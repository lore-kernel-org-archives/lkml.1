Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbXGAHgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbXGAHgW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 03:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbXGAHfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 03:35:52 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54083 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956AbXGAHfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 03:35:50 -0400
Subject: [EXT4 set 1][PATCH 1/2] Add noextents mount option
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Sun, 01 Jul 2007 03:35:48 -0400
Message-Id: <1183275348.4010.118.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a mount option to turn off extents.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
Index: linux-2.6.22-rc4/fs/ext4/super.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/ext4/super.c	2007-06-11 17:02:18.000000000 -0700
+++ linux-2.6.22-rc4/fs/ext4/super.c	2007-06-11 17:02:22.000000000 -0700
@@ -725,7 +725,7 @@
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
-	Opt_grpquota, Opt_extents,
+	Opt_grpquota, Opt_extents, Opt_noextents,
 };
 
 static match_table_t tokens = {
@@ -776,6 +776,7 @@
 	{Opt_usrquota, "usrquota"},
 	{Opt_barrier, "barrier=%u"},
 	{Opt_extents, "extents"},
+	{Opt_noextents, "noextents"},
 	{Opt_err, NULL},
 	{Opt_resize, "resize"},
 };
@@ -1111,6 +1112,9 @@
 		case Opt_extents:
 			set_opt (sbi->s_mount_opt, EXTENTS);
 			break;
+		case Opt_noextents:
+			clear_opt (sbi->s_mount_opt, EXTENTS);
+			break;
 		default:
 			printk (KERN_ERR
 				"EXT4-fs: Unrecognized mount option \"%s\" "


