Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZJ0HfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZJ0HfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755620AbZJ0HfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:35:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59070 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985AbZJ0HfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:35:05 -0400
Date: Tue, 27 Oct 2009 18:35:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>,
       Johannes Berg <johannes@sipsolutions.net>,
       Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: linux-next: manual merge of the staging tree with the net/wireless
 tree
Message-Id: <20091027183503.5c398311.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging tree got conflicts in
drivers/net/wireless/Kconfig between commits
3d23e349d807177eaf519d444677cee86b1a04cf ("wext: refactor") and
0465af8e03bdc6cd0b49dc5548671387a8674b69 ("libertas: separate libertas'
Kconfig in it's own file") from the net/wireless tree and various commits
("... move driver to staging") from the staging tree.

I fixed it up (see below) and added a merge fixup (see further below) and
can carry these as necessary (though it may be easier for everyone (i.e.
me :-)) if these 4 staging tree commits are moved to the wireless
tree ...).
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/Kconfig
index 85f8bf4,18cadf0..0000000
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@@ -5,132 -5,20 +5,23 @@@
  menuconfig WLAN
  	bool "Wireless LAN"
  	depends on !S390
 +	select WIRELESS
  	default y
  	---help---
- 	  This section contains all the pre 802.11 and 802.11 wireless
- 	  device drivers. For a complete list of drivers and documentation
+ 	  This section contains all the 802.11 wireless LAN device
+ 	  drivers. For a complete list of drivers and documentation
  	  on them refer to the wireless wiki:
  
  	  http://wireless.kernel.org/en/users/Drivers
  
  if WLAN
  
- menuconfig WLAN_PRE80211
- 	bool "Wireless LAN (pre-802.11)"
- 	depends on NETDEVICES
- 	---help---
- 	  Say Y if you have any pre-802.11 wireless LAN hardware.
- 
- 	  This option does not affect the kernel build, it only
- 	  lets you choose drivers.
- 
- config STRIP
- 	tristate "STRIP (Metricom starmode radio IP)"
- 	depends on INET && WLAN_PRE80211
- 	select WIRELESS_EXT
- 	---help---
- 	  Say Y if you have a Metricom radio and intend to use Starmode Radio
- 	  IP. STRIP is a radio protocol developed for the MosquitoNet project
- 	  to send Internet traffic using Metricom radios.  Metricom radios are
- 	  small, battery powered, 100kbit/sec packet radio transceivers, about
- 	  the size and weight of a cellular telephone. (You may also have heard
- 	  them called "Metricom modems" but we avoid the term "modem" because
- 	  it misleads many people into thinking that you can plug a Metricom
- 	  modem into a phone line and use it as a modem.)
- 
- 	  You can use STRIP on any Linux machine with a serial port, although
- 	  it is obviously most useful for people with laptop computers. If you
- 	  think you might get a Metricom radio in the future, there is no harm
- 	  in saying Y to STRIP now, except that it makes the kernel a bit
- 	  bigger.
- 
- 	  To compile this as a module, choose M here: the module will be
- 	  called strip.
- 
- config ARLAN
- 	tristate "Aironet Arlan 655 & IC2200 DS support"
- 	depends on ISA && !64BIT && WLAN_PRE80211
- 	select WIRELESS_EXT
- 	---help---
- 	  Aironet makes Arlan, a class of wireless LAN adapters. These use the
- 	  www.Telxon.com chip, which is also used on several similar cards.
- 	  This driver is tested on the 655 and IC2200 series cards. Look at
- 	  <http://www.ylenurme.ee/~elmer/655/> for the latest information.
- 
- 	  The driver is built as two modules, arlan and arlan-proc. The latter
- 	  is the /proc interface and is not needed most of time.
- 
- 	  On some computers the card ends up in non-valid state after some
- 	  time. Use a ping-reset script to clear it.
- 
- config WAVELAN
- 	tristate "AT&T/Lucent old WaveLAN & DEC RoamAbout DS ISA support"
- 	depends on ISA && WLAN_PRE80211
- 	select WIRELESS_EXT
- 	select WEXT_SPY
- 	select WEXT_PRIV
- 	---help---
- 	  The Lucent WaveLAN (formerly NCR and AT&T; or DEC RoamAbout DS) is
- 	  a Radio LAN (wireless Ethernet-like Local Area Network) using the
- 	  radio frequencies 900 MHz and 2.4 GHz.
- 
- 	  If you want to use an ISA WaveLAN card under Linux, say Y and read
- 	  the Ethernet-HOWTO, available from
- 	  <http://www.tldp.org/docs.html#howto>. Some more specific
- 	  information is contained in
- 	  <file:Documentation/networking/wavelan.txt> and in the source code
- 	  <file:drivers/net/wireless/wavelan.p.h>.
- 
- 	  You will also need the wireless tools package available from
- 	  <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
- 	  Please read the man pages contained therein.
- 
- 	  To compile this driver as a module, choose M here: the module will be
- 	  called wavelan.
- 
- config PCMCIA_WAVELAN
- 	tristate "AT&T/Lucent old WaveLAN Pcmcia wireless support"
- 	depends on PCMCIA && WLAN_PRE80211
- 	select WIRELESS_EXT
- 	select WEXT_SPY
- 	select WEXT_PRIV
- 	help
- 	  Say Y here if you intend to attach an AT&T/Lucent Wavelan PCMCIA
- 	  (PC-card) wireless Ethernet networking card to your computer.  This
- 	  driver is for the non-IEEE-802.11 Wavelan cards.
- 
- 	  To compile this driver as a module, choose M here: the module will be
- 	  called wavelan_cs.  If unsure, say N.
- 
- config PCMCIA_NETWAVE
- 	tristate "Xircom Netwave AirSurfer Pcmcia wireless support"
- 	depends on PCMCIA && WLAN_PRE80211
- 	select WIRELESS_EXT
- 	select WEXT_PRIV
- 	help
- 	  Say Y here if you intend to attach this type of PCMCIA (PC-card)
- 	  wireless Ethernet networking card to your computer.
- 
- 	  To compile this driver as a module, choose M here: the module will be
- 	  called netwave_cs.  If unsure, say N.
- 
- 
- menuconfig WLAN_80211
- 	bool "Wireless LAN (IEEE 802.11)"
- 	depends on NETDEVICES
- 	---help---
- 	  Say Y if you have any 802.11 wireless LAN hardware.
- 
- 	  This option does not affect the kernel build, it only
- 	  lets you choose drivers.
- 
  config PCMCIA_RAYCS
  	tristate "Aviator/Raytheon 2.4GHz wireless support"
