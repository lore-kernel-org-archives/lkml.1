Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbZI2FBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbZI2FBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 01:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZI2FBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 01:01:37 -0400
Received: from mail.perches.com ([173.55.12.10]:1375 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbZI2FBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 01:01:23 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@nokia.com>, Alex Elder <aelder@sgi.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@lst.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jgarzik@redhat.com>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Matt Mackall <mpm@selenic.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Neil Brown <neilb@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       xfs-masters@oss.sgi.com, Dave Chinner <david@fromorbit.com>,
       xfs@oss.sgi.com
Subject: [PATCH 9/9] fs/xfs/xfs_log_recover.c: Use %pU to print UUIDs
Date: Mon, 28 Sep 2009 22:01:11 -0700
Message-Id: <a1ef34a30fa69b35db003f2e68445c4eb0a03a93.1254193019.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1254193019.git.joe@perches.com>
References: <cover.1254193019.git.joe@perches.com>
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

