Return-Path: <linux-kernel-owner+w=401wt.eu-S2992466AbXBQQ4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992466AbXBQQ4M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992469AbXBQQ4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:56:11 -0500
Received: from smtp.nokia.com ([131.228.20.170]:52300 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992465AbXBQQz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:55:56 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:54:49 +0200
Message-Id: <20070217165449.5845.18238.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/44 take 2] [UBI] internal common header
X-OriginalArrivalTime: 17 Feb 2007 16:54:49.0314 (UTC) FILETIME=[55F63C20:01C752B4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/ubi.h tmp-to/drivers/mtd/ubi/ubi.h
--- tmp-from/drivers/mtd/ubi/ubi.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/ubi.h	2007-02-17 18:07:26.000000000 +0200
@@ -0,0 +1,100 @@
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
+#ifndef __UBI_UBI_H__
+#define __UBI_UBI_H__
+
+#include <linux/mtd/ubi.h>
+
+/* Version of this UBI implementation */
+#define UBI_VERSION 1
+
+/* Maximum number of supported UBI devices */
+#define UBI_MAX_INSTANCES 32
+
+/* UBI messages printk level */
+#define UBI_MSG_LEVEL  KERN_INFO
+#define UBI_WARN_LEVEL KERN_WARNING
+#define UBI_ERR_LEVEL  KERN_ERR
+
+/* Prefixes of UBI messages */
+#define UBI_MSG_PREF  "UBI:"
+#define UBI_WARN_PREF "UBI warning:"
+#define UBI_ERR_PREF  "UBI error:"
+
+/* Normal UBI messages */
+#define ubi_msg(fmt, ...)                                                   \
+	printk(UBI_MSG_LEVEL UBI_MSG_PREF " " fmt "\n", ##__VA_ARGS__)
+/* UBI warning messages */
+#define ubi_warn(fmt, ...)                                                  \
+	printk(UBI_WARN_LEVEL UBI_WARN_PREF " %s: " fmt "\n", __FUNCTION__, \
+	       ##__VA_ARGS__)
+/* UBI error messages */
+#define ubi_err(fmt, ...)                                                   \
+	printk(UBI_ERR_LEVEL UBI_ERR_PREF " %s " fmt "\n", __FUNCTION__,    \
+	       ##__VA_ARGS__)
+
+struct ubi_io_info;
+struct ubi_bgt_info;
+struct ubi_wl_info;
+struct ubi_beb_info;
+struct ubi_vmt_info;
+struct ubi_ivol_info;
+struct ubi_vtbl_info;
+struct ubi_acc_info;
+struct ubi_upd_info;
+struct ubi_eba_info;
+struct ubi_uif_info;
+
+/**
+ * struct ubi_info - UBI device description structure
+ *
+ * @ubi_num: number of the UBI device
+ * @io: input/output unit information
+ * @bgt: background thread unit information
+ * @wl: wear-leveling unit information
+ * @beb: bad eraseblock handling unit information
+ * @vmt: volume management unit information
+ * @ivol: internal volume management unit information
+ * @vtbl: volume table unit information
+ * @acc: accounting unit information
+ * @upd: update unit information
+ * @eba: EBA unit information
+ * @uif: user interface unit information
+ */
+struct ubi_info {
+	int ubi_num;
+	struct ubi_io_info   *io;
+	struct ubi_bgt_info  *bgt;
+	struct ubi_wl_info   *wl;
+	struct ubi_beb_info  *beb;
+	struct ubi_vmt_info  *vmt;
+	struct ubi_ivol_info *ivol;
+	struct ubi_vtbl_info *vtbl;
+	struct ubi_acc_info  *acc;
+	struct ubi_upd_info  *upd;
+	struct ubi_eba_info  *eba;
+	struct ubi_uif_info  *uif;
+};
+
+extern int ubis_num;
+extern struct ubi_info *ubis[UBI_MAX_INSTANCES];
+
+#endif /* !__UBI_UBI_H__ */
