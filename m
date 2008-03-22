Return-Path: <linux-kernel-owner+w=401wt.eu-S1755031AbYCVQKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbYCVQKH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 12:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbYCVQJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 12:09:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:39995 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYCVQJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 12:09:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=uYM7MgtsrfJQYJwAy+VxiAm6dFYqgxLRg9gbBRSZazv9c9oIWADYct3Scbmt9mfVaPZbbpuArcV8DCEeA0SLClR9SSTy/49aGqv808511ffKRLDrB3Iz5ZUgD016SCWP8UxQEeEZ3fFALMgJd9sl1o96BuT1uWypvVGWU7wxF3I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/3] ide: mark "idebus=" kernel parameter as obsoleted (take 2)
Date: Sat, 22 Mar 2008 17:22:44 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803221722.44733.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have "vlb|pci_clock=" parameters now.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/ide/ide.txt   |   10 ----------
 drivers/ide/ide.c           |    2 +-
 drivers/ide/legacy/qd65xx.c |    2 --
 drivers/ide/pci/cy82c693.c  |    2 --
 drivers/ide/pci/opti621.c   |    3 +--
 5 files changed, 2 insertions(+), 17 deletions(-)

Index: b/Documentation/ide/ide.txt
===================================================================
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -205,16 +205,6 @@ Summary of ide driver parameters for ker
 
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
  "ide=doubler"		: probe/support IDE doublers on Amiga
 
 There may be more options than shown -- use the source, Luke!
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -969,7 +969,7 @@ static int __init ide_setup(char *s)
 			idebus_parameter = vals[0];
 		} else
 			printk(" -- BAD BUS SPEED! Expected value from 20 to 66");
-		goto done;
+		goto obsolete_option;
 	}
 
 bad_option:
Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -11,8 +11,6 @@
  *
  * QDI QD6500/QD6580 EIDE controller fast support
  *
- * Please set local bus speed using kernel parameter idebus
- * 	for example, "idebus=33" stands for 33Mhz VLbus
  * To activate controller support, use "ide0=qd65xx"
  * To enable tuning, use "hda=autotune hdb=autotune"
  * To enable 2nd channel tuning (qd6580 only), use "hdc=autotune hdd=autotune"
Index: b/drivers/ide/pci/cy82c693.c
===================================================================
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -18,8 +18,6 @@
  *   hdparm -t reports 8.17 MB/sec at about 6% CPU usage for the DTTA
  * - this is my first linux driver, so there's probably a lot  of room
  *   for optimizations and bug fixing, so feel free to do it.
- * - use idebus=xx parameter to set PCI bus speed - needed to calc
- *   timings for PIO modes (default will be 40)
  * - if using PIO mode it's a good idea to set the PIO mode and
  *   32-bit I/O support (if possible), e.g. hdparm -p2 -c1 /dev/hda
  * - I had some problems with my IBM DHEA with PIO modes < 2
Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -53,8 +53,7 @@
  * If you then set the second drive to another PIO, the old value
  * (automatically selected) will be overrided by yours.
  * There is a 25/33MHz switch in configuration
- * register, but driver is written for use at any frequency which get
- * (use idebus=xx to select PCI bus speed).
+ * register, but driver is written for use at any frequency.
  *
  * Version 0.1, Nov 8, 1996
  * by Jaromir Koutek, for 2.1.8.
