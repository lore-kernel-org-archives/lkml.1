Return-Path: <linux-kernel-owner+w=401wt.eu-S1762058AbYFES1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762058AbYFES1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761783AbYFES1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:27:24 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33623 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761765AbYFES1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:27:22 -0400
Date: Thu, 5 Jun 2008 21:26:45 +0300
From: Adrian Bunk <bunk@kernel.org>
To: geert@linux-m68k.org, zippel@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] m68k: remove AP1000 code
Message-ID: <20080605182645.GK1469@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unless I miss something that's code for a sparc machine even the sparc 
code no longer supports that got copied to m68k when these files were 
copied.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m68k/sun3/prom/console.c |    4 ----
 arch/m68k/sun3/prom/init.c    |    9 ---------
 arch/m68k/sun3/prom/printf.c  |    5 -----
 include/asm-m68k/oplib.h      |    1 -
 4 files changed, 19 deletions(-)

0bae6d3f656139602f96e0ace2766a40d9da5725 diff --git a/arch/m68k/sun3/prom/console.c b/arch/m68k/sun3/prom/console.c
index 52c1427..cb364e5 100644
--- a/arch/m68k/sun3/prom/console.c
+++ b/arch/m68k/sun3/prom/console.c
@@ -104,8 +104,6 @@ prom_query_input_device()
 				return PROMDEV_ITTYB;
 		}
 		return PROMDEV_I_UNK;
-	case PROM_AP1000:
-		return PROMDEV_I_UNK;
 	};
 }
 #endif
@@ -166,8 +164,6 @@ prom_query_output_device()
 			};
 		}
 		break;
-	case PROM_AP1000:
-		return PROMDEV_I_UNK;
 	};
 	return PROMDEV_O_UNK;
 }
diff --git a/arch/m68k/sun3/prom/init.c b/arch/m68k/sun3/prom/init.c
index 202adfc..3ab1e9d 100644
--- a/arch/m68k/sun3/prom/init.c
+++ b/arch/m68k/sun3/prom/init.c
@@ -31,11 +31,6 @@ extern void prom_ranges_init(void);
 
 void __init prom_init(struct linux_romvec *rp)
 {
-#ifdef CONFIG_AP1000
-	extern struct linux_romvec *ap_prom_init(void);
-	rp = ap_prom_init();
-#endif
-
 	romvec = rp;
 #ifndef CONFIG_SUN3
 	switch(romvec->pv_romvers) {
@@ -53,10 +48,6 @@ void __init prom_init(struct linux_romvec *rp)
 		prom_printf("PROMLIB: Sun IEEE Prom not supported yet\n");
 		prom_halt();
 		break;
-	case 42: /* why not :-) */
-		prom_vers = PROM_AP1000;
-		break;
-
 	default:
 		prom_printf("PROMLIB: Bad PROM version %d\n",
 			    romvec->pv_romvers);
diff --git a/arch/m68k/sun3/prom/printf.c b/arch/m68k/sun3/prom/printf.c
index e7bfde3..f6b44f1 100644
--- a/arch/m68k/sun3/prom/printf.c
+++ b/arch/m68k/sun3/prom/printf.c
@@ -37,10 +37,6 @@ prom_printf(char *fmt, ...)
 
 	bptr = ppbuf;
 
-#ifdef CONFIG_AP1000
-        ap_write(1,bptr,strlen(bptr));
-#else
-
 #ifdef CONFIG_KGDB
 	if (kgdb_initialized) {
 		printk("kgdb_initialized = %d\n", kgdb_initialized);
@@ -54,7 +50,6 @@ prom_printf(char *fmt, ...)
 		prom_putchar(ch);
 	}
 #endif
-#endif
 	va_end(args);
 	return;
 }
diff --git a/include/asm-m68k/oplib.h b/include/asm-m68k/oplib.h
index 06caa2d..275cb3f 100644
--- a/include/asm-m68k/oplib.h
+++ b/include/asm-m68k/oplib.h
@@ -19,7 +19,6 @@ enum prom_major_version {
 	PROM_V2,      /* sun4c and early sun4m V2 prom */
 	PROM_V3,      /* sun4m and later, up to sun4d/sun4e machines V3 */
 	PROM_P1275,   /* IEEE compliant ISA based Sun PROM, only sun4u */
-        PROM_AP1000,  /* actually no prom at all */
 };
 
 extern enum prom_major_version prom_vers;

