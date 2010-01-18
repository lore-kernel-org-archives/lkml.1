Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009Ab0ARRX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab0ARRX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559Ab0ARRXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:23:52 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:34219 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab0ARRXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:23:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=lRzkhHq/WlyNE1n+g2Qvda/5DNsCvCsUsu02qXnj7B/eXUey2DmTNjnTGU1sgPQARO
         r/+3Nz6c+N60CFSb4GT2k9HNgYxb8AkDKvMTyFT5V2jcTDivxm2sIAoh9RapHE/UQCL3
         Q0Ha64Eak8LtP78uocm2h1A2AbEtfmmACYneM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:22:38 +0100
Message-Id: <20100118172238.14623.41430.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 64/64] ide: make ide_get_best_pio_mode() static
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: make ide_get_best_pio_mode() static

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-xfer-mode.c |    3 +--
 include/linux/ide.h         |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

Index: b/drivers/ide/ide-xfer-mode.c
===================================================================
--- a/drivers/ide/ide-xfer-mode.c
+++ b/drivers/ide/ide-xfer-mode.c
@@ -58,7 +58,7 @@ EXPORT_SYMBOL(ide_xfer_verbose);
  *	This is used by most chipset support modules when "auto-tuning".
  */
 
-u8 ide_get_best_pio_mode(ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
+static u8 ide_get_best_pio_mode(ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
 {
 	u16 *id = drive->id;
 	int pio_mode = -1, overridden = 0;
@@ -105,7 +105,6 @@ u8 ide_get_best_pio_mode(ide_drive_t *dr
 
 	return pio_mode;
 }
-EXPORT_SYMBOL_GPL(ide_get_best_pio_mode);
 
 int ide_pio_need_iordy(ide_drive_t *drive, const u8 pio)
 {
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1496,7 +1496,6 @@ int ide_timing_compute(ide_drive_t *, u8
 #ifdef CONFIG_IDE_XFER_MODE
 int ide_scan_pio_blacklist(char *);
 const char *ide_xfer_verbose(u8);
-u8 ide_get_best_pio_mode(ide_drive_t *, u8, u8);
 int ide_pio_need_iordy(ide_drive_t *, const u8);
 int ide_set_pio_mode(ide_drive_t *, u8);
 int ide_set_dma_mode(ide_drive_t *, u8);
