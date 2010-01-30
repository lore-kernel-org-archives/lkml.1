Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192Ab0A3Pm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab0A3Pm1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 10:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136Ab0A3Pm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 10:42:26 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:55564 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab0A3PmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 10:42:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OKJKS83cwHr32/PHohrCGPMomwSVHDweqrXW7Vzdrko7A3oRmctXrnjhSbUZ41Lckc
         NGI0IDNH0rJrw9mhhKrPZPnJP70eesHhnb7FrcVxvXllj7oZekLQ4i5uO4KdQuFTX3r0
         LA13aKCmPxqxeUlVVPGsLMGdvhdfaLeR6laV0=
Message-ID: <4B6454C3.1030606@gmail.com>
Date: Sat, 30 Jan 2010 16:48:19 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Sergey Mironov <ierton@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] geode: Fix cip/blk confusion
References: <4B62E388.1070707@gmail.com> <20100129145152.GA31953@Chamillionaire.breakpoint.cc> <25e057c01001290720k529a5ee3i6bef74c9217abbf8@mail.gmail.com> <20100129203008.GA5828@gondor.apana.org.au>
In-Reply-To: <20100129203008.GA5828@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a crypto_cipher cip member was set where a crypto_cipher blk members
should have been.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
>> I think my previous patch missed one
>> blk to cip conversion in geode_setkey_cip():
> 
> Please send an incremental patch.  Thanks!

Ok, here's the missing part

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 03e71b1..c7a5a43 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -141,7 +141,7 @@ static int geode_setkey_cip(struct crypto_tfm *tfm, const u8 *key,
 	ret = crypto_cipher_setkey(op->fallback.cip, key, len);
 	if (ret) {
 		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |= (op->fallback.blk->base.crt_flags & CRYPTO_TFM_RES_MASK);
+		tfm->crt_flags |= (op->fallback.cip->base.crt_flags & CRYPTO_TFM_RES_MASK);
 	}
 	return ret;
 }
