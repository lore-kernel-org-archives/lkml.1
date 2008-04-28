Return-Path: <linux-kernel-owner+w=401wt.eu-S937556AbYD1VNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937556AbYD1VNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934830AbYD1VNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:13:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:42327 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935239AbYD1VNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:13:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fD1GEyq5s4HXNWXZBuIhxIWEvEkelm2oov/F4+BvwVNlPdq2PoyZqtTb2dVL0DgeTi8Zu/I9SCJs71/ZPnHYT3LWxiYdMHvgT9nRZ47SM1AIyi5odOyflsID45iiCkDraOBB+ZrP6+ojafttYExbuu4WeB/z1swukQ4zaOYi9tk=
Subject: [PATCH 1/4] init: fix integer as NULL pointer warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 14:13:14 -0700
Message-Id: <1209417194.14173.98.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init/do_mounts_rd.c:215:13: warning: Using plain integer as NULL pointer
init/do_mounts_md.c:136:45: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Linus, should I break them up this finely?  I've done a sweep of most of
the mainline tree.

 init/do_mounts_md.c |    2 +-
 init/do_mounts_rd.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index 753dc54..7473b0c 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -133,7 +133,7 @@ static void __init md_setup_drive(void)
 		else
 			dev = MKDEV(MD_MAJOR, minor);
 		create_dev(name, dev);
-		for (i = 0; i < MD_SB_DISKS && devname != 0; i++) {
+		for (i = 0; i < MD_SB_DISKS && devname != NULL; i++) {
 			char *p;
 			char comp_name[64];
 			u32 rdev;
diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index 3ac5904..46dfd64 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -212,7 +212,7 @@ int __init rd_load_image(char *from)
 	}
 
 	buf = kmalloc(BLOCK_SIZE, GFP_KERNEL);
-	if (buf == 0) {
+	if (!buf) {
 		printk(KERN_ERR "RAMDISK: could not allocate buffer\n");
 		goto done;
 	}
-- 
1.5.5.1.270.g89765


