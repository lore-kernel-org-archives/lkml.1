Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbYHUNV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbYHUNV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbYHUNVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:21:19 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:34111 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbYHUNVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:21:18 -0400
Message-ID: <48AD6B93.7020702@csr.com>
Date: Thu, 21 Aug 2008 14:20:19 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
CC: linux-usb <linux-usb@vger.kernel.org>, torvalds@linux-foundation.org
Subject: [patch] Add helper macros for little-endian bitfields
References: <48AD6AF0.3050504@csr.com>
In-Reply-To: <48AD6AF0.3050504@csr.com>
Content-Type: multipart/mixed;
 boundary="------------010508050907080502090104"
X-OriginalArrivalTime: 21 Aug 2008 13:20:19.0528 (UTC) FILETIME=[A894FC80:01C90390]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010508050907080502090104
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/

--------------010508050907080502090104
Content-Type: text/x-diff;
 name="add-linux-byteorder-bitfields.h.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="add-linux-byteorder-bitfields.h.patch"

Add helper macros for little-endian bitfields

From: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>

This adds some macros to help in defining structures with little-endian
values with bitfields.  Useful when defining hardware interfaces.

Signed-off-by: David Vrabel <david.vrabel@csr.com>
---
 include/linux/byteorder/bitfields.h |  114 ++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

Index: linux-2.6/include/linux/byteorder/bitfields.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/linux/byteorder/bitfields.h	2008-05-13 09:44:16.000000000 +0100
@@ -0,0 +1,114 @@
+/*
+ * Helpers for defining little-endian bitfields
+ *
+ * Copyright (C) 2007 Intel Corporation
+ * Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef __LINUX__BYTEORDER__BITFIELDS_H__
+#define __LINUX__BYTEORDER__BITFIELDS_H__
+
+#include <asm/byteorder.h>
+
+/*
+ * Declare Little Endian bitfields
+ *
+ * These macros are used to switch the order of the bitfields when
+ * packing with Little Endian in mind (ie: for mapping to a hw type
+ * that you have to send or read from a device).
+ *
+ * NOTE: When using multibyte bitfields, you need to convert the data
+ *       from Little Endian to CPU before you can access the bitfield
+ *       (to make it simpler):
+ *
+ *       union something {
+ *               le16 value;
+ *               DECL_BF_LE3(
+ *                       u16  bf0:3,
+ *                       u16  bf1:10,
+ *                       u16  bf2:3
+ *               ) __attribute__((packed));
+ *       };
+ *
+ *       ...
+ *
+ *       union something s;
+ *
+ *       s.value = le16_to_cpu(something LE read from hw);
+ *       frame_count = s.bf1;
+ *
+ */
+#ifdef __LITTLE_ENDIAN_BITFIELD
+#define DECL_BF_LE2(a, b)                   struct { a; b; }
+#define DECL_BF_LE3(a, b, c)                struct { a; b; c; }
+#define DECL_BF_LE4(a, b, c, d)             struct { a; b; c; d ; }
+#define DECL_BF_LE5(a, b, c, d, e)          struct { a; b; c; d; e; }
+#define DECL_BF_LE6(a, b, c, d, e, f)       struct { a; b; c; d; e; f; }
+#define DECL_BF_LE7(a, b, c, d, e, f, g)    struct { a; b; c; d; e; f; g; }
+#define DECL_BF_LE8(a, b, c, d, e, f, g, h) struct { a; b; c; d; e; f; g; h; }
+#define DECL_BF_LE9(a, b, c, d, e, f, g, h, i) \
+	struct { a; b; c; d; e; f; g; h; i; }
+#define DECL_BF_LE10(a, b, c, d, e, f, g, h, i, j) \
+	struct { a; b; c; d; e; f; g; h; i; j; }
+#define DECL_BF_LE11(a, b, c, d, e, f, g, h, i, j, k) \
+	struct { a; b; c; d; e; f; g; h; i; j; k; }
+#define DECL_BF_LE12(a, b, c, d, e, f, g, h, i, j, k, l) \
+	struct { a; b; c; d; e; f; g; h; i; j; k; l; }
+#define DECL_BF_LE13(a, b, c, d, e, f, g, h, i, j, k, l, m) \
+	struct { a; b; c; d; e; f; g; h; i; j; k; l; m; }
+#define DECL_BF_LE14(a, b, c, d, e, f, g, h, i, j, k, l, m, n) \
+	struct { a; b; c; d; e; f; g; h; i; j; k; l; m; n; }
+#define DECL_BF_LE15(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o) \
+	struct { a; b; c; d; e; f; g; h; i; j; k; l; m; n; o; }
+#define DECL_BF_LE16(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p) \
+	struct { a; b; c; d; e; f; g; h; i; j; k; l; m; n; o; p; }
+
+#else
+#ifdef __BIG_ENDIAN_BITFIELD
+
+#define DECL_BF_LE2(a, b)                   struct { b; a; }
+#define DECL_BF_LE3(a, b, c)                struct { c; b; a; }
+#define DECL_BF_LE4(a, b, c, d)             struct { d; c; b; a; }
+#define DECL_BF_LE5(a, b, c, d, e)          struct { e; d; c; b; a; }
+#define DECL_BF_LE6(a, b, c, d, e, f)       struct { f; e; d; c; b; a; }
+#define DECL_BF_LE7(a, b, c, d, e, f, g)    struct { g; f; e; d; c; b; a; }
+#define DECL_BF_LE8(a, b, c, d, e, f, g, h) struct { h; g; f; e; d; c; b; a; }
+#define DECL_BF_LE9(a, b, c, d, e, f, g, h, i) \
+	struct { i; h; g; f; e; d; c; b; a; }
+#define DECL_BF_LE10(a, b, c, d, e, f, g, h, i, j) \
+	struct { j; i; h; g; f; e; d; c; b; a; }
+#define DECL_BF_LE11(a, b, c, d, e, f, g, h, i, j, k) \
+	struct { k; j; i; h; g; f; e; d; c; b; a; }
+#define DECL_BF_LE12(a, b, c, d, e, f, g, h, i, j, k, l) \
+	struct { l; k; j; i; h; g; f; e; d; c; b; a; }
+#define DECL_BF_LE13(a, b, c, d, e, f, g, h, i, j, k, l, m) \
+	struct { m; l; k; j; i; h; g; f; e; d; c; b; a; }
+#define DECL_BF_LE14(a, b, c, d, e, f, g, h, i, j, k, l, m, n) \
+	struct { n; m; l; k; j; i; h; g; f; e; d; c; b; a; }
+#define DECL_BF_LE15(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o) \
+	struct { o; n; m; l; k; j; i; h; g; f; e; d; c; b; a; }
+#define DECL_BF_LE16(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p) \
+	struct { p; o; n; m; l; k; j; i; h; g; f; e; d; c; b; a; }
+
+#else
+
+#error Unknown endianess for Little Endian bitfield definition
+
+#endif
+#endif
+
+#endif /* #ifndef __LINUX__BYTEORDER__BITFIELDS_H__ */

--------------010508050907080502090104--
