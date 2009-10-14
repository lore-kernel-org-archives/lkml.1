Return-Path: <linux-kernel-owner+w=401wt.eu-S1762178AbZJNXzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762178AbZJNXzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 19:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762169AbZJNXzC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 19:55:02 -0400
Received: from kroah.org ([198.145.64.141]:38292 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759303AbZJNXzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 19:55:01 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Phil Carmody <ext-phil.2.carmody@nokia.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/2] sysfs: Allow sysfs_move_dir(..., NULL) again.
Date: Wed, 14 Oct 2009 16:51:46 -0700
Message-Id: <1255564307-9566-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <20091014230432.GB8865@kroah.com>
References: <20091014230432.GB8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

As device_move() and kobject_move() both handle a NULL destination,
sysfs_move_dir() should do this as well (again) and fall back to
sysfs_root in that case.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 0050fc4..5fad489 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -894,7 +894,8 @@ int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
 
 	mutex_lock(&sysfs_rename_mutex);
 	BUG_ON(!sd->s_parent);
-	new_parent_sd = new_parent_kobj->sd ? new_parent_kobj->sd : &sysfs_root;
+	new_parent_sd = (new_parent_kobj && new_parent_kobj->sd) ?
+		new_parent_kobj->sd : &sysfs_root;
 
 	error = 0;
 	if (sd->s_parent == new_parent_sd)
-- 
1.6.4.2

