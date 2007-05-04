Return-Path: <linux-kernel-owner+w=401wt.eu-S1767709AbXEDIJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767709AbXEDIJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767715AbXEDIJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:09:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:12493 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767712AbXEDIJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:09:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZZYijeFtDmiVEhStGO813cGO/IoERx3e4ktv8dZEOJiDqkJOR51bKaKU0yzSWCBsGl7R4CiXPC1p9hlRk509V5LuvsUF4I8s6gF0yf0Hand5Eb1viMfFTfIk9S49hZXmSM1eiIxsB0OE4sDNIxly4OYfnPEFJkTFO6L3cBIW5E0=
Message-ID: <a781481a0705040109r45cbf472i4094dd2ebf7841e8@mail.gmail.com>
Date: Fri, 4 May 2007 13:39:20 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Richard Purdie" <rpurdie@openedhand.com>
Subject: Re: [PATCH 5/5] crypto: Add LZO compression support to the crypto interface
Cc: LKML <linux-kernel@vger.kernel.org>,
       "David Woodhouse" <dwmw2@infradead.org>, herbert@gondor.apana.org.au,
       linux-mtd <linux-mtd@lists.infradead.org>, linux-crypto@vger.kernel.org
In-Reply-To: <1178030843.5883.57.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1178030843.5883.57.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Richard Purdie <rpurdie@openedhand.com> wrote:
> +static int lzo_init(struct crypto_tfm *tfm)
> +{
> +       struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
> +
> +       ctx->lzo_mem = vmalloc(LZO1X_MEM_COMPRESS);
> +
> +       if (!ctx->lzo_mem) {
> +               vfree(ctx->lzo_mem);

Heh. What's (why's) this? You _can_ {k, v}free NULL but doing so after
explicitly checking for it is ... ... insane!

> +               return -ENOMEM;

Yeah. Just return -ENOMEM; and be done with it.
