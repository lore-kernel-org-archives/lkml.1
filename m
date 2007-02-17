Return-Path: <linux-kernel-owner+w=401wt.eu-S965355AbXBQQ6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965355AbXBQQ6q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992475AbXBQQ62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:58:28 -0500
Received: from smtp.nokia.com ([131.228.20.171]:55294 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992480AbXBQQ6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:58:06 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:57:51 +0200
Message-Id: <20070217165751.5845.28503.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 41/44 take 2] [UBI] gluebi unit header
X-OriginalArrivalTime: 17 Feb 2007 16:57:50.0681 (UTC) FILETIME=[C210A490:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185541-3C652BB0-7DCD096C/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/gluebi.h tmp-to/drivers/mtd/ubi/gluebi.h
--- tmp-from/drivers/mtd/ubi/gluebi.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/gluebi.h	2007-02-17 18:07:28.000000000 +0200
@@ -0,0 +1,88 @@
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
+ * This unit is responsible for emulating MTD devices on top of UBI devices.
+ * This sounds strange, but it is in fact quite useful to make legacy software
+ * work on top of UBI. New software should use native UBI API instead.
+ *
+ * Gluebi emulated MTD devices of "MTD_UBIVOLUME" type. Their minimal I/O unit
+ * size (mtd->writesize) is equivalent to the underlying flash minimal I/O
+ * unit. The eraseblock size is equivalent to the logical UBI volume eraseblock
+ * size.
+ */
+
+#ifndef __UBI_GLUEBI_H__
+#define __UBI_GLUEBI_H__
+
+#include <linux/mtd/mtd.h>
+
+#if defined(CONFIG_MTD_UBI_GLUEBI)
+
+struct ubi_uif_volume;
+
+/**
+ * struct ubi_gluebi_volume - emulated MTD device description data structure.
+ *
+ * @desc: UBI volume descriptor
+ * @mtd: MTD device description object
+ */
+struct ubi_gluebi_volume
+{
+	struct ubi_vol_desc *desc;
+	int refcount;
+	struct mtd_info mtd;
+};
+
+/**
+ * ubi_gluebi_vol_init - initialize all the gluebi-related stuff for an UBI
+ * volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol: user interfaces unit volume description object
+ *
+ * This function is called when an UBI volume is created in order to create
+ * corresponding MTD device. Returns zero in case of success and a negative
+ * error code in case of failure.
+ */
+int ubi_gluebi_vol_init(const struct ubi_info *ubi, struct ubi_uif_volume *vol);
+
+/**
+ * ubi_gluebi_vol_close - close all the gluebi-related stuff for an UBI volume.
+ *
+ * @vol: user interfaces unit volume description object
+ *
+ * This function is called when an UBI volume is removed in order to remove
+ * corresponding MTD device. Returns zero in case of success and a negative
+ * error code in case of failure.
+ */
+int ubi_gluebi_vol_close(struct ubi_uif_volume *vol);
+
+#else
+
+struct ubi_gluebi_volume
+{
+};
+
+#define ubi_gluebi_vol_init(ubi, vol) ({int __ret; __ret = 0;})
+#define ubi_gluebi_vol_close(vol)     ({int __ret; __ret = 0;})
+
+#endif /* CONFIG_MTD_UBI_GLUEBI */
+#endif /* __UBI_GLUEBI_H__ */
