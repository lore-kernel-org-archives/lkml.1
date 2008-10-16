Return-Path: <linux-kernel-owner+w=401wt.eu-S1759025AbYJPR24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025AbYJPR24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756488AbYJPRO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:59 -0400
Received: from kroah.org ([198.145.64.141]:47031 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756481AbYJPRO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:58 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Trent Piepho <tpiepho@freescale.com>, Neil Brown <neilb@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 38/46] sysfs: Make dir and name args to sysfs_notify() const
Date: Thu, 16 Oct 2008 10:10:39 -0700
Message-Id: <1224177047-11859-38-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trent Piepho <tpiepho@freescale.com>

Because they can be, and because code like this produces a warning if
they're not:

struct device_attribute dev_attr;

sysfs_notify(&kobj, NULL, dev_attr.attr.name);

Signed-off-by: Trent Piepho <tpiepho@freescale.com>
CC: Neil Brown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c       |    2 +-
 include/linux/sysfs.h |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index d0d79e6..1f4a3f8 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -469,7 +469,7 @@ void sysfs_notify_dirent(struct sysfs_dirent *sd)
 }
 EXPORT_SYMBOL_GPL(sysfs_notify_dirent);
 
-void sysfs_notify(struct kobject *k, char *dir, char *attr)
+void sysfs_notify(struct kobject *k, const char *dir, const char *attr)
 {
 	struct sysfs_dirent *sd = k->sd;
 
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index d8e0230..b330e28 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -119,7 +119,7 @@ int sysfs_add_file_to_group(struct kobject *kobj,
 void sysfs_remove_file_from_group(struct kobject *kobj,
 			const struct attribute *attr, const char *group);
 
-void sysfs_notify(struct kobject *kobj, char *dir, char *attr);
+void sysfs_notify(struct kobject *kobj, const char *dir, const char *attr);
 void sysfs_notify_dirent(struct sysfs_dirent *sd);
 struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
 				      const unsigned char *name);
@@ -229,7 +229,8 @@ static inline void sysfs_remove_file_from_group(struct kobject *kobj,
 {
 }
 
-static inline void sysfs_notify(struct kobject *kobj, char *dir, char *attr)
+static inline void sysfs_notify(struct kobject *kobj, const char *dir,
+				const char *attr)
 {
 }
 static inline void sysfs_notify_dirent(struct sysfs_dirent *sd)
-- 
1.6.0.2

