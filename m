Return-Path: <linux-kernel-owner+w=401wt.eu-S972343AbXHMM7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972343AbXHMM7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968774AbXHMIA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 04:00:57 -0400
Received: from il.qumranet.com ([82.166.9.18]:33347 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968773AbXHMIAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 04:00:55 -0400
Message-ID: <46C00FC1.1070306@qumranet.com>
Date: Mon, 13 Aug 2007 11:01:05 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [kvm-devel] [PATCH 0/2][KVM] guest time accounting
References: <46BC8B39.6050202@bull.net>
In-Reply-To: <46BC8B39.6050202@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
> The aim of these two patches is to measure the CPU time used by a virtual
> machine. All comments are welcome... I'm not sure it's the good way to do that.
>
> [PATCH 1/2] introduce a new field, "guest", in cpustat to store the time used by
> the CPU to run virtual CPU. Modify /proc/stat to display this new field.
>
> [PATCH 2/2] modify account_system_time() to add cputime to cpustat->guest if we
> are running a VCPU. We add this cputime to  cpustat->user instead of
> cpustat->system because this part of KVM code is in fact user code although it
> is executed in the kernel. We duplicate VCPU time between guest and user to
> allow an unmodified "top(1)" to display correct value. A modified "top(1)" is
> able to display good cpu user time and cpu guest time by subtracting cpu guest
> time from cpu user time.
>   

[copying Ingo and Rusty]

The patches look good.  A couple of comments:

- perhaps the new fields should be guarded by a #ifdef CONFIG_HYPERVISOR 
(selected by CONFIG_KVM)?  that way the (minor) additional overhead is 
only incurred if it can possibly be used.  I imagine that our canine 
cousin will want to use this as well.

- I think that there is per-task accounting of user time and system 
time; that should be extended as well.



-- 
error compiling committee.c: too many arguments to function

