Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbXK1Vi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbXK1Vi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 16:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbXK1Vip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 16:38:45 -0500
Received: from smtp2-g19.free.fr ([212.27.42.28]:54532 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188AbXK1Vio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 16:38:44 -0500
Message-ID: <474DDFDE.7010204@free.fr>
Date: Wed, 28 Nov 2007 22:38:38 +0100
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.9) Gecko/20071030 SeaMonkey/1.1.6
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1: I/O error, system hangs
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>	 <4744A6F2.4030302@free.fr>	 <20071121144116.c932727b.akpm@linux-foundation.org>	 <4746814F.80502@free.fr> <4746866B.5070207@suse.de>	 <4746BB9D.2030508@suse.de>  <4747135C.60205@free.fr>	 <1195886569.3195.2.camel@localhost.localdomain> <47481FA6.9050506@free.fr>	 <1195910809.3195.5.camel@localhost.localdomain> <4748ACC7.4010509@free.fr> <1195976275.3427.6.camel@localhost.localdomain> <4749DD87.5020206@free.fr>
In-Reply-To: <4749DD87.5020206@free.fr>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le 25.11.2007 21:39, Laurent Riffard a écrit :
> Le 25.11.2007 08:37, James Bottomley a écrit :
>> On Sat, 2007-11-24 at 23:59 +0100, Laurent Riffard wrote:
>>> Le 24.11.2007 14:26, James Bottomley a écrit :
>>>> OK, could you post dmesgs again, please.  I actually tested this
>>> with an
>>>> aic79xx card, and for me it does cause Domain Validation to succeed
>>>> again.
>>> James, 
>>>
>>> Here is a dmesg produced by 2.6.24-rc3-mm1 + your patch "separates
>>> the 
>>> BLOCK and QUIESCE states
>>> correctly" (http://lkml.org/lkml/2007/11/24/8).
>>>
[...]
>>> [   25.521256] scsi0 : pata_via
>>> [   25.521711] scsi1 : pata_via
>>> [   25.524089] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xb800 irq 14
>>> [   25.524176] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xb808 irq 15
>>> [   25.683141] ata1.00: ATA-5: ST340016A, 3.75, max UDMA/100
>>> [   25.683208] ata1.00: 78165360 sectors, multi 16: LBA 
>>> [   25.683475] ata1.01: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
>>> [   25.684116] ata1.01: 160086528 sectors, multi 16: LBA 
>>> [   25.691127] ata1.00: configured for UDMA/100
>>> [   25.699142] ata1.01: configured for UDMA/100
>>> [   26.170860] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-4165B, DL05, max UDMA/33
>>> [   26.171562] ata2.01: ATAPI: CD-950E/AKU, A4Q, max MWDMA2, CDB intr
>>> [   26.330839] ata2.00: configured for UDMA/33
>>> [   26.490828] ata2.01: configured for MWDMA2
>>> [   26.503014] scsi 0:0:0:0: Direct-Access     ATA      ST340016A 3.75 PQ: 0 ANSI: 5
>>> [   26.504670] scsi 0:0:1:0: Direct-Access     ATA      Maxtor 6Y080L0 YAR4 PQ: 0 ANSI: 5
>>> [   26.509842] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4165B DL05 PQ: 0 ANSI: 5
>>> [   26.511673] scsi 1:0:1:0: CD-ROM            E-IDE    CD-950E/AKU A4Q  PQ: 0 ANSI: 5
>> [...]
>>> [   60.216113] sd 0:0:0:0: [sda] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
>>> [   60.216124] end_request: I/O error, dev sda, sector 16460
>> I think this one's quite easy:  PATA devices in libata are queue depth 1
>> (since they don't do NCQ).  Thus, they're peculiarly sensitive to the
>> bug where we fail over queue depth requests.
>>
>> On the other hand, I don't see how a filesystem request is getting
>> REQ_FAILFAST ... unless there's a bio or readahead issue involved.
>> Anyway, could you try this patch:
>>
>> http://marc.info/?l=linux-scsi&m=119592627425498
>>
>> Which should fix the queue depth issue, and see if the errors go away?
> 
> No, this one doesn't help...
 
still happens with 2.6.24-rc3-mm2...
-- 
laurent
