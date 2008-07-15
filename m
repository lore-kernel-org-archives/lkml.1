Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbYGOPaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbYGOPaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbYGOPaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:30:00 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2444 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761354AbYGOP36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:29:58 -0400
Date: Tue, 15 Jul 2008 11:29:04 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, herbert@gondor.apana.org.au, mingo@elte.hu,
       nhorman@tuxdriver.com
Subject: [PATCH] crypto: fix up checkpatch errors
Message-ID: <20080715152904.GC4918@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch to clean up the checkpatch errors in crypto/prng.c

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 prng.c |  155 +++++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 85 insertions(+), 70 deletions(-)


diff --git a/crypto/prng.c b/crypto/prng.c
index 24e4f32..11b9306 100644
--- a/crypto/prng.c
+++ b/crypto/prng.c
@@ -81,14 +81,17 @@ static void hexdump(char *note, unsigned char *buf, unsigned int len)
 	}
 }
 
-#define dbgprint(format, args...) do {if(dbg) printk(format, ##args);} while(0)
+#define dbgprint(format, args...) do {\
+if (dbg)\
+	printk(format, ##args);\
+} while (0)
 
 static void xor_vectors(unsigned char *in1, unsigned char *in2,
-		        unsigned char *out, unsigned int size)
+			unsigned char *out, unsigned int size)
 {
 	int i;
 
-	for (i=0;i<size;i++)
+	for (i = 0; i < size; i++)
 		out[i] = in1[i] ^ in2[i];
 
 }
@@ -108,7 +111,8 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 	desc.flags = 0;
 
 
-	dbgprint(KERN_CRIT "Calling _get_more_prng_bytes for context %p\n",ctx);
+	dbgprint(KERN_CRIT "Calling _get_more_prng_bytes for context %p\n",
+		ctx);
 
 	hexdump("Input DT: ", ctx->DT, DEFAULT_BLK_SZ);
 	hexdump("Input I: ", ctx->I, DEFAULT_BLK_SZ);
@@ -117,63 +121,70 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 	/*
 	 * This algorithm is a 3 stage state machine
 	 */
