Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab0APDEo (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 22:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757767Ab0APDEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 22:04:42 -0500
Received: from p01c11o148.mxlogic.net ([208.65.144.71]:51553 "EHLO
	p01c11o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab0APDEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 22:04:42 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jan 2010 22:04:41 EST
X-MXL-Hash: 4b512cc92d4a2375-313ff8aae82992b2d05ebc329ae6b43ca8bf8727
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATH 2.6.33 2/3] net: Kconfig change for Micrel KSZ884X driver
Date: Fri, 15 Jan 2010 19:04:39 -0800
Message-ID: <14385191E87B904DBD836449AA30269D021A4B@MORGANITE.micrel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATH 2.6.33 2/3] net: Kconfig change for Micrel KSZ884X driver
Thread-Index: AcqWWKRJWQUbHQsPS7a8P8Ine+MHag==
From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
To: "Dave Miller" <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Jan 2010 03:04:39.0098 (UTC) FILETIME=[A44871A0:01CA9658]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010011101)]
X-MAIL-FROM: <tristram.ha@micrel.com>
X-SOURCE-IP: [65.218.208.2]
X-AnalysisOut: [v=1.0 c=1 a=6vXHp6nfoPEA:10 a=J3BOMSfJb05aRia9DmE+FQ==:17 ]
X-AnalysisOut: [a=Q4n7fi2PAAAA:8 a=VYfMdWa_kRON_9sugdgA:9 a=WEsdoGNZL8SV2C]
X-AnalysisOut: [WqW8SDFDjU5lkA:4 a=yJsD6ztlz_8A:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tristram Ha <Tristram.Ha@micrel.com>

Add Micrel KSZ8841/KSZ8842 PCI Ethernet chip support.

Some users like to use KSZ8842 switch to run Spanning Tree Protocol.  As a result a hardware STP support was implemented so that the host does not waste CPU time forwarding each and every packet.

Signed-off-by: Tristram Ha <Tristram.Ha@micrel.com>
---
diff -uprN linux-2.6.33-rc3.old/drivers/net/Kconfig linux-2.6.33-rc3.new/drivers/net/Kconfig
--- linux-2.6.33-rc3.old/drivers/net/Kconfig	2010-01-05 16:02:46.000000000 -0800
+++ linux-2.6.33-rc3.new/drivers/net/Kconfig	2010-01-13 12:17:42.000000000 -0800
@@ -1368,6 +1368,27 @@ config AC3200
 	  To compile this driver as a module, choose M here. The module
 	  will be called ac3200.
 
+config KSZ884X_PCI
+	tristate "Micrel KSZ8841/2 PCI"
+	depends on NET_PCI && PCI
+	select MII
+	select CRC32
+	help
+	  This PCI driver is for Micrel KSZ8841/KSZ8842 PCI Ethernet chip.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called ksz884x.
+
+config KSZ8842_STP
+	bool "STP support"
+	depends on KSZ884X_PCI && EXPERIMENTAL
+	help
+	  This enables a feature to aid KSZ8842 running Spanning Tree Protocol.
+	  To actually use it pass the stp=1 parameter to the driver.
+
+	  This feature is experimental and may not work correctly compared to
+	  the Linux bridge using STP.
+
 config APRICOT
 	tristate "Apricot Xen-II on board Ethernet"
 	depends on NET_PCI && ISA
