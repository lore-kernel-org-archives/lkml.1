Return-Path: <linux-kernel-owner+w=401wt.eu-S935279AbZAOXfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935279AbZAOXfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763131AbZAOXeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:34:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58127
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752273AbZAOXes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:34:48 -0500
Date: Thu, 15 Jan 2009 15:34:49 -0800 (PST)
Message-Id: <20090115.153449.204259387.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: w@1wt.eu, jarkao2@gmail.com, zbr@ioremap.net, dada1@cosmosbay.com,
       ben@zeus.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090115233205.GA8474@gondor.apana.org.au>
References: <20090115231934.GA8328@gondor.apana.org.au>
	<20090115.152608.89323697.davem@davemloft.net>
	<20090115233205.GA8474@gondor.apana.org.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 16 Jan 2009 10:32:05 +1100

> On Thu, Jan 15, 2009 at 03:26:08PM -0800, David Miller wrote:
> > +static inline struct page *linear_to_page(struct page *page, unsigned int len,
> > +					  unsigned int offset)
> > +{
> > +	struct page *p = alloc_pages(GFP_KERNEL, 0);
> > +
> > +	if (!p)
> > +		return NULL;
> > +	memcpy(page_address(p) + offset, page_address(page) + offset, len);
> 
> This won't work very well if skb->head is longer than a page.
> 
> We'll need to divide it up into individual pages.

Oh yes the same bug I pointed out the other day.

But Willy can test this patch as-is, since he is not using
jumbo frames in linear SKBs.
