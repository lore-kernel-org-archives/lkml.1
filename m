Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489Ab0A3Tt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab0A3Tt6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 14:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395Ab0A3Ttz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 14:49:55 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:50554 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab0A3Ttx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 14:49:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=JDA5b5xLtPGaEVACneCb7LbhHv9PkylZ60T2VbE13Rmt7BqBJqtXecU7lXYYKc8J3l
         Y1N1ZJ2NVYP7oTlyriNQzoGVTv4SbrNwsyNvTY0Dnm5MfBKQ2D5s4zljL3saVUcWgmjM
         2SuX4dhC2E06mRlYuWs7VUc52LXrI4zIvCYSU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 30 Jan 2010 20:49:44 +0100
Message-Id: <20100130194944.30779.95951.sendpatchset@localhost>
In-Reply-To: <20100130194918.30779.25485.sendpatchset@localhost>
References: <20100130194918.30779.25485.sendpatchset@localhost>
Subject: [PATCH 4/9] [ata_]piix: move documentation to ata_piix.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] [ata_]piix: move documentation to ata_piix.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/ata_piix.c |   45 ---------------------------------------------
 drivers/ata/ata_piix.h |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/piix.c     |   37 -------------------------------------
 3 files changed, 46 insertions(+), 82 deletions(-)

Index: b/drivers/ata/ata_piix.c
===================================================================
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -36,51 +36,6 @@
  *  as Documentation/DocBook/libata.*
  *
  *  Hardware documentation available at http://developer.intel.com/
- *
- * Documentation
- *	Publically available from Intel web site. Errata documentation
- * is also publically available. As an aide to anyone hacking on this
- * driver the list of errata that are relevant is below, going back to
- * PIIX4. Older device documentation is now a bit tricky to find.
- *
- * The chipsets all follow very much the same design. The orginal Triton
- * series chipsets do _not_ support independant device timings, but this
- * is fixed in Triton II. With the odd mobile exception the chips then
- * change little except in gaining more modes until SATA arrives. This
- * driver supports only the chips with independant timing (that is those
- * with SITRE and the 0x44 timing register). See pata_oldpiix and pata_mpiix
- * for the early chip drivers.
- *
- * Errata of note:
- *
- * Unfixable
- *	PIIX4    errata #9	- Only on ultra obscure hw
- *	ICH3	 errata #13     - Not observed to affect real hw
- *				  by Intel
- *
- * Things we must deal with
- *	PIIX4	errata #10	- BM IDE hang with non UDMA
- *				  (must stop/start dma to recover)
- *	440MX   errata #15	- As PIIX4 errata #10
- *	PIIX4	errata #15	- Must not read control registers
- * 				  during a PIO transfer
- *	440MX   errata #13	- As PIIX4 errata #15
- *	ICH2	errata #21	- DMA mode 0 doesn't work right
- *	ICH0/1  errata #55	- As ICH2 errata #21
- *	ICH2	spec c #9	- Extra operations needed to handle
- *				  drive hotswap [NOT YET SUPPORTED]
- *	ICH2    spec c #20	- IDE PRD must not cross a 64K boundary
- *				  and must be dword aligned
- *	ICH2    spec c #24	- UDMA mode 4,5 t85/86 should be 6ns not 3.3
- *	ICH7	errata #16	- MWDMA1 timings are incorrect
- *
- * Should have been BIOS fixed:
- *	450NX:	errata #19	- DMA hangs on old 450NX
- *	450NX:  errata #20	- DMA hangs on old 450NX
- *	450NX:  errata #25	- Corruption with DMA on old 450NX
- *	ICH3    errata #15      - IDE deadlock under high load
- *				  (BIOS must set dev 31 fn 0 bit 23)
- *	ICH3	errata #18	- Don't use native mode
  */
 
 #include <linux/kernel.h>
