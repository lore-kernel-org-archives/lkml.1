Return-Path: <linux-kernel-owner+w=401wt.eu-S1762037AbXILHjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762037AbXILHjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbXILHjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:39:40 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:59126 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbXILHjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:39:39 -0400
Date: Wed, 12 Sep 2007 03:39:20 -0400
From: Nathanael Nerode <neroden@fastmail.fm>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] dgrs: remove from build, config, and maintainer list
Message-ID: <20070912073920.GA6608@doctormoo.dyndns.org>
Reply-To: neroden@gcc.gnu.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathanael Nerode

Stop building and configuring driver for Digi RightSwitch, which was 
never actually sold to anyone, and remove it from MAINTAINERS.

In response to an investigation into the firmware of the "Digi Rightswitch" 
driver, Andres Salomon discovered:
>
> Dear Andres:
>
> After further research, we found that this product was killed in place
> and never reached the market.  We would like to request that this not be
> included.  

Since the product never reached market, clearly nobody is using this orphaned 
driver.

Signed-off-by: Nathanael Nerode <neroden@gcc.gnu.org>

---

This is patch 1 of 2 for removing the "Digi Rightswitch" (dgrs).

Patch 2 would be the patch to remove the actual files.  However, that would
be around 400K, which doesn't seem suitable for a mailing list -- and this 
length seems quite unnecessary, given that it would consist solely of full-file 
deletions.  I'm not quite sure what to do about this.  Please advise.

These are the files to be deleted:
./Documentation/networking/dgrs.txt
./drivers/net/dgrs.c
./drivers/net/dgrs.h
./drivers/net/dgrs_asstruct.h
./drivers/net/dgrs_bcomm.h
./drivers/net/dgrs_es4h.h
./drivers/net/dgrs_ether.h
./drivers/net/dgrs_firmware.c (this is the very large one)
./drivers/net/dgrs_i82596.h
./drivers/net/dgrs_plx9060.h

diff -upr linux-2.6.22.6/drivers/net/Kconfig linux-2.6-deleted/drivers/net/Kconfig
--- linux-2.6.22.6/drivers/net/Kconfig	2007-08-31 02:21:01.000000000 -0400
+++ linux-2.6-deleted/drivers/net/Kconfig	2007-09-12 03:28:11.000000000 -0400
@@ -1447,21 +1447,6 @@ config TC35815
 	depends on NET_PCI && PCI && MIPS
 	select MII
 
-config DGRS
-	tristate "Digi Intl. RightSwitch SE-X support"
-	depends on NET_PCI && (PCI || EISA)
-	---help---
-	  This is support for the Digi International RightSwitch series of
-	  PCI/EISA Ethernet switch cards. These include the SE-4 and the SE-6
-	  models.  If you have a network card of this type, say Y and read the
-	  Ethernet-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.  More specific
-	  information is contained in <file:Documentation/networking/dgrs.txt>.
-
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module
-	  will be called dgrs.
-
 config EEPRO100
 	tristate "EtherExpressPro/100 support (eepro100, original Becker driver)"
 	depends on NET_PCI && PCI
diff -upr linux-2.6.22.6/drivers/net/Makefile linux-2.6-deleted/drivers/net/Makefile
--- linux-2.6.22.6/drivers/net/Makefile	2007-08-31 02:21:01.000000000 -0400
+++ linux-2.6-deleted/drivers/net/Makefile	2007-09-12 03:28:31.000000000 -0400
@@ -38,7 +38,6 @@ obj-$(CONFIG_CASSINI) += cassini.o
 obj-$(CONFIG_MACE) += mace.o
 obj-$(CONFIG_BMAC) += bmac.o
 
-obj-$(CONFIG_DGRS) += dgrs.o
 obj-$(CONFIG_VORTEX) += 3c59x.o
 obj-$(CONFIG_TYPHOON) += typhoon.o
 obj-$(CONFIG_NE2K_PCI) += ne2k-pci.o 8390.o
diff -upr linux-2.6.22.6/MAINTAINERS linux-2.6-deleted/MAINTAINERS
--- linux-2.6.22.6/MAINTAINERS	2007-08-31 02:21:01.000000000 -0400
+++ linux-2.6-deleted/MAINTAINERS	2007-09-12 03:27:26.000000000 -0400
@@ -1234,12 +1234,6 @@ L:	Eng.Linux@digi.com
 W:	http://www.digi.com
 S:	Orphaned
 
-DIGI RIGHTSWITCH NETWORK DRIVER
-P:	Rick Richardson
-L:	netdev@vger.kernel.org
-W:	http://www.digi.com
-S:	Orphaned
-
 DIRECTORY NOTIFICATION
 P:	Stephen Rothwell
 M:	sfr@canb.auug.org.au

-- 
Nathanael Nerode  <neroden@fastmail.fm>

[Insert famous quote here]
