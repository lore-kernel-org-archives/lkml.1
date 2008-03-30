Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbYC3Tbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbYC3Tbs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 15:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYC3TbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 15:31:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:31275 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbYC3Tau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 15:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ruRTty/QpXQChrQLIJ9tGZF7wNswb1Mvff0lyg/ey+HD7J4+/XGYeBCMrLlikEa/cN3w3Zjzw8RmO9DbGcjSZAN3r+EK1JieZ/aX62+WGbZ+uNDcmoBDoxkyXI+cOJbZcF1WVLKELCU0HePlg3WPo0p9b4zkpaHGeGSZuV39Xx8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/6] ide-h8300: add ->{in,out}put_data methods
Date: Sun, 30 Mar 2008 21:43:13 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803302143.13428.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/h8300/ide-h8300.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -56,6 +56,16 @@ static void mm_insw(unsigned long addr, 
 		*bp = bswap(*(volatile u16 *)addr);
 }
 
+static void h8300_input_data(ide_drive_t *drive, void *buf, unsigned int len)
+{
+	mm_insw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
+
+static void h8300_output_data(ide_drive_t *drive, void *buf, unsigned int len)
+{
+	mm_outsw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
+
 #define H8300_IDE_GAP (2)
 
 static inline void hw_setup(hw_regs_t *hw)
@@ -74,6 +84,9 @@ static inline void hwif_setup(ide_hwif_t
 {
 	default_hwif_iops(hwif);
 
+	hwif->input_data  = h8300_input_data;
+	hwif->output_data = h8300_output_data;
+
 	hwif->OUTW  = mm_outw;
 	hwif->OUTSW = mm_outsw;
 	hwif->INW   = mm_inw;
