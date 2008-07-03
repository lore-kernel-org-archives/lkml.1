Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbYGCVbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbYGCVbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbYGCVbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:31:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:34507 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbYGCVbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:31:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=RRAOdVa97xX9d+eC8rDCu0WtFXH5B26hhjtp+G+7PjrIl4IHycqehXRBSseS5m8P+S
         TEZj/Kd6xyzOi1YHAYdCwgerWZaKIhwY7R+Z3DaXiMsm5R2YPusgsB3SsFbEqn2ytdDh
         q7Eb2gR15g8gw8TkcuEA5p1vedS/8ACOuz2jg=
Subject: [PATCH] crypto: rmd160.c rmd256.c rmd320.c sparse annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 14:30:42 -0700
Message-Id: <1215120642.16647.26.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to the rmd128.c annotations, significantly cuts down on the
noise.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 crypto/rmd160.c |    8 ++++----
 crypto/rmd256.c |    8 ++++----
 crypto/rmd320.c |    8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/crypto/rmd160.c b/crypto/rmd160.c
index e9fd5f6..f001ec7 100644
--- a/crypto/rmd160.c
+++ b/crypto/rmd160.c
@@ -26,7 +26,7 @@
 struct rmd160_ctx {
 	u64 byte_count;
 	u32 state[5];
-	u32 buffer[16];
+	__le32 buffer[16];
 };
 
 #define K1  RMD_K1
@@ -52,7 +52,7 @@ struct rmd160_ctx {
 	(c) = rol32((c), 10); \
 }
 
-static void rmd160_transform(u32 *state, u32 const *in)
+static void rmd160_transform(u32 *state, const __le32 *in)
 {
 	u32 aa, bb, cc, dd, ee, aaa, bbb, ccc, ddd, eee;
 
@@ -313,8 +313,8 @@ static void rmd160_final(struct crypto_tfm *tfm, u8 *out)
 {
 	struct rmd160_ctx *rctx = crypto_tfm_ctx(tfm);
 	u32 i, index, padlen;
-	u64 bits;
-	u32 *dst = (u32 *)out;
+	__le64 bits;
+	__le32 *dst = (__le32 *)out;
 	static const u8 padding[64] = { 0x80, };
 
 	bits = cpu_to_le64(rctx->byte_count << 3);
diff --git a/crypto/rmd256.c b/crypto/rmd256.c
index b088526..e3de5b4 100644
--- a/crypto/rmd256.c
+++ b/crypto/rmd256.c
@@ -26,7 +26,7 @@
 struct rmd256_ctx {
 	u64 byte_count;
 	u32 state[8];
-	u32 buffer[16];
+	__le32 buffer[16];
 };
 
 #define K1  RMD_K1
@@ -48,7 +48,7 @@ struct rmd256_ctx {
 	(a) = rol32((a), (s)); \
 }
 
-static void rmd256_transform(u32 *state, u32 const *in)
+static void rmd256_transform(u32 *state, const __le32 *in)
 {
 	u32 aa, bb, cc, dd, aaa, bbb, ccc, ddd, tmp;
 
@@ -288,8 +288,8 @@ static void rmd256_final(struct crypto_tfm *tfm, u8 *out)
 {
 	struct rmd256_ctx *rctx = crypto_tfm_ctx(tfm);
 	u32 i, index, padlen;
-	u64 bits;
-	u32 *dst = (u32 *)out;
+	__le64 bits;
+	__le32 *dst = (__le32 *)out;
 	static const u8 padding[64] = { 0x80, };
 
 	bits = cpu_to_le64(rctx->byte_count << 3);
diff --git a/crypto/rmd320.c b/crypto/rmd320.c
index dba03ec..b143d66 100644
--- a/crypto/rmd320.c
+++ b/crypto/rmd320.c
@@ -26,7 +26,7 @@
 struct rmd320_ctx {
 	u64 byte_count;
 	u32 state[10];
-	u32 buffer[16];
+	__le32 buffer[16];
 };
 
 #define K1  RMD_K1
@@ -52,7 +52,7 @@ struct rmd320_ctx {
 	(c) = rol32((c), 10); \
 }
 
-static void rmd320_transform(u32 *state, u32 const *in)
+static void rmd320_transform(u32 *state, const __le32 *in)
 {
 	u32 aa, bb, cc, dd, ee, aaa, bbb, ccc, ddd, eee, tmp;
 
@@ -337,8 +337,8 @@ static void rmd320_final(struct crypto_tfm *tfm, u8 *out)
 {
 	struct rmd320_ctx *rctx = crypto_tfm_ctx(tfm);
 	u32 i, index, padlen;
-	u64 bits;
-	u32 *dst = (u32 *)out;
+	__le64 bits;
+	__le32 *dst = (__le32 *)out;
 	static const u8 padding[64] = { 0x80, };
 
 	bits = cpu_to_le64(rctx->byte_count << 3);
-- 
1.5.6.1.281.g1087e



