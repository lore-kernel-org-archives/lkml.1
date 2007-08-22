Return-Path: <linux-kernel-owner+w=401wt.eu-S1765290AbXHVQma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765290AbXHVQma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762966AbXHVQmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:42:23 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:42305 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761908AbXHVQmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:42:22 -0400
Date: Wed, 22 Aug 2007 17:42:20 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: adaplas@gmail.com, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [VIDEO] Fix font dependency for SGI Newport console driver.
Message-ID: <20070822164220.GB29751@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We better select a font when the newport driver is a module or the user
experience might suffer.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index 4964396..70cbb7c 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -182,7 +182,7 @@ config FONT_8x8
 
 config FONT_8x16
 	bool "VGA 8x16 font" if FONTS
-	depends on FRAMEBUFFER_CONSOLE || SGI_NEWPORT_CONSOLE=y || STI_CONSOLE || USB_SISUSBVGA_CON 
+	depends on FRAMEBUFFER_CONSOLE || SGI_NEWPORT_CONSOLE || STI_CONSOLE || USB_SISUSBVGA_CON 
 	default y if !SPARC && !FONTS
 	help
 	  This is the "high resolution" font for the VGA frame buffer (the one
