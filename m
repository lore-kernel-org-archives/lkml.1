Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbXD1G3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbXD1G3F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 02:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbXD1G3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 02:29:05 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2060 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754747AbXD1G3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 02:29:03 -0400
Date: Sat, 28 Apr 2007 16:28:39 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: Re: [PATCH 22/25] xen: xen-netfront: use skb.cb for storing private data
Message-ID: <20070428062839.GA6535@gondor.apana.org.au>
References: <20070423215638.563901986@goop.org> <20070423215713.550883195@goop.org> <20070424014528.GA27789@gondor.apana.org.au> <462D88EF.9030007@goop.org> <20070424055731.GA30018@gondor.apana.org.au> <46327706.80508@goop.org> <20070427223742.GA2742@gondor.apana.org.au> <463286D9.7090609@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463286D9.7090609@goop.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 04:27:21PM -0700, Jeremy Fitzhardinge wrote:
> Herbert Xu wrote:
> > They can be applied separately so you don't need the dom0 part for your
> > tree.
> 
> Great, thanks.

BTW, the version I posted to you is missing the following line.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
--- linux-2.6.20.i386/drivers/xen/core/skbuff.c	2007-04-28 15:30:16.000000000 +1000
+++ build-2.6.20.i386/drivers/xen/core/skbuff.c	2007-04-28 15:30:52.000000000 +1000
@@ -89,6 +89,7 @@
 	skb->h.raw = (unsigned char *)skb->nh.iph + 4*skb->nh.iph->ihl;
 	if (skb->h.raw >= skb->tail)
 		goto out;
+	skb->csum_start = skb->h.raw - skb->head;
 	switch (skb->nh.iph->protocol) {
 	case IPPROTO_TCP:
 		skb->csum_offset = offsetof(struct tcphdr, check);
