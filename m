Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbZHYIIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbZHYIIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbZHYIIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:08:36 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54296 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbZHYIIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:08:35 -0400
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
 memory  (f6f6e1a4), by kmemleak's scan_block()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Catalin Marinas <catalin.marinas@arm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0908250104y6e877545y485a2104c2b97cfd@mail.gmail.com>
References: <20090825071959.GA25877@elte.hu>
	 <19f34abd0908250104y6e877545y485a2104c2b97cfd@mail.gmail.com>
Date: Tue, 25 Aug 2009 11:08:36 +0300
Message-Id: <1251187716.7261.2.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

On Tue, 2009-08-25 at 10:04 +0200, Vegard Nossum wrote:
> 2009/8/25 Ingo Molnar <mingo@elte.hu>:
> >
> > FYI, -tip testing triggered the following kmemcheck warning in
> > kmemleak:
> >
> > PM: Adding info for No Bus:vcsa7
> > WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f6f6e1a4)
> > d873f9f600000000c42ae4c1005c87f70000000070665f666978656400000000
> >  i i i i u u u u i i i i i i i i i i i i i i i i i i i i i u u u
> >         ^
> >
> > Pid: 3091, comm: kmemleak Not tainted (2.6.31-rc7-tip #1303) P4DC6
> > EIP: 0060:[<c110301f>] EFLAGS: 00010006 CPU: 0
> > EIP is at scan_block+0x3f/0xe0
> > EAX: f40bd700 EBX: f40bd780 ECX: f16b46c0 EDX: 00000001
> > ESI: f6f6e1a4 EDI: 00000000 EBP: f10f3f4c ESP: c2605fcc
> >  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> > CR0: 8005003b CR2: e89a4844 CR3: 30ff1000 CR4: 000006f0
> > DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> > DR6: ffff4ff0 DR7: 00000400
> >  [<c110313c>] scan_object+0x7c/0xf0
> >  [<c1103389>] kmemleak_scan+0x1d9/0x400
> >  [<c1103a3c>] kmemleak_scan_thread+0x4c/0xb0
> >  [<c10819d4>] kthread+0x74/0x80
> >  [<c10257db>] kernel_thread_helper+0x7/0x3c
> >  [<ffffffff>] 0xffffffff
> > kmemleak: 515 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> > kmemleak: 42 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> >
> > config attached. (And this is the first documented case of a kmem
> > civil war i guess ;-)
> 
> Already the patch to make kmemcheck and kmemleak mutually exclusive is
> underway. It is not surprising that kmemleak is scanning uninitialized
> memory. But if you say that you have tried it before, it is strange
> that it didn't appear until now.

Why isn't it surprising? Yes, it's non-fatal for kmemleak to scan
uninitialized memory but we could be looking at non-initialized struct
member that's a bug waiting to happen elsewhere in the code (that
doesn't trigger often).

			Pekka

