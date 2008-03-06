Return-Path: <linux-kernel-owner+w=401wt.eu-S932666AbYCFSDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbYCFSDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYCFSDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:03:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:24659 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbYCFSDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:03:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,457,1199692800"; 
   d="scan'208";a="261162738"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Unknown SATA PIIX PCI device ID 0x29b6
Date: Thu, 6 Mar 2008 10:02:06 -0800
Message-ID: <39B20DF628532344BC7A2692CB6AEE0702679018@orsmsx420.amr.corp.intel.com>
In-Reply-To: <Pine.LNX.4.64.0803061248070.5670@axis700.grange>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Unknown SATA PIIX PCI device ID 0x29b6
Thread-Index: Ach/glxNLqBYJ782SWCnapB9dj4zkgAMXisA
References: <Pine.LNX.4.64.0802282306190.10087@axis700.grange> <20080228225603.2764bfd1@core> <Pine.LNX.4.64.0802290010320.10498@axis700.grange> <47CFADDF.20200@gmail.com> <Pine.LNX.4.64.0803061248070.5670@axis700.grange>
From: "Gaston, Jason D" <jason.d.gaston@intel.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
       "Tejun Heo" <htejun@gmail.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, <linux-ide@vger.kernel.org>
X-OriginalArrivalTime: 06 Mar 2008 18:02:07.0524 (UTC) FILETIME=[31226E40:01C87FB4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-ide-owner@vger.kernel.org 
>[mailto:linux-ide-owner@vger.kernel.org] On Behalf Of Guennadi 
>Liakhovetski
>Sent: Thursday, March 06, 2008 3:58 AM
>To: Tejun Heo
>Cc: Alan Cox; linux-kernel@vger.kernel.org; Jeff Garzik; 
>linux-ide@vger.kernel.org
>Subject: Re: Unknown SATA PIIX PCI device ID 0x29b6
>
>On Thu, 6 Mar 2008, Tejun Heo wrote:
>
>> Guennadi Liakhovetski wrote:
>> > Indeed! It was in "IDE" mode, and 2 out of the 3 chips 
>were handled by the 
>> > piix driver (btw, why did Intel put 3 different SATA 
>controllers on one 
>> > board?). I switched it to AHCI mode (the third possibility 
>is RAID) and 
>> > indeed a kernel with (only) ahci driver managed to bring them up! 
>> > Although, the eSATA link was "slow to respond":
>> > 
>> > ata4: port is slow to respond, please be patient (Status 0x80)
>> > ata4: softreset failed (device not ready)
>> > ata4: port is slow to respond, please be patient (Status 0x80)
>> > ata4: softreset failed (device not ready)
>> > ata4: port is slow to respond, please be patient (Status 0x80)
>> > ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> > ata4.00: ATA-7: WDC WD1600BB-00RDA0, 20.00K20, max UDMA/100
>> > ata4.00: 312581808 sectors, multi 16: LBA48
>> > ata4.00: applying bridge limits
>> > ata4.00: configured for UDMA/100
>> > 
>> > but then it did manage it. Is such a delay normal?
>> 
>> If you hotplugged it, sometimes drives don't respond too 
>well and takes
>> a few retries to talk to it.
>
>I've seen this messages both on cold- and hot-plug.
>
>> How long did the whole thing take?
>
>Here's a hot-plug log:
>
>Mar  4 15:04:28 6a kernel: ata4: exception Emask 0x10 SAct 0x0 
>SErr 0x4050000 action 0xa frozen
>Mar  4 15:04:28 6a kernel: ata4: irq_stat 0x00000040, 
>connection status changed
>Mar  4 15:04:28 6a kernel: ata4: SError: { PHYRdyChg CommWake 
>DevExch }Mar  4 15:04:28 6a kernel: ata4: hard resetting link
>Mar  4 15:04:38 6a kernel: ata4: softreset failed (device not ready)
>Mar  4 15:04:38 6a kernel: ata4: hard resetting link
>Mar  4 15:04:48 6a kernel: ata4: softreset failed (device not ready)
>Mar  4 15:04:48 6a kernel: ata4: hard resetting link
>Mar  4 15:04:55 6a kernel: ata4: port is slow to respond, 
>please be patient (Status 0x80)
>Mar  4 15:05:20 6a kernel: ata4: SATA link up 3.0 Gbps 
>(SStatus 123 SControl 300)
>Mar  4 15:05:20 6a kernel: ata4.00: ATA-7: WDC 
>WD1600BB-00RDA0, 20.00K20, max UDMA/100
>Mar  4 15:05:20 6a kernel: ata4.00: 312581808 sectors, multi 0: LBA48
>Mar  4 15:05:20 6a kernel: ata4.00: applying bridge limits
>Mar  4 15:05:20 6a kernel: ata4.00: configured for UDMA/100
>Mar  4 15:05:20 6a kernel: ata4: EH complete
>Mar  4 15:05:20 6a kernel: scsi 3:0:0:0: Direct-Access     ATA 
>     WDC WD1600BB-00R 20.0 PQ: 0 ANSI: 5
>Mar  4 15:05:20 6a kernel: sd 3:0:0:0: [sdb] 312581808 
>512-byte hardware sectors (160042 MB)
>Mar  4 15:05:20 6a kernel: sd 3:0:0:0: [sdb] Write Protect is off
>Mar  4 15:05:20 6a kernel: sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
>Mar  4 15:05:20 6a kernel: sd 3:0:0:0: [sdb] Write cache: 
>enabled, read cache: enabled, doesn't support DPO or FUA
>Mar  4 15:05:20 6a kernel: sd 3:0:0:0: [sdb] 312581808 
>512-byte hardware sectors (160042 MB)
>Mar  4 15:05:20 6a kernel: sd 3:0:0:0: [sdb] Write Protect is off
>Mar  4 15:05:20 6a kernel: sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
>Mar  4 15:05:20 6a kernel: sd 3:0:0:0: [sdb] Write cache: 
>enabled, read cache: enabled, doesn't support DPO or FUA
>Mar  4 15:05:20 6a kernel:  sdb: sdb1 sdb2
>Mar  4 15:05:20 6a kernel: sd 3:0:0:0: [sdb] Attached SCSI disk
>Mar  4 15:05:20 6a kernel: sd 3:0:0:0: Attached scsi generic sg2 type 0
>
>Looks like almost a minute to me? On another occurence I see about 1.5 
>minutes, then "port is slow to respond, please be patient 
>(Status 0x80)" 
>has been repeated 3 times. On cold-plug also 3 times, I think, 
>about the 
>same time then (time is not updated in the log).
>
>> And is it always like that?
>
>So far - yes.
>
>> > One more question, what do UDMA numbers mean in SATA 
>context? The internal 
>> > SATA disk is "ata1.00: configured for UDMA/133", but 
>should be SATA-2.
>> 
>> 1.00 is port 1 device 00 and UDMA numbers don't mean much to 
>SATA devices.
>
>Sorry, I actually meant to ask what "UDMA/133" means for a SATA link?
>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski
>--
>To unsubscribe from this list: send the line "unsubscribe linux-ide" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

If you disable the IDE Redirection in BIOS on that system, the 0x29b6
controller should not appear.  If you are not using this, it would be
interesting to see if this effects what you are seeing.

Jason
