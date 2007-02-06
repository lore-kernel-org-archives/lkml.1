Return-Path: <linux-kernel-owner+w=401wt.eu-S932994AbXBFQHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbXBFQHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932622AbXBFQHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:07:40 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:59552 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994AbXBFQHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:07:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=UIGAGckiW268ylYIk0+uugxLtsRVAxXr8FkqDyMAkfnEGBH+AC4xe0aakS4Gc9FoW7ElDXZ+7pOvKZTaN3udTjhgcq6bKT+v8nO6uPtxaKD8MwViGip2AUX7OtyMFF4ynDzHpyJ5Dd82LRXMaI0rwQBb2KLb6ARQ4LFgem+BHNg=
Date: Tue, 6 Feb 2007 18:07:25 +0200
To: rolandd@cisco.com
Cc: linux-kernel@vger.kernel.org, openib-general@openib.org
Subject: [PATCH 2.6.20] infinband: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206160725.GJ8991@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206160204.GA8991@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A patch to use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 63d2a39..7fabb42 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -36,6 +36,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
@@ -93,7 +94,7 @@ static int ib_device_check_mandatory(struct ib_device *device)
 	};
 	int i;
 
-	for (i = 0; i < sizeof mandatory_table / sizeof mandatory_table[0]; ++i) {
+	for (i = 0; i < ARRAY_SIZE(mandatory_table); ++i) {
 		if (!*(void **) ((void *) device + mandatory_table[i].offset)) {
 			printk(KERN_WARNING "Device %s is missing mandatory function %s\n",
 			       device->name, mandatory_table[i].name);

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
