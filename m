Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbYFHTDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbYFHTDn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 15:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbYFHTDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 15:03:33 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45161 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216AbYFHTDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 15:03:32 -0400
Subject: [PATCH] Make some ext3 kernel messages useful by showing device
From: Kasper Sandberg <lkml@metanurb.dk>
To: LKML Mailinglist <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-ikFu1sgLQxhYy2ux+01B"
Date: Sun, 08 Jun 2008 21:02:41 +0200
Message-Id: <1212951761.32756.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ikFu1sgLQxhYy2ux+01B
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello.

Some of the ext3 warnings in super.c are not really as useful as they
can be, for instance the "EXT3-fs warning: maximal mount count reached,
running e2fsck is recommended" message, does not tell which device it
actually is.

Below is patch(both inlined, and in attached form, since i dont trust my
mailer), to a patch which fixes that particular message, and a few more.
I could look at the rest if anyones interrested?

Oh, and i dont really know if this is nessecary, but:
Signed-off-by: Kasper Sandberg <lkml@metanurb.dk>


--- super.c.orig	2008-06-08 20:49:26.153047364 +0200
+++ super.c	2008-06-08 20:45:20.812047463 +0200
@@ -1188,31 +1188,31 @@
 	int res = 0;
 
 	if (le32_to_cpu(es->s_rev_level) > EXT3_MAX_SUPP_REV) {
-		printk (KERN_ERR "EXT3-fs warning: revision level too high, "
-			"forcing read-only mode\n");
+		printk (KERN_ERR "EXT3-fs on %s warning: revision level too high, "
+			"forcing read-only mode\n", sb->s_id);
 		res = MS_RDONLY;
 	}
 	if (read_only)
 		return res;
 	if (!(sbi->s_mount_state & EXT3_VALID_FS))
-		printk (KERN_WARNING "EXT3-fs warning: mounting unchecked fs, "
-			"running e2fsck is recommended\n");
+		printk (KERN_WARNING "EXT3-fs on %s warning: mounting unchecked fs, "
+			"running e2fsck is recommended\n", sb->s_id);
 	else if ((sbi->s_mount_state & EXT3_ERROR_FS))
 		printk (KERN_WARNING
-			"EXT3-fs warning: mounting fs with errors, "
-			"running e2fsck is recommended\n");
+			"EXT3-fs on %s warning: mounting fs with errors, "
+			"running e2fsck is recommended\n", sb->s_id);
 	else if ((__s16) le16_to_cpu(es->s_max_mnt_count) >= 0 &&
 		 le16_to_cpu(es->s_mnt_count) >=
 		 (unsigned short) (__s16) le16_to_cpu(es->s_max_mnt_count))
 		printk (KERN_WARNING
-			"EXT3-fs warning: maximal mount count reached, "
-			"running e2fsck is recommended\n");
+			"EXT3-fs on %s warning: maximal mount count reached, "
+			"running e2fsck is recommended\n", sb->s_id);
 	else if (le32_to_cpu(es->s_checkinterval) &&
 		(le32_to_cpu(es->s_lastcheck) +
 			le32_to_cpu(es->s_checkinterval) <= get_seconds()))
 		printk (KERN_WARNING
-			"EXT3-fs warning: checktime reached, "
-			"running e2fsck is recommended\n");
+			"EXT3-fs on %s warning: checktime reached, "
+			"running e2fsck is recommended\n", sb->s_id);
 #if 0
 		/* @@@ We _will_ want to clear the valid bit if we find
                    inconsistencies, to force a fsck at reboot.  But for
@@ -1339,8 +1339,8 @@
 	}
 
 	if (bdev_read_only(sb->s_bdev)) {
-		printk(KERN_ERR "EXT3-fs: write access "
-			"unavailable, skipping orphan cleanup.\n");
+		printk(KERN_ERR "EXT3-fs on %s: write access "
+			"unavailable, skipping orphan cleanup.\n", sb->s_id);
 		return;
 	}
 


--=-ikFu1sgLQxhYy2ux+01B
Content-Disposition: attachment; filename=super.c.diff
Content-Type: text/x-patch; name=super.c.diff; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

--- super.c.orig	2008-06-08 20:49:26.153047364 +0200
+++ super.c	2008-06-08 20:45:20.812047463 +0200
@@ -1188,31 +1188,31 @@
 	int res = 0;
 
 	if (le32_to_cpu(es->s_rev_level) > EXT3_MAX_SUPP_REV) {
-		printk (KERN_ERR "EXT3-fs warning: revision level too high, "
-			"forcing read-only mode\n");
+		printk (KERN_ERR "EXT3-fs on %s warning: revision level too high, "
+			"forcing read-only mode\n", sb->s_id);
 		res = MS_RDONLY;
 	}
 	if (read_only)
 		return res;
 	if (!(sbi->s_mount_state & EXT3_VALID_FS))
-		printk (KERN_WARNING "EXT3-fs warning: mounting unchecked fs, "
-			"running e2fsck is recommended\n");
+		printk (KERN_WARNING "EXT3-fs on %s warning: mounting unchecked fs, "
+			"running e2fsck is recommended\n", sb->s_id);
 	else if ((sbi->s_mount_state & EXT3_ERROR_FS))
 		printk (KERN_WARNING
-			"EXT3-fs warning: mounting fs with errors, "
-			"running e2fsck is recommended\n");
+			"EXT3-fs on %s warning: mounting fs with errors, "
+			"running e2fsck is recommended\n", sb->s_id);
 	else if ((__s16) le16_to_cpu(es->s_max_mnt_count) >= 0 &&
 		 le16_to_cpu(es->s_mnt_count) >=
 		 (unsigned short) (__s16) le16_to_cpu(es->s_max_mnt_count))
 		printk (KERN_WARNING
-			"EXT3-fs warning: maximal mount count reached, "
-			"running e2fsck is recommended\n");
+			"EXT3-fs on %s warning: maximal mount count reached, "
+			"running e2fsck is recommended\n", sb->s_id);
 	else if (le32_to_cpu(es->s_checkinterval) &&
 		(le32_to_cpu(es->s_lastcheck) +
 			le32_to_cpu(es->s_checkinterval) <= get_seconds()))
 		printk (KERN_WARNING
-			"EXT3-fs warning: checktime reached, "
-			"running e2fsck is recommended\n");
+			"EXT3-fs on %s warning: checktime reached, "
+			"running e2fsck is recommended\n", sb->s_id);
 #if 0
 		/* @@@ We _will_ want to clear the valid bit if we find
                    inconsistencies, to force a fsck at reboot.  But for
@@ -1339,8 +1339,8 @@
 	}
 
 	if (bdev_read_only(sb->s_bdev)) {
-		printk(KERN_ERR "EXT3-fs: write access "
-			"unavailable, skipping orphan cleanup.\n");
+		printk(KERN_ERR "EXT3-fs on %s: write access "
+			"unavailable, skipping orphan cleanup.\n", sb->s_id);
 		return;
 	}
 

--=-ikFu1sgLQxhYy2ux+01B--

