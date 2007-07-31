Return-Path: <linux-kernel-owner+w=401wt.eu-S1759524AbXGaKbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbXGaKbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbXGaKbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:31:01 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:62250 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbXGaKbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:31:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=l/+PhF8Q8tEMbtVoSL6SNzfwqGYTyksReFZ1fySo0mxgb+g/BnrlCvvkQLLmPWwJQairV4gNuk6UnCOhM7/aBe1uUhhfHhxmgwM3vtWB1x9VaFOKwX9tR1OJu5yIExUw8kzENqsLLUFkPUQdj/fgt+3sprHuH+sAUEPExPZZXxQ=
From: Denis Cheng <crquan@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, chdebra@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] fs/gfs2: mark struct *_operations const
Date: Tue, 31 Jul 2007 18:31:11 +0800
Message-Id: <1185877873787-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1185873464.8765.564.camel@quoit>
References: <1185873464.8765.564.camel@quoit>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

these struct *_operations are all method tables, thus should be const.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/gfs2/eaops.c |    8 ++++----
 fs/gfs2/eaops.h |    4 ++--
 fs/gfs2/glock.c |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

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
index 3f0974e..00fe234 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -2095,7 +2095,7 @@ static int gfs2_glock_seq_show(struct seq_file *file, void *iter_ptr)
 	return 0;
 }
 
-static struct seq_operations gfs2_glock_seq_ops = {
+static const struct seq_operations gfs2_glock_seq_ops = {
 	.start = gfs2_glock_seq_start,
 	.next  = gfs2_glock_seq_next,
 	.stop  = gfs2_glock_seq_stop,
-- 
1.5.2.2

