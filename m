Return-Path: <linux-kernel-owner+w=401wt.eu-S933403AbXJLWaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403AbXJLWaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932428AbXJLWTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:19:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:53212 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410AbXJLWTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:19:13 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 21/75] sysfs: cosmetic changes in sysfs_lookup()
Date: Fri, 12 Oct 2007 15:16:25 -0700
Message-Id: <11922275371856-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922275312531-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

* remove space between * and symbol name in variable declaration.

* kill unnecessary new line.

* kill 'found' and test 'sd' instead.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 837073d..5da8da8 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -756,24 +756,19 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 				struct nameidata *nd)
 {
 	struct dentry *ret = NULL;
-	struct sysfs_dirent * parent_sd = dentry->d_parent->d_fsdata;
-	struct sysfs_dirent * sd;
+	struct sysfs_dirent *parent_sd = dentry->d_parent->d_fsdata;
+	struct sysfs_dirent *sd;
 	struct bin_attribute *bin_attr;
 	struct inode *inode;
-	int found = 0;
 
 	mutex_lock(&sysfs_mutex);
 
-	for (sd = parent_sd->s_children; sd; sd = sd->s_sibling) {
-		if (sysfs_type(sd) &&
-		    !strcmp(sd->s_name, dentry->d_name.name)) {
-			found = 1;
+	for (sd = parent_sd->s_children; sd; sd = sd->s_sibling)
+		if (sysfs_type(sd) && !strcmp(sd->s_name, dentry->d_name.name))
 			break;
-		}
-	}
 
 	/* no such entry */
-	if (!found)
+	if (!sd)
 		goto out_unlock;
 
 	/* attach dentry and inode */
-- 
1.5.3.4

