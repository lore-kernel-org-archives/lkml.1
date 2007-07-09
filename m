Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbXGIC4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbXGIC4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 22:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758457AbXGIC42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 22:56:28 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:60162 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758585AbXGIC41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 22:56:27 -0400
Date: Sun, 8 Jul 2007 22:56:25 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] selinux: rename sel_remove_bools() for more general
 usage.
In-Reply-To: <Line.LNX.4.64.0707082253040.12256@d.namei>
Message-ID: <Line.LNX.4.64.0707082255520.12256@d.namei>
References: <Line.LNX.4.64.0707082253040.12256@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christopher J. PeBenito <cpebenito@tresys.com>

sel_remove_bools() will also be used by the object class discovery, rename
it for more general use.

Signed-off-by: Christopher J. PeBenito <cpebenito@tresys.com>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/selinuxfs.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index aca099a..e955246 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -940,9 +940,8 @@ static const struct file_operations sel_commit_bools_ops = {
 	.write          = sel_commit_bools_write,
 };
 
-/* delete booleans - partial revoke() from
- * fs/proc/generic.c proc_kill_inodes */
-static void sel_remove_bools(struct dentry *de)
+/* partial revoke() from fs/proc/generic.c proc_kill_inodes */
+static void sel_remove_entries(struct dentry *de)
 {
 	struct list_head *p, *node;
 	struct super_block *sb = de->d_sb;
@@ -998,7 +997,7 @@ static int sel_make_bools(void)
 	kfree(bool_pending_values);
 	bool_pending_values = NULL;
 
-	sel_remove_bools(dir);
+	sel_remove_entries(dir);
 
 	if (!(page = (char*)get_zeroed_page(GFP_KERNEL)))
 		return -ENOMEM;
@@ -1048,7 +1047,7 @@ out:
 	return ret;
 err:
 	kfree(values);
-	sel_remove_bools(dir);
+	sel_remove_entries(dir);
 	ret = -ENOMEM;
 	goto out;
 }
-- 
1.5.0.6

