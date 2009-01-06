Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133AbZAFWOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbZAFWOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbZAFWNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:21 -0500
Received: from kroah.org ([198.145.64.141]:51167 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751687AbZAFWNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:18 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/60] driver core: Rearrange struct device for better packing
Date: Tue,  6 Jan 2009 14:11:22 -0800
Message-Id: <1231279939-32728-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>

This minor rearrangement saves 16 bytes from sizeof(struct device)
according to pahole.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/device.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 4a52005..4e14fad 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -373,9 +373,9 @@ struct device {
 
 	struct kobject kobj;
 	char	bus_id[BUS_ID_SIZE];	/* position on parent bus */
+	unsigned		uevent_suppress:1;
 	const char		*init_name; /* initial name of the device */
 	struct device_type	*type;
-	unsigned		uevent_suppress:1;
 
 	struct semaphore	sem;	/* semaphore to synchronize calls to
 					 * its driver.
@@ -408,12 +408,13 @@ struct device {
 	/* arch specific additions */
 	struct dev_archdata	archdata;
 
+	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
+
 	spinlock_t		devres_lock;
 	struct list_head	devres_head;
 
 	struct klist_node	knode_class;
 	struct class		*class;
-	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
 	struct attribute_group	**groups;	/* optional groups */
 
 	void	(*release)(struct device *dev);
-- 
1.6.0.4

