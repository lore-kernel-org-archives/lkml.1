Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712AbZHYIce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbZHYIce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbZHYIcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:32:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56377 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbZHYIcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:32:31 -0400
Date: Tue, 25 Aug 2009 10:32:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
	memory (f6f6e1a4), by kmemleak's scan_block()
Message-ID: <20090825083222.GC17692@elte.hu>
References: <20090825071959.GA25877@elte.hu> <19f34abd0908250104y6e877545y485a2104c2b97cfd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0908250104y6e877545y485a2104c2b97cfd@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -0.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.1 required=5.9 tests=BAYES_00,WEIRD_QUOTING autolearn=no SpamAssassin version=3.2.5
	1.4 WEIRD_QUOTING          BODY: Weird repeated double-quotation marks
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> 2009/8/25 Ingo Molnar <mingo@elte.hu>:
> >
> > FYI, -tip testing triggered the following kmemcheck warning in
> > kmemleak:
> >
> > PM: Adding info for No Bus:vcsa7
> > WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f6f6e1a4)
> > d873f9f600000000c42ae4c1005c87f70000000070665f666978656400000000
> > ??i i i i u u u u i i i i i i i i i i i i i i i i i i i i i u u u
> > ?? ?? ?? ?? ^
> >
> > Pid: 3091, comm: kmemleak Not tainted (2.6.31-rc7-tip #1303) P4DC6
> > EIP: 0060:[<c110301f>] EFLAGS: 00010006 CPU: 0
> > EIP is at scan_block+0x3f/0xe0
> > EAX: f40bd700 EBX: f40bd780 ECX: f16b46c0 EDX: 00000001
> > ESI: f6f6e1a4 EDI: 00000000 EBP: f10f3f4c ESP: c2605fcc
> > ??DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> > CR0: 8005003b CR2: e89a4844 CR3: 30ff1000 CR4: 000006f0
> > DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> > DR6: ffff4ff0 DR7: 00000400
> > ??[<c110313c>] scan_object+0x7c/0xf0
> > ??[<c1103389>] kmemleak_scan+0x1d9/0x400
> > ??[<c1103a3c>] kmemleak_scan_thread+0x4c/0xb0
> > ??[<c10819d4>] kthread+0x74/0x80
> > ??[<c10257db>] kernel_thread_helper+0x7/0x3c
> > ??[<ffffffff>] 0xffffffff
> > kmemleak: 515 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> > kmemleak: 42 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> >
> > config attached. (And this is the first documented case of a kmem
> > civil war i guess ;-)
> 
> Already the patch to make kmemcheck and kmemleak mutually 
> exclusive is underway. It is not surprising that kmemleak is 
> scanning uninitialized memory. But if you say that you have tried 
> it before, it is strange that it didn't appear until now.

i had kmemleak off for long periods of time in -tip, it stabilized 
recently:

earth4:~/tip> gll linus..out-of-tree | grep kmeml
d4ece0f: Revert "Revert "Revert "Revert "Revert "kmemleak: Disable it for now"""""
3aa8916: kmemleak: Ignore the aperture memory hole on x86_64
0f97c9f: Revert "kmemleak: Ignore the aperture memory hole on x86_64"
eedff6e: Revert "Revert "Revert "Revert "kmemleak: Disable it for now""""
a1bf608: kmemleak: Ignore the aperture memory hole on x86_64
74a9357: kmemleak: Allow rescheduling during an object scanning
a047bfe: Revert "kmemleak: Allow rescheduling during an object scanning"
47dc143: Revert "Revert "Revert "kmemleak: Disable it for now"""
4a3f3f7: Revert "Revert "kmemleak: Disable it for now""
39ac9ee: kmemleak: Allow rescheduling during an object scanning
085fac5: Revert "kmemleak: Disable it for now"
da0ce63: kmemleak: Disable it for now
f6a5295: kmemleak: Mark nice +10
5ba1a81: kmemleak: Fix scheduling-while-atomic bug

plus not all of my systems have kmemcheck testing enabled. These two 
factors would explain the latency of it i think.

> In any case, I don't think it is very productive to run them both 
> at the same time, simply because kmemcheck slows every memory 
> access down so much and scanning memory doesn't exactly help that. 
> It _could_ be useful to have them compiled into the same kernel, 
> though, e.g. a distro "-debug" kernel.
> 
> Maybe you can just add the "depends on !KMEMLEAK" to 
> CONFIG_KMEMCHECK in tip/out-of-tree for now?

i think it would be far more intelligent to annotate those accesses 
by kmemleak as 'trust me, dont check'. Willing to test such a patch.

	Ingo
