Return-Path: <linux-kernel-owner+w=401wt.eu-S1161614AbXDYFb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161614AbXDYFb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 01:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbXDYFb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 01:31:59 -0400
Received: from hqemgate01.nvidia.com ([216.228.112.170]:3829 "EHLO
	HQEMGATE01.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbXDYFb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 01:31:58 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] drivers/net: move the nvidia forcedeth driver from 100M group to 1000M group
Date: Wed, 25 Apr 2007 13:30:04 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B130752BE@hkemmail01.nvidia.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net: move the nvidia forcedeth driver from 100M group to 1000M group
Thread-Index: AceG5ZQo5uXNfGB+QGeRfQfC7buISwAFQjRA
From: "Peer Chen" <pchen@nvidia.com>
To: <linux-kernel@vger.kernel.org>
Cc: <akpm@osdl.org>, <torvalds@osdl.org>
X-OriginalArrivalTime: 25 Apr 2007 05:31:49.0826 (UTC) FILETIME=[05F5DA20:01C786FB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nForce ehternet is a Gigabit NIC not 100M, move it to 1000M group to
avoid the confusion.

Signed-off-by: Peer Chen <pchen@nvidia.com>

====================

--- linux-2.6.21-rc7/drivers/net/Kconfig.orig
+++ linux-2.6.21-rc7/drivers/net/Kconfig
@@ -1399,35 +1399,6 @@ config B44
 	  <file:Documentation/networking/net-modules.txt>.  The module
will be
 	  called b44.
 
-config FORCEDETH
-	tristate "nForce Ethernet support"
-	depends on NET_PCI && PCI
-	help
-	  If you have a network (Ethernet) controller of this type, say
Y and
-	  read the Ethernet-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
-
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module
will be
-	  called forcedeth.
-
-config FORCEDETH_NAPI
-	bool "Use Rx and Tx Polling (NAPI) (EXPERIMENTAL)"
-	depends on FORCEDETH && EXPERIMENTAL
-	help
-	  NAPI is a new driver API designed to reduce CPU and interrupt
load
-	  when the driver is receiving lots of packets from the card. It
is
-	  still somewhat experimental and thus not yet enabled by
default.
-
-	  If your estimated Rx load is 10kpps or more, or if the card
will be
-	  deployed on potentially unfriendly networks (e.g. in a
firewall),
-	  then say Y here.
-
-	  See <file:Documentation/networking/NAPI_HOWTO.txt> for more
-	  information.
-
-	  If in doubt, say N.
-
 config CS89x0
 	tristate "CS89x0 support"
 	depends on NET_PCI && (ISA || MACH_IXDP2351 || ARCH_IXDP2X01 ||
ARCH_PNX010X)
@@ -1999,6 +1970,35 @@ config MYRI_SBUS
 	  To compile this driver as a module, choose M here: the module
 	  will be called myri_sbus.  This is recommended.
 
+config FORCEDETH
+	tristate "nForce Ethernet support"
+	depends on NET_PCI && PCI
+	help
+	  If you have a network (Ethernet) controller of this type, say
Y and
+	  read the Ethernet-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.
+
+	  To compile this driver as a module, choose M here and read
+	  <file:Documentation/networking/net-modules.txt>.  The module
will be
+	  called forcedeth.
+
+config FORCEDETH_NAPI
+	bool "Use Rx and Tx Polling (NAPI) (EXPERIMENTAL)"
+	depends on FORCEDETH && EXPERIMENTAL
+	help
+	  NAPI is a new driver API designed to reduce CPU and interrupt
load
+	  when the driver is receiving lots of packets from the card. It
is
+	  still somewhat experimental and thus not yet enabled by
default.
+
+	  If your estimated Rx load is 10kpps or more, or if the card
will be
+	  deployed on potentially unfriendly networks (e.g. in a
firewall),
+	  then say Y here.
+
+	  See <file:Documentation/networking/NAPI_HOWTO.txt> for more
+	  information.
+
+	  If in doubt, say N.
+
 config NS83820
 	tristate "National Semiconductor DP83820 support"
 	depends on PCI
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
