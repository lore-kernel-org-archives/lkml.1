Return-Path: <linux-kernel-owner+w=401wt.eu-S1423188AbXDXWiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423188AbXDXWiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423195AbXDXWiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:38:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423188AbXDXWh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:37:59 -0400
Message-ID: <462E86BF.7010402@redhat.com>
Date: Tue, 24 Apr 2007 18:37:51 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: LAPLACE Cyprien <cyprien.laplace@trango-systems.com>
CC: virtualization@lists.linux-foundation.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SMP lockup in virtualized environment
References: <462E4223.1050109@trango-systems.com>
In-Reply-To: <462E4223.1050109@trango-systems.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

LAPLACE Cyprien wrote:
> An example: in kernel/pid.c:alloc_pid(), if one of the guest CPUs is
> descheduled when holding the pidmap_lock, what happens to the other
> guest CPUs who want to alloc/free pids ? Are they blocked too ?

Yup.  This is where it's really nice to have directed yields, where you tell the 
hypervisor to give your physical CPU time to the vcpu that's holding the lock 
you're blocking on.  I know s390 can do this.  Perhaps it's something worth 
generalizing in paravirt_ops?

	-- Chris
