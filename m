Return-Path: <linux-kernel-owner+w=401wt.eu-S1757128AbYGAN3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128AbYGAN3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbYGAN3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:29:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44953 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbYGAN3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:29:11 -0400
To: mhalcrow@us.ibm.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [patch resend] ecryptfs: string copy cleanup
Message-Id: <E1KDfuj-0005FW-7X@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 01 Jul 2008 15:28:57 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Clean up overcomplicated string copy, which also gets rid of this
bogus warning:

fs/ecryptfs/main.c: In function 'ecryptfs_parse_options':
include/asm/arch/string_32.h:75: warning: array subscript is above array bounds

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ecryptfs/main.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

Index: linux-2.6/fs/ecryptfs/main.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/main.c	2008-06-09 14:14:27.000000000 +0200
+++ linux-2.6/fs/ecryptfs/main.c	2008-06-13 13:04:04.000000000 +0200
@@ -314,7 +314,6 @@ static int ecryptfs_parse_options(struct
 	char *cipher_name_dst;
 	char *cipher_name_src;
 	char *cipher_key_bytes_src;
-	int cipher_name_len;
 
 	if (!options) {
 		rc = -EINVAL;
@@ -395,17 +394,12 @@ static int ecryptfs_parse_options(struct
 		goto out;
 	}
 	if (!cipher_name_set) {
-		cipher_name_len = strlen(ECRYPTFS_DEFAULT_CIPHER);
-		if (unlikely(cipher_name_len
-			     >= ECRYPTFS_MAX_CIPHER_NAME_SIZE)) {
-			rc = -EINVAL;
-			BUG();
-			goto out;
-		}
-		memcpy(mount_crypt_stat->global_default_cipher_name,
-		       ECRYPTFS_DEFAULT_CIPHER, cipher_name_len);
-		mount_crypt_stat->global_default_cipher_name[cipher_name_len]
-		    = '\0';
+		int cipher_name_len = strlen(ECRYPTFS_DEFAULT_CIPHER);
+
+		BUG_ON(cipher_name_len >= ECRYPTFS_MAX_CIPHER_NAME_SIZE);
+
+		strcpy(mount_crypt_stat->global_default_cipher_name,
+		       ECRYPTFS_DEFAULT_CIPHER);
 	}
 	if (!cipher_key_bytes_set) {
 		mount_crypt_stat->global_default_cipher_key_size = 0;

