Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958Ab0A2Wn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab0A2Wn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944Ab0A2WnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:43:25 -0500
Received: from p01c12o147.mxlogic.net ([208.65.145.70]:45735 "EHLO
	p01c12o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab0A2WnY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:43:24 -0500
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jan 2010 17:43:24 EST
X-MXL-Hash: 4b63648c13e15cdb-833094056f584d742dd10a5875160bf75c451a62
X-MXL-Hash: 4b6363e56b302e86-e8c067e875b5495d65f348bc2a57d34c4b7f4c23
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH 2.6.33 2/4] net: Kconfig change for KSZ884X driver
Date: Fri, 29 Jan 2010 14:40:34 -0800
Message-ID: <14385191E87B904DBD836449AA30269D021A4E@MORGANITE.micrel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.33 2/4] net: Kconfig change for KSZ884X driver
Thread-Index: AcqhNBHBnUKSIGToTEW6ZDguTRywiA==
From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
To: "Dave Miller" <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 29 Jan 2010 22:40:34.0392 (UTC) FILETIME=[11E2AD80:01CAA134]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010011101)]
X-MAIL-FROM: <tristram.ha@micrel.com>
X-SOURCE-IP: [65.218.208.2]
X-AnalysisOut: [v=1.0 c=1 a=8PPP1YHBDycA:10 a=J3BOMSfJb05aRia9DmE+FQ==:17 ]
X-AnalysisOut: [a=Q4n7fi2PAAAA:8 a=VYfMdWa_kRON_9sugdgA:9 a=1ljP9evXTYvjWx]
X-AnalysisOut: [Uq1mGxlsZ3TUYA:4 a=yJsD6ztlz_8A:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tristram Ha <Tristram.Ha@micrel.com>

Add Micrel KSZ8841/KSZ8842 PCI Ethernet chip support.

Some users like to use KSZ8842 switch to run Spanning Tree Protocol.  As a result a hardware STP support was implemented so that the host does not waste CPU time forwarding each and every packet.

Signed-off-by: Tristram Ha <Tristram.Ha@micrel.com>
---
This is a resubmission of the Micrel KSZ8841/2 PCI Ethernet driver.

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
+	bool "STP support (EXPERIMENTAL)"
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
