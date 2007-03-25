Return-Path: <linux-kernel-owner+w=401wt.eu-S932255AbXCYSD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbXCYSD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 14:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932263AbXCYSD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 14:03:27 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:54198 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbXCYSDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 14:03:22 -0400
X-Originating-Ip: 74.109.98.130
Date: Sun, 25 Mar 2007 13:59:36 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] PCMCIA: Allow PCMCIA SCSI drivers to be built into the
 kernel.
Message-ID: <Pine.LNX.4.64.0703251353260.25176@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the Kconfig requirement that the PCMCIA SCSI drivers be built
only as modules, and allow them to be built into the kernel.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

i imagine there's a historical reason for these drivers being forced
to be built only as modules.  and i'm not sure whether i should have
CCed the SCSI folks, the PCMCIA folks, or both.  or whatever.

compile-tested on x86 with "make allyesconfig".

diff --git a/drivers/scsi/pcmcia/Kconfig b/drivers/scsi/pcmcia/Kconfig
index eac8e17..7dd787f 100644
--- a/drivers/scsi/pcmcia/Kconfig
+++ b/drivers/scsi/pcmcia/Kconfig
@@ -3,11 +3,11 @@
 #

 menu "PCMCIA SCSI adapter support"
-	depends on SCSI!=n && PCMCIA!=n && MODULES
+	depends on SCSI!=n && PCMCIA!=n

 config PCMCIA_AHA152X
 	tristate "Adaptec AHA152X PCMCIA support"
-	depends on m && !64BIT
+	depends on !64BIT
 	select SCSI_SPI_ATTRS
 	help
 	  Say Y here if you intend to attach this type of PCMCIA SCSI host
@@ -18,7 +18,6 @@ config PCMCIA_AHA152X

 config PCMCIA_FDOMAIN
 	tristate "Future Domain PCMCIA support"
-	depends on m
 	help
 	  Say Y here if you intend to attach this type of PCMCIA SCSI host
 	  adapter to your computer.
@@ -28,7 +27,7 @@ config PCMCIA_FDOMAIN

 config PCMCIA_NINJA_SCSI
 	tristate "NinjaSCSI-3 / NinjaSCSI-32Bi (16bit) PCMCIA support"
-	depends on m && !64BIT
+	depends on !64BIT
 	help
 	  If you intend to attach this type of PCMCIA SCSI host adapter to
 	  your computer, say Y here and read
@@ -62,7 +61,6 @@ config PCMCIA_NINJA_SCSI

 config PCMCIA_QLOGIC
 	tristate "Qlogic PCMCIA support"
-	depends on m
 	help
 	  Say Y here if you intend to attach this type of PCMCIA SCSI host
 	  adapter to your computer.
@@ -72,7 +70,6 @@ config PCMCIA_QLOGIC

 config PCMCIA_SYM53C500
 	tristate "Symbios 53c500 PCMCIA support"
-	depends on m
 	help
 	  Say Y here if you have a New Media Bus Toaster or other PCMCIA
 	  SCSI adapter based on the Symbios 53c500 controller.
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
