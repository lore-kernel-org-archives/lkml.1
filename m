Return-Path: <linux-kernel-owner+w=401wt.eu-S935051AbZLGN1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935051AbZLGN1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935032AbZLGN1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:27:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:55507 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934807AbZLGN1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:27:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=rOrVIEvKxpHwHRtH/IYZXLopW9U0Rzj/cOCHVyq+Ee7ymRo9co+y3uAO/QmozU6tkk
         +kQDQjyduBVt3UTe8rLI5fwn7jysSlmFKTCkJB5eINvKGN/R1I3v/tsllsWQbOXv6pOU
         50j5koIJ/IzY1J3Q1uAmIx6XlUDntOoaidb5c=
Message-ID: <4B1D02F7.2020505@gmail.com>
Date: Mon, 07 Dec 2009 14:28:23 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] geode: PTR_ERR return of wrong pointer in fallback_init_cip()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the PTR_ERR of the correct pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/crypto/geode-aes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 4801162..12cf864 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -263,7 +263,7 @@ static int fallback_init_cip(struct crypto_tfm *tfm)
 
 	if (IS_ERR(op->fallback.cip)) {
 		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
-		return PTR_ERR(op->fallback.blk);
+		return PTR_ERR(op->fallback.cip);
 	}
 
 	return 0;
