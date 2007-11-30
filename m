Return-Path: <linux-kernel-owner+w=401wt.eu-S934559AbXK3BUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559AbXK3BUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 20:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933072AbXK3BUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 20:20:38 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:54774 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827AbXK3BUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 20:20:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OKnZjarCkjoes2sxi35+JYeJT/tJYztN1/DQ9UQQFYhc38HXRF0IEpaYEoHgubXOoppmgky9RfPq3koTL2O916oTLEIAGqFff+wDsIDizmdHj3tNQhS7nw6CTLyxSAM17RcVlQ/61Cb5j4KdBypfGI95tPMh+8GoGE7bZSOhEKU=
Message-ID: <91b13c310711291720p1dde31b9k1f974025b01703cf@mail.gmail.com>
Date: Fri, 30 Nov 2007 09:20:34 +0800
From: "rae l" <crquan@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [RESEND] crypto test: use print_hex_dump from kernel.h instead
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Knutsson" <ricknu-0@student.ltu.se>,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       dengxw@163.com, "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Joe Perches" <joe@perches.com>
In-Reply-To: <20071129111324.GH22537@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071126143939.GB28022@gondor.apana.org.au>
	 <1196098095-8995-1-git-send-email-crquan@gmail.com>
	 <1196100104.31590.11.camel@localhost>
	 <20071127013540.GA793@gondor.apana.org.au>
	 <1196131632-7285-1-git-send-email-crquan@gmail.com>
	 <474B87F1.2060109@student.ltu.se>
	 <91b13c310711262103w781b3047k6338acda56837c0@mail.gmail.com>
	 <20071127012622.3e3a6bd1.akpm@linux-foundation.org>
	 <20071129111324.GH22537@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2007 7:13 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
...
> > uninlining this function shrinks crypto/tcrypt.o's .text from 20,009 bytes
> > down to 19,701.
> >
> > inlining is almost always wrong.
>
> I agree.  Please do as Andrew suggests and resubmit.
inline disabled.

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Denis Cheng <crquan@gmail.com>
---

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 24141fb..13efc72 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -83,10 +83,9 @@ static char *check[] = {

 static void hexdump(unsigned char *buf, unsigned int len)
 {
-	while (len--)
-		printk("%02x", *buf++);
-
-	printk("\n");
+	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
+			16, 1,
+			buf, len, false);
 }

 static void tcrypt_complete(struct crypto_async_request *req, int err)

-- 
Denis Cheng
