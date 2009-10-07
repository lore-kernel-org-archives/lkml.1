Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbZJGErY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbZJGErY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 00:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbZJGErH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 00:47:07 -0400
Received: from mail.perches.com ([173.55.12.10]:1975 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbZJGErC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 00:47:02 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com
Subject: [PATCH 8/8] fs/xfs/xfs_log_recover.c: Use %pU to print UUIDs
Date: Tue,  6 Oct 2009 21:45:41 -0700
Message-Id: <d3ce3dab424deedd43322990503af8944f751a73.1254884776.git.joe@perches.com>
X-Mailer: git-send-email 1.6.5.rc2.17.gdbc1b.dirty
In-Reply-To: <1254890742-28245-1-git-send-email-joe@perches.com>
References: <1254890742-28245-1-git-send-email-joe@perches.com>
In-Reply-To: <cover.1254884776.git.joe@perches.com>
References: <cover.1254884776.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/xfs/xfs_log_recover.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1099395..3b8e3df 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -225,16 +225,10 @@ xlog_header_check_dump(
 	xfs_mount_t		*mp,
 	xlog_rec_header_t	*head)
 {
-	int			b;
-
-	cmn_err(CE_DEBUG, "%s:  SB : uuid = ", __func__);
-	for (b = 0; b < 16; b++)
-		cmn_err(CE_DEBUG, "%02x", ((__uint8_t *)&mp->m_sb.sb_uuid)[b]);
-	cmn_err(CE_DEBUG, ", fmt = %d\n", XLOG_FMT);
-	cmn_err(CE_DEBUG, "    log : uuid = ");
-	for (b = 0; b < 16; b++)
-		cmn_err(CE_DEBUG, "%02x", ((__uint8_t *)&head->h_fs_uuid)[b]);
-	cmn_err(CE_DEBUG, ", fmt = %d\n", be32_to_cpu(head->h_fmt));
+	cmn_err(CE_DEBUG, "%s:  SB : uuid = %pU, fmt = %d\n",
+		__func__, &mp->m_sb.sb_uuid, XLOG_FMT);
+	cmn_err(CE_DEBUG, "    log : uuid = %pU, fmt = %d\n",
+		&head->h_fs_uuid, be32_to_cpu(head->h_fmt));
 }
 #else
 #define xlog_header_check_dump(mp, head)
-- 
1.6.3.1.10.g659a0.dirty

