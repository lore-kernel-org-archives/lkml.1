Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbXELKRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbXELKRQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 06:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbXELKRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 06:17:06 -0400
Received: from mailgate2.urz.uni-halle.de ([141.48.3.8]:35438 "EHLO
	mailgate2.urz.uni-halle.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756015AbXELKRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 06:17:04 -0400
Date: Sat, 12 May 2007 12:16:32 +0200
From: Bert Wesarg <wesarg@informatik.uni-halle.de>
Subject: Re: getcpu after sched_setaffinity
In-reply-to: <46439BBA.2070705@redhat.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andi Kleen <ak@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <46459400.1000900@informatik.uni-halle.de>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.3)
 Gecko/20070326 Thunderbird/2.0.0.0 Mnenhy/0.7.5.0
X-Enigmail-Version: 0.95.0
References: <46439BBA.2070705@redhat.com>
X-Scan-Signature: 3ac3d0bd6dbe02dd5a6d2e1f14992302
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(Please CC me, thank you)

Ulrich Drepper wrote:
> The attached test program fails on a dual core (and probably SMP) 
> machine on x86-64.  Depending on where the thread starts, in one of the 
> iterations the sched_setffinity() call succeeds but then sched_getcpu() 
> fails to report the correct CPU.
> 
> In set_cpus_allowed migrate_task() is called if the new CPU set does not 
> include the current CPU.  I hope that migrate_task() also works for 
> p==current.
> 
> This leaves the x86-64 vgetcpu() implementation as the weak point.  Is 
> the caching causing problems?  Should migrate_task() make sure the cache 
> is reset?
> 
> You need a very recent glibc to compile (glibc-2.5.90-22 in rawhide). 
> If this is not available replace the sched_getcpu() call.  But make sure 
> you pass a pointer to a cache.
> 
> 
A question not related to this problem, but may I ask why the libc don't
use[1] the linux/getcpu.h header to get the opaque struct vgetcpu_cache?

Thank You

Bert Wesarg

[1]: http://sourceware.org/ml/glibc-cvs/2007-q2/msg00098.html
