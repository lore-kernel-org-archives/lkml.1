Return-Path: <linux-kernel-owner+w=401wt.eu-S1757629AbYC0Rcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbYC0Rcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbYC0Rcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:32:32 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:40823 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbYC0Rca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:32:30 -0400
Date: Thu, 27 Mar 2008 23:02:22 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: 7eggert@gmx.de, Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@ozlabs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       herbert@gondor.apana.org.au, davem@davemloft.net
Subject: [RESENDING-PATCH] init()/fini() clean up in the crypto 
Message-ID: <20080327173222.GA11676@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <abRrB-4uZ-1@gated-at.bofh.it> <abRBc-53a-9@gated-at.bofh.it> <abVvc-4cT-5@gated-at.bofh.it> <E1JetHQ-0000wK-Mk@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1JetHQ-0000wK-Mk@be1.7eggert.dyndns.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 03:40:36PM +0100, Bodo Eggert wrote:
> Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > This patch cleanups the crypto code, replaces the init() and fini()  with the
> > <algorithm name>_init/_fini
> 
> This part ist OK.
> 
> > or init/fini_<algorithm name> (if the 
> > <algorithm name>_init/_fini exist)
> 
> Having init_foo and foo_init won't be a good thing, will it? I'd start
> confusing them.
> 
> What about foo_modinit instead?
> 
> ¢¢
> 
Thanks for the suggestion, the init() is replaced with <algorithm name>_mod_init ()
and fini () is replaced with <algorithm name>_mod_fini.
 
Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
diff --git a/crypto/anubis.c b/crypto/anubis.c
index 4ff0e1e..e42c3a8 100644
--- a/crypto/anubis.c
+++ b/crypto/anubis.c
@@ -687,7 +687,7 @@ static struct crypto_alg anubis_alg = {
 	.cia_decrypt		=	anubis_decrypt } }
 };
 
-static int __init init(void)
+static int __init anubis_mod_init(void)
 {
 	int ret = 0;
 	
@@ -695,13 +695,13 @@ static int __init init(void)
 	return ret;
 }
 
