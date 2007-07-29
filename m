Return-Path: <linux-kernel-owner+w=401wt.eu-S1765384AbXG2PCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765384AbXG2PCc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764229AbXG2O6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:58:06 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47793 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764160AbXG2O6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:58:03 -0400
Date: Sun, 29 Jul 2007 16:57:38 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Michael Halcrow <mhalcrow@us.ibm.com>, phillip@hellewell.homeip.net
Cc: linux-kernel@vger.kernel.org, ecryptfs-devel@lists.sourceforge.net
Subject: [-mm patch] fs/ecryptfs/: make code static
Message-ID: <20070729145738.GO16817@stusta.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
>... 
> Changes since 2.6.22-rc6-mm1:
>...
> +ecryptfs-add-key-list-structure-search-keyring.patch
>...
>  ecryptfs feature work
>...

This patch makes some needlessly global code static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/ecryptfs/crypto.c          |   15 +++++------
 fs/ecryptfs/ecryptfs_kernel.h |   10 -------
 fs/ecryptfs/keystore.c        |   43 +++++++++++++++++-----------------
 3 files changed, 29 insertions(+), 39 deletions(-)

--- linux-2.6.23-rc1-mm1/fs/ecryptfs/ecryptfs_kernel.h.old	2007-07-26 13:50:59.000000000 +0200
+++ linux-2.6.23-rc1-mm1/fs/ecryptfs/ecryptfs_kernel.h	2007-07-26 14:09:15.000000000 +0200
@@ -156,7 +156,6 @@
 	} token;
 } __attribute__ ((packed));
 
-int ecryptfs_get_auth_tok_sig(char **sig, struct ecryptfs_auth_tok *auth_tok);
 void ecryptfs_dump_auth_tok(struct ecryptfs_auth_tok *auth_tok);
 extern void ecryptfs_to_hex(char *dst, char *src, size_t src_size);
 extern void ecryptfs_from_hex(char *dst, char *src, int dst_size);
@@ -290,9 +289,6 @@
 	unsigned char cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE + 1];
 };
 
-extern struct list_head key_tfm_list;
-extern struct mutex key_tfm_list_mutex;
-
 /**
  * This struct is to enable a mount-wide passphrase/salt combo. This
  * is more or less a stopgap to provide similar functionality to other
@@ -520,9 +516,6 @@
 void ecryptfs_destruct_mount_crypt_stat(
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat);
 int ecryptfs_init_crypt_ctx(struct ecryptfs_crypt_stat *crypt_stat);
-int ecryptfs_crypto_api_algify_cipher_name(char **algified_name,
-					   char *cipher_name,
-					   char *chaining_modifier);
 #define ECRYPTFS_LOWER_I_MUTEX_NOT_HELD 0
 #define ECRYPTFS_LOWER_I_MUTEX_HELD 1
 int ecryptfs_write_inode_size_to_metadata(struct file *lower_file,
@@ -563,13 +556,10 @@
 				     struct ecryptfs_crypt_stat *crypt_stat,
 				     struct dentry *ecryptfs_dentry,
 				     size_t *len, size_t max);
-int process_request_key_err(long err_code);
 int
 ecryptfs_parse_packet_set(struct ecryptfs_crypt_stat *crypt_stat,
 			  unsigned char *src, struct dentry *ecryptfs_dentry);
 int ecryptfs_truncate(struct dentry *dentry, loff_t new_length);
-int ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
-				char *cipher_name, size_t *key_size);
 int ecryptfs_inode_test(struct inode *inode, void *candidate_lower_inode);
 int ecryptfs_inode_set(struct inode *inode, void *lower_inode);
 void ecryptfs_init_inode(struct inode *inode, struct inode *lower_inode);
--- linux-2.6.23-rc1-mm1/fs/ecryptfs/crypto.c.old	2007-07-26 13:51:13.000000000 +0200
+++ linux-2.6.23-rc1-mm1/fs/ecryptfs/crypto.c	2007-07-26 13:59:12.000000000 +0200
@@ -123,9 +123,9 @@
 	return rc;
 }
 
-int ecryptfs_crypto_api_algify_cipher_name(char **algified_name,
-					   char *cipher_name,
-					   char *chaining_modifier)
+static int ecryptfs_crypto_api_algify_cipher_name(char **algified_name,
+						  char *cipher_name,
+						  char *chaining_modifier)
 {
 	int cipher_name_len = strlen(cipher_name);
 	int chaining_modifier_len = strlen(chaining_modifier);
@@ -1828,9 +1828,8 @@
  * should be released by other functions, such as on a superblock put
  * event, regardless of whether this function succeeds for fails.
  */
-int
-ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
-			    char *cipher_name, size_t *key_size)
+static int ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
+				       char *cipher_name, size_t *key_size)
 {
 	char dummy_key[ECRYPTFS_MAX_KEY_BYTES];
 	char *full_alg_name;
@@ -1874,8 +1873,8 @@
 }
 
 struct kmem_cache *ecryptfs_key_tfm_cache;
-struct list_head key_tfm_list;
-struct mutex key_tfm_list_mutex;
+static struct list_head key_tfm_list;
+static struct mutex key_tfm_list_mutex;
 
 int ecryptfs_init_crypto(void)
 {
--- linux-2.6.23-rc1-mm1/fs/ecryptfs/keystore.c.old	2007-07-26 14:01:08.000000000 +0200
+++ linux-2.6.23-rc1-mm1/fs/ecryptfs/keystore.c	2007-07-26 14:09:26.000000000 +0200
@@ -39,7 +39,7 @@
  * determine the type of error, make appropriate log entries, and
  * return an error code.
  */
-int process_request_key_err(long err_code)
+static int process_request_key_err(long err_code)
 {
 	int rc = 0;
 
@@ -396,6 +396,27 @@
 	return rc;
 }
 
+static int ecryptfs_get_auth_tok_sig(char **sig,
+				     struct ecryptfs_auth_tok *auth_tok)
+{
+	int rc = 0;
+
+	(*sig) = NULL;
+	switch (auth_tok->token_type) {
+	case ECRYPTFS_PASSWORD:
+		(*sig) = auth_tok->token.password.signature;
+		break;
+	case ECRYPTFS_PRIVATE_KEY:
+		(*sig) = auth_tok->token.private_key.signature;
+		break;
+	default:
+		printk(KERN_ERR "Cannot get sig for auth_tok of type [%d]\n",
+		       auth_tok->token_type);
+		rc = -EINVAL;
+	}
+	return rc;
+}
+
 /**
  * decrypt_pki_encrypted_session_key - Decrypt the session key with
  * the given auth_tok.
@@ -1080,26 +1101,6 @@
 	return rc;
 }
 
-int ecryptfs_get_auth_tok_sig(char **sig, struct ecryptfs_auth_tok *auth_tok)
-{
-	int rc = 0;
-
-	(*sig) = NULL;
-	switch (auth_tok->token_type) {
-	case ECRYPTFS_PASSWORD:
-		(*sig) = auth_tok->token.password.signature;
-		break;
-	case ECRYPTFS_PRIVATE_KEY:
-		(*sig) = auth_tok->token.private_key.signature;
-		break;
-	default:
-		printk(KERN_ERR "Cannot get sig for auth_tok of type [%d]\n",
-		       auth_tok->token_type);
-		rc = -EINVAL;
-	}
-	return rc;
-}
-
 /**
  * ecryptfs_parse_packet_set
  * @dest: The header page in memory

