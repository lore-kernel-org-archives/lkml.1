Return-Path: <linux-kernel-owner+w=401wt.eu-S932770AbXLRGYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770AbXLRGYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 01:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbXLRGYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 01:24:32 -0500
Received: from hs-out-0708.google.com ([64.233.178.250]:36408 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753083AbXLRGYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 01:24:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:content-type:date:message-id:mime-version:x-mailer:from;
        b=EMMQbaG7JxSMs8ZMk/klO+G1djbq6lrK3b46RY/+e9EzTUGSetf2QmJh0xylqFB1k8hZP2j6HFghVELbQ1Qr+/4y8qRnGKZ+GYXKK7K3sxHwHzFBISZ/fTjBuh3Fhrg8W1Syj9g75XIZBBh3RB3E3zssWObvfMe8bH06t9dZkLY=
Subject: [PATCH] eCryptfs: Change the type of cipher_code from u16 to u8
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net, mhalcrow@us.ibm.com
Content-Type: multipart/mixed; boundary="=-/JCOvnTqLfZrhVMckZYX"
Date: Tue, 18 Dec 2007 00:24:34 -0600
Message-Id: <1197959074.10903.18.camel@buster2>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
From: Trevor Highland <thighlan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/JCOvnTqLfZrhVMckZYX
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Only one byte of cipher_code is being written to the file header so it
should be of type u8.

Trevor

--=-/JCOvnTqLfZrhVMckZYX
Content-Disposition: attachment; filename=0001-Change-the-type-of-cipher_code-from-u16-to-u8.txt
Content-Type: application/mbox; name=0001-Change-the-type-of-cipher_code-from-u16-to-u8.txt
Content-Transfer-Encoding: 7bit

>From 699c8188fd198cfecab865afdcd104b8e35bee4b Mon Sep 17 00:00:00 2001
From: Trevor Highland <trevor.highland@gmail.com>
Date: Thu, 13 Dec 2007 00:41:42 -0600
Subject: [PATCH] [PATCH] Change the type of cipher_code from u16 to u8.

Signed-off-by: Trevor Highland <trevor.highland@gmail.com>
---
 fs/ecryptfs/crypto.c          |    8 ++++----
 fs/ecryptfs/ecryptfs_kernel.h |    4 ++--
 fs/ecryptfs/keystore.c        |    8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 949fe44..5804400 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1129,7 +1129,7 @@ write_ecryptfs_flags(char *page_virt, struct ecryptfs_crypt_stat *crypt_stat,
 
 struct ecryptfs_cipher_code_str_map_elem {
 	char cipher_str[16];
-	u16 cipher_code;
+	u8 cipher_code;
 };
 
 /* Add support for additional ciphers by adding elements here. The
@@ -1153,10 +1153,10 @@ ecryptfs_cipher_code_str_map[] = {
  *
  * Returns zero on no match, or the cipher code on match
  */
-u16 ecryptfs_code_for_cipher_string(struct ecryptfs_crypt_stat *crypt_stat)
+u8 ecryptfs_code_for_cipher_string(struct ecryptfs_crypt_stat *crypt_stat)
 {
 	int i;
-	u16 code = 0;
+	u8 code = 0;
 	struct ecryptfs_cipher_code_str_map_elem *map =
 		ecryptfs_cipher_code_str_map;
 
@@ -1188,7 +1188,7 @@ u16 ecryptfs_code_for_cipher_string(struct ecryptfs_crypt_stat *crypt_stat)
  *
  * Returns zero on success
  */
-int ecryptfs_cipher_code_to_string(char *str, u16 cipher_code)
+int ecryptfs_cipher_code_to_string(char *str, u8 cipher_code)
 {
 	int rc = 0;
 	int i;
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 114cb86..a991b4e 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -562,8 +562,8 @@ int ecryptfs_read_and_validate_header_region(char *data,
 					     struct inode *ecryptfs_inode);
 int ecryptfs_read_and_validate_xattr_region(char *page_virt,
 					    struct dentry *ecryptfs_dentry);
-u16 ecryptfs_code_for_cipher_string(struct ecryptfs_crypt_stat *crypt_stat);
-int ecryptfs_cipher_code_to_string(char *str, u16 cipher_code);
+u8 ecryptfs_code_for_cipher_string(struct ecryptfs_crypt_stat *crypt_stat);
+int ecryptfs_cipher_code_to_string(char *str, u8 cipher_code);
 void ecryptfs_set_default_sizes(struct ecryptfs_crypt_stat *crypt_stat);
 int ecryptfs_generate_key_packet_set(char *dest_base,
 				     struct ecryptfs_crypt_stat *crypt_stat,
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 263fed8..0fe7c13 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -189,7 +189,7 @@ out:
 }
 
 static int
-parse_tag_65_packet(struct ecryptfs_session_key *session_key, u16 *cipher_code,
+parse_tag_65_packet(struct ecryptfs_session_key *session_key, u8 *cipher_code,
 		    struct ecryptfs_message *msg)
 {
 	size_t i = 0;
@@ -275,7 +275,7 @@ out:
 
 
 static int
-write_tag_66_packet(char *signature, size_t cipher_code,
+write_tag_66_packet(char *signature, u8 cipher_code,
 		    struct ecryptfs_crypt_stat *crypt_stat, char **packet,
 		    size_t *packet_len)
 {
@@ -428,7 +428,7 @@ static int
 decrypt_pki_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 				  struct ecryptfs_crypt_stat *crypt_stat)
 {
-	u16 cipher_code = 0;
+	u8 cipher_code = 0;
 	struct ecryptfs_msg_ctx *msg_ctx;
 	struct ecryptfs_message *msg = NULL;
 	char *auth_tok_sig;
@@ -1537,7 +1537,7 @@ write_tag_3_packet(char *dest, size_t *remaining_bytes,
 	struct scatterlist dst_sg;
 	struct scatterlist src_sg;
 	struct mutex *tfm_mutex = NULL;
-	size_t cipher_code;
+	u8 cipher_code;
 	size_t packet_size_length;
 	size_t max_packet_size;
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
-- 
1.5.2.5


--=-/JCOvnTqLfZrhVMckZYX--

