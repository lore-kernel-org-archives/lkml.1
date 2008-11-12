Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbYKLRBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbYKLRBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbYKLRB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:01:26 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:47560 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYKLRBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:01:25 -0500
Date: Wed, 12 Nov 2008 11:01:07 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dustin.kirkland@gmail.com,
       sandeen@redhat.com, tchicks@us.ibm.com, shaggy@us.ibm.com
Subject: [PATCH] eCryptfs: Replace %Z with %z
Message-ID: <20081112170107.GB6842@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20081104213754.GC6675@halcrowt61p.austin.ibm.com> <20081104213908.GA6677@halcrowt61p.austin.ibm.com> <20081106141234.ba53c112.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106141234.ba53c112.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 02:12:34PM -0800, Andrew Morton wrote:
> (I think %Z is a legacy gcc-ism, and that %z is the standard token)

%Z is a gcc-ism. Using %z instead.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/crypto.c    |    8 ++++----
 fs/ecryptfs/keystore.c  |   18 +++++++++---------
 fs/ecryptfs/messaging.c |    4 ++--
 fs/ecryptfs/miscdev.c   |   18 +++++++++---------
 4 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index ea2afd2..490b129 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1679,7 +1679,7 @@ ecryptfs_encrypt_filename(struct ecryptfs_filename *filename,
 			kmalloc(filename->encrypted_filename_size, GFP_KERNEL);
 		if (!filename->encrypted_filename) {
 			printk(KERN_ERR "%s: Out of memory whilst attempting "
-			       "to kmalloc [%Zd] bytes\n", __func__,
+			       "to kmalloc [%zd] bytes\n", __func__,
 			       filename->encrypted_filename_size);
 			rc = -ENOMEM;
 			goto out;
@@ -1752,7 +1752,7 @@ ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
 	*key_tfm = NULL;
 	if (*key_size > ECRYPTFS_MAX_KEY_BYTES) {
 		rc = -EINVAL;
-		printk(KERN_ERR "Requested key size is [%Zd] bytes; maximum "
+		printk(KERN_ERR "Requested key size is [%zd] bytes; maximum "
 		      "allowable is [%d]\n", *key_size, ECRYPTFS_MAX_KEY_BYTES);
 		goto out;
 	}
@@ -1777,7 +1777,7 @@ ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
 	get_random_bytes(dummy_key, *key_size);
 	rc = crypto_blkcipher_setkey(*key_tfm, dummy_key, *key_size);
 	if (rc) {
-		printk(KERN_ERR "Error attempting to set key of size [%Zd] for "
+		printk(KERN_ERR "Error attempting to set key of size [%zd] for "
 		       "cipher [%s]; rc = [%d]\n", *key_size, cipher_name, rc);
 		rc = -EINVAL;
 		goto out;
@@ -2221,7 +2221,7 @@ int ecryptfs_decode_and_decrypt_filename(char **plaintext_name,
 		decoded_name = kmalloc(decoded_name_size, GFP_KERNEL);
 		if (!decoded_name) {
 			printk(KERN_ERR "%s: Out of memory whilst attempting "
-			       "to kmalloc [%Zd] bytes\n", __func__,
+			       "to kmalloc [%zd] bytes\n", __func__,
 			       decoded_name_size);
 			rc = -ENOMEM;
 			goto out;
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 1e16893..5cfd830 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -358,7 +358,7 @@ parse_tag_67_packet(struct ecryptfs_key_record *key_rec,
 	/* verify that everything through the encrypted FEK size is present */
 	if (message_len < 4) {
 		rc = -EIO;
-		printk(KERN_ERR "%s: message_len is [%Zd]; minimum acceptable "
+		printk(KERN_ERR "%s: message_len is [%zd]; minimum acceptable "
 		       "message length is [%d]\n", __func__, message_len, 4);
 		goto out;
 	}
@@ -385,13 +385,13 @@ parse_tag_67_packet(struct ecryptfs_key_record *key_rec,
 	i += data_len;
 	if (message_len < (i + key_rec->enc_key_size)) {
 		rc = -EIO;
-		printk(KERN_ERR "%s: message_len [%Zd]; max len is [%Zd]\n",
+		printk(KERN_ERR "%s: message_len [%zd]; max len is [%zd]\n",
 		       __func__, message_len, (i + key_rec->enc_key_size));
 		goto out;
 	}
 	if (key_rec->enc_key_size > ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES) {
 		rc = -EIO;
-		printk(KERN_ERR "%s: Encrypted key_size [%Zd] larger than "
+		printk(KERN_ERR "%s: Encrypted key_size [%zd] larger than "
 		       "the maximum key size [%d]\n", __func__,
 		       key_rec->enc_key_size,
 		       ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES);
@@ -511,7 +511,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s) {
 		printk(KERN_ERR "%s: Out of memory whilst trying to kmalloc "
-		       "[%d] bytes of kernel memory\n", __func__, sizeof(*s));
+		       "[%zd] bytes of kernel memory\n", __func__, sizeof(*s));
 		goto out;
 	}
 	s->desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
@@ -566,7 +566,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 					    GFP_KERNEL);
 	if (!s->block_aligned_filename) {
 		printk(KERN_ERR "%s: Out of kernel memory whilst attempting to "
-		       "kzalloc [%Zd] bytes\n", __func__,
+		       "kzalloc [%zd] bytes\n", __func__,
 		       s->block_aligned_filename_size);
 		rc = -ENOMEM;
 		goto out_unlock;
@@ -721,7 +721,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 		printk(KERN_ERR "%s: Error setting key for crypto context; "
 		       "rc = [%d]. s->auth_tok->token.password.session_key_"
 		       "encryption_key = [0x%p]; mount_crypt_stat->"
-		       "global_default_fn_cipher_key_bytes = [%Zd]\n", __func__,
+		       "global_default_fn_cipher_key_bytes = [%zd]\n", __func__,
 		       rc,
 		       s->auth_tok->token.password.session_key_encryption_key,
 		       mount_crypt_stat->global_default_fn_cipher_key_bytes);
@@ -792,7 +792,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 	}
 	s->desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 	if (max_packet_size < (1 + 1 + ECRYPTFS_SIG_SIZE + 1 + 1)) {
-		printk(KERN_WARNING "%s: max_packet_size is [%Zd]; it must be "
+		printk(KERN_WARNING "%s: max_packet_size is [%zd]; it must be "
 		       "at least [%d]\n", __func__, max_packet_size,
 			(1 + 1 + ECRYPTFS_SIG_SIZE + 1 + 1));
 		rc = -EINVAL;
@@ -909,7 +909,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 		printk(KERN_ERR "%s: Error setting key for crypto context; "
 		       "rc = [%d]. s->auth_tok->token.password.session_key_"
 		       "encryption_key = [0x%p]; mount_crypt_stat->"
-		       "global_default_fn_cipher_key_bytes = [%Zd]\n", __func__,
+		       "global_default_fn_cipher_key_bytes = [%zd]\n", __func__,
 		       rc,
 		       s->auth_tok->token.password.session_key_encryption_key,
 		       mount_crypt_stat->global_default_fn_cipher_key_bytes);
@@ -936,7 +936,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 	s->i++;
 	(*filename_size) = (s->block_aligned_filename_size - s->i);
 	if (!((*filename_size) > 0 && (*filename_size < PATH_MAX))) {
-		printk(KERN_WARNING "%s: Filename size is [%Zd], which is "
+		printk(KERN_WARNING "%s: Filename size is [%zd], which is "
 		       "invalid\n", __func__, (*filename_size));
 		rc = -EINVAL;
 		goto out_free_unlock;
diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
index e0b0a4e..a8b6cfe 100644
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -193,7 +193,7 @@ ecryptfs_spawn_daemon(struct ecryptfs_daemon **daemon, uid_t euid,
 	(*daemon) = kzalloc(sizeof(**daemon), GFP_KERNEL);
 	if (!(*daemon)) {
 		rc = -ENOMEM;
-		printk(KERN_ERR "%s: Failed to allocate [%Zd] bytes of "
+		printk(KERN_ERR "%s: Failed to allocate [%zd] bytes of "
 		       "GFP_KERNEL memory\n", __func__, sizeof(**daemon));
 		goto out;
 	}
@@ -435,7 +435,7 @@ int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t euid,
 	msg_ctx->msg = kmalloc(msg_size, GFP_KERNEL);
 	if (!msg_ctx->msg) {
 		rc = -ENOMEM;
-		printk(KERN_ERR "%s: Failed to allocate [%Zd] bytes of "
+		printk(KERN_ERR "%s: Failed to allocate [%zd] bytes of "
 		       "GFP_KERNEL memory\n", __func__, msg_size);
 		goto unlock;
 	}
diff --git a/fs/ecryptfs/miscdev.c b/fs/ecryptfs/miscdev.c
index 047ac60..25ca0e1 100644
--- a/fs/ecryptfs/miscdev.c
+++ b/fs/ecryptfs/miscdev.c
@@ -203,7 +203,7 @@ int ecryptfs_send_miscdev(char *data, size_t data_size,
 		if (!msg_ctx->msg) {
 			rc = -ENOMEM;
 			printk(KERN_ERR "%s: Out of memory whilst attempting "
-			       "to kmalloc(%Zd, GFP_KERNEL)\n", __func__,
+			       "to kmalloc(%zd, GFP_KERNEL)\n", __func__,
 			       (sizeof(*msg_ctx->msg) + data_size));
 			goto out_unlock;
 		}
@@ -327,7 +327,7 @@ check_list:
 	if (count < total_length) {
 		rc = 0;
 		printk(KERN_WARNING "%s: Only given user buffer of "
-		       "size [%Zd], but we need [%Zd] to read the "
+		       "size [%zd], but we need [%zd] to read the "
 		       "pending message\n", __func__, count, total_length);
 		goto out_unlock_msg_ctx;
 	}
@@ -381,7 +381,7 @@ static int ecryptfs_miscdev_response(char *data, size_t data_size,
 
 	if ((sizeof(*msg) + msg->data_len) != data_size) {
 		printk(KERN_WARNING "%s: (sizeof(*msg) + msg->data_len) = "
-		       "[%Zd]; data_size = [%Zd]. Invalid packet.\n", __func__,
+		       "[%zd]; data_size = [%zd]. Invalid packet.\n", __func__,
 		       (sizeof(*msg) + msg->data_len), data_size);
 		rc = -EINVAL;
 		goto out;
@@ -426,7 +426,7 @@ ecryptfs_miscdev_write(struct file *file, const char __user *buf,
 	data = kmalloc(count, GFP_KERNEL);
 	if (!data) {
 		printk(KERN_ERR "%s: Out of memory whilst attempting to "
-		       "kmalloc([%Zd], GFP_KERNEL)\n", __func__, count);
+		       "kmalloc([%zd], GFP_KERNEL)\n", __func__, count);
 		goto out;
 	}
 	rc = copy_from_user(data, buf, count);
@@ -441,8 +441,8 @@ ecryptfs_miscdev_write(struct file *file, const char __user *buf,
 	case ECRYPTFS_MSG_RESPONSE:
 		if (count < (1 + 4 + 1 + sizeof(struct ecryptfs_message))) {
 			printk(KERN_WARNING "%s: Minimum acceptable packet "
-			       "size is [%Zd], but amount of data written is "
-			       "only [%Zd]. Discarding response packet.\n",
+			       "size is [%zd], but amount of data written is "
+			       "only [%zd]. Discarding response packet.\n",
 			       __func__,
 			       (1 + 4 + 1 + sizeof(struct ecryptfs_message)),
 			       count);
@@ -460,9 +460,9 @@ ecryptfs_miscdev_write(struct file *file, const char __user *buf,
 		}
 		i += packet_size_length;
 		if ((1 + 4 + packet_size_length + packet_size) != count) {
-			printk(KERN_WARNING "%s: (1 + packet_size_length([%Zd])"
-			       " + packet_size([%Zd]))([%Zd]) != "
-			       "count([%Zd]). Invalid packet format.\n",
+			printk(KERN_WARNING "%s: (1 + packet_size_length([%zd])"
+			       " + packet_size([%zd]))([%zd]) != "
+			       "count([%zd]). Invalid packet format.\n",
 			       __func__, packet_size_length, packet_size,
 			       (1 + packet_size_length + packet_size), count);
 			goto out_free;
-- 
1.5.3.7

