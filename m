Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbYGUOwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbYGUOwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 10:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbYGUOwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 10:52:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbYGUOwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 10:52:11 -0400
Subject: parser: add const to parser token table
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: Alexander Viro <aviro@redhat.com>, Evgeniy Dushistov <dushistov@mail.ru>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Mon, 21 Jul 2008 15:50:06 +0100
Message-Id: <1216651806.3507.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds a "const" to the parser token table. I've done an
allmodconfig build to see if this produces any warnings/failures and the
patch includes a fix for the only warning that was produced.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Acked-by: Alexander Viro <aviro@redhat.com>
Acked-by: Evgeniy Dushistov <dushistov@mail.ru>

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 85b22b5..506f724 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1232,7 +1232,7 @@ static int ufs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 {
 	struct ufs_sb_info *sbi = UFS_SB(vfs->mnt_sb);
 	unsigned mval = sbi->s_mount_opt & UFS_MOUNT_UFSTYPE;
-	struct match_token *tp = tokens;
+	const struct match_token *tp = tokens;
 
 	while (tp->token != Opt_onerror_panic && tp->token != mval)
 		++tp;
diff --git a/include/linux/parser.h b/include/linux/parser.h
index 7dcd050..cc554ca 100644
--- a/include/linux/parser.h
+++ b/include/linux/parser.h
@@ -14,7 +14,7 @@ struct match_token {
 	const char *pattern;
 };
 
-typedef struct match_token match_table_t[];
+typedef const struct match_token match_table_t[];
 
 /* Maximum number of arguments that match_token will find in a pattern */
 enum {MAX_OPT_ARGS = 3};


