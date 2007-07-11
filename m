Return-Path: <linux-kernel-owner+w=401wt.eu-S935455AbXGKXiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935455AbXGKXiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934865AbXGKXdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:33:52 -0400
Received: from mail.suse.de ([195.135.220.2]:33726 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935081AbXGKXdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:33:50 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@stusta.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/61] Driver core: fix devres_release_all() return value
Date: Wed, 11 Jul 2007 16:31:32 -0700
Message-Id: <11841968071826-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841968032469-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>

Every file should include the headers containing the prototypes for
it's global functions.

Since the GNU C compiler is now able to detect that the function
prototype of devres_release_all() in the header and the actual function
disagree regarding the return value, this patch also fixes this bug.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h   |    2 +-
 drivers/base/devres.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 5512d84..47eb02d 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -44,6 +44,6 @@ struct class_device_attribute *to_class_dev_attr(struct attribute *_attr)
 
 extern char *make_class_name(const char *name, struct kobject *kobj);
 
-extern void devres_release_all(struct device *dev);
+extern int devres_release_all(struct device *dev);
 
 extern struct kset devices_subsys;
diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index e1c0730..e8beb8e 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -10,6 +10,8 @@
 #include <linux/device.h>
 #include <linux/module.h>
 
+#include "base.h"
+
 struct devres_node {
 	struct list_head		entry;
 	dr_release_t			release;
-- 
1.5.2.2

