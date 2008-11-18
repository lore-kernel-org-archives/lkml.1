Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbYKRRSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbYKRRSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbYKRROr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:14:47 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4563 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbYKRRO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:14:26 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@strlen.de>,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH 02/10] MAINTAINERS - Add file patterns
Date: Tue, 18 Nov 2008 09:13:14 -0800
Message-Id: <1227028402-1548-3-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1227028402-1548-1-git-send-email-joe@perches.com>
References: <1227028402-1548-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better description of file pattern tag "F:"
Add file exclusion tag "X:"
Add patterns to sections

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 1109 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 1108 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 627e4c8..bd28571 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -72,7 +72,6 @@ M: Mail patches to
 L: Mailing list that is relevant to this area
 W: Web-page with status/info
 T: SCM tree type and location.  Type is one of: git, hg, quilt.
-F: Applicable files and/or directories
 S: Status, one of the following:
 
 	Supported:	Someone is actually paid to look after this.
@@ -85,23 +84,40 @@ S: Status, one of the following:
 			it has been replaced by a better system and you
 			should be using that.
 
+F: Files and directories with wildcard patterns.
+   A trailing slash includes all files and subdirectory files.
+	F:	drivers/net/	all files in and below drivers/net
+	F:	drivers/net/*	all files in drivers/net, but not below
+	F:	*/net/*		all files in "any top level directory"/net
+   One pattern per line.  Multiple F: lines acceptable.
+X: Files and directories that are NOT maintained, same rules as F:
+   Files exclusions are tested before file matches.
+   Can be useful for excluding a specific subdirectory, for instance:
+	F:	net/
+	X:	net/ipv6/
+   matches all files in and below net excluding net/ipv6/
+
 3C505 NETWORK DRIVER
 P:	Philip Blundell
 M:	philb@gnu.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/3c505*
 
 3C59X NETWORK DRIVER
 P:	Steffen Klassert
 M:	klassert@mathematik.tu-chemnitz.de
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	Documentation/networking/vortex.txt
+F:	drivers/net/3c59x.c
 
 3CR990 NETWORK DRIVER
 P:	David Dillow
 M:	dave@thedillows.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/typhoon*
 
 3W-9XXX SATA-RAID CONTROLLER DRIVER
 P:	Adam Radford
@@ -109,6 +125,7 @@ M:	linuxraid@amcc.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.amcc.com
 S:	Supported
+F:	drivers/scsi/3w-9xxx*
 
 3W-XXXX ATA-RAID CONTROLLER DRIVER
 P:	Adam Radford
@@ -116,24 +133,28 @@ M:	linuxraid@amcc.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.amcc.com
 S:	Supported
+F:	drivers/scsi/3w-xxxx*
 
 53C700 AND 53C700-66 SCSI DRIVER
 P:	James E.J. Bottomley
 M:	James.Bottomley@HansenPartnership.com
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/53c700*
 
 6PACK NETWORK DRIVER FOR AX.25
 P:	Andreas Koensgen
 M:	ajk@iehk.rwth-aachen.de
 L:	linux-hams@vger.kernel.org
 S:	Maintained
+F:	drivers/net/hamradio/6pack.c
 
 8169 10/100/1000 GIGABIT ETHERNET DRIVER
 P:	Francois Romieu
 M:	romieu@fr.zoreil.com
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/r8169.c
 
 8250/16?50 (AND CLONE UARTS) SERIAL DRIVER
 L:	linux-serial@vger.kernel.org
@@ -145,6 +166,8 @@ P:	Paul Gortmaker
 M:	p_gortmaker@yahoo.com
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/*8390*
+F:	drivers/net/ax88796.c
 
 9P FILE SYSTEM
 P:	Eric Van Hensbergen
@@ -157,12 +180,14 @@ L:	v9fs-developer@lists.sourceforge.net
 W:	http://swik.net/v9fs
 T:	git kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
 S:	Maintained
+F:	fs/9p/
 
 A2232 SERIAL BOARD DRIVER
 P:	Enver Haase
 M:	A2232@gmx.net
 L:	linux-m68k@lists.linux-m68k.org
 S:	Maintained
+F:	drivers/char/ser_a2232*
 
 AACRAID SCSI RAID DRIVER
 P:	Adaptec OEM Raid Solutions
@@ -170,24 +195,29 @@ M:	aacraid@adaptec.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.adaptec.com/
 S:	Supported
+F:	Documentation/scsi/aacraid.txt
+F:	drivers/scsi/aacraid/
 
 ABIT UGURU 1,2 HARDWARE MONITOR DRIVER
 P:	Hans de Goede
 M:	j.w.r.degoede@hhs.nl
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	drivers/hwmon/abituguru.c
 
 ABIT UGURU 3 HARDWARE MONITOR DRIVER
 P:	Alistair John Strachan
 M:	alistair@devzero.co.uk
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	drivers/hwmon/abituguru3.c
 
 ACENIC DRIVER
 P:	Jes Sorensen
 M:	jes@trained-monkey.org
 L:	linux-acenic@sunsite.dk
 S:	Maintained
+F:	drivers/net/acenic*
 
 ACER WMI LAPTOP EXTRAS
 P:	Carlos Corbacho
@@ -195,6 +225,7 @@ M:	carlos@strangeworlds.co.uk
 L:	aceracpi@googlegroups.com (subscribers-only)
 W:	http://code.google.com/p/aceracpi
 S:	Maintained
+F:	drivers/misc/acer-wmi.c
 
 ACPI
 P:	Len Brown
@@ -203,6 +234,9 @@ L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 T:	git kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
 S:	Supported
+F:	drivers/acpi/
+F:	drivers/pnp/pnpacpi/
+F:	include/linux/acpi.h
 
 ACPI BATTERY DRIVERS
 P:	Alexey Starikovskiy
@@ -210,6 +244,8 @@ M:	astarikovskiy@suse.de
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 S:	Supported
+F:	drivers/acpi/battery.c
+F:	drivers/acpi/*sbs*
 
 ACPI EC DRIVER
 P:	Alexey Starikovskiy
@@ -217,6 +253,7 @@ M:	astarikovskiy@suse.de
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 S:	Supported
+F:	drivers/acpi/ec.c
 
 ACPI FAN DRIVER
 P:	Zhang Rui
@@ -224,12 +261,14 @@ M:	rui.zhang@intel.com
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 S:	Supported
+F:	drivers/acpi/fan.c
 
 ACPI PCI HOTPLUG DRIVER
 P:	Kristen Carlson Accardi
 M:	kristen.c.accardi@intel.com
 L:	linux-pci@vger.kernel.org
 S:	Supported
+F:	drivers/pci/hotplug/acpi*
 
 ACPI THERMAL DRIVER
 P:	Zhang Rui
@@ -237,6 +276,7 @@ M:	rui.zhang@intel.com
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 S:	Supported
+F:	drivers/acpi/*thermal*
 
 ACPI VIDEO DRIVER
 P:	Zhang Rui
@@ -244,6 +284,7 @@ M:	rui.zhang@intel.com
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 S:	Supported
+F:	drivers/acpi/video.c
 
 ACPI WMI DRIVER
 P:	Carlos Corbacho
@@ -251,6 +292,7 @@ M:	carlos@strangeworlds.co.uk
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 S:	Maintained
+F:	drivers/acpi/wmi.c
 
 AD1889 ALSA SOUND DRIVER
 P:	Kyle McMartin
@@ -260,18 +302,22 @@ M:	T-Bone@parisc-linux.org
 W:	http://wiki.parisc-linux.org/AD1889
 L:	linux-parisc@vger.kernel.org
 S:	Maintained
+F:	sound/pci/ad1889.*
 
 ADM1025 HARDWARE MONITOR DRIVER
 P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/adm1025
+F:	drivers/hwmon/adm1025.c
 
 ADM1029 HARDWARE MONITOR DRIVER
 P:	Corentin Labbe
 M:	corentin.labbe@geomatys.fr
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	drivers/hwmon/adm1029.c
 
 ADM8211 WIRELESS DRIVER
 P:	Michael Wu
@@ -280,57 +326,74 @@ L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
 S:	Maintained
+F:	drivers/net/wireless/adm8211.*
 
 ADT746X FAN DRIVER
 P:	Colin Leroy
 M:	colin@colino.net
 S:	Maintained
+F:	drivers/macintosh/therm_adt746x.c
 
 ADVANSYS SCSI DRIVER
 P:	Matthew Wilcox
 M:	matthew@wil.cx
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	Documentation/scsi/advansys.txt
+F:	drivers/scsi/advansys.c
 
 AEDSP16 DRIVER
 P:	Riccardo Facchetti
 M:	fizban@tin.it
 S:	Maintained
+F:	sound/oss/aedsp16.c
 
 AFFS FILE SYSTEM
 P:	Roman Zippel
 M:	zippel@linux-m68k.org
 S:	Maintained
+F:	fs/affs/
 
 AFS FILESYSTEM & AF_RXRPC SOCKET DOMAIN
 P:	David Howells
 M:	dhowells@redhat.com
 L:	linux-afs@lists.infradead.org
 S:	Supported
+F:	fs/afs/
+F:	include/net/af_rxrpc.h
+F:	net/rxrpc/af_rxrpc.c
 
 AGPGART DRIVER
 P:	David Airlie
 M:	airlied@linux.ie
 T:	git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
+F:	drivers/char/agp/
+F:	include/linux/agp*
 
 AHA152X SCSI DRIVER
 P:	Juergen E. Fischer
 M:	Juergen Fischer <fischer@norbit.de>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/aha152x*
+F:	drivers/scsi/pcmcia/aha152x*
 
 AIC7XXX / AIC79XX SCSI DRIVER
 P:	Hannes Reinecke
 M:	hare@suse.de
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/aic7xxx/
+F:	drivers/scsi/aic7xxx_old/
 
 AIO
 P:	Benjamin LaHaise
 M:	bcrl@kvack.org
 L:	linux-aio@kvack.org
 S:	Supported
+F:	fs/aio.c
+F:	include/linux/*aio*.h
 
 ALCATEL SPEEDTOUCH USB DRIVER
 P:	Duncan Sands
@@ -338,17 +401,22 @@ M:	duncan.sands@free.fr
 L:	linux-usb@vger.kernel.org
 W:	http://www.linux-usb.org/SpeedTouch/
 S:	Maintained
+F:	drivers/usb/atm/speedtch.c
+F:	drivers/usb/atm/usbatm.c
 
 ALCHEMY AU1XX0 MMC DRIVER
 P:	Manuel Lauss
 M:	manuel.lauss@gmail.com
 S:	Maintained
+F:	drivers/mmc/host/au1xmmc.c
 
 ALI1563 I2C DRIVER
 P:	Rudolf Marek
 M:	r.marek@assembler.cz
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
+F:	Documentation/i2c/busses/i2c-ali1563
+F:	drivers/i2c/busses/i2c-ali1563.c
 
 ALPHA PORT
 P:	Richard Henderson
@@ -357,18 +425,25 @@ S:	Odd Fixes for 2.4; Maintained for 2.6.
 P:	Ivan Kokshaysky
 M:	ink@jurassic.park.msu.ru
 S:	Maintained for 2.4; PCI support for 2.6.
+F:	arch/alpha/
 
 AMD GEODE CS5536 USB DEVICE CONTROLLER DRIVER
 P:	Thomas Dahlmann
 M:	thomas.dahlmann@amd.com
 L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
+F:	drivers/usb/gadget/amd5536udc.*
 
 AMD GEODE PROCESSOR/CHIPSET SUPPORT
 P:	Jordan Crouse
 L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.amd.com/us-en/ConnectivitySolutions/TechnicalResources/0,,50_2334_2452_11363,00.html
 S:	Supported
+F:	arch/x86/kernel/geode_32.c
+F:	drivers/char/hw_random/geode-rng.c
+F:	drivers/crypto/geode*
+F:	drivers/video/geode/
+F:	arch/x86/include/asm/geode.h
 
 AMD IOMMU (AMD-VI)
 P:	Joerg Roedel
@@ -382,6 +457,7 @@ P:      Andreas Herrmann
 M:      andeas.herrmann3@amd.com
 L:      amd64-microcode@amd64.org
 S:      Supported
+F:	arch/x86/kernel/microcode_amd.c
 
 AMS (Apple Motion Sensor) DRIVER
 P:	Stelian Pop
@@ -389,6 +465,7 @@ M:	stelian@popies.net
 P:	Michael Hanselmann
 M:	linux-kernel@hansmi.ch
 S:	Supported
+F:	drivers/hwmon/ams/
 
 AMSO1100 RNIC DRIVER
 P:	Tom Tucker
@@ -397,6 +474,7 @@ P:	Steve Wise
 M:	swise@opengridcomputing.com
 L:	general@lists.openfabrics.org
 S:	Maintained
+F:	drivers/infiniband/hw/amso1100/
 
 AOA (Apple Onboard Audio) ALSA DRIVER
 P:	Johannes Berg
@@ -404,6 +482,7 @@ M:	johannes@sipsolutions.net
 L:	linuxppc-dev@ozlabs.org
 L:	alsa-devel@alsa-project.org (subscribers-only)
 S:	Maintained
+F:	sound/aoa/
 
 APM DRIVER
 P:	Stephen Rothwell
@@ -411,48 +490,63 @@ M:	sfr@canb.auug.org.au
 L:	linux-laptop@vger.kernel.org
 W:	http://www.canb.auug.org.au/~sfr/
 S:	Supported
+F:	arch/x86/kernel/apm_32.c
+F:	include/linux/apm_bios.h
 
 APPLE BCM5974 MULTITOUCH DRIVER
 P:	Henrik Rydberg
 M:	rydberg@euromail.se
 L:	linux-input@vger.kernel.org
 S:	Maintained
+F:	drivers/input/mouse/bcm5974.c
 
 APPLE SMC DRIVER
 P:	Nicolas Boichat
 M:	nicolas@boichat.ch
 L:	mactel-linux-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/hwmon/applesmc.c
 
 APPLETALK NETWORK LAYER
 P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
 S:	Maintained
+F:	drivers/net/appletalk/
+F:	net/appletalk/
 
 APPLETOUCH TOUCHPAD DRIVER
 P:	Johannes Berg
 M:	johannes@sipsolutions.net
 L:	linux-input@vger.kernel.org
 S:	Maintained
+F:	Documentation/input/appletouch.txt
+F:	drivers/input/mouse/appletouch.c
 
 ARC FRAMEBUFFER DRIVER
 P:	Jaya Kumar
 M:	jayalk@intworks.biz
 S:	Maintained
+F:	drivers/video/arcfb.c
+F:	drivers/video/fb_defio.c
 
 ARM MFM AND FLOPPY DRIVERS
 P:	Ian Molton
 M:	spyro@f2s.com
 S:	Maintained
+F:	arch/arm/lib/floppydma.S
+F:	arch/arm/include/asm/floppy.h
 
 ARM PRIMECELL MMCI PL180/1 DRIVER
 S:	Orphan
+F:	drivers/mmc/host/mmci.*
 
 ARM/ADI ROADRUNNER MACHINE SUPPORT
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-ixp23xx/
+F:	arch/arm/mach-ixp23xx/include/mach/
 
 ARM/ADS SPHERE MACHINE SUPPORT
 P:	Lennert Buytenhek
@@ -706,12 +800,14 @@ L:	acpi4asus-user@lists.sourceforge.net
 W:	http://sourceforge.net/projects/acpi4asus
 W:	http://xf.iksaif.net/acpi4asus
 S:	Maintained
+F:	drivers/acpi/asus_acpi.c
 
 ASUS ASB100 HARDWARE MONITOR DRIVER
 P:	Mark M. Hoffman
 M:	mhoffman@lightlink.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	drivers/hwmon/asb100.c
 
 ASUS LAPTOP EXTRAS DRIVER
 P:	Corentin Chary
@@ -720,6 +816,7 @@ L:	acpi4asus-user@lists.sourceforge.net
 W:	http://sourceforge.net/projects/acpi4asus
 W:	http://xf.iksaif.net/acpi4asus
 S:	Maintained
+F:	drivers/misc/asus-laptop.c
 
 ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
 P:	Dan Williams
@@ -729,12 +826,19 @@ M:	maciej.sosnowski@intel.com
 L:	linux-kernel@vger.kernel.org
 W:	http://sourceforge.net/projects/xscaleiop
 S:	Supported
+F:	Documentation/crypto/async-tx-api.txt
+F:	crypto/async_tx/
+F:	drivers/dma/
+F:	include/linux/dmaengine.h
+F:	include/linux/async_tx.h
 
 ATA OVER ETHERNET (AOE) DRIVER
 P:	Ed L. Cashin
 M:	ecashin@coraid.com
 W:	http://www.coraid.com/support/linux
 S:	Supported
+F:	Documentation/aoe/
+F:	drivers/block/aoe/
 
 ATHEROS ATH5K WIRELESS DRIVER
 P:	Jiri Slaby
@@ -748,6 +852,7 @@ M:	me@bobcopeland.com
 L:	linux-wireless@vger.kernel.org
 L:	ath5k-devel@lists.ath5k.org
 S:	Maintained
+F:	drivers/net/wireless/ath5k/
 
 ATHEROS ATH9K WIRELESS DRIVER
 P:	Luis R. Rodriguez
@@ -757,11 +862,13 @@ M:	jmalinen@atheros.com
 L:	linux-wireless@vger.kernel.org
 L:	ath9k-devel@lists.ath9k.org
 S:	Supported
+F:	drivers/net/wireless/ath9k/
 
 ATI_REMOTE2 DRIVER
 P:	Ville Syrjala
 M:	syrjala@sci.fi
 S:	Maintained
+F:	drivers/input/misc/ati_remote2.c
 
 ATLX ETHERNET DRIVERS
 P:	Jay Cliburn
@@ -774,6 +881,7 @@ L:	atl1-devel@lists.sourceforge.net
 W:	http://sourceforge.net/projects/atl1
 W:	http://atl1.sourceforge.net
 S:	Maintained
+F:	drivers/net/atlx/
 
 ATM
 P:	Chas Williams
@@ -781,6 +889,8 @@ M:	chas@cmf.nrl.navy.mil
 L:	linux-atm-general@lists.sourceforge.net (subscribers-only)
 W:	http://linux-atm.sourceforge.net
 S:	Maintained
+F:	drivers/atm/
+F:	include/linux/atm*
 
 ATMEL AT91 MCI DRIVER
 P:	Nicolas Ferre
@@ -789,28 +899,34 @@ L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 W:	http://www.atmel.com/products/AT91/
 W:	http://www.at91.com/
 S:	Maintained
+F:	drivers/mmc/host/at91_mci.c
 
 ATMEL AT91 / AT32 SERIAL DRIVER
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	drivers/serial/atmel_serial.c
 
 ATMEL LCDFB DRIVER
 P:	Nicolas Ferre
 M:	nicolas.ferre@atmel.com
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
+F:	drivers/video/atmel_lcdfb.c
+F:	include/video/atmel_lcdc.h
 
 ATMEL MACB ETHERNET DRIVER
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
 S:	Supported
+F:	drivers/net/macb.*
 
 ATMEL SPI DRIVER
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
 S:	Supported
+F:	drivers/spi/atmel_spi.*
 
 ATMEL USBA UDC DRIVER
 P:	Haavard Skinnemoen
@@ -818,6 +934,7 @@ M:	hskinnemoen@atmel.com
 L:	kernel@avr32linux.org
 W:	http://avr32linux.org/twiki/bin/view/Main/AtmelUsbDeviceDriver
 S:	Supported
+F:	drivers/usb/gadget/atmel_usba_udc.*
 
 ATMEL WIRELESS DRIVER
 P:	Simon Kelley
@@ -826,6 +943,7 @@ L:	linux-wireless@vger.kernel.org
 W:	http://www.thekelleys.org.uk/atmel
 W:	http://atmelwlandriver.sourceforge.net/
 S:	Maintained
+F:	drivers/net/wireless/atmel*
 
 AUDIT SUBSYSTEM
 P:	Al Viro
@@ -836,6 +954,8 @@ L:	linux-audit@redhat.com (subscribers-only)
 W:	http://people.redhat.com/sgrubb/audit/
 T:	git git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git
 S:	Maintained
+F:	include/linux/audit.h
+F:	kernel/audit*
 
 AUXILIARY DISPLAY DRIVERS
 P:	Miguel Ojeda Sandonis
@@ -844,6 +964,8 @@ L:	linux-kernel@vger.kernel.org
 W:	http://miguelojeda.es/auxdisplay.htm
 W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
+F:	drivers/auxdisplay/
+F:	include/linux/cfag12864b.h
 
 AVR32 ARCHITECTURE
 P:	Haavard Skinnemoen
@@ -852,11 +974,13 @@ W:	http://www.atmel.com/products/AVR32/
 W:	http://avr32linux.org/
 W:	http://avrfreaks.net/
 S:	Supported
+F:	arch/avr32/
 
 AVR32/AT32AP MACHINE SUPPORT
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
 S:	Supported
+F:	arch/avr32/mach-at32ap/
 
 AX.25 NETWORK LAYER
 P:	Ralf Baechle
@@ -864,6 +988,9 @@ M:	ralf@linux-mips.org
 L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
+F:	include/linux/ax25.h
+F:	include/net/ax25.h
+F:	net/ax25/
 
 B43 WIRELESS DRIVER
 P:	Michael Buesch
@@ -873,6 +1000,7 @@ M:	stefano.brivio@polimi.it
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/en/users/Drivers/b43
 S:	Maintained
+F:	drivers/net/wireless/b43/
 
 B43LEGACY WIRELESS DRIVER
 P:	Larry Finger
@@ -882,11 +1010,14 @@ M:	stefano.brivio@polimi.it
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/en/users/Drivers/b43
 S:	Maintained
+F:	drivers/net/wireless/b43legacy/
 
 BACKLIGHT CLASS/SUBSYSTEM
 P:	Richard Purdie
 M:	rpurdie@rpsys.net
 S:	Maintained
+F:	drivers/video/backlight/
+F:	include/linux/backlight.h
 
 BAYCOM/HDLCDRV DRIVERS FOR AX.25
 P:	Thomas Sailer
@@ -894,18 +1025,21 @@ M:	t.sailer@alumni.ethz.ch
 L:	linux-hams@vger.kernel.org
 W:	http://www.baycom.org/~tom/ham/ham.html
 S:	Maintained
+F:	drivers/net/hamradio/baycom*
 
 BEFS FILE SYSTEM
 P:	Sergey S. Kostyliov
 M:	rathamahata@php4.ru
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	fs/befs/
 
 BFS FILE SYSTEM
 P:	Tigran A. Aivazian
 M:	tigran@aivazian.fsnet.co.uk
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	fs/bfs/
 
 BLACKFIN ARCHITECTURE
 P:	Bryan Wu
@@ -913,6 +1047,7 @@ M:	cooloney@kernel.org
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
+F:	arch/blackfin/
 
 BLACKFIN EMAC DRIVER
 P:	Bryan Wu
@@ -920,6 +1055,7 @@ M:	cooloney@kernel.org
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
+F:	drivers/net/bfin_mac.*
 
 BLACKFIN RTC DRIVER
 P:	Mike Frysinger
@@ -927,6 +1063,7 @@ M:	vapier.adi@gmail.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
+F:	drivers/rtc/rtc-bfin.c
 
 BLACKFIN SERIAL DRIVER
 P:	Sonic Zhang
@@ -934,6 +1071,7 @@ M:	sonic.zhang@analog.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
+F:	drivers/serial/bfin_5xx.c
 
 BLACKFIN WATCHDOG DRIVER
 P:	Mike Frysinger
@@ -941,6 +1079,7 @@ M:	vapier.adi@gmail.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
+F:	drivers/watchdog/bfin_wdt.c
 
 BLACKFIN I2C TWI DRIVER
 P:	Sonic Zhang
@@ -948,6 +1087,7 @@ M:	sonic.zhang@analog.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org/
 S:	Supported
+F:	drivers/i2c/busses/i2c-bfin-twi.c
 
 BLOCK LAYER
 P:	Jens Axboe
@@ -955,12 +1095,14 @@ M:	axboe@kernel.dk
 L:	linux-kernel@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
 S:	Maintained
+F:	block/
 
 BLOCK2MTD DRIVER
 P:	Joern Engel
 M:	joern@lazybastard.org
 L:	linux-mtd@lists.infradead.org
 S:	Maintained
+F:	drivers/mtd/devices/block2mtd.c
 
 BLUETOOTH DRIVERS
 P:	Marcel Holtmann
@@ -968,6 +1110,7 @@ M:	marcel@holtmann.org
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
 S:	Maintained
+F:	drivers/bluetooth/
 
 BLUETOOTH SUBSYSTEM
 P:	Marcel Holtmann
@@ -976,6 +1119,8 @@ L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/holtmann/bluetooth-2.6.git
 S:	Maintained
+F:	net/bluetooth/
+F:	include/net/bluetooth/
 
 BONDING DRIVER
 P:	Jay Vosburgh
@@ -983,42 +1128,52 @@ M:	fubar@us.ibm.com
 L:	bonding-devel@lists.sourceforge.net
 W:	http://sourceforge.net/projects/bonding/
 S:	Supported
+F:	drivers/net/bonding/
+F:	include/linux/if_bonding.h
 
 BROADCOM B44 10/100 ETHERNET DRIVER
 P:	Gary Zambrano
 M:	zambrano@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	drivers/net/b44.*
 
 BROADCOM BNX2 GIGABIT ETHERNET DRIVER
 P:	Michael Chan
 M:	mchan@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	drivers/net/bnx2.*
+F:	drivers/net/bnx2_*
 
 BROADCOM BNX2X 10 GIGABIT ETHERNET DRIVER
 P:	Eilon Greenstein
 M:	eilong@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	drivers/net/bnx2x*
 
 BROADCOM TG3 GIGABIT ETHERNET DRIVER
 P:	Michael Chan
 M:	mchan@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	drivers/net/tg3.*
 
 BSG (block layer generic sg v4 driver)
 P:	FUJITA Tomonori
 M:	fujita.tomonori@lab.ntt.co.jp
 L:	linux-scsi@vger.kernel.org
 S:	Supported
+F:	block/bsg.c
+F:	include/linux/bsg.h
 
 BT8XXGPIO DRIVER
 P:	Michael Buesch
 M:	mb@bu3sch.de
 W:	http://bu3sch.de/btgpio.php
 S:	Maintained
+F:	drivers/gpio/bt8xxgpio.c
 
 BTTV VIDEO4LINUX DRIVER
 P:	Mauro Carvalho Chehab
@@ -1028,12 +1183,16 @@ L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
+F:	Documentation/video4linux/bttv/
+F:	drivers/media/video/bt8xx/bttv*
 
 CAFE CMOS INTEGRATED CAMERA CONTROLLER DRIVER
 P:	Jonathan Corbet
 M:	corbet@lwn.net
 L:	video4linux-list@redhat.com
 S:	Maintained
+F:	Documentation/video4linux/cafe_ccic
+F:	drivers/media/video/cafe_ccic*
 
 CALGARY x86-64 IOMMU
 P:	Muli Ben-Yehuda
@@ -1043,6 +1202,10 @@ M:	jdmason@kudzu.us
 L:	linux-kernel@vger.kernel.org
 L:	discuss@x86-64.org
 S:	Maintained
+F:	arch/x86/kernel/pci-calgary_64.c
+F:	arch/x86/kernel/tce_64.c
+F:	arch/x86/include/asm/calgary.h
+F:	arch/x86/include/asm/tce.h
 
 CAN NETWORK LAYER
 P:	Urs Thuermann
@@ -1052,6 +1215,9 @@ M:	oliver.hartkopp@volkswagen.de
 L:	socketcan-core@lists.berlios.de (subscribers-only)
 W:	http://developer.berlios.de/projects/socketcan/
 S:	Maintained
+F:	drivers/net/can/
+F:	include/linux/can/
+F:	include/linux/can.h
 
 CELL BROADBAND ENGINE ARCHITECTURE
 P:	Arnd Bergmann
@@ -1066,6 +1232,10 @@ P:	David Vrabel
 M:	david.vrabel@csr.com
 L:	linux-usb@vger.kernel.org
 S:	Supported
+F:	Documentation/usb/WUSB-Design-overview.txt
+F:	Documentation/usb/wusb-cbaf
+F:	drivers/usb/wusbcore/
+F:	include/linux/usb/wusb*
 
 CFAG12864B LCD DRIVER
 P:	Miguel Ojeda Sandonis
@@ -1074,6 +1244,8 @@ L:	linux-kernel@vger.kernel.org
 W:	http://miguelojeda.es/auxdisplay.htm
 W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
+F:	drivers/auxdisplay/cfag12864b.c
+F:	include/linux/cfag12864b.h
 
 CFAG12864BFB LCD FRAMEBUFFER DRIVER
 P:	Miguel Ojeda Sandonis
@@ -1082,12 +1254,18 @@ L:	linux-kernel@vger.kernel.org
 W:	http://miguelojeda.es/auxdisplay.htm
 W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
+F:	drivers/auxdisplay/cfag12864bfb.c
+F:	include/linux/cfag12864b.h
 
 CFG80211 and NL80211
 P:	Johannes Berg
 M:	johannes@sipsolutions.net
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
+F:	include/linux/nl80211.h
+F:	include/net/cfg80211.h
+F:	net/wireless/*
+X:	net/wireless/wext*
 
 CHECKPATCH
 P:	Andy Whitcroft
@@ -1097,6 +1275,7 @@ M:	rdunlap@xenotime.net
 P:	Joel Schopp
 M:	jschopp@austin.ibm.com
 S:	Supported
+F:	scripts/checkpatch.pl
 
 CISCO 10G ETHERNET DRIVER
 P:	Scott Feldman
@@ -1104,24 +1283,29 @@ M:	scofeldm@cisco.com
 P:	Joe Eykholt
 M:	jeykholt@cisco.com
 S:	Supported
+F:	drivers/net/enic/
 
 CIRRUS LOGIC EP93XX ETHERNET DRIVER
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/arm/ep93xx_eth.c
 
 CIRRUS LOGIC EP93XX OHCI USB HOST DRIVER
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-usb@vger.kernel.org
 S:	Maintained
+F:	drivers/usb/host/ohci-ep93xx.c
 
 CIRRUS LOGIC CS4270 SOUND DRIVER
 P:	Timur Tabi
 M:	timur@freescale.com
 L:	alsa-devel@alsa-project.org
 S:	Supported
+F:	sound/soc/codecs/cs4270*
+F:	sound/soc/fsl/mpc8610_hpcd.c
 
 CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
 P:	Cirrus Logic Corporation (kernel 2.2 driver)
@@ -1129,6 +1313,8 @@ M:	Cirrus Logic Corporation, Thomas Woller <twoller@crystal.cirrus.com>
 P:	Nils Faerber (port to kernel 2.4)
 M:	Nils Faerber <nils@kernelconcepts.de>
 S:	Maintained
+F:	Documentation/input/cs461x.txt
+F:	sound/pci/cs46xx/
 
 CODA FILE SYSTEM
 P:	Jan Harkes
@@ -1137,6 +1323,8 @@ M:	coda@cs.cmu.edu
 L:	codalist@coda.cs.cmu.edu
 W:	http://www.coda.cs.cmu.edu/
 S:	Maintained
+F:	fs/coda/
+F:	include/linux/coda*.h
 
 COMMON INTERNET FILE SYSTEM (CIFS)
 P:	Steve French
@@ -1146,6 +1334,7 @@ L:	samba-technical@lists.samba.org
 W:	http://linux-cifs.samba.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
 S:	Supported
+F:	fs/cifs/
 
 COMPACTPCI HOTPLUG CORE
 P:	Scott Murray
@@ -1153,6 +1342,7 @@ M:	scottm@somanetworks.com
 M:	scott@spiteful.org
 L:	linux-pci@vger.kernel.org
 S:	Supported
+F:	drivers/pci/hotplug/cpci_hotplug*
 
 COMPACTPCI HOTPLUG ZIATECH ZT5550 DRIVER
 P:	Scott Murray
@@ -1160,6 +1350,7 @@ M:	scottm@somanetworks.com
 M:	scott@spiteful.org
 L:	linux-pci@vger.kernel.org
 S:	Supported
+F:	drivers/pci/hotplug/cpcihp_zt5550.*
 
 COMPACTPCI HOTPLUG GENERIC DRIVER
 P:	Scott Murray
@@ -1167,17 +1358,21 @@ M:	scottm@somanetworks.com
 M:	scott@spiteful.org
 L:	linux-pci@vger.kernel.org
 S:	Supported
+F:	drivers/pci/hotplug/cpcihp_generic.c
 
 COMPAL LAPTOP SUPPORT
 P:	Cezary Jackiewicz
 M:	cezary.jackiewicz@gmail.com
 S:	Maintained
+F:	drivers/misc/compal-laptop.c
 
 COMPUTONE INTELLIPORT MULTIPORT CARD
 P:	Michael H. Warfield
 M:	mhw@wittsend.com
 W:	http://www.wittsend.com/computone.html
 S:	Maintained
+F:	Documentation/serial/computone.txt
+F:	drivers/char/ip2/
 
 CONEXANT ACCESSRUNNER USB DRIVER
 P:	Simon Arlott
@@ -1185,30 +1380,38 @@ M:	cxacru@fire.lp0.eu
 L:	accessrunner-general@lists.sourceforge.net
 W:	http://accessrunner.sourceforge.net/
 S:	Maintained
+F:	drivers/usb/atm/cxacru.c
 
 CONFIGFS
 P:	Joel Becker
 M:	joel.becker@oracle.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	fs/configfs/
+F:	include/linux/configfs.h
 
 CONTROL GROUPS (CGROUPS)
 P:	Paul Menage
 M:	menage@google.com
 L:	containers@lists.linux-foundation.org
 S:	Maintained
+F:	include/linux/cgroup*
+F:	kernel/cgroup*
 
 CORETEMP HARDWARE MONITORING DRIVER
 P:	Rudolf Marek
 M:	r.marek@assembler.cz
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/coretemp
+F:	drivers/hwmon/coretemp.c
 
 COSA/SRP SYNC SERIAL DRIVER
 P:	Jan "Yenya" Kasprzak
 M:	kas@fi.muni.cz
 W:	http://www.fi.muni.cz/~kas/cosa/
 S:	Maintained
+F:	drivers/net/wan/cosa*
 
 CPU FREQUENCY DRIVERS
 P:	Dave Jones
@@ -1217,11 +1420,16 @@ L:	cpufreq@vger.kernel.org
 W:	http://www.codemonkey.org.uk/projects/cpufreq/
 T:	git kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git
 S:	Maintained
+F:	arch/x86/kernel/cpu/cpufreq/
+F:	drivers/cpufreq/
+F:	include/linux/cpufreq.h
 
 CPUID/MSR DRIVER
 P:	H. Peter Anvin
 M:	hpa@zytor.com
 S:	Maintained
+F:	arch/x86/kernel/cpuid.c
+F:	arch/x86/kernel/msr.c
 
 CPUSETS
 P:	Paul Menage
@@ -1230,10 +1438,15 @@ L:	linux-kernel@vger.kernel.org
 W:	http://www.bullopensource.org/cpuset/
 W:	http://oss.sgi.com/projects/cpusets/
 S:	Supported
+F:	Documentation/cpusets.txt
+F:	include/linux/cpuset.h
+F:	kernel/cpuset.c
 
 CRAMFS FILESYSTEM
 W:	http://sourceforge.net/projects/cramfs/
 S:	Orphan
+F:	Documentation/filesystems/cramfs.txt
+F:	fs/cramfs/
 
 CRIS PORT
 P:	Mikael Starvik
@@ -1243,6 +1456,7 @@ M:	jesper.nilsson@axis.com
 L:	dev-etrax@axis.com
 W:	http://developer.axis.com
 S:	Maintained
+F:	arch/cris/
 
 CRYPTO API
 P:	Herbert Xu
@@ -1252,11 +1466,13 @@ M:	davem@davemloft.net
 L:	linux-crypto@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
 S:	Maintained
+F:	crypto/
 
 CS5535 Audio ALSA driver
 P:	Jaya Kumar
 M:	jayakumar.alsa@gmail.com
 S:	Maintained
+F:	sound/pci/cs5535audio/
 
 CX18 VIDEO4LINUX DRIVER
 P:	Hans Verkuil, Andy Walls
@@ -1266,6 +1482,8 @@ L:	ivtv-users@ivtvdriver.org
 L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
 S:	Maintained
+F:	Documentation/video4linux/cx18.txt
+F:	drivers/media/video/cx18/
 
 CXGB3 ETHERNET DRIVER (CXGB3)
 P:	Divy Le Ray
@@ -1273,6 +1491,7 @@ M:	divy@chelsio.com
 L:	netdev@vger.kernel.org
 W:	http://www.chelsio.com
 S:	Supported
+F:	drivers/net/cxgb3/
 
 CXGB3 IWARP RNIC DRIVER (IW_CXGB3)
 P:	Steve Wise
@@ -1280,24 +1499,28 @@ M:	swise@chelsio.com
 L:	general@lists.openfabrics.org
 W:	http://www.openfabrics.org
 S:	Supported
+F:	drivers/infiniband/hw/cxgb3/
 
 CYBERPRO FB DRIVER
 P:	Russell King
 M:	rmk@arm.linux.org.uk
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
+F:	drivers/video/cyber2000fb.*
 
 CYBLAFB FRAMEBUFFER DRIVER
 P:	Knut Petersen
 M:	Knut_Petersen@t-online.de
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
+F:	drivers/video/cyblafb.c
 
 CYCLADES 2X SYNC CARD DRIVER
 P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
 W:	http://oops.ghostprotocols.net:81/blog
 S:	Maintained
+F:	drivers/net/wan/cycx*
 
 CYCLADES ASYNC MUX DRIVER
 W:	http://www.cyclades.com/
@@ -1306,6 +1529,7 @@ S:	Orphan
 CYCLADES PC300 DRIVER
 W:	http://www.cyclades.com/
 S:	Orphan
+F:	drivers/net/wan/pc300*
 
 DAMA SLAVE for AX.25
 P:	Joerg Reuter
@@ -1314,12 +1538,21 @@ W:	http://yaina.de/jreuter/
 W:	http://www.qsl.net/dl1bke/
 L:	linux-hams@vger.kernel.org
 S:	Maintained
+F:	net/ax25/af_ax25.c
+F:	net/ax25/ax25_dev.c
+F:	net/ax25/ax25_ds_*
+F:	net/ax25/ax25_in.c
+F:	net/ax25/ax25_out.c
+F:	net/ax25/ax25_timer.c
+F:	net/ax25/sysctl_net_ax25.c
 
 DAVICOM FAST ETHERNET (DMFE) NETWORK DRIVER
 P:	Tobias Ringstrom
 M:	tori@unhappy.mine.nu
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	Documentation/networking/dmfe.txt
+F:	drivers/net/tulip/dmfe.c
 
 DC390/AM53C974 SCSI driver
 P:	Kurt Garloff
@@ -1328,6 +1561,7 @@ W:	http://www.garloff.de/kurt/linux/dc390/
 P:	Guennadi Liakhovetski
 M:	g.liakhovetski@gmx.de
 S:	Maintained
+F:	drivers/scsi/tmscsim.*
 
 DC395x SCSI driver
 P:	Oliver Neukum
@@ -1340,6 +1574,8 @@ W:	http://twibble.org/dist/dc395x/
 L:	dc395x@twibble.org
 L:	http://lists.twibble.org/mailman/listinfo/dc395x/
 S:	Maintained
+F:	Documentation/scsi/dc395x.txt
+F:	drivers/scsi/dc395x.*
 
 DCCP PROTOCOL
 P:	Arnaldo Carvalho de Melo
@@ -1347,6 +1583,9 @@ M:	acme@ghostprotocols.net
 L:	dccp@vger.kernel.org
 W:	http://linux-net.osdl.org/index.php/DCCP
 S:	Maintained
+F:	include/linux/dccp.h
+F:	include/linux/tfrc.h
+F:	net/dccp/
 
 DECnet NETWORK LAYER
 P:	Christine Caulfield
@@ -1354,22 +1593,29 @@ M:	christine.caulfield@googlemail.com
 W:	http://linux-decnet.sourceforge.net
 L:	linux-decnet-user@lists.sourceforge.net
 S:	Maintained
+F:	Documentation/networking/decnet.txt
+F:	net/decnet/
 
 DEFXX FDDI NETWORK DRIVER
 P:	Maciej W. Rozycki
 M:	macro@linux-mips.org
 S:	Maintained
+F:	drivers/net/defxx.*
 
 DELL LAPTOP SMM DRIVER
 P:	Massimo Dal Zotto
 M:	dz@debian.org
 W:	http://www.debian.org/~dz/i8k/
 S:	Maintained
+F:	drivers/char/i8k.c
+F:	include/linux/i8k.h
 
 DELL SYSTEMS MANAGEMENT BASE DRIVER (dcdbas)
 P:	Doug Warzecha
 M:	Douglas_Warzecha@dell.com
 S:	Maintained
+F:	Documentation/dcdbas.txt
+F:	drivers/firmware/dcdbas.*
 
 DEVICE NUMBER REGISTRY
 P:	Torben Mathiasen
@@ -1383,6 +1629,10 @@ P:	Alasdair Kergon
 L:	dm-devel@redhat.com
 W:	http://sources.redhat.com/dm
 S:	Maintained
+F:	Documentation/device-mapper/
+F:	drivers/md/dm*
+F:	include/linux/device-mapper.h
+F:	include/linux/dm-*.h
 
 DIGI INTL. EPCA DRIVER
 P:	Digi International, Inc
@@ -1390,12 +1640,17 @@ M:	Eng.Linux@digi.com
 L:	Eng.Linux@digi.com
 W:	http://www.digi.com
 S:	Orphan
+F:	Documentation/serial/digiepca.txt
+F:	drivers/char/epca*
+F:	drivers/char/digi*
 
 DIRECTORY NOTIFICATION (DNOTIFY)
 P:	Stephen Rothwell
 M:	sfr@canb.auug.org.au
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	fs/dnotify.c
+F:	include/linux/dnotify.h
 
 DISK GEOMETRY AND PARTITION HANDLING
 P:	Andries Brouwer
@@ -1410,6 +1665,9 @@ P:	Jan Kara
 M:	jack@suse.cz
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/filesystems/quota.txt
+F:	fs/quota*
+F:	include/linux/quota*.h
 
 DISTRIBUTED LOCK MANAGER (DLM)
 P:	Christine Caulfield
@@ -1420,6 +1678,7 @@ L:	cluster-devel@redhat.com
 W:	http://sources.redhat.com/cluster/
 T:	git kernel.org:/pub/scm/linux/kernel/git/teigland/dlm.git
 S:	Supported
+F:	fs/dlm/
 
 DMA GENERIC OFFLOAD ENGINE SUBSYSTEM
 P:	Maciej Sosnowski
@@ -1428,12 +1687,16 @@ P:	Dan Williams
 M:	dan.j.williams@intel.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	drivers/dma/
+F:	include/linux/dma*
 
 DME1737 HARDWARE MONITOR DRIVER
 P:	Juerg Haefliger
 M:	juergh@gmail.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/dme1737
+F:	drivers/hwmon/dme1737.c
 
 DOCBOOK FOR DOCUMENTATION
 P:	Randy Dunlap
@@ -1445,6 +1708,7 @@ P:	Shaohua Li
 M:	shaohua.li@intel.com
 L:	linux-acpi@vger.kernel.org
 S:	Supported
+F:	drivers/acpi/dock.c
 
 DOCUMENTATION (/Documentation directory)
 P:	Michael Kerrisk
@@ -1459,6 +1723,8 @@ P:	James R. Van Zandt
 M:	jrv@vanzandt.mv.com
 L:	blinux-list@redhat.com
 S:	Maintained
+F:	drivers/char/dtlk.c
+F:	include/linux/dtlk.h
 
 DPT_I2O SCSI RAID DRIVER
 P:	Adaptec OEM Raid Solutions
@@ -1466,6 +1732,8 @@ M:	aacraid@adaptec.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.adaptec.com/
 S:	Maintained
+F:	drivers/scsi/dpt*
+F:	drivers/scsi/dpt/
 
 DRIVER CORE, KOBJECTS, AND SYSFS
 P:	Greg Kroah-Hartman
@@ -1473,6 +1741,11 @@ M:	gregkh@suse.de
 L:	linux-kernel@vger.kernel.org
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 S:	Supported
+F:	Documentation/kobject.txt
+F:	drivers/base/core.c
+F:	fs/sysfs/
+F:	include/linux/kobj*
+F:	lib/kobj*
 
 DRM DRIVERS
 P:	David Airlie
@@ -1480,12 +1753,14 @@ M:	airlied@linux.ie
 L:	dri-devel@lists.sourceforge.net
 T:	git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
+F:	drivers/gpu/drm/
 
 DSCC4 DRIVER
 P:	Francois Romieu
 M:	romieu@fr.zoreil.com
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/wan/dscc4.c
 
 DVB SUBSYSTEM AND DRIVERS
 P:	LinuxTV.org Project
@@ -1494,16 +1769,22 @@ L:	linux-dvb@linuxtv.org (subscription required)
 W:	http://linuxtv.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
+F:	Documentation/dvb/
+F:	drivers/media/dvb/
+F:	drivers/media/common/saa7146*.c
+F:	include/linux/dvb/
 
 DZ DECSTATION DZ11 SERIAL DRIVER
 P:	Maciej W. Rozycki
 M:	macro@linux-mips.org
 S:	Maintained
+F:	drivers/serial/dz.*
 
 EATA-DMA SCSI DRIVER
 P:	Michael Neuffer
 L:	linux-eata@i-connect.net, linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/eata*
 
 EATA ISA/EISA/PCI SCSI DRIVER
 P:	Dario Ballabio
@@ -1516,6 +1797,7 @@ P:	Michael Neuffer
 M:	mike@i-Connect.Net
 L:	linux-eata@i-connect.net, linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/eata_pio.*
 
 EBTABLES
 P:	Bart De Schuymer
@@ -1524,6 +1806,8 @@ L:	ebtables-user@lists.sourceforge.net
 L:	ebtables-devel@lists.sourceforge.net
 W:	http://ebtables.sourceforge.net/
 S:	Maintained
+F:	include/linux/netfilter_bridge/ebt_*.h
+F:	net/bridge/netfilter/ebt*.c
 
 ECRYPT FILE SYSTEM
 P:	Mike Halcrow, Phillip Hellewell
@@ -1531,6 +1815,7 @@ M:	mhalcrow@us.ibm.com, phillip@hellewell.homeip.net
 L:	ecryptfs-devel@lists.sourceforge.net
 W:	http://ecryptfs.sourceforge.net/
 S:	Supported
+F:	fs/ecryptfs/
 
 EDAC-CORE
 P:	Doug Thompson
@@ -1538,6 +1823,9 @@ M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Supported
+F:	Documentation/edac.txt
+F:	drivers/edac/edac_*
+F:	include/linux/edac.h
 
 EDAC-E752X
 P:	Mark Gross
@@ -1547,6 +1835,7 @@ M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/e752x_edac.c
 
 EDAC-E7XXX
 P:	Doug Thompson
@@ -1554,6 +1843,7 @@ M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/e7xxx_edac.c
 
 EDAC-I82443BXGX
 P:	Tim Small
@@ -1561,6 +1851,7 @@ M:	tim@buttersideup.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/i82443bxgx_edac.c
 
 EDAC-I3000
 P:	Jason Uhlenkott
@@ -1568,6 +1859,7 @@ M:	juhlenko@akamai.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/i3000_edac.c
 
 EDAC-I5000
 P:	Doug Thompson
@@ -1575,6 +1867,7 @@ M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/i5000_edac.c
 
 EDAC-I82975X
 P:	Ranganathan Desikan
@@ -1584,6 +1877,7 @@ M:	arvind@acarlab.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/i82975x_edac.c
 
 EDAC-PASEMI
 P:	Egor Martovetsky
@@ -1591,6 +1885,7 @@ M:	egor@pasemi.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/pasemi_edac.c
 
 EDAC-R82600
 P:	Tim Small
@@ -1598,6 +1893,7 @@ M:	tim@buttersideup.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/r82600_edac.c
 
 EEEPC LAPTOP EXTRAS DRIVER
 P:	Corentin Chary
@@ -1605,15 +1901,18 @@ M:	corentincj@iksaif.net
 L:	acpi4asus-user@lists.sourceforge.net
 W:	http://sourceforge.net/projects/acpi4asus
 S:	Maintained
+F:	drivers/misc/eeepc-laptop.c
 
 EEPRO100 NETWORK DRIVER
 P:	Andrey V. Savochkin
 M:	saw@saw.sw.com.sg
 S:	Maintained
+F:	drivers/net/eepro100.c
 
 EFS FILESYSTEM
 W:	http://aeschi.ch.eu.org/efs/
 S:	Orphan
+F:	fs/efs/
 
 EHCA (IBM GX bus InfiniBand adapter) DRIVER
 P:	Hoang-Nam Nguyen
@@ -1622,6 +1921,7 @@ P:	Christoph Raisch
 M:	raisch@de.ibm.com
 L:	general@lists.openfabrics.org
 S:	Supported
+F:	drivers/infiniband/hw/ehca/
 
 EMBEDDED LINUX
 P:	Paul Gortmaker
@@ -1637,22 +1937,27 @@ M:	james.smart@emulex.com
 L:	linux-scsi@vger.kernel.org
 W:	http://sourceforge.net/projects/lpfcxxxx
 S:	Supported
+F:	drivers/scsi/lpfc/
 
 EPSON 1355 FRAMEBUFFER DRIVER
 P:	Christopher Hoover
 M:	ch@murgatroid.com, ch@hpl.hp.com
 S:	Maintained
+F:	drivers/video/epson1355fb.c
 
 EPSON S1D13XXX FRAMEBUFFER DRIVER
 P:	Kristoffer Ericson
 M:	kristoffer.ericson@gmail.com
 S:	Maintained
+F:	drivers/video/s1d13xxxfb.c
+F:	include/video/s1d13xxxfb.h
 
 ETHEREXPRESS-16 NETWORK DRIVER
 P:	Philip Blundell
 M:	philb@gnu.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/eexpress.*
 
 ETHERNET BRIDGE
 P:	Stephen Hemminger
@@ -1660,21 +1965,28 @@ M:	shemminger@linux-foundation.org
 L:	bridge@lists.linux-foundation.org
 W:	http://www.linux-foundation.org/en/Net:Bridge
 S:	Maintained
+F:	include/linux/netfilter_bridge/
+F:	net/bridge/
 
 ETHERTEAM 16I DRIVER
 P:	Mika Kuoppala
 M:	miku@iki.fi
 S:	Maintained
+F:	drivers/net/eth16i.c
 
 EXT2 FILE SYSTEM
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
+F:	fs/ext2/
+F:	include/linux/ext2*
 
 EXT3 FILE SYSTEM
 P:	Stephen Tweedie, Andrew Morton
 M:	sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
+F:	fs/ext3/
+F:	include/linux/ext3*
 
 EXT4 FILE SYSTEM
 P:	Theodore Ts'o
@@ -1682,35 +1994,46 @@ M:	tytso@mit.edu, adilger@sun.com
 L:	linux-ext4@vger.kernel.org
 W:	http://ext4.wiki.kernel.org
 S:	Maintained
+F:	fs/ext4/
 
 F71805F HARDWARE MONITORING DRIVER
 P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/f71805f
+F:	drivers/hwmon/f71805f.c
 
 FARSYNC SYNCHRONOUS DRIVER
 P:	Kevin Curtis
 M:	kevin.curtis@farsite.co.uk
 W:	http://www.farsite.co.uk/
 S:	Supported
+F:	drivers/net/wan/farsync.*
 
 FAULT INJECTION SUPPORT
 P:	Akinobu Mita
 M:	akinobu.mita@gmail.com
 S:	Supported
+F:	Documentation/fault-injection/
+F:	lib/fault-inject.c
 
 FILE LOCKING (flock() and fcntl()/lockf())
 P:	Matthew Wilcox
 M:	matthew@wil.cx
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
+F:	include/linux/fcntl.h
+F:	include/linux/fs.h
+F:	fs/fcntl.c
+F:	fs/locks.c
 
 FILESYSTEMS (VFS and infrastructure)
 P:	Alexander Viro
 M:	viro@zeniv.linux.org.uk
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
+F:	fs/*
 
 FIREWIRE SUBSYSTEM (drivers/firewire, <linux/firewire*.h>)
 P:	Kristian Hoegsberg, Stefan Richter
@@ -1719,22 +2042,30 @@ L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
+F:	drivers/firewire/
+F:	include/linux/firewire*.h
 
 FIRMWARE LOADER (request_firmware)
 L:	linux-kernel@vger.kernel.org
 S:	Orphan
+F:	Documentation/firmware_class/
+F:	drivers/base/firmware*.c
+F:	include/linux/firmware.h
 
 FPU EMULATOR
 P:	Bill Metzenthen
 M:	billm@suburbia.net
 W:	http://suburbia.net/~billm/floating-point/emulator/
 S:	Maintained
+F:	arch/x86/math-emu/
 
 FRAME RELAY DLCI/FRAD (Sangoma drivers too)
 P:	Mike McLagan
 M:	mike.mclagan@linux.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/wan/dlci.c
+F:	drivers/net/wan/sdla.c
 
 FRAMEBUFFER LAYER
 P:	Antonino Daplas
@@ -1742,6 +2073,9 @@ M:	adaplas@gmail.com
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://linux-fbdev.sourceforge.net/
 S:	Maintained
+F:	Documentation/fb/
+F:	drivers/video/fb*
+F:	include/linux/fb.h
 
 FREESCALE DMA DRIVER
 P:	Li Yang
@@ -1751,6 +2085,7 @@ M:	zw@zh-kernel.org
 L:	linuxppc-embedded@ozlabs.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/dma/fsldma.*
 
 FREESCALE I2C CPM DRIVER
 P:	Jochen Friedrich
@@ -1758,6 +2093,7 @@ M:	jochen@scram.de
 L:	linuxppc-dev@ozlabs.org
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
+F:	drivers/i2c/busses/i2c-cpm.c
 
 FREESCALE SOC FS_ENET DRIVER
 P:	Pantelis Antoniou
@@ -1767,12 +2103,16 @@ M:	vbordug@ru.mvista.com
 L:	linuxppc-dev@ozlabs.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/fs_enet/
+F:	include/linux/fs_enet_pd.h
 
 FREESCALE QUICC ENGINE LIBRARY
 P:	Timur Tabi
 M:	timur@freescale.com
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
+F:	arch/powerpc/sysdev/qe_lib/
+F:	arch/powerpc/include/asm/*qe.h
 
 FREESCALE HIGHSPEED USB DEVICE DRIVER
 P:	Li Yang
@@ -1780,6 +2120,7 @@ M:	leoli@freescale.com
 L:	linux-usb@vger.kernel.org
 L:	linuxppc-dev@ozlabs.org
 S:	Maintained
+F:	drivers/usb/gadget/fsl_usb2_udc.c
 
 FREESCALE QUICC ENGINE UCC ETHERNET DRIVER
 P:	Li Yang
@@ -1787,12 +2128,14 @@ M:	leoli@freescale.com
 L:	netdev@vger.kernel.org
 L:	linuxppc-dev@ozlabs.org
 S:	Maintained
+F:	drivers/net/ucc_geth*
 
 FREESCALE QUICC ENGINE UCC UART DRIVER
 P:	Timur Tabi
 M:	timur@freescale.com
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
+F:	drivers/serial/ucc_uart.c
 
 FREESCALE SOC SOUND DRIVERS
 P:	Timur Tabi
@@ -1800,28 +2143,38 @@ M:	timur@freescale.com
 L:	alsa-devel@alsa-project.org
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
+F:	sound/soc/fsl/
 
 FREEVXFS FILESYSTEM
 P:	Christoph Hellwig
 M:	hch@infradead.org
 W:	ftp://ftp.openlinux.org/pub/people/hch/vxfs
 S:	Maintained
+F:	fs/freevxfs/
 
 FTRACE
 P:	Steven Rostedt
 M:	srostedt@redhat.com
 S:	Maintained
+F:	Documentation/ftrace.txt
+F:	arch/*/*/*/ftrace.h
+F:	arch/*/kernel/ftrace.c
+F:	include/*/ftrace.h
+F:	kernel/trace/
 
 FUJITSU FR-V (FRV) PORT
 P:	David Howells
 M:	dhowells@redhat.com
 S:	Maintained
+F:	arch/frv/
+F:	include/asm-frv/
 
 FUJITSU LAPTOP EXTRAS
 P:	Jonathan Woithe
 M:	jwoithe@physics.adelaide.edu.au
 L:	linux-acpi@vger.kernel.org
 S:	Maintained
+F:	drivers/misc/fujitsu-laptop.c
 
 FUSE: FILESYSTEM IN USERSPACE
 P:	Miklos Szeredi
@@ -1829,12 +2182,15 @@ M:	miklos@szeredi.hu
 L:	fuse-devel@lists.sourceforge.net
 W:	http://fuse.sourceforge.net/
 S:	Maintained
+F:	fs/fuse/
+F:	include/linux/fuse.h
 
 FUTURE DOMAIN TMC-16x0 SCSI DRIVER (16-bit)
 P:	Rik Faith
 M:	faith@cs.unc.edu
 L:	linux-scsi@vger.kernel.org
 S:	Odd Fixes (e.g., new signatures)
+F:	drivers/scsi/fdomain.*
 
 GDT SCSI DISK ARRAY CONTROLLER DRIVER
 P:	Achim Leubner
@@ -1842,17 +2198,27 @@ M:	achim_leubner@adaptec.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.icp-vortex.com/
 S:	Supported
+F:	drivers/scsi/gdt*
 
 GENERIC GPIO I2C DRIVER
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
 S:	Supported
+F:	drivers/i2c/busses/i2c-gpio.c
+F:	include/linux/i2c-gpio.h
 
 GENERIC HDLC DRIVER, N2, C101, PCI200SYN and WANXL DRIVERS
 P:	Krzysztof Halasa
 M:	khc@pm.waw.pl
 W:	http://www.kernel.org/pub/linux/utils/net/hdlc/
 S:	Maintained
+F:	drivers/net/wan/c101.c
+F:	drivers/net/wan/hd6457x.c
+F:	drivers/net/wan/hdlc*
+F:	drivers/net/wan/n2.c
+F:	drivers/net/wan/pc300too.c
+F:	drivers/net/wan/pci200syn.c
+F:	drivers/net/wan/wanxl*
 
 GFS2 FILE SYSTEM
 P:	Steven Whitehouse
@@ -1862,6 +2228,10 @@ W:	http://sources.redhat.com/cluster/
 T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git
 T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git
 S:	Supported
+F:	Documentation/filesystems/gfs2.txt
+F:	fs/gfs2/
+F:	include/linux/gfs2_ondisk.h
+F:	include/linux/lm_interface.h
 
 GIGASET ISDN DRIVERS
 P:	Hansjoerg Lipp
@@ -1871,6 +2241,9 @@ M:	tilman@imap.cc
 L:	gigaset307x-common@lists.sourceforge.net
 W:	http://gigaset307x.sourceforge.net/
 S:	Maintained
+F:	Documentation/isdn/README.gigaset
+F:	drivers/isdn/gigaset/
+F:	include/linux/gigaset_dev.h
 
 HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
 P:	Robert Love
@@ -1878,30 +2251,35 @@ M:	rlove@rlove.org
 M:	linux-kernel@vger.kernel.org
 W:	http://www.kernel.org/pub/linux/kernel/people/rml/hdaps/
 S:	Maintained
+F:	drivers/hwmon/hdaps.c
 
 GSPCA FINEPIX SUBDRIVER
 P:	Frank Zago
 M:	frank@zago.net
 L:	video4linux-list@redhat.com
 S:	Maintained
+F:	drivers/media/video/gspca/finepix.c
 
 GSPCA M5602 SUBDRIVER
 P:	Erik Andren
 M:	erik.andren@gmail.com
 L:	video4linux-list@redhat.com
 S:	Maintained
+F:	drivers/media/video/gspca/m5602/
 
 GSPCA PAC207 SONIXB SUBDRIVER
 P:	Hans de Goede
 M:	hdegoede@redhat.com
 L:	video4linux-list@redhat.com
 S:	Maintained
+F:	drivers/media/video/gspca/pac207.c
 
 GSPCA T613 SUBDRIVER
 P:	Leandro Costantino
 M:	lcostantino@gmail.com
 L:	video4linux-list@redhat.com
 S:	Maintained
+F:	drivers/media/video/gspca/t613.c
 
 GSPCA USB WEBCAM DRIVER
 P:	Jean-Francois Moine
@@ -1909,20 +2287,26 @@ M:	moinejf@free.fr
 W:	http://moinejf.free.fr
 L:	video4linux-list@redhat.com
 S:	Maintained
+F:	drivers/media/video/gspca/
 
 HARDWARE MONITORING
 L:	lm-sensors@lm-sensors.org
 W:	http://www.lm-sensors.org/
 S:	Orphan
+F:	drivers/hwmon/
 
 HARDWARE RANDOM NUMBER GENERATOR CORE
 S:	Orphan
+F:	Documentation/hw_random.txt
+F:	drivers/char/hw_random/
+F:	include/linux/hw_random.h
 
 HARMONY SOUND DRIVER
 P:	Kyle McMartin
 M:	kyle@mcmartin.ca
 L:	linux-parisc@vger.kernel.org
 S:	Maintained
+F:	sound/parisc/harmony.*
 
 HAYES ESP SERIAL DRIVER
 P:	Andrew J. Robinson
@@ -1930,6 +2314,8 @@ M:	arobinso@nyx.net
 L:	linux-kernel@vger.kernel.org
 W:	http://www.nyx.net/~arobinso
 S:	Maintained
+F:	Documentation/serial/hayes-esp.txt
+F:	drivers/char/esp.c
 
 HEWLETT-PACKARD FIBRE CHANNEL 64-bit/66MHz PCI non-intelligent HBA
 P:	Chirag Kantharia
@@ -1942,18 +2328,25 @@ P:	Chirag Kantharia
 M:	chirag.kantharia@hp.com
 L:	iss_storagedev@hp.com
 S:	Maintained
+F:	Documentation/blockdev/cpqarray.txt
+F:	drivers/block/cpqarray.*
 
 HEWLETT-PACKARD SMART CISS RAID DRIVER (cciss)
 P:	Mike Miller
 M:	mike.miller@hp.com
 L:	iss_storagedev@hp.com
 S:	Supported
+F:	Documentation/blockdev/cciss.txt
+F:	drivers/block/cciss*
+F:	include/linux/cciss_ioctl.h
 
 HFS FILESYSTEM
 P:	Roman Zippel
 M:	zippel@linux-m68k.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/filesystems/hfs.txt
+F:	fs/hfs/
 
 HGA FRAMEBUFFER DRIVER
 P:	Ferenc Bakonyi
@@ -1961,6 +2354,7 @@ M:	fero@drama.obuda.kando.hu
 L:	linux-nvidia@lists.surfsouth.com
 W:	http://drama.obuda.kando.hu/~fero/cgi-bin/hgafb.shtml
 S:	Maintained
+F:	drivers/video/hgafb.c
 
 HIBERNATION (aka Software Suspend, aka swsusp)
 P:	Pavel Machek
@@ -1969,6 +2363,14 @@ P:	Rafael J. Wysocki
 M:	rjw@sisk.pl
 L:	linux-pm@lists.linux-foundation.org
 S:	Supported
+F:	arch/x86/power/
+F:	drivers/base/power/
+F:	kernel/power/
+F:	include/linux/suspend.h
+F:	include/linux/freezer.h
+F:	include/linux/pm.h
+F:	include/asm-*/suspend*.h
+F:	arch/*/include/asm/suspend*.h
 
 HID CORE LAYER
 P:	Jiri Kosina
@@ -1976,12 +2378,17 @@ M:	jkosina@suse.cz
 L:	linux-input@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
+F:	drivers/hid/
+F:	include/linux/hid*
 
 HIGH-RESOLUTION TIMERS, CLOCKEVENTS, DYNTICKS
 P:	Thomas Gleixner
 M:	tglx@linutronix.de
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/timers/
+F:	kernel/hrtimer.c
+F:	include/linux/hrtimer.h
 
 HIGH-SPEED SCC DRIVER FOR AX.25
 P:	Klaus Kudielka
@@ -1989,18 +2396,25 @@ M:	klaus.kudielka@ieee.org
 L:	linux-hams@vger.kernel.org
 W:	http://www.nt.tuwien.ac.at/~kkudielk/Linux/
 S:	Maintained
+F:	drivers/net/hamradio/dmascc.c
+F:	drivers/net/hamradio/scc.c
 
 HIGHPOINT ROCKETRAID 3xxx RAID DRIVER
 P:	HighPoint Linux Team
 M:	linux@highpoint-tech.com
 W:	http://www.highpoint-tech.com
 S:	Supported
+F:	Documentation/scsi/hptiop.txt
+F:	drivers/scsi/hptiop.c
 
 HIPPI
 P:	Jes Sorensen
 M:	jes@trained-monkey.org
 L:	linux-hippi@sunsite.dk
 S:	Maintained
+F:	include/linux/hippidevice.h
+F:	include/linux/if_hippi.h
+F:	net/802/hippi.c
 
 HOST AP DRIVER
 P:	Jouni Malinen
@@ -2009,26 +2423,34 @@ L:	hostap@shmoo.com (subscribers-only)
 L:	linux-wireless@vger.kernel.org
 W:	http://hostap.epitest.fi/
 S:	Maintained
+F:	drivers/net/wireless/hostap/
 
 HP COMPAQ TC1100 TABLET WMI EXTRAS DRIVER
 P:	Carlos Corbacho
 M:	carlos@strangeworlds.co.uk
 S:	Odd Fixes
+F:	drivers/misc/tc1100-wmi.c
 
 HP100:	Driver for HP 10/100 Mbit/s Voice Grade Network Adapter Series
 P:	Jaroslav Kysela
 M:	perex@perex.cz
 S:	Maintained
+F:	drivers/net/hp100.*
 
 HPET:	High Precision Event Timers driver (drivers/char/hpet.c)
 P:	Clemens Ladisch
 M:	clemens@ladisch.de
 S:	Maintained
+F:	Documentation/timers/hpet.txt
+F:	drivers/char/hpet.c
+F:	include/linux/hpet.h
 
 HPET:	i386
 P:	Venkatesh Pallipadi (Venki)
 M:	venkatesh.pallipadi@intel.com
 S:	Maintained
+F:	arch/x86/kernel/hpet.c
+F:	arch/x86/include/asm/hpet.h
 
 HPET:	x86_64
 P:	Vojtech Pavlik
@@ -2039,23 +2461,27 @@ HPET:	ACPI hpet.c
 P:	Bob Picco
 M:	bob.picco@hp.com
 S:	Maintained
+F:	drivers/char/hpet.c
 
 HPFS FILESYSTEM
 P:	Mikulas Patocka
 M:	mikulas@artax.karlin.mff.cuni.cz
 W:	http://artax.karlin.mff.cuni.cz/~mikulas/vyplody/hpfs/index-e.cgi
 S:	Maintained
+F:	fs/hpfs/
 
 HTCPEN TOUCHSCREEN DRIVER
 P:	Pau Oliva Fora
 M:	pof@eslack.org
 L:	linux-input@vger.kernel.org
 S:	Maintained
+F:	drivers/input/touchscreen/htcpen.c
 
 HUGETLB FILESYSTEM
 P:	William Irwin
 M:	wli@holomorphy.com
 S:	Maintained
+F:	fs/hugetlbfs/
 
 I2C/SMBUS STUB DRIVER
 P:	Mark M. Hoffman
@@ -2071,6 +2497,11 @@ M:	ben-linux@fluff.org
 L:	linux-i2c@vger.kernel.org
 T:	quilt http://khali.linux-fr.org/devel/linux-2.6/jdelvare-i2c/
 S:	Maintained
+F:	Documentation/i2c/
+F:	drivers/i2c/
+F:	include/linux/i2c.h
+F:	include/linux/i2c-dev.h
+F:	include/linux/i2c-id.h
 
 I2C-TINY-USB DRIVER
 P:	Till Harbaum
@@ -2078,6 +2509,7 @@ M:	till@harbaum.org
 L:	linux-i2c@vger.kernel.org
 T:	http://www.harbaum.org/till/i2c_tiny_usb
 S:	Maintained
+F:	drivers/i2c/busses/i2c-tiny-usb.c
 
 i386 BOOT CODE
 P:	H. Peter Anvin
@@ -2104,11 +2536,13 @@ P:	Michael Lang
 M:	langa2@kph.uni-mainz.de
 W:	http://www.uni-mainz.de/~langm000/linux.html
 S:	Maintained
+F:	drivers/scsi/ibmmca.c
 
 IBM Power Linux RAID adapter
 P:	Brian King
 M:	brking@us.ibm.com
 S:	Supported
+F:	drivers/scsi/ipr.*
 
 IBM ServeRAID RAID DRIVER
 P:	Jack Hammer
@@ -2116,6 +2550,7 @@ P:	Dave Jeffery
 M:	ipslinux@adaptec.com
 W:	http://www.developer.ibm.com/welcome/netfinity/serveraid.html
 S:	Supported
+F:	drivers/scsi/ips.*
 
 IDE SUBSYSTEM
 P:	Bartlomiej Zolnierkiewicz
@@ -2123,12 +2558,17 @@ M:	bzolnier@gmail.com
 L:	linux-ide@vger.kernel.org
 T:	quilt kernel.org/pub/linux/kernel/people/bart/pata-2.6/
 S:	Maintained
+F:	Documentation/ide/
+F:	drivers/ide/
+F:	include/linux/ide.h
 
 IDE/ATAPI CDROM DRIVER
 P:	Borislav Petkov
 M:	petkovbb@gmail.com
 L:	linux-ide@vger.kernel.org
 S:	Maintained
+F:	Documentation/cdrom/ide-cd
+F:	drivers/ide/ide-cd*
 
 IDE/ATAPI FLOPPY DRIVERS
 P:	Paul Bristow
@@ -2136,12 +2576,14 @@ M:	Paul Bristow <paul@paulbristow.net>
 W:	http://paulbristow.net/linux/idefloppy.html
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/ide/ide-floppy*
 
 IDE/ATAPI TAPE DRIVERS
 P:	Gadi Oxman
 M:	Gadi Oxman <gadio@netvision.net.il>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/ide/ide-tape.c
 
 IDE-SCSI DRIVER
 L:	linux-ide@vger.kernel.org
@@ -2153,6 +2595,7 @@ P:	Andy Henroid
 M:	andrew.d.henroid@intel.com
 L:	linux-pm@lists.linux-foundation.org
 S:	Supported
+F:	drivers/idle/i7300_idle.c
 
 IEEE 1394 SUBSYSTEM (drivers/ieee1394)
 P:	Ben Collins
@@ -2163,6 +2606,7 @@ L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
+F:	drivers/ieee1394/
 
 IEEE 1394 RAW I/O DRIVER (raw1394)
 P:	Dan Dennedy
@@ -2171,10 +2615,12 @@ P:	Stefan Richter
 M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/ieee1394/raw1394*
 
 IMS TWINTURBO FRAMEBUFFER DRIVER
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Orphan
+F:	drivers/video/imsttfb.c
 
 INFINIBAND SUBSYSTEM
 P:	Roland Dreier
@@ -2187,6 +2633,9 @@ L:	general@lists.openfabrics.org
 W:	http://www.openib.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
 S:	Supported
+F:	Documentation/infiniband/
+F:	drivers/infiniband/
+F:	include/linux/if_infiniband.h
 
 INOTIFY
 P:	John McCutchan
@@ -2195,6 +2644,8 @@ P:	Robert Love
 M:	rml@novell.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/filesystems/inotify.txt
+F:	fs/inotify*
 
 INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN) DRIVERS
 P:	Dmitry Torokhov
@@ -2203,18 +2654,22 @@ M:	dtor@mail.ru
 L:	linux-input@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/dtor/input.git
 S:	Maintained
+F:	drivers/input/
 
 INTEL FRAMEBUFFER DRIVER (excluding 810 and 815)
 P:	Sylvain Meyer
 M:	sylvain.meyer@worldonline.fr
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
+F:	Documentation/fb/intelfb.txt
+F:	drivers/video/intelfb/
 
 INTEL 810/815 FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
+F:	drivers/video/i810/
 
 INTEL MENLOW THERMAL DRIVER
 P:	Sujith Thomas
@@ -2222,17 +2677,21 @@ M:	sujith.thomas@intel.com
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 S:	Supported
+F:	drivers/misc/intel_menlow.c
 
 INTEL IA32 MICROCODE UPDATE SUPPORT
 P:	Tigran Aivazian
 M:	tigran@aivazian.fsnet.co.uk
 S:	Maintained
+F:	arch/x86/kernel/microcode_core.c
+F:	arch/x86/kernel/microcode_intel.c
 
 INTEL I/OAT DMA DRIVER
 P:	Maciej Sosnowski
 M:	maciej.sosnowski@intel.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	drivers/dma/ioat*
 
 INTEL IOMMU (VT-d)
 P:	David Woodhouse
@@ -2240,23 +2699,28 @@ M:	dwmw2@infradead.org
 L:	iommu@lists.linux-foundation.org
 T:	git://git.infradead.org/iommu-2.6.git
 S:	Supported
+F:	drivers/pci/intel-iommu.c
+F:	include/linux/intel-iommu.h
 
 INTEL IOP-ADMA DMA DRIVER
 P:	Dan Williams
 M:	dan.j.williams@intel.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	drivers/dma/iop-adma.c
 
 INTEL IXP4XX RANDOM NUMBER GENERATOR SUPPORT
 P:	Deepak Saxena
 M:	dsaxena@plexity.net
 S:	Maintained
+F:	drivers/char/hw_random/ixp4xx-rng.c
 
 INTEL IXP2000 ETHERNET DRIVER
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/ixp2000/
 
 INTEL ETHERNET DRIVERS (e100/e1000/e1000e/igb/ixgb/ixgbe)
 P:	Jeff Kirsher
@@ -2272,6 +2736,12 @@ M:	john.ronciak@intel.com
 L:	e1000-devel@lists.sourceforge.net
 W:	http://e1000.sourceforge.net/
 S:	Supported
+F:	drivers/net/e100.c
+F:	drivers/net/e1000/
+F:	drivers/net/e1000e/
+F:	drivers/net/igb/
+F:	drivers/net/ixgb/
+F:	drivers/net/ixgbe/
 
 INTEL PRO/WIRELESS 2100 NETWORK CONNECTION SUPPORT
 P:	Zhu Yi
@@ -2285,6 +2755,8 @@ L:	ipw2100-devel@lists.sourceforge.net
 W:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
 W:	http://ipw2100.sourceforge.net
 S:	Supported
+F:	Documentation/networking/README.ipw2100
+F:	drivers/net/wireless/ipw2100.*
 
 INTEL PRO/WIRELESS 2915ABG NETWORK CONNECTION SUPPORT
 P:	Zhu Yi
@@ -2298,6 +2770,7 @@ L:	ipw2100-devel@lists.sourceforge.net
 W:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
 W:	http://ipw2200.sourceforge.net
 S:	Supported
+F:	drivers/net/wireless/ipw2200.*
 
 INTEL WIRELESS WIFI LINK (iwlwifi)
 P:	Zhu Yi
@@ -2309,23 +2782,27 @@ L:	ipw3945-devel@lists.sourceforge.net
 W:	http://intellinuxwireless.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
 S:	Supported
+F:	drivers/net/wireless/iwlwifi/
 
 IOC3 ETHERNET DRIVER
 P:	Ralf Baechle
 M:	ralf@linux-mips.org
 L:	linux-mips@linux-mips.org
 S:	Maintained
+F:	drivers/net/ioc3-eth.c
 
 IOC3 SERIAL DRIVER
 P:	Pat Gefre
 M:	pfg@sgi.com
 L:	linux-mips@linux-mips.org
 S:	Maintained
+F:	drivers/serial/ioc3_serial.c
 
 IP MASQUERADING
 P:	Juanjo Ciarlante
 M:	jjciarla@raiz.uncu.edu.ar
 S:	Maintained
+F:	net/ipv4/netfilter/ipt_MASQUERADE.c
 
 IP1000A 10/100/1000 GIGABIT ETHERNET DRIVER
 P:	Francois Romieu
@@ -2336,6 +2813,7 @@ P:	Jesse Huang
 M:	jesse@icplus.com.tw
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/ipg.c
 
 IPATH DRIVER
 P:	Ralph Campbell
@@ -2343,6 +2821,7 @@ M:	infinipath@qlogic.com
 L:	general@lists.openfabrics.org
 T:	git git://git.qlogic.com/ipath-linux-2.6
 S:	Supported
+F:	drivers/infiniband/hw/ipath/
 
 IPMI SUBSYSTEM
 P:	Corey Minyard
@@ -2350,6 +2829,9 @@ M:	minyard@acm.org
 L:	openipmi-developer@lists.sourceforge.net
 W:	http://openipmi.sourceforge.net/
 S:	Supported
+F:	Documentation/IPMI.txt
+F:	drivers/char/ipmi/
+F:	include/linux/ipmi*
 
 IPS SCSI RAID DRIVER
 P:	Adaptec OEM Raid Solutions
@@ -2357,6 +2839,7 @@ M:	aacraid@adaptec.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.adaptec.com/
 S:	Maintained
+F:	drivers/scsi/ips*
 
 IPVS
 P:	Wensong Zhang
@@ -2368,6 +2851,8 @@ M:	ja@ssi.bg
 L:	netdev@vger.kernel.org
 L:	lvs-devel@vger.kernel.org
 S:	Maintained
+F:	Documentation/networking/ipvs-sysctl.txt
+F:	net/netfilter/ipvs/
 
 IPWIRELESS DRIVER
 P:	Jiri Kosina
@@ -2376,12 +2861,16 @@ P:	David Sterba
 M:	dsterba@suse.cz
 S:	Maintained
 T:	git://git.kernel.org/pub/scm/linux/kernel/git/jikos/ipwireless_cs.git
+F:	drivers/char/pcmcia/ipwireless/
 
 IPX NETWORK LAYER
 P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	include/linux/ipx.h
+F:	include/net/ipx.h
+F:	net/ipx/
 
 IRDA SUBSYSTEM
 P:	Samuel Ortiz
@@ -2389,11 +2878,18 @@ M:	samuel@sortiz.org
 L:	irda-users@lists.sourceforge.net (subscribers-only)
 W:	http://irda.sourceforge.net/
 S:	Maintained
+F:	Documentation/networking/irda.txt
+F:	drivers/net/irda/
+F:	include/net/irda/
+F:	net/irda/
 
 ISAPNP
 P:	Jaroslav Kysela
 M:	perex@perex.cz
 S:	Maintained
+F:	Documentation/isapnp.txt
+F:	drivers/pnp/isapnp/
+F:	include/linux/isapnp.h
 
 ISCSI
 P:	Mike Christie
@@ -2402,6 +2898,8 @@ L:	open-iscsi@googlegroups.com
 W:	www.open-iscsi.org
 T:	git kernel.org:/pub/scm/linux/kernel/mnc/linux-2.6-iscsi.git
 S:	Maintained
+F:	drivers/scsi/*iscsi*
+F:	include/scsi/*iscsi*
 
 ISDN SUBSYSTEM
 P:	Karsten Keil
@@ -2410,6 +2908,10 @@ L:	isdn4linux@listserv.isdn4linux.de (subscribers-only)
 W:	http://www.isdn4linux.de
 T:	git kernel.org:/pub/scm/linux/kernel/kkeil/isdn-2.6.git
 S:	Maintained
+F:	Documentation/isdn/
+F:	drivers/isdn/
+F:	include/linux/isdn.h
+F:	include/linux/isdn/
 
 ISDN SUBSYSTEM (Eicon active card driver)
 P:	Armin Schindler
@@ -2417,6 +2919,7 @@ M:	mac@melware.de
 L:	isdn4linux@listserv.isdn4linux.de (subscribers-only)
 W:	http://www.melware.de
 S:	Maintained
+F:	drivers/isdn/hardware/eicon/
 
 IVTV VIDEO4LINUX DRIVER
 P:	Hans Verkuil
@@ -2426,6 +2929,9 @@ L:	ivtv-users@ivtvdriver.org
 L:	video4linux-list@redhat.com
 W:	http://www.ivtvdriver.org
 S:	Maintained
+F:	Documentation/video4linux/*.ivtv
+F:	drivers/media/video/ivtv/
+F:	include/linux/ivtv*
 
 JFS FILESYSTEM
 P:	Dave Kleikamp
@@ -2434,12 +2940,15 @@ L:	jfs-discussion@lists.sourceforge.net
 W:	http://jfs.sourceforge.net/
 T:	git kernel.org:/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git
 S:	Supported
+F:	Documentation/filesystems/jfs.txt
+F:	fs/jfs/
 
 JME NETWORK DRIVER
 P:	Guo-Fu Tseng
 M:	cooldavid@cooldavid.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/jme.*
 
 JOURNALLING FLASH FILE SYSTEM V2 (JFFS2)
 P:	David Woodhouse
@@ -2447,24 +2956,33 @@ M:	dwmw2@infradead.org
 L:	linux-mtd@lists.infradead.org
 W:	http://www.linux-mtd.infradead.org/doc/jffs2.html
 S:	Maintained
+F:	fs/jffs2/
+F:	include/linux/jffs2.h
+F:	include/mtd/jffs2-user.h
 
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD)
 P:	Stephen Tweedie, Andrew Morton
 M:	sct@redhat.com, akpm@linux-foundation.org
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
+F:	fs/jbd*/
+F:	include/linux/*jbd*.h
 
 K8TEMP HARDWARE MONITORING DRIVER
 P:	Rudolf Marek
 M:	r.marek@assembler.cz
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/k8temp
+F:	drivers/hwmon/k8temp.c
 
 KCONFIG
 P:	Roman Zippel
 M:	zippel@linux-m68k.org
 L:	linux-kbuild@vger.kernel.org
 S:	Maintained
+F:	Documentation/kbuild/kconfig-language.txt
+F:	scripts/kconfig/
 
 KDUMP
 P:	Vivek Goyal
@@ -2475,18 +2993,21 @@ L:	kexec@lists.infradead.org
 L:	linux-kernel@vger.kernel.org
 W:	http://lse.sourceforge.net/kdump/
 S:	Maintained
+F:	Documentation/kdump
 
 KERNEL AUTOMOUNTER (AUTOFS)
 P:	H. Peter Anvin
 M:	hpa@zytor.com
 L:	autofs@linux.kernel.org
 S:	Odd Fixes
+F:	fs/autofs/
 
 KERNEL AUTOMOUNTER v4 (AUTOFS4)
 P:	Ian Kent
 M:	raven@themaw.net
 L:	autofs@linux.kernel.org
 S:	Maintained
+F:	fs/autofs4/
 
 KERNEL BUILD (kbuild: Makefile, scripts/Makefile.*)
 P:	Sam Ravnborg
@@ -2495,6 +3016,9 @@ T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-next.git
 T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-fixes.git
 L:	linux-kbuild@vger.kernel.org
 S:	Maintained
+F:	Documentation/kbuild/
+F:	Makefile
+F:	scripts/Makefile.*
 
 KERNEL JANITORS
 P:	Several
@@ -2510,6 +3034,13 @@ M:	neilb@suse.de
 L:	linux-nfs@vger.kernel.org
 W:	http://nfs.sourceforge.net/
 S:	Supported
+F:	fs/nfsd/
+F:	include/linux/nfsd/
+F:	fs/lockd/
+F:	fs/nfs_common/
+F:	net/sunrpc/
+F:	include/linux/lockd/
+F:	include/linux/sunrpc/
 
 KERNEL VIRTUAL MACHINE (KVM)
 P:	Avi Kivity
@@ -2517,6 +3048,10 @@ M:	avi@redhat.com
 L:	kvm@vger.kernel.org
 W:	http://kvm.qumranet.com
 S:	Supported
+F:	Documentation/*/kvm.txt
+F:	arch/*/kvm/
+F:	arch/*/include/asm/kvm*
+F:	include/linux/kvm*
 
 KERNEL VIRTUAL MACHINE (KVM) FOR AMD-V
 P:	Joerg Roedel
