Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbXDJVIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbXDJVIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbXDJVIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:08:45 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:44464 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873AbXDJVIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:08:36 -0400
Date: Tue, 10 Apr 2007 23:07:50 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Arnaldo Carvalho de Melo <acme@mandriva.com>
cc: dccp@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/30] Use menuconfig objects - DCCP
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102305291.32056@yvahk01.tjqt.qr>
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

Index: linux-2.6.21-rc5/net/dccp/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/net/dccp/Kconfig
+++ linux-2.6.21-rc5/net/dccp/Kconfig
@@ -1,8 +1,6 @@
-menu "DCCP Configuration (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
-
-config IP_DCCP
+menuconfig IP_DCCP
 	tristate "The DCCP Protocol (EXPERIMENTAL)"
+	depends on INET && EXPERIMENTAL
 	---help---
 	  Datagram Congestion Control Protocol (RFC 4340)
 
@@ -19,19 +17,20 @@ config IP_DCCP
 
 	  If in doubt, say N.
 
+if IP_DCCP
+
 config INET_DCCP_DIAG
-	depends on IP_DCCP && INET_DIAG
+	depends on INET_DIAG
 	def_tristate y if (IP_DCCP = y && INET_DIAG = y)
 	def_tristate m
 
 config IP_DCCP_ACKVEC
-	depends on IP_DCCP
 	bool
 
 source "net/dccp/ccids/Kconfig"
 
 menu "DCCP Kernel Hacking"
-	depends on IP_DCCP && DEBUG_KERNEL=y
+	depends on DEBUG_KERNEL=y
 
 config IP_DCCP_DEBUG
 	bool "DCCP debug messages"
@@ -61,4 +60,4 @@ config NET_DCCPPROBE
 
 endmenu
 
-endmenu
+endif # IP_DDCP
#<EOF>
