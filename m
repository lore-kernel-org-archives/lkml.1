Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab0BCQMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:12:35 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:48235 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757388Ab0BCQMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:12:34 -0500
Date: Wed, 3 Feb 2010 17:12:45 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: linux-kernel@vger.kernel.org, sfrench@samba.org, jlayton@redhat.com,
       linux-cifs-client@lists.samba.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: Obsolete config in kernel source (CIFS_QUOTA)
Message-ID: <20100203161245.GA7638@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	The CIFS Quota module seems to be a bit larger than the other
unreachable code blocks I've come acros recently. Is the KConfig Item
simply missing here? If not maybe the unreachable code should be
removed from the kernel tree?

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

----
>From 69f2e89897e197bea5984e4c2f98bdb6ec3f48b0 Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Wed, 3 Feb 2010 15:40:44 +0100
Subject: [PATCH] Getting rid of CONFIG_CIFS_QUOTA

CONFIG_CIFS_QUOTA has been a Zombi Feature for a really long time now
and doesn't seem to be developed on. So this change gets rid of the
unused Codepath.

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
---
 fs/cifs/cifsfs.c |  107 ------------------------------------------------------
 1 files changed, 0 insertions(+), 107 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8c6a036..0135079 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -49,10 +49,6 @@
 #include "cifs_spnego.h"
 #define CIFS_MAGIC_NUMBER 0xFF534D42	/* the first four bytes of SMB PDUs */
 
-#ifdef CONFIG_CIFS_QUOTA
-static const struct quotactl_ops cifs_quotactl_ops;
-#endif /* QUOTA */
-
 int cifsFYI = 0;
 int cifsERROR = 1;
 int traceSMB = 0;
@@ -138,9 +134,6 @@ cifs_read_super(struct super_block *sb, void *data,
 /*	if (cifs_sb->tcon->ses->server->maxBuf > MAX_CIFS_HDR_SIZE + 512)
 	    sb->s_blocksize =
 		cifs_sb->tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE; */
-#ifdef CONFIG_CIFS_QUOTA
-	sb->s_qcop = &cifs_quotactl_ops;
-#endif
 	sb->s_blocksize = CIFS_MAX_MSGSIZE;
 	sb->s_blocksize_bits = 14;	/* default 2**14 = CIFS_MAX_MSGSIZE */
 	inode = cifs_root_iget(sb, ROOT_I);
@@ -421,106 +414,6 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
 	return 0;
 }
 
-#ifdef CONFIG_CIFS_QUOTA
-int cifs_xquota_set(struct super_block *sb, int quota_type, qid_t qid,
-		struct fs_disk_quota *pdquota)
-{
-	int xid;
-	int rc = 0;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
-	struct cifsTconInfo *pTcon;
-
-	if (cifs_sb)
-		pTcon = cifs_sb->tcon;
-	else
-		return -EIO;
-
-
-	xid = GetXid();
-	if (pTcon) {
-		cFYI(1, ("set type: 0x%x id: %d", quota_type, qid));
-	} else
-		rc = -EIO;
-
-	FreeXid(xid);
-	return rc;
-}
-
-int cifs_xquota_get(struct super_block *sb, int quota_type, qid_t qid,
-		    struct fs_disk_quota *pdquota)
-{
-	int xid;
-	int rc = 0;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
-	struct cifsTconInfo *pTcon;
-
-	if (cifs_sb)
-		pTcon = cifs_sb->tcon;
-	else
-		return -EIO;
-
-	xid = GetXid();
-	if (pTcon) {
-		cFYI(1, ("set type: 0x%x id: %d", quota_type, qid));
-	} else
-		rc = -EIO;
-
-	FreeXid(xid);
-	return rc;
-}
-
-int cifs_xstate_set(struct super_block *sb, unsigned int flags, int operation)
-{
-	int xid;
-	int rc = 0;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
-	struct cifsTconInfo *pTcon;
-
-	if (cifs_sb)
-		pTcon = cifs_sb->tcon;
-	else
-		return -EIO;
-
-	xid = GetXid();
-	if (pTcon) {
-		cFYI(1, ("flags: 0x%x operation: 0x%x", flags, operation));
-	} else
-		rc = -EIO;
-
-	FreeXid(xid);
-	return rc;
-}
-
-int cifs_xstate_get(struct super_block *sb, struct fs_quota_stat *qstats)
-{
-	int xid;
-	int rc = 0;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
-	struct cifsTconInfo *pTcon;
-
-	if (cifs_sb)
-		pTcon = cifs_sb->tcon;
-	else
-		return -EIO;
-
-	xid = GetXid();
-	if (pTcon) {
-		cFYI(1, ("pqstats %p", qstats));
-	} else
-		rc = -EIO;
-
-	FreeXid(xid);
-	return rc;
-}
-
-static const struct quotactl_ops cifs_quotactl_ops = {
-	.set_xquota	= cifs_xquota_set,
-	.get_xquota	= cifs_xquota_get,
-	.set_xstate	= cifs_xstate_set,
-	.get_xstate	= cifs_xstate_get,
-};
-#endif
-
 static void cifs_umount_begin(struct super_block *sb)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
-- 
1.6.3.3

