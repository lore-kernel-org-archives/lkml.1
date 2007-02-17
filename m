Return-Path: <linux-kernel-owner+w=401wt.eu-S2992479AbXBQRHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992479AbXBQRHP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992732AbXBQRHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:07:14 -0500
Received: from smtp.nokia.com ([131.228.20.173]:35105 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992727AbXBQRG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:06:56 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:57:10 +0200
Message-Id: <20070217165710.5845.51361.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 33/44 take 2] [UBI] volume management unit header
X-OriginalArrivalTime: 17 Feb 2007 16:57:10.0386 (UTC) FILETIME=[AA0C1D20:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185340-0B110BB0-25C54BB8/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/volmgmt.h tmp-to/drivers/mtd/ubi/volmgmt.h
--- tmp-from/drivers/mtd/ubi/volmgmt.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/volmgmt.h	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,129 @@
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
+ * UBI volume management unit.
+ *
+ * The unit is responsible for creation, deletion, updating and resizing
+ * of volumes.
+ */
+
+#ifndef __UBI_VOLMGMT_H__
+#define __UBI_VOLMGMT_H__
+
+#include <linux/mutex.h>
+
+struct ubi_info;
+struct ubi_scan_info;
+struct ubi_vol_info;
+struct ubi_vtbl_vtr;
+
+/**
+ * ubi_vmt_get_data_info - get volume data description.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the requested volume
+ *
+ * This function returns a pointer to the corresponding data description
+ * object.
+ */
+const struct ubi_vmt_data_info *
+ubi_vmt_get_data_info(const struct ubi_info *ubi, int vol_id);
+
+/**
+ * ubi_vmt_mkvol - create a volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID to assign to the new volume
+ * @vtr: volume table record corresponding to the new volume
+ *
+ * If @vol_id id %UBI_VOL_NUM_AUTO then new volume is automatically given an
+ * unused volume identifier. The @vtr->usable_leb_size field is ignored.
+ *
+ * This function returns the ID of the newly created volume in case of success,
+ * and a negative error code in case of failure.
+ */
+int ubi_vmt_mkvol(const struct ubi_info *ubi, int vol_id,
+		  const struct ubi_vtbl_vtr *vtr);
+
+/**
+ * ubi_vmt_rmvol - remove a volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume to remove
+ *
+ * This function returns zero in case of success, and a negative error code in
+ * case of failure.
+ */
+int ubi_vmt_rmvol(const struct ubi_info *ubi, int vol_id);
+
+/**
+ * ubi_vmt_rsvol - re-size a volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume to re-size
+ * @reserved_pebs: new volume size
+ *
+ * This function returns zero in case of success, and a negative error code in
+ * case of failure.
+ */
+int ubi_vmt_rsvol(const struct ubi_info *ubi, int vol_id, int reserved_pebs);
+
+/**
+ * ubi_vmt_truncate_volume - make sure the volume contains only 0xFF bytes.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume to free
+ *
+ * This function erases all the volume's eraseblocks. Returns zero in case of
+ * success, and a negative error code in case of failure.
+ */
+int ubi_vmt_truncate_volume(const struct ubi_info *ubi, int vol_id);
+
+/**
+ * ubi_vmt_init_scan - initialize the volume management unit using scanning
+ * information.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information
+ *
+ * This function returns zero in case of success, and a negative error code in
+ * case of failure.
+ */
+int ubi_vmt_init_scan(struct ubi_info *ubi, struct ubi_scan_info *si);
+
+/**
+ * ubi_vmt_close - close the volume management unit.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_vmt_close(const struct ubi_info *ubi);
+
+/**
+ * struct ubi_vmt_info - volume management unit description data
+ * structure.
+ *
+ * @mutex: a mutex to serialize volume changes
+ */
+struct ubi_vmt_info {
+	struct mutex mutex; /* private */
+};
+
+#endif /* !__UBI_VOLMGMT_H__ */
