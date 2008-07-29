Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbYG2Qtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbYG2Qtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 12:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYG2QtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 12:49:21 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:34876 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbYG2QtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 12:49:19 -0400
Date: Tue, 29 Jul 2008 19:48:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove unneeded #include <linux/ide.h>'s
Message-ID: <20080729164831.GC23951@cs181140183.pp.htv.fi>
References: <20080727130448.GK9301@cs181140183.pp.htv.fi> <200807271632.16417.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200807271632.16417.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 04:32:16PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 27 July 2008, Adrian Bunk wrote:
> > The sh systemh_defconfig currently fails to build with the following 
> > error:
> > 
> > <--  snip  -->
> > 
> > ...
> >   CC      arch/sh/boards/renesas/systemh/irq.o
> > In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/boards/renesas/systemh/irq.c:16:
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/ide.h:645: error: 'CONFIG_IDE_MAX_HWIFS' undeclared here (not in a function)
> > make[2]: *** [arch/sh/boards/renesas/systemh/irq.o] Error 1
> 
> Please also fix the source root of the problem:
> 
> arch/sh/boards/renesas/systemh/irq.c should have no bussiness in
> including include/linux/ide.h (which is for drivers/ide/ _only_)
>...

ide-scsi.c and the mediabay stuff might qualify as exceptions?

For the rest a patch is below (on top of your #include <linux/hdreg.h> 
removal patch).

cu
Adrian


<--  snip  -->


This patch remove unneeded #include <linux/ide.h>'s.

It also adds a required #include <linux/interrupt.h> that was previously 
implicitely pulled by ide.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/arm/mach-pxa/pcm990-baseboard.c |    1 -
 arch/m68k/mac/baboon.c               |    1 -
 arch/m68k/mac/via.c                  |    1 -
 arch/mips/emma2rh/markeins/setup.c   |    1 -
 arch/mips/jazz/setup.c               |    1 -
 arch/sh/boards/renesas/systemh/irq.c |    2 +-
 arch/xtensa/kernel/xtensa_ksyms.c    |    1 -
 drivers/misc/lkdtm.c                 |    4 ----
 8 files changed, 1 insertion(+), 11 deletions(-)

5d4186cd22d575b6adbbeeee7dfa88299817a408 
diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
index 30023b0..90056d5 100644
--- a/arch/arm/mach-pxa/pcm990-baseboard.c
+++ b/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -22,7 +22,6 @@
 
 #include <linux/irq.h>
 #include <linux/platform_device.h>
-#include <linux/ide.h>
 #include <linux/i2c.h>
 #include <linux/pwm_backlight.h>
 
diff --git a/arch/m68k/mac/baboon.c b/arch/m68k/mac/baboon.c
index dae9c98..c7b25b0 100644
--- a/arch/m68k/mac/baboon.c
+++ b/arch/m68k/mac/baboon.c
@@ -11,7 +11,6 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/init.h>
-#include <linux/ide.h>
 
 #include <asm/traps.h>
 #include <asm/bootinfo.h>
diff --git a/arch/m68k/mac/via.c b/arch/m68k/mac/via.c
index f3b27d0..1bdb03c 100644
--- a/arch/m68k/mac/via.c
+++ b/arch/m68k/mac/via.c
@@ -27,7 +27,6 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/init.h>
-#include <linux/ide.h>
 #include <linux/module.h>
 
 #include <asm/bootinfo.h>
diff --git a/arch/mips/emma2rh/markeins/setup.c b/arch/mips/emma2rh/markeins/setup.c
index 62bfb45..65d06d5 100644
--- a/arch/mips/emma2rh/markeins/setup.c
+++ b/arch/mips/emma2rh/markeins/setup.c
@@ -27,7 +27,6 @@
 #include <linux/types.h>
 #include <linux/initrd.h>
 #include <linux/irq.h>
-#include <linux/ide.h>
 #include <linux/ioport.h>
 #include <linux/param.h>	/* for HZ */
 #include <linux/root_dev.h>
diff --git a/arch/mips/jazz/setup.c b/arch/mips/jazz/setup.c
index d3a531a..b59ba6b 100644
--- a/arch/mips/jazz/setup.c
+++ b/arch/mips/jazz/setup.c
@@ -17,7 +17,6 @@
 #include <linux/mm.h>
 #include <linux/console.h>
 #include <linux/fb.h>
-#include <linux/ide.h>
 #include <linux/pm.h>
 #include <linux/screen_info.h>
 #include <linux/platform_device.h>
diff --git a/arch/sh/boards/renesas/systemh/irq.c b/arch/sh/boards/renesas/systemh/irq.c
index 82101cc..601c9c8 100644
--- a/arch/sh/boards/renesas/systemh/irq.c
+++ b/arch/sh/boards/renesas/systemh/irq.c
@@ -11,8 +11,8 @@
 
 #include <linux/init.h>
 #include <linux/irq.h>
+#include <linux/interrupt.h>
 
-#include <linux/ide.h>
 #include <asm/io.h>
 #include <asm/systemh7751.h>
 #include <asm/smc37c93x.h>
diff --git a/arch/xtensa/kernel/xtensa_ksyms.c b/arch/xtensa/kernel/xtensa_ksyms.c
index 6e52cdd..c9a7c5b 100644
--- a/arch/xtensa/kernel/xtensa_ksyms.c
+++ b/arch/xtensa/kernel/xtensa_ksyms.c
@@ -18,7 +18,6 @@
 #include <linux/interrupt.h>
 #include <asm/irq.h>
 #include <linux/in6.h>
-#include <linux/ide.h>
 
 #include <asm/uaccess.h>
 #include <asm/checksum.h>
diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 1bfe5d1..2a40d18 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -54,10 +54,6 @@
 #include <linux/hrtimer.h>
 #include <scsi/scsi_cmnd.h>
 
-#ifdef CONFIG_IDE
-#include <linux/ide.h>
-#endif
-
 #define NUM_CPOINTS 8
 #define NUM_CPOINT_TYPES 5
 #define DEFAULT_COUNT 10

