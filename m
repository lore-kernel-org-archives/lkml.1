Return-Path: <linux-kernel-owner+w=401wt.eu-S1759048AbYE3FPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048AbYE3FPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYE3FPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:15:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:50913 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbYE3FP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:15:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=VCku64Pzz+dDEv/Ac5bVdQsCYOZLV1VWdRrRegiWNYIWF6eKg3D8u001RQhgHtJYRRlmRDY02gM7iD3D6sZ4kxMjoYi2SofkiNxF0p+bBtc4CJ5n0rN2QhqYy0KFzGzhIdFf0EjQKSiJaqTpDh+3vrrrOpLuXpHp1mfCy9xDVrQ=
Message-ID: <483F8D6A.3010109@gmail.com>
Date: Fri, 30 May 2008 14:15:22 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Henry, Andrew" <andrew.henry@logica.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: 2.6.25: sata_sil freezes, hard resets port.
References: <3ECBDC05781B3D48ABD520A01ABF2F9B12C589D4FA@SE-EX008.groupinfra.com>
In-Reply-To: <3ECBDC05781B3D48ABD520A01ABF2F9B12C589D4FA@SE-EX008.groupinfra.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, cc'ing linux-ide@vger.kernel.org

Henry, Andrew wrote:
> I'm not on the list.  Please cc me if you reply.
> 
> I run 2.6.18-53 kernel on CentOS5.1 x86_64.  I recently bought 2 x
> WD 500GB triple interface drives and an ST Labs/Sunway eSATA CardBus
> (sil_3512?) controller with 2 ports.
> 
> Note that I compiled 2.6.25 and still get errors.  All output below
> is from 2.6.25.
> 
> I can hotplug the card and drives and run badblocks for 48hrs
> without any verification errors, RAID1 them with mdadm, run dmcrypt
> and create ext3 fs and mount it and it works perfectly.
>
> Then the drives spin down/go to sleep *or* I cold boot the
> computer, and the problems begin...
>
> As long as the discs are always in use, they seem to work, and
> maybe a workaround is a cronjob with sdparm -C start /dev/sdx, but
> the lockups/hangs on the port during boot cannot be overcome so
> easily.  At boot one of the 2 ports can hang and the activity LED
> stays lit and then I cannot access that disc until I cold boot, and
> disconnect all power from the drive and unplug the eSATA cable.  It
> does not work even on cold boot and pressing power off/power on
> button on drive: I need to actually disconnect the cables!
>
> Error 1.
> 
> (system is booted, I hotplug card here)
> 
> pccard: CardBus card inserted into slot 0
> sata_sil 0000:07:00.0: version 2.3
> PCI: Enabling device 0000:07:00.0 (0000 -> 0003)
> ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 20 (level, low) -> IRQ 20
> sata_sil 0000:07:00.0: cache line size not set.  Driver may not function
> sata_sil 0000:07:00.0: Applying R_ERR on DMA activate FIS errata fix
> 
> Error 2.
> 
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1: soft resetting port
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> ata1.00: configured for UDMA/66
> ata1: EH complete
> 
> Error 3.
> 
> (this can happen when disc has spun down and I try to access with 'fdisk -l')
> 
> ata2: port is slow to respond, please be patient (Status 0xd8)
> ata2: device not ready (errno=-16), forcing hardreset
> ata2: hard resetting port
> ata2: port is slow to respond, please be patient (Status 0xff)
> ata2: COMRESET failed (errno=-16)
> ata2: hard resetting port
> ata2: port is slow to respond, please be patient (Status 0xff)
> ata2: COMRESET failed (errno=-16)
> ata2: hard resetting port
> ata2: port is slow to respond, please be patient (Status 0xff)
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd 25/00:08:80:5f:38/00:00:3a:00:00/e0 tag 0 cdb 0x0 data 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1: soft resetting port
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> ata1.00: configured for UDMA/33
> ata1: EH complete
> ata2: COMRESET failed (errno=-16)
> ata2: hard resetting port
> ata2: COMRESET failed (errno=-16)
> ata2: reset failed, giving up
> ata2.00: disabled
> ata2: EH complete
> sd 1:0:0:0: SCSI error: return code = 0x00040000
> end_request: I/O error, dev sdb, sector 0
> 
> 
> Error 4.
> 
> ( I get these after the hard resets)
> 
> May 29 07:50:25 k2 kernel: end_request: I/O error, dev sdb, sector 0
> May 29 07:50:25 k2 kernel: sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK

ATA drives are supposed to wake up from standby on command issue and
from sleep on reset.  Does the drive spin up while sata_sil is trying
to reset the port?  Also, please post the result of 'hdparm -I
/dev/sdX' where sdX is the offending drive.

Thanks.

-- 
tejun