@@ -2540,6 +3075,8 @@ M:	xiantao.zhang@intel.com
 L:	kvm-ia64@vger.kernel.org
 W:	http://kvm.qumranet.com
 S:	Supported
+F:	Documentation/ia64/kvm.txt
+F:	arch/ia64/kvm/
 
 KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
 P:	Carsten Otte
@@ -2550,6 +3087,8 @@ M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
+F:	Documentation/s390/kvm.txt
+F:	arch/s390/kvm
 
 KEXEC
 P:	Eric Biederman
@@ -2558,12 +3097,19 @@ W:	http://ftp.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
 L:	linux-kernel@vger.kernel.org
 L:	kexec@lists.infradead.org
 S:	Maintained
+F:	include/linux/kexec.h
+F:	kernel/kexec.c
 
 KGDB
 P:	Jason Wessel
 M:	jason.wessel@windriver.com
 L:	kgdb-bugreport@lists.sourceforge.net
 S:	Maintained
+F:	Documentation/DocBook/kgdb.tmpl
+F:	drivers/misc/kgdbts.c
+F:	drivers/serial/kgdboc.c
+F:	include/linux/kgdb.h
+F:	kernel/kgdb.c
 
 KPROBES
 P:	Ananth N Mavinakayanahalli
@@ -2576,6 +3122,9 @@ P:	Masami Hiramatsu
 M:	mhiramat@redhat.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/kprobes.txt