-	for (i=0;i<3;i++) {
+	for (i = 0; i < 3; i++) {
 
 		desc.tfm = ctx->tfm;
 		desc.flags = 0;
 		switch (i) {
-			case 0:
-				/*
-				 * Start by encrypting the counter value
-				 * This gives us an intermediate value I
-				 */
-				memcpy(tmp, ctx->DT, DEFAULT_BLK_SZ);
-				sg_init_one(&sg_out, &ctx->I[0], DEFAULT_BLK_SZ);
-				hexdump("tmp stage 0: ", tmp, DEFAULT_BLK_SZ);
-				break;
-			case 1:
-
-				/*
-				 * Next xor I with our secret vector V
-				 * encrypt that result to obtain our
-				 * pseudo random data which we output
-				 */
-				xor_vectors(ctx->I, ctx->V, tmp, DEFAULT_BLK_SZ);
-				sg_init_one(&sg_out, &ctx->rand_data[0], DEFAULT_BLK_SZ);
-				hexdump("tmp stage 1: ", tmp, DEFAULT_BLK_SZ);
-				break;
-			case 2:
-				/*
-				 * First check that we didn't produce the same random data
-				 * that we did last time around through this
-				 */
-				if (!memcmp(ctx->rand_data, ctx->last_rand_data, DEFAULT_BLK_SZ)) {
-					printk(KERN_ERR "ctx %p Failed repetition check!\n",
-						ctx);
-					ctx->flags |= PRNG_NEED_RESET;
-					return -1;
-				}
-				memcpy(ctx->last_rand_data, ctx->rand_data, DEFAULT_BLK_SZ);
-
-				/*
-				 * Lastly xor the random data with I
-				 * and encrypt that to obtain a new secret vector V
-				 */
-				xor_vectors(ctx->rand_data, ctx->I, tmp, DEFAULT_BLK_SZ);
-				sg_init_one(&sg_out, &ctx->V[0], DEFAULT_BLK_SZ);
-				hexdump("tmp stage 2: ", tmp, DEFAULT_BLK_SZ);
-				break;
+		case 0:
+			/*
+			 * Start by encrypting the counter value
+			 * This gives us an intermediate value I
+			 */
+			memcpy(tmp, ctx->DT, DEFAULT_BLK_SZ);
+			sg_init_one(&sg_out, &ctx->I[0], DEFAULT_BLK_SZ);
+			hexdump("tmp stage 0: ", tmp, DEFAULT_BLK_SZ);
+			break;
+		case 1:
+
+			/*
+			 * Next xor I with our secret vector V
+			 * encrypt that result to obtain our
+			 * pseudo random data which we output
+			 */
+			xor_vectors(ctx->I, ctx->V, tmp, DEFAULT_BLK_SZ);
+			sg_init_one(&sg_out, &ctx->rand_data[0],
+					DEFAULT_BLK_SZ);
+			hexdump("tmp stage 1: ", tmp, DEFAULT_BLK_SZ);
+			break;
+		case 2:
+			/*
+			 * First check that we didn't produce the same
+			 * random data that we did last time around through this
+			 */
+			if (!memcmp(ctx->rand_data, ctx->last_rand_data,
+					DEFAULT_BLK_SZ)) {
+				printk(KERN_ERR
+					"ctx %p Failed repetition check!\n",
+					ctx);
+				ctx->flags |= PRNG_NEED_RESET;
+				return -1;
+			}
+			memcpy(ctx->last_rand_data, ctx->rand_data,
+				DEFAULT_BLK_SZ);
+
+			/*
+			 * Lastly xor the random data with I
+			 * and encrypt that to obtain a new secret vector V
+			 */
+			xor_vectors(ctx->rand_data, ctx->I, tmp,
+				DEFAULT_BLK_SZ);
+			sg_init_one(&sg_out, &ctx->V[0], DEFAULT_BLK_SZ);
+			hexdump("tmp stage 2: ", tmp, DEFAULT_BLK_SZ);
+			break;
 		}
 
 		/* Initialize our input buffer */
 		sg_init_one(&sg_in, &tmp[0], DEFAULT_BLK_SZ);
 
 		/* do the encryption */
-		ret = crypto_blkcipher_encrypt(&desc, &sg_out, &sg_in, DEFAULT_BLK_SZ);
+		ret = crypto_blkcipher_encrypt(&desc, &sg_out, &sg_in,
+			DEFAULT_BLK_SZ);
 
 		/* And check the result */
 		if (ret) {
-			dbgprint(KERN_CRIT "Encryption of new block failed for context %p\n",ctx);
+			dbgprint(KERN_CRIT
+				"Crypt of block failed for context %p\n", ctx);
 			ctx->rand_data_valid = DEFAULT_BLK_SZ;
 			return -1;
 		}
@@ -183,12 +194,11 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 	/*
 	 * Now update our DT value
 	 */
-	for (i=DEFAULT_BLK_SZ-1;i>0;i--) {
+	for (i = DEFAULT_BLK_SZ-1; i > 0; i--)
 		ctx->DT[i] = ctx->DT[i-1];
-	}
 	ctx->DT[0] += 1;
 
-	dbgprint("Returning new block for context %p\n",ctx);
+	dbgprint("Returning new block for context %p\n", ctx);
 	ctx->rand_data_valid = 0;
 
 	hexdump("Output DT: ", ctx->DT, DEFAULT_BLK_SZ);
@@ -230,7 +240,8 @@ int get_prng_bytes(char *buf, int nbytes, struct prng_context *ctx)
 
 	err = byte_count;
 
-	dbgprint(KERN_CRIT "getting %d random bytes for context %p\n",byte_count, ctx);
+	dbgprint(KERN_CRIT "getting %d random bytes for context %p\n",
+		byte_count, ctx);
 
 
 remainder:
@@ -246,7 +257,8 @@ remainder:
 	 * Copy up to the next whole block size
 	 */
 	if (byte_count < DEFAULT_BLK_SZ) {
-		for (;ctx->rand_data_valid < DEFAULT_BLK_SZ; ctx->rand_data_valid++) {
+		for (; ctx->rand_data_valid < DEFAULT_BLK_SZ;
+			ctx->rand_data_valid++) {
 			*ptr = ctx->rand_data[ctx->rand_data_valid];
 			ptr++;
 			byte_count--;
@@ -258,7 +270,7 @@ remainder:
 	/*
 	 * Now copy whole blocks
 	 */
-	for(;byte_count >= DEFAULT_BLK_SZ; byte_count -= DEFAULT_BLK_SZ) {
+	for (; byte_count >= DEFAULT_BLK_SZ; byte_count -= DEFAULT_BLK_SZ) {
 		if (_get_more_prng_bytes(ctx) < 0) {
 			memset(buf, 0, nbytes);
 			err = -1;
@@ -277,14 +289,16 @@ remainder:
 
 done:
 	spin_unlock_irqrestore(&ctx->prng_lock, flags);
-	dbgprint(KERN_CRIT "returning %d from get_prng_bytes in context %p\n",err, ctx);
+	dbgprint(KERN_CRIT "returning %d from get_prng_bytes in context %p\n",
+		err, ctx);
 	return err;
 }
 EXPORT_SYMBOL_GPL(get_prng_bytes);
 
 struct prng_context *alloc_prng_context(void)
 {
-	struct prng_context *ctx=kzalloc(sizeof(struct prng_context), GFP_KERNEL);
+	struct prng_context *ctx = kzalloc(sizeof(struct prng_context),
+					GFP_KERNEL);
 
 	spin_lock_init(&ctx->prng_lock);
 
@@ -293,10 +307,9 @@ struct prng_context *alloc_prng_context(void)
 		ctx = NULL;
 	}
 
-	dbgprint(KERN_CRIT "returning context %p\n",ctx);
+	dbgprint(KERN_CRIT "returning context %p\n", ctx);
 	return ctx;
 }
-
 EXPORT_SYMBOL_GPL(alloc_prng_context);
 
 void free_prng_context(struct prng_context *ctx)
@@ -318,40 +331,42 @@ int reset_prng_context(struct prng_context *ctx,
 	ctx->flags |= PRNG_NEED_RESET;
 
 	if (key)
-		memcpy(ctx->prng_key,key,strlen(ctx->prng_key));
+		memcpy(ctx->prng_key, key, strlen(ctx->prng_key));
 	else
 		ctx->prng_key = DEFAULT_PRNG_KEY;
 
 	if (iv)
-		memcpy(ctx->prng_iv,iv, strlen(ctx->prng_iv));
+		memcpy(ctx->prng_iv, iv, strlen(ctx->prng_iv));
 	else
 		ctx->prng_iv = DEFAULT_PRNG_IV;
 
 	if (V)
-		memcpy(ctx->V,V,DEFAULT_BLK_SZ);
+		memcpy(ctx->V, V, DEFAULT_BLK_SZ);
 	else
-		memcpy(ctx->V,DEFAULT_V_SEED,DEFAULT_BLK_SZ);
+		memcpy(ctx->V, DEFAULT_V_SEED, DEFAULT_BLK_SZ);
 
 	if (DT)
 		memcpy(ctx->DT, DT, DEFAULT_BLK_SZ);
 	else
 		memset(ctx->DT, 0, DEFAULT_BLK_SZ);
 
-	memset(ctx->rand_data,0,DEFAULT_BLK_SZ);
-	memset(ctx->last_rand_data,0,DEFAULT_BLK_SZ);
+	memset(ctx->rand_data, 0, DEFAULT_BLK_SZ);
+	memset(ctx->last_rand_data, 0, DEFAULT_BLK_SZ);
 
 	if (ctx->tfm)
 		crypto_free_blkcipher(ctx->tfm);
 
-	ctx->tfm = crypto_alloc_blkcipher("rfc3686(ctr(aes))",0,0);
+	ctx->tfm = crypto_alloc_blkcipher("rfc3686(ctr(aes))", 0, 0);
 	if (!ctx->tfm) {
-		dbgprint(KERN_CRIT "Failed to alloc crypto tfm for context %p\n",ctx->tfm);
+		dbgprint(KERN_CRIT "Failed to alloc tfm for context %p\n",
+			ctx->tfm);
 		goto out;
 	}
 
 	ctx->rand_data_valid = DEFAULT_BLK_SZ;
 
-	ret = crypto_blkcipher_setkey(ctx->tfm, ctx->prng_key, strlen(ctx->prng_key));
+	ret = crypto_blkcipher_setkey(ctx->tfm, ctx->prng_key,
+					strlen(ctx->prng_key));
 	if (ret) {
 		dbgprint(KERN_CRIT "PRNG: setkey() failed flags=%x\n",
 			crypto_blkcipher_get_flags(ctx->tfm));
@@ -360,9 +375,9 @@ int reset_prng_context(struct prng_context *ctx,
 	}
 
 	iv_len = crypto_blkcipher_ivsize(ctx->tfm);
-	if (iv_len) {
+	if (iv_len)
 		crypto_blkcipher_set_iv(ctx->tfm, ctx->prng_iv, iv_len);
-	}
+
 	rc = 0;
 	ctx->flags &= ~PRNG_NEED_RESET;
 out:
@@ -384,7 +399,7 @@ static int __init prng_mod_init(void)
 	struct prng_context *ctx = alloc_prng_context();
 	if (ctx == NULL)
 		return -EFAULT;
-	for (i=0;i<16;i++) {
+	for (i = 0; i < 16; i++) {
 		if (get_prng_bytes(tmpbuf, DEFAULT_BLK_SZ, ctx) < 0) {
 			free_prng_context(ctx);
 			return -EFAULT;
-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
