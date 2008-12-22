Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbYLVVwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbYLVVwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755840AbYLVVs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:48:58 -0500
Received: from cantor.suse.de ([195.135.220.2]:41564 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827AbYLVVs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:48:57 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 08/56] reiserfs: Use sb_any_quota_loaded() instead of sb_any_quota_enabled().
Date: Mon, 22 Dec 2008 13:47:49 -0800
Message-Id: <1229982517-3455-9-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/reiserfs/super.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 663a91f..a9b393a 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -994,8 +994,7 @@ static int reiserfs_parse_options(struct super_block *s, char *options,	/* strin
 		if (c == 'u' || c == 'g') {
 			int qtype = c == 'u' ? USRQUOTA : GRPQUOTA;
 
-			if ((sb_any_quota_enabled(s) ||
-			     sb_any_quota_suspended(s)) &&
+			if (sb_any_quota_loaded(s) &&
 			    (!*arg != !REISERFS_SB(s)->s_qf_names[qtype])) {
 				reiserfs_warning(s,
 						 "reiserfs_parse_options: cannot change journaled quota options when quota turned on.");
@@ -1041,8 +1040,7 @@ static int reiserfs_parse_options(struct super_block *s, char *options,	/* strin
 						 "reiserfs_parse_options: unknown quota format specified.");
 				return 0;
 			}
-			if ((sb_any_quota_enabled(s) ||
-			     sb_any_quota_suspended(s)) &&
+			if (sb_any_quota_loaded(s) &&
 			    *qfmt != REISERFS_SB(s)->s_jquota_fmt) {
 				reiserfs_warning(s,
 						 "reiserfs_parse_options: cannot change journaled quota options when quota turned on.");
@@ -1067,7 +1065,7 @@ static int reiserfs_parse_options(struct super_block *s, char *options,	/* strin
 	}
 	/* This checking is not precise wrt the quota type but for our purposes it is sufficient */
 	if (!(*mount_options & (1 << REISERFS_QUOTA))
-	    && sb_any_quota_enabled(s)) {
+	    && sb_any_quota_loaded(s)) {
 		reiserfs_warning(s,
 				 "reiserfs_parse_options: quota options must be present when quota is turned on.");
 		return 0;
-- 
1.5.6

