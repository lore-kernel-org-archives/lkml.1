Return-Path: <linux-kernel-owner+w=401wt.eu-S2992733AbXBQRHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992733AbXBQRHg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992732AbXBQRHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:07:18 -0500
Received: from smtp.nokia.com ([131.228.20.173]:33078 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992478AbXBQQ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:58:04 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:57:41 +0200
Message-Id: <20070217165741.5845.51491.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 39/44 take 2] [UBI] character devices handling sub-unit header
X-OriginalArrivalTime: 17 Feb 2007 16:57:40.0603 (UTC) FILETIME=[BC0EDCB0:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185412-0CD71BB0-3628FDE0/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/cdev.h tmp-to/drivers/mtd/ubi/cdev.h
--- tmp-from/drivers/mtd/ubi/cdev.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/cdev.h	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,82 @@
+/*
+ * Copyright (c) International Business Machines Corp., 2006
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Author: Artem B. Bityutskiy
+ */
+
+/*
+ * This is a part of the user interface unit and includes all the character
+ * device-related stuff.
+ */
+
+#ifndef __UBI_CDEV_H__
+#define __UBI_CDEV_H__
+
+/* Maximum sequence numbers of UBI and volume character device IOCTLs */
+#define UBI_CDEV_IOC_MAX_SEQ 2
+
+#ifndef CONFIG_MTD_UBI_USERSPACE_IO
+#define VOL_CDEV_IOC_MAX_SEQ 1
+#else
+#define VOL_CDEV_IOC_MAX_SEQ 2
+#endif
+
+struct ubi_info;
+struct inode;
+struct file;
+struct ubi_uif_volume;
+
+/**
+ * ubi_cdev_vol_init - initialize all the character device-related stuff for
+ * an UBI volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol: user interfaces unit volume description object
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_cdev_vol_init(const struct ubi_info *ubi, struct ubi_uif_volume *vol);
+
+/**
+ * ubi_cdev_vol_close - close all the character device-related stuff for an
+ * UBI volume.
+ *
+ * @vol: user interfaces unit volume description object
+ */
+void ubi_cdev_vol_close(struct ubi_uif_volume *vol);
+
+/**
+ * ubi_cdev_init - initialize all the character device-related stuff for
+ * an UBI device.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_cdev_init(struct ubi_info *ubi);
+
+/**
+ * ubi_cdev_close - close all the character device-related stuff for an UBI
+ * device.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_cdev_close(const struct ubi_info *ubi);
+
+#endif /* !__UBI_CDEV_H__ */
