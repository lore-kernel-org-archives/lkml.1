Return-Path: <linux-kernel-owner+w=401wt.eu-S932785AbXD2IIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785AbXD2IIE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 04:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932796AbXD2IHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 04:07:41 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2497 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932785AbXD2IGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:06:47 -0400
Date: Sun, 29 Apr 2007 18:05:15 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: Re: [PATCH 22/25] xen: xen-netfront: use skb.cb for storing private data
Message-ID: <20070429080515.GA16942@gondor.apana.org.au>
References: <20070423215638.563901986@goop.org> <20070423215713.550883195@goop.org> <20070424014528.GA27789@gondor.apana.org.au> <462D88EF.9030007@goop.org> <20070424055731.GA30018@gondor.apana.org.au> <46327706.80508@goop.org> <20070427223742.GA2742@gondor.apana.org.au> <463286D9.7090609@goop.org> <20070428062839.GA6535@gondor.apana.org.au> <46344CA5.6000900@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46344CA5.6000900@goop.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 12:43:33AM -0700, Jeremy Fitzhardinge wrote:
> Herbert Xu wrote:
> > BTW, the version I posted to you is missing the following line.
> >   
> > --- linux-2.6.20.i386/drivers/xen/core/skbuff.c	2007-04-28 15:30:16.000000000 +1000
> > +++ build-2.6.20.i386/drivers/xen/core/skbuff.c	2007-04-28 15:30:52.000000000 +1000
> > @@ -89,6 +89,7 @@
> >  	skb->h.raw = (unsigned char *)skb->nh.iph + 4*skb->nh.iph->ihl;
> >  	if (skb->h.raw >= skb->tail)
> >  		goto out;
> > +	skb->csum_start = skb->h.raw - skb->head;
> >  	switch (skb->nh.iph->protocol) {
> >  	case IPPROTO_TCP:
> >  		skb->csum_offset = offsetof(struct tcphdr, check);
> >   
> 
> drivers/xen/core/skbuff.c?  What's that?

It's part of the skb_checksum_setup function which we still need
for this because the current netback protocol doesn't pass the
csum_start and csum_offset values along.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
