Return-Path: <linux-kernel-owner+w=401wt.eu-S965576AbXCLN2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965576AbXCLN2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965578AbXCLN2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:28:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:58361 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965576AbXCLN2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:28:54 -0400
Date: Mon, 12 Mar 2007 15:29:30 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland Dreier <roland.list@gmail.com>,
       Tziporet Koren <tziporet@mellanox.co.il>,
       Roland Dreier <rdreier@cisco.com>, general@lists.openfabrics.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep question (was Re: IPoIB caused a kernel: BUG: softlockup
	detected on CPU#0!)
Message-ID: <20070312132826.GB20549@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <45E552FC.4040305@mellanox.co.il>
	<f8ca0a150703030937u61bcd9aj200415b76c00d151@mail.gmail.com>
	<20070311135051.GA31985@mellanox.co.il>
	<1173626719.5182.10.camel@lappy>
	<20070311161231.GC13817@mellanox.co.il>
	<20070311184819.GA2567@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311184819.GA2567@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Ingo Molnar <mingo@elte.hu>:
> Subject: Re: lockdep question (was Re: IPoIB caused a kernel: BUG: softlockup detected on CPU#0!)
> 
> 
> * Michael S. Tsirkin <mst@mellanox.co.il> wrote:
> 
> > > So either there are other sites that instanciate those objects and
> > > forget about the lock init, or the object is corrupted (use after free?)
> > 
> > OK, thanks for the hint. So I added this:
> 
> > And sure enough it triggers:
> > 
> > [  858.503010] ipoib_neigh_destructor lock c0687880 wrong type 772 !!!!!!!!!!
> 
> could you turn on CONFIG_SLAB_DEBUG as well?
> 
> that should catch certain types of use-after-free accesses, and lockdep 
> will also warn if a still locked object is freed.

Hmm, no, this does not look like use-after-free.
I enabled CONFIG_SLAB_DEBUG, and I still see the same message, so
the memory was not overwritten by slab debugger.


-- 
MST
