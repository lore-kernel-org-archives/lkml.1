Return-Path: <linux-kernel-owner+w=401wt.eu-S1760981AbXFSWvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760981AbXFSWvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbXFSWvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:51:35 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:13715 "EHLO
	outbound2-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945AbXFSWve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:51:34 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Wed, 20 Jun 2007 00:52:03 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: [PATCH 11/12] pcmcia/net_pcmcia: all net_pcmcia modules depend
 on PCMCIA
Message-ID: <20070619225203.GM5193@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Jun 2007 22:51:06.0827 (UTC)
 FILETIME=[525959B0:01C7B2C4]
X-WSS-ID: 6A6682571S4852452-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix several build errors with PCMCIA=m && NET_PCMCIA=y:

   LD      .tmp_vmlinux1
   drivers/built-in.o: In function `nmclan_release':
   nmclan_cs.c:(.text+0x14026c): undefined reference to `pcmcia_disable_device'
   ...
   drivers/built-in.o: In function `exit_xirc2ps_cs':
   xirc2ps_cs.c:(.exit.text+0x1055): undefined reference to `pcmcia_unregister_driver'
   make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/net/pcmcia/Kconfig |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pcmcia/Kconfig b/drivers/net/pcmcia/Kconfig
index 5d658bc..9545440 100644
--- a/drivers/net/pcmcia/Kconfig
+++ b/drivers/net/pcmcia/Kconfig
@@ -23,6 +23,7 @@ if NET_PCMCIA
 
 config PCMCIA_3C589
 	tristate "3Com 3c589 PCMCIA support"
+	depends on PCMCIA
 	help
 	  Say Y here if you intend to attach a 3Com 3c589 or compatible PCMCIA
 	  (PC-card) Ethernet card to your computer.
@@ -32,6 +33,7 @@ config PCMCIA_3C589
 
 config PCMCIA_3C574
 	tristate "3Com 3c574 PCMCIA support"
+	depends on PCMCIA
 	help
 	  Say Y here if you intend to attach a 3Com 3c574 or compatible PCMCIA
 	  (PC-card) Fast Ethernet card to your computer.
@@ -41,6 +43,7 @@ config PCMCIA_3C574
 
 config PCMCIA_FMVJ18X
 	tristate "Fujitsu FMV-J18x PCMCIA support"
+	depends on PCMCIA
 	select CRC32
 	help
 	  Say Y here if you intend to attach a Fujitsu FMV-J18x or compatible
@@ -51,6 +54,7 @@ config PCMCIA_FMVJ18X
 
 config PCMCIA_PCNET
 	tristate "NE2000 compatible PCMCIA support"
+	depends on PCMCIA
 	select CRC32
 	help
 	  Say Y here if you intend to attach an NE2000 compatible PCMCIA
@@ -61,6 +65,7 @@ config PCMCIA_PCNET
 
 config PCMCIA_NMCLAN
 	tristate "New Media PCMCIA support"
+	depends on PCMCIA
 	help
 	  Say Y here if you intend to attach a New Media Ethernet or LiveWire
 	  PCMCIA (PC-card) Ethernet card to your computer.
@@ -70,6 +75,7 @@ config PCMCIA_NMCLAN
 
 config PCMCIA_SMC91C92
 	tristate "SMC 91Cxx PCMCIA support"
+	depends on PCMCIA
 	select CRC32
 	select MII
 	help
@@ -81,6 +87,7 @@ config PCMCIA_SMC91C92
 
 config PCMCIA_XIRC2PS
 	tristate "Xircom 16-bit PCMCIA support"
+	depends on PCMCIA
 	help
 	  Say Y here if you intend to attach a Xircom 16-bit PCMCIA (PC-card)
 	  Ethernet or Fast Ethernet card to your computer.
@@ -90,6 +97,7 @@ config PCMCIA_XIRC2PS
 
 config PCMCIA_AXNET
 	tristate "Asix AX88190 PCMCIA support"
+	depends on PCMCIA
 	---help---
 	  Say Y here if you intend to attach an Asix AX88190-based PCMCIA
 	  (PC-card) Fast Ethernet card to your computer.  These cards are
@@ -101,7 +109,7 @@ config PCMCIA_AXNET
 
 config ARCNET_COM20020_CS
 	tristate "COM20020 ARCnet PCMCIA support"
-	depends on ARCNET_COM20020
+	depends on ARCNET_COM20020 && PCMCIA
 	help
 	  Say Y here if you intend to attach this type of ARCnet PCMCIA card
 	  to your computer.
@@ -111,7 +119,7 @@ config ARCNET_COM20020_CS
 
 config PCMCIA_IBMTR
 	tristate "IBM PCMCIA tokenring adapter support"
-	depends on IBMTR!=y && TR && !64BIT
+	depends on IBMTR!=y && TR && !64BIT && PCMCIA
 	help
 	  Say Y here if you intend to attach this type of Token Ring PCMCIA
 	  card to your computer. You then also need to say Y to "Token Ring
-- 
1.5.0.7




