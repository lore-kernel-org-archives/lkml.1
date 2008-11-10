Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbYKJKDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbYKJKDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 05:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbYKJKDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 05:03:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60597 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625AbYKJKDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 05:03:41 -0500
Date: Mon, 10 Nov 2008 11:03:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] sparse_irq aka dyn_irq
Message-ID: <20081110100329.GA19970@elte.hu>
References: <4913F9AA.80500@kernel.org> <20081107084240.GG4435@elte.hu> <491434FB.2050904@kernel.org> <20081107124957.GA21709@elte.hu> <49168BD3.5010204@kernel.org> <20081109073813.GA17180@elte.hu> <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com> <20081110094033.GL22392@elte.hu> <20081110015511.453a801e.akpm@linux-foundation.org> <4918065A.6050402@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4918065A.6050402@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Andrew Morton wrote:
> > On Mon, 10 Nov 2008 10:40:33 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> > 
> >>>>> @@ -987,6 +988,8 @@ void __init mem_init(void)
> >>>>>
> >>>>>       set_highmem_pages_init();
> >>>>>
> >>>>> +     after_bootmem = 1;
> >>>> this hack can go away once we have a proper percpu_alloc() that can be
> >>>> used early enough.
> >>> where is that fancy patch? current percpu_alloc(), will keep big 
> >>> pointer in array..., instead of put that pointer in percpu_area
> >>>
> >>> 64bit has that after_bootmem already.
> >> or at least introduce a "bootmem agnostic" allocator instead of 
> >> open-coding the after_bootmem flag.
> >>
> >> Something like:
> >>
> >>   early_kzalloc()
> >>
> >> ?
> >>
> >> Andrew, any preferences?
> > 
> > My mind reading ain't what it was, and this after_bootmem flag is
> > write-only in this patch.
> > 
> > So what's all this about?
> 
> if i use alloc_bootmem to get some memory, and later after_bootmem, 
> can I use kfree to free it?

hm, no. If we used alloc_bootmem(), then we must not free it after 
after_bootmem has been set.

	Ingo
