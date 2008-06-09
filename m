Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbYFINf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbYFINf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 09:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYFINfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 09:35:20 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41514 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbYFINfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 09:35:19 -0400
Date: Mon, 9 Jun 2008 16:34:26 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay.sievers@vrfy.org>,
       Neil Brown <neilb@suse.de>, Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: Re: [bug, 2.6.26-rc4/rc5] sporadic bootup crashes in
	blk_lookup_devt()/prepare_namespace()
Message-ID: <20080609133426.GB20194@cs181133002.pp.htv.fi>
References: <20080609080312.GA32458@elte.hu> <20080609020623.b6727f2b.akpm@linux-foundation.org> <19f34abd0806090209l541d93c6jaba2704314b34418@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <19f34abd0806090209l541d93c6jaba2704314b34418@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 11:09:07AM +0200, Vegard Nossum wrote:
> On Mon, Jun 9, 2008 at 11:06 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Mon, 9 Jun 2008 10:03:12 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> -tip testing has started triggering a new type of sporadic bootup crash
> >> a few days ago. Find below a collection of 14 crashes i've managed to
> >> capture so far, which are all similar to this crash pattern:
> >>
> >>  BUG: unable to handle kernel paging request at ffff81003b984fb8
> >>  IP: [<ffffffff803fafd4>] blk_lookup_devt+0x42/0xa0
> >>  PGD 8063 PUD 9063 PMD 3be2d163 PTE 800000003b984160
> >>  Oops: 0000 [1] SMP DEBUG_PAGEALLOC
> >>
> >>  Call Trace:
> >>   [<ffffffff80bac17b>] ? ip_auto_config+0x0/0xd94
> >>   [<ffffffff80209259>] name_to_dev_t+0x145/0xeec
> >>   [<ffffffff803ff2be>] ? __next_cpu_nr+0x22/0x2b
> >>   [<ffffffff80b7f372>] prepare_namespace+0x91/0x14c
> >>   [<ffffffff80b7eb70>] kernel_init+0x2fe/0x314
> >>   [<ffffffff80251f3d>] ? trace_hardirqs_on_caller+0xca/0xee
> >>   [<ffffffff80741bbb>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> >>   [<ffffffff80251f3d>] ? trace_hardirqs_on_caller+0xca/0xee
> >>   [<ffffffff8020d3f8>] child_rip+0xa/0x12
> >>   [<ffffffff8020c90c>] ? restore_args+0x0/0x30
> >>   [<ffffffff8025068d>] ? trace_hardirqs_off+0xd/0xf
> >>   [<ffffffff80b7e872>] ? kernel_init+0x0/0x314
> >>   [<ffffffff8020d3ee>] ? child_rip+0x0/0x12
> >
> > Did you work out where it's dying?  Deref of `dev' I assume?
> 
>                         struct gendisk *disk = dev_to_disk(dev);

Mariusz already ran into this.

Neil already did some analysis of what could cause such problems [1],
but since Mariusz was no longer able to reproduce it with more recent 
kernels it became somehow forgotten.

Oh, and commit 30f2f0eb4bd2c43d10a8b0d872c6e5ad8f31c9a0 is currently 
sent for -stable review. I'll send an email that it shouldn't be merged 
not.

> Vegard

cu
Adrian

[1] http://lkml.org/lkml/2008/5/25/257

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

