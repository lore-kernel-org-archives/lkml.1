Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbYIXWMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbYIXWMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 18:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYIXWBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 18:01:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbYIXWAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:00:47 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: joel.becker@oracle.com, ocfs2-devel@oss.oracle.com,
       linux-fsdevel@vger.kernel.org, Sunil Mushran <sunil.mushran@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 39/39] ocfs2: Add xattr mount option in ocfs2_show_options()
Date: Wed, 24 Sep 2008 15:01:20 -0700
Message-Id: <1222293680-15451-40-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sunil Mushran <sunil.mushran@oracle.com>

Patch adds check for [no]user_xattr in ocfs2_show_options() that completes
the list of all mount options.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/super.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 39f6238..6b4b86e 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1010,6 +1010,11 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 		seq_printf(s, ",cluster_stack=%.*s", OCFS2_STACK_LABEL_LEN,
 			   osb->osb_cluster_stack);
 
+	if (opts & OCFS2_MOUNT_NOUSERXATTR)
+		seq_printf(s, ",nouser_xattr");
+	else
+		seq_printf(s, ",user_xattr");
+
 	if (opts & OCFS2_MOUNT_INODE64)
 		seq_printf(s, ",inode64");
 
-- 
1.5.4.5

