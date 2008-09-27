Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbYI0C36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbYI0C36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 22:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYI0C2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 22:28:19 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:54614 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbYI0C2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 22:28:10 -0400
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [PATCH 6/6] file capabilities: remove needless (?) bprm_clear_caps calls
Date: Fri, 26 Sep 2008 22:27:50 -0400
Message-Id: <d57038cdc6b35c2522771e8ed5d5d59ce991a6e1.1222451103.git.serue@us.ibm.com>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <06b2774a667bc535442305193417ff1a479ef1aa.1222451103.git.serue@us.ibm.com>
References: <1222482472-12847-1-git-send-email-serue@us.ibm.com>
 <7004aef68d149ffb4a11835f37469948496ffc18.1222451103.git.serue@us.ibm.com>
 <89d3843fc1aaf91ded89d741b2e6d425508e0146.1222451103.git.serue@us.ibm.com>
 <178a4b5984b7559cb5cdb93b242484386ec3e3ab.1222451103.git.serue@us.ibm.com>
 <c9c64bbdfd3f1c665f0d1b08b82f77622be701cc.1222451103.git.serue@us.ibm.com>
 <06b2774a667bc535442305193417ff1a479ef1aa.1222451103.git.serue@us.ibm.com>
In-Reply-To: <7004aef68d149ffb4a11835f37469948496ffc18.1222451103.git.serue@us.ibm.com>
References: <7004aef68d149ffb4a11835f37469948496ffc18.1222451103.git.serue@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two error conditions at the top of get_file_caps() call
bprm_clear_caps().  However, the bprm capabilities have not
yet been set at this point.

Remove those calls (saving another 16 bytes on vmlinux).

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 security/commoncap.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index e5afb7c..43bba7a 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -250,15 +250,11 @@ static int get_file_caps(struct linux_binprm *bprm)
 	struct vfs_cap_data vcaps;
 	struct inode *inode;
 
-	if (!file_caps_enabled) {
-		bprm_clear_caps(bprm);
+	if (!file_caps_enabled)
 		return 0;
-	}
 
-	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
-		bprm_clear_caps(bprm);
+	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID)
 		return 0;
-	}
 
 	dentry = dget(bprm->file->f_dentry);
 	inode = dentry->d_inode;
-- 
1.5.1.1.GIT