Index: b/drivers/ata/ata_piix.h
===================================================================
--- a/drivers/ata/ata_piix.h
+++ b/drivers/ata/ata_piix.h
@@ -1,3 +1,49 @@
+/*
+ * Documentation:
+ *	Publically available from Intel web site. Errata documentation
+ * is also publically available. As an aide to anyone hacking on this
+ * driver the list of errata that are relevant is below, going back to
+ * PIIX4. Older device documentation is now a bit tricky to find.
+ *
+ * The chipsets all follow very much the same design. The orginal Triton
+ * series chipsets do _not_ support independant device timings, but this
+ * is fixed in Triton II. With the odd mobile exception the chips then
+ * change little except in gaining more modes until SATA arrives. This
+ * driver supports only the chips with independant timing (that is those
+ * with SITRE and the 0x44 timing register). See pata_oldpiix and pata_mpiix
+ * for the early chip drivers.
+ *
+ * Errata of note:
+ *
+ * Unfixable
+ *	PIIX4    errata #9	- Only on ultra obscure hw
+ *	ICH3	 errata #13     - Not observed to affect real hw
+ *				  by Intel
+ *
+ * Things we must deal with
+ *	PIIX4	errata #10	- BM IDE hang with non UDMA
+ *				  (must stop/start dma to recover)
+ *	440MX   errata #15	- As PIIX4 errata #10
+ *	PIIX4	errata #15	- Must not read control registers
+ * 				  during a PIO transfer
+ *	440MX   errata #13	- As PIIX4 errata #15
+ *	ICH2	errata #21	- DMA mode 0 doesn't work right
+ *	ICH0/1  errata #55	- As ICH2 errata #21
+ *	ICH2	spec c #9	- Extra operations needed to handle
+ *				  drive hotswap [NOT YET SUPPORTED]
+ *	ICH2    spec c #20	- IDE PRD must not cross a 64K boundary
+ *				  and must be dword aligned
+ *	ICH2    spec c #24	- UDMA mode 4,5 t85/86 should be 6ns not 3.3
+ *	ICH7	errata #16	- MWDMA1 timings are incorrect
+ *
+ * Should have been BIOS fixed:
+ *	450NX:	errata #19	- DMA hangs on old 450NX
+ *	450NX:  errata #20	- DMA hangs on old 450NX
+ *	450NX:  errata #25	- Corruption with DMA on old 450NX
+ *	ICH3    errata #15      - IDE deadlock under high load
+ *				  (BIOS must set dev 31 fn 0 bit 23)
+ *	ICH3	errata #18	- Don't use native mode
+ */
 
 struct ich_laptop {
 	u16 device;
Index: b/drivers/ide/piix.c
===================================================================
--- a/drivers/ide/piix.c
+++ b/drivers/ide/piix.c
@@ -5,43 +5,6 @@
  *  Copyright (C) 2006-2007 MontaVista Software, Inc. <source@mvista.com>
  *
  *  May be copied or modified under the terms of the GNU General Public License
- *
- * Documentation:
- *
- *	Publically available from Intel web site. Errata documentation
- * is also publically available. As an aide to anyone hacking on this
- * driver the list of errata that are relevant is below.going back to
- * PIIX4. Older device documentation is now a bit tricky to find.
- *
- * Errata of note:
- *
- * Unfixable
- *	PIIX4    errata #9	- Only on ultra obscure hw
- *	ICH3	 errata #13     - Not observed to affect real hw
- *				  by Intel
- *
- * Things we must deal with
- *	PIIX4	errata #10	- BM IDE hang with non UDMA
- *				  (must stop/start dma to recover)
- *	440MX   errata #15	- As PIIX4 errata #10
- *	PIIX4	errata #15	- Must not read control registers
- * 				  during a PIO transfer
- *	440MX   errata #13	- As PIIX4 errata #15
- *	ICH2	errata #21	- DMA mode 0 doesn't work right
- *	ICH0/1  errata #55	- As ICH2 errata #21
- *	ICH2	spec c #9	- Extra operations needed to handle
- *				  drive hotswap [NOT YET SUPPORTED]
- *	ICH2    spec c #20	- IDE PRD must not cross a 64K boundary
- *				  and must be dword aligned
- *	ICH2    spec c #24	- UDMA mode 4,5 t85/86 should be 6ns not 3.3
- *
- * Should have been BIOS fixed:
- *	450NX:	errata #19	- DMA hangs on old 450NX
- *	450NX:  errata #20	- DMA hangs on old 450NX
- *	450NX:  errata #25	- Corruption with DMA on old 450NX
- *	ICH3    errata #15      - IDE deadlock under high load
- *				  (BIOS must set dev 31 fn 0 bit 23)
- *	ICH3	errata #18	- Don't use native mode
  */
 
 #include <linux/types.h>
