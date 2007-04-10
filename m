Return-Path: <linux-kernel-owner+w=401wt.eu-S1030673AbXDJV12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030673AbXDJV12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030720AbXDJV12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:27:28 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:51826 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030673AbXDJV10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:27:26 -0400
Date: Tue, 10 Apr 2007 23:26:35 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Sridhar Samudrala <sri@us.ibm.com>
cc: lksctp-developers@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/30] Use menuconfig objects - SCTP
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102326020.32056@yvahk01.tjqt.qr>
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

Index: linux-2.6.21-rc5/net/sctp/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/net/sctp/Kconfig
+++ linux-2.6.21-rc5/net/sctp/Kconfig
@@ -2,11 +2,9 @@
 # SCTP configuration
 #
 
-menu "SCTP Configuration (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
-
-config IP_SCTP
+menuconfig IP_SCTP
 	tristate "The SCTP Protocol (EXPERIMENTAL)"
+	depends on NET && EXPERIMENTAL
 	depends on IPV6 || IPV6=n
 	select CRYPTO if SCTP_HMAC_SHA1 || SCTP_HMAC_MD5
 	select CRYPTO_HMAC if SCTP_HMAC_SHA1 || SCTP_HMAC_MD5
@@ -36,9 +34,10 @@ config IP_SCTP
 
 	  If in doubt, say N.
 
+if IP_SCTP
+
 config SCTP_DBG_MSG
 	bool "SCTP: Debug messages"
-	depends on IP_SCTP
 	help
 	  If you say Y, this will enable verbose debugging messages. 
 
@@ -47,7 +46,6 @@ config SCTP_DBG_MSG
 
 config SCTP_DBG_OBJCNT
 	bool "SCTP: Debug object counts"
-	depends on IP_SCTP
 	help
 	  If you say Y, this will enable debugging support for counting the 
 	  type of objects that are currently allocated.  This is useful for 
@@ -59,7 +57,6 @@ config SCTP_DBG_OBJCNT
 
 choice
 	prompt "SCTP: Cookie HMAC Algorithm"
-	depends on IP_SCTP
 	default SCTP_HMAC_MD5
 	help
 	  HMAC algorithm to be used during association initialization.  It
@@ -86,4 +83,5 @@ config SCTP_HMAC_MD5
 	  advised to use either HMAC-MD5 or HMAC-SHA1.
 
 endchoice
-endmenu
+
+endif # IP_SCTP
#<EOF>
