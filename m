Return-Path: <linux-kernel-owner+w=401wt.eu-S1751880AbXA0Uiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbXA0Uiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 15:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbXA0Uiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 15:38:46 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3984 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751880AbXA0Uip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 15:38:45 -0500
Date: Sun, 28 Jan 2007 07:38:39 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
Message-ID: <20070127203839.GA18970@gondor.apana.org.au>
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net> <45BB6A2F.8090401@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BB6A2F.8090401@googlemail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 27, 2007 at 04:05:19PM +0100, Michal Piotrowski wrote:
> 
> git-cryptodev.patch removes CRYPTO_TFM_MODE_CBC but it is still defined as ECRYPTFS_DEFAULT_CHAINING_MODE
> in fs/ecryptfs/ecryptfs_kernel.h
> 
> What should be a new ECRYPTFS_DEFAULT_CHAINING_MODE ?

It should simply be removed.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
On Sat, Jan 27, 2007 at 09:49:21AM +1100, Herbert Xu wrote:
> 
> That macro has been obsolete for ages.  I wonder why ecryptfs is still
> using it.  Oh well I'll restore it for now.

What I ended up doing is adding the following patch to cryptodev-2.6.
So if you pull again it should be there now.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 7196f50..a86a55c 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -828,9 +828,7 @@ int ecryptfs_init_crypt_ctx(struct ecryptfs_crypt_stat *crypt_stat)
 		mutex_unlock(&crypt_stat->cs_tfm_mutex);
 		goto out;
 	}
-	crypto_blkcipher_set_flags(crypt_stat->tfm,
-				   (ECRYPTFS_DEFAULT_CHAINING_MODE
-				    | CRYPTO_TFM_REQ_WEAK_KEY));
+	crypto_blkcipher_set_flags(crypt_stat->tfm, CRYPTO_TFM_REQ_WEAK_KEY);
 	mutex_unlock(&crypt_stat->cs_tfm_mutex);
 	rc = 0;
 out:
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index afb64bd..0f89710 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -176,7 +176,6 @@ ecryptfs_get_key_payload_data(struct key *key)
 #define ECRYPTFS_FILE_SIZE_BYTES 8
 #define ECRYPTFS_DEFAULT_CIPHER "aes"
 #define ECRYPTFS_DEFAULT_KEY_BYTES 16
-#define ECRYPTFS_DEFAULT_CHAINING_MODE CRYPTO_TFM_MODE_CBC
 #define ECRYPTFS_DEFAULT_HASH "md5"
 #define ECRYPTFS_TAG_3_PACKET_TYPE 0x8C
 #define ECRYPTFS_TAG_11_PACKET_TYPE 0xED
