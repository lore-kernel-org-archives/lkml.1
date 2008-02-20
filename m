Return-Path: <linux-kernel-owner+w=401wt.eu-S1761739AbYBTIku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761739AbYBTIku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbYBTIkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:40:00 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42877 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbYBTIj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:39:59 -0500
Date: Wed, 20 Feb 2008 00:34:38 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 3/4] ide: use dev_to_node instead of pcibus_to_node
In-reply-to: <200802200015.43547.yinghai.lu@sun.com>
To: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802200034.38359.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802200015.43547.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when node0 doesn't have RAM, could have problem because pcibus_to_node may
return 0. So use update dev_to_node to get online node.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/include/linux/ide.h
===================================================================
--- linux-2.6.orig/include/linux/ide.h
+++ linux-2.6/include/linux/ide.h
@@ -1294,8 +1294,7 @@ static inline void ide_dump_identify(u8 
 
 static inline int hwif_to_node(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	return hwif->dev ? pcibus_to_node(dev->bus) : -1;
+	return hwif->dev ? dev_to_node(hwif->dev) : -1;
 }
 
 static inline ide_drive_t *ide_get_paired_drive(ide_drive_t *drive)



