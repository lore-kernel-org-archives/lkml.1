Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbYAYPyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbYAYPyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 10:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYAYPy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 10:54:29 -0500
Received: from gw.goop.org ([64.81.55.164]:34877 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158AbYAYPy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 10:54:28 -0500
Message-ID: <479A0632.9090205@goop.org>
Date: Fri, 25 Jan 2008 07:54:26 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH UPDATE] x86: ignore spurious faults
References: <4797D64D.1060105@goop.org> <1201133916.16972.124.camel@brick> <4797DBA0.5020909@goop.org> <20080125153032.GE11846@elte.hu>
In-Reply-To: <20080125153032.GE11846@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> thanks, applied.
>
> it would be nice to expose this ability of the architecture to the core 
> Linux kernel mprotect code as well, and let it skip on a TLB flush when 
> doing a RO->RW transition.

The usermode fault handler already effectively does this; this patch 
just does it for kernel mode as well.  I don't know if mprotect takes 
advantage of this.

>  It could speed up valgrind and the other 
> mprotect() users i guess? [and UML too perhaps]
>   

Not valgrind (it doesn't rely on mmap protections), but electric fence 
perhaps.

    J

