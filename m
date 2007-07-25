Return-Path: <linux-kernel-owner+w=401wt.eu-S1763923AbXGYUuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763923AbXGYUuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbXGYUtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:49:52 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:47942 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769AbXGYUtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:49:51 -0400
Date: Wed, 25 Jul 2007 15:49:40 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, toml@us.ibm.com
Subject: [PATCH 1/7] eCryptfs: Remove unnecessary BUG_ON
Message-ID: <20070725204940.GR14091@halcrow.austin.ibm.com>
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
> > +     mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
> > +     BUG_ON(mount_crypt_stat->num_global_auth_toks == 0);
> > +     mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
>
> That's odd-looking.  If it was a bug for num_global_auth_toks to be
> zero, and if that mutex protects num_global_auth_toks then as soon
> as the lock gets dropped, another thread can make
> num_global_auth_toks zero, hence the bug is present.  Perhaps?

That was serving as an internal sanity check that should not have made
it into the final patch set in the first place. This patch removes it.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/crypto.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 129ed13..14cc1f5 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1029,9 +1029,6 @@ int ecryptfs_new_file_context(struct dentry *ecryptfs_dentry)
 	int rc = 0;
 
 	ecryptfs_set_default_crypt_stat_vals(crypt_stat, mount_crypt_stat);
-	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
-	BUG_ON(mount_crypt_stat->num_global_auth_toks == 0);
-	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
 	crypt_stat->flags |= ECRYPTFS_ENCRYPTED;
 	crypt_stat->flags |= ECRYPTFS_KEY_VALID;
 	ecryptfs_copy_mount_wide_flags_to_inode_flags(crypt_stat,
-- 
1.5.1.6