+F:	include/linux/kprobes.h
+F:	kernel/kprobes.c
 
 KS0108 LCD CONTROLLER DRIVER
 P:	Miguel Ojeda Sandonis
@@ -2584,21 +3133,31 @@ L:	linux-kernel@vger.kernel.org
 W:	http://miguelojeda.es/auxdisplay.htm
 W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
+F:	Documentation/auxdisplay/ks0108
+F:	drivers/auxdisplay/ks0108.c
+F:	include/linux/ks0108.h
 
 LAPB module
 L:	linux-x25@vger.kernel.org
 S:	Orphan
+F:	Documentation/networking/lapb-module.txt
+F:	include/*/lapb.h
+F:	net/lapb/
 
 LASI 53c700 driver for PARISC
 P:	James E.J. Bottomley
 M:	James.Bottomley@HansenPartnership.com
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	Documentation/scsi/53c700.txt
+F:	drivers/scsi/53c700*
 
 LED SUBSYSTEM
 P:	Richard Purdie
 M:	rpurdie@rpsys.net
 S:	Maintained
+F:	drivers/leds/
+F:	include/linux/leds.h
 
 LEGO USB Tower driver
 P:	Juergen Stuber
@@ -2606,6 +3165,7 @@ M:	starblue@users.sourceforge.net
 L:	legousb-devel@lists.sourceforge.net
 W:	http://legousb.sourceforge.net/
 S:	Maintained
+F:	drivers/usb/misc/legousbtower.c
 
 LGUEST
 P:	Rusty Russell
@@ -2613,6 +3173,11 @@ M:	rusty@rustcorp.com.au
 L:	lguest@ozlabs.org
 W:	http://lguest.ozlabs.org/
 S:	Maintained
+F:	Documentation/lguest/
+F:	arch/x86/lguest/
+F:	drivers/lguest/
+F:	include/linux/lguest*.h
+F:	arch/x86/include/asm/lguest*.h
 
 LINUX FOR IBM pSERIES (RS/6000)
 P:	Paul Mackerras
@@ -2625,6 +3190,11 @@ P:	James Bottomley
 M:	James.Bottomley@HansenPartnership.com
 W:	http://www.hansenpartnership.com/voyager
 S:	Maintained
+F:	Documentation/voyager.txt
+F:	arch/x86/boot/voyager.c
+F:	arch/x86/mach-voyager/
+F:	arch/x86/include/asm/mach-voyager/
+F:	arch/x86/include/asm/voyager.h
 
 LINUX FOR POWERPC (32-BIT AND 64-BIT)
 P:	Paul Mackerras
@@ -2702,23 +3272,31 @@ LLC (802.2)
 P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
 S:	Maintained
+F:	include/linux/llc.h
+F:	include/net/llc*
+F:	net/llc/
 
 LIS3LV02D ACCELEROMETER DRIVER
 P:	Eric Piel
 M:	eric.piel@tremplin-utc.net
 S:	Maintained
+F:	drivers/hwmon/lis3lv02d.*
 
 LM83 HARDWARE MONITOR DRIVER
 P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/lm83
+F:	drivers/hwmon/lm83.c
 
 LM90 HARDWARE MONITOR DRIVER
 P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/lm90
+F:	drivers/hwmon/lm90.c
 
 LOCKDEP AND LOCKSTAT
 P:	Peter Zijlstra
@@ -2728,6 +3306,10 @@ M:	mingo@redhat.com
 L:	linux-kernel@vger.kernel.org
 T:	git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git
 S:	Maintained
+F:	Documentation/lockdep-design.txt
+F:	Documentation/lockstat.txt
+F:	include/linux/lockdep.h
+F:	kernel/lockdep*
 
 LOGICAL DISK MANAGER SUPPORT (LDM, Windows 2000/XP/Vista Dynamic Disks)
 P:	Richard Russon (FlatCap)
@@ -2735,6 +3317,8 @@ M:	ldm@flatcap.org
 L:	linux-ntfs-dev@lists.sourceforge.net
 W:	http://www.linux-ntfs.org/content/view/19/37/
 S:	Maintained
+F:	Documentation/ldm.txt
+F:	fs/partitions/ldm.*
 
 LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
 P:	Eric Moore
@@ -2744,12 +3328,14 @@ L:	DL-MPTFusionLinux@lsi.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.lsilogic.com/support
 S:	Supported
+F:	drivers/message/fusion/
 
 LSILOGIC/SYMBIOS/NCR 53C8XX and 53C1010 PCI-SCSI drivers
 P:	Matthew Wilcox
 M:	matthew@wil.cx
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/sym53c8xx_2/
 
 LTP (Linux Test Project)
 P:	Subrata Modak
@@ -2768,6 +3354,8 @@ L:	linux-m32r@ml.linux-m32r.org
 L:	linux-m32r-ja@ml.linux-m32r.org (in Japanese)
 W:	http://www.linux-m32r.org/
 S:	Maintained
+F:	arch/m32r/
+F:	include/asm-m32r/
 
 M68K ARCHITECTURE
 P:	Geert Uytterhoeven
@@ -2778,6 +3366,8 @@ L:	linux-m68k@lists.linux-m68k.org
 W:	http://www.linux-m68k.org/
 W:	http://linux-m68k-cvs.ubb.ca/
 S:	Maintained
+F:	arch/m68k/
+F:	include/asm-m68k/
 
 M68K ON APPLE MACINTOSH
 P:	Joshua Thompson
@@ -2791,6 +3381,8 @@ P:	Philip Blundell
 M:	philb@gnu.org
 W:	http://www.tazenda.demon.co.uk/phil/linux-hp
 S:	Maintained
+F:	arch/m68k/hp300/
+F:	include/asm-m68k/hp*
 
 MAC80211
 P:	Johannes Berg
@@ -2801,6 +3393,9 @@ L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
+F:	Documentation/networking/mac80211-injection.txt
+F:	include/net/mac80211.h
+F:	net/mac80211/
 
 MAC80211 PID RATE CONTROL
 P:	Stefano Brivio
@@ -2811,12 +3406,15 @@ L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/en/developers/Documentation/mac80211/RateControl/PID
 T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
+F:	net/mac80211/rc80211_pid*
 
 MACVLAN DRIVER
 P:	Patrick McHardy
 M:	kaber@trash.net
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/macvlan.c
+F:	include/linux/if_macvlan.h
 
 MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
 P:	Michael Kerrisk
@@ -2830,12 +3428,15 @@ P:	Dan Williams
 M:	dcbw@redhat.com
 L:	libertas-dev@lists.infradead.org
 S:	Maintained
+F:	drivers/net/wireless/libertas/
 
 MARVELL MV643XX ETHERNET DRIVER
 P:	Lennert Buytenhek
 M:	buytenh@marvell.com
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	drivers/net/mv643xx_eth.c
+F:	include/linux/mv643xx.h
 
 MARVELL YUKON / SYSKONNECT DRIVER
 P:	Mirko Lindner
@@ -2850,12 +3451,16 @@ P:	Petr Vandrovec
 M:	vandrove@vc.cvut.cz
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
+F:	drivers/video/matrox/matroxfb_*
+F:	include/linux/matroxfb.h
 
 MAX6650 HARDWARE MONITOR AND FAN CONTROLLER DRIVER
 P:	Hans J. Koch
 M:	hjk@linutronix.de
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/max6650
+F:	drivers/hwmon/max6650.c
 
 MEGARAID SCSI DRIVERS
 P:	Neela Syam Kolli
@@ -2863,12 +3468,17 @@ M:	megaraidlinux@lsi.com
 L:	linux-scsi@vger.kernel.org
 W:	http://megaraid.lsilogic.com
 S:	Maintained
+F:	Documentation/scsi/megaraid.txt
+F:	drivers/scsi/megaraid.*
+F:	drivers/scsi/megaraid/
 
 MEMORY MANAGEMENT
 L:	linux-mm@kvack.org
 L:	linux-kernel@vger.kernel.org
 W:	http://www.linux-mm.org
 S:	Maintained
+F:	include/linux/mm.h
+F:	mm/
 
 MEMORY RESOURCE CONTROLLER
 P:	Balbir Singh
@@ -2880,6 +3490,7 @@ M:	kamezawa.hiroyu@jp.fujitsu.com
 L:	linux-mm@kvack.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	mm/memcontrol.c
 
 MEMORY TECHNOLOGY DEVICES (MTD)
 P:	David Woodhouse
@@ -2888,11 +3499,15 @@ W:	http://www.linux-mtd.infradead.org/
 L:	linux-mtd@lists.infradead.org
 T:	git git://git.infradead.org/mtd-2.6.git
 S:	Maintained
+F:	drivers/mtd/
+F:	include/linux/mtd/
+F:	include/mtd/
 
 MICROTEK X6 SCANNER
 P:	Oliver Neukum
 M:	oliver@neukum.name
 S:	Maintained
+F:	drivers/usb/image/microtek.*
 
 MIPS
 P:	Ralf Baechle
@@ -2901,42 +3516,58 @@ W:	http://www.linux-mips.org/
 L:	linux-mips@linux-mips.org
 T:	git www.linux-mips.org:/pub/scm/linux.git
 S:	Supported
+F:	Documentation/mips/
+F:	arch/mips/
 
 MISCELLANEOUS MCA-SUPPORT
 P:	James Bottomley
 M:	James.Bottomley@HansenPartnership.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/ia64/mca.txt
+F:	Documentation/mca.txt
+F:	drivers/mca/
+F:	include/linux/mca*
 
 MODULE SUPPORT
 P:	Rusty Russell
 M:	rusty@rustcorp.com.au
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	include/linux/module.h
+F:	kernel/module.c
 
 MOTION EYE VAIO PICTUREBOOK CAMERA DRIVER
 P:	Stelian Pop
 M:	stelian@popies.net
 W:	http://popies.net/meye/
 S:	Maintained
+F:	Documentation/video4linux/meye.txt
+F:	drivers/media/video/meye.*
+F:	include/linux/meye.h
 
 MOTOROLA IMX MMC/SD HOST CONTROLLER INTERFACE DRIVER
 P:	Pavel Pisa
 M:	ppisa@pikron.com
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	drivers/mmc/host/imxmmc.*
 
 MOUSE AND MISC DEVICES [GENERAL]
 P:	Alessandro Rubini
 M:	rubini@ipvvis.unipv.it
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/input/mouse/
+F:	include/linux/gpio_mouse.h
 
 MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CARD
 P:	Jiri Slaby
 M:	jirislaby@gmail.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/serial/moxa-smartio
+F:	drivers/char/mxser.*
 
 MSI LAPTOP SUPPORT
 P:	Lennart Poettering
@@ -2944,18 +3575,22 @@ M:	mzxreary@0pointer.de
 W:	https://tango.0pointer.de/mailman/listinfo/s270-linux
 W:	http://0pointer.de/lennart/tchibo.html
 S:	Maintained
+F:	drivers/misc/msi-laptop.c
 
 MULTIFUNCTION DEVICES (MFD)
 P:	Samuel Ortiz
 M:	sameo@openedhand.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	drivers/mfd/
 
 MULTIMEDIA CARD (MMC), SECURE DIGITAL (SD) AND SDIO SUBSYSTEM
 P:	Pierre Ossman
 M:	drzeus-mmc@drzeus.cx
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/mmc/
+F:	include/linux/mmc/
 
 MULTIMEDIA CARD (MMC) ETC. OVER SPI
 P:	David Brownell
@@ -2967,18 +3602,23 @@ MULTISOUND SOUND DRIVER
 P:	Andrew Veliath
 M:	andrewtv@usa.net
 S:	Maintained
+F:	Documentation/sound/oss/MultiSound
+F:	sound/oss/msnd*
 
 MULTITECH MULTIPORT CARD (ISICOM)
 P:	Jiri Slaby
 M:	jirislaby@gmail.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/char/isicom.c
+F:	include/linux/isicom.h
 
 MUSB MULTIPOINT HIGH SPEED DUAL-ROLE CONTROLLER
 P:	Felipe Balbi
 M:	felipe.balbi@nokia.com
 L:	linux-usb@vger.kernel.org
 S:	Maintained
+F:	drivers/usb/musb/
 
 MYRICOM MYRI-10G 10GbE DRIVER (MYRI10GE)
 P:	Andrew Gallatin
@@ -2988,23 +3628,27 @@ M:	brice@myri.com
 L:	netdev@vger.kernel.org
 W:	http://www.myri.com/scs/download-Myri10GE.html
 S:	Supported
+F:	drivers/net/myri10ge/
 
 NATSEMI ETHERNET DRIVER (DP8381x)
 P:	Tim Hockin
 M:	thockin@hockin.org
 S:	Maintained
+F:	drivers/net/natsemi.c
 
 NCP FILESYSTEM
 P:	Petr Vandrovec
 M:	vandrove@vc.cvut.cz
 L:	linware@sh.cvut.cz
 S:	Maintained
+F:	fs/ncpfs/
 
 NCR DUAL 700 SCSI DRIVER (MICROCHANNEL)
 P:	James E.J. Bottomley
 M:	James.Bottomley@HansenPartnership.com
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/NCR_D700.*
 
 NETEFFECT IWARP RNIC DRIVER (IW_NES)
 P:	Faisal Latif
@@ -3021,6 +3665,7 @@ P:	Stephen Hemminger
 M:	shemminger@linux-foundation.org
 L:	netem@lists.linux-foundation.org
 S:	Maintained
+F:	net/sched/sch_netem.c
 
 NETERION (S2IO) Xframe 10GbE DRIVER
 P:	Ramkrishna Vepa
@@ -3034,6 +3679,8 @@ M:	sreenivasa.honnur@neterion.com
 L:	netdev@vger.kernel.org
 W:	http://trac.neterion.com/cgi-bin/trac.cgi/wiki/TitleIndex?anonymous
 S:	Supported
+F:	Documentation/networking/s2io.txt
+F:	drivers/net/s2io*
 
 NETFILTER/IPTABLES/IPCHAINS
 P:	Rusty Russell
@@ -3049,6 +3696,12 @@ L:	coreteam@netfilter.org
 W:	http://www.netfilter.org/
 W:	http://www.iptables.org/
 S:	Supported
+F:	include/linux/netfilter*
+F:	include/linux/netfilter/
+F:	include/net/netfilter/
+F:	net/*/netfilter.c
+F:	net/*/netfilter/
+F:	net/netfilter/
 
 NETLABEL
 P:	Paul Moore
@@ -3056,6 +3709,9 @@ M:	paul.moore@hp.com
 W:	http://netlabel.sf.net
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	Documentation/netlabel
+F:	include/net/netlabel.h
+F:	net/netlabel/
 
 NETROM NETWORK LAYER
 P:	Ralf Baechle
@@ -3063,11 +3719,17 @@ M:	ralf@linux-mips.org
 L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
+F:	include/linux/netrom.h
+F:	include/net/netrom.h
+F:	net/netrom/
 
 NETWORK BLOCK DEVICE (NBD)
 P:	Paul Clements
 M:	Paul.Clements@steeleye.com
 S:	Maintained
+F:	Documentation/blockdev/nbd.txt
+F:	drivers/block/nbd.c
+F:	include/linux/nbd.h
 
 NETWORK DEVICE DRIVERS
 P:	Jeff Garzik
@@ -3075,6 +3737,7 @@ M:	jgarzik@pobox.com
 L:	netdev@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
 S:	Maintained
+F:	drivers/net/
 
 NETWORKING [GENERAL]
 P:	Networking Team
@@ -3082,6 +3745,8 @@ M:	netdev@vger.kernel.org
 L:	netdev@vger.kernel.org
 W:	http://linux-net.osdl.org/
 S:	Maintained
+F:	net/
+F:	include/net/
 
 NETWORKING [IPv4/IPv6]
 P:	David S. Miller
@@ -3099,6 +3764,9 @@ M:	kaber@trash.net
 L:	netdev@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git
 S:	Maintained
+F:	net/ipv4/
+F:	net/ipv6/
+F:	include/net/ip*
 
 NETWORKING [LABELED] (NetLabel, CIPSO, Labeled IPsec, SECMARK)
 P:	Paul Moore
@@ -3112,6 +3780,10 @@ M:	linville@tuxdriver.com
 L:	linux-wireless@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
+F:	net/ieee80211/
+F:	net/wireless/
+F:	include/net/ieee80211*
+F:	include/net/wireless.h
 
 NETXEN (1/10) GbE SUPPORT
 P:	Dhananjay Phadke
@@ -3119,6 +3791,7 @@ M:	dhananjay@netxen.com
 L:	netdev@vger.kernel.org
 W:	http://www.netxen.com
 S:	Supported
+F:	drivers/net/netxen/
 
 NFS, SUNRPC, AND LOCKD CLIENTS
 P:	Trond Myklebust
@@ -3127,6 +3800,13 @@ L:	linux-nfs@vger.kernel.org
 W:	http://client.linux-nfs.org
 T:	git git://git.linux-nfs.org/pub/linux/nfs-2.6.git
 S:	Maintained
+F:	fs/lockd/
+F:	fs/nfs/
+F:	fs/nfs_common/
+F:	net/sunrpc/
+F:	include/linux/lockd/
+F:	include/linux/nfs*
+F:	include/linux/sunrpc/
 
 NI5010 NETWORK DRIVER
 P:	Jan-Pascal van Best
@@ -3135,12 +3815,15 @@ P:	Andreas Mohr
 M:	andi@lisas.de
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/ni5010.*
 
 NINJA SCSI-3 / NINJA SCSI-32Bi (16bit/CardBus) PCMCIA SCSI HOST ADAPTER DRIVER
 P:	YOKOTA Hiroshi
 M:	yokota@netlab.is.tsukuba.ac.jp
 W:	http://www.netlab.is.tsukuba.ac.jp/~yokota/izumi/ninja/
 S:	Maintained
+F:	Documentation/scsi/NinjaSCSI.txt
+F:	drivers/scsi/pcmcia/nsp_*
 
 NINJA SCSI-32Bi/UDE PCI/CARDBUS SCSI HOST ADAPTER DRIVER
 P:	GOTO Masanori
@@ -3149,6 +3832,8 @@ P:	YOKOTA Hiroshi
 M:	yokota@netlab.is.tsukuba.ac.jp
 W:	http://www.netlab.is.tsukuba.ac.jp/~yokota/izumi/ninja/
 S:	Maintained
+F:	Documentation/scsi/NinjaSCSI.txt
+F:	drivers/scsi/nsp32*
 
 NTFS FILESYSTEM
 P:	Anton Altaparmakov
@@ -3158,40 +3843,52 @@ L:	linux-kernel@vger.kernel.org
 W:	http://www.linux-ntfs.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/aia21/ntfs-2.6.git
 S:	Maintained
+F:	Documentation/filesystems/ntfs.txt
+F:	fs/ntfs/
 
 NVIDIA (rivafb and nvidiafb) FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
+F:	drivers/video/riva/
+F:	drivers/video/nvidia/
 
 OMFS FILESYSTEM
 P:	Bob Copeland
 M:	me@bobcopeland.com
 L:	linux-karma-devel@lists.sourceforge.net
 S:	Maintained
+F:	Documentation/filesystems/omfs.txt
+F:	fs/omfs/
 
 OMNIKEY CARDMAN 4000 DRIVER
 P:	Harald Welte
 M:	laforge@gnumonks.org
 S:	Maintained
+F:	drivers/char/pcmcia/cm4000_cs.c
+F:	include/linux/cm4000_cs.h
 
 OMNIKEY CARDMAN 4040 DRIVER
 P:	Harald Welte
 M:	laforge@gnumonks.org
 S:	Maintained
+F:	drivers/char/pcmcia/cm4040_cs.*
 
 OMNIVISION OV7670 SENSOR DRIVER
 P:	Jonathan Corbet
 M:	corbet@lwn.net
 L:	video4linux-list@redhat.com
 S:	Maintained
+F:	drivers/media/video/ov7670.c
 
 ONENAND FLASH DRIVER
 P:	Kyungmin Park
 M:	kyungmin.park@samsung.com
 L:	linux-mtd@lists.infradead.org
 S:	Maintained
+F:	drivers/mtd/onenand/
+F:	include/linux/mtd/onenand*.h
 
 ONSTREAM SCSI TAPE DRIVER
 P:	Willem Riede
@@ -3199,18 +3896,25 @@ M:	osst@riede.org
 L:	osst-users@lists.sourceforge.net
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/osst*
+F:	drivers/scsi/st*
 
 OPENCORES I2C BUS DRIVER
 P:	Peter Korsgaard
 M:	jacmet@sunsite.dk
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
+F:	Documentation/i2c/busses/i2c-ocores
+F:	drivers/i2c/busses/i2c-ocores.c
 
 OPROFILE
 P:	Robert Richter
 M:	robert.richter@amd.com
 L:	oprofile-list@lists.sf.net
 S:	Maintained
+F:	arch/*/oprofile/
+F:	drivers/oprofile/
+F:	include/linux/oprofile.h
 
 ORACLE CLUSTER FILESYSTEM 2 (OCFS2)
 P:	Mark Fasheh
