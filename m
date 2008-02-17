Return-Path: <linux-kernel-owner+w=401wt.eu-S1760041AbYBQDCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041AbYBQDCB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 22:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbYBQC6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:58:34 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36363 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757697AbYBQC6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:58:30 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 08/17] Unionfs: improve debugging in copy_attr_times
Date: Sat, 16 Feb 2008 21:57:17 -0500
Message-Id: <1203217050889-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
References: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/subr.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/subr.c b/fs/unionfs/subr.c
index 68a6280..1a40f63 100644
--- a/fs/unionfs/subr.c
+++ b/fs/unionfs/subr.c
@@ -247,8 +247,14 @@ void unionfs_copy_attr_times(struct inode *upper)
 	int bindex;
 	struct inode *lower;
 
-	if (!upper || ibstart(upper) < 0)
+	if (!upper)
 		return;
+	if (ibstart(upper) < 0) {
+#ifdef CONFIG_UNION_FS_DEBUG
+		WARN_ON(ibstart(upper) < 0);
+#endif /* CONFIG_UNION_FS_DEBUG */
+		return;
+	}
 	for (bindex = ibstart(upper); bindex <= ibend(upper); bindex++) {
 		lower = unionfs_lower_inode_idx(upper, bindex);
 		if (!lower)
-- 
1.5.2.2

