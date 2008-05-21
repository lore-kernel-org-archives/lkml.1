Return-Path: <linux-kernel-owner+w=401wt.eu-S1766005AbYEUAeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766005AbYEUAeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764869AbYEUAb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:31:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45309 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185AbYEUAbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:31:52 -0400
To: mchehab@infradead.org
Subject: [PATCH] annotate bcx_riscmem
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Message-Id: <E1JycFD-0004pl-R6@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:31:51 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/video/bt8xx/bttv-risc.c      |    8 +++++---
 drivers/media/video/btcx-risc.c            |    2 +-
 drivers/media/video/btcx-risc.h            |    4 ++--
 drivers/media/video/cx23885/cx23885-core.c |    8 ++++----
 drivers/media/video/cx88/cx88-core.c       |    8 ++++----
 5 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-risc.c b/drivers/media/video/bt8xx/bttv-risc.c
index e5979f7..0af5868 100644
--- a/drivers/media/video/bt8xx/bttv-risc.c
+++ b/drivers/media/video/bt8xx/bttv-risc.c
@@ -48,7 +48,7 @@ bttv_risc_packed(struct bttv *btv, struct btcx_riscmem *risc,
 {
 	u32 instructions,line,todo;
 	struct scatterlist *sg;
-	u32 *rp;
+	__le32 *rp;
 	int rc;
 
 	/* estimate risc mem: worst case is one write per page border +
@@ -128,7 +128,8 @@ bttv_risc_planar(struct bttv *btv, struct btcx_riscmem *risc,
 		 unsigned int cpadding)
 {
 	unsigned int instructions,line,todo,ylen,chroma;
-	u32 *rp,ri;
+	__le32 *rp;
+	u32 ri;
 	struct scatterlist *ysg;
 	struct scatterlist *usg;
 	struct scatterlist *vsg;
@@ -244,7 +245,8 @@ bttv_risc_overlay(struct bttv *btv, struct btcx_riscmem *risc,
 {
 	int dwords,rc,line,maxy,start,end,skip,nskips;
 	struct btcx_skiplist *skips;
-	u32 *rp,ri,ra;
+	__le32 *rp;
+	u32 ri,ra;
 	u32 addr;
 
 	/* skip list for window clipping */
diff --git a/drivers/media/video/btcx-risc.c b/drivers/media/video/btcx-risc.c
index ce0840c..f42701f 100644
--- a/drivers/media/video/btcx-risc.c
+++ b/drivers/media/video/btcx-risc.c
@@ -63,7 +63,7 @@ int btcx_riscmem_alloc(struct pci_dev *pci,
 		       struct btcx_riscmem *risc,
 		       unsigned int size)
 {
-	u32 *cpu;
+	__le32 *cpu;
 	dma_addr_t dma;
 
 	if (NULL != risc->cpu && risc->size < size)
diff --git a/drivers/media/video/btcx-risc.h b/drivers/media/video/btcx-risc.h
index 503e6c6..861bc81 100644
--- a/drivers/media/video/btcx-risc.h
+++ b/drivers/media/video/btcx-risc.h
@@ -2,8 +2,8 @@
  */
 struct btcx_riscmem {
 	unsigned int   size;
-	u32            *cpu;
-	u32            *jmp;
+	__le32         *cpu;
+	__le32         *jmp;
 	dma_addr_t     dma;
 };
 
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index f24abcd..c4cc2f3 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -823,7 +823,7 @@ static void cx23885_dev_unregister(struct cx23885_dev *dev)
 	iounmap(dev->lmmio);
 }
 
-static u32* cx23885_risc_field(u32 *rp, struct scatterlist *sglist,
+static __le32* cx23885_risc_field(__le32 *rp, struct scatterlist *sglist,
 			       unsigned int offset, u32 sync_line,
 			       unsigned int bpl, unsigned int padding,
 			       unsigned int lines)
@@ -883,7 +883,7 @@ int cx23885_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 			unsigned int padding, unsigned int lines)
 {
 	u32 instructions, fields;
-	u32 *rp;
+	__le32 *rp;
 	int rc;
 
 	fields = 0;
@@ -924,7 +924,7 @@ static int cx23885_risc_databuffer(struct pci_dev *pci,
 				   unsigned int lines)
 {
 	u32 instructions;
-	u32 *rp;
+	__le32 *rp;
 	int rc;
 
 	/* estimate risc mem: worst case is one write per page border +
@@ -951,7 +951,7 @@ static int cx23885_risc_databuffer(struct pci_dev *pci,
 int cx23885_risc_stopper(struct pci_dev *pci, struct btcx_riscmem *risc,
 				u32 reg, u32 mask, u32 value)
 {
-	u32 *rp;
+	__le32 *rp;
 	int rc;
 
 	if ((rc = btcx_riscmem_alloc(pci, risc, 4*16)) < 0)
diff --git a/drivers/media/video/cx88/cx88-core.c b/drivers/media/video/cx88/cx88-core.c
index c4d1aff..60eeda3 100644
--- a/drivers/media/video/cx88/cx88-core.c
+++ b/drivers/media/video/cx88/cx88-core.c
@@ -70,7 +70,7 @@ static DEFINE_MUTEX(devlist);
 
 /* @lpi: lines per IRQ, or 0 to not generate irqs. Note: IRQ to be
 	 generated _after_ lpi lines are transferred. */
-static u32* cx88_risc_field(u32 *rp, struct scatterlist *sglist,
+static __le32* cx88_risc_field(__le32 *rp, struct scatterlist *sglist,
 			    unsigned int offset, u32 sync_line,
 			    unsigned int bpl, unsigned int padding,
 			    unsigned int lines, unsigned int lpi)
@@ -130,7 +130,7 @@ int cx88_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 		     unsigned int bpl, unsigned int padding, unsigned int lines)
 {
 	u32 instructions,fields;
-	u32 *rp;
+	__le32 *rp;
 	int rc;
 
 	fields = 0;
@@ -168,7 +168,7 @@ int cx88_risc_databuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 			 unsigned int lines, unsigned int lpi)
 {
 	u32 instructions;
-	u32 *rp;
+	__le32 *rp;
 	int rc;
 
 	/* estimate risc mem: worst case is one write per page border +
@@ -193,7 +193,7 @@ int cx88_risc_databuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 int cx88_risc_stopper(struct pci_dev *pci, struct btcx_riscmem *risc,
 		      u32 reg, u32 mask, u32 value)
 {
-	u32 *rp;
+	__le32 *rp;
 	int rc;
 
 	if ((rc = btcx_riscmem_alloc(pci, risc, 4*16)) < 0)
-- 
1.5.3.GIT


