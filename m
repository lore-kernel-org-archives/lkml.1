Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbXFYEFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbXFYEFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 00:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbXFYEFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 00:05:00 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:50142 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbXFYEE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 00:04:59 -0400
Message-ID: <467F3EDC.2060002@tw.ibm.com>
Date: Mon, 25 Jun 2007 12:04:44 +0800
From: Albert Lee <albertcc@tw.ibm.com>
Reply-To: albertl@mail.com
User-Agent: Mozilla Thunderbird 1.0.6 (Windows/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>, Robert de Rooy <robert.de.rooy@gmail.com>
CC: Tejun Heo <htejun@gmail.com>, albertl@mail.com,
       Mark Lord <mlord@pobox.com>, Jeff Garzik <jeff@garzik.org>,
       bzolnier@gmail.com, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: libata and legacy ide pcmcia failure
References: <466718B6.4080105@gmail.com> <4667B39D.209@gmail.com> <46685AE5.4010908@gmail.com> <466900F3.7040801@gmail.com> <46694FB2.6040007@pobox.com> <4669D2D8.3020806@gmail.com> <4669D3F5.7040300@rtr.ca> <466B4D86.1020808@gmail.com> <466C631D.2000001@rtr.ca> <466C723C.6000300@gmail.com> <20070610221322.GA18196@flint.arm.linux.org.uk> <466C7A9F.1080700@rtr.ca> <466DCE55.30507@gmail.com> <466DCF43.5060304@pobox.com> <466E11DF.5020901@gmail.com> <466F4A27.8070309@tw.ibm.com> <46710CD7.9070901@gmail.com> <467BB7DB.4090004@gmail.com> <467BCF86.8060508@rtr.ca>
In-Reply-To: <467BCF86.8060508@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Robert de Rooy wrote:
> 
>>
>> I did another try with libata pcmcia support using 2.6.22-rc5 which
>> already includes the nodata polling fix, in combination with
>> disable-dev_init_param-and-setxfermode-for-CFA.patch and the
>> timing-debug.patch
> 
> ...
> 
>> Jun 22 13:19:44 localhost kernel: ata3.00: issuing IDENTIFY
>> Jun 22 13:19:45 localhost kernel: ata3.00: IDENTIFY complete
>> Jun 22 13:19:45 localhost kernel: ata3.00: CFA: Memory Card Adapter,
>> 20011212, max PIO1
>> Jun 22 13:19:45 localhost kernel: ata3.00: 253696 sectors, multi 0: LBA
>> Jun 22 13:19:45 localhost kernel: ata3.00: issuing IDENTIFY
>> Jun 22 13:19:45 localhost kernel: ata3.00: IDENTIFY complete
>> Jun 22 13:19:45 localhost kernel: ata3.00: configured for PIO0
>> Jun 22 13:19:45 localhost kernel: ata3: EH complete
>> Jun 22 13:19:45 localhost kernel: scsi 2:0:0:0: Direct-Access    
>> ATA      Memory Card Adap 2001 PQ: 0 ANSI: 5
>> Jun 22 13:19:45 localhost kernel: sd 2:0:0:0: [sdb] 253696 512-byte
>> hardware sectors (130 MB)
>> Jun 22 13:19:45 localhost kernel: sd 2:0:0:0: [sdb] Write Protect is off
>> Jun 22 13:19:45 localhost kernel: sd 2:0:0:0: [sdb] Write cache:
>> disabled, read cache: enabled, doesn't support DPO or FUA
>> Jun 22 13:19:45 localhost kernel: sd 2:0:0:0: [sdb] 253696 512-byte
>> hardware sectors (130 MB)
>> Jun 22 13:19:45 localhost kernel: sd 2:0:0:0: [sdb] Write Protect is off
>> Jun 22 13:19:45 localhost kernel: sd 2:0:0:0: [sdb] Write cache:
>> disabled, read cache: enabled, doesn't support DPO or FUA
>> Jun 22 13:20:15 localhost kernel:  sdb:<3>ata3.00: exception Emask 0x0
>> SAct 0x0 SErr 0x0 action 0x2 frozen
>> Jun 22 13:20:15 localhost kernel: ata3.00: cmd
>> 20/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
>> Jun 22 13:20:15 localhost kernel:          res
>> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> Jun 22 13:20:15 localhost kernel: ata3: soft resetting port
>> Jun 22 13:20:15 localhost kernel: ata3: reset complete
>> Jun 22 13:20:15 localhost kernel: ATA: abnormal status 0x80 on port
>> 0x00014107
>> Jun 22 13:20:15 localhost kernel: ATA: abnormal status 0x80 on port
>> 0x00014107
>> Jun 22 13:20:15 localhost kernel: ATA: abnormal status 0x58 on port
>> 0x00014107
>> Jun 22 13:20:15 localhost kernel: ata3.00: issuing IDENTIFY
>> Jun 22 13:20:15 localhost kernel: ATA: abnormal status 0x58 on port
>> 0x00014107
> 
> ...
> 
> Mmm.. I don't know about the first failure there,
> but after that it gets into the "stuck DRQ" state
> which libata makes no attempt to handle at present.
> 

It seems the pata_pcmcia driver is using IRQ driven PIO. Maybe Robert
could try the following pio_polling patch first.

--
albert

---

--- libata-dev/drivers/ata/pata_pcmcia.c~	2007-06-12 16:44:43.000000000 +0800
+++ libata-dev/drivers/ata/pata_pcmcia.c	2007-06-25 11:53:37.000000000 +0800
@@ -299,7 +299,7 @@ next_entry:
 
 	ap->ops = &pcmcia_port_ops;
 	ap->pio_mask = 1;		/* ISA so PIO 0 cycles */
-	ap->flags |= ATA_FLAG_SLAVE_POSS;
+	ap->flags |= ATA_FLAG_SLAVE_POSS | ATA_FLAG_PIO_POLLING;
 	ap->ioaddr.cmd_addr = io_addr;
 	ap->ioaddr.altstatus_addr = ctl_addr;
 	ap->ioaddr.ctl_addr = ctl_addr;





