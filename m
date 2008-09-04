Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYIDL5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYIDL5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 07:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYIDL46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 07:56:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54442 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbYIDL45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 07:56:57 -0400
Date: Thu, 4 Sep 2008 13:56:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Remove remnants of CONFIG_VIDEO_SELECT (read: vga=)
Message-ID: <20080904115639.GA1715@elte.hu>
References: <20080903210302.GA4006@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903210302.GA4006@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Video mode selection became always possible in 2.6.23-rc1 after i386 setup
> code rewrite in C.
> 
> Regardless, VIDEO_SELECT is stupid config option because it affects only
> kernel setup code, not code which always stays in memory.
> 
> vga= always possible now which is good.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

hpa has put the commit below into x86/setup - thanks Alexey.

	Ingo

-------------->
>From a57a5c2e8db8d80f460dcad77877895718c9f209 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Thu, 4 Sep 2008 01:03:02 +0400
Subject: [PATCH] x86 setup: remove remnants of CONFIG_VIDEO_SELECT (read: vga=)

Impact: cleanup

Video mode selection became always possible in 2.6.23-rc1 after i386 setup
code rewrite in C.

Regardless, VIDEO_SELECT is stupid config option because it affects only
kernel setup code, not code which always stays in memory.

vga= always possible now which is good.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/configs/i386_defconfig   |    1 -
 arch/x86/configs/x86_64_defconfig |    1 -
 drivers/video/Kconfig             |    2 --
 drivers/video/console/Kconfig     |   16 ----------------
 4 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 9bc34e2..a7ae438 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -1482,7 +1482,6 @@ CONFIG_BACKLIGHT_CLASS_DEVICE=y
 CONFIG_VGA_CONSOLE=y
 CONFIG_VGACON_SOFT_SCROLLBACK=y
 CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
-CONFIG_VIDEO_SELECT=y
 CONFIG_DUMMY_CONSOLE=y
 # CONFIG_FRAMEBUFFER_CONSOLE is not set
 CONFIG_LOGO=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index ae5124e..743e803 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -1449,7 +1449,6 @@ CONFIG_BACKLIGHT_CLASS_DEVICE=y
 CONFIG_VGA_CONSOLE=y
 CONFIG_VGACON_SOFT_SCROLLBACK=y
 CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
-CONFIG_VIDEO_SELECT=y
 CONFIG_DUMMY_CONSOLE=y
 # CONFIG_FRAMEBUFFER_CONSOLE is not set
 CONFIG_LOGO=y
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 9b887ef..d58509a 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -678,7 +678,6 @@ config FB_VESA
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	select VIDEO_SELECT
 	help
 	  This is the frame buffer device driver for generic VESA 2.0
 	  compliant graphic cards. The older VESA 1.2 cards are not supported.
@@ -1583,7 +1582,6 @@ config FB_CYBLA
 	tristate "Cyberblade/i1 support"
 	depends on FB && PCI && X86_32 && !64BIT
 	select FB_CFB_IMAGEBLIT
-	select VIDEO_SELECT
 	---help---
 	  This driver is supposed to support the Trident Cyberblade/i1
 	  graphics core integrated in the VIA VT8601A North Bridge,
diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index 06f87b0..2f50a80 100644
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
