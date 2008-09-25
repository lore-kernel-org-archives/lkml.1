Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbYIYXs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbYIYXs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 19:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbYIYXst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 19:48:49 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:58365 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbYIYXss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 19:48:48 -0400
From: Trent Piepho <tpiepho@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Trent Piepho <tpiepho@freescale.com>,
       NeilBrown <neilb@suse.de>
Subject: [PATCH] sysfs: Make dir and name args to sysfs_notify() const
Date: Thu, 25 Sep 2008 16:45:13 -0700
Message-Id: <1222386313-18401-1-git-send-email-tpiepho@freescale.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because they can be, and because code like this produces a warning if
they're not:

struct device_attribute dev_attr;

sysfs_notify(&kobj, NULL, dev_attr.attr.name);

Signed-off-by: Trent Piepho <tpiepho@freescale.com>
CC: NeilBrown <neilb@suse.de>
---
 fs/sysfs/file.c       |    2 +-
 include/linux/sysfs.h |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index c9e4e50..cabfd0f 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -440,7 +440,7 @@ static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 	return POLLERR|POLLPRI;
 }
 
-void sysfs_notify(struct kobject *k, char *dir, char *attr)
+void sysfs_notify(struct kobject *k, const char *dir, const char *attr)
 {
 	struct sysfs_dirent *sd = k->sd;
 
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 37fa241..94e835f 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -117,7 +117,7 @@ int sysfs_add_file_to_group(struct kobject *kobj,
 void sysfs_remove_file_from_group(struct kobject *kobj,
 			const struct attribute *attr, const char *group);
 
-void sysfs_notify(struct kobject *kobj, char *dir, char *attr);
+void sysfs_notify(struct kobject *kobj, const char *dir, const char *attr);
 
 extern int __must_check sysfs_init(void);
 
@@ -222,7 +222,8 @@ static inline void sysfs_remove_file_from_group(struct kobject *kobj,
 {
 }
 
-static inline void sysfs_notify(struct kobject *kobj, char *dir, char *attr)
+static inline void sysfs_notify(struct kobject *kobj, const char *dir,
+				const char *attr)
 {
 }
 
-- 
1.5.4.1

