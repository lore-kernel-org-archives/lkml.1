Return-Path: <linux-kernel-owner+w=401wt.eu-S1765392AbYD1GBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765392AbYD1GBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758029AbYD1F7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 01:59:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43523 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765520AbYD1F7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 01:59:47 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] celleb_scc_pciex __iomem annotations
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-Id: <E1JqMOv-0004ml-Vo@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 28 Apr 2008 06:59:45 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/powerpc/platforms/cell/celleb_scc_pciex.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/platforms/cell/celleb_scc_pciex.c b/arch/powerpc/platforms/cell/celleb_scc_pciex.c
index ab24d94..31da84c 100644
--- a/arch/powerpc/platforms/cell/celleb_scc_pciex.c
+++ b/arch/powerpc/platforms/cell/celleb_scc_pciex.c
@@ -36,8 +36,8 @@
 #include "celleb_scc.h"
 #include "celleb_pci.h"
 
-#define PEX_IN(base, off)	in_be32((void *)(base) + (off))
-#define PEX_OUT(base, off, data) out_be32((void *)(base) + (off), (data))
+#define PEX_IN(base, off)	in_be32((void __iomem *)(base) + (off))
+#define PEX_OUT(base, off, data) out_be32((void __iomem *)(base) + (off), (data))
 
 static void scc_pciex_io_flush(struct iowa_bus *bus)
 {
@@ -304,7 +304,7 @@ static int __init scc_pciex_iowa_init(struct iowa_bus *bus, void *data)
 	((((0x1 << (size))-1) << ((addr) & 0x3)) << PEXDCMND_BYTE_EN_SHIFT)
 #define MK_PEXDCMND(cmd, addr, size) ((cmd) | MK_PEXDCMND_BYTE_EN(addr, size))
 
-static uint32_t config_read_pciex_dev(unsigned int *base,
+static uint32_t config_read_pciex_dev(unsigned int __iomem *base,
 		uint64_t bus_no, uint64_t dev_no, uint64_t func_no,
 		uint64_t off, uint64_t size)
 {
@@ -320,7 +320,7 @@ static uint32_t config_read_pciex_dev(unsigned int *base,
 	return ret;
 }
 
-static void config_write_pciex_dev(unsigned int *base, uint64_t bus_no,
+static void config_write_pciex_dev(unsigned int __iomem *base, uint64_t bus_no,
 	uint64_t dev_no, uint64_t func_no, uint64_t off, uint64_t size,
 	uint32_t data)
 {
@@ -338,7 +338,7 @@ static void config_write_pciex_dev(unsigned int *base, uint64_t bus_no,
 	((((0x1 << (len)) - 1) << ((off) & 0x3)) << PEXCADRS_BYTE_EN_SHIFT)
 #define MK_PEXCADRS(cmd, addr, size) \
 	((cmd) | MK_PEXCADRS_BYTE_EN(addr, size) | ((addr) & ~0x3))
-static uint32_t config_read_pciex_rc(unsigned int *base,
+static uint32_t config_read_pciex_rc(unsigned int __iomem *base,
 				     uint32_t where, uint32_t size)
 {
 	PEX_OUT(base, PEXCADRS, MK_PEXCADRS(PEXCADRS_CMD_READ, where, size));
@@ -346,7 +346,7 @@ static uint32_t config_read_pciex_rc(unsigned int *base,
 		>> ((where & (4 - size)) * 8)) & ((0x1 << (size * 8)) - 1);
 }
 
-static void config_write_pciex_rc(unsigned int *base, uint32_t where,
+static void config_write_pciex_rc(unsigned int __iomem *base, uint32_t where,
 				  uint32_t size, uint32_t val)
 {
 	uint32_t data;
@@ -410,7 +410,7 @@ static struct pci_ops scc_pciex_pci_ops = {
 	scc_pciex_write_config,
 };
 
-static void pciex_clear_intr_all(unsigned int *base)
+static void pciex_clear_intr_all(unsigned int __iomem *base)
 {
 	PEX_OUT(base, PEXAERRSTS, 0xffffffff);
 	PEX_OUT(base, PEXPRERRSTS, 0xffffffff);
@@ -427,7 +427,7 @@ static void pciex_disable_intr_all(unsigned int *base)
 }
 #endif
 
-static void pciex_enable_intr_all(unsigned int *base)
+static void pciex_enable_intr_all(unsigned int __iomem *base)
 {
 	PEX_OUT(base, PEXINTMASK, 0x0000e7f1);
 	PEX_OUT(base, PEXAERRMASK, 0x03ff01ff);
@@ -435,7 +435,7 @@ static void pciex_enable_intr_all(unsigned int *base)
 	PEX_OUT(base, PEXVDMASK, 0x00000001);
 }
 
-static void pciex_check_status(unsigned int *base)
+static void pciex_check_status(unsigned int __iomem *base)
 {
 	uint32_t err = 0;
 	uint32_t intsts, aerr, prerr, rcvcp, lenerr;
-- 
1.5.3.GIT


