Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbYCMWb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbYCMWb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758194AbYCMW3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:29:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:13615 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758180AbYCMW3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:29:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ATvpnAiP9fhFL4ikFiBsyNASJknppGRW24hVcP9Zs5KqFRVdJcQzS74fnUkvPbVqI7p9hlmJA1zlhfoI9ks8KZbvG0tcAGym39yTY/8GLrXedcgRfzL/2W/hmu4xC6T6dCBGb0a/HRox/KqsaTEjNGz9pviHonLORUO5Q9iN+Z4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 13 Mar 2008 23:44:19 +0100
Message-Id: <20080313224419.7051.7555.sendpatchset@localhost.localdomain>
In-Reply-To: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
References: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/12] alim15x3: add "pci_clock=" parameter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "pci_clock=" parameter for specifying PCI bus clock frequency (in MHz).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/alim15x3.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -40,6 +40,8 @@
 
 #define DISPLAY_ALI_TIMINGS
 
+static int pci_clock;
+
 /*
  *	ALi devices are not plug in. Otherwise these static values would
  *	need to go. They ought to go away anyway
@@ -294,7 +296,7 @@ static void ali_set_pio_mode(ide_drive_t
 	int s_time, a_time, c_time;
 	u8 s_clc, a_clc, r_clc;
 	unsigned long flags;
-	int bus_speed = system_bus_clock();
+	int bus_speed = pci_clock ? pci_clock : system_bus_clock();
 	int port = hwif->channel ? 0x5c : 0x58;
 	int portFIFO = hwif->channel ? 0x55 : 0x54;
 	u8 cd_dma_fifo = 0;
@@ -839,6 +841,9 @@ static int __init ali15x3_ide_init(void)
 
 module_init(ali15x3_ide_init);
 
+module_param(pci_clock, int, 0);
+MODULE_PARM_DESC(pci_clock, "PCI bus clock frequency (in MHz)");
+
 MODULE_AUTHOR("Michael Aubry, Andrzej Krzysztofowicz, CJ, Andre Hedrick, Alan Cox");
 MODULE_DESCRIPTION("PCI driver module for ALi 15x3 IDE");
 MODULE_LICENSE("GPL");
