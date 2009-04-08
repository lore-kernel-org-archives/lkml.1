Return-Path: <linux-kernel-owner+w=401wt.eu-S1762777AbZDHHeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762777AbZDHHeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbZDHHdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:33:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:53103 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbZDHHdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:33:54 -0400
Subject: Re: Linux 2.6.30-rc1 boot failure on ia64 w/ QLA12160.  Bisected.
From: David Woodhouse <dwmw2@infradead.org>
To: Robin Holt <holt@sgi.com>
Cc: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090408042734.GD10768@sgi.com>
References: <alpine.LFD.2.00.0904071700170.4583@localhost.localdomain>
	 <20090408042734.GD10768@sgi.com>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 00:33:43 -0700
Message-Id: <1239176024.32073.2.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 23:27 -0500, Robin Holt wrote:
> On and ia64 system with a QLA12160 adapter, my boot fails with:
> 
> qla1280: QLA12160 found on PCI bus 0, dev 3
> qla1280 0001:00:03.0: PCI INT A -> GSI 61 (level, low) -> IRQ 61
> scsi(0): Enabling SN2 PCI DMA dual channel lockup workaround
> qla1280 0001:00:03.0: firmware: using built-in firmware qlogic/12160.bin
> qla1280_mailbox_command: Command failed, mailbox0 = 0x0007, mailbox_out0 = 0x4003, istatus = 0x6000

Does this fix it?

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 351b56c..b6f8382 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1663,7 +1663,7 @@ qla1280_load_firmware_pio(struct scsi_qla_host
*ha)
 
 	/* Load RISC code. */
 	risc_address = ha->fwstart;
-	fw_data = (const __le16 *)&fw->data[4];
+	fw_data = (const __le16 *)&fw->data[3];
 	risc_code_size = (fw->size - 6) / 2;
 
 	for (i = 0; i < risc_code_size; i++) {
@@ -1722,7 +1722,7 @@ qla1280_load_firmware_dma(struct scsi_qla_host
*ha)
 
 	/* Load RISC code. */
 	risc_address = ha->fwstart;
-	fw_data = (const __le16 *)&fw->data[4];
+	fw_data = (const __le16 *)&fw->data[3];
 	risc_code_size = (fw->size - 6) / 2;
 
 	dprintk(1, "%s: DMA RISC code (%i) words\n",

-- 
dwmw2

