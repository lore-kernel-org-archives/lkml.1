Return-Path: <linux-kernel-owner+w=401wt.eu-S1758443AbYGNWE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbYGNWE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbYGNWCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:02:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:33210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758170AbYGNWCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:02:06 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>,
       Wengang Wang <wen.gang.wang@oracle.com>
Subject: [PATCH 06/17] ocfs2: Handle error during journal load
Date: Mon, 14 Jul 2008 15:01:39 -0700
Message-Id: <1216072910-27226-7-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
References: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wengang Wang <wen.gang.wang@oracle.com>

This patch ensures the mount fails if the fs is unable to load the journal.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Acked-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/super.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index df63ba2..ccecfe5 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1703,7 +1703,11 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
 	local = ocfs2_mount_local(osb);
 
 	/* will play back anything left in the journal. */
-	ocfs2_journal_load(osb->journal, local);
+	status = ocfs2_journal_load(osb->journal, local);
+	if (status < 0) {
+		mlog(ML_ERROR, "ocfs2 journal load failed! %d\n", status);
+		goto finally;
+	}
 
 	if (dirty) {
 		/* recover my local alloc if we didn't unmount cleanly. */
-- 
1.5.4.1