@@ -3221,6 +3925,9 @@ L:	ocfs2-devel@oss.oracle.com (moderated for non-subscribers)
 W:	http://oss.oracle.com/projects/ocfs2/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git
 S:	Supported
+F:	Documentation/filesystems/ocfs2.txt
+F:	Documentation/filesystems/dlmfs.txt
+F:	fs/ocfs2/
 
 ORINOCO DRIVER
 P:	Pavel Roskin
@@ -3232,6 +3939,10 @@ L:	orinoco-users@lists.sourceforge.net
 L:	orinoco-devel@lists.sourceforge.net
 W:	http://www.nongnu.org/orinoco/
 S:	Maintained
+F:	drivers/net/wireless/orinoco*
+F:	drivers/net/wireless/airport.c
+F:	drivers/net/wireless/spectrum_cs.c
+F:	drivers/net/wireless/hermes*
 
 P54 WIRELESS DRIVER
 P:	Michael Wu
@@ -3246,17 +3957,20 @@ P:	Olof Johansson
 M:	olof@lixom.net
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/pasemi_mac.*
 
 PA SEMI SMBUS DRIVER
 P:	Olof Johansson
 M:	olof@lixom.net
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
+F:	drivers/i2c/busses/i2c-pasemi.c
 
 PANASONIC LAPTOP ACPI EXTRAS DRIVER
 P:	Harald Welte
 M:	laforge@gnumonks.org
 S:	Maintained
