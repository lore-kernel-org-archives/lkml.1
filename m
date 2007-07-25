Return-Path: <linux-kernel-owner+w=401wt.eu-S1764120AbXGYUuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764120AbXGYUuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760081AbXGYUuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:50:37 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43158 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbXGYUug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:50:36 -0400
Date: Wed, 25 Jul 2007 15:50:19 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, toml@us.ibm.com
Subject: [PATCH 2/7] eCryptfs: Collapse flag set into one statement
Message-ID: <20070725205019.GS14091@halcrow.austin.ibm.com>
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
> > +     crypt_stat->flags |= ECRYPTFS_ENCRYPTED;
> > +     crypt_stat->flags |= ECRYPTFS_KEY_VALID;
>
> Maybe the compiler can optimise those two statements, but we'd
> normally provide it with some manual help.

This patch provides the compiler with some manual help for
optimizing the setting of some flags.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/crypto.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 14cc1f5..76bba73 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1029,8 +1029,7 @@ int ecryptfs_new_file_context(struct dentry *ecryptfs_dentry)
 	int rc = 0;
 
 	ecryptfs_set_default_crypt_stat_vals(crypt_stat, mount_crypt_stat);
-	crypt_stat->flags |= ECRYPTFS_ENCRYPTED;
-	crypt_stat->flags |= ECRYPTFS_KEY_VALID;
+	crypt_stat->flags |= (ECRYPTFS_ENCRYPTED | ECRYPTFS_KEY_VALID);
 	ecryptfs_copy_mount_wide_flags_to_inode_flags(crypt_stat,
 						      mount_crypt_stat);
 	rc = ecryptfs_copy_mount_wide_sigs_to_inode_sigs(crypt_stat,
-- 
1.5.1.6

