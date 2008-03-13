Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbYCMWbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbYCMWbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758238AbYCMW3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:29:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:14483 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232AbYCMW3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:29:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=dcyhGjoGLvxY8qUUjzqawkesUxO0EhS6pIj9vQpgPRV+kVM6SNM3v4WW1X5CuMa4SgU9v7SCh30/Ovd8auLk5HjqILBzSMAKeQi4anHjzBOWUvePpRUv0BFh0+VXo+6c5/82eP64XmIxCB1AQ+31nUdyspiYSlA+2Sa8ZIFrRnU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 13 Mar 2008 23:44:26 +0100
Message-Id: <20080313224426.7051.37571.sendpatchset@localhost.localdomain>
In-Reply-To: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
References: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/12] amd74xx: add "pci_clock=" parameter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "pci_clock=" parameter for specifying PCI bus clock frequency (in MHz).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/amd74xx.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -32,6 +32,8 @@ enum {
 	AMD_UDMA_TIMING		= 0x50,
 };
 
+static int pci_clock;
+
 static unsigned int amd_80w;
 static unsigned int amd_clock;
 
@@ -179,7 +181,7 @@ static unsigned int __devinit init_chips
  * Determine the system bus clock.
  */
 
-	amd_clock = system_bus_clock() * 1000;
+	amd_clock = (pci_clock ? pci_clock : system_bus_clock()) * 1000;
 
 	switch (amd_clock) {
 		case 33000: amd_clock = 33333; break;
@@ -353,6 +355,9 @@ static int __init amd74xx_ide_init(void)
 
 module_init(amd74xx_ide_init);
 
+module_param(pci_clock, int, 0);
+MODULE_PARM_DESC(pci_clock, "PCI bus clock frequency (in MHz)");
+
 MODULE_AUTHOR("Vojtech Pavlik");
 MODULE_DESCRIPTION("AMD PCI IDE driver");
 MODULE_LICENSE("GPL");
