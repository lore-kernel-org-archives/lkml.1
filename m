Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbZLINuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbZLINuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 08:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756058AbZLINuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 08:50:06 -0500
Received: from smtp.nokia.com ([192.100.122.233]:51640 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbZLINuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 08:50:03 -0500
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: dbrownell@users.sourceforge.net, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, dsilvers@simtec.co.uk, ben@simtec.co.uk,
       Artem.Bityutskiy@nokia.com, akpm@linux-foundation.org,
       ext-jani.1.nikula@nokia.com
Subject: [PATCH 1/3] device class: add symlink creation helpers
Date: Wed,  9 Dec 2009 15:49:02 +0200
Message-Id: <30f1f2c867089bb78cdb9fe3c2032c091bed106a.1260364108.git.ext-jani.1.nikula@nokia.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
In-Reply-To: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
X-OriginalArrivalTime: 09 Dec 2009 13:49:13.0104 (UTC) FILETIME=[6416F100:01CA78D6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 drivers/base/class.c   |   21 +++++++++++++++++++++
 include/linux/device.h |    4 ++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 161746d..818cbe2 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -92,6 +92,25 @@ void class_remove_file(struct class *cls, const struct class_attribute *attr)
 		sysfs_remove_file(&cls->p->class_subsys.kobj, &attr->attr);
 }
 
+int class_create_link(struct class *cls, struct kobject *target,
+		      const char *name)
+{
+	int error;
+
+	if (cls)
+		error = sysfs_create_link(&cls->p->class_subsys.kobj,
+					  target, name);
+	else
+		error = -EINVAL;
+	return error;
+}
+
+void class_remove_link(struct class *cls, const char *name)
+{
+	if (cls)
+		sysfs_remove_link(&cls->p->class_subsys.kobj, name);
+}
+
 static struct class *class_get(struct class *cls)
 {
 	if (cls)
@@ -585,6 +604,8 @@ int __init classes_init(void)
 
 EXPORT_SYMBOL_GPL(class_create_file);
 EXPORT_SYMBOL_GPL(class_remove_file);
+EXPORT_SYMBOL_GPL(class_create_link);
+EXPORT_SYMBOL_GPL(class_remove_link);
 EXPORT_SYMBOL_GPL(class_unregister);
 EXPORT_SYMBOL_GPL(class_destroy);
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 2ea3e49..e877be6 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -262,6 +262,10 @@ extern int __must_check class_create_file(struct class *class,
 					  const struct class_attribute *attr);
 extern void class_remove_file(struct class *class,
 			      const struct class_attribute *attr);
+extern int __must_check class_create_link(struct class *class,
+					  struct kobject *target,
+					  const char *name);
+extern void class_remove_link(struct class *class, const char *name);
 
 struct class_interface {
 	struct list_head	node;
-- 
1.6.5.2

