Return-Path: <linux-kernel-owner+w=401wt.eu-S1762763AbYDAVMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762763AbYDAVMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762131AbYDAVIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:08:17 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45635 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761060AbYDAVIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:08:13 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 12/14] Unionfs: do not over-decrement lower superblock refs on remount
Date: Tue,  1 Apr 2008 17:06:54 -0400
Message-Id: <12070840222576-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
References: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index e5cb235..4cddc83 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -755,7 +755,7 @@ out_no_change:
 	/* grab new lower super references; release old ones */
 	for (i = 0; i < new_branches; i++)
 		atomic_inc(&new_data[i].sb->s_active);
-	for (i = 0; i < new_branches; i++)
+	for (i = 0; i < sbmax(sb); i++)
 		atomic_dec(&UNIONFS_SB(sb)->data[i].sb->s_active);
 
 	/* copy new vectors into their correct place */
-- 
1.5.2.2

