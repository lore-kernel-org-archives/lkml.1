Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbYJWSeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbYJWSeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 14:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYJWSdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 14:33:38 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43695 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753212AbYJWSdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 14:33:36 -0400
Date: Thu, 23 Oct 2008 13:33:35 -0500
From: Dean Nelson <dcn@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sgi-xp: only build for ia64-sn2 when CONFIG_IA64_GENERIC specified v.2
Message-ID: <20081023183335.GA24139@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the time being build for ia64-sn2 alone when CONFIG_IA64_GENERIC is
specified.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 drivers/misc/sgi-xp/Makefile   |    4 ++--
 drivers/misc/sgi-xp/xp.h       |    4 ++++
 drivers/misc/sgi-xp/xpc_main.c |    4 ++--
 3 files changed, 8 insertions(+), 4 deletions(-)

Index: linux/drivers/misc/sgi-xp/Makefile
===================================================================
--- linux.orig/drivers/misc/sgi-xp/Makefile	2008-10-23 10:59:42.000000000 -0500
+++ linux/drivers/misc/sgi-xp/Makefile	2008-10-23 10:59:44.000000000 -0500
@@ -5,14 +5,14 @@
 obj-$(CONFIG_SGI_XP)		+= xp.o
 xp-y				:= xp_main.o
 xp-$(CONFIG_IA64_SGI_SN2)	+= xp_sn2.o xp_nofault.o
-xp-$(CONFIG_IA64_GENERIC)	+= xp_sn2.o xp_nofault.o xp_uv.o
+xp-$(CONFIG_IA64_GENERIC)	+= xp_sn2.o xp_nofault.o
 xp-$(CONFIG_IA64_SGI_UV)	+= xp_uv.o
 xp-$(CONFIG_X86_64)		+= xp_uv.o
 
 obj-$(CONFIG_SGI_XP)		+= xpc.o
 xpc-y				:= xpc_main.o xpc_channel.o xpc_partition.o
 xpc-$(CONFIG_IA64_SGI_SN2)	+= xpc_sn2.o
-xpc-$(CONFIG_IA64_GENERIC)	+= xpc_sn2.o xpc_uv.o
+xpc-$(CONFIG_IA64_GENERIC)	+= xpc_sn2.o
 xpc-$(CONFIG_IA64_SGI_UV) 	+= xpc_uv.o
 xpc-$(CONFIG_X86_64)		+= xpc_uv.o
 
Index: linux/drivers/misc/sgi-xp/xp.h
===================================================================
--- linux.orig/drivers/misc/sgi-xp/xp.h	2008-10-23 10:59:42.000000000 -0500
+++ linux/drivers/misc/sgi-xp/xp.h	2008-10-23 10:59:44.000000000 -0500
@@ -19,7 +19,11 @@
 #include <asm/system.h>
 #include <asm/sn/arch.h>	/* defines is_shub1() and is_shub2() */
 #define is_shub()	ia64_platform_is("sn2")
+#ifdef CONFIG_IA64_SGI_UV
 #define is_uv()		ia64_platform_is("uv")
+#else
+#define is_uv()		0
+#endif
 #endif
 #ifdef CONFIG_X86_64
 #include <asm/genapic.h>
Index: linux/drivers/misc/sgi-xp/xpc_main.c
===================================================================
--- linux.orig/drivers/misc/sgi-xp/xpc_main.c	2008-10-23 10:59:42.000000000 -0500
+++ linux/drivers/misc/sgi-xp/xpc_main.c	2008-10-23 10:59:44.000000000 -0500
@@ -1104,7 +1104,7 @@ xpc_do_exit(enum xp_retval reason)
 
 	if (is_shub())
 		xpc_exit_sn2();
-	else
+	else if (is_uv())
 		xpc_exit_uv();
 }
 
@@ -1363,7 +1363,7 @@ out_2:
 out_1:
 	if (is_shub())
 		xpc_exit_sn2();
-	else
+	else if (is_uv())
 		xpc_exit_uv();
 	return ret;
 }