- 	depends on PCMCIA && WLAN_80211
+ 	depends on PCMCIA
  	select WIRELESS_EXT
 +	select WEXT_SPY
 +	select WEXT_PRIV
  	---help---
  	  Say Y here if you intend to attach an Aviator/Raytheon PCMCIA
  	  (PC-card) wireless Ethernet networking card to your computer.
@@@ -140,9 -28,48 +31,9 @@@
  	  To compile this driver as a module, choose M here: the module will be
  	  called ray_cs.  If unsure, say N.
  
 -config LIBERTAS
 -	tristate "Marvell 8xxx Libertas WLAN driver support"
 -	select WIRELESS_EXT
 -	select LIB80211
 -	select FW_LOADER
 -	---help---
 -	  A library for Marvell Libertas 8xxx devices.
 -
 -config LIBERTAS_USB
 -	tristate "Marvell Libertas 8388 USB 802.11b/g cards"
 -	depends on LIBERTAS && USB
 -	---help---
 -	  A driver for Marvell Libertas 8388 USB devices.
 -
 -config LIBERTAS_CS
 -	tristate "Marvell Libertas 8385 CompactFlash 802.11b/g cards"
 -	depends on LIBERTAS && PCMCIA
 -	select FW_LOADER
 -	---help---
 -	  A driver for Marvell Libertas 8385 CompactFlash devices.
 -
 -config LIBERTAS_SDIO
 -	tristate "Marvell Libertas 8385/8686/8688 SDIO 802.11b/g cards"
 -	depends on LIBERTAS && MMC
 -	---help---
 -	  A driver for Marvell Libertas 8385/8686/8688 SDIO devices.
 -
 -config LIBERTAS_SPI
 -	tristate "Marvell Libertas 8686 SPI 802.11b/g cards"
 -	depends on LIBERTAS && SPI
 -	---help---
 -	  A driver for Marvell Libertas 8686 SPI devices.
 -
 -config LIBERTAS_DEBUG
 -	bool "Enable full debugging output in the Libertas module."
 -	depends on LIBERTAS
 -	---help---
 -	  Debugging support.
 -
  config LIBERTAS_THINFIRM
  	tristate "Marvell 8xxx Libertas WLAN driver support with thin firmware"
- 	depends on WLAN_80211 && MAC80211
+ 	depends on MAC80211
  	select FW_LOADER
  	---help---
  	  A library for Marvell Libertas 8xxx devices using thinfirm.
@@@ -155,11 -82,9 +46,11 @@@ config LIBERTAS_THINFIRM_US
  
  config AIRO
  	tristate "Cisco/Aironet 34X/35X/4500/4800 ISA and PCI cards"
- 	depends on ISA_DMA_API && WLAN_80211 && (PCI || BROKEN)
+ 	depends on ISA_DMA_API && (PCI || BROKEN)
  	select WIRELESS_EXT
  	select CRYPTO
 +	select WEXT_SPY
 +	select WEXT_PRIV
  	---help---
  	  This is the standard Linux driver to support Cisco/Aironet ISA and
  	  PCI 802.11 wireless cards.
@@@ -175,9 -100,8 +66,9 @@@
  
  config ATMEL
        tristate "Atmel at76c50x chipset  802.11b support"
