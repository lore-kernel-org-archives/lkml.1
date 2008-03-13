Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbYCMWd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbYCMWd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758538AbYCMWa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:30:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:13615 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720AbYCMWa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:30:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=tkB7va8QDJPJapk8Q2JzUzP2ByToL2p6BeKlZ3+uevG4CF7ziGjXmCozOuFN0yC/eQqiNZslx6w8BpAxTHL/n6qxLJY98MYZ3DVN/AiCFANVBoxi0EIKvFjLPi2ESxQYWXWLgdEr1PHREMmrAvaOeUoSC4F3NyJy01cQNhgAZy8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 13 Mar 2008 23:45:07 +0100
Message-Id: <20080313224507.7051.33673.sendpatchset@localhost.localdomain>
In-Reply-To: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
References: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/12] ide: mark "idebus=" kernel parameter as obsoleted
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have per host driver "vlb|pci|cmd_clock=" parameters now.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/ide/ide.txt |   10 ----------
 drivers/ide/ide.c         |    2 +-
 2 files changed, 1 insertion(+), 11 deletions(-)

Index: b/Documentation/ide/ide.txt
===================================================================
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -214,16 +214,6 @@ Summary of ide driver parameters for ker
 
  "hdx=nodma"		: disallow DMA
 
- "idebus=xx"		: inform IDE driver of VESA/PCI bus speed in MHz,
-			  where "xx" is between 20 and 66 inclusive,
-			  used when tuning chipset PIO modes.
-			  For PCI bus, 25 is correct for a P75 system,
-			  30 is correct for P90,P120,P180 systems,
-			  and 33 is used for P100,P133,P166 systems.
-			  If in doubt, use idebus=33 for PCI.
-			  As for VLB, it is safest to not specify it.
-			  Bigger values are safer than smaller ones.
-
  "ide=reverse"		: formerly called to pci sub-system, but now local.
 
 The following are valid ONLY on ide0, which usually corresponds
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -979,7 +979,7 @@ static int __init ide_setup(char *s)
 			idebus_parameter = vals[0];
 		} else
 			printk(" -- BAD BUS SPEED! Expected value from 20 to 66");
-		goto done;
+		goto obsolete_option;
 	}
 
 bad_option:
