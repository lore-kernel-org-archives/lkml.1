Return-Path: <linux-kernel-owner+w=401wt.eu-S1759549AbXKNB6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549AbXKNB6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbXKNB6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:58:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32789
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755158AbXKNB6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:58:04 -0500
Date: Tue, 13 Nov 2007 17:58:04 -0800 (PST)
Message-Id: <20071113.175804.151698768.davem@davemloft.net>
To: nickpiggin@yahoo.com.au
Cc: clameter@sgi.com, netdev@vger.kernel.org, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2: Network commit causes SLUB performance regression
 with tbench
From: David Miller <davem@davemloft.net>
In-Reply-To: <200711132241.59074.nickpiggin@yahoo.com.au>
References: <200711101229.35822.nickpiggin@yahoo.com.au>
	<Pine.LNX.4.64.0711121144001.26936@schroedinger.engr.sgi.com>
	<200711132241.59074.nickpiggin@yahoo.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Tue, 13 Nov 2007 22:41:58 +1100

> On Tuesday 13 November 2007 06:44, Christoph Lameter wrote:
> > On Sat, 10 Nov 2007, Nick Piggin wrote:
> > > BTW. your size-2048 kmalloc cache is order-1 in the default setup,
> > > wheras kmalloc(1024) or kmalloc(4096) will be order-0 allocations. And
> > > SLAB also uses order-0 for size-2048. It would be nice if SLUB did the
> > > same...
> >
> > You can try to see the effect that order 0 would have by booting with
> >
> > slub_max_order=0
> 
> Yeah, that didn't help much, but in general I think it would give
> more consistent and reliable behaviour from slub.

Just a note that I'm not ignoring this issue, I just don't have time
to get to it yet.

I suspect the issue is about having a huge skb->data linear area for
TCP sends over loopback.  We're likely getting a much smaller
skb->data linear data area after the patch in question, the rest using
the sk_buff scatterlist pages which are a little bit more expensive to
process.

