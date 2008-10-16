Return-Path: <linux-kernel-owner+w=401wt.eu-S1760105AbYJPRar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105AbYJPRar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756536AbYJPRPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:15:07 -0400
Received: from kroah.org ([198.145.64.141]:47044 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756530AbYJPRPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:15:05 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 43/46] UIO: Add alignment warnings for uio-mem
Date: Thu, 16 Oct 2008 10:10:44 -0700
Message-Id: <1224177047-11859-43-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans J. Koch <hjk@linutronix.de>

This patch adds an "offset" attribute for UIO mappings. It shows the
difference between the actual start address of the memory and the start
address of the page.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 9ac22c7..557e73e 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -67,6 +67,11 @@ static ssize_t map_size_show(struct uio_mem *mem, char *buf)
 	return sprintf(buf, "0x%lx\n", mem->size);
 }
 
+static ssize_t map_offset_show(struct uio_mem *mem, char *buf)
+{
+	return sprintf(buf, "0x%lx\n", mem->addr & ~PAGE_MASK);
+}
+
 struct uio_sysfs_entry {
 	struct attribute attr;
 	ssize_t (*show)(struct uio_mem *, char *);
@@ -77,10 +82,13 @@ static struct uio_sysfs_entry addr_attribute =
 	__ATTR(addr, S_IRUGO, map_addr_show, NULL);
 static struct uio_sysfs_entry size_attribute =
 	__ATTR(size, S_IRUGO, map_size_show, NULL);
+static struct uio_sysfs_entry offset_attribute =
+	__ATTR(offset, S_IRUGO, map_offset_show, NULL);
 
 static struct attribute *attrs[] = {
 	&addr_attribute.attr,
 	&size_attribute.attr,
+	&offset_attribute.attr,
 	NULL,	/* need to NULL terminate the list of attributes */
 };
 
-- 
1.6.0.2

