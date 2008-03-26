Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbYCZOo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbYCZOo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 10:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYCZOou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 10:44:50 -0400
Received: from qb-out-0506.google.com ([72.14.204.227]:12425 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbYCZOos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 10:44:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=QocLSQEZBNnkgCZuDzslQu4aX/z4x9Mqr2IYx+ecAczyDmFWt4xwDosVOLkSVNhEWw2lgw7FL8c9JWSo0/VXdh1sGb/Ilyu1vEhia20yQoU3aOGxS+qboMusyf7ILiRQGomM5WrxCWlAN8TWz0YIphxUU5ApIirhDn6S0uf8DFY=
Message-ID: <47EA6157.6090208@gmail.com>
Date: Wed, 26 Mar 2008 23:44:39 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: "Peter F. Patel-Schneider" <pfps@verizon.net>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       "Peter F. Patel-Schneider" <pfps@research.bell-labs.com>
Subject: Re: 2.6.23-rc9-git4: pata_pcmcia, disabling IRQ #9 and Re: libata
 and legacy ide pcmcia failure
References: <47067DB9.80200@roarinelk.homelinux.net> <47E300B2.7000104@verizon.net> <20080321011205.4c7b4a61@core> <47EA5A13.70109@verizon.net>
In-Reply-To: <47EA5A13.70109@verizon.net>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter F. Patel-Schneider wrote:
> Alan Cox wrote:
>> O> Mar 20 19:51:45 idefix kernel: ata12: PATA max PIO0 cmd 0xa100 ctl  
>>> 0xa10e irq 3
>>> Mar 20 19:52:15 idefix kernel: ata12.00: qc timeout (cmd 0x91)
>>> Mar 20 19:52:15 idefix kernel: ata12.00: failed to IDENTIFY
>>> (INIT_DEV_PARAMS failed, err_mask=0x4)
>>>     
>>
>> Thinkpad T61p .. I've seen a few of these.
>>
>> Firstly try the card and adapter in a different PC and let me know if
>> that works. So far they do. If that is the case get the latest firmware
>> updates (BIOS etc) for your thinkpad and see if the problem goes away.
>> They (or our ACPI code I guess it may be) have some serious IRQ routing
>> problems on this box.
>>
>> Alan
>>
>>   
> So I tried again just now (on the same T60p running the current Fedora
> 8),  and got different behaviour!
> 
> Mar 26 10:06:33 idefix kernel: pccard: PCMCIA card inserted into slot 0
> Mar 26 10:06:33 idefix kernel: cs: memory probe 0xe4300000-0xe7ffffff:
> excluding 0xe4300000-0xe46cffff 0xe4e70000-0xe523ffff
> 0xe5db0000-0xe617ffff 0xe6cf0000-0xe70bffff
> Mar 26 10:06:33 idefix kernel: pcmcia: registering new device pcmcia0.0
> Mar 26 10:06:34 idefix kernel: scsi11 : pata_pcmcia
> Mar 26 10:06:34 idefix kernel: ata7: PATA max PIO0 cmd 0xa100 ctl 0xa10e
> irq 3
> Mar 26 10:06:34 idefix kernel: ata7.00: CFA: SanDisk SDCFH-512,
> FhCA0145, max PIO4
> Mar 26 10:06:34 idefix kernel: ata7.00: 1000944 sectors, multi 0: LBA
> Mar 26 10:06:34 idefix kernel: ata7.00: configured for PIO0
> Mar 26 10:06:34 idefix kernel: isa bounce pool size: 16 pages
> Mar 26 10:06:34 idefix kernel: scsi 11:0:0:0: Direct-Access     ATA     
> SanDisk SDCFH-51 FhCA PQ: 0 ANSI: 5
> Mar 26 10:06:34 idefix kernel: sd 11:0:0:0: [sdc] 1000944 512-byte
> hardware sectors (512 MB)
> Mar 26 10:06:34 idefix kernel: sd 11:0:0:0: [sdc] Write Protect is off
> Mar 26 10:06:34 idefix kernel: sd 11:0:0:0: [sdc] Write cache: disabled,
> read cache: enabled, doesn't support DPO or FUA
> Mar 26 10:06:34 idefix kernel: sd 11:0:0:0: [sdc] 1000944 512-byte
> hardware sectors (512 MB)
> Mar 26 10:06:34 idefix kernel: sd 11:0:0:0: [sdc] Write Protect is off
> Mar 26 10:06:34 idefix kernel: sd 11:0:0:0: [sdc] Write cache: disabled,
> read cache: enabled, doesn't support DPO or FUA
> Mar 26 10:07:04 idefix kernel:  sdc:<3>ata7.00: exception Emask 0x0 SAct
> 0x0 SErr 0x0 action 0x2 frozen
> Mar 26 10:07:04 idefix kernel: ata7.00: cmd
> 20/00:08:00:00:00/00:00:00:00:00/e0 tag 0 pio 4096 in
> Mar 26 10:07:04 idefix kernel:          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Mar 26 10:07:04 idefix kernel: ata7.00: status: { DRDY }
> Mar 26 10:07:04 idefix kernel: ata7: soft resetting link
> Mar 26 10:07:04 idefix kernel: ata7.00: configured for PIO0
> Mar 26 10:07:04 idefix kernel: ata7: EH complete
> Mar 26 10:07:34 idefix kernel: ata7.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x2 frozen
> Mar 26 10:07:34 idefix kernel: ata7.00: cmd
> 20/00:08:00:00:00/00:00:00:00:00/e0 tag 0 pio 4096 in
> Mar 26 10:07:34 idefix kernel:          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Mar 26 10:07:34 idefix kernel: ata7.00: status: { DRDY }
> Mar 26 10:07:34 idefix kernel: ata7: soft resetting link
> Mar 26 10:07:34 idefix kernel: ata7.00: configured for PIO0
> Mar 26 10:07:34 idefix kernel: ata7: EH complete
> Mar 26 10:08:04 idefix kernel: ata7.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x2 frozen
> Mar 26 10:08:04 idefix kernel: ata7.00: cmd
> 20/00:08:00:00:00/00:00:00:00:00/e0 tag 0 pio 4096 in
> Mar 26 10:08:04 idefix kernel:          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Mar 26 10:08:04 idefix kernel: ata7.00: status: { DRDY }
> Mar 26 10:08:04 idefix kernel: ata7: soft resetting link
> Mar 26 10:08:04 idefix kernel: ata7.00: configured for PIO0
> Mar 26 10:08:04 idefix kernel: ata7: EH complete
> 
> Any ideas on where this "report" should go?

Does irqpoll help?

-- 
tejun
