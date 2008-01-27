Return-Path: <linux-kernel-owner+w=401wt.eu-S1757684AbYA0PUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbYA0PUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 10:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbYA0PUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 10:20:06 -0500
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85]:44130 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753714AbYA0PUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 10:20:04 -0500
From: Frans Pop <elendil@planet.nl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Use on-board instead of built-in in config options
Date: Sun, 27 Jan 2008 16:20:00 +0100
User-Agent: KMail/1.9.7
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <200801262043.17739.bzolnier@gmail.com> <Pine.LNX.4.64.0801262142300.15243@fbirervta.pbzchgretzou.qr> <200801262208.28859.bzolnier@gmail.com>
In-Reply-To: <200801262208.28859.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_hEKnHqzXzeaUrN+"
Message-Id: <200801271620.01629.elendil@planet.nl>
X-OriginalArrivalTime: 27 Jan 2008 15:20:02.0129 (UTC) FILETIME=[163CAC10:01C860F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_hEKnHqzXzeaUrN+
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 26 January 2008, Bartlomiej Zolnierkiewicz wrote:
> On Saturday 26 January 2008, Jan Engelhardt wrote:
> > On Jan 26 2008 21:31, Frans Pop wrote:
> > >>  config BLK_DEV_IDE_PMAC
> > >> -       bool "Builtin PowerMac IDE support"
> > >> +       tristate "Builtin PowerMac IDE support"
>
> this change is no-op at the moment because the next Kconfig line is:
>
> 	depends on PPC_PMAC && IDE=y && BLK_DEV_IDE=y
>
> [ PPC-specific IDE host drivers are still a special case because they are
>   using ppc_ide_md architecture hooks instead of doing proper host driver
>   initialization sequence - to be fixed after adding warm-plug support...
> ]
>
> > >This does not seem to make sense: if the option is now tristate, it is
> > > no longer "Builtin", so probably s/Builtin // in the description.
> >
> > Or something like s/Builtin/Onboard/;

I did not even consider that meaning of built-in, but that does seem more 
descriptive.

> Please send a patch.

Of course :-)

---
From: Frans Pop <elendil@planet.nl>

To avoid confusion between 'built-in' drivers and 'on-board'
controllers, consistently use the term 'on-board' for controllers.

Minor line-wrapping improvements in descriptions for config options.

Signed-off-by: Frans Pop <elendil@planet.nl>

---
Spelling for on-board seems to be rather inconsistent. All of "on board",
"on-board" and onboard currently occur. I've chosen "on-board" as that seems 
most correct to me.


--Boundary-00=_hEKnHqzXzeaUrN+
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="ide_use_on-board.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="ide_use_on-board.patch"

diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 64df55e..92b0117 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -617,8 +617,8 @@ config BLK_DEV_SC1200
 	tristate "National SCx200 chipset support"
 	select BLK_DEV_IDEDMA_PCI
 	help
-	  This driver adds support for the built in IDE on the National
-	  SCx200 series of embedded x86 "Geode" systems
+	  This driver adds support for the on-board IDE controller on the
+	  National SCx200 series of embedded x86 "Geode" systems.
 
 config BLK_DEV_PIIX
 	tristate "Intel PIIXn chipsets support"
@@ -793,22 +793,22 @@ config BLK_DEV_CELLEB
 	depends on PPC_CELLEB
 	select BLK_DEV_IDEDMA_PCI
 	help
-	  This driver provides support for the built-in IDE controller on
+	  This driver provides support for the on-board IDE controller on
 	  Toshiba Cell Reference Board.
 	  If unsure, say Y.
 
 endif
 
 config BLK_DEV_IDE_PMAC
-	tristate "Builtin PowerMac IDE support"
+	tristate "PowerMac on-board IDE support"
 	depends on PPC_PMAC && IDE=y && BLK_DEV_IDE=y
 	help
-	  This driver provides support for the built-in IDE controller on
+	  This driver provides support for the on-board IDE controller on
 	  most of the recent Apple Power Macintoshes and PowerBooks.
 	  If unsure, say Y.
 
 config BLK_DEV_IDE_PMAC_ATA100FIRST
-	bool "Probe internal ATA/100 (Kauai) first"
+	bool "Probe on-board ATA/100 (Kauai) first"
 	depends on BLK_DEV_IDE_PMAC
 	help
 	  This option will cause the ATA/100 controller found in UniNorth2
@@ -823,7 +823,7 @@ config BLK_DEV_IDEDMA_PMAC
 	depends on BLK_DEV_IDE_PMAC
 	select BLK_DEV_IDEDMA_PCI
 	help
-	  This option allows the driver for the built-in IDE controller on
+	  This option allows the driver for the on-board IDE controller on
 	  Power Macintoshes and PowerBooks to use DMA (direct memory access)
 	  to transfer data to and from memory.  Saying Y is safe and improves
 	  performance.
