Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab0CBX6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:58:22 -0500
Received: from kroah.org ([198.145.64.141]:38518 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165Ab0CBX3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:16 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/62] sysdev: Fix type of sysdev class attribute in memory driver
Date: Tue,  2 Mar 2010 15:28:12 -0800
Message-Id: <1267572541-410-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

This attribute is really a sysdev_class attribute, not a plain class attribute.

They are identical in layout currently, but this might not always be
the case.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/memory.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index bd02505..563656a 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -309,17 +309,18 @@ static SYSDEV_ATTR(removable, 0444, show_mem_removable, NULL);
  * Block size attribute stuff
  */
 static ssize_t
-print_block_size(struct class *class, char *buf)
+print_block_size(struct sysdev_class *class, struct sysdev_class_attribute *attr,
+		 char *buf)
 {
 	return sprintf(buf, "%#lx\n", (unsigned long)PAGES_PER_SECTION * PAGE_SIZE);
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
-- 
1.7.0.1

