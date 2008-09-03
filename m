Return-Path: <linux-kernel-owner+w=401wt.eu-S1756294AbYICVBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbYICVBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbYICVBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:01:24 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:53027 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbYICVBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:01:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=n3/b9KikYzY1vQ1jsyNnpV57QFdKMcEiITch6aw+q1yoOI5pjfhlxkyvkM6T204g3L
         Q4gmFlTaCkPxz7mXzyt4JoBfvzXcs2pWE88Z1SSqP6JN6a70Ud956nSLSty4fclxVyxg
         lKBFe8+vOnq8QFfaQoBGm2kDwmAr+MAcM4HDY=
Date: Thu, 4 Sep 2008 01:03:02 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Remove remnants of CONFIG_VIDEO_SELECT (read: vga=)
Message-ID: <20080903210302.GA4006@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Video mode selection became always possible in 2.6.23-rc1 after i386 setup
code rewrite in C.

Regardless, VIDEO_SELECT is stupid config option because it affects only
kernel setup code, not code which always stays in memory.

vga= always possible now which is good.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/x86/configs/i386_defconfig   |    1 -
 arch/x86/configs/x86_64_defconfig |    1 -
 drivers/video/Kconfig             |    2 --
 drivers/video/console/Kconfig     |   16 ----------------
 4 files changed, 20 deletions(-)

--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -1531,7 +1531,6 @@ CONFIG_BACKLIGHT_CLASS_DEVICE=y
 CONFIG_VGA_CONSOLE=y
 CONFIG_VGACON_SOFT_SCROLLBACK=y
 CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
-CONFIG_VIDEO_SELECT=y
 CONFIG_DUMMY_CONSOLE=y
 # CONFIG_FRAMEBUFFER_CONSOLE is not set
 CONFIG_LOGO=y
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -1508,7 +1508,6 @@ CONFIG_BACKLIGHT_CLASS_DEVICE=y
 CONFIG_VGA_CONSOLE=y
 CONFIG_VGACON_SOFT_SCROLLBACK=y
 CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
-CONFIG_VIDEO_SELECT=y
 CONFIG_DUMMY_CONSOLE=y
 # CONFIG_FRAMEBUFFER_CONSOLE is not set
 CONFIG_LOGO=y
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -673,7 +673,6 @@ config FB_VESA
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	select VIDEO_SELECT
 	help
 	  This is the frame buffer device driver for generic VESA 2.0
 	  compliant graphic cards. The older VESA 1.2 cards are not supported.
@@ -1578,7 +1577,6 @@ config FB_CYBLA
 	tristate "Cyberblade/i1 support"
 	depends on FB && PCI && X86_32 && !64BIT
 	select FB_CFB_IMAGEBLIT
-	select VIDEO_SELECT
 	---help---
 	  This driver is supposed to support the Trident Cyberblade/i1
 	  graphics core integrated in the VIA VT8601A North Bridge,
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -43,22 +43,6 @@ config VGACON_SOFT_SCROLLBACK_SIZE
 	 buffer.  Each 64KB will give you approximately 16 80x25
 	 screenfuls of scrollback buffer
 
-config VIDEO_SELECT
-	bool "Video mode selection support"
-	depends on  X86 && VGA_CONSOLE
-	---help---
-	  This enables support for text mode selection on kernel startup. If
-	  you want to take advantage of some high-resolution text mode your
-	  card's BIOS offers, but the traditional Linux utilities like
-	  SVGATextMode don't, you can say Y here and set the mode using the
-	  "vga=" option from your boot loader (lilo or loadlin) or set
-	  "vga=ask" which brings up a video mode menu on kernel startup. (Try
-	  "man bootparam" or see the documentation of your boot loader about
-	  how to pass options to the kernel.)
-
-	  Read the file <file:Documentation/svga.txt> for more information
-	  about the Video mode selection support. If unsure, say N.
-
 config MDA_CONSOLE
 	depends on !M68K && !PARISC && ISA
 	tristate "MDA text console (dual-headed) (EXPERIMENTAL)"

