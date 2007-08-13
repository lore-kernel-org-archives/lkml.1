Return-Path: <linux-kernel-owner+w=401wt.eu-S946777AbXHMO3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946777AbXHMO3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S944460AbXHML3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:29:32 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:47907
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S942082AbXHML32 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:29:28 -0400
Message-Id: <46C05CF4.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 13 Aug 2007 12:30:28 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] cleanup floppy.h
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

AUTO_DMA and FLOPPY_MOTOR_MASK in include/asm-*/floppy.h are dead
symbols - remove them.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 include/asm-alpha/floppy.h   |    2 --
 include/asm-arm/floppy.h     |    2 --
 include/asm-i386/floppy.h    |    4 ----
 include/asm-m68k/floppy.h    |    3 ---
 include/asm-mips/floppy.h    |    2 --
 include/asm-parisc/floppy.h  |    4 ----
 include/asm-powerpc/floppy.h |    2 --
 include/asm-ppc/floppy.h     |    2 --
 include/asm-sh/floppy.h      |    4 ----
 include/asm-sparc/floppy.h   |    2 --
 include/asm-sparc64/floppy.h |    4 ----
 include/asm-x86_64/floppy.h  |    4 ----
 12 files changed, 35 deletions(-)

--- linux-2.6.23-rc3/include/asm-alpha/floppy.h	2006-09-20 05:42:06.000000000 +0200
+++ 2.6.23-rc3-kill-auto-dma/include/asm-alpha/floppy.h	2007-07-12 12:18:23.000000000 +0200
@@ -91,8 +91,6 @@ static int FDC2 = -1;
 #define N_FDC 2
 #define N_DRIVE 8
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
 /*
  * Most Alphas have no problems with floppy DMA crossing 64k borders,
  * except for certain ones, like XL and RUFFIAN.
--- linux-2.6.23-rc3/include/asm-arm/floppy.h	2007-08-13 09:00:59.000000000 +0200
+++ 2.6.23-rc3-kill-auto-dma/include/asm-arm/floppy.h	2007-07-12 12:18:29.000000000 +0200
@@ -128,8 +128,6 @@ static inline void fd_scandrives (void)
 #define N_FDC 1
 #define N_DRIVE 4
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
 #define CROSS_64KB(a,s) (0)
 
 /*
--- linux-2.6.23-rc3/include/asm-i386/floppy.h	2006-11-29 22:57:37.000000000 +0100
+++ 2.6.23-rc3-kill-auto-dma/include/asm-i386/floppy.h	2007-07-12 12:18:41.000000000 +0200
@@ -275,10 +275,6 @@ static int FDC2 = -1;
 #define N_FDC 2
 #define N_DRIVE 8
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
-#define AUTO_DMA
-
 #define EXTRA_FLOPPY_PARAMS
 
 #endif /* __ASM_I386_FLOPPY_H */