+F:	drivers/misc/panasonic-laptop.c
 
 PANASONIC MN10300/AM33 PORT
 P:	David Howells
@@ -3266,6 +3980,9 @@ M:	yasutake.koichi@jp.panasonic.com
 L:	linux-am33-list@redhat.com (moderated for non-subscribers)
 W:	ftp://ftp.redhat.com/pub/redhat/gnupro/AM33/
 S:	Maintained
+F:	Documentation/mn10300/
+F:	arch/mn10300/
+F:	include/asm-mn10300/
 
 PARALLEL PORT SUPPORT
 L:	linux-parport@lists.infradead.org (subscribers-only)
@@ -3283,6 +4000,9 @@ M:	rusty@rustcorp.com.au
 L:	virtualization@lists.osdl.org
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	Documentation/ia64/paravirt_ops.txt
+F:	arch/*/kernel/paravirt*
+F:	arch/*/include/asm/paravirt.h
 
 PARIDE DRIVERS FOR PARALLEL PORT IDE DEVICES
 P:	Tim Waugh
@@ -3290,6 +4010,8 @@ M:	tim@cyberelk.net
 L:	linux-parport@lists.infradead.org (subscribers-only)
 W:	http://www.torque.net/linux-pp.html
 S:	Maintained
+F:	Documentation/blockdev/paride.txt
+F:	drivers/block/paride/
 
 PARISC ARCHITECTURE
 P:	Kyle McMartin
