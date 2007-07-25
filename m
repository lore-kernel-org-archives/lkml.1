Return-Path: <linux-kernel-owner+w=401wt.eu-S1764934AbXGYUvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764934AbXGYUvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764140AbXGYUvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:51:10 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46297 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764257AbXGYUvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:51:07 -0400
Date: Wed, 25 Jul 2007 15:50:57 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, toml@us.ibm.com
Subject: [PATCH 3/7] eCryptfs: Grammatical fix (destruct to destroy)
Message-ID: <20070725205057.GT14091@halcrow.austin.ibm.com>
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
> > +int ecryptfs_destruct_crypto(void)
>
> ecryptfs_destroy_crypto would be more grammatically correct ;)

Grammatical fix for some function names.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/crypto.c          |    8 ++++----
 fs/ecryptfs/ecryptfs_kernel.h |    6 +++---
 fs/ecryptfs/main.c            |    4 ++--
 fs/ecryptfs/super.c           |    4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 76bba73..6051dbf 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -213,12 +213,12 @@ ecryptfs_init_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat)
 }
 
 /**
- * ecryptfs_destruct_crypt_stat
+ * ecryptfs_destroy_crypt_stat
  * @crypt_stat: Pointer to the crypt_stat struct to initialize.
  *
  * Releases all memory associated with a crypt_stat struct.
  */
-void ecryptfs_destruct_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat)
+void ecryptfs_destroy_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat)
 {
 	struct ecryptfs_key_sig *key_sig, *key_sig_tmp;
 
@@ -236,7 +236,7 @@ void ecryptfs_destruct_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat)
 	memset(crypt_stat, 0, sizeof(struct ecryptfs_crypt_stat));
 }
 
-void ecryptfs_destruct_mount_crypt_stat(
+void ecryptfs_destroy_mount_crypt_stat(
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat)
 {
 	struct ecryptfs_global_auth_tok *auth_tok, *auth_tok_tmp;
@@ -1880,7 +1880,7 @@ int ecryptfs_init_crypto(void)
 	return 0;
 }
 
-int ecryptfs_destruct_crypto(void)
+int ecryptfs_destroy_crypto(void)
 {
 	struct ecryptfs_key_tfm *key_tfm, *key_tfm_tmp;
 
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 6ddab6c..69f6a22 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -516,8 +516,8 @@ int virt_to_scatterlist(const void *addr, int size, struct scatterlist *sg,
 int ecryptfs_compute_root_iv(struct ecryptfs_crypt_stat *crypt_stat);
 void ecryptfs_rotate_iv(unsigned char *iv);
 void ecryptfs_init_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat);
-void ecryptfs_destruct_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat);
-void ecryptfs_destruct_mount_crypt_stat(
+void ecryptfs_destroy_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat);
+void ecryptfs_destroy_mount_crypt_stat(
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat);
 int ecryptfs_init_crypt_ctx(struct ecryptfs_crypt_stat *crypt_stat);
 int ecryptfs_crypto_api_algify_cipher_name(char **algified_name,
@@ -620,7 +620,7 @@ int
 ecryptfs_add_new_key_tfm(struct ecryptfs_key_tfm **key_tfm, char *cipher_name,
 			 size_t key_size);
 int ecryptfs_init_crypto(void);
-int ecryptfs_destruct_crypto(void);
+int ecryptfs_destroy_crypto(void);
 int ecryptfs_get_tfm_and_mutex_for_cipher_name(struct crypto_blkcipher **tfm,
 					       struct mutex **tfm_mutex,
 					       char *cipher_name);
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index dd9d7b5..d1b9a70 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -846,8 +846,8 @@ static void __exit ecryptfs_exit(void)
 {
 	int rc;
 
-	if ((rc = ecryptfs_destruct_crypto())) {
-		printk(KERN_ERR "Failure whilst attempting to destruct crypto; "
+	if ((rc = ecryptfs_destroy_crypto())) {
+		printk(KERN_ERR "Failure whilst attempting to destroy crypto; "
 		       "rc = [%d]\n", rc);
 	}
 	sysfs_remove_file(&ecryptfs_subsys.kobj,
diff --git a/fs/ecryptfs/super.c b/fs/ecryptfs/super.c
index 7b3f0cc..18d77f8 100644
--- a/fs/ecryptfs/super.c
+++ b/fs/ecryptfs/super.c
@@ -73,7 +73,7 @@ static void ecryptfs_destroy_inode(struct inode *inode)
 	struct ecryptfs_inode_info *inode_info;
 
 	inode_info = ecryptfs_inode_to_private(inode);
-	ecryptfs_destruct_crypt_stat(&inode_info->crypt_stat);
+	ecryptfs_destroy_crypt_stat(&inode_info->crypt_stat);
 	kmem_cache_free(ecryptfs_inode_info_cache, inode_info);
 }
 
@@ -104,7 +104,7 @@ static void ecryptfs_put_super(struct super_block *sb)
 {
 	struct ecryptfs_sb_info *sb_info = ecryptfs_superblock_to_private(sb);
 
-	ecryptfs_destruct_mount_crypt_stat(&sb_info->mount_crypt_stat);
+	ecryptfs_destroy_mount_crypt_stat(&sb_info->mount_crypt_stat);
 	kmem_cache_free(ecryptfs_sb_info_cache, sb_info);
 	ecryptfs_set_superblock_private(sb, NULL);
 }
-- 
1.5.1.6

