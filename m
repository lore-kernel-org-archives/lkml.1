Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347AbXLETtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbXLETtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbXLETlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:41:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542AbXLETkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:40:32 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 22/28] fcrypt endianness misannotations [try #2]
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 05 Dec 2007 19:40:10 +0000
Message-ID: <20071205194010.24617.79612.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
References: <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---

 crypto/fcrypt.c |   88 ++++++++++++++++++++++++++++---------------------------
 1 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
index d161949..a32cb68 100644
--- a/crypto/fcrypt.c
+++ b/crypto/fcrypt.c
@@ -51,7 +51,7 @@
 #define ROUNDS 16
 
 struct fcrypt_ctx {
-	u32 sched[ROUNDS];
+	__be32 sched[ROUNDS];
 };
 
 /* Rotate right two 32 bit numbers as a 56 bit number */
@@ -73,8 +73,8 @@ do {								\
  * /afs/transarc.com/public/afsps/afs.rel31b.export-src/rxkad/sboxes.h
  */
 #undef Z
-#define Z(x) __constant_be32_to_cpu(x << 3)
-static const u32 sbox0[256] = {
+#define Z(x) __constant_cpu_to_be32(x << 3)
+static const __be32 sbox0[256] = {
 	Z(0xea), Z(0x7f), Z(0xb2), Z(0x64), Z(0x9d), Z(0xb0), Z(0xd9), Z(0x11),
 	Z(0xcd), Z(0x86), Z(0x86), Z(0x91), Z(0x0a), Z(0xb2), Z(0x93), Z(0x06),
 	Z(0x0e), Z(0x06), Z(0xd2), Z(0x65), Z(0x73), Z(0xc5), Z(0x28), Z(0x60),
@@ -110,8 +110,8 @@ static const u32 sbox0[256] = {
 };
 
 #undef Z
-#define Z(x) __constant_be32_to_cpu((x << 27) | (x >> 5))
-static const u32 sbox1[256] = {
+#define Z(x) __constant_cpu_to_be32((x << 27) | (x >> 5))
+static const __be32 sbox1[256] = {
 	Z(0x77), Z(0x14), Z(0xa6), Z(0xfe), Z(0xb2), Z(0x5e), Z(0x8c), Z(0x3e),
 	Z(0x67), Z(0x6c), Z(0xa1), Z(0x0d), Z(0xc2), Z(0xa2), Z(0xc1), Z(0x85),
 	Z(0x6c), Z(0x7b), Z(0x67), Z(0xc6), Z(0x23), Z(0xe3), Z(0xf2), Z(0x89),
@@ -147,8 +147,8 @@ static const u32 sbox1[256] = {
 };
 
 #undef Z
-#define Z(x) __constant_be32_to_cpu(x << 11)
-static const u32 sbox2[256] = {
+#define Z(x) __constant_cpu_to_be32(x << 11)
+static const __be32 sbox2[256] = {
 	Z(0xf0), Z(0x37), Z(0x24), Z(0x53), Z(0x2a), Z(0x03), Z(0x83), Z(0x86),
 	Z(0xd1), Z(0xec), Z(0x50), Z(0xf0), Z(0x42), Z(0x78), Z(0x2f), Z(0x6d),
 	Z(0xbf), Z(0x80), Z(0x87), Z(0x27), Z(0x95), Z(0xe2), Z(0xc5), Z(0x5d),
@@ -184,8 +184,8 @@ static const u32 sbox2[256] = {
 };
 
 #undef Z
-#define Z(x) __constant_be32_to_cpu(x << 19)
-static const u32 sbox3[256] = {
+#define Z(x) __constant_cpu_to_be32(x << 19)
+static const __be32 sbox3[256] = {
 	Z(0xa9), Z(0x2a), Z(0x48), Z(0x51), Z(0x84), Z(0x7e), Z(0x49), Z(0xe2),
 	Z(0xb5), Z(0xb7), Z(0x42), Z(0x33), Z(0x7d), Z(0x5d), Z(0xa6), Z(0x12),
 	Z(0x44), Z(0x48), Z(0x6d), Z(0x28), Z(0xaa), Z(0x20), Z(0x6d), Z(0x57),
@@ -225,7 +225,7 @@ static const u32 sbox3[256] = {
  */
 #define F_ENCRYPT(R, L, sched)						\
 do {									\
-	union lc4 { u32 l; u8 c[4]; } u;				\
+	union lc4 { __be32 l; u8 c[4]; } u;				\
 	u.l = sched ^ R;						\
 	L ^= sbox0[u.c[0]] ^ sbox1[u.c[1]] ^ sbox2[u.c[2]] ^ sbox3[u.c[3]]; \
 } while(0)
@@ -237,7 +237,7 @@ static void fcrypt_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	const struct fcrypt_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct {
-		u32 l, r;
+		__be32 l, r;
 	} X;
 
 	memcpy(&X, src, sizeof(X));
@@ -269,7 +269,7 @@ static void fcrypt_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	const struct fcrypt_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct {
-		u32 l, r;
+		__be32 l, r;
 	} X;
 
 	memcpy(&X, src, sizeof(X));
@@ -328,22 +328,22 @@ static int fcrypt_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int key
 	k |= (*key) >> 1;
 
 	/* Use lower 32 bits for schedule, rotate by 11 each round (16 times) */
-	ctx->sched[0x0] = be32_to_cpu(k); ror56_64(k, 11);
-	ctx->sched[0x1] = be32_to_cpu(k); ror56_64(k, 11);
-	ctx->sched[0x2] = be32_to_cpu(k); ror56_64(k, 11);
-	ctx->sched[0x3] = be32_to_cpu(k); ror56_64(k, 11);
-	ctx->sched[0x4] = be32_to_cpu(k); ror56_64(k, 11);
-	ctx->sched[0x5] = be32_to_cpu(k); ror56_64(k, 11);
-	ctx->sched[0x6] = be32_to_cpu(k); ror56_64(k, 11);
-	ctx->sched[0x7] = be32_to_cpu(k); ror56_64(k, 11);
-	ctx->sched[0x8] = be32_to_cpu(k); ror56_64(k, 11);
-	ctx->sched[0x9] = be32_to_cpu(k); ror56_64(k, 11);
-	ctx->sched[0xa] = be32_to_cpu(k); ror56_64(k, 11);
-	ctx->sched[0xb] = be32_to_cpu(k); ror56_64(k, 11);
-	ctx->sched[0xc] = be32_to_cpu(k); ror56_64(k, 11);
-	ctx->sched[0xd] = be32_to_cpu(k); ror56_64(k, 11);
-	ctx->sched[0xe] = be32_to_cpu(k); ror56_64(k, 11);
-	ctx->sched[0xf] = be32_to_cpu(k);
+	ctx->sched[0x0] = cpu_to_be32(k); ror56_64(k, 11);
+	ctx->sched[0x1] = cpu_to_be32(k); ror56_64(k, 11);
+	ctx->sched[0x2] = cpu_to_be32(k); ror56_64(k, 11);
+	ctx->sched[0x3] = cpu_to_be32(k); ror56_64(k, 11);
+	ctx->sched[0x4] = cpu_to_be32(k); ror56_64(k, 11);
+	ctx->sched[0x5] = cpu_to_be32(k); ror56_64(k, 11);
+	ctx->sched[0x6] = cpu_to_be32(k); ror56_64(k, 11);
+	ctx->sched[0x7] = cpu_to_be32(k); ror56_64(k, 11);
+	ctx->sched[0x8] = cpu_to_be32(k); ror56_64(k, 11);
+	ctx->sched[0x9] = cpu_to_be32(k); ror56_64(k, 11);
+	ctx->sched[0xa] = cpu_to_be32(k); ror56_64(k, 11);
+	ctx->sched[0xb] = cpu_to_be32(k); ror56_64(k, 11);
+	ctx->sched[0xc] = cpu_to_be32(k); ror56_64(k, 11);
+	ctx->sched[0xd] = cpu_to_be32(k); ror56_64(k, 11);
+	ctx->sched[0xe] = cpu_to_be32(k); ror56_64(k, 11);
+	ctx->sched[0xf] = cpu_to_be32(k);
 
 	return 0;
 #else
@@ -369,22 +369,22 @@ static int fcrypt_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int key
 	lo |= (*key) >> 1;
 
 	/* Use lower 32 bits for schedule, rotate by 11 each round (16 times) */
-	ctx->sched[0x0] = be32_to_cpu(lo); ror56(hi, lo, 11);
-	ctx->sched[0x1] = be32_to_cpu(lo); ror56(hi, lo, 11);
-	ctx->sched[0x2] = be32_to_cpu(lo); ror56(hi, lo, 11);
-	ctx->sched[0x3] = be32_to_cpu(lo); ror56(hi, lo, 11);
-	ctx->sched[0x4] = be32_to_cpu(lo); ror56(hi, lo, 11);
-	ctx->sched[0x5] = be32_to_cpu(lo); ror56(hi, lo, 11);
-	ctx->sched[0x6] = be32_to_cpu(lo); ror56(hi, lo, 11);
-	ctx->sched[0x7] = be32_to_cpu(lo); ror56(hi, lo, 11);
-	ctx->sched[0x8] = be32_to_cpu(lo); ror56(hi, lo, 11);
-	ctx->sched[0x9] = be32_to_cpu(lo); ror56(hi, lo, 11);
-	ctx->sched[0xa] = be32_to_cpu(lo); ror56(hi, lo, 11);
-	ctx->sched[0xb] = be32_to_cpu(lo); ror56(hi, lo, 11);
-	ctx->sched[0xc] = be32_to_cpu(lo); ror56(hi, lo, 11);
-	ctx->sched[0xd] = be32_to_cpu(lo); ror56(hi, lo, 11);
-	ctx->sched[0xe] = be32_to_cpu(lo); ror56(hi, lo, 11);
-	ctx->sched[0xf] = be32_to_cpu(lo);
+	ctx->sched[0x0] = cpu_to_be32(lo); ror56(hi, lo, 11);
+	ctx->sched[0x1] = cpu_to_be32(lo); ror56(hi, lo, 11);
+	ctx->sched[0x2] = cpu_to_be32(lo); ror56(hi, lo, 11);
+	ctx->sched[0x3] = cpu_to_be32(lo); ror56(hi, lo, 11);
+	ctx->sched[0x4] = cpu_to_be32(lo); ror56(hi, lo, 11);
+	ctx->sched[0x5] = cpu_to_be32(lo); ror56(hi, lo, 11);
+	ctx->sched[0x6] = cpu_to_be32(lo); ror56(hi, lo, 11);
+	ctx->sched[0x7] = cpu_to_be32(lo); ror56(hi, lo, 11);
+	ctx->sched[0x8] = cpu_to_be32(lo); ror56(hi, lo, 11);
+	ctx->sched[0x9] = cpu_to_be32(lo); ror56(hi, lo, 11);
+	ctx->sched[0xa] = cpu_to_be32(lo); ror56(hi, lo, 11);
+	ctx->sched[0xb] = cpu_to_be32(lo); ror56(hi, lo, 11);
+	ctx->sched[0xc] = cpu_to_be32(lo); ror56(hi, lo, 11);
+	ctx->sched[0xd] = cpu_to_be32(lo); ror56(hi, lo, 11);
+	ctx->sched[0xe] = cpu_to_be32(lo); ror56(hi, lo, 11);
+	ctx->sched[0xf] = cpu_to_be32(lo);
 	return 0;
 #endif
 }

