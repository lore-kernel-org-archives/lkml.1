Return-Path: <linux-kernel-owner+w=401wt.eu-S2992469AbXBQQ4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992469AbXBQQ4U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992473AbXBQQ4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:56:20 -0500
Received: from smtp.nokia.com ([131.228.20.173]:32748 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992469AbXBQQ4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:56:18 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:55:50 +0200
Message-Id: <20070217165550.5845.96396.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 17/44 take 2] [UBI] build unit header
X-OriginalArrivalTime: 17 Feb 2007 16:55:49.0687 (UTC) FILETIME=[79F26C70:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185220-0B11ABB0-31629ACB/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/build.h tmp-to/drivers/mtd/ubi/build.h
--- tmp-from/drivers/mtd/ubi/build.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/build.h	2007-02-17 18:07:26.000000000 +0200
@@ -0,0 +1,62 @@
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
+ * UBI build unit.
+ *
+ * This unit is responsible for attaching MTD devices to UBI devices. At the
+ * moment there is only one attachment method exists - full scan. But in future
+ * one may add a superblock-based attachment method and improve UBI
+ * scalability. But anyways, the scanning method will always be useful because
+ * in case of superblock corruptions UBI can always scan the device and
+ * re-build all the core data structures.
+ */
+
+#ifndef __UBI_BUILD_H__
+#define __UBI_BUILD_H__
+
+struct ubi_info;
+
+/**
+ * ubi_bld_attach_mtd_dev - attach an MTD device.
+ *
+ * @ubi: the UBI device description object
+ * @mtd_num: MTD device number
+ * @vid_hdr_offset: volume identifier headers offset
+ * @data_offset: data offset
+ *
+ * This function attaches an MTD device number @mtd_num. If @vid_hdr_offset and
+ * @data_offset are zero, the default layout of UBI headers is assumed. See the
+ * I/O unit.
+ *
+ * This function returns a positive number of the new UBI device in case of
+ * success and a negative error code in case of failure.
+ */
+int ubi_bld_attach_mtd_dev(struct ubi_info *ubi, int mtd_num,
+			   int vid_hdr_offset, int data_offset);
+
+/**
+ * ubi_bld_detach_mtd_dev - detach an MTD device.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_bld_detach_mtd_dev(struct ubi_info *ubi);
+
+#endif /* __UBI_BUILD_H__ */
