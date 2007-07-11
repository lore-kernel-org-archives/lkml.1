Return-Path: <linux-kernel-owner+w=401wt.eu-S936443AbXGKXyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936443AbXGKXyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934727AbXGKXgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:36:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935023AbXGKXgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:36:13 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 45/61] sysfs: fix root sysfs_dirent -> root dentry association
Date: Wed, 11 Jul 2007 16:32:04 -0700
Message-Id: <11841969502188-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841969453004-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

The root sysfs_dirent didn't point to the root dentry fix it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/mount.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 6d3a624..d0e1603 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -65,6 +65,7 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 		iput(inode);
 		return -ENOMEM;
 	}
+	sysfs_root.s_dentry = root;
 	root->d_fsdata = &sysfs_root;
 	sb->s_root = root;
 	return 0;
-- 
1.5.2.2

