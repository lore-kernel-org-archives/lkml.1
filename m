Return-Path: <linux-kernel-owner+w=401wt.eu-S1764197AbXJRA4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764197AbXJRA4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761179AbXJRA4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:56:24 -0400
Received: from ozlabs.org ([203.10.76.45]:36523 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759618AbXJRA4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:56:22 -0400
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Linux IDE <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 18 Oct 2007 10:56:19 +1000
Subject: [PATCH 1/3] ide: Add ide_get_paired_drive() helper
In-Reply-To: <1192668978.21882.719539599813.qpush@grosgo>
Message-Id: <20071018005621.8F637DDEB8@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a helper to get to the "other" drive on a pair connected
to a given hwif.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Note: You may want to use the 1 - select.b.unit construct instead,
as you prefer, I just used what was there and fixed it.

 include/linux/ide.h |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-work/include/linux/ide.h
===================================================================
--- linux-work.orig/include/linux/ide.h	2007-10-18 10:41:42.000000000 +1000
+++ linux-work/include/linux/ide.h	2007-10-18 10:42:40.000000000 +1000
@@ -1454,4 +1454,11 @@ static inline int hwif_to_node(ide_hwif_
 	return dev ? pcibus_to_node(dev->bus) : -1;
 }
 
+static inline ide_drive_t *ide_get_paired_drive(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif	= HWIF(drive);
+
+	return &hwif->drives[(drive->dn ^ 1) & 1];
+}
+
 #endif /* _IDE_H */
