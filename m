Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbYBLXH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbYBLXH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbYBLXHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:07:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:4852 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbYBLXHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:07:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=a86wNk2wNRAO7MJ6BWm429MNU8o2Y+mUUgv8cCRna3eq91HhwMwIkv685lobK8M3H74Jybod2XLFJG53n0MYIe1H/p1IzopHPgrtIh2LVgZtjgdWs4U/HRbZJQlR+I8FxNcoUvuC+m5kHwEC5o/JTwz2ctYs5x7ECIm9wHa5U3Y=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] crypto: be*_add_cpu conversion
Date: Wed, 13 Feb 2008 00:06:06 +0100
Message-Id: <1202857582-15450-2-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
big_endian_variable = cpu_to_beX(beX_to_cpu(big_endian_variable) +
					expression_in_cpu_byteorder);
with:
	beX_add_cpu(&big_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
---
 crypto/lrw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 9d52e58..4d93928 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -92,7 +92,7 @@ struct sinfo {
 static inline void inc(be128 *iv)
 {
 	if (!(iv->b = cpu_to_be64(be64_to_cpu(iv->b) + 1)))
-		iv->a = cpu_to_be64(be64_to_cpu(iv->a) + 1);
+		be64_add_cpu(&iv->a, 1);
 }
 
 static inline void lrw_round(struct sinfo *s, void *dst, const void *src)
-- 
1.5.3.7