--- linux-2.6.23-rc3/include/asm-m68k/floppy.h	2006-11-29 22:57:37.000000000 +0100
+++ 2.6.23-rc3-kill-auto-dma/include/asm-m68k/floppy.h	2007-07-12 12:18:55.000000000 +0200
@@ -31,9 +31,6 @@ asmlinkage irqreturn_t floppy_hardint(in
 #define FLOPPY0_TYPE (MACH_IS_Q40 ? 6 : 4)
 #define FLOPPY1_TYPE 0
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
-
 /* basically PC init + set use_virtual_dma */
 #define  FDC1 m68k_floppy_init()
 
--- linux-2.6.23-rc3/include/asm-mips/floppy.h	2004-04-04 05:36:14.000000000 +0200
+++ 2.6.23-rc3-kill-auto-dma/include/asm-mips/floppy.h	2007-07-12 12:19:03.000000000 +0200
@@ -32,8 +32,6 @@ static inline void fd_cacheflush(char * 
 #define N_FDC 1			/* do you *really* want a second controller? */
 #define N_DRIVE 8
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
 /*
  * The DMA channel used by the floppy controller cannot access data at
  * addresses >= 16MB
--- linux-2.6.23-rc3/include/asm-parisc/floppy.h	2006-09-20 05:42:06.000000000 +0200
+++ 2.6.23-rc3-kill-auto-dma/include/asm-parisc/floppy.h	2007-07-12 12:19:10.000000000 +0200
@@ -266,10 +266,6 @@ static int FDC2 = -1;
 #define N_FDC 1
 #define N_DRIVE 8
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
-#define AUTO_DMA
-
 #define EXTRA_FLOPPY_PARAMS
 
 #endif /* __ASM_PARISC_FLOPPY_H */
--- linux-2.6.23-rc3/include/asm-powerpc/floppy.h	2007-08-13 09:01:04.000000000 +0200
+++ 2.6.23-rc3-kill-auto-dma/include/asm-powerpc/floppy.h	2007-07-12 12:19:16.000000000 +0200
@@ -202,8 +202,6 @@ static int FDC2 = -1;
 #define N_FDC 2			/* Don't change this! */
 #define N_DRIVE 8
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
 /*
  * The PowerPC has no problems with floppy DMA crossing 64k borders.
  */
--- linux-2.6.23-rc3/include/asm-ppc/floppy.h	2006-11-29 22:57:37.000000000 +0100
+++ 2.6.23-rc3-kill-auto-dma/include/asm-ppc/floppy.h	2007-07-12 12:19:23.000000000 +0200
@@ -166,8 +166,6 @@ static int FDC2 = -1;
 #define N_FDC 2			/* Don't change this! */
 #define N_DRIVE 8
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
 /*
  * The PowerPC has no problems with floppy DMA crossing 64k borders.
  */
--- linux-2.6.23-rc3/include/asm-sh/floppy.h	2007-08-13 09:01:05.000000000 +0200
+++ 2.6.23-rc3-kill-auto-dma/include/asm-sh/floppy.h	2007-07-12 12:19:31.000000000 +0200
@@ -263,10 +263,6 @@ static int FDC2 = -1;
 #define N_FDC 2
 #define N_DRIVE 8
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
-#define AUTO_DMA
-
 #define EXTRA_FLOPPY_PARAMS
 
 #endif /* __ASM_SH_FLOPPY_H */
--- linux-2.6.23-rc3/include/asm-sparc/floppy.h	2007-08-13 09:01:05.000000000 +0200
+++ 2.6.23-rc3-kill-auto-dma/include/asm-sparc/floppy.h	2007-07-12 12:19:41.000000000 +0200
@@ -77,8 +77,6 @@ static struct sun_floppy_ops sun_fdops;
 #define fd_dma_mem_free(addr,size) (vfree((void *)(addr)))
 #endif
 
-#define FLOPPY_MOTOR_MASK         0x10
-
 /* XXX This isn't really correct. XXX */
 #define get_dma_residue(x)        (0)
 
--- linux-2.6.23-rc3/include/asm-sparc64/floppy.h	2007-08-13 09:01:06.000000000 +0200
+++ 2.6.23-rc3-kill-auto-dma/include/asm-sparc64/floppy.h	2007-07-12 12:20:40.000000000 +0200
@@ -84,8 +84,6 @@ static struct sun_floppy_ops sun_fdops;
 #define fd_free_irq()             sun_fdops.fd_free_irq()
 #define fd_eject(drive)           sun_fdops.fd_eject(drive)
 
-static int FLOPPY_MOTOR_MASK = 0x10;
-
 /* Super paranoid... */
 #undef HAVE_DISABLE_HLT
 
@@ -622,7 +620,6 @@ isa_done:
 	sun_fdops.fd_eject = sun_pci_fd_eject;
 
         fdc_status = (unsigned long) &sun_fdc->status_82077;
-	FLOPPY_MOTOR_MASK = 0xf0;
 
 	allowed_drive_mask = 0;
 	sun_floppy_types[0] = 0;
@@ -729,7 +726,6 @@ static unsigned long __init sun_floppy_i
 		sun_fdops.fd_eject = sun_pci_fd_eject;
 
         	fdc_status = (unsigned long) &sun_fdc->status_82077;
-		FLOPPY_MOTOR_MASK = 0xf0;
 
 		/*
 		 * XXX: Find out on which machines this is really needed.
--- linux-2.6.23-rc3/include/asm-x86_64/floppy.h	2006-11-29 22:57:37.000000000 +0100
+++ 2.6.23-rc3-kill-auto-dma/include/asm-x86_64/floppy.h	2007-07-12 12:17:48.000000000 +0200
@@ -274,10 +274,6 @@ static int FDC2 = -1;
 #define N_FDC 2
 #define N_DRIVE 8
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
-#define AUTO_DMA
-
 #define EXTRA_FLOPPY_PARAMS
 
 #endif /* __ASM_X86_64_FLOPPY_H */


