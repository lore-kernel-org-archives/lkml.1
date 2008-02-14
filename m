Return-Path: <linux-kernel-owner+w=401wt.eu-S934760AbYBNAYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934760AbYBNAYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934278AbYBNAWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:22:18 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:4277 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934178AbYBNAWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:22:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=P+idfu8R/aICJAribkSuZVXLGzwp8olOX0IF7yGNj6xIyyEPLx6FHEFQyEwn5IINlaZ0RwwuHzNb1gscRyo/er3ZZQuOyhtYfhhfOq5eveSNdxJBdSicJopPKjOg6Oi0XjzveMnlgQhVbBM7PjhjkR4muOSinY2m8cFYyPNCry8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2008 01:36:42 +0100
Message-Id: <20080214003642.12879.73252.sendpatchset@localhost.localdomain>
In-Reply-To: <20080214003621.12879.33868.sendpatchset@localhost.localdomain>
References: <20080214003621.12879.33868.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/11] ppc/ppc4xx: remove ppc_ide_md hooks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no "default" IDE ports on PPC4xx so ppc4xx_ide_init_hwif_ports() is
unnecessary, remove it.  Also remove no longer needed <linux/ide.h> include.

There should be no functional changes caused by this patch.

Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 arch/ppc/syslib/ppc4xx_setup.c |   23 -----------------------
 1 file changed, 23 deletions(-)

Index: b/arch/ppc/syslib/ppc4xx_setup.c
===================================================================
--- a/arch/ppc/syslib/ppc4xx_setup.c
+++ b/arch/ppc/syslib/ppc4xx_setup.c
@@ -24,7 +24,6 @@
 #include <linux/pci.h>
 #include <linux/rtc.h>
 #include <linux/console.h>
-#include <linux/ide.h>
 #include <linux/serial_reg.h>
 #include <linux/seq_file.h>
 
@@ -189,24 +188,6 @@ ppc4xx_calibrate_decr(void)
 	mtspr(SPRN_PIT, tb_ticks_per_jiffy);
 }
 
-/*
- * IDE stuff.
- * should be generic for every IDE PCI chipset
- */
-#if defined(CONFIG_PCI) && defined(CONFIG_IDE)
-static void
-ppc4xx_ide_init_hwif_ports(hw_regs_t * hw, unsigned long data_port,
-			   unsigned long ctrl_port, int *irq)
-{
-	int i;
-
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; ++i)
-		hw->io_ports[i] = data_port + i - IDE_DATA_OFFSET;
-
-	hw->io_ports[IDE_CONTROL_OFFSET] = ctrl_port;
-}
-#endif /* defined(CONFIG_PCI) && defined(CONFIG_IDE) */
-
 TODC_ALLOC();
 
 /*
@@ -271,10 +252,6 @@ ppc4xx_init(unsigned long r3, unsigned l
 #ifdef CONFIG_SERIAL_TEXT_DEBUG
 	ppc_md.progress = gen550_progress;
 #endif
-
-#if defined(CONFIG_PCI) && defined(CONFIG_IDE)
-	ppc_ide_md.ide_init_hwif = ppc4xx_ide_init_hwif_ports;
-#endif /* defined(CONFIG_PCI) && defined(CONFIG_IDE) */
 }
 
 /* Called from machine_check_exception */
