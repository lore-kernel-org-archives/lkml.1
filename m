Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676AbZIAK2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbZIAK2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 06:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZIAK2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 06:28:17 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:29482 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbZIAK2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 06:28:17 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=Mv5P-v-zDEQA:10 a=w4iE+TBsmj5y1WloLYF40w==:17 a=VwQbUJbxAAAA:8
 a=mlwxIoYv1GO3lwxsMxkA:9 a=ITg9bddxJzN7Yo2kZmYA:7
 a=GuCi48ebBPiTjBVo_G6uPtDpWiEA:4 a=U62fhAwekXMA:10
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: Re: sata exception frozen timeout?
Date: Tue, 1 Sep 2009 04:28:18 -0600
User-Agent: KMail/1.12.90 (Linux/2.6.31-rc5; KDE/4.3.64; x86_64; svn-1004284; 2009-07-29)
References: <200909010316.58715.tfjellstrom@shaw.ca>
In-Reply-To: <200909010316.58715.tfjellstrom@shaw.ca>
MIME-Version: 1.0
Message-Id: <200909010428.18403.tfjellstrom@shaw.ca>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue September 1 2009, Thomas Fjellstrom wrote:
> I've recently started seeing the following messages from a new WD Green
> drive, not long after I had to RMA a Seagate drive for a strange (but
> different) error. Highlights from my dmesg include:
>
> [59634.792101] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [59634.792121] ata6.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
> [59634.792125]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4
> (timeout)
> [59634.792133] ata6.00: status: { DRDY }
> [59634.792145] ata6: hard resetting link
> [59635.277695] ata6: softreset failed (device not ready)
> [59635.277705] ata6: failed due to HW bug, retry pmp=0
> [59635.441570] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [59635.454030] ata6.00: configured for UDMA/133
> [59635.454068] ata6: EH complete
> ...
> [59713.792224] ata6.00: NCQ disabled due to excessive errors
> [59713.792236] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [59713.792254] ata6.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
> [59713.792257]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4
> (timeout)
> [59713.792264] ata6.00: status: { DRDY }
> ...
> [63484.781764] ata6: hard resetting link
> [63485.264204] ata6: softreset failed (device not ready)
> [63485.264214] ata6: failed due to HW bug, retry pmp=0
> [63485.428205] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> [63485.440499] ata6.00: configured for UDMA/100
> [63485.440536] ata6: EH complete
> [63493.780182] ata6.00: limiting speed to UDMA/33:PIO4
> [63493.780194] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [63493.780211] ata6.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
> [63493.780214]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4
> (timeout)
> [63493.780221] ata6.00: status: { DRDY }
> ...
> [99318.070669] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [99318.070679] ata6.00: irq_stat 0x40000001
> [99318.070698] ata6.00: cmd 25/00:00:30:bd:01/00:01:1b:00:00/e0 tag 0 dma
> 131072 in
> [99318.070701]          res 41/04:ef:30:bd:01/00:00:1b:00:00/e0 Emask 0x1
> (device error)
> [99318.070709] ata6.00: status: { DRDY ERR }
> [99318.070714] ata6.00: error: { ABRT }
> [99318.082588] ata6.00: configured for UDMA/33
> [99318.082612] ata6: EH complete
> ...
> [99339.780358] ata6: hard resetting link
> [99349.785096] ata6: softreset failed (device not ready)
> [99349.785108] ata6: hard resetting link
> [99359.789033] ata6: softreset failed (device not ready)
> [99359.789045] ata6: hard resetting link
> [99370.352916] ata6: link is slow to respond, please be patient (ready=0)
> ..
> [99400.016925] ata6: softreset failed (device not ready)
> [99400.016936] ata6: reset failed, giving up
> [99400.016942] ata6.00: disabled
> [99400.016986] ata6: EH complete
> [99400.017021] sd 5:0:0:0: [sdf] Unhandled error code
> [99400.017026] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET
> driverbyte=DRIVER_OK
> [99400.017021] sd 5:0:0:0: [sdf] Unhandled error code
> [99400.017026] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET
> driverbyte=DRIVER_OK
> [99400.017035] end_request: I/O error, dev sdf, sector 453099568
> [99400.017045] Buffer I/O error on device md1, logical block 113274390
> [99400.017058] Buffer I/O error on device md1, logical block 113274391
> [99400.017064] Buffer I/O error on device md1, logical block 113274392
> [99400.017070] Buffer I/O error on device md1, logical block 113274393
> [99400.017076] Buffer I/O error on device md1, logical block 113274394
> [99400.017082] Buffer I/O error on device md1, logical block 113274395
> [99400.017088] Buffer I/O error on device md1, logical block 113274396
> [99400.017094] Buffer I/O error on device md1, logical block 113274397
> [99400.017100] Buffer I/O error on device md1, logical block 113274398
> [99400.017106] Buffer I/O error on device md1, logical block 113274399
> [99400.017115] sd 5:0:0:0: [sdf] Unhandled error code
> [99400.017123] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET
> driverbyte=DRIVER_OK
> [99400.017133] end_request: I/O error, dev sdf, sector 453099824
> [99400.017310] sd 5:0:0:0: [sdf] Unhandled error code
> [99400.017315] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET
> driverbyte=DRIVER_OK
> [99400.017322] end_request: I/O error, dev sdf, sector 453099568
> [99400.017383] program smartctl is using a deprecated SCSI ioctl, please
> convert it to SG_IO
> [99400.017456] program smartctl is using a deprecated SCSI ioctl, please
> convert it to SG_IO
> [99400.018822] sd 5:0:0:0: [sdf] Unhandled error code
> [99400.018829] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET
> driverbyte=DRIVER_OK
> [99400.018838] end_request: I/O error, dev sdf, sector 453099568
>
> and a bunch more end_request errors. This happens fairly reliably after a
> day or so of being online. I try and start to play some music or watch a
> video off the array (2xWD Green on md raid0) and it fails. The file system
> is mostly read only right now (that is I don't write to it) so I haven't
> manged to loose any data that I know of, and the fs seems to be fine. A
> reboot fixes the errors and the disk and fs work fine for a day or two
> before these errors show up again.
>
> I'm currently running 2.6.31-rc5 from kernel.org. What would cause these
> errors?

It's now happened again after only 30 minutes or so. I'm trying with an older 
kernel (debian's 2.6.30-6 from sid) now. So far so good.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
