Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbZIXIcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbZIXIcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 04:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZIXIce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 04:32:34 -0400
Received: from outbound.icp-qv1-irony-out6.iinet.net.au ([203.59.1.109]:48931
	"EHLO outbound.icp-qv1-irony-out6.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752266AbZIXIbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:31:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMvIukrLO0En/2dsb2JhbADWL4QbBYFYZQ
X-IronPort-AV: E=Sophos;i="4.44,444,1249228800"; 
   d="scan'208";a="9569239"
From: Ian Kent <raven@themaw.net>
Subject: [RFC PATCH 06/11] autofs4 - renamer unhashed to active in
	autofs4_lookup()
To: Sage Weil <sage@newdream.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Andreas Dilger <adilger@sun.com>, Yehuda Saheh <yehuda@newdream.net>,
       Jim Garlick <garlick@llnl.gov>
Date: Thu, 24 Sep 2009 16:21:58 +0800
Message-ID: <20090924082158.22151.20833.stgit@zeus.themaw.net>
In-Reply-To: <20090924082036.22151.85151.stgit@zeus.themaw.net>
References: <20090924082036.22151.85151.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the variable unhashed to active in autofs4_lookup() to
better reflect its usage.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/root.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 305136b..961ff37 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -514,7 +514,7 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 {
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
-	struct dentry *expiring, *unhashed;
+	struct dentry *expiring, *active;
 	int oz_mode;
 
 	DPRINTK("name = %.*s",
@@ -530,9 +530,9 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
 		 current->pid, task_pgrp_nr(current), sbi->catatonic, oz_mode);
 
-	unhashed = autofs4_lookup_active(sbi, dentry->d_parent, &dentry->d_name);
-	if (unhashed) {
-		dentry = unhashed;
+	active = autofs4_lookup_active(sbi, dentry->d_parent, &dentry->d_name);
+	if (active) {
+		dentry = active;
 		ino = autofs4_dentry_ino(dentry);
 	} else {
 		/*
@@ -600,8 +600,8 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 			if (sigismember (sigset, SIGKILL) ||
 			    sigismember (sigset, SIGQUIT) ||
 			    sigismember (sigset, SIGINT)) {
-			    if (unhashed)
-				dput(unhashed);
+			    if (active)
+				dput(active);
 			    return ERR_PTR(-ERESTARTNOINTR);
 			}
 		}
@@ -633,14 +633,14 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 		else
 			dentry = ERR_PTR(-ENOENT);
 
-		if (unhashed)
-			dput(unhashed);
+		if (active)
+			dput(active);
 
 		return dentry;
 	}
 
-	if (unhashed)
-		return unhashed;
+	if (active)
+		return active;
 
 	return NULL;
 }

