Return-Path: <linux-kernel-owner+w=401wt.eu-S933996AbXCKStZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996AbXCKStZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 14:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933997AbXCKStZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 14:49:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36202 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933996AbXCKStR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 14:49:17 -0400
Date: Sun, 11 Mar 2007 19:48:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland Dreier <roland.list@gmail.com>,
       Tziporet Koren <tziporet@mellanox.co.il>,
       Roland Dreier <rdreier@cisco.com>, general@lists.openfabrics.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep question (was Re: IPoIB caused a kernel: BUG: softlockup detected on CPU#0!)
Message-ID: <20070311184819.GA2567@elte.hu>
References: <45E552FC.4040305@mellanox.co.il> <f8ca0a150703030937u61bcd9aj200415b76c00d151@mail.gmail.com> <20070311135051.GA31985@mellanox.co.il> <1173626719.5182.10.camel@lappy> <20070311161231.GC13817@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311161231.GC13817@mellanox.co.il>
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

> > So either there are other sites that instanciate those objects and
> > forget about the lock init, or the object is corrupted (use after free?)
> 
> OK, thanks for the hint. So I added this:

> And sure enough it triggers:
> 
> [  858.503010] ipoib_neigh_destructor lock c0687880 wrong type 772 !!!!!!!!!!

could you turn on CONFIG_SLAB_DEBUG as well?

that should catch certain types of use-after-free accesses, and lockdep 
will also warn if a still locked object is freed.

	Ingo
