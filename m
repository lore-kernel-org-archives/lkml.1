Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab0BEOhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 09:37:23 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:56967 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab0BEOhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:37:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=d0V1mNoQvK+70tK3pxrX4qDy4sN+qQrAGLPkLYIR9U0kLwSEHcAPNI6H6DEmdJ0PzS
         GfznDBfFPMe58UjjZvbHCwo6MXlDstWtGBcs66/kVWfvGjDSaVcPht/kl4XHC6xiY9rx
         qs7zCHMYjG29nRSJiTIjRr5VYkgBEQ+noGQsE=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] x86-32: Move XQUAD definitions to numaq.h
Date: Fri,  5 Feb 2010 09:37:03 -0500
Message-Id: <1265380629-3212-2-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265380629-3212-1-git-send-email-brgerst@gmail.com>
References: <1265380629-3212-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/io_32.h |    3 ---
 arch/x86/include/asm/numaq.h |    4 ++++
 arch/x86/pci/numaq_32.c      |    6 +-----
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/io_32.h b/arch/x86/include/asm/io_32.h
index a299900..e16b9db 100644
--- a/arch/x86/include/asm/io_32.h
+++ b/arch/x86/include/asm/io_32.h
@@ -37,9 +37,6 @@
   *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
   */
 
-#define XQUAD_PORTIO_BASE 0xfe400000
-#define XQUAD_PORTIO_QUAD 0x40000  /* 256k per quad. */
-
 #ifdef __KERNEL__
 
 #include <asm-generic/iomap.h>
diff --git a/arch/x86/include/asm/numaq.h b/arch/x86/include/asm/numaq.h
index 9f0a5f5..13370b9 100644
--- a/arch/x86/include/asm/numaq.h
+++ b/arch/x86/include/asm/numaq.h
@@ -33,6 +33,10 @@ extern int get_memcfg_numaq(void);
 
 extern void *xquad_portio;
 
+#define XQUAD_PORTIO_BASE 0xfe400000
+#define XQUAD_PORTIO_QUAD 0x40000  /* 256k per quad. */
+#define XQUAD_PORT_ADDR(port, quad) (xquad_portio + (XQUAD_PORTIO_QUAD*quad) + port)
+
 /*
  * SYS_CFG_DATA_PRIV_ADDR, struct eachquadmem, and struct sys_cfg_data are the
  */
diff --git a/arch/x86/pci/numaq_32.c b/arch/x86/pci/numaq_32.c
index 8eb295e..8884a1c 100644
--- a/arch/x86/pci/numaq_32.c
+++ b/arch/x86/pci/numaq_32.c
@@ -8,9 +8,7 @@
 #include <asm/apic.h>
 #include <asm/mpspec.h>
 #include <asm/pci_x86.h>
-
-#define XQUAD_PORTIO_BASE 0xfe400000
-#define XQUAD_PORTIO_QUAD 0x40000  /* 256k per quad. */
+#include <asm/numaq.h>
 
 #define BUS2QUAD(global) (mp_bus_id_to_node[global])
 
@@ -18,8 +16,6 @@
 
 #define QUADLOCAL2BUS(quad,local) (quad_local_to_mp_bus_id[quad][local])
 
-#define XQUAD_PORT_ADDR(port, quad) (xquad_portio + (XQUAD_PORTIO_QUAD*quad) + port)
-
 #define PCI_CONF1_MQ_ADDRESS(bus, devfn, reg) \
 	(0x80000000 | (BUS2LOCAL(bus) << 16) | (devfn << 8) | (reg & ~3))
 
-- 
1.6.6

