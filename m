Return-Path: <linux-kernel-owner+w=401wt.eu-S936730AbZFPF6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936730AbZFPF6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935842AbZFPFvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:23 -0400
Received: from kroah.org ([198.145.64.141]:48392 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934880AbZFPFvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:21 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 34/64] Driver Core: drm: add nodename for drm devices
Date: Mon, 15 Jun 2009 22:46:23 -0700
Message-Id: <1245131213-24168-34-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This adds support to the drm core to report the proper device name to
userspace for the drm devices.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/drm_sysfs.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index 9987ab8..85ec31b 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -70,6 +70,11 @@ static ssize_t version_show(struct class *dev, char *buf)
 		       CORE_MINOR, CORE_PATCHLEVEL, CORE_DATE);
 }
 
+static char *drm_nodename(struct device *dev)
+{
+	return kasprintf(GFP_KERNEL, "dri/%s", dev_name(dev));
+}
+
 static CLASS_ATTR(version, S_IRUGO, version_show, NULL);
 
 /**
@@ -101,6 +106,8 @@ struct class *drm_sysfs_create(struct module *owner, char *name)
 	if (err)
 		goto err_out_class;
 
+	class->nodename = drm_nodename;
+
 	return class;
 
 err_out_class:
-- 
1.6.3.2