@@ -934,7 +934,7 @@ config BLK_DEV_GAYLE
 	help
 	  This is the IDE driver for the Amiga Gayle IDE interface. It supports
 	  both the `A1200 style' and `A4000 style' of the Gayle IDE interface,
-	  This includes builtin IDE interfaces on some Amiga models (A600,
+	  This includes on-board IDE interfaces on some Amiga models (A600,
 	  A1200, A4000, and A4000T), and IDE interfaces on the Zorro expansion
 	  bus (M-Tech E-Matrix 530 expansion card).
 	  Say Y if you have an Amiga with a Gayle IDE interface and want to use
@@ -948,10 +948,10 @@ config BLK_DEV_IDEDOUBLER
 	depends on BLK_DEV_GAYLE && EXPERIMENTAL
 	---help---
 	  This driver provides support for the so-called `IDE doublers' (made
-	  by various manufacturers, e.g. Eyetech) that can be connected to the
-	  builtin IDE interface of some Amiga models. Using such an IDE
-	  doubler, you can connect up to four instead of two IDE devices on
-	  the Amiga's builtin IDE interface.
+	  by various manufacturers, e.g. Eyetech) that can be connected to
+	  the on-board IDE interface of some Amiga models. Using such an IDE
+	  doubler, you can connect up to four instead of two IDE devices to
+	  the Amiga's on-board IDE interface.
 
 	  Note that the normal Amiga Gayle IDE driver may not work correctly
 	  if you have an IDE doubler and don't enable this driver!
@@ -963,9 +963,9 @@ config BLK_DEV_BUDDHA
 	tristate "Buddha/Catweasel/X-Surf IDE interface support (EXPERIMENTAL)"
 	depends on ZORRO && EXPERIMENTAL
 	help
-	  This is the IDE driver for the IDE interfaces on the Buddha, 
-	  Catweasel and X-Surf expansion boards.  It supports up to two interfaces 
-	  on the Buddha, three on the Catweasel and two on the X-Surf.
+	  This is the IDE driver for the IDE interfaces on the Buddha, Catweasel
+	  and X-Surf expansion boards.  It supports up to two interfaces on the
+	  Buddha, three on the Catweasel and two on the X-Surf.
 
 	  Say Y if you have a Buddha or Catweasel expansion board and want to
 	  use IDE devices (hard disks, CD-ROM drives, etc.) that are connected
@@ -975,23 +975,23 @@ config BLK_DEV_FALCON_IDE
 	tristate "Falcon IDE interface support"
 	depends on ATARI
 	help
-	  This is the IDE driver for the builtin IDE interface on the Atari
+	  This is the IDE driver for the on-board IDE interface on the Atari
 	  Falcon. Say Y if you have a Falcon and want to use IDE devices (hard
-	  disks, CD-ROM drives, etc.) that are connected to the builtin IDE
+	  disks, CD-ROM drives, etc.) that are connected to the on-board IDE
 	  interface.
 
 config BLK_DEV_MAC_IDE
 	tristate "Macintosh Quadra/Powerbook IDE interface support"
 	depends on MAC
 	help
-	  This is the IDE driver for the builtin IDE interface on some m68k
+	  This is the IDE driver for the on-board IDE interface on some m68k
 	  Macintosh models. It supports both the `Quadra style' (used in
 	  Quadra/ Centris 630 and Performa 588 models) and `Powerbook style'
 	  (used in the Powerbook 150 and 190 models) IDE interface.
 
 	  Say Y if you have such an Macintosh model and want to use IDE
 	  devices (hard disks, CD-ROM drives, etc.) that are connected to the
-	  builtin IDE interface.
+	  on-board IDE interface.
 
 config BLK_DEV_Q40IDE
 	tristate "Q40/Q60 IDE interface support"
@@ -1062,8 +1062,8 @@ config BLK_DEV_ALI14XX
 	  boot parameter.  It enables support for the secondary IDE interface
 	  of the ALI M1439/1443/1445/1487/1489 chipsets, and permits faster
 	  I/O speeds to be set as well.  See the files
-	  <file:Documentation/ide.txt> and <file:drivers/ide/legacy/ali14xx.c> for
-	  more info.
+	  <file:Documentation/ide.txt> and <file:drivers/ide/legacy/ali14xx.c>
+	  for more info.
 
 config BLK_DEV_DTC2278
 	tristate "DTC-2278 support"
@@ -1088,8 +1088,8 @@ config BLK_DEV_QD65XX
 	help
 	  This driver is enabled at runtime using the "qd65xx.probe" kernel
 	  boot parameter.  It permits faster I/O speeds to be set.  See the
-	  <file:Documentation/ide.txt> and <file:drivers/ide/legacy/qd65xx.c> for
-	  more info.
+	  <file:Documentation/ide.txt> and <file:drivers/ide/legacy/qd65xx.c>
+	  for more info.
 
 config BLK_DEV_UMC8672
 	tristate "UMC-8672 support"

--Boundary-00=_hEKnHqzXzeaUrN+--
