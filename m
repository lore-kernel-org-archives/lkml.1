Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbZAJLuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbZAJLuT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 06:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbZAJLuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 06:50:03 -0500
Received: from h155.mvista.com ([63.81.120.155]:63167 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752200AbZAJLuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 06:50:02 -0500
Message-ID: <49688B63.5030105@ru.mvista.com>
Date: Sat, 10 Jan 2009 14:49:55 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
References: <200901091334.55823.borntraeger@de.ibm.com> <200901101009.13699.borntraeger@de.ibm.com> <20090110104114.633cacd8@lxorguk.ukuu.org.uk> <200901101242.05203.borntraeger@de.ibm.com>
In-Reply-To: <200901101242.05203.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Christian Borntraeger wrote:

>>> I did some printk debugging. 
>>> __atapi_pio_bytes is called with bytes=18. That means with 32bit transfers
>>> there is a 2 byte trailing transfer, which triggers this WARN_ON.
>>>       
>> Ouch.. that means all that someone issued a multiple segment data
>> transfer with a 2 byte aligned chunk in the middle.
>>
>> That is a bit of a suprise because we set blk_queue_dma_alignment to 3 so
>> the block layer should never hand us an sg list in that form. That means
>> we've either got a block layer bug or someone somewhere is generating
>> invalid sg lists internally to libata.
>>
>> Can you dump qc->cdb[] and see what command is getting issued in the
>> broken form ?
>>     
>
> I instrumented __atapi_pio_bytes to print some variables. This is the dump of
> the first two:
>
> [    1.484730] count: 36 sg->length: 36 qc->cursg_ofs: 0 bytes: 36
> [    1.485709] qc->cdb[]:12000000240000000000000000000000
> That works fine.
>   

   That's the typical INQUIRY command with 36-byte data length.

> [    1.499843] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U10N  1.05 PQ: 0 ANSI: 5
> [    1.508389] count: 18 sg->length: 96 qc->cursg_ofs: 0 bytes: 18
> [    1.509369] qc->cdb[]:03000000600000000000000000000000
> That one is broken.
>   

   That's the typical REQUEST SENSE command with 18-byte data length.

MBR, Sergei


