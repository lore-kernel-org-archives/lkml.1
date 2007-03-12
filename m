Return-Path: <linux-kernel-owner+w=401wt.eu-S965872AbXCLNwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965872AbXCLNwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965870AbXCLNwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:52:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48552 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965862AbXCLNw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:52:26 -0400
Date: Mon, 12 Mar 2007 14:51:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland Dreier <roland.list@gmail.com>,
       Tziporet Koren <tziporet@mellanox.co.il>,
       Roland Dreier <rdreier@cisco.com>, general@lists.openfabrics.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep question (was Re: IPoIB caused a kernel: BUG: softlockup detected on CPU#0!)
Message-ID: <20070312135112.GA18158@elte.hu>
References: <45E552FC.4040305@mellanox.co.il> <f8ca0a150703030937u61bcd9aj200415b76c00d151@mail.gmail.com> <20070311135051.GA31985@mellanox.co.il> <1173626719.5182.10.camel@lappy> <20070311161231.GC13817@mellanox.co.il> <20070311184819.GA2567@elte.hu> <20070312132826.GB20549@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312132826.GB20549@mellanox.co.il>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael S. Tsirkin <mst@mellanox.co.il> wrote:

> > could you turn on CONFIG_SLAB_DEBUG as well?
> > 
> > that should catch certain types of use-after-free accesses, and 
> > lockdep will also warn if a still locked object is freed.
> 
> Hmm, no, this does not look like use-after-free. I enabled 
> CONFIG_SLAB_DEBUG, and I still see the same message, so the memory was 
> not overwritten by slab debugger.

that's still not conclusive - the memory might not have been allocated 
by slab again to detect it. Your magic-number check definitely shows 
some sort of corruption going on, right?

	Ingo