-       depends on (PCI || PCMCIA) && WLAN_80211
+       depends on (PCI || PCMCIA)
        select WIRELESS_EXT
 +      select WEXT_PRIV
        select FW_LOADER
        select CRC32
         ---help---
@@@ -237,21 -161,18 +128,21 @@@ config AIRO_C
  	  Cisco Linux utilities can be used to configure the card.
  
  config PCMCIA_WL3501
 -      tristate "Planet WL3501 PCMCIA cards"
 -      depends on EXPERIMENTAL && PCMCIA
 -      select WIRELESS_EXT
 -       ---help---
 -         A driver for WL3501 PCMCIA 802.11 wireless cards made by Planet.
 -	 It has basic support for Linux wireless extensions and initial
 -	 micro support for ethtool.
 +	tristate "Planet WL3501 PCMCIA cards"
- 	depends on EXPERIMENTAL && PCMCIA && WLAN_80211
++	depends on EXPERIMENTAL && PCMCIA
 +	select WIRELESS_EXT
 +	select WEXT_SPY
 +	help
 +	  A driver for WL3501 PCMCIA 802.11 wireless cards made by Planet.
 +	  It has basic support for Linux wireless extensions and initial
 +	  micro support for ethtool.
  
  config PRISM54
  	tristate 'Intersil Prism GT/Duette/Indigo PCI/Cardbus (DEPRECATED)'
- 	depends on PCI && EXPERIMENTAL && WLAN_80211
+ 	depends on PCI && EXPERIMENTAL
  	select WIRELESS_EXT
 +	select WEXT_SPY
 +	select WEXT_PRIV
  	select FW_LOADER
  	---help---
  	  This enables support for FullMAC PCI/Cardbus prism54 devices. This
@@@ -272,9 -193,8 +163,9 @@@
  
  config USB_ZD1201
  	tristate "USB ZD1201 based Wireless device support"
- 	depends on USB && WLAN_80211
+ 	depends on USB
  	select WIRELESS_EXT
 +	select WEXT_PRIV
  	select FW_LOADER
  	---help---
  	  Say Y if you want to use wireless LAN adapters based on the ZyDAS


-------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 27 Oct 2009 18:29:04 +1100
Subject: [PATCH] staging: merge fixup for wireless drivers move

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wireless/libertas/Kconfig |    2 +-
 drivers/staging/netwave/Kconfig       |    1 +
 drivers/staging/wavelan/Kconfig       |    4 ++++
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/Kconfig b/drivers/net/wireless/libertas/Kconfig
index 8f8d75b..30aa9d4 100644
--- a/drivers/net/wireless/libertas/Kconfig
+++ b/drivers/net/wireless/libertas/Kconfig
@@ -1,6 +1,6 @@
 config LIBERTAS
 	tristate "Marvell 8xxx Libertas WLAN driver support"
-	depends on WLAN_80211 && CFG80211
+	depends on CFG80211
 	select WIRELESS_EXT
 	select WEXT_SPY
 	select LIB80211
diff --git a/drivers/staging/netwave/Kconfig b/drivers/staging/netwave/Kconfig
index b6f0f0a..c0c996c 100644
--- a/drivers/staging/netwave/Kconfig
+++ b/drivers/staging/netwave/Kconfig
@@ -2,6 +2,7 @@ config PCMCIA_NETWAVE
 	tristate "Xircom Netwave AirSurfer Pcmcia wireless support"
 	depends on PCMCIA
 	select WIRELESS_EXT
+	select WEXT_PRIV
 	help
 	  Say Y here if you intend to attach this type of PCMCIA (PC-card)
 	  wireless Ethernet networking card to your computer.
diff --git a/drivers/staging/wavelan/Kconfig b/drivers/staging/wavelan/Kconfig
index ff349cd..786060e 100644
--- a/drivers/staging/wavelan/Kconfig
+++ b/drivers/staging/wavelan/Kconfig
@@ -2,6 +2,8 @@ config WAVELAN
 	tristate "AT&T/Lucent old WaveLAN & DEC RoamAbout DS ISA support"
 	depends on ISA
 	select WIRELESS_EXT
+	select WEXT_SPY
+	select WEXT_PRIV
 	---help---
 	  The Lucent WaveLAN (formerly NCR and AT&T; or DEC RoamAbout DS) is
 	  a Radio LAN (wireless Ethernet-like Local Area Network) using the
@@ -25,6 +27,8 @@ config PCMCIA_WAVELAN
 	tristate "AT&T/Lucent old WaveLAN Pcmcia wireless support"
 	depends on PCMCIA
 	select WIRELESS_EXT
+	select WEXT_SPY
+	select WEXT_PRIV
 	help
 	  Say Y here if you intend to attach an AT&T/Lucent Wavelan PCMCIA
 	  (PC-card) wireless Ethernet networking card to your computer.  This
-- 
1.6.5

