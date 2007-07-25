Return-Path: <linux-kernel-owner+w=401wt.eu-S1764470AbXGYUxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764470AbXGYUxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbXGYUxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:53:24 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59631 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762233AbXGYUxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:53:22 -0400
Date: Wed, 25 Jul 2007 15:53:11 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, toml@us.ibm.com
Subject: [PATCH 7/7] eCryptfs: Make needlessly global symbols static
Message-ID: <20070725205311.GX14091@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070725204855.GQ14091@halcrow.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725204855.GQ14091@halcrow.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Please check that all the newly-added global symbols do indeed need
> to be global.

Change symbols in keystore.c and crypto.o to static if they do not
need to be global.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/crypto.c          |    8 +++---
 fs/ecryptfs/ecryptfs_kernel.h |    7 ------
 fs/ecryptfs/keystore.c        |   43 +++++++++++++++++++++--------------------
 3 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 7aa2f48..8e9b36d 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -123,9 +123,9 @@ out:
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
@@ -1859,7 +1859,7 @@ out:
  * should be released by other functions, such as on a superblock put
  * event, regardless of whether this function succeeds for fails.
  */
-int
+static int
 ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
 			    char *cipher_name, size_t *key_size)
 {
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index e09e1fb..6cd1e18 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -156,7 +156,6 @@ struct ecryptfs_auth_tok {
 	} token;
 } __attribute__ ((packed));
 
-int ecryptfs_get_auth_tok_sig(char **sig, struct ecryptfs_auth_tok *auth_tok);
 void ecryptfs_dump_auth_tok(struct ecryptfs_auth_tok *auth_tok);
 extern void ecryptfs_to_hex(char *dst, char *src, size_t src_size);
 extern void ecryptfs_from_hex(char *dst, char *src, int dst_size);
@@ -536,9 +535,6 @@ void ecryptfs_destroy_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat);
 void ecryptfs_destroy_mount_crypt_stat(
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat);
 int ecryptfs_init_crypt_ctx(struct ecryptfs_crypt_stat *crypt_stat);
-int ecryptfs_crypto_api_algify_cipher_name(char **algified_name,
-					   char *cipher_name,
-					   char *chaining_modifier);
 #define ECRYPTFS_LOWER_I_MUTEX_NOT_HELD 0
 #define ECRYPTFS_LOWER_I_MUTEX_HELD 1
 int ecryptfs_write_inode_size_to_metadata(struct file *lower_file,
@@ -579,13 +575,10 @@ int ecryptfs_generate_key_packet_set(char *dest_base,
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
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index d9739bc..63c6ded 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -39,7 +39,7 @@
  * determine the type of error, make appropriate log entries, and
  * return an error code.
  */
-int process_request_key_err(long err_code)
+static int process_request_key_err(long err_code)
 {
 	int rc = 0;
 
@@ -396,6 +396,27 @@ out:
 	return rc;
 }
 
+static int
+ecryptfs_get_auth_tok_sig(char **sig, struct ecryptfs_auth_tok *auth_tok)
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
  * decrypt_pki_encrypted_session_key - Decrypt the session key with the given auth_tok.
  * @auth_tok: The key authentication token used to decrypt the session key
@@ -1082,26 +1103,6 @@ out:
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
  * @crypt_stat: The cryptographic context
-- 
1.5.1.6

