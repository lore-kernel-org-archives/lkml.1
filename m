Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbYAHIq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbYAHIq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 03:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbYAHIqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 03:46:49 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:46695 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbYAHIqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 03:46:48 -0500
Date: Tue, 8 Jan 2008 11:46:29 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH 4/4] Fixup container_of() usage
Message-ID: <20080108084629.GD6209@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using "attr" twice is not OK, because it effectively prohibits such
container_of() on variables not named "attr".

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 arch/sh/kernel/cpu/sh4/sq.c    |    2 +-
 drivers/lguest/lguest_device.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sh/kernel/cpu/sh4/sq.c
+++ b/arch/sh/kernel/cpu/sh4/sq.c
@@ -263,7 +263,7 @@ struct sq_sysfs_attr {
 	ssize_t (*store)(const char *buf, size_t count);
 };
 
-#define to_sq_sysfs_attr(attr)	container_of(attr, struct sq_sysfs_attr, attr)
+#define to_sq_sysfs_attr(a)	container_of(a, struct sq_sysfs_attr, attr)
 
 static ssize_t sq_sysfs_show(struct kobject *kobj, struct attribute *attr,
 			     char *buf)
--- a/drivers/lguest/lguest_device.c
+++ b/drivers/lguest/lguest_device.c
@@ -47,7 +47,7 @@ struct lguest_device {
 /* Since the virtio infrastructure hands us a pointer to the virtio_device all
  * the time, it helps to have a curt macro to get a pointer to the struct
  * lguest_device it's enclosed in.  */
-#define to_lgdev(vdev) container_of(vdev, struct lguest_device, vdev)
+#define to_lgdev(vd) container_of(vd, struct lguest_device, vdev)
 
 /*D:130
  * Device configurations

