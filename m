Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbXJDJVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbXJDJVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759457AbXJDJRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759454AbXJDJRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:34 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Denis Cheng <crquan@gmail.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/51] [GFS2] mark struct *_operations const
Date: Thu,  4 Oct 2007 09:49:04 +0100
Message-Id: <11914878102813-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878081562-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>

these struct *_operations are all method tables, thus should be const.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/eaops.c b/fs/gfs2/eaops.c
index 1ab3e9d..aa8dbf3 100644
--- a/fs/gfs2/eaops.c
+++ b/fs/gfs2/eaops.c
@@ -200,28 +200,28 @@ static int security_eo_remove(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 	return gfs2_ea_remove_i(ip, er);
 }
 
-static struct gfs2_eattr_operations gfs2_user_eaops = {
+static const struct gfs2_eattr_operations gfs2_user_eaops = {
 	.eo_get = user_eo_get,
 	.eo_set = user_eo_set,
 	.eo_remove = user_eo_remove,
 	.eo_name = "user",
 };
 
-struct gfs2_eattr_operations gfs2_system_eaops = {
+const struct gfs2_eattr_operations gfs2_system_eaops = {
 	.eo_get = system_eo_get,
 	.eo_set = system_eo_set,
 	.eo_remove = system_eo_remove,
 	.eo_name = "system",
 };
 
-static struct gfs2_eattr_operations gfs2_security_eaops = {
+static const struct gfs2_eattr_operations gfs2_security_eaops = {
 	.eo_get = security_eo_get,
 	.eo_set = security_eo_set,
 	.eo_remove = security_eo_remove,
 	.eo_name = "security",
 };
 
-struct gfs2_eattr_operations *gfs2_ea_ops[] = {
+const struct gfs2_eattr_operations *gfs2_ea_ops[] = {
 	NULL,
 	&gfs2_user_eaops,
 	&gfs2_system_eaops,
diff --git a/fs/gfs2/eaops.h b/fs/gfs2/eaops.h
index 508b4f7..da2f7fb 100644
--- a/fs/gfs2/eaops.h
+++ b/fs/gfs2/eaops.h
@@ -22,9 +22,9 @@ struct gfs2_eattr_operations {
 
 unsigned int gfs2_ea_name2type(const char *name, const char **truncated_name);
 
-extern struct gfs2_eattr_operations gfs2_system_eaops;
+extern const struct gfs2_eattr_operations gfs2_system_eaops;
 
-extern struct gfs2_eattr_operations *gfs2_ea_ops[];
+extern const struct gfs2_eattr_operations *gfs2_ea_ops[];
 
 #endif /* __EAOPS_DOT_H__ */
 
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index e4bc8ae..0054b7d 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -2103,7 +2103,7 @@ static int gfs2_glock_seq_show(struct seq_file *file, void *iter_ptr)
 	return 0;
 }
 
-static struct seq_operations gfs2_glock_seq_ops = {
+static const struct seq_operations gfs2_glock_seq_ops = {
 	.start = gfs2_glock_seq_start,
 	.next  = gfs2_glock_seq_next,
 	.stop  = gfs2_glock_seq_stop,
-- 
1.5.1.2

