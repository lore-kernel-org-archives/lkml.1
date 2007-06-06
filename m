Return-Path: <linux-kernel-owner+w=401wt.eu-S935135AbXFFTv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935135AbXFFTv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932372AbXFFTvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:51:46 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:34662 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932361AbXFFTvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:51:44 -0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
To: bzolnier@gmail.com, wildy@petra.hos.u-szeged.hu
Subject: [PATCH pata-2.6 fix] hpt366: disallow Ultra133 for HPT374
Date: Wed, 6 Jun 2007 23:53:28 +0400
User-Agent: KMail/1.5
Cc: linux-ide@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706062353.28707.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate UltraATA/133 support for HPT374 -- the chip isn't capable of this mode
according to the manual, and doesn't even seem to tolerate 66 MHz DPLL clock...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
 drivers/ide/pci/hpt366.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/ide/pci/hpt366.c
===================================================================
--- linux-2.6.orig/drivers/ide/pci/hpt366.c
+++ linux-2.6/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.03	May 4, 2007
+ * linux/drivers/ide/pci/hpt366.c		Version 1.04	Jun 4, 2007
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -106,7 +106,8 @@
  *   switch  to calculating  PCI clock frequency based on the chip's base DPLL
  *   frequency
  * - switch to using the  DPLL clock and enable UltraATA/133 mode by default on
- *   anything  newer than HPT370/A
+ *   anything  newer than HPT370/A (except HPT374 that is not capable of this
+ *   mode according to the manual)
  * - fold PCI clock detection and DPLL setup code into init_chipset_hpt366(),
  *   also fixing the interchanged 25/40 MHz PCI clock cases for HPT36x chips;
  *   unify HPT36x/37x timing setup code and the speedproc handlers by joining
@@ -365,7 +366,6 @@ static u32 sixty_six_base_hpt37x[] = {
 };
 
 #define HPT366_DEBUG_DRIVE_INFO		0
-#define HPT374_ALLOW_ATA133_6		1
 #define HPT371_ALLOW_ATA133_6		1
 #define HPT302_ALLOW_ATA133_6		1
 #define HPT372_ALLOW_ATA133_6		1
@@ -450,7 +450,7 @@ static struct hpt_info hpt370a __devinit
 
 static struct hpt_info hpt374 __devinitdata = {
 	.chip_type	= HPT374,
-	.max_mode	= HPT374_ALLOW_ATA133_6 ? 4 : 3,
+	.max_mode	= 3,
 	.dpll_clk	= 48,
 	.settings	= hpt37x_settings
 };

