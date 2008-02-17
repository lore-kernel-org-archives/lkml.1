Return-Path: <linux-kernel-owner+w=401wt.eu-S1760104AbYBQIXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104AbYBQIXN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758845AbYBQIUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:20:23 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59720 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758101AbYBQIUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:20:21 -0500
Date: Sun, 17 Feb 2008 10:19:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] make udf_error() static
Message-ID: <20080217081955.GQ3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global udf_error() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/udf/super.c   |    6 ++++--
 fs/udf/udfdecl.h |    1 -
 2 files changed, 4 insertions(+), 3 deletions(-)

c99325d879eda1095e5d82e2b8151a22bc220db8 diff --git a/fs/udf/super.c b/fs/udf/super.c
index f3ac4ab..d1f9507 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -100,6 +100,8 @@ static void udf_close_lvid(struct super_block *);
 static unsigned int udf_count_free(struct super_block *);
 static int udf_statfs(struct dentry *, struct kstatfs *);
 static int udf_show_options(struct seq_file *, struct vfsmount *);
+static void udf_error(struct super_block *sb, const char *function,
+		      const char *fmt, ...);
 
 struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct udf_sb_info *sbi)
 {
@@ -1920,8 +1922,8 @@ error_out:
 	return -EINVAL;
 }
 
-void udf_error(struct super_block *sb, const char *function,
-	       const char *fmt, ...)
+static void udf_error(struct super_block *sb, const char *function,
+		      const char *fmt, ...)
 {
 	va_list args;
 
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index 681dc2b..55aabaf 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -83,7 +83,6 @@ struct extent_position {
 };
 
 /* super.c */
-extern void udf_error(struct super_block *, const char *, const char *, ...);
 extern void udf_warning(struct super_block *, const char *, const char *, ...);
 
 /* namei.c */

