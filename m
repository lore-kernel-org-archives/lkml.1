Return-Path: <linux-kernel-owner+w=401wt.eu-S932869AbXHASFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbXHASFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756465AbXHASFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:05:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757214AbXHASFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:05:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Enable the MB86943 PCI arbiter correctly
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Wed, 01 Aug 2007 19:04:51 +0100
Message-ID: <20070801180451.25087.54239.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Enable the MB93090 motherboard's MB86943 PCI arbiter correctly by assigning to
the register rather than comparing against it.  This is required to support
bus mastering.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/mb93090-mb00/pci-vdk.c |    3 ++-
 include/asm-frv/mb86943a.h      |    3 +++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/frv/mb93090-mb00/pci-vdk.c b/arch/frv/mb93090-mb00/pci-vdk.c
index 0b581e3..6d51f13 100644
--- a/arch/frv/mb93090-mb00/pci-vdk.c
+++ b/arch/frv/mb93090-mb00/pci-vdk.c
@@ -400,7 +400,8 @@ int __init pcibios_init(void)
 	__reg_MB86943_pci_sl_mem_base	= __region_CS2 + 0x08000000;
 	mb();
 
-	*(volatile unsigned long *)(__region_CS2+0x01300014) == 1;
+	/* enable PCI arbitration */
+	__reg_MB86943_pci_arbiter	= MB86943_PCIARB_EN;
 
 	ioport_resource.start	= (__reg_MB86943_sl_pci_io_base << 9) & 0xfffffc00;
 	ioport_resource.end	= (__reg_MB86943_sl_pci_io_range << 9) | 0x3ff;
diff --git a/include/asm-frv/mb86943a.h b/include/asm-frv/mb86943a.h
index b89fd0b..e87ef92 100644
--- a/include/asm-frv/mb86943a.h
+++ b/include/asm-frv/mb86943a.h
@@ -36,4 +36,7 @@
 #define __reg_MB86943_pci_sl_io_base	*(volatile uint32_t *) (__region_CS1 + 0x70)
 #define __reg_MB86943_pci_sl_mem_base	*(volatile uint32_t *) (__region_CS1 + 0x78)
 
+#define __reg_MB86943_pci_arbiter	*(volatile uint32_t *) (__region_CS2 + 0x01300014)
+#define MB86943_PCIARB_EN		0x00000001
+
 #endif /* _ASM_MB86943A_H */

