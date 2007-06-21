Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbXFUXwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbXFUXwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbXFUXvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:51:46 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35908 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754582AbXFUXvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:51:45 -0400
Date: Fri, 22 Jun 2007 01:52:04 +0200
From: Adrian Bunk <bunk@stusta.de>
To: James Simmons <jsimmons@infradead.org>,
       "Antonino A. Daplas" <adaplas@pol.net>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC: 2.6.22 patch] don't offer DISPLAY_SUPPORT for now
Message-ID: <20070621235204.GF23017@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

DISPLAY_SUPPORT offers support code without any users currently in the 
tree. For a user it's quite confusing that the help text talks about
"proper drivers" when none are available.

This patch therefore lets DISPLAY_SUPPORT depend on BROKEN until there 
will be user.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc4-mm2/drivers/video/display/Kconfig.old	2007-06-21 18:41:26.000000000 +0200
+++ linux-2.6.22-rc4-mm2/drivers/video/display/Kconfig	2007-06-21 18:41:41.000000000 +0200
@@ -1,24 +1,25 @@
 #
 # Display drivers configuration
 #
 
 menu "Display device support"
 
 config DISPLAY_SUPPORT
 	tristate "Display panel/monitor support"
+	depends on BROKEN  #  lacks users
 	---help---
 	  This framework adds support for low-level control of a display.
 	  This includes support for power.
 
 	  Enable this to be able to choose the drivers for controlling the
 	  physical display panel/monitor on some platforms. This not only
 	  covers LCD displays for PDAs but also other types of displays
 	  such as CRT, TVout etc.
 
 	  To have support for your specific display panel you will have to
 	  select the proper drivers which depend on this option.
 
 comment "Display hardware drivers"
 	depends on DISPLAY_SUPPORT
 
 endmenu