-static void __exit fini(void)
+static void __exit anubis_mod_fini(void)
 {
 	crypto_unregister_alg(&anubis_alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(anubis_mod_init);
+module_exit(anubis_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Anubis Cryptographic Algorithm");
diff --git a/crypto/blowfish.c b/crypto/blowfish.c
index 80c3fd8..6f5b487 100644
--- a/crypto/blowfish.c
+++ b/crypto/blowfish.c
@@ -465,18 +465,18 @@ static struct crypto_alg alg = {
 	.cia_decrypt  		=	bf_decrypt } }
 };
 
-static int __init init(void)
+static int __init blowfish_mod_init(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit blowfish_mod_fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(blowfish_mod_init);
+module_exit(blowfish_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Blowfish Cipher Algorithm");
diff --git a/crypto/cast5.c b/crypto/cast5.c
index 13ea60a..8cbe28f 100644
--- a/crypto/cast5.c
+++ b/crypto/cast5.c
@@ -817,18 +817,18 @@ static struct crypto_alg alg = {
 	}
 };
 
-static int __init init(void)
+static int __init cast5_mod_init(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit cast5_mod_fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(cast5_mod_init);
+module_exit(cast5_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Cast5 Cipher Algorithm");
diff --git a/crypto/cast6.c b/crypto/cast6.c
index 5fd9420..007d02b 100644
--- a/crypto/cast6.c
+++ b/crypto/cast6.c
@@ -528,18 +528,18 @@ static struct crypto_alg alg = {
 		  }
 };
 
-static int __init init(void)
+static int __init cast6_mod_init(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit cast6_mod_fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(cast6_mod_init);
+module_exit(cast6_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Cast6 Cipher Algorithm");
diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index 0fa7443..0dcf64a 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -98,18 +98,18 @@ static struct crypto_alg alg = {
 	}
 };
 
-static int __init init(void)
+static int __init crc32c_mod_init(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit crc32c_mod_fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(crc32c_mod_init);
+module_exit(crc32c_mod_fini);
 
 MODULE_AUTHOR("Clay Haapala <chaapala@cisco.com>");
 MODULE_DESCRIPTION("CRC32c (Castagnoli) calculations wrapper for lib/crc32c");
diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index ff7b3de..1f7d530 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -142,7 +142,7 @@ MODULE_ALIAS("compress_null");
 MODULE_ALIAS("digest_null");
 MODULE_ALIAS("cipher_null");
 
-static int __init init(void)
+static int __init crypto_null_mod_init(void)
 {
 	int ret = 0;
 	
@@ -174,7 +174,7 @@ out_unregister_cipher:
 	goto out;
 }
 
-static void __exit fini(void)
+static void __exit crypto_null_mod_fini(void)
 {
 	crypto_unregister_alg(&compress_null);
 	crypto_unregister_alg(&digest_null);
@@ -182,8 +182,8 @@ static void __exit fini(void)
 	crypto_unregister_alg(&cipher_null);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(crypto_null_mod_init);
+module_exit(crypto_null_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Null Cryptographic Algorithms");
diff --git a/crypto/deflate.c b/crypto/deflate.c
index 6588bbf..9128da4 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -208,18 +208,18 @@ static struct crypto_alg alg = {
 	.coa_decompress  	= deflate_decompress } }
 };
 
-static int __init init(void)
+static int __init deflate_mod_init(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit deflate_mod_fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(deflate_mod_init);
+module_exit(deflate_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Deflate Compression Algorithm for IPCOMP");
diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 355ecb7..5d0e458 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -977,7 +977,7 @@ static struct crypto_alg des3_ede_alg = {
 
 MODULE_ALIAS("des3_ede");
 
-static int __init init(void)
+static int __init des_generic_mod_init(void)
 {
 	int ret = 0;
 
@@ -992,14 +992,14 @@ out:
 	return ret;
 }
 
-static void __exit fini(void)
+static void __exit des_generic_mod_fini(void)
 {
 	crypto_unregister_alg(&des3_ede_alg);
 	crypto_unregister_alg(&des_alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(des_generic_mod_init);
+module_exit(des_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("DES & Triple DES EDE Cipher Algorithms");
diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
index a32cb68..1302f4c 100644
--- a/crypto/fcrypt.c
+++ b/crypto/fcrypt.c
@@ -405,18 +405,18 @@ static struct crypto_alg fcrypt_alg = {
 	.cia_decrypt		=	fcrypt_decrypt } }
 };
 
-static int __init init(void)
+static int __init fcrypt_mod_init(void)
 {
 	return crypto_register_alg(&fcrypt_alg);
 }
 
-static void __exit fini(void)
+static void __exit fcrypt_mod_fini(void)
 {
 	crypto_unregister_alg(&fcrypt_alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(fcrypt_mod_init);
+module_exit(fcrypt_mod_fini);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("FCrypt Cipher Algorithm");
diff --git a/crypto/khazad.c b/crypto/khazad.c
index 704ebfe..527e4e3 100644
--- a/crypto/khazad.c
+++ b/crypto/khazad.c
@@ -862,7 +862,7 @@ static struct crypto_alg khazad_alg = {
 	.cia_decrypt		=	khazad_decrypt } }
 };
 
-static int __init init(void)
+static int __init khazad_mod_init(void)
 {
 	int ret = 0;
 	
@@ -870,14 +870,14 @@ static int __init init(void)
 	return ret;
 }
 
-static void __exit fini(void)
+static void __exit khazad_mod_fini(void)
 {
 	crypto_unregister_alg(&khazad_alg);
 }
 
 
-module_init(init);
-module_exit(fini);
+module_init(khazad_mod_init);
+module_exit(khazad_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Khazad Cryptographic Algorithm");
diff --git a/crypto/lzo.c b/crypto/lzo.c
index 48c3288..b5e7707 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -89,18 +89,18 @@ static struct crypto_alg alg = {
 	.coa_decompress  	= lzo_decompress } }
 };
 
-static int __init init(void)
+static int __init lzo_mod_init(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit lzo_mod_fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(lzo_mod_init);
+module_exit(lzo_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("LZO Compression Algorithm");
diff --git a/crypto/md4.c b/crypto/md4.c
index c1bc71b..3c19aa0 100644
--- a/crypto/md4.c
+++ b/crypto/md4.c
@@ -233,18 +233,18 @@ static struct crypto_alg alg = {
 	.dia_final  	=	md4_final } }
 };
 
-static int __init init(void)
+static int __init md4_mod_init(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit md4_mod_fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(md4_mod_init);
+module_exit(md4_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MD4 Message Digest Algorithm");
diff --git a/crypto/md5.c b/crypto/md5.c
index 93d18e8..39268f3 100644
--- a/crypto/md5.c
+++ b/crypto/md5.c
@@ -228,18 +228,18 @@ static struct crypto_alg alg = {
 	.dia_final  	=	md5_final } }
 };
 
-static int __init init(void)
+static int __init md5_mod_init(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit md5_mod_fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(md5_mod_init);
+module_exit(md5_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MD5 Message Digest Algorithm");
diff --git a/crypto/salsa20_generic.c b/crypto/salsa20_generic.c
index 1fa4e4d..b07d559 100644
--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -237,18 +237,18 @@ static struct crypto_alg alg = {
 	}
 };
 
-static int __init init(void)
+static int __init salsa20_generic_mod_init(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit salsa20_generic_mod_fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(salsa20_generic_mod_init);
+module_exit(salsa20_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION ("Salsa20 stream cipher algorithm");
diff --git a/crypto/serpent.c b/crypto/serpent.c
index 2b0a19a..b651a55 100644
--- a/crypto/serpent.c
+++ b/crypto/serpent.c
@@ -557,7 +557,7 @@ static struct crypto_alg tnepres_alg = {
 	.cia_decrypt  		=	tnepres_decrypt } }
 };
 
-static int __init init(void)
+static int __init serpent_mod_init(void)
 {
 	int ret = crypto_register_alg(&serpent_alg);
 
@@ -572,14 +572,14 @@ static int __init init(void)
 	return ret;
 }
 
-static void __exit fini(void)
+static void __exit serpent_mod_fini(void)
 {
 	crypto_unregister_alg(&tnepres_alg);
 	crypto_unregister_alg(&serpent_alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(serpent_mod_init);
+module_exit(serpent_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Serpent and tnepres (kerneli compatible serpent reversed) Cipher Algorithm");
diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 68c62f5..c7c6899 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -120,18 +120,18 @@ static struct crypto_alg alg = {
 	.dia_final  	=	sha1_final } }
 };
 
-static int __init init(void)
+static int __init sha1_generic_mod_init(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit sha1_generic_mod_fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(sha1_generic_mod_init);
+module_exit(sha1_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA1 Secure Hash Algorithm");
diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index 3cc93fd..5a8dd47 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -353,7 +353,7 @@ static struct crypto_alg sha224 = {
 	.dia_final	= sha224_final } }
 };
 
-static int __init init(void)
+static int __init sha256_generic_mod_init(void)
 {
 	int ret = 0;
 
@@ -370,14 +370,14 @@ static int __init init(void)
 	return ret;
 }
 
-static void __exit fini(void)
+static void __exit sha256_generic_mod_fini(void)
 {
 	crypto_unregister_alg(&sha224);
 	crypto_unregister_alg(&sha256);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(sha256_generic_mod_init);
+module_exit(sha256_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA-224 and SHA-256 Secure Hash Algorithm");
diff --git a/crypto/sha512.c b/crypto/sha512.c
index c39c803..e843946 100644
--- a/crypto/sha512.c
+++ b/crypto/sha512.c
@@ -280,7 +280,7 @@ static struct crypto_alg sha384 = {
 
 MODULE_ALIAS("sha384");
 
-static int __init init(void)
+static int __init sha512_mod_init(void)
 {
         int ret = 0;
 
@@ -292,14 +292,14 @@ out:
         return ret;
 }
 
-static void __exit fini(void)
+static void __exit sha512_mod_fini(void)
 {
         crypto_unregister_alg(&sha384);
         crypto_unregister_alg(&sha512);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(sha512_mod_init);
+module_exit(sha512_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA-512 and SHA-384 Secure Hash Algorithms");
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 1ab8c01..ebf2c82 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1775,7 +1775,7 @@ static void do_test(void)
 	}
 }
 
-static int __init init(void)
+static int __init tcrypt_mod_init(void)
 {
 	int err = -ENOMEM;
 
@@ -1814,10 +1814,10 @@ static int __init init(void)
  * If an init function is provided, an exit function must also be provided
  * to allow module unload.
  */
-static void __exit fini(void) { }
+static void __exit tcrypt_mod_fini(void) { }
 
-module_init(init);
-module_exit(fini);
+module_init(tcrypt_mod_init);
+module_exit(tcrypt_mod_fini);
 
 module_param(mode, int, 0);
 module_param(sec, uint, 0);
diff --git a/crypto/tea.c b/crypto/tea.c
index 6893b3f..412bc74 100644
--- a/crypto/tea.c
+++ b/crypto/tea.c
@@ -267,7 +267,7 @@ static struct crypto_alg xeta_alg = {
 	.cia_decrypt		=	xeta_decrypt } }
 };
 
-static int __init init(void)
+static int __init tea_mod_init(void)
 {
 	int ret = 0;
 	
@@ -292,7 +292,7 @@ out:
 	return ret;
 }
 
-static void __exit fini(void)
+static void __exit tea_mod_fini(void)
 {
 	crypto_unregister_alg(&tea_alg);
 	crypto_unregister_alg(&xtea_alg);
@@ -302,8 +302,8 @@ static void __exit fini(void)
 MODULE_ALIAS("xtea");
 MODULE_ALIAS("xeta");
 
-module_init(init);
-module_exit(fini);
+module_init(tea_mod_init);
+module_exit(tea_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("TEA, XTEA & XETA Cryptographic Algorithms");
diff --git a/crypto/tgr192.c b/crypto/tgr192.c
index 2e7ea16..a92414f 100644
--- a/crypto/tgr192.c
+++ b/crypto/tgr192.c
@@ -663,7 +663,7 @@ static struct crypto_alg tgr128 = {
 			     .dia_final = tgr128_final}}
 };
 
-static int __init init(void)
+static int __init tgr192_mod_init(void)
 {
 	int ret = 0;
 
@@ -688,7 +688,7 @@ static int __init init(void)
 	return ret;
 }
 
-static void __exit fini(void)
+static void __exit tgr192_mod_fini(void)
 {
 	crypto_unregister_alg(&tgr192);
 	crypto_unregister_alg(&tgr160);
@@ -698,8 +698,8 @@ static void __exit fini(void)
 MODULE_ALIAS("tgr160");
 MODULE_ALIAS("tgr128");
 
-module_init(init);
-module_exit(fini);
+module_init(tgr192_mod_init);
+module_exit(tgr192_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Tiger Message Digest Algorithm");
diff --git a/crypto/twofish.c b/crypto/twofish.c
index 4979a2b..dfcda23 100644
--- a/crypto/twofish.c
+++ b/crypto/twofish.c
@@ -197,18 +197,18 @@ static struct crypto_alg alg = {
 	.cia_decrypt        =   twofish_decrypt } }
 };
 
-static int __init init(void)
+static int __init twofish_mod_init(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit twofish_mod_fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(twofish_mod_init);
+module_exit(twofish_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION ("Twofish Cipher Algorithm");
diff --git a/crypto/wp512.c b/crypto/wp512.c
index f746952..bff2856 100644
--- a/crypto/wp512.c
+++ b/crypto/wp512.c
@@ -1146,7 +1146,7 @@ static struct crypto_alg wp256 = {
 	.dia_final  	=	wp256_final } }
 };
 
-static int __init init(void)
+static int __init wp512_mod_init(void)
 {
 	int ret = 0;
 
@@ -1172,7 +1172,7 @@ out:
 	return ret;
 }
 
-static void __exit fini(void)
+static void __exit wp512_mod_fini(void)
 {
 	crypto_unregister_alg(&wp512);
 	crypto_unregister_alg(&wp384);
@@ -1182,8 +1182,8 @@ static void __exit fini(void)
 MODULE_ALIAS("wp384");
 MODULE_ALIAS("wp256");
 
-module_init(init);
-module_exit(fini);
+module_init(wp512_mod_init);
+module_exit(wp512_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Whirlpool Message Digest Algorithm");
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
