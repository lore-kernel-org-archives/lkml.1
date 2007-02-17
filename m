Return-Path: <linux-kernel-owner+w=401wt.eu-S2992616AbXBQRCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992616AbXBQRCf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992484AbXBQRCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:02:35 -0500
Received: from smtp.nokia.com ([131.228.20.170]:53094 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992617AbXBQRBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:01:36 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:54:59 +0200
Message-Id: <20070217165459.5845.18967.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/44 take 2] [UBI] misc unit header
X-OriginalArrivalTime: 17 Feb 2007 16:54:59.0376 (UTC) FILETIME=[5BF59300:01C752B4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/misc.h tmp-to/drivers/mtd/ubi/misc.h
--- tmp-from/drivers/mtd/ubi/misc.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/misc.h	2007-02-17 18:07:26.000000000 +0200
@@ -0,0 +1,146 @@
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
+ * Here we keep miscellaneous functions which are used all over the UBI code and
+ * do not really belong to any particular unit.
+ */
+
+#ifndef __UBI_MISC_H__
+#define __UBI_MISC_H__
+
+#include <linux/rbtree.h>
+
+struct ubi_info;
+
+#define xquotise(s) #s
+#define quotise(s) xquotise(s)
+
+/**
+ * rb_for_each_entry - walk an RB-tree.
+ *
+ * @rb: a pointer to type 'struct rb_node' to to use as a loop counter
+ * @pos: a pointer to RB-tree entry type to use as a loop counter
+ * @root: RB-tree's root
+ * @member: the name of the 'struct rb_node' within the RB-tree entry
+ */
+#define rb_for_each_entry(rb, pos, root, member)                             \
+	for (rb = rb_first(root),                                            \
+	     pos = (rb ? container_of(rb, typeof(*pos), member) : NULL);     \
+	     rb;                                                             \
+	     rb = rb_next(rb), pos = container_of(rb, typeof(*pos), member))
+
+/*
+ * align_up - align an integer to another integer.
+ *
+ * @x: the integer to align
+ * @y: the integer to align to
+ *
+ * This function returns the lowest number which is multiple to @y and not less
+ * then @x.
+ */
+static inline int align_up(int x, int y)
+{
+	return y*(x/y) + (!!(x % y)) * y;
+}
+
+/*
+ * align_down - align an integer to another integer.
+ *
+ * @x: the integer to align
+ * @y: the integer to align to
+ *
+ * This function returns the highest number which is multiple to @y and not
+ * greater then @x.
+ */
+static inline int align_down(int x, int y)
+{
+	return y*(x/y) - (!!(x % y)) * y;
+}
+
+/**
+ * ubi_buf_all_ff - check if buffer contains only 0xFF bytes.
+ *
+ * @buf: buffer to check
+ * @size: buffer size in bytes
+ *
+ * This function returns non-zero in there are only 0xFF bytes in @buf, and
+ * zero if something else was also found.
+ */
+int ubi_buf_all_ff(const void *buf, int size);
+
+/**
+ * ubi_buf_all_zeroes - check if buffer contains only zeroes.
+ *
+ * @buf: buffer to check
+ * @size: buffer size in bytes
+ *
+ * This function returns non-zero in there are only 0 bytes in @buf, and
+ * zero if something else was also found.
+ */
+int ubi_buf_all_zeroes(const void *buf, int size);
+
+/**
+ * ubi_check_pattern - check if buffer contains only a certain byte pattern.
+ *
+ * @buf: buffer to check
+ * @patt: the pattern to check
+ * @size: buffer size in bytes
+ *
+ * This function returns non-zero in there are only @patt bytes in @buf, and
+ * zero if something else was also found.
+ */
+int ubi_check_pattern(const void *buf, uint8_t patt, int size);
+
+/**
+ * strdup_len - duplicate a string with known length.
+ *
+ * @str: original string
+ * @len: the length of the string
+ */
+char *strdup_len(const char *str, int len);
+
+/**
+ * calc_data_len - calculate how much real data is stored in a buffer.
+ *
+ * @ubi: the UBI device description object
+ * @buf: a buffer with the contents of the physical eraseblock
+ * @length: the buffer length
+ *
+ * This function calculates how much real data is stored in @buf. Continuous
+ * 0xFF bytes at the end of the buffer are not considered as data.
+ */
+int ubi_calc_data_len(const struct ubi_info *ubi, const void *buf,
+		      int length);
+
+/**
+ * ubi_check_volume - check the contents of a (static) volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume to check
+ *
+ * This function checks if a static volume is corrupted by fully reading it and
+ * checking data CRC. This function returns %0 if the volume is not corrupted,
+ * %1 if it is corrupted and a negative error code in case of failure. Dynamic
+ * volumes are not checked and zero is returned immediately.
+ */
+int ubi_check_volume(const struct ubi_info *ubi, int vol_id);
+
+#endif /* !__UBI_MISC_H__ */
