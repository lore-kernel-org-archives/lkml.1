Return-Path: <linux-kernel-owner+w=401wt.eu-S969927AbXFHQSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969927AbXFHQSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969657AbXFHQRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:17:13 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:24610 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S966216AbXFHQRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:17:11 -0400
Date: Fri, 08 Jun 2007 09:52:44 -0600
From: dougthompson@xmission.com
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH 1/6]
Message-ID: <46697b4c.euhUs2q10ak3OBjl%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmission.com>

1) Remove an old CVS ID string

2) change EDAC from a tristate option to a simple bool option 

3) In addition to the X86 arch, PPC and MIPS also have drivers in the
submission queue. This patch turns on the EDAC flag 
for those archs.  Each driver will have its respective 'depends on ARCH' set.

Signed-off-by:	Douglas Thompson <dougthompson@xmission.com>
Cc:	alan@lxorguk.ukuu.org.uk
---
 Kconfig |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6.22-rc4-mm1/drivers/edac/Kconfig
===================================================================
--- linux-2.6.22-rc4-mm1.orig/drivers/edac/Kconfig
+++ linux-2.6.22-rc4-mm1/drivers/edac/Kconfig
@@ -3,13 +3,12 @@
 #	Copyright (c) 2003 Linux Networx
 #	Licensed and distributed under the GPL
 #
-# $Id: Kconfig,v 1.4.2.7 2005/07/08 22:05:38 dsp_llnl Exp $
-#
 
 menuconfig EDAC
-	tristate "EDAC - error detection and reporting (EXPERIMENTAL)"
+	bool "EDAC - error detection and reporting (EXPERIMENTAL)"
 	depends on HAS_IOMEM
-	depends on X86 && EXPERIMENTAL
+	depends on EXPERIMENTAL
+	depends on X86 || MIPS || PPC
 	help
 	  EDAC is designed to report errors in the core system.
 	  These are low-level errors that are reported in the CPU or
