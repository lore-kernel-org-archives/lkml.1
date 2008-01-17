Return-Path: <linux-kernel-owner+w=401wt.eu-S1761174AbYAQWpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761174AbYAQWpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760020AbYAQWhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:37:00 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:36370 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760115AbYAQWgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:36:50 -0500
From: Mark Fasheh <mark.fasheh@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 25/30] ocfs2: convert byte order of constant instead of variable
Date: Thu, 17 Jan 2008 14:35:51 -0800
Message-Id: <1200609356-17788-26-git-send-email-mark.fasheh@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

Convert byte order of constant instead of variable it will be done at
compile time vs run time. Remove unused le32_and_cpu.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/endian.h |    5 -----
 fs/ocfs2/inode.c  |    2 +-
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/endian.h b/fs/ocfs2/endian.h
index ff25762..1942e09 100644
--- a/fs/ocfs2/endian.h
+++ b/fs/ocfs2/endian.h
@@ -37,11 +37,6 @@ static inline void le64_add_cpu(__le64 *var, u64 val)
 	*var = cpu_to_le64(le64_to_cpu(*var) + val);
 }
 
-static inline void le32_and_cpu(__le32 *var, u32 val)
-{
-	*var = cpu_to_le32(le32_to_cpu(*var) & val);
-}
-
 static inline void be32_add_cpu(__be32 *var, u32 val)
 {
 	*var = cpu_to_be32(be32_to_cpu(*var) + val);
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 5e19c11..7e9e4c7 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -620,7 +620,7 @@ static int ocfs2_remove_inode(struct inode *inode,
 	}
 
 	di->i_dtime = cpu_to_le64(CURRENT_TIME.tv_sec);
-	le32_and_cpu(&di->i_flags, ~(OCFS2_VALID_FL | OCFS2_ORPHANED_FL));
+	di->i_flags &= cpu_to_le32(~(OCFS2_VALID_FL | OCFS2_ORPHANED_FL));
 
 	status = ocfs2_journal_dirty(handle, di_bh);
 	if (status < 0) {
-- 
1.5.3.6

