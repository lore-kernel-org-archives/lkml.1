Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbYGCVTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbYGCVTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYGCVTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:19:15 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:36368 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbYGCVTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:19:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=hVya/8bZDn3fRP48qcw7QzZ+1+Dj6suZK+YLnK/YuQBlVQCJVwc5t05KxFDOBC0NMz
         YC80Nv88d4Q1AXGEEqpyAiVNZDLI5x8DgfgmEcj7PbQURifby6BXDZ+7vMPG8b+BdePd
         uZHtluNdas3E0D9axjK84Nlt/ltKfZKoUbwZU=
Subject: [PATCH] crypto: rmd128.c sparse annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 14:18:40 -0700
Message-Id: <1215119921.16647.24.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 crypto/rmd128.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/rmd128.c b/crypto/rmd128.c
index 1a481df..5de6fa2 100644
--- a/crypto/rmd128.c
+++ b/crypto/rmd128.c
@@ -26,7 +26,7 @@
 struct rmd128_ctx {
 	u64 byte_count;
 	u32 state[4];
-	u32 buffer[16];
+	__le32 buffer[16];
 };
 
 #define K1  RMD_K1
@@ -48,7 +48,7 @@ struct rmd128_ctx {
 	(a) = rol32((a), (s)); \
 }
 
-static void rmd128_transform(u32 *state, u32 const *in)
+static void rmd128_transform(u32 *state, const __le32 *in)
 {
 	u32 aa, bb, cc, dd, aaa, bbb, ccc, ddd;
 
@@ -269,8 +269,8 @@ static void rmd128_final(struct crypto_tfm *tfm, u8 *out)
 {
 	struct rmd128_ctx *rctx = crypto_tfm_ctx(tfm);
 	u32 i, index, padlen;
-	u64 bits;
-	u32 *dst = (u32 *)out;
+	__le64 bits;
+	__le32 *dst = (__le32 *)out;
 	static const u8 padding[64] = { 0x80, };
 
 	bits = cpu_to_le64(rctx->byte_count << 3);
-- 
1.5.6.1.281.g1087e



