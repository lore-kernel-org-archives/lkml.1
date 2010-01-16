Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676Ab0APBiK convert rfc822-to-quoted-printable (ORCPT
	<rfc822;list-kernel77@spinics.net>); Fri, 15 Jan 2010 20:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758598Ab0APBiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 20:38:09 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:45427 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758262Ab0APBiF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 20:38:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T9rbdKtdkq7LzzzRsWlejesDQE7v0e/zokKHRt1sbyxd884a0/xPOTB14Acrq3bHum
         Vg9lTChs9luS8NKRuEJ3u5EyGB2ijJXDDsOegQmldbfI7tU0Yy8T21wDOrSgDTwgBwtT
         f8RJLb4X27XsfUuwRjWWTbQ+raQkcvree/Nj8=
MIME-Version: 1.0
In-Reply-To: <m3iqb3rqmz.fsf@intrepid.localdomain>
References: <201001121700.18234.seth.heasley@intel.com>
	 <4B4D4EAA.2010109@gmail.com> <4B4DAA68.60608@pobox.com>
	 <m3my0i6nou.fsf@intrepid.localdomain> <4B4DFE1A.4000606@pobox.com>
	 <m3iqb57ts7.fsf@intrepid.localdomain>
	 <51f3faa71001131557n52e34260k13bf1fe3057bb0e@mail.gmail.com>
	 <m3iqb4iwb4.fsf@intrepid.localdomain>
	 <51f3faa71001141615n5776454cwbf6787b7a7fb0081@mail.gmail.com>
	 <m3iqb3rqmz.fsf@intrepid.localdomain>
Date: Fri, 15 Jan 2010 19:32:34 -0600
Message-ID: <51f3faa71001151732s77c198bdu1268879afadd2308@mail.gmail.com>
Subject: Re: [PATCH 2.6.32.3] ahci: AHCI and RAID mode SATA patch for Intel 
	Cougar Point DeviceIDs
From: Robert Hancock <hancockrwd@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jeff Garzik <jgarzik@pobox.com>, Seth Heasley <seth.heasley@intel.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 3:43 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote=
:
> Robert Hancock <hancockrwd@gmail.com> writes:
>
>> It would be interesting to see what happens if you actually plug
>> something into that port that's having the issues, and see what
>> happens. I'm kind of inclined to suspect it's a hardware fault, thou=
gh
>> it would likely require a report from someone else with the same or
>> similar board model to confirm that..
>
> 2.6.32.3 with the patch disabling JMB363 and "catch all AHCI" applied=
=2E
> Nothing connected to SATA, only PATA in use.
>
> I understand the following doesn't set the AHCI_HFLAG_IGN_IRQ_IF_ERR
> and thus doesn't ignore PORT_IRQ_IF_ERR, but the latter doesn't seem =
to
> be set.
>
> # echo -n 197b 2363 > new_id
>
> ahci 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SA=
TA mode
> ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part
> ahci 0000:02:00.0: setting latency timer to 64
> scsi9 : ahci
> scsi10 : ahci
> ata9: SATA max UDMA/133 abar m8192@0xfe9fe000 port 0xfe9fe100 irq 16
> ata10: SATA max UDMA/133 abar m8192@0xfe9fe000 port 0xfe9fe180 irq 16
> ata10: SATA link down (SStatus 0 SControl 300)
> ata9: SATA link down (SStatus 0 SControl 300)
>
> ata10: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
> ata10: irq_stat 0x00000040, connection status changed
> ata10: SError: { CommWake DevExch }
> ata10: hard resetting link
> ata10: SATA link down (SStatus 0 SControl 300)
> ata10: EH complete
> ata10: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
> ata10: irq_stat 0x00000040, connection status changed
> ata10: SError: { CommWake DevExch }
> ata10: limiting SATA link speed to 1.5 Gbps
> ata10: hard resetting link
> ata10: SATA link down (SStatus 0 SControl 310)
> ata10: EH complete
> ...
>
> sometimes the two lines become:
>
> ata10: exception Emask 0x10 SAct 0x0 SErr 0x4060000 action 0xe frozen
> ata10: SError: { PHYInt CommWake DevExch }
>
> Now plugging something into the mb connector (1.5 Gbps device, the sa=
me
> which my VT6421A-based miniPCI card doesn't like):
>
> ata10: exception Emask 0x10 SAct 0x0 SErr 0x4050000 action 0xe frozen
> ata10: irq_stat 0x00400040, connection status changed
> ata10: SError: { PHYRdyChg CommWake DevExch }
> ata10: hard resetting link
> ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata10.00: ATA-7: Kingston SSDNow V Series 64GB, B090428a, max UDMA/10=
0
> ata10.00: 125045424 sectors, multi 1: LBA
> ata10.00: configured for UDMA/100
> ata10: EH complete
> scsi 10:0:0:0: Direct-Access =A0 =A0 ATA =A0 =A0 =A0Kingston SSDNow =A0=
B090 PQ: 0 ANSI: 5
> sd 10:0:0:0: Attached scsi generic sg8 type 0
> sd 10:0:0:0: [sdh] 125045424 512-byte logical blocks: (64.0 GB/59.6 G=
iB)
> sd 10:0:0:0: [sdh] Write Protect is off
> sd 10:0:0:0: [sdh] Mode Sense: 00 3a 00 00
> sd 10:0:0:0: [sdh] Write cache: disabled, read cache: enabled, doesn'=
t support DPO or FUA
> sd 10:0:0:0: [sdh] Attached SCSI disk
>
> Absolutely no problems with fs access, expected linear transfer speed
> etc.
>
> Well, let's unplug it. Power down first:
>
> ata10: exception Emask 0x10 SAct 0x0 SErr 0x990000 action 0xe frozen
> ata10: irq_stat 0x00400000, PHY RDY changed
> ata10: SError: { PHYRdyChg 10B8B Dispar LinkSeq }
> ata10: hard resetting link
> ata10: SATA link down (SStatus 0 SControl 300)
> ata10: hard resetting link
> ata10: SATA link down (SStatus 0 SControl 300)
> ata10: limiting SATA link speed to 1.5 Gbps
> ata10: hard resetting link
> ata10: SATA link down (SStatus 0 SControl 310)
> ata10.00: disabled
> ata10: EH complete
> ata10.00: detaching (SCSI 10:0:0:0)
> sd 10:0:0:0: [sdh] Stopping disk
> sd 10:0:0:0: [sdh] START_STOP FAILED
> sd 10:0:0:0: [sdh] Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRI=
VER_OK
>
> Seems stable at this point, no additional messages.
>
> Then removing the plug from (unpowered) SSD - IRQs start appearing ag=
ain
> every few seconds. Mostly:
>
> ata10: exception Emask 0x10 SAct 0x0 SErr 0x4000000 action 0xe frozen
> ata10: irq_stat 0x00000040, connection status changed
> ata10: SError: { DevExch }
> ata10: limiting SATA link speed to 1.5 Gbps
> ata10: hard resetting link
> ata10: SATA link down (SStatus 0 SControl 310)
> ata10: EH complete
>
> sometimes SErr 0x4060000 and 0x4040000
>
> Fine, so let's connect it again (device still not powered):
> Messages stopped.
>
> Disconnected again, messages started, reconnected, stopped.
>
> Am I to use the SSD as a passive SATA terminator?
>
> Any further ideas welcome :-)

Hmm.. From those test results I really suspect some kind of hardware
fault. Could be a defective motherboard - I don't know if that chip
needs any terminating resistors on the motherboard for the SATA signal
lines or something, if so, could be they weren't installed properly..
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
