Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbYGQNZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbYGQNZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 09:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029AbYGQNYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 09:24:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbYGQNYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 09:24:53 -0400
Subject: [RFC] parser: add const to parser token table
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, Alexander Viro <aviro@redhat.com>,
       dushistov@mail.ru
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Thu, 17 Jul 2008 14:22:52 +0100
Message-Id: <1216300972.4011.291.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Any objections to the following patch? If not I'll send it on to Linus.

This patch adds a "const" to the parser token table. I've done an
allmodconfig build to see if this produces any warnings/failures and the
patch includes a fix for the only warning that was produced.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Alexander Viro <aviro@redhat.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>


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


