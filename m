Return-Path: <linux-kernel-owner+w=401wt.eu-S1750974AbXDJVaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750974AbXDJVaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbXDJVaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:30:23 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:52915 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbXDJVaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:30:20 -0400
Date: Tue, 10 Apr 2007 23:27:31 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Per Liden <per.liden@ericsson.com>, Jon Maloy <jon.maloy@ericsson.com>,
       Allan Stephens <allan.stephens@windriver.com>
cc: tipc-discussion@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 19/30] Use menuconfig objects - TIPC
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102326370.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Use menuconfigs instead of menus, so the whole menu can be disabled at        
once instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/net/tipc/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/net/tipc/Kconfig
+++ linux-2.6.21-rc5/net/tipc/Kconfig
@@ -2,11 +2,9 @@
 # TIPC configuration
 #
 
-menu "TIPC Configuration (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
-
-config TIPC
+menuconfig TIPC
 	tristate "The TIPC Protocol (EXPERIMENTAL)"
+	depends on INET && EXPERIMENTAL
 	---help---
 	  The Transparent Inter Process Communication (TIPC) protocol is
 	  specially designed for intra cluster communication. This protocol
@@ -22,9 +20,10 @@ config TIPC
 
 	  If in doubt, say N.
 
+if TIPC
+
 config TIPC_ADVANCED
 	bool "TIPC: Advanced configuration"
-	depends on TIPC
 	default n
 	help
 	  Saying Y here will open some advanced configuration
@@ -33,7 +32,7 @@ config TIPC_ADVANCED
 
 config TIPC_ZONES
 	int "Maximum number of zones in network"
-	depends on TIPC && TIPC_ADVANCED
+	depends on TIPC_ADVANCED
 	default "3"
 	help
 	 Max number of zones inside TIPC network. Max supported value 
@@ -44,7 +43,7 @@ config TIPC_ZONES
 
 config TIPC_CLUSTERS
 	int "Maximum number of clusters in a zone"
-	depends on TIPC && TIPC_ADVANCED
+	depends on TIPC_ADVANCED
 	default "1"
 	help
           ***Only 1 (one cluster in a zone) is supported by current code.
@@ -59,7 +58,7 @@ config TIPC_CLUSTERS
 
 config TIPC_NODES
 	int "Maximum number of nodes in cluster"
-	depends on TIPC && TIPC_ADVANCED
+	depends on TIPC_ADVANCED
 	default "255"
 	help
 	  Maximum number of nodes inside a TIPC cluster. Maximum 
@@ -70,7 +69,7 @@ config TIPC_NODES
 
 config TIPC_SLAVE_NODES
 	int "Maximum number of slave nodes in cluster"
-	depends on TIPC && TIPC_ADVANCED
+	depends on TIPC_ADVANCED
 	default "0"
 	help
           ***This capability is not supported by current code.***
@@ -83,7 +82,7 @@ config TIPC_SLAVE_NODES
 
 config TIPC_PORTS
 	int "Maximum number of ports in a node"
-	depends on TIPC && TIPC_ADVANCED
+	depends on TIPC_ADVANCED
 	default "8191"
 	help
 	  Maximum number of ports within a node. Maximum 
@@ -94,7 +93,7 @@ config TIPC_PORTS
 
 config TIPC_LOG
 	int "Size of log buffer"
-	depends on TIPC && TIPC_ADVANCED
+	depends on TIPC_ADVANCED
 	default 0
 	help
  	  Size (in bytes) of TIPC's internal log buffer, which records the
@@ -106,7 +105,6 @@ config TIPC_LOG
 
 config TIPC_DEBUG
 	bool "Enable debugging support"
-	depends on TIPC
 	default n
 	help
  	  This will enable debugging of TIPC.
@@ -114,4 +112,4 @@ config TIPC_DEBUG
 	  Only say Y here if you are having trouble with TIPC.  It will
 	  enable the display of detailed information about what is going on.
 
-endmenu
+endif # TIPC
#<EOF>
