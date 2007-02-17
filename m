Return-Path: <linux-kernel-owner+w=401wt.eu-S965362AbXBQQ7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965362AbXBQQ7H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965361AbXBQQ6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:58:48 -0500
Received: from smtp.nokia.com ([131.228.20.172]:56748 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965351AbXBQQ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:58:41 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:55:09 +0200
Message-Id: <20070217165509.5845.12977.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/44 take 2] [UBI] debug unit header
X-OriginalArrivalTime: 17 Feb 2007 16:55:09.0423 (UTC) FILETIME=[61F29FF0:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185229-03D7DBB0-6F5ADB4D/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/debug.h tmp-to/drivers/mtd/ubi/debug.h
--- tmp-from/drivers/mtd/ubi/debug.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/debug.h	2007-02-17 18:07:26.000000000 +0200
@@ -0,0 +1,284 @@
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
+/**
+ * UBI debugging unit.
+ *
+ * UBI provides rich debugging capabilities which are implemented in
+ * this unit. The main feature provided by this unit is the debugging log.
+ * The debugging log is accessed via the "<debugfs>/ubi/log" file from
+ * user-space. The debugging prints may also be directed to the console. UBI
+ * distinguishes between debugging messages from different units and may switch
+ * them on and off separately.
+ */
+
+#ifndef __UBI_DEBUG_H__
+#define __UBI_DEBUG_H__
+
+#include <linux/init.h>
+
+#ifdef CONFIG_MTD_UBI_DEBUG
+
+#define UBI_DEBUG 1
+
+#define ubi_assert(expr) BUG_ON(!(expr))
+
+#define ubi_dbg_dump_stack() dump_stack()
+
+/* Debugging messages from different UBI units */
+
+/* A verbose error message */
+#define dbg_err(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_VB_ERR, __FUNCTION__, fmt, ##__VA_ARGS__)
+/* User interface unit */
+#define dbg_uif(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_UIF, __FUNCTION__, fmt, ##__VA_ARGS__)
+/* Character device handling sub-unit */
+#define dbg_cdev(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_CDEV, __FUNCTION__, fmt, ##__VA_ARGS__)
+/* Gluebi sub-unit */
+#define dbg_gluebi(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_GLUEBI, __FUNCTION__, fmt, ##__VA_ARGS__)
+/* Volume management unit */
+#define dbg_vmt(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_VMT, __FUNCTION__, fmt, ##__VA_ARGS__)
+/* Update unit */
+#define dbg_upd(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_UPD, __FUNCTION__, fmt, ##__VA_ARGS__)
+/* Volume table unit */
+#define dbg_vtbl(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_VTBL, __FUNCTION__, fmt, ##__VA_ARGS__)
+/* Accounting unit */
+#define dbg_acc(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_ACC, __FUNCTION__, fmt, ##__VA_ARGS__)
+/* Eraseblock association unit */
+#define dbg_eba(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_EBA, __FUNCTION__, fmt, ##__VA_ARGS__)
+/* Wear-leveling unit */
+#define dbg_wl(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_WL, __FUNCTION__, fmt, ##__VA_ARGS__)
+/* Background thread unit */
+#define dbg_bgt(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_BGT, __FUNCTION__, fmt, ##__VA_ARGS__)
+/* Input/output unit */
+#define dbg_io(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_IO, __FUNCTION__, fmt, ##__VA_ARGS__)
+/* Build unit */
+#define dbg_bld(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_BLD, __FUNCTION__, fmt, ##__VA_ARGS__)
+/* Scanning unit */
+#define dbg_scan(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_SCAN, __FUNCTION__, fmt, ##__VA_ARGS__)
+
+/**
+ * UBI message types.
+ *
+ * @UBI_DBG_VB_ERR: a verbose error message
+ * @UBI_DBG_UIF: a debugging message from the user interfaces unit
+ * @UBI_DBG_CDEV: a debugging message from the character device handling
+ * sub-unit.
+ * @UBI_DBG_GLUEBI: a debugging message from the gluebi sub-unit.
+ * @UBI_DBG_VMT: a debugging message from the volume management unit
+ * @UBI_DBG_UPD: a debugging message from the update unit
+ * @UBI_DBG_VTBL: a debugging message from the volume table unit
+ * @UBI_DBG_ACC: a debugging message from the accounting unit
+ * @UBI_DBG_EBA: a debugging message from the eraseblock association unit
+ * @UBI_DBG_WL: a debugging message from the wear-leveling unit
+ * @UBI_DBG_BGT: a debugging message from the background thread unit
+ * @UBI_DBG_IO: a debugging message from the input/output unit
+ * @UBI_DBG_BLD: a debugging message from the build unit
+ * @UBI_DBG_SCAN: a debugging message from the scanning unit
+ */
+enum {
+	UBI_DBG_VB_ERR,
+	UBI_DBG_UIF,
+	UBI_DBG_CDEV,
+	UBI_DBG_GLUEBI,
+	UBI_DBG_VMT,
+	UBI_DBG_UPD,
+	UBI_DBG_VTBL,
+	UBI_DBG_ACC,
+	UBI_DBG_EBA,
+	UBI_DBG_WL,
+	UBI_DBG_BGT,
+	UBI_DBG_IO,
+	UBI_DBG_BLD,
+	UBI_DBG_SCAN
+};
+
+/**
+ * ubi_dbg_print - print a message.
+ *
+ * @type: type of the message
+ * @func: printing function name
+ * @fmt: format string
+ *
+ * This function prints a message to the console, the debugging log, or both.
+ * Normal, warning, and error messages always go to both console and debugging
+ * log. Debugging messages always go to the debugging log, and if the
+ * corresponding option is enabled, they also go to the console.
+ */
+void ubi_dbg_print(int type, const char *func, const char *fmt, ...);
+
+struct ubi_info;
+struct ubi_ec_hdr;
+struct ubi_vid_hdr;
+struct ubi_vtbl_vtr;
+struct ubi_vol_tbl_record;
+struct ubi_scan_volume;
+struct ubi_scan_leb;
+struct ubi_mkvol_req;
+
+/**
+ * ubi_dbg_dump_ec_hdr - dump an erase counter header.
+ *
+ * @ec_hdr: the erase counter header to dump
+ */
+void ubi_dbg_dump_ec_hdr(const struct ubi_ec_hdr *ec_hdr);
+
+/**
+ * ubi_dbg_dump_vid_hdr - dump a volume identifier header.
+ *
+ * @vid_hdr: the volume identifier header to dump
+ */
+void ubi_dbg_dump_vid_hdr(const struct ubi_vid_hdr *vid_hdr);
+
+/**
+ * ubi_dbg_dump_vtr - dump a &struct ubi_vtbl_vtr object.
+ *
+ * @vtr: the object to dump
+ */
+void ubi_dbg_dump_vtr(const struct ubi_vtbl_vtr *vtr);
+
+/**
+ * ubi_dbg_dump_vol_tbl_record - dump a &struct ubi_vol_tbl_record object.
+ *
+ * @r: the object to dump
+ */
+void ubi_dbg_dump_vol_tbl_record(const struct ubi_vol_tbl_record *r);
+
+/**
+ * ubi_dbg_dump_sv - dump a &struct ubi_scan_volume object.
+ *
+ * @sv: the object to dump
+ */
+void ubi_dbg_dump_sv(const struct ubi_scan_volume *sv);
+
+
+/**
+ * ubi_dbg_dump_seb - dump a &struct ubi_scan_leb object.
+ *
+ * @seb: the object to dump
+ * @type: object type: 0 - not corrupted, 1 - corrupted
+ */
+void ubi_dbg_dump_seb(const struct ubi_scan_leb *seb, int type);
+
+/**
+ * ubi_dbg_dump_mkvol_req - dump a &struct ubi_mkvol_req object.
+ *
+ * @req: the object to dump
+ * @name: volume name in kernel memory
+ */
+void ubi_dbg_dump_mkvol_req(const struct ubi_mkvol_req *req, const char *name);
+
+/**
+ * ubi_dbg_hexdump - dump a buffer.
+ *
+ * @buf: the buffer to dump
+ * @size: buffer size which must be multiple of 4 bytes
+ */
+void ubi_dbg_hexdump(const void *buf, int size);
+
+/**
+ * ubi_dbg_is_bitflip - if its time to emulate a bit-flip.
+ *
+ * Returns non-zero if a bit-flip should be emulated, otherwise returns zero.
+ */
+int ubi_dbg_is_bitflip(void);
+
+/**
+ * ubi_dbg_is_write_failure - if its time to emulate a write failure.
+ *
+ * Returns non-zero if a write failure should be emulated, otherwise returns
+ * zero.
+ */
+int ubi_dbg_is_write_failure(void);
+
+/**
+ * ubi_dbg_is_erase_failure - if its time to emulate an erase failure.
+ *
+ * Returns non-zero if an erase failure should be emulated, otherwise returns
+ * zero.
+ */
+int ubi_dbg_is_erase_failure(void);
+
+/**
+ * ubi_dbg_init - initialize the debugging unit.
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int __init ubi_dbg_init(void);
+
+/**
+ * ubi_dbg_close - close the debugging unit.
+ */
+void __exit ubi_dbg_close(void);
+
+#else
+
+#define UBI_DEBUG 0
+
+#define ubi_assert(expr)    ({})
+
+#define dbg_err(fmt, ...)    ({})
+#define dbg_uif(fmt, ...)    ({})
+#define dbg_cdev(fmt, ...)   ({})
+#define dbg_gluebi(fmt, ...) ({})
+#define dbg_vmt(fmt, ...)    ({})
+#define dbg_upd(fmt, ...)    ({})
+#define dbg_vtbl(fmt, ...)   ({})
+#define dbg_acc(fmt, ...)    ({})
+#define dbg_eba(fmt, ...)    ({})
+#define dbg_wl(fmt, ...)     ({})
+#define dbg_bgt(fmt, ...)    ({})
+#define dbg_io(fmt, ...)     ({})
+#define dbg_bld(fmt, ...)    ({})
+#define dbg_scan(fmt, ...)   ({})
+
+#define ubi_dbg_print(func, fmt, ...)     ({})
+#define ubi_dbg_dump_stack()              ({})
+#define ubi_dbg_dump_ec_hdr(ec_hdr)       ({})
+#define ubi_dbg_dump_vid_hdr(vid_hdr)     ({})
+#define ubi_dbg_dump_vtr(vtr)             ({})
+#define ubi_dbg_dump_vol_tbl_record(r)    ({})
+#define ubi_dbg_dump_sv(sv)               ({})
+#define ubi_dbg_dump_seb(seb, type)       ({})
+#define ubi_dbg_dump_mkvol_req(req, name) ({})
+#define ubi_dbg_hexdump(buf, size)        ({})
+#define ubi_dbg_is_bitflip()               0
+#define ubi_dbg_is_write_failure()         0
+#define ubi_dbg_is_erase_failure()         0
+
+#define ubi_dbg_init()  0
+#define ubi_dbg_close()
+
+#endif /* !CONFIG_MTD_UBI_DEBUG */
+#endif /* !__UBI_DEBUG_H__ */
