Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbYI1QnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbYI1QnN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 12:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYI1Qm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 12:42:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40355 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbYI1Qm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 12:42:58 -0400
To: Pardo <pardo@google.com>
Cc: linux-kernel@vger.kernel.org, mbligh@google.com, briangrant@google.com,
       odo@google.com, nil@google.com, jyasskin@google.com
Subject: Re: Faster getcpu() and sched_getcpu()
From: Andi Kleen <andi@firstfloor.org>
References: <af8810200809111648n55e05ac9g286fcd498690432f@mail.gmail.com>
	<af8810200809231209w7428347neb88094e543a048f@mail.gmail.com>
Date: Sun, 28 Sep 2008 18:42:54 +0200
In-Reply-To: <af8810200809231209w7428347neb88094e543a048f@mail.gmail.com> (pardo@google.com's message of "Tue, 23 Sep 2008 12:09:14 -0700")
Message-ID: <87wsgwp6gh.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pardo <pardo@google.com> writes:
>
> ANALYSIS AND SUGGESTIONS
>
> Caching is currently disabled for 2.6.26/arch/x86/vdso/vgetcpu.c.
> getcpu()/sched_getcpu() performance is most important when they are
> used very frequently, in which case the jiffy-based cache is
> effective.  Conversely, when calls are infrequent, cache miss overhead
> is small.  Recommendation: caching should be enabled (probably for all
> architectures, not just x86-64).

Without a vsyscall the cache probably doesn't make too much sense
because once you're in the kernel reading the real CPU number is really
cheap.

I agree with you that the cache should be enabled on all vDSO implementations
(that is what my original code did)

Also the TSCP version could probably go.

I'm still not sure why you say no redzone is that expensive? Do you
have numbers?  I know it's a few instructions, but it shouldn't 
be that expensive.

> A specialized version of the VDSO code for sched_getcpu() is
> substantially faster than calling getcpu().  

Yes, unfortunately glibc didn't chose the same interface as the kernel
for this. I still don't know why. But now since we're in this mess
specializing for the glibc implementation is probably a good idea.
Or just add getcpu() to glibc :)

-Andi

-- 
ak@linux.intel.com
