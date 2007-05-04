Return-Path: <linux-kernel-owner+w=401wt.eu-S1422797AbXEDIjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422797AbXEDIjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031356AbXEDIjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:39:43 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:42286 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840AbXEDIjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:39:42 -0400
Subject: Re: [PATCH 5/5] crypto: Add LZO compression support to the crypto
	interface
From: Richard Purdie <rpurdie@openedhand.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       herbert@gondor.apana.org.au, linux-mtd <linux-mtd@lists.infradead.org>,
       linux-crypto@vger.kernel.org
In-Reply-To: <a781481a0705040109r45cbf472i4094dd2ebf7841e8@mail.gmail.com>
References: <1178030843.5883.57.camel@localhost.localdomain>
	 <a781481a0705040109r45cbf472i4094dd2ebf7841e8@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 04 May 2007 09:39:23 +0100
Message-Id: <1178267963.5839.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 13:39 +0530, Satyam Sharma wrote:
> On 5/1/07, Richard Purdie <rpurdie@openedhand.com> wrote:
> > +static int lzo_init(struct crypto_tfm *tfm)
> > +{
> > +       struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
> > +
> > +       ctx->lzo_mem = vmalloc(LZO1X_MEM_COMPRESS);
> > +
> > +       if (!ctx->lzo_mem) {
> > +               vfree(ctx->lzo_mem);
> 
> Heh. What's (why's) this? You _can_ {k, v}free NULL but doing so after
> explicitly checking for it is ... ... insane!

True, there used to be two buffers allocated there and I've missed a
sensible cleanup when I removed one. I'll fix it, thanks.

Cheers,

Richard


