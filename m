Return-Path: <linux-kernel-owner+w=401wt.eu-S1422772AbXD3CsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422772AbXD3CsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 22:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422773AbXD3CsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 22:48:13 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:24266 "EHLO
	outbound2-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422772AbXD3CsL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 22:48:11 -0400
X-BigFish: V
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [patch] Add the combined mode for ATI SB700
Date: Mon, 30 Apr 2007 10:47:56 +0800
Message-ID: <FFECF24D2A7F6D418B9511AF6F35860201927D4C@shacnexch2.atitech.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] Add the combined mode for ATI SB700
Thread-Index: AceK0fSiek2XN5NIT1a3dfTsNtOlDw==
From: "Henry Su" <henry.su@amd.com>
To: <mj@ucw.cz>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 30 Apr 2007 02:48:01.0369 (UTC) FILETIME=[F7CF1490:01C78AD1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: henry.su@amd.com
Besides those modes in ATI SB600 SATA controller, ATI SB700 supports one
more mode:the combined mode. \
The combined mode is a Legacy IDE mode used for compatibility with some
old OS without AHCI driver, \
but now it is not necessary for Linux since the kernel has supported
AHCI. 
Signed-off-by: Luugi Marsan <luugi.marsan@amd.com>
------------------------------------
diff -Nur linux-2.6.21.orig/include/linux/pci_ids.h
linux-2.6.21/include/linux/pci_ids.h
--- linux-2.6.21.orig/include/linux/pci_ids.h 2007-04-29
07:00:04.000000000 +0800
+++ linux-2.6.21/include/linux/pci_ids.h 2007-04-29 07:49:00.000000000 
+++ +0800
@@ -371,6 +371,7 @@
#define PCI_DEVICE_ID_ATI_IXP600_SRAID 0x4381 
#define PCI_DEVICE_ID_ATI_IXP600_SMBUS 0x4385 
#define PCI_DEVICE_ID_ATI_IXP600_IDE 0x438c
+#define PCI_DEVICE_ID_ATI_IXP700_SATA 0x4390

#define PCI_VENDOR_ID_VLSI 0x1004
#define PCI_DEVICE_ID_VLSI_82C592 0x0005

diff -Nur linux-2.6.21.orig/drivers/pci/quirks.c
linux-2.6.21/drivers/pci/quirks.c
--- linux-2.6.21.orig/drivers/pci/quirks.c 2007-04-29 07:00:15.000000000
+0800
+++ linux-2.6.21/drivers/pci/quirks.c 2007-04-29 07:35:53.000000000 
+++ +0800
@@ -875,6 +875,7 @@
}
}
DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI,
PCI_DEVICE_ID_ATI_IXP600_SATA, quirk_sb600_sata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, 
+PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_sb600_sata);

/*
* Serverworks CSB5 IDE does not fully support native mode




