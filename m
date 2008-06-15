Return-Path: <linux-kernel-owner+w=401wt.eu-S1759607AbYFOQQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607AbYFOQQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 12:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759227AbYFOQPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 12:15:07 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:42548 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759059AbYFOQO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 12:14:59 -0400
Date: Sun, 15 Jun 2008 19:13:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: kyle@mcmartin.ca, matthew@wil.cx, grundler@parisc-linux.org
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/parisc/: make code static
Message-ID: <20080615161341.GF7865@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global code static:
- asp.c: asp_init_chip()
- ccio-dma.c: ccio_io_pdir_entry()
- dino.c: struct dino_port_ops
- dino.c: struct dino_bios_ops
- hppb.c: struct hppb_card_head
- lasi.c: lasi_led_init()
- lasi.c: lasi_init_chip()
- lba_pci.c: struct lba_bios_ops
- sba_iommu.c: sba_io_pdir_entry()
- sba_iommu.c: sba_driver_callback()
- sba_iommu.c: sba_driver_callback()
- wax.c: wax_init_chip()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/parisc/asp.c       |    3 +--
 drivers/parisc/ccio-dma.c  |    2 +-
 drivers/parisc/dino.c      |    4 ++--
 drivers/parisc/hppb.c      |    2 +-
 drivers/parisc/lasi.c      |    5 ++---
 drivers/parisc/lba_pci.c   |    2 +-
 drivers/parisc/sba_iommu.c |    7 +++----
 drivers/parisc/wax.c       |    3 +--
 8 files changed, 12 insertions(+), 16 deletions(-)

78e10083d054032afa9979cae16c10d54d366855 diff --git a/drivers/parisc/asp.c b/drivers/parisc/asp.c
index 8213691..7931133 100644
--- a/drivers/parisc/asp.c
+++ b/drivers/parisc/asp.c
@@ -71,8 +71,7 @@ static void asp_choose_irq(struct parisc_device *dev, void *ctrl)
  */
 #define ASP_INTERRUPT_ADDR 0xf0800000
 
-int __init
-asp_init_chip(struct parisc_device *dev)
+static int __init asp_init_chip(struct parisc_device *dev)
 {
 	struct gsc_irq gsc_irq;
 	int ret;
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index b30e38f..898f69e 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -564,7 +564,7 @@ static u32 hint_lookup[] = {
  * (Load Coherence Index) instruction.  The 8 bits used for the virtual
  * index are bits 12:19 of the value returned by LCI.
  */ 
-void CCIO_INLINE
+static void CCIO_INLINE
 ccio_io_pdir_entry(u64 *pdir_ptr, space_t sid, unsigned long vba,
 		   unsigned long hints)
 {
diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index fd56128..ada21b0 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -287,7 +287,7 @@ DINO_PORT_OUT(b,  8, 3)
 DINO_PORT_OUT(w, 16, 2)
 DINO_PORT_OUT(l, 32, 0)
 
-struct pci_port_ops dino_port_ops = {
+static struct pci_port_ops dino_port_ops = {
 	.inb	= dino_in8,
 	.inw	= dino_in16,
 	.inl	= dino_in32,
@@ -688,7 +688,7 @@ dino_fixup_bus(struct pci_bus *bus)
 }
 
 
-struct pci_bios_ops dino_bios_ops = {
+static struct pci_bios_ops dino_bios_ops = {
 	.init		= dino_bios_init,
 	.fixup_bus	= dino_fixup_bus
 };
diff --git a/drivers/parisc/hppb.c b/drivers/parisc/hppb.c
index 65eee67..1385641 100644
--- a/drivers/parisc/hppb.c
+++ b/drivers/parisc/hppb.c
@@ -29,7 +29,7 @@ struct hppb_card {
 	struct hppb_card *next;
 };
 
-struct hppb_card hppb_card_head = {
+static struct hppb_card hppb_card_head = {
 	.hpa = 0,
 	.next = NULL,
 };
diff --git a/drivers/parisc/lasi.c b/drivers/parisc/lasi.c
index bee5100..e65727c 100644
--- a/drivers/parisc/lasi.c
+++ b/drivers/parisc/lasi.c
@@ -107,7 +107,7 @@ lasi_init_irq(struct gsc_asic *this_lasi)
 
 #else
 
-void __init lasi_led_init(unsigned long lasi_hpa)
+static void __init lasi_led_init(unsigned long lasi_hpa)
 {
 	unsigned long datareg;
 
@@ -163,8 +163,7 @@ static void lasi_power_off(void)
 	gsc_writel(0x02, datareg);
 }
 
-int __init
-lasi_init_chip(struct parisc_device *dev)
+static int __init lasi_init_chip(struct parisc_device *dev)
 {
 	extern void (*chassis_power_off)(void);
 	struct gsc_asic *lasi;
diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index a28c894..d8233de 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -824,7 +824,7 @@ lba_fixup_bus(struct pci_bus *bus)
 }
 
 
-struct pci_bios_ops lba_bios_ops = {
+static struct pci_bios_ops lba_bios_ops = {
 	.init =		lba_bios_init,
 	.fixup_bus =	lba_fixup_bus,
 };
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index bc73b96..34763e2 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -561,7 +561,7 @@ typedef unsigned long space_t;
  * IOMMU uses little endian for the pdir.
  */
 
-void SBA_INLINE
+static void SBA_INLINE
 sba_io_pdir_entry(u64 *pdir_ptr, space_t sid, unsigned long vba,
 		  unsigned long hint)
 {
@@ -1874,7 +1874,7 @@ static struct parisc_device_id sba_tbl[] = {
 	{ 0, }
 };
 
-int sba_driver_callback(struct parisc_device *);
+static int sba_driver_callback(struct parisc_device *);
 
 static struct parisc_driver sba_driver = {
 	.name =		MODULE_NAME,
@@ -1887,8 +1887,7 @@ static struct parisc_driver sba_driver = {
 ** If so, initialize the chip and tell other partners in crime they
 ** have work to do.
 */
-int
-sba_driver_callback(struct parisc_device *dev)
+static int sba_driver_callback(struct parisc_device *dev)
 {
 	struct sba_device *sba_dev;
 	u32 func_class;
diff --git a/drivers/parisc/wax.c b/drivers/parisc/wax.c
index 892a83b..da9d5ad 100644
--- a/drivers/parisc/wax.c
+++ b/drivers/parisc/wax.c
@@ -68,8 +68,7 @@ wax_init_irq(struct gsc_asic *wax)
 //	gsc_writel(0xFFFFFFFF, base+0x2000); /* RS232-B on Wax */
 }
 
-int __init
-wax_init_chip(struct parisc_device *dev)
+static int __init wax_init_chip(struct parisc_device *dev)
 {
 	struct gsc_asic *wax;
 	struct parisc_device *parent;

