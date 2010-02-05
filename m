Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934040Ab0BEWtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 17:49:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:37603 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933959Ab0BEWtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 17:49:09 -0500
Date: Fri, 5 Feb 2010 22:48:45 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1265380629-3212-2-git-send-email-brgerst@gmail.com>
References: <1265380629-3212-2-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/io] x86-32: Move XQUAD definitions to numaq.h
Message-ID: <tip-5c64c7019e571a726f4aa9c1896402c15391a8ed@git.kernel.org>
Git-Commit-ID: 5c64c7019e571a726f4aa9c1896402c15391a8ed
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Feb 2010 22:48:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c64c7019e571a726f4aa9c1896402c15391a8ed
Gitweb:     http://git.kernel.org/tip/5c64c7019e571a726f4aa9c1896402c15391a8ed
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Fri, 5 Feb 2010 09:37:03 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 5 Feb 2010 13:57:12 -0800

x86-32: Move XQUAD definitions to numaq.h

The XQUAD stuff is part of the NUMAQ architecture, so move it there.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1265380629-3212-2-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
 
