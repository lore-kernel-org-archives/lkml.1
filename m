Return-Path: <linux-kernel-owner+w=401wt.eu-S1764808AbXGYUwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764808AbXGYUwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbXGYUvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:51:46 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48659 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762823AbXGYUvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:51:45 -0400
Date: Wed, 25 Jul 2007 15:51:35 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, toml@us.ibm.com
Subject: [PATCH 4/7] eCryptfs: Comments for some structs
Message-ID: <20070725205135.GU14091@halcrow.austin.ibm.com>
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
> > +struct ecryptfs_global_auth_tok {
> > +#define ECRYPTFS_AUTH_TOK_INVALID 0x00000001
> > +     u32 flags;
> > +     struct list_head mount_crypt_stat_list;
> > +     struct key *global_auth_tok_key;
> > +     struct ecryptfs_auth_tok *global_auth_tok;
> > +     unsigned char sig[ECRYPTFS_SIG_SIZE_HEX + 1];
> > +};
> > +
> > +struct ecryptfs_key_tfm {
> > +     struct crypto_blkcipher *key_tfm;
> > +     size_t key_size;
> > +     struct mutex key_tfm_mutex;
> > +     struct list_head key_tfm_list;
> > +     unsigned char cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE + 1];
> > +};
>
> Please consider commenting your struct fields carefully: it's a
> great way to help other to understand your code.

Add some comments to the ecryptfs_global_auth_tok and ecryptfs_key_tfm
structs to make their functions more easily ascertained.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/ecryptfs_kernel.h |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 69f6a22..e09e1fb 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -273,21 +273,36 @@ struct ecryptfs_dentry_info {
 	struct ecryptfs_crypt_stat *crypt_stat;
 };
 
+/**
+ * ecryptfs_global_auth_tok structs refer to authentication token keys
+ * in the user keyring that apply to newly created files. A list of
+ * these objects hangs off of the mount_crypt_stat struct for any
+ * given eCryptfs mount. This struct maintains a reference to both the
+ * key contents and the key itself so that the key can be put on
+ * unmount.
+ */
 struct ecryptfs_global_auth_tok {
 #define ECRYPTFS_AUTH_TOK_INVALID 0x00000001
 	u32 flags;
-	struct list_head mount_crypt_stat_list;
-	struct key *global_auth_tok_key;
-	struct ecryptfs_auth_tok *global_auth_tok;
-	unsigned char sig[ECRYPTFS_SIG_SIZE_HEX + 1];
+	struct list_head mount_crypt_stat_list; /* Default auth_tok list for
+						 * the mount_crypt_stat */
+	struct key *global_auth_tok_key; /* The key from the user's keyring for
+					  * the sig */
+	struct ecryptfs_auth_tok *global_auth_tok; /* The key contents */
+	unsigned char sig[ECRYPTFS_SIG_SIZE_HEX + 1]; /* The key identifier */
 };
 
+/**
+ * Typically, eCryptfs will use the same ciphers repeatedly throughout
+ * the course of its operations. In order to avoid unnecessarily
+ * destroying and initializing the same cipher repeatedly, eCryptfs
+ * keeps a list of crypto API contexts around to use when needed.
+ */
 struct ecryptfs_key_tfm {
 	struct crypto_blkcipher *key_tfm;
 	size_t key_size;
 	struct mutex key_tfm_mutex;
-	struct list_head key_tfm_list;
+	struct list_head key_tfm_list; /* The module's tfm list */
 	unsigned char cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE + 1];
 };
 
-- 
1.5.1.6

