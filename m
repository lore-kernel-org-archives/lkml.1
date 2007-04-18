Return-Path: <linux-kernel-owner+w=401wt.eu-S1422783AbXDRKG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422783AbXDRKG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 06:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422778AbXDRKG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 06:06:28 -0400
Received: from mx0.karneval.cz ([81.27.192.123]:14552 "EHLO av1.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422783AbXDRKG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 06:06:27 -0400
Message-id: <13586229432622914258@karneval.cz>
In-reply-to: <2428225437641930190@karneval.cz>
Subject: [PATCH 7/11] Char: cyclades, remove some global vars
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed, 18 Apr 2007 12:06:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, remove some global vars

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit b1b13ea51dcaef72c5298a04d233b92206adf978
tree a55032090e0b1c40e541685b49f8f608edf60611
parent 39e37f9c0e50657a546e20c2e37f58e0f260cdf6
author Jiri Slaby <jirislaby@gmail.com> Mon, 02 Apr 2007 12:50:04 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 10 Apr 2007 10:48:05 +0200

 drivers/char/cyclades.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 2abe6f2..1baf7d7 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -818,9 +818,6 @@ static int cy_chip_offset[] = { 0x0000,
 
 /* PCI related definitions */
 
-static unsigned short cy_pci_nboard;
-static unsigned short cy_isa_nboard;
-static unsigned short cy_nboard;
 #ifdef CONFIG_PCI
 static struct pci_device_id cy_pci_dev_id[] __devinitdata = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_Y_Lo) },	/* PCI < 1Mb */
@@ -5462,7 +5459,7 @@ static const struct tty_operations cy_ops = {
 
 static int __init cy_init(void)
 {
-	unsigned int i;
+	unsigned int i, nboards;
 
 	cy_serial_driver = alloc_tty_driver(NR_PORTS);
 	if (!cy_serial_driver)
@@ -5506,14 +5503,12 @@ static int __init cy_init(void)
 	   the cy_next_channel. */
 
 	/* look for isa boards */
-	cy_isa_nboard = cy_detect_isa();
+	nboards = cy_detect_isa();
 
 	/* look for pci boards */
-	cy_pci_nboard = cy_detect_pci();
-
-	cy_nboard = cy_isa_nboard + cy_pci_nboard;
+	nboards += cy_detect_pci();
 
-	return 0;
+	return nboards ? 0 : -ENODEV;
 }				/* cy_init */
 
 static void __exit cy_cleanup_module(void)
