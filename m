Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568Ab0AELvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0AELvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272Ab0AELvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:51:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36335 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab0AELsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:48:07 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201001051247.104464547@firstfloor.org>
In-Reply-To: <201001051247.104464547@firstfloor.org>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] [9/12] SYSFS: Fix type of sysdev class attribute in memory driver
Message-Id: <20100105114806.8D457B17C2@basil.firstfloor.org>
Date: Tue,  5 Jan 2010 12:48:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This attribute is really a sysdev_class attribute, not a plain class attribute.

They are identical in layout currently, but this might not always be 
the case.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/base/memory.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6.33-rc2-ak/drivers/base/memory.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/base/memory.c
+++ linux-2.6.33-rc2-ak/drivers/base/memory.c
@@ -309,17 +309,18 @@ static SYSDEV_ATTR(removable, 0444, show
  * Block size attribute stuff
  */
 static ssize_t
-print_block_size(struct class *class, char *buf)
+print_block_size(struct sysdev_class *class, struct sysdev_class_attribute *attr,
+		 char *buf)
 {
 	return sprintf(buf, "%lx\n", (unsigned long)PAGES_PER_SECTION * PAGE_SIZE);
 }
 
-static CLASS_ATTR(block_size_bytes, 0444, print_block_size, NULL);
+static SYSDEV_CLASS_ATTR(block_size_bytes, 0444, print_block_size, NULL);
 
 static int block_size_init(void)
 {
 	return sysfs_create_file(&memory_sysdev_class.kset.kobj,
-				&class_attr_block_size_bytes.attr);
+				&attr_block_size_bytes.attr);
 }
 
 /*