@@ -3302,17 +4024,22 @@ L:	linux-parisc@vger.kernel.org
 W:	http://www.parisc-linux.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
 S:	Maintained
+F:	arch/parisc/
+F:	drivers/parisc/
 
 PC87360 HARDWARE MONITORING DRIVER
 P:	Jim Cromie
 M:	jim.cromie@gmail.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/pc87360
+F:	drivers/hwmon/pc87360.c
 
 PC8736x GPIO DRIVER
 P:	Jim Cromie
 M:	jim.cromie@gmail.com
 S:	Maintained
+F:	drivers/char/pc8736x_gpio.c
 
 PCI ERROR RECOVERY
 P:	Linas Vepstas
@@ -3320,6 +4047,8 @@ M:	linas@austin.ibm.com
 L:	linux-kernel@vger.kernel.org
 L:	linux-pci@vger.kernel.org
 S:	Supported
+F:	Documentation/PCI/pci-error-recovery.txt
+F:	Documentation/powerpc/eeh-pci-error-recovery.txt
 
 PCI SUBSYSTEM
 P:	Jesse Barnes
@@ -3328,12 +4057,16 @@ L:	linux-kernel@vger.kernel.org
 L:	linux-pci@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
 S:	Supported
+F:	Documentation/PCI/
+F:	drivers/pci/
+F:	include/linux/pci*
 
 PCIE HOTPLUG DRIVER
 P:	Kristen Carlson Accardi
 M:	kristen.c.accardi@intel.com
 L:	linux-pci@vger.kernel.org
 S:	Supported
+F:	drivers/pci/pcie/
 
 PCMCIA SUBSYSTEM
 P:	Linux PCMCIA Team
@@ -3341,42 +4074,55 @@ L:	linux-pcmcia@lists.infradead.org
 W:	http://lists.infradead.org/mailman/listinfo/linux-pcmcia
 T:	git kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
 S:	Maintained
+F:	Documentation/pcmcia/
+F:	drivers/pcmcia/
+F:	include/pcmcia/
 
 PCNET32 NETWORK DRIVER
 P:	Don Fry
 M:	pcnet32@verizon.net
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/pcnet32.c
 
 PER-TASK DELAY ACCOUNTING
 P:	Balbir Singh
 M:	balbir@linux.vnet.ibm.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	include/linux/delayacct.h
+F:	kernel/delayacct.c
 
 PERSONALITY HANDLING
 P:	Christoph Hellwig
 M:	hch@infradead.org
 L:	linux-abi-devel@lists.sourceforge.net
 S:	Maintained
+F:	include/linux/personality.h
 
 PHRAM MTD DRIVER
 P:	Joern Engel
 M:	joern@lazybastard.org
 L:	linux-mtd@lists.infradead.org
 S:	Maintained
+F:	drivers/mtd/devices/phram.c
 
 PKTCDVD DRIVER
 P:	Peter Osterlund
 M:	petero2@telia.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/block/pktcdvd.c
+F:	include/linux/pktcdvd.h
 
 POSIX CLOCKS and TIMERS
 P:	Thomas Gleixner
 M:	tglx@linutronix.de
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	fs/timerfd.c
+F:	include/linux/timer*
+F:	kernel/*timer*
 
 POWER SUPPLY CLASS/SUBSYSTEM and DRIVERS
 P:	Anton Vorontsov
@@ -3386,6 +4132,8 @@ M:	dwmw2@infradead.org
 L:	linux-kernel@vger.kernel.org
 T:	git git.infradead.org/battery-2.6.git
 S:	Maintained
+F:	include/linux/power_supply.h
+F:	drivers/power/power_supply*
 
 PNP SUPPORT
 P:	Adam Belay
@@ -3393,33 +4141,42 @@ M:	abelay@mit.edu
 P:	Bjorn Helgaas
 M:	bjorn.helgaas@hp.com
 S:	Maintained
+F:	drivers/pnp/
 
 PNXxxxx I2C DRIVER
 P:	Vitaly Wool
 M:	vitalywool@gmail.com
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
+F:	drivers/i2c/busses/i2c-pnx.c
 
 PPP PROTOCOL DRIVERS AND COMPRESSORS
 P:	Paul Mackerras
 M:	paulus@samba.org
 L:	linux-ppp@vger.kernel.org
 S:	Maintained
+F:	drivers/net/ppp_*
 
 PPP OVER ATM (RFC 2364)
 P:	Mitchell Blank Jr
 M:	mitch@sfgoth.com
 S:	Maintained
+F:	net/atm/pppoatm.c
+F:	include/linux/atmppp.h
 
 PPP OVER ETHERNET
 P:	Michal Ostrowski
 M:	mostrows@earthlink.net
 S:	Maintained
+F:	drivers/net/pppoe.c
+F:	drivers/net/pppox.c
 
 PPP OVER L2TP
 P:	James Chapman
 M:	jchapman@katalix.com
 S:	Maintained
+F:	drivers/net/pppol2tp.c
+F:	include/linux/if_pppol2tp.h
 
 PREEMPTIBLE KERNEL
 P:	Robert Love
@@ -3428,6 +4185,8 @@ L:	linux-kernel@vger.kernel.org
 L:	kpreempt-tech@lists.sourceforge.net
 W:	ftp://ftp.kernel.org/pub/linux/kernel/people/rml/preempt-kernel
 S:	Supported
+F:	Documentation/preempt-locking.txt
+F:	include/linux/preempt.h
 
 PRISM54 WIRELESS DRIVER
 P:	Luis R. Rodriguez
@@ -3435,6 +4194,7 @@ M:	mcgrof@gmail.com
 L:	linux-wireless@vger.kernel.org
 W:	http://prism54.org
 S:	Maintained
+F:	drivers/net/wireless/prism54/
 
 PROMISE DC4030 CACHING DISK CONTROLLER DRIVER
 P:	Peter Denison
@@ -3447,6 +4207,7 @@ P:	Mikael Pettersson
 M:	mikpe@it.uu.se
 L:	linux-ide@vger.kernel.org
 S:	Maintained
+F:	drivers/ata/sata_promise.*
 
 PS3 NETWORK SUPPORT
 P:	Masakazu Mokuno
@@ -3454,6 +4215,7 @@ M:	mokuno@sm.sony.co.jp
 L:	netdev@vger.kernel.org
 L:	cbe-oss-dev@ozlabs.org
 S:	Supported
+F:	drivers/net/ps3_gelic_net.*
 
 PS3 PLATFORM SUPPORT
 P:	Geoff Levand
@@ -3469,6 +4231,8 @@ L:	pvrusb2@isely.net	(subscribers-only)
 L:	video4linux-list@redhat.com
 W:	http://www.isely.net/pvrusb2/
 S:	Maintained
+F:	Documentation/video4linux/README.pvrusb2
+F:	drivers/media/video/pvrusb2/
 
 PXA2xx/PXA3xx SUPPORT
 P:	Eric Miao
@@ -3477,6 +4241,12 @@ P:	Russell King
 M:	linux@arm.linux.org.uk
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-pxa/
+F:	drivers/pcmcia/pxa2xx*
+F:	drivers/spi/pxa2xx*
+F:	drivers/usb/gadget/pxa2*
+F:	include/sound/pxa2xx-lib.h
+F:	sound/soc/pxa/pxa2xx*
 
 PXA MMCI DRIVER
 S:	Orphan
@@ -3486,12 +4256,16 @@ P:	Andrew Vasquez
 M:	linux-driver@qlogic.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
+F:	Documentation/scsi/LICENSE.qla2xxx
+F:	drivers/scsi/qla2xxx/
 
 QLOGIC QLA3XXX NETWORK DRIVER
 P:	Ron Mercer
 M:	linux-driver@qlogic.com
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	Documentation/networking/LICENSE.qla3xxx
+F:	drivers/net/qla3xxx.*
 
 QLOGIC QLGE 10Gb ETHERNET DRIVER
 P:	Ron Mercer
@@ -3499,6 +4273,7 @@ M:	linux-driver@qlogic.com
 M:	ron.mercer@qlogic.com
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	drivers/net/qlge/
 
 QNX4 FILESYSTEM
 P:	Anders Larsen
@@ -3506,18 +4281,24 @@ M:	al@alarsen.net
 L:	linux-kernel@vger.kernel.org
 W:	http://www.alarsen.net/linux/qnx4fs/
 S:	Maintained
+F:	fs/qnx4
+F:	include/linux/qnx4_fs.h
+F:	include/linux/qnxtypes.h
 
 RADEON FRAMEBUFFER DISPLAY DRIVER
 P:	Benjamin Herrenschmidt
 M:	benh@kernel.crashing.org
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
+F:	drivers/video/aty/radeon*
+F:	include/linux/radeonfb.h
 
 RAGE128 FRAMEBUFFER DISPLAY DRIVER
 P:	Paul Mackerras
 M:	paulus@samba.org
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
+F:	drivers/video/aty/aty128fb.c
 
 RALINK RT2X00 WIRELESS LAN DRIVER
 P:	rt2x00 project
@@ -3532,41 +4313,51 @@ RAMDISK RAM BLOCK DEVICE DRIVER
 P:	Nick Piggin
 M:	npiggin@suse.de
 S:	Maintained
+F:	Documentation/blockdev/ramdisk.txt
+F:	drivers/block/brd.c
 
 RANDOM NUMBER DRIVER
 P:	Matt Mackall
 M:	mpm@selenic.com
 S:	Maintained
+F:	drivers/char/random.c
 
 RAPIDIO SUBSYSTEM
 P:	Matt Porter
 M:	mporter@kernel.crashing.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/rapidio/
 
 RAYLINK/WEBGEAR 802.11 WIRELESS LAN DRIVER
 P:	Corey Thomas
 M:	coreythomas@charter.net
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
+F:	drivers/net/wireless/ray*
 
 RCUTORTURE MODULE
 P:	Josh Triplett
 M:	josh@freedesktop.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/RCU/torture.txt
+F:	kernel/rcutorture.c
 
 RDC R-321X SoC
 P:	Florian Fainelli
 M:	florian.fainelli@telecomint.eu
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	arch/x86/mach-rdc321x/
+F:	arch/x86/include/asm/mach-rdc321x/
 
 RDC R6040 FAST ETHERNET DRIVER
 P:	Florian Fainelli
 M:	florian.fainelli@telecomint.eu
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/r6040.c
 
 READ-COPY UPDATE (RCU)
 P:	Dipankar Sarma
@@ -3574,22 +4365,34 @@ M:	dipankar@in.ibm.com
 W:	http://www.rdrop.com/users/paulmck/rclock/
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	Documentation/RCU/rcu.txt
+F:	Documentation/RCU/rcuref.txt
+F:	include/linux/rcupdate.h
+F:	include/linux/srcu.h
+F:	kernel/rcupdate.c
 
 REAL TIME CLOCK DRIVER
 P:	Paul Gortmaker
 M:	p_gortmaker@yahoo.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/rtc.txt
+F:	drivers/rtc/
+F:	include/linux/rtc.h
 
 REAL TIME CLOCK (RTC) SUBSYSTEM
 P:	Alessandro Zummo
 M:	a.zummo@towertech.it
 L:	rtc-linux@googlegroups.com
 S:	Maintained
+F:	Documentation/rtc.txt
+F:	drivers/rtc/
+F:	include/linux/rtc.h
 
 REISERFS FILE SYSTEM
 L:	reiserfs-devel@vger.kernel.org
 S:	Supported
+F:	fs/reiserfs/
 
 RFKILL
 P:	Ivo van Doorn
@@ -3600,11 +4403,15 @@ F:	net/rfkill
 
 RISCOM8 DRIVER
 S:	Orphan
+F:	Documentation/serial/riscom8.txt
+F:	drivers/char/riscom8*
 
 ROCKETPORT DRIVER
 P:	Comtrol Corp.
 W:	http://www.comtrol.com
 S:	Maintained
+F:	Documentation/serial/rocket.txt
+F:	drivers/char/rocket*
 
 ROSE NETWORK LAYER
 P:	Ralf Baechle
@@ -3612,6 +4419,9 @@ M:	ralf@linux-mips.org
 L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
+F:	include/linux/rose.h
+F:	include/net/rose.h
+F:	net/rose/
 
 RTL818X WIRELESS DRIVER
 P:	Michael Wu
@@ -3622,12 +4432,14 @@ L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
 S:	Maintained
+F:	drivers/net/wireless/rtl818*
 
 S3 SAVAGE FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
+F:	drivers/video/savage/
 
 S390
 P:	Martin Schwidefsky
@@ -3638,6 +4450,7 @@ M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
+F:	arch/s390/
 
 S390 NETWORK DRIVERS
 P:	Ursula Braun
@@ -3648,6 +4461,7 @@ M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
+F:	drivers/s390/net/
 
 S390 ZFCP DRIVER
 P:	Christof Schmitt
@@ -3658,6 +4472,8 @@ M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
+F:	Documentation/s390/zfcpdump.txt
+F:	drivers/s390/scsi/zfcp_*
 
 S390 IUCV NETWORK LAYER
 P:	Ursula Braun
@@ -3666,6 +4482,9 @@ M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
+F:	drivers/s390/net/*iucv*
+F:	include/net/iucv/
+F:	net/iucv/
 
 S3C24XX SD/MMC Driver
 P:	Ben Dooks
@@ -3679,11 +4498,15 @@ P:	Michael Hunold
 M:	michael@mihu.de
 W:	http://www.mihu.de/linux/saa7146
 S:	Maintained
+F:	drivers/media/common/saa7146*
+F:	drivers/media/video/*7146*
+F:	include/media/*7146*
 
 SC1200 WDT DRIVER
 P:	Zwane Mwaikambo
 M:	zwane@arm.linux.org.uk
 S:	Maintained
+F:	drivers/watchdog/sc1200wdt.c
 
 SCHEDULER
 P:	Ingo Molnar
@@ -3692,6 +4515,8 @@ P:	Robert Love    [the preemptible kernel bits]
 M:	rml@tech9.net
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	kernel/sched*
+F:	include/linux/sched.h
 
 SCSI CDROM DRIVER
 P:	Jens Axboe
@@ -3699,6 +4524,7 @@ M:	axboe@kernel.dk
 L:	linux-scsi@vger.kernel.org
 W:	http://www.kernel.dk
 S:	Maintained
+F:	drivers/scsi/sr*
 
 SCSI SG DRIVER
 P:	Doug Gilbert
@@ -3706,6 +4532,8 @@ M:	dgilbert@interlog.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.torque.net/sg
 S:	Maintained
+F:	drivers/scsi/sg.c
+F:	include/scsi/sg.h
 
 SCSI SUBSYSTEM
 P:	James E.J. Bottomley
@@ -3715,12 +4543,16 @@ T:	git kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
 T:	git kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
 T:	git kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-pending-2.6.git
 S:	Maintained
+F:	drivers/scsi/
+F:	include/scsi/
 
 SCSI TAPE DRIVER
 P:	Kai Mäkisara
 M:	Kai.Makisara@kolumbus.fi
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	Documentation/scsi/st.txt
+F:	drivers/scsi/st*
 
 SCTP PROTOCOL
 P:	Vlad Yasevich
@@ -3730,33 +4562,48 @@ M:	sri@us.ibm.com
 L:	linux-sctp@vger.kernel.org
 W:	http://lksctp.sourceforge.net
 S:	Supported
+F:	Documentation/networking/sctp.txt
+F:	include/linux/sctp.h
+F:	include/net/sctp/
+F:	net/sctp/
 
 SCx200 CPU SUPPORT
 P:	Jim Cromie
 M:	jim.cromie@gmail.com
 S:	Odd Fixes
+F:	Documentation/i2c/busses/scx200_acb
+F:	arch/x86/kernel/scx200_32.c
+F:	drivers/watchdog/scx200_wdt.c
+F:	drivers/i2c/busses/scx200*
+F:	drivers/mtd/maps/scx200_docflash.c
+F:	include/linux/scx200.h
 
 SCx200 GPIO DRIVER
 P:	Jim Cromie
 M:	jim.cromie@gmail.com
 S:	Maintained
+F:	drivers/char/scx200_gpio.c
+F:	include/linux/scx200_gpio.h
 
 SCx200 HRT CLOCKSOURCE DRIVER
 P:	Jim Cromie
 M:	jim.cromie@gmail.com
 S:	Maintained
+F:	drivers/clocksource/scx200_hrt.c
 
 SDRICOH_CS MMC/SD HOST CONTROLLER INTERFACE DRIVER
 P:	Sascha Sommer
 M:	saschasommer@freenet.de
 L:	sdricohcs-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	drivers/mmc/host/sdricoh_cs.c
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) DRIVER
 P:	Pierre Ossman
 M:	drzeus-sdhci@drzeus.cx
 L:	sdhci-devel@list.drzeus.cx
 S:	Maintained
+F:	drivers/mmc/host/sdhci.*
 
 SECURITY CONTACT
 P:	Security Officers
@@ -3775,11 +4622,15 @@ L: 	selinux@tycho.nsa.gov (subscribers-only, general discussion)
 W:	http://selinuxproject.org
 T:	git kernel.org:pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
 S:	Supported
+F:	include/linux/selinux*
+F:	security/selinux/
 
 SENSABLE PHANTOM
 P:	Jiri Slaby
 M:	jirislaby@gmail.com
 S:	Maintained
+F:	drivers/misc/phantom.c
+F:	include/linux/phantom.h
 
 SERIAL ATA (SATA) SUBSYSTEM
 P:	Jeff Garzik
@@ -3787,6 +4638,7 @@ M:	jgarzik@pobox.com
 L:	linux-ide@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
 S:	Supported
+F:	drivers/ata/
 
 SFC NETWORK DRIVER
 P:	Steve Hodgson
@@ -3794,17 +4646,20 @@ P:	Ben Hutchings
 P:	Robert Stonehouse
 M:	linux-net-drivers@solarflare.com
 S:	Supported
+F:	drivers/net/sfc/
 
 SGI GRU DRIVER
 P:	Jack Steiner
 M:	steiner@sgi.com
 S:	Maintained
+F:	drivers/misc/sgi-gru/
 
 SGI SN-IA64 (Altix) SERIAL CONSOLE DRIVER
 P:	Pat Gefre
 M:	pfg@sgi.com
 L:	linux-ia64@vger.kernel.org
 S:	Supported
+F:	Documentation/ia64/serial.txt
 
 SGI VISUAL WORKSTATION 320 AND 540
 P:	Andrey Panin
@@ -3812,11 +4667,13 @@ M:	pazke@donpac.ru
 L:	linux-visws-devel@lists.sf.net
 W:	http://linux-visws.sf.net
 S:	Maintained for 2.6.
+F:	Documentation/sgi-visws.txt
 
 SGI XP/XPC/XPNET DRIVER
 P:	Dean Nelson
 M:	dcn@sgi.com
 S:	Maintained
+F:	drivers/misc/sgi-xp/
 
 SHARP LH SUPPORT (LH7952X & LH7A40X)
 P:	Marc Singer
@@ -3824,12 +4681,17 @@ M:	elf@buici.com
 W:	http://projects.buici.com/arm
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 S:	Maintained
+F:	Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen
+F:	arch/arm/mach-lh7a40x/
+F:	drivers/serial/serial_lh7a40x.c
+F:	drivers/*/*/*lh7a40*
 
 SHPC HOTPLUG DRIVER
 P:	Kristen Carlson Accardi
 M:	kristen.c.accardi@intel.com
 L:	linux-pci@vger.kernel.org
 S:	Supported
+F:	drivers/pci/hotplug/shpchp*
 
 SIMTEC EB110ATX (Chalice CATS)
 P:	Ben Dooks
@@ -3837,6 +4699,7 @@ P:	Vincent Sanders
 M:	support@simtec.co.uk
 W:	http://www.simtec.co.uk/products/EB110ATX/
 S:	Supported
+F:	arch/arm/mach-ebsa110/
 
 SIMTEC EB2410ITX (BAST)
 P:	Ben Dooks
@@ -3844,12 +4707,16 @@ P:	Vincent Sanders
 M:	support@simtec.co.uk
 W:	http://www.simtec.co.uk/products/EB2410ITX/
 S:	Supported
+F:	arch/arm/mach-s3c2410/
+F:	drivers/*/*s3c2410*
+F:	drivers/*/*/*s3c2410*
 
 SIS 190 ETHERNET DRIVER
 P:	Francois Romieu
 M:	romieu@fr.zoreil.com
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/sis190.c
 
 SIS 900/7016 FAST ETHERNET DRIVER
 P:	Daniele Venzano
