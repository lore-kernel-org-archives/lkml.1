Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874AbZIBEck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbZIBEck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 00:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZIBEck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 00:32:40 -0400
Received: from mail-yw0-f188.google.com ([209.85.211.188]:44712 "EHLO
	mail-yw0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbZIBEcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 00:32:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AXFtQN3rPO9jWQkmgiY/jxYMFltLv2H2TDRg3SAxY6ah3gr8JXJMQJJztbUZ9/N3ih
         5LkmYhdmcAe9QaZBk0nnTLMUBHQddGBQOIAtudeb1tnU6669F4UueiLBL+YQFeu1nS1X
         b2f64TZyIg27hnfJLuJGCkWcqPS8DpNZfGkEA=
Message-ID: <4A9DF566.50805@gmail.com>
Date: Tue, 01 Sep 2009 22:32:38 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: tfjellstrom@shaw.ca
CC: linux-kernel@vger.kernel.org
Subject: Re: sata exception frozen timeout?
References: <200909010316.58715.tfjellstrom@shaw.ca>
In-Reply-To: <200909010316.58715.tfjellstrom@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2009 03:16 AM, Thomas Fjellstrom wrote:
> I've recently started seeing the following messages from a new WD Green drive,
> not long after I had to RMA a Seagate drive for a strange (but different)
> error. Highlights from my dmesg include:
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
> and a bunch more end_request errors. This happens fairly reliably after a day
> or so of being online. I try and start to play some music or watch a video off
> the array (2xWD Green on md raid0) and it fails. The file system is mostly
> read only right now (that is I don't write to it) so I haven't manged to loose
> any data that I know of, and the fs seems to be fine. A reboot fixes the
> errors and the disk and fs work fine for a day or two before these errors show
> up again.
>
> I'm currently running 2.6.31-rc5 from kernel.org. What would cause these
> errors?

This sort of thing is quite often a hardware problem. You can see that 
commands start timing out and then the controller seems to mostly lose 
communication with the drive (the resets failing). In particular, it 
seems an overloaded power supply can cause these sort of symptoms. (It 
seems like a lot of the time this happens with people with multiple hard 
drives installed, either the power supply just isn't powerful enough to 
handle them all, or there's too many drives connected to one cable and 
the voltage drop is too high under heavy load.)
