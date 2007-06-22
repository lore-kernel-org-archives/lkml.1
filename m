Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbXFVNdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbXFVNdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbXFVNc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:32:58 -0400
Received: from rtr.ca ([64.26.128.89]:3346 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbXFVNc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:32:57 -0400
Message-ID: <467BCF86.8060508@rtr.ca>
Date: Fri, 22 Jun 2007 09:32:54 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Robert de Rooy <robert.de.rooy@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, albertl@mail.com,
       Mark Lord <mlord@pobox.com>, Jeff Garzik <jeff@garzik.org>,
       bzolnier@gmail.com, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: libata and legacy ide pcmcia failure
References: <466718B6.4080105@gmail.com> <4667B39D.209@gmail.com> <46685AE5.4010908@gmail.com> <466900F3.7040801@gmail.com> <46694FB2.6040007@pobox.com> <4669D2D8.3020806@gmail.com> <4669D3F5.7040300@rtr.ca> <466B4D86.1020808@gmail.com> <466C631D.2000001@rtr.ca> <466C723C.6000300@gmail.com> <20070610221322.GA18196@flint.arm.linux.org.uk> <466C7A9F.1080700@rtr.ca> <466DCE55.30507@gmail.com> <466DCF43.5060304@pobox.com> <466E11DF.5020901@gmail.com> <466F4A27.8070309@tw.ibm.com> <46710CD7.9070901@gmail.com> <467BB7DB.4090004@gmail.com>
In-Reply-To: <467BB7DB.4090004@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert de Rooy wrote:
>
> I did another try with libata pcmcia support using 2.6.22-rc5 which 
> already includes the nodata polling fix, in combination with 
> disable-dev_init_param-and-setxfermode-for-CFA.patch and the 
> timing-debug.patch
...
> Jun 22 13:19:44 localhost kernel: ata3.00: issuing IDENTIFY
> Jun 22 13:19:45 localhost kernel: ata3.00: IDENTIFY complete
> Jun 22 13:19:45 localhost kernel: ata3.00: CFA: Memory Card Adapter, 
> 20011212, max PIO1
> Jun 22 13:19:45 localhost kernel: ata3.00: 253696 sectors, multi 0: LBA
> Jun 22 13:19:45 localhost kernel: ata3.00: issuing IDENTIFY
> Jun 22 13:19:45 localhost kernel: ata3.00: IDENTIFY complete
> Jun 22 13:19:45 localhost kernel: ata3.00: configured for PIO0
> Jun 22 13:19:45 localhost kernel: ata3: EH complete
> Jun 22 13:19:45 localhost kernel: scsi 2:0:0:0: Direct-Access     
> ATA      Memory Card Adap 2001 PQ: 0 ANSI: 5
> Jun 22 13:19:45 localhost kernel: sd 2:0:0:0: [sdb] 253696 512-byte 
> hardware sectors (130 MB)
> Jun 22 13:19:45 localhost kernel: sd 2:0:0:0: [sdb] Write Protect is off
> Jun 22 13:19:45 localhost kernel: sd 2:0:0:0: [sdb] Write cache: 
> disabled, read cache: enabled, doesn't support DPO or FUA
> Jun 22 13:19:45 localhost kernel: sd 2:0:0:0: [sdb] 253696 512-byte 
> hardware sectors (130 MB)
> Jun 22 13:19:45 localhost kernel: sd 2:0:0:0: [sdb] Write Protect is off
> Jun 22 13:19:45 localhost kernel: sd 2:0:0:0: [sdb] Write cache: 
> disabled, read cache: enabled, doesn't support DPO or FUA
> Jun 22 13:20:15 localhost kernel:  sdb:<3>ata3.00: exception Emask 0x0 
> SAct 0x0 SErr 0x0 action 0x2 frozen
> Jun 22 13:20:15 localhost kernel: ata3.00: cmd 
> 20/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
> Jun 22 13:20:15 localhost kernel:          res 
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Jun 22 13:20:15 localhost kernel: ata3: soft resetting port
> Jun 22 13:20:15 localhost kernel: ata3: reset complete
> Jun 22 13:20:15 localhost kernel: ATA: abnormal status 0x80 on port 
> 0x00014107
> Jun 22 13:20:15 localhost kernel: ATA: abnormal status 0x80 on port 
> 0x00014107
> Jun 22 13:20:15 localhost kernel: ATA: abnormal status 0x58 on port 
> 0x00014107
> Jun 22 13:20:15 localhost kernel: ata3.00: issuing IDENTIFY
> Jun 22 13:20:15 localhost kernel: ATA: abnormal status 0x58 on port 
> 0x00014107
...

Mmm.. I don't know about the first failure there,
but after that it gets into the "stuck DRQ" state
which libata makes no attempt to handle at present.

Here is an additional patch, which hopefully will apply to your kernel
to handle the stuck DRQ.  You may need to hand tweak it, though,
as I'm not entirely certain as to where to place the new call
to ata_drain_fifo().  It's currently on an error recovery path
which works for DMA, but your device is using PIO.  It may still get
hit as-is, but..  Give it a try.


--- linux/drivers/ata/libata-sff.c.orig	2007-04-26 12:02:46.000000000 -0400
+++ linux/drivers/ata/libata-sff.c	2007-04-29 08:29:27.000000000 -0400
@@ -413,6 +413,24 @@
 	ap->ops->irq_on(ap);
 }
 
+static void ata_drain_fifo (struct ata_port *ap, struct ata_queued_cmd *qc)
+{
+	u8 stat = ata_chk_status(ap);
+	/*
+	 * Try to clear stuck DRQ if necessary.
+	 */
+	if ((stat & ATA_DRQ) && (!qc || qc->dma_dir != DMA_TO_DEVICE)) {
+		unsigned int i, limit = 512;
+		printk("Draining up to %u words from data FIFO.\n", limit);
+		for (i = 0; i < limit ; ++i) {
+			ioread16(ap->ioaddr.data_addr);
+			if (!(ata_chk_status(ap) & ATA_DRQ))
+				break;
+		}
+		printk("Drained %u/%u words.\n", i, limit);
+	}
+}
+
 /**
  *	ata_bmdma_drive_eh - Perform EH with given methods for BMDMA controller
  *	@ap: port to handle error for
@@ -469,7 +487,7 @@
 	}
 
 	ata_altstatus(ap);
-	ata_chk_status(ap);
+	ata_drain_fifo(ap, qc);
 	ap->ops->irq_clear(ap);
 
 	spin_unlock_irqrestore(ap->lock, flags);
