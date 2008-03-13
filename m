Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbYCMWcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbYCMWcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758477AbYCMWaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:30:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:13615 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758456AbYCMWaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:30:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=AKFTJ4VyoSvSwhZnUGFnoh3bkwB0hMUY1kalM5pkJyLW5oHGvH7XxCU7ioaf6Bpst9wQ/d7ui15caEEmfol3vSTaKqnkwqiLNzyB5X4HnqbMA3wUjjzjkj87+MO2/Dlnb2x6HvUm1lfGpaS2ZPTQzj1Jn0Q5bnJ6AY0mHeywhhw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 13 Mar 2008 23:44:53 +0100
Message-Id: <20080313224453.7051.50484.sendpatchset@localhost.localdomain>
In-Reply-To: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
References: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/12] via82cxxx: add "pci_clock=" parameter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "pci_clock=" parameter for specifying PCI bus clock frequency (in MHz).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/via82cxxx.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -94,6 +94,8 @@ static struct via_isa_bridge {
 	{ NULL }
 };
 
+static int pci_clock;
+
 static unsigned int via_clock;
 static char *via_dma[] = { "16", "25", "33", "44", "66", "100", "133" };
 
@@ -340,7 +342,7 @@ static unsigned int __devinit init_chips
 	 * Determine system bus clock.
 	 */
 
-	via_clock = system_bus_clock() * 1000;
+	via_clock = (pci_clock ? pci_clock : system_bus_clock()) * 1000;
 
 	switch (via_clock) {
 		case 33000: via_clock = 33333; break;
@@ -495,6 +497,9 @@ static int __init via_ide_init(void)
 
 module_init(via_ide_init);
 
+module_param(pci_clock, int, 0);
+MODULE_PARM_DESC(pci_clock, "PCI bus clock frequency (in MHz)");
+
 MODULE_AUTHOR("Vojtech Pavlik, Michel Aubry, Jeff Garzik, Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for VIA IDE");
 MODULE_LICENSE("GPL");
