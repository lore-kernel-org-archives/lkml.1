Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbYJVQI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbYJVQI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757136AbYJVQHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:07:41 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:4808 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129AbYJVQHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:07:39 -0400
Date: Wed, 22 Oct 2008 11:07:36 -0500
From: Mike Miller <mike.miller@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/1] cciss: new hardware support
Message-ID: <20081022160736.GA11270@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 of 1

This patch adds support for 2 new SAS/SATA controllers. Please consider this
for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/Documentation/cciss.txt b/Documentation/cciss.txt
index 8244c64..48d80d9 100644
--- a/Documentation/cciss.txt
+++ b/Documentation/cciss.txt
@@ -26,6 +26,8 @@ This driver is known to work with the following cards:
 	* SA P410i
 	* SA P411
 	* SA P812
+	* SA P712m
+	* SA P711m
 
 Detecting drive failures:
 -------------------------
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index eb68f39..3c7316c 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -96,6 +96,8 @@ static const struct pci_device_id cciss_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3245},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3247},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324A},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324B},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
@@ -133,6 +135,8 @@ static struct board_type products[] = {
 	{0x3245103C, "Smart Array P410i", &SA5_access},
 	{0x3247103C, "Smart Array P411", &SA5_access},
 	{0x3249103C, "Smart Array P812", &SA5_access},
+	{0x324A103C, "Smart Array P712m", &SA5_access},
+	{0x324B103C, "Smart Array P711m", &SA5_access},
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
 
