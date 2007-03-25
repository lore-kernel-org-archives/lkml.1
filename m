Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbXCYMnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbXCYMnD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 08:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbXCYMnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 08:43:03 -0400
Received: from mail24.syd.optusnet.com.au ([211.29.133.165]:58995 "EHLO
	mail24.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753507AbXCYMnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 08:43:01 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] sched: accurate user accounting
Date: Sun, 25 Mar 2007 22:41:54 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, malc <av1474@comtv.ru>,
       Ingo Molnar <mingo@elte.hu>, zwane@infradead.org,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200703251159.03616.kernel@kolivas.org> <200703252202.48022.kernel@kolivas.org> <200703250832.36818.gene.heskett@gmail.com>
In-Reply-To: <200703250832.36818.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703252241.55431.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 March 2007 22:32, Gene Heskett wrote:
> On Sunday 25 March 2007, Con Kolivas wrote:
> >On Sunday 25 March 2007 21:46, Con Kolivas wrote:
> >> On Sunday 25 March 2007 21:34, malc wrote:
> >> > On Sun, 25 Mar 2007, Ingo Molnar wrote:
> >> > > * Con Kolivas <kernel@kolivas.org> wrote:
> >> > >> For an rsdl 0.33 patched kernel. Comments? Overhead worth it?
> >> > >
> >> > > we want to do this - and we should do this to the vanilla
> >> > > scheduler first and check the results. I've back-merged the patch
> >> > > to before RSDL and have tested it - find the patch below. Vale,
> >> > > could you try this patch against a 2.6.21-rc4-ish kernel and
> >> > > re-test your testcase?
> >> >
> >> > [..snip..]
> >> >
> >> > Compilation failed with:
> >> > kernel/built-in.o(.sched.text+0x564): more undefined references to
> >> > `__udivdi3' follow
> >> >
> >> > $ gcc --version | head -1
> >> > gcc (GCC) 3.4.6
> >> >
> >> > $ cat /proc/cpuinfo | grep cpu
> >> > cpu             : 7447A, altivec supported
> >> >
> >> > Can't say i really understand why 64bit arithmetics suddenly became
> >> > an issue here.
> >>
> >> Probably due to use of:
> >>
> >> #define NS_TO_JIFFIES(TIME)	((TIME) / (1000000000 / HZ))
> >> #define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))
> >>
> >> Excuse our 64bit world while we strive to correct our 32bit blindness
> >> and fix this bug.
> >
> >Please try this (akpm please don't include till we confirm it builds on
> > ppc, sorry). For 2.6.21-rc4
> >
> >---
> >Currently we only do cpu accounting to userspace based on what is
> >actually happening precisely on each tick. The accuracy of that
> >accounting gets progressively worse the lower HZ is. As we already keep
> >accounting of nanosecond resolution we can accurately track user cpu,
> >nice cpu and idle cpu if we move the accounting to update_cpu_clock with
> >a nanosecond cpu_usage_stat entry. This increases overhead slightly but
> >avoids the problem of tick aliasing errors making accounting unreliable.

>
> I'm playing again because the final 2.6.20.4 does NOT break amanda, where
> 2.6.20.4-rc1 did.

Yes only the original version I posted on this email thread was for an RSDL 
0.33 patched kernel. That original patch should build fine on i386 and x86_64 
(where I tried it). This version I sent out following Ingo's lead has 
2.6.21-rc4 in mind (without rsdl).

-- 
-ck
