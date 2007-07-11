Return-Path: <linux-kernel-owner+w=401wt.eu-S936572AbXGKX4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936572AbXGKX4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935264AbXGKXgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:36:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:33455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934920AbXGKXgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:36:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <htejun@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 49/61] sysfs: Fix oops in sysfs_drop_dentry on x86_64
Date: Wed, 11 Jul 2007 16:32:08 -0700
Message-Id: <11841969731234-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184196968712-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
 <1184196818497-git-send-email-gregkh@suse.de>
 <11841968231043-git-send-email-gregkh@suse.de>
 <11841968271925-git-send-email-gregkh@suse.de>
 <11841968303508-git-send-email-gregkh@suse.de>
 <11841968352439-git-send-email-gregkh@suse.de>
 <11841968392043-git-send-email-gregkh@suse.de>
 <11841968431153-git-send-email-gregkh@suse.de>
 <11841968471598-git-send-email-gregkh@suse.de>
 <11841968512510-git-send-email-gregkh@suse.de>
 <1184196856662-git-send-email-gregkh@suse.de>
 <1184196860992-git-send-email-gregkh@suse.de>
 <11841968643630-git-send-email-gregkh@suse.de>
 <11841968683554-git-send-email-gregkh@suse.de>
 <11841968731843-git-send-email-gregkh@suse.de>
 <11841968773426-git-send-email-gregkh@suse.de>
 <118419688284-git-send-email-gregkh@suse.de>
 <11841968872456-git-send-email-gregkh@suse.de>
 <11841968903726-git-send-email-gregkh@suse.de>
 <11841968951572-git-send-email-gregkh@suse.de>
 <11841968992181-git-send-email-gregkh@suse.de>
 <1184196905515-git-send-email-gregkh@suse.de>
 <11841969101299-git-send-email-gregkh@suse.de>
 <11841969142368-git-send-email-gregkh@suse.de>
 <11841969191116-git-send-email-gregkh@suse.de>
 <118419692665-git-send-email-gregkh@suse.de>
 <11841969323515-git-send-email-gregkh@suse.de>
 <11841969361535-git-send-email-gregkh@suse.de>
 <11841969401152-git-send-email-gregkh@suse.de>
 <11841969453004-git-send-email-gregkh@suse.de>
 <11841969502188-git-send-email-gregkh@suse.de>
 <1184196954330-git-send-email-gregkh@suse.de>
 <11841969641445-git-send-email-gregkh@suse.de>
 <1184196968712-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Fix oops on x86_64 caused by the dereference of dir in
sysfs_drop_dentry() made before checking if dir is not NULL
(cf. http://marc.info/?l=linux-kernel&m=118151626704924&w=2).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 732fd7f..ee31bf3 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -285,7 +285,7 @@ void sysfs_drop_dentry(struct sysfs_dirent *sd)
 int sysfs_hash_and_remove(struct dentry * dir, const char * name)
 {
 	struct sysfs_dirent **pos, *sd;
-	struct sysfs_dirent *parent_sd = dir->d_fsdata;
+	struct sysfs_dirent *parent_sd;
 	int found = 0;
 
 	if (!dir)
@@ -295,6 +295,7 @@ int sysfs_hash_and_remove(struct dentry * dir, const char * name)
 		/* no inode means this hasn't been made visible yet */
 		return -ENOENT;
 
+	parent_sd = dir->d_fsdata;
 	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
 	for (pos = &parent_sd->s_children; *pos; pos = &(*pos)->s_sibling) {
 		sd = *pos;
-- 
1.5.2.2