@@ -3857,30 +4724,39 @@ M:	venza@brownhat.org
 W:	http://www.brownhat.org/sis900.html
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/sis900.*
 
 SIS 96X I2C/SMBUS DRIVER
 P:	Mark M. Hoffman
 M:	mhoffman@lightlink.com
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
+F:	Documentation/i2c/busses/i2c-sis96x
+F:	drivers/i2c/busses/i2c-sis96x.c
 
 SIS FRAMEBUFFER DRIVER
 P:	Thomas Winischhofer
 M:	thomas@winischhofer.net
 W:	http://www.winischhofer.net/linuxsisvga.shtml
 S:	Maintained
+F:	Documentation/fb/sisfb.txt
+F:	drivers/video/sis/
+F:	include/video/sisfb.h
 
 SIS USB2VGA DRIVER
 P:	Thomas Winischhofer
 M:	thomas@winischhofer.net
 W:	http://www.winischhofer.at/linuxsisusbvga.shtml
 S:	Maintained
+F:	drivers/usb/misc/sisusbvga/
 
 SKGE, SKY2 10/100/1000 GIGABIT ETHERNET DRIVERS
 P:	Stephen Hemminger
 M:	shemminger@linux-foundation.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/skge.*
+F:	drivers/net/sky2.*
 
 SLAB ALLOCATOR
 P:	Christoph Lameter
@@ -3891,22 +4767,28 @@ P:	Matt Mackall
 M:	mpm@selenic.com
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	include/linux/sl?b*.h
+F:	mm/sl?b.c
 
 SMC91x ETHERNET DRIVER
 P:	Nicolas Pitre
 M:	nico@cam.org
 S:	Maintained
+F:	drivers/net/smc91x.*
 
 SMSC47B397 HARDWARE MONITOR DRIVER
 P:	Mark M. Hoffman
 M:	mhoffman@lightlink.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/smsc47b397
+F:	drivers/hwmon/smsc47b397.c
 
 SMX UIO Interface
 P:	Ben Nizette
 M:	bn@niasdigital.com
 S:	Maintained
+F:	drivers/uio/uio_smx.c
 
 SN-IA64 (Itanium) SUB-PLATFORM
 P:	Jes Sorensen
@@ -3915,35 +4797,44 @@ L:	linux-altix@sgi.com
 L:	linux-ia64@vger.kernel.org
 W:	http://www.sgi.com/altix
 S:	Maintained
+F:	arch/ia64/sn/
 
 SOC-CAMERA V4L2 SUBSYSTEM
 P:	Guennadi Liakhovetski
 M:	g.liakhovetski@gmx.de
 L:	video4linux-list@redhat.com
 S:	Maintained
+F:	include/media/v4l2*
+F:	drivers/media/video/v4l2*
 
 SOEKRIS NET48XX LED SUPPORT
 P:	Chris Boot
 M:	bootc@bootc.net
 S:	Maintained
+F:	drivers/leds/leds-net48xx.c
 
 SOFTWARE RAID (Multiple Disks) SUPPORT
 P:	Neil Brown
 M:	neilb@suse.de
 L:	linux-raid@vger.kernel.org
 S:	Supported
+F:	drivers/md/
+F:	include/linux/raid/
 
 SONIC NETWORK DRIVER
 P:	Thomas Bogendoerfer
 M:	tsbogend@alpha.franken.de
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/sonic.*
 
 SONICS SILICON BACKPLANE DRIVER (SSB)
 P:	Michael Buesch
 M:	mb@bu3sch.de
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/ssb/
+F:	include/linux/ssb/
 
 SONY VAIO CONTROL DEVICE DRIVER
 P:	Mattia Dongili
@@ -3951,6 +4842,8 @@ M:	malattia@linux.it
 L:	linux-acpi@vger.kernel.org
 W:	http://www.linux.it/~malattia/wiki/index.php/Sony_drivers
 S:	Maintained
+F:	drivers/char/sonypi.c
+F:	drivers/misc/sony-laptop.c
 
 SONY MEMORYSTICK CARD SUPPORT
 P:	Alex Dubov
@@ -3958,6 +4851,7 @@ M:	oakad@yahoo.com
 L:	linux-kernel@vger.kernel.org
 W:	http://tifmxx.berlios.de/
 S:	Maintained
+F:	drivers/memstick/host/tifm_ms.c
 
 SOUND
 P:	Jaroslav Kysela
@@ -3966,6 +4860,7 @@ P:	Takashi Iwai
 M:	tiwai@suse.de
 L:	alsa-devel@alsa-project.org (subscribers-only)
 S:	Maintained
+F:	sound/
 
 SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEMENT
 P:	Liam Girdwood
@@ -3976,24 +4871,31 @@ T:	git opensource.wolfsonmicro.com/linux-2.6-asoc
 L:	alsa-devel@alsa-project.org (subscribers-only)
 W:	http://alsa-project.org/main/index.php/ASoC
 S:	Supported
+F:	sound/soc/
 
 SPARC (sparc32)
 P:	William L. Irwin
 M:	wli@holomorphy.com
 L:	sparclinux@vger.kernel.org
 S:	Maintained
+F:	arch/sparc/
 
 SPECIALIX IO8+ MULTIPORT SERIAL CARD DRIVER
 P:	Roger Wolff
 M:	R.E.Wolff@BitWizard.nl
 L:	linux-kernel@vger.kernel.org ?
 S:	Supported
+F:	Documentation/serial/specialix.txt
+F:	drivers/char/specialix*
 
 SPI SUBSYSTEM
 P:	David Brownell
 M:	dbrownell@users.sourceforge.net
 L:	spi-devel-general@lists.sourceforge.net
 S:	Maintained
+F:	Documentation/spi/
+F:	drivers/spi/
+F:	include/linux/spi/
 
 SPIDERNET NETWORK DRIVER for CELL
 P:	Ishizaki Kou
@@ -4002,6 +4904,8 @@ P:	Jens Osterkamp
 M:	jens@de.ibm.com
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	Documentation/networking/spider_net.txt
+F:	drivers/net/spider_net*
 
 SPU FILE SYSTEM
 P:	Jeremy Kerr
@@ -4010,12 +4914,15 @@ L:	linuxppc-dev@ozlabs.org
 L:	cbe-oss-dev@ozlabs.org
 W:	http://www.ibm.com/developerworks/power/cell/
 S:	Supported
+F:	Documentation/filesystems/spufs.txt
+F:	arch/powerpc/platforms/cell/spufs/
 
 SRM (Alpha) environment access
 P:	Jan-Benedict Glaw
 M:	jbglaw@lug-owl.de
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	arch/alpha/kernel/srm_env.c
 
 STABLE BRANCH
 P:	Greg Kroah-Hartman
@@ -4031,27 +4938,35 @@ M:	gregkh@suse.de
 L:	linux-kernel@vger.kernel.org
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 S:	Maintained
+F:	drivers/staging/
 
 STARFIRE/DURALAN NETWORK DRIVER
 P:	Ion Badulescu
 M:	ionut@cs.columbia.edu
 S:	Maintained
+F:	drivers/net/starfire*
 
 STARMODE RADIO IP (STRIP) PROTOCOL DRIVER
 W:	http://mosquitonet.Stanford.EDU/strip.html
 S:	Orphan
+F:	drivers/net/wireless/strip.c
+F:	include/linux/if_strip.h
 
 STRADIS MPEG-2 DECODER DRIVER
 P:	Nathan Laredo
 M:	laredo@gnu.org
 W:	http://www.stradis.com/
 S:	Maintained
+F:	drivers/media/video/stradis.c
 
 SUN3/3X
 P:	Sam Creasey
 M:	sammy@sammy.net
 W:	http://sammy.net/sun3/
 S:	Maintained
+F:	arch/m68k/kernel/*sun3*
+F:	arch/m68k/sun3*/
+F:	include/asm-m68k/sun3*
 
 SUPERH
 P:	Paul Mundt
@@ -4060,6 +4975,7 @@ L:	linux-sh@vger.kernel.org
 W:	http://www.linux-sh.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git
 S:	Supported
+F:	arch/sh/
 
 SUSPEND TO RAM
 P:	Len Brown
@@ -4070,29 +4986,48 @@ P:	Rafael J. Wysocki
 M:	rjw@sisk.pl
 L:	linux-pm@lists.linux-foundation.org
 S:	Supported
+F:	Documentation/power/
+F:	arch/x86/kernel/acpi/
+F:	drivers/base/power/
+F:	kernel/power/
+F:	include/linux/suspend.h
+F:	include/linux/freezer.h
+F:	include/linux/pm.h
+F:	include/asm-*/suspend.h
 
 SVGA HANDLING
 P:	Martin Mares
 M:	mj@ucw.cz
 L:	linux-video@atrey.karlin.mff.cuni.cz
 S:	Maintained
+F:	Documentation/svga.txt
+F:	arch/x86/boot/video*
 
 SYSV FILESYSTEM
 P:	Christoph Hellwig
 M:	hch@infradead.org
 S:	Maintained
+F:	Documentation/filesystems/sysv-fs.txt
+F:	fs/sysv/
+F:	include/linux/sysv_fs.h
 
 TASKSTATS STATISTICS INTERFACE
 P:	Balbir Singh
 M:	balbir@linux.vnet.ibm.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/accounting/taskstats*
+F:	include/linux/taskstats*
+F:	kernel/taskstats.c
 
 TC CLASSIFIER
 P:	Jamal Hadi Salim
 M:	hadi@cyberus.ca
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	include/linux/pkt_cls.h
+F:	include/net/pkt_cls.h
+F:	net/sched/
 
 TCP LOW PRIORITY MODULE
 P:	Wong Hoi Sing, Edison
@@ -4101,6 +5036,7 @@ P:	Hung Hing Lun, Mike
 M:	hlhung3i@gmail.com
 W:	http://tcp-lp-mod.sourceforge.net/
 S:	Maintained
+F:	net/ipv4/tcp_lp.c
 
 TEHUTI ETHERNET DRIVER
 P:	Alexander Indenbaum
@@ -4109,16 +5045,20 @@ P:	Andy Gospodarek
 M:	andy@greyhouse.net
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	drivers/net/tehuti*
 
 Telecom Clock Driver for MCPL0010
 P:	Mark Gross
 M:	mark.gross@intel.com
 S:	Supported
+F:	drivers/char/tlclk.c
 
 TENSILICA XTENSA PORT (xtensa)
 P:	Chris Zankel
 M:	chris@zankel.net
 S:	Maintained
+F:	arch/xtensa/
+F:	include/asm-xtensa/
 
 THINKPAD ACPI EXTRAS DRIVER
 P:	Henrique de Moraes Holschuh
@@ -4128,11 +5068,15 @@ W:	http://ibm-acpi.sourceforge.net
 W:	http://thinkwiki.org/wiki/Ibm-acpi
 T:	git repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git
 S:	Maintained
+F:	drivers/misc/thinkpad_acpi.c
 
 TI FLASH MEDIA INTERFACE DRIVER
 P:	Alex Dubov
 M:	oakad@yahoo.com
 S:	Maintained
+F:	drivers/misc/tifm*
+F:	drivers/mmc/host/tifm_sd.c
+F:	include/linux/tifm.h
 
 TI OMAP MMC INTERFACE DRIVER
 P:	Carlos Aguiar, Anderson Briglia and Syed Khasim
@@ -4145,6 +5089,7 @@ TI OMAP RANDOM NUMBER GENERATOR SUPPORT
 P:	Deepak Saxena
 M:	dsaxena@plexity.net
 S:	Maintained
+F:	drivers/char/hw_random/omap-rng.c
 
 TIPC NETWORK LAYER
 P:	Per Liden
@@ -4158,6 +5103,9 @@ W:	http://tipc.sourceforge.net/
 W:	http://tipc.cslab.ericsson.net/
 T:	git tipc.cslab.ericsson.net:/pub/git/tipc.git
 S:	Maintained
+F:	include/linux/tipc*.h
+F:	include/net/tipc/
+F:	net/tipc/
 
 TLAN NETWORK DRIVER
 P:	Samuel Chessman
@@ -4165,12 +5113,15 @@ M:	chessman@tux.org
 L:	tlan-devel@lists.sourceforge.net (subscribers-only)
 W:	http://sourceforge.net/projects/tlan/
 S:	Maintained
+F:	Documentation/networking/tlan.txt
+F:	drivers/net/tlan.*
 
 TOSHIBA ACPI EXTRAS DRIVER
 P:	John Belmonte
 M:	toshiba_acpi@memebeam.org
 W:	http://memebeam.org/toys/ToshibaAcpiDriver
 S:	Maintained
+F:	drivers/acpi/toshiba_acpi.c
 
 TOSHIBA SMM DRIVER
 P:	Jonathan Buzzard
@@ -4178,6 +5129,8 @@ M:	jonathan@buzzard.org.uk
 L:	tlinux-users@tce.toshiba-dme.co.jp
 W:	http://www.buzzard.org.uk/toshiba/
 S:	Maintained
+F:	drivers/char/toshiba.c
+F:	include/linux/toshiba.h
 
 TPM DEVICE DRIVER
 P:	Debora Velarde
@@ -4190,6 +5143,7 @@ M:	tpm@selhorst.net
 W:	http://www.prosec.rub.de/tpm/
 L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
+F:	drivers/char/tpm/
 
 TRIVIAL PATCHES
 P:	Jesper Juhl
@@ -4210,6 +5164,7 @@ P:	Kyle McMartin
 M:	kyle@mcmartin.ca
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/tulip/
 
 TUN/TAP driver
 P:	Maxim Krasnyansky
@@ -4217,17 +5172,22 @@ M:	maxk@qualcomm.com
 L:	vtun@office.satix.net
 W:	http://vtun.sourceforge.net/tun
 S:	Maintained
+F:	Documentation/networking/tuntap.txt
+F:	arch/um/os-Linux/drivers/
 
 TURBOCHANNEL SUBSYSTEM
 P:	Maciej W. Rozycki
 M:	macro@linux-mips.org
 S:	Maintained
+F:	drivers/tc/
+F:	include/linux/tc.h
 
 U14-34F SCSI DRIVER
 P:	Dario Ballabio
 M:	ballabio_dario@emc.com
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/u14-34f.c
 
 UBI FILE SYSTEM (UBIFS)
 P:	Artem Bityutskiy
@@ -4238,6 +5198,8 @@ L:	linux-mtd@lists.infradead.org
 T:	git git://git.infradead.org/~dedekind/ubifs-2.6.git
 W:	http://www.linux-mtd.infradead.org/doc/ubifs.html
 S:	Maintained
+F:	Documentation/filesystems/ubifs.txt
+F:	fs/ubifs/
 
 UCLINUX (AND M68KNOMMU)
 P:	Greg Ungerer
@@ -4245,6 +5207,7 @@ M:	gerg@uclinux.org
 W:	http://www.uclinux.org/
 L:	uclinux-dev@uclinux.org  (subscribers-only)
 S:	Maintained
+F:	arch/m68knommu/
 
 UCLINUX FOR RENESAS H8/300
 P:	Yoshinori Sato
@@ -4257,12 +5220,16 @@ P:	Jan Kara
 M:	jack@suse.cz
 W:	http://linux-udf.sourceforge.net
 S:	Maintained
+F:	Documentation/filesystems/udf.txt
+F:	fs/udf/
 
 UFS FILESYSTEM
 P:	Evgeniy Dushistov
 M:	dushistov@mail.ru
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/filesystems/ufs.txt
+F:	fs/ufs/
 
 UltraSPARC (sparc64)
 P:	David S. Miller
@@ -4270,12 +5237,16 @@ M:	davem@davemloft.net
 L:	sparclinux@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git
 S:	Maintained
+F:	arch/sparc64/
 
 ULTRA-WIDEBAND (UWB) SUBSYSTEM:
 P:	David Vrabel
 M:	david.vrabel@csr.com
 L:	linux-usb@vger.kernel.org
 S:	Supported
