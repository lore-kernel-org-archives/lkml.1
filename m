Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbYKLOfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbYKLOfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 09:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYKLOfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 09:35:43 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:42024 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbYKLOfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 09:35:42 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging/wlan-ng: kill WLAN_CPU_FAMILY and WLAN_SYSARCH
Date: Wed, 12 Nov 2008 09:35:40 -0500
Message-Id: <1226500540-9667-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WLAN_CPU_FAMILY and WLAN_SYSARCH defines are used in all of three places
(two of which look pretty suspect), so just kill them off rather than
throwing up a pointless #error on processors that are not in the existing
list.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/staging/wlan-ng/prism2_cs.c   |    8 ---
 drivers/staging/wlan-ng/wlan_compat.h |   85 ++-------------------------------
 2 files changed, 4 insertions(+), 89 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2_cs.c b/drivers/staging/wlan-ng/prism2_cs.c
index 63ce565..e221b1d 100644
--- a/drivers/staging/wlan-ng/prism2_cs.c
+++ b/drivers/staging/wlan-ng/prism2_cs.c
@@ -4,14 +4,6 @@
 #include "prism2mib.c"
 #include "prism2sta.c"
 
-#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,4,21) )
-#if (WLAN_CPU_FAMILY == WLAN_Ix86)
-#ifndef CONFIG_ISA
-#warning "You may need to enable ISA support in your kernel."
-#endif
-#endif
-#endif
-
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,11) )
 static u_int	irq_mask = 0xdeb8;		/* Interrupt mask */
 static int	irq_list[4] = { -1 };		/* Interrupt list */
diff --git a/drivers/staging/wlan-ng/wlan_compat.h b/drivers/staging/wlan-ng/wlan_compat.h
index 59dfa8f..b0cc670 100644
--- a/drivers/staging/wlan-ng/wlan_compat.h
+++ b/drivers/staging/wlan-ng/wlan_compat.h
@@ -51,92 +51,14 @@
 /*=============================================================*/
 /*------ Establish Platform Identity --------------------------*/
 /*=============================================================*/
-/* Key macros: */
-/* WLAN_CPU_FAMILY */
-	#define WLAN_Ix86			1
-	#define WLAN_PPC			2
-	#define WLAN_Ix96			3
-	#define WLAN_ARM			4
-	#define WLAN_ALPHA			5
-	#define WLAN_MIPS			6
-	#define WLAN_HPPA			7
-	#define WLAN_SPARC			8
-	#define WLAN_SH    			9
-	#define WLAN_x86_64                     10
-/* WLAN_SYSARCH */
-	#define WLAN_PCAT			1
-	#define WLAN_MBX			2
-	#define WLAN_RPX			3
-	#define WLAN_LWARCH			4
-	#define WLAN_PMAC			5
-	#define WLAN_SKIFF			6
-	#define WLAN_BITSY			7
-	#define WLAN_ALPHAARCH			7
-	#define WLAN_MIPSARCH			9
-	#define WLAN_HPPAARCH			10
-	#define WLAN_SPARCARCH			11
-	#define WLAN_SHARCH   			12
 
 /* Note: the PLX HOSTIF above refers to some vendors implementations for */
 /*       PCI.  It's a PLX chip that is a PCI to PCMCIA adapter, but it   */
 /*       isn't a real PCMCIA host interface adapter providing all the    */
 /*       card&socket services.                                           */
 
-#if (defined(CONFIG_PPC) || defined(CONFIG_8xx) || defined(__powerpc__))
-#ifndef __ppc__
-#define __ppc__
-#endif
-#endif
-
 #if defined(__KERNEL__)
 
-#ifndef AUTOCONF_INCLUDED
-#include <linux/config.h>
-#endif
-
-#if defined(__x86_64__)
-	#define WLAN_CPU_FAMILY		WLAN_x86_64
-	#define WLAN_SYSARCH		WLAN_PCAT
-#elif defined(__i386__) || defined(__i486__) || defined(__i586__) || defined(__i686__)
-	#define WLAN_CPU_FAMILY		WLAN_Ix86
-	#define WLAN_SYSARCH		WLAN_PCAT
-#elif defined(__ppc__)
-	#define WLAN_CPU_FAMILY		WLAN_PPC
-	#if defined(CONFIG_MBX)
-		#define WLAN_SYSARCH	WLAN_MBX
-	#elif defined(CONFIG_RPXLITE)
-		#define WLAN_SYSARCH	WLAN_RPX
-	#elif defined(CONFIG_RPXCLASSIC)
-		#define WLAN_SYSARCH	WLAN_RPX
-	#else
-		#define WLAN_SYSARCH	WLAN_PMAC
-	#endif
-#elif defined(__arm__)
-	#define WLAN_CPU_FAMILY		WLAN_ARM
-	#define WLAN_SYSARCH		WLAN_SKIFF
-#elif defined(__alpha__)
-	#define WLAN_CPU_FAMILY		WLAN_ALPHA
-	#define WLAN_SYSARCH		WLAN_ALPHAARCH
-#elif defined(__mips__)
-	#define WLAN_CPU_FAMILY		WLAN_MIPS
-	#define WLAN_SYSARCH		WLAN_MIPSARCH
-#elif defined(__hppa__)
-	#define WLAN_CPU_FAMILY		WLAN_HPPA
-	#define WLAN_SYSARCH		WLAN_HPPAARCH
-#elif defined(__sparc__)
-        #define WLAN_CPU_FAMILY         WLAN_SPARC
-        #define WLAN_SYSARCH            WLAN_SPARC
-#elif defined(__sh__)
-        #define WLAN_CPU_FAMILY         WLAN_SH
-        #define WLAN_SYSARCH            WLAN_SHARCH
-        #ifndef __LITTLE_ENDIAN__
-        #define __LITTLE_ENDIAN__
-        #endif
-#else
-	#error "No CPU identified!"
-#endif
-#endif /* __KERNEL__ */
-
 /*
    Some big endian machines implicitly do all I/O in little endian mode.
 
@@ -150,7 +72,8 @@
 
 #if defined(WLAN_HOSTIF)
 #if ((WLAN_HOSTIF == WLAN_PCI) || (WLAN_HOSTIF == WLAN_PLX))
-#if ((WLAN_SYSARCH == WLAN_SKIFF) || (WLAN_SYSARCH == WLAN_PMAC) || (WLAN_SYSARCH == WLAN_SPARC))
+#if defined(__arm__) || defined(__sparc__) || \
+    (defined(__powerpc__) && !defined(CONFIG_MBX) && !defined(CONFIG_RPXLITE) && !defined(CONFIG_RPXCLASSIC))
 #define REVERSE_ENDIAN
 #endif
 #endif
@@ -692,11 +615,11 @@ typedef u32 pm_message_t;
 #define host2ieee16(n)	__cpu_to_le16(n)
 #define host2ieee32(n)	__cpu_to_le32(n)
 
-#if (WLAN_CPU_FAMILY != WLAN_MIPS)
+#if !defined(__mips__)
 typedef UINT32 phys_t;
 #endif
 
-#if (WLAN_CPU_FAMILY == WLAN_PPC)
+#if defined(__powerpc__)
        #define wlan_inw(a)                     in_be16((unsigned short *)((a)+_IO_BASE))
        #define wlan_inw_le16_to_cpu(a)         inw((a))
        #define wlan_outw(v,a)                  out_be16((unsigned short *)((a)+_IO_BASE), (v))
-- 
1.6.0.3

