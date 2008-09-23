Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbYIWHgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbYIWHgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 03:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYIWHgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 03:36:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:7091 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbYIWHgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 03:36:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=No94q2LqziTgHWNTWM8MHgBF8teNYmSM+xDnHym7lE41VmvhK9uqcS8t2jHzokA83X
         zMh8nVpGuWxpk4dJ0QAG5gh38szGDhqb3X7Ry0+V/+go6oFQSuaLnkpv9dqkyWn2Qdey
         JtewIh/lu28ou7rmFbjc7LBKeKFhbYVGt706I=
Message-ID: <48D89C85.2080104@panasas.com>
Date: Tue, 23 Sep 2008 10:36:37 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <fa.CVrJhjm3R8sjl5Z+EEIzYm7QtW0@ifi.uio.no> <48B80B40.5060002@shaw.ca> <48B80D33.5050806@gmail.com> <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org>
In-Reply-To: <48B90F7F.8040308@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug. 30, 2008, 12:14 +0300, Tejun Heo <tj@kernel.org> wrote:
> Konstantin Kletschke wrote:
>> Am 2008-08-29 16:52 +0200 schrieb Tejun Heo:
>>
>>>   http://article.gmane.org/gmane.linux.ide/34077
>> I have this patch actually applied and had switched off the computer
>> afterwards completely for more than one hour two times. Each time it
>> booted then (this was the patch you suggested initially to Many Maxwell
>> this month to this list).
>>
>> Everything seems to work fine, but my dmesg and /var/log/messages is
>> flooded with this now:
>>
>> Aug 29 23:20:39 zappa ata1: EH complete
>> Aug 29 23:20:41 zappa ata1: EH complete
>> Aug 29 23:20:47 zappa ata1: EH complete
>> Aug 29 23:20:49 zappa ata1: EH complete
>> Aug 29 23:20:51 zappa ata1: EH complete
>> Aug 29 23:20:53 zappa ata1: EH complete
>> Aug 29 23:20:55 zappa ata1: EH complete
>> Aug 29 23:20:56 zappa ata1: EH complete
>> Aug 29 23:20:59 zappa ata1: EH complete
>> Aug 29 23:21:01 zappa ata1: EH complete

I'm seeing a similar problem after upgrading from 
2.6.25.14-108.fc9.x86_64 to 2.6.27-rc6.

>From what I can tell the messages
Sep 23 10:27:20 pangw kernel: ata6: EH pending after 5 tries, giving up
Sep 23 10:27:20 pangw kernel: ata6: EH complete

are printed for a disconnected ATA port that's a neighbor
of one that's occupied.

these are the ports that are in use:
Sep 23 10:19:40 pangw kernel: ata1.00: ATA-6: ST3160023A, 3.01, max UDMA/100
Sep 23 10:19:40 pangw kernel: ata2.00: ATAPI: _NEC DVD_RW ND-3550A, 1.05, max UDMA/33
[PATA]
Sep 23 10:19:40 pangw kernel: ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)

The WDC drive was previously on ata3 and the message were then printed
for ata4.  This makes me thunk it might be related to managing of
dual-ported sata_nv chips?

before:
Sep 21 19:14:10 pangw kernel: sata_nv 0000:00:08.0: PCI INT A -> Link[APSJ] -> GSI 20 (level, low) -> IRQ 20
Sep 21 19:14:10 pangw kernel: scsi2 : sata_nv
Sep 21 19:14:10 pangw kernel: scsi3 : sata_nv
Sep 21 19:14:10 pangw kernel: ata3: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xcc00 irq 21
Sep 21 19:14:10 pangw kernel: ata4: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xcc08 irq 21
Sep 21 19:14:10 pangw kernel: ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Sep 21 19:14:10 pangw kernel: ata3.00: ATA-7: WDC WD1600JS-60MHB1, 10.02E02, max UDMA/100
Sep 21 19:14:10 pangw kernel: ata3.00: 312581808 sectors, multi 16: LBA48 
Sep 21 19:14:10 pangw kernel: ata3.00: configured for UDMA/100
Sep 21 19:14:10 pangw kernel: scsi 2:0:0:0: Direct-Access     ATA      WDC WD1600JS-60M 10.0 PQ: 0 ANSI: 5
Sep 21 19:14:10 pangw kernel: sd 2:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
Sep 21 19:14:10 pangw kernel: sd 2:0:0:0: [sdb] Write Protect is off
Sep 21 19:14:10 pangw kernel: sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Sep 21 19:14:10 pangw kernel: sd 2:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
Sep 21 19:14:10 pangw kernel: sd 2:0:0:0: [sdb] Write Protect is off
Sep 21 19:14:10 pangw kernel: sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Sep 21 19:14:10 pangw kernel: sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 >
Sep 21 19:14:10 pangw kernel: sd 2:0:0:0: [sdb] Attached SCSI disk
Sep 21 19:14:10 pangw kernel: sata_nv 0000:00:08.0: PCI INT A -> Link[APSJ] -> GSI 20 (level, low) -> IRQ 20
Sep 21 19:14:10 pangw kernel: scsi4 : sata_nv
Sep 21 19:14:10 pangw kernel: scsi5 : sata_nv
Sep 21 19:14:10 pangw kernel: ata5: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xb800 irq 20
Sep 21 19:14:10 pangw kernel: ata6: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xb808 irq 20
Sep 21 19:14:10 pangw kernel: ata4: EH complete

after:
Sep 23 09:55:45 pangw kernel: sata_nv 0000:00:08.0: PCI INT A -> Link[APSJ] -> GSI 20 (level, low)
 -> IRQ 20
Sep 23 09:55:45 pangw kernel: scsi4 : sata_nv
Sep 23 09:55:45 pangw kernel: scsi5 : sata_nv
Sep 23 10:19:40 pangw kernel: ata5: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xb800 irq 20
Sep 23 10:19:40 pangw kernel: ata6: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xb808 irq 20
Sep 23 10:19:40 pangw kernel: ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Sep 23 10:19:40 pangw kernel: ata5.00: ATA-7: WDC WD1600JS-60MHB1, 10.02E02, max UDMA/100
Sep 23 10:19:40 pangw kernel: ata5.00: 312581808 sectors, multi 16: LBA48 
Sep 23 10:19:40 pangw kernel: ata5.00: configured for UDMA/100
Sep 23 10:19:40 pangw kernel: scsi 4:0:0:0: Direct-Access     ATA      WDC WD1600JS-60M 10.0 PQ: 0 ANSI: 5
Sep 23 10:19:40 pangw kernel: sd 4:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
Sep 23 10:19:40 pangw kernel: sd 4:0:0:0: [sdb] Write Protect is off
Sep 23 10:19:40 pangw kernel: sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Sep 23 10:19:40 pangw kernel: sd 4:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
Sep 23 10:19:40 pangw kernel: sd 4:0:0:0: [sdb] Write Protect is off
Sep 23 10:19:40 pangw kernel: sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Sep 23 10:19:40 pangw kernel: sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 >
Sep 23 10:19:40 pangw kernel: sd 4:0:0:0: [sdb] Attached SCSI disk
Sep 23 10:19:40 pangw kernel: ata6: EH complete

Benny

> 
> Hmm... Can you post full dmesg output?  We used to see things like above
> when ATAPI CHECK SENSE handling somehow failed to tell EH that it was an
> exception not worth whining about.  Maybe EH action mask is not being
> cleared properly?
> 
>> I am curious if it boots tomorrow after sleeping for one night :-P
> 
> I somehow feel pretty optimistic about that part.  :-)
> 