+F:	drivers/uwb/*
+F:	include/linux/uwb.h
+F:	include/linux/uwb/
 
 UNIFORM CDROM DRIVER
 P:	Jens Axboe
@@ -4283,6 +5254,9 @@ M:	axboe@kernel.dk
 L:	linux-kernel@vger.kernel.org
 W:	http://www.kernel.dk
 S:	Maintained
+F:	Documentation/cdrom/
+F:	drivers/cdrom/cdrom.c
+F:	include/linux/cdrom.h
 
 UNSORTED BLOCK IMAGES (UBI)
 P:	Artem Bityutskiy
@@ -4291,12 +5265,17 @@ W:	http://www.linux-mtd.infradead.org/
 L:	linux-mtd@lists.infradead.org
 T:	git git://git.infradead.org/~dedekind/ubi-2.6.git
 S:	Maintained
+F:	drivers/mtd/ubi
+F:	include/linux/mtd/ubi.h
+F:	include/mtd/ubi-user.h
 
 USB ACM DRIVER
 P:	Oliver Neukum
 M:	oliver@neukum.name
 L:	linux-usb@vger.kernel.org
 S:	Maintained
+F:	Documentation/usb/acm.txt
+F:	drivers/usb/class/cdc-acm.*
 
 USB BLOCK DRIVER (UB ub)
 P:	Pete Zaitcev
@@ -4304,6 +5283,7 @@ M:	zaitcev@redhat.com
 L:	linux-kernel@vger.kernel.org
 L:	linux-usb@vger.kernel.org
 S:	Supported
+F:	drivers/block/ub.c
 
 USB CDC ETHERNET DRIVER
 P:	Greg Kroah-Hartman
@@ -4311,12 +5291,15 @@ M:	greg@kroah.com
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 W:	http://www.kroah.com/linux-usb/
+F:	drivers/net/usb/cdc_*.c
+F:	include/linux/usb/cdc.h
 
 USB CYPRESS C67X00 DRIVER
 P:	Peter Korsgaard
 M:	jacmet@sunsite.dk
 L:	linux-usb@vger.kernel.org
 S:	Maintained
+F:	drivers/usb/c67x00/
 
 USB DAVICOM DM9601 DRIVER
 P:	Peter Korsgaard
@@ -4324,6 +5307,7 @@ M:	jacmet@sunsite.dk
 L:	netdev@vger.kernel.org
 W:	http://www.linux-usb.org/usbnet
 S:	Maintained
+F:	drivers/net/usb/dm9601.c
 
 USB DIAMOND RIO500 DRIVER
 P:	Cesar Miquel
@@ -4331,12 +5315,15 @@ M:	miquel@df.uba.ar
 L:	rio500-users@lists.sourceforge.net
 W:	http://rio500.sourceforge.net
 S:	Maintained
+F:	drivers/usb/misc/rio500*
 
 USB EHCI DRIVER
 P:	David Brownell
 M:	dbrownell@users.sourceforge.net
 L:	linux-usb@vger.kernel.org
 S:	Odd Fixes
+F:	Documentation/usb/ehci.txt
+F:	drivers/usb/host/ehci*
 
 USB ET61X[12]51 DRIVER
 P:	Luca Risolia
@@ -4345,6 +5332,7 @@ L:	linux-usb@vger.kernel.org
 L:	video4linux-list@redhat.com
 W:	http://www.linux-projects.org
 S:	Maintained
+F:	drivers/media/video/et61x251/
 
 USB GADGET/PERIPHERAL SUBSYSTEM
 P:	David Brownell
@@ -4352,6 +5340,8 @@ M:	dbrownell@users.sourceforge.net
 L:	linux-usb@vger.kernel.org
 W:	http://www.linux-usb.org/gadget
 S:	Maintained
+F:	drivers/usb/gadget/
+F:	include/linux/usb/gadget*
 
 USB HID/HIDBP DRIVERS (USB KEYBOARDS, MICE, REMOTE CONTROLS, ...)
 P:	Jiri Kosina
@@ -4359,18 +5349,23 @@ M:	jkosina@suse.cz
 L:	linux-usb@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
+F:	Documentation/usb/hiddev.txt
+F:	drivers/hid/usbhid/
 
 USB ISP116X DRIVER
 P:	Olav Kongas
 M:	ok@artecdesign.ee
 L:	linux-usb@vger.kernel.org
 S:	Maintained
+F:	drivers/usb/host/isp116x*
+F:	include/linux/usb/isp116x.h
 
 USB KAWASAKI LSI DRIVER
 P:	Oliver Neukum
 M:	oliver@neukum.name
 L:	linux-usb@vger.kernel.org
 S:	Maintained
+F:	drivers/usb/serial/kl5kusb105.*
 
 USB MASS STORAGE DRIVER
 P:	Matthew Dharm
@@ -4379,18 +5374,22 @@ L:	linux-usb@vger.kernel.org
 L:	usb-storage@lists.one-eyed-alien.net
 S:	Maintained
 W:	http://www.one-eyed-alien.net/~mdharm/linux-usb/
+F:	drivers/usb/storage/
 
 USB OHCI DRIVER
 P:	David Brownell
 M:	dbrownell@users.sourceforge.net
 L:	linux-usb@vger.kernel.org
 S:	Odd Fixes
+F:	Documentation/usb/ohci.txt
+F:	drivers/usb/host/ohci*
 
 USB OPTION-CARD DRIVER
 P:	Matthias Urlichs
 M:	smurf@smurf.noris.de
 L:	linux-usb@vger.kernel.org
 S:	Maintained
+F:	drivers/usb/serial/option.c
 
 USB OV511 DRIVER
 P:	Mark McClelland
@@ -4398,6 +5397,7 @@ M:	mmcclell@bigfoot.com
 L:	linux-usb@vger.kernel.org
 W:	http://alpha.dyndns.org/ov511/
 S:	Maintained
+F:	drivers/media/video/ov511.*
 
 USB PEGASUS DRIVER
 P:	Petko Manolov
@@ -4406,12 +5406,14 @@ L:	linux-usb@vger.kernel.org
 L:	netdev@vger.kernel.org
 W:	http://pegasus2.sourceforge.net/
 S:	Maintained
+F:	drivers/net/usb/pegasus.*
 
 USB PRINTER DRIVER (usblp)
 P:	Pete Zaitcev
 M:	zaitcev@redhat.com
 L:	linux-usb@vger.kernel.org
 S:	Supported
+F:	drivers/usb/class/usblp.c
 
 USB RTL8150 DRIVER
 P:	Petko Manolov
@@ -4420,6 +5422,7 @@ L:	linux-usb@vger.kernel.org
 L:	netdev@vger.kernel.org
 W:	http://pegasus2.sourceforge.net/
 S:	Maintained
+F:	drivers/net/usb/rtl8150.c
 
 USB SE401 DRIVER
 P:	Jeroen Vreeken
@@ -4433,6 +5436,7 @@ P:	William Greathouse
 M:	wgreathouse@smva.com
 L:	linux-usb@vger.kernel.org
 S:	Maintained
+F:	drivers/usb/serial/belkin_sa.*
 
 USB SERIAL CYPRESS M8 DRIVER
 P:	Lonnie Mendez
@@ -4441,12 +5445,14 @@ L:	linux-usb@vger.kernel.org
 S:	Maintained
 W:	http://geocities.com/i0xox0i
 W:	http://firstlight.net/cvs
+F:	drivers/usb/serial/cypress_m8.*
 
 USB SERIAL CYBERJACK DRIVER
 P:	Matthias Bruestle and Harald Welte
 M:	support@reiner-sct.com
 W:	http://www.reiner-sct.de/support/treiber_cyberjack.php
 S:	Maintained
+F:	drivers/usb/serial/cyberjack.c
 
 USB SERIAL DIGI ACCELEPORT DRIVER
 P:	Peter Berger and Al Borchers
@@ -4454,18 +5460,24 @@ M:	pberger@brimson.com
 M:	alborchers@steinerpoint.com
 L:	linux-usb@vger.kernel.org
 S:	Maintained
+F:	drivers/usb/serial/digi_acceleport.c
 
 USB SERIAL DRIVER
 P:	Greg Kroah-Hartman
 M:	gregkh@suse.de
 L:	linux-usb@vger.kernel.org
 S:	Supported
+F:	Documentation/usb/usb-serial.txt
+F:	drivers/usb/serial/generic.c
+F:	drivers/usb/serial/usb-serial.c
+F:	include/linux/usb/serial.h
 
 USB SERIAL EMPEG EMPEG-CAR MARK I/II DRIVER
 P:	Gary Brubaker
 M:	xavyer@ix.netcom.com
 L:	linux-usb@vger.kernel.org
 S:	Maintained
+F:	drivers/usb/serial/empeg.c
 
 USB SERIAL KEYSPAN DRIVER
 P:	Greg Kroah-Hartman
@@ -4473,6 +5485,7 @@ M:	greg@kroah.com
 L:	linux-usb@vger.kernel.org
 W:	http://www.kroah.com/linux/
 S:	Maintained
+F:	drivers/usb/serial/*keyspan*
 
 USB SERIAL WHITEHEAT DRIVER
 P:	Support Department
@@ -4480,12 +5493,14 @@ M:	support@connecttech.com
 L:	linux-usb@vger.kernel.org
 W:	http://www.connecttech.com
 S:	Supported
+F:	drivers/usb/serial/whiteheat*
 
 USB SMSC95XX ETHERNET DRIVER
 P:	Steve Glendinning
 M:	steve.glendinning@smsc.com
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	drivers/net/usb/smsc95xx.*
 
 USB SN9C1xx DRIVER
 P:	Luca Risolia
@@ -4494,6 +5509,8 @@ L:	linux-usb@vger.kernel.org
 L:	video4linux-list@redhat.com
 W:	http://www.linux-projects.org
 S:	Maintained
+F:	Documentation/video4linux/sn9c102.txt
+F:	drivers/media/video/sn9c102/
 
 USB SUBSYSTEM
 P:	Greg Kroah-Hartman
@@ -4502,12 +5519,18 @@ L:	linux-usb@vger.kernel.org
 W:	http://www.linux-usb.org
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 S:	Supported
+F:	Documentation/usb/
+F:	drivers/net/usb/
+F:	drivers/usb/
+F:	include/linux/usb.h
+F:	include/linux/usb/
 
 USB UHCI DRIVER
 P:	Alan Stern
 M:	stern@rowland.harvard.edu
 L:	linux-usb@vger.kernel.org
 S:	Maintained
+F:	drivers/usb/host/uhci*
 
 USB "USBNET" DRIVER FRAMEWORK
 P:	David Brownell
@@ -4515,6 +5538,8 @@ M:	dbrownell@users.sourceforge.net
 L:	netdev@vger.kernel.org
 W:	http://www.linux-usb.org/usbnet
 S:	Maintained
+F:	drivers/net/usb/usbnet.c
+F:	include/linux/usb/usbnet.h
 
 USB VIDEO CLASS
 P:	Laurent Pinchart
@@ -4531,12 +5556,15 @@ L:	linux-usb@vger.kernel.org
 L:	video4linux-list@redhat.com
 W:	http://www.linux-projects.org
 S:	Maintained
+F:	Documentation/video4linux/w9968cf.txt
+F:	drivers/media/video/w996*
 
 USB WIRELESS RNDIS DRIVER (rndis_wlan)
 P:	Jussi Kivilinna
 M:	jussi.kivilinna@mbnet.fi
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
+F:	drivers/net/wireless/rndis_wlan.c
 
 USB ZC0301 DRIVER
 P:	Luca Risolia
@@ -4545,6 +5573,8 @@ L:	linux-usb@vger.kernel.org
 L:	video4linux-list@redhat.com
 W:	http://www.linux-projects.org
 S:	Maintained
+F:	Documentation/video4linux/zc0301.txt
+F:	drivers/media/video/zc0301/
 
 USB ZD1201 DRIVER
 P:	Jeroen Vreeken
@@ -4552,6 +5582,7 @@ M:	pe1rxq@amsat.org
 L:	linux-usb@vger.kernel.org
 W:	http://linux-lc100020.sourceforge.net
 S:	Maintained
+F:	drivers/net/wireless/zd1201.*
 
 USB ZR364XX DRIVER
 P:	Antoine Jacquet
@@ -4560,6 +5591,8 @@ L:	linux-usb@vger.kernel.org
 L:	video4linux-list@redhat.com
 W:	http://royale.zerezo.com/zr364xx/
 S:	Maintained
+F:	Documentation/video4linux/zr364xx.txt
+F:	drivers/media/video/zr364xx.c
 
 USER-MODE LINUX (UML)
 P:	Jeff Dike
@@ -4568,6 +5601,10 @@ L:	user-mode-linux-devel@lists.sourceforge.net
 L:	user-mode-linux-user@lists.sourceforge.net
 W:	http://user-mode-linux.sourceforge.net
 S:	Maintained
+F:	Documentation/uml/
+F:	arch/um/
+F:	fs/hostfs/
+F:	fs/hppfs/
 
 USERSPACE I/O (UIO)
 P:	Hans J. Koch
@@ -4576,6 +5613,9 @@ P:	Greg Kroah-Hartman
 M:	gregkh@suse.de
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/DocBook/uio-howto.tmpl
+F:	drivers/uio/
+F:	include/linux/uio*.h
 
 UTIL-LINUX-NG PACKAGE
 P:	Karel Zak
@@ -4591,23 +5631,33 @@ M:	spock@gentoo.org
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://dev.gentoo.org/~spock/projects/uvesafb/
 S:	Maintained
+F:	Documentation/fb/uvesafb.txt
+F:	drivers/video/uvesafb.c
+F:	include/video/uvesafb.h
 
 VFAT/FAT/MSDOS FILESYSTEM
 P:	OGAWA Hirofumi
 M:	hirofumi@mail.parknet.co.jp
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/filesystems/vfat.txt
+F:	fs/fat/
+F:	fs/msdos/
+F:	fs/vfat/
 
 VIA RHINE NETWORK DRIVER
 P:	Roger Luethi
 M:	rl@hellgate.ch
 S:	Maintained
+F:	drivers/net/via-rhine.c
 
 VIAPRO SMBUS DRIVER
 P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
+F:	Documentation/i2c/busses/i2c-viapro
+F:	drivers/i2c/busses/i2c-viapro.c
 
 VIA UNICHROME(PRO)/CHROME9 FRAMEBUFFER DRIVER
 P:	Joseph Chan
@@ -4622,6 +5672,7 @@ P:	Francois Romieu
 M:	romieu@fr.zoreil.com
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/via-velocity.*
 
 VIDEO FOR LINUX (V4L)
 P:	Mauro Carvalho Chehab
@@ -4631,12 +5682,22 @@ L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
+F:	Documentation/video4linux/
+F:	drivers/media/video/
+F:	drivers/media/radio/
+F:	include/linux/video_decoder.h
+F:	include/linux/videodev.h
+F:	include/linux/videodev2.h
+F:	include/media/
 
 VLAN (802.1Q)
 P:	Patrick McHardy
 M:	kaber@trash.net
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/macvlan.c
+F:	include/linux/if_*vlan.h
+F:	net/8021q/
 
 VOLTAGE AND CURRENT REGULATOR FRAMEWORK
 P:	Liam Girdwood
@@ -4647,47 +5708,62 @@ W:	http://opensource.wolfsonmicro.com/node/15
 W:	http://www.slimlogic.co.uk/?page_id=5
 T:	git kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git
 S:	Supported
+F:	drivers/regulator/
+F:	include/linux/regulator/
 
 VT1211 HARDWARE MONITOR DRIVER
 P:	Juerg Haefliger
 M:	juergh@gmail.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/vt1211
+F:	drivers/hwmon/vt1211.c
 
 VT8231 HARDWARE MONITOR DRIVER
 P:	Roger Lucas
 M:	vt8231@hiddenengine.co.uk
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	drivers/hwmon/vt8231.c
 
 W1 DALLAS'S 1-WIRE BUS
 P:	Evgeniy Polyakov
 M:	johnpol@2ka.mipt.ru
 S:	Maintained
+F:	Documentation/w1/
+F:	drivers/w1/
 
 W83791D HARDWARE MONITORING DRIVER
 P:	Marc Hulsman
 M:	m.hulsman@tudelft.nl
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/w83791d
+F:	drivers/hwmon/w83791d.c
 
 W83793 HARDWARE MONITORING DRIVER
 P:	Rudolf Marek
 M:	r.marek@assembler.cz
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/w83793
+F:	drivers/hwmon/w83793.c
 
 W83L51xD SD/MMC CARD INTERFACE DRIVER
 P:	Pierre Ossman
 M:	drzeus-wbsd@drzeus.cx
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/mmc/host/wbsd.*
 
 WATCHDOG DEVICE DRIVERS
 P:	Wim Van Sebroeck
 M:	wim@iguana.be
 T:	git kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
 S:	Maintained
+F:	Documentation/watchdog/
+F:	drivers/watchdog/
+F:	include/linux/watchdog.h
 
 WAVELAN NETWORK DRIVER & WIRELESS EXTENSIONS
 P:	Jean Tourrilhes
@@ -4695,22 +5771,28 @@ M:	jt@hpl.hp.com
 L:	linux-wireless@vger.kernel.org
 W:	http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/
 S:	Maintained
+F:	Documentation/networking/wavelan.txt
+F:	drivers/net/wireless/wavelan*
 
 WD7000 SCSI DRIVER
 P:	Miroslav Zagorac
 M:	zaga@fly.cc.fer.hr
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/wd7000.c
 
 WIMEDIA LLC PROTOCOL (WLP) SUBSYSTEM
 P:	David Vrabel
 M:	david.vrabel@csr.com
 S:	Maintained
+F:	include/linux/wlp.h
+F:	drivers/uwb/wlp/
 
 WISTRON LAPTOP BUTTON DRIVER
 P:	Miloslav Trmac
 M:	mitr@volny.cz
 S:	Maintained
+F:	drivers/input/misc/wistron_btns.c
 
 WL3501 WIRELESS PCMCIA CARD DRIVER
 P:	Arnaldo Carvalho de Melo
@@ -4718,6 +5800,7 @@ M:	acme@ghostprotocols.net
 L:	linux-wireless@vger.kernel.org
 W:	http://oops.ghostprotocols.net:81/blog
 S:	Maintained
+F:	drivers/net/wireless/wl3501*
 
 WM97XX TOUCHSCREEN DRIVERS
 P:	Mark Brown
@@ -4734,6 +5817,9 @@ P:	Henner Eisen
 M:	eis@baty.hanse.de
 L:	linux-x25@vger.kernel.org
 S:	Maintained
+F:	Documentation/networking/x25*
+F:	include/net/x25*
+F:	net/x25/
 
 X86 ARCHITECTURE (32-BIT AND 64-BIT)
 P:	Thomas Gleixner
@@ -4745,6 +5831,8 @@ M:	hpa@zytor.com
 L:	linux-kernel@vger.kernel.org
 T:	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
 S:	Maintained
+F:	Documentation/x86/
+F:	arch/x86/
 
 XEN HYPERVISOR INTERFACE
 P:	Jeremy Fitzhardinge
@@ -4754,6 +5842,11 @@ M:	chrisw@sous-sol.org
 L:	virtualization@lists.osdl.org
 L:	xen-devel@lists.xensource.com
 S:	Supported
+F:	arch/x86/xen/
+F:	drivers/*/xen-*front.c
+F:	drivers/xen/
+F:	arch/x86/include/asm/xen/
+F:	include/xen/
 
 XFS FILESYSTEM
 P:	Silicon Graphics Inc
@@ -4763,6 +5856,8 @@ L:	xfs@oss.sgi.com
 W:	http://oss.sgi.com/projects/xfs
 T:	git git://oss.sgi.com:8090/xfs/xfs-2.6.git
 S:	Supported
+F:	Documentation/filesystems/xfs.txt
+F:	fs/xfs/
 
 XILINX SYSTEMACE DRIVER
 P:	Grant Likely
@@ -4770,24 +5865,30 @@ M:	grant.likely@secretlab.ca
 W:	http://www.secretlab.ca/
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/block/xsysace.c
 
 XILINX UARTLITE SERIAL DRIVER
 P:	Peter Korsgaard
 M:	jacmet@sunsite.dk
 L:	linux-serial@vger.kernel.org
 S:	Maintained
+F:	drivers/serial/uartlite.c
 
 YAM DRIVER FOR AX.25
 P:	Jean-Paul Roubelat
 M:	jpr@f6fbb.org
 L:	linux-hams@vger.kernel.org
 S:	Maintained
+F:	drivers/net/hamradio/yam*
+F:	include/linux/yam.h
 
 YEALINK PHONE DRIVER
 P:	Henk Vergonet
 M:	Henk.Vergonet@gmail.com
 L:	usbb2k-api-dev@nongnu.org
 S:	Maintained
+F:	Documentation/input/yealink.txt
+F:	drivers/input/misc/yealink.*
 
 Z8530 DRIVER FOR AX.25
 P:	Joerg Reuter
@@ -4796,6 +5897,9 @@ W:	http://yaina.de/jreuter/
 W:	http://www.qsl.net/dl1bke/
 L:	linux-hams@vger.kernel.org
 S:	Maintained
+F:	Documentation/networking/z8530drv.txt
+F:	drivers/net/hamradio/*scc.c
+F:	drivers/net/hamradio/z8530.h
 
 ZD1211RW WIRELESS DRIVER
 P:	Daniel Drake
@@ -4806,6 +5910,7 @@ W:	http://zd1211.ath.cx/wiki/DriverRewrite
 L:	linux-wireless@vger.kernel.org
 L:	zd1211-devs@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	drivers/net/wireless/zd1211rw/
 
 ZR36067 VIDEO FOR LINUX DRIVER
 P:	Ronald Bultje
@@ -4813,11 +5918,13 @@ M:	rbultje@ronald.bitfreak.net
 L:	mjpeg-users@lists.sourceforge.net
 W:	http://mjpeg.sourceforge.net/driver-zoran/
 S:	Maintained
+F:	drivers/media/video/zoran/
 
 ZS DECSTATION Z85C30 SERIAL DRIVER
 P:	Maciej W. Rozycki
 M:	macro@linux-mips.org
 S:	Maintained
+F:	drivers/serial/zs.*
 
 THE REST
 P:	Linus Torvalds
-- 
1.6.0.2

