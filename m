Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998AbYGNWDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbYGNWDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757362AbYGNWCC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:02:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:33192 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254AbYGNWCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:02:00 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 03/17] ocfs2: fix printk format warnings with OCFS2_FS_STATS=n
Date: Mon, 14 Jul 2008 15:01:36 -0700
Message-Id: <1216072910-27226-4-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
References: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings when OCFS2_FS_STATS=n:

linux-next-20080528/fs/ocfs2/dlmglue.c: In function 'ocfs2_dlm_seq_show':
linux-next-20080528/fs/ocfs2/dlmglue.c:2623: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type 'int'
linux-next-20080528/fs/ocfs2/dlmglue.c:2623: warning: format '%llu' expects type 'long long unsigned int', but argument 4 has type 'int'
linux-next-20080528/fs/ocfs2/dlmglue.c:2623: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'int'
linux-next-20080528/fs/ocfs2/dlmglue.c:2623: warning: format '%llu' expects type 'long long unsigned int', but argument 8 has type 'int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlmglue.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 80537b7..eae3d64 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2592,12 +2592,12 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 # define lock_max_exmode(_l)		(_l)->l_lock_max_exmode
 # define lock_refresh(_l)		(_l)->l_lock_refresh
 #else
-# define lock_num_prmode(_l)		(0)
-# define lock_num_exmode(_l)		(0)
+# define lock_num_prmode(_l)		(0ULL)
+# define lock_num_exmode(_l)		(0ULL)
 # define lock_num_prmode_failed(_l)	(0)
 # define lock_num_exmode_failed(_l)	(0)
-# define lock_total_prmode(_l)		(0)
-# define lock_total_exmode(_l)		(0)
+# define lock_total_prmode(_l)		(0ULL)
+# define lock_total_exmode(_l)		(0ULL)
 # define lock_max_prmode(_l)		(0)
 # define lock_max_exmode(_l)		(0)
 # define lock_refresh(_l)		(0)
-- 
1.5.4.1

