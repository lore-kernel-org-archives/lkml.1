Return-Path: <linux-kernel-owner+w=401wt.eu-S1750941AbZIMEz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750941AbZIMEz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 00:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbZIMEzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 00:55:54 -0400
Received: from smtp-out.google.com ([216.239.45.13]:5516 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbZIMEzx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 00:55:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=K6ctJGWKauTEkEbPt7px4YkdP5sZnumSwvCr8lmYHjzPZ8HO1S/MhoIttT+ioOKfl
	Y7h7/EItuc3fwAkZNQIFw==
MIME-Version: 1.0
In-Reply-To: <4AAC632E.3090902@pobox.com>
References: <8b5805ff0909111906j68c20c3yf7226f2798a67d80@mail.gmail.com> 
	<1252721641.28368.34.camel@desktop> <8b5805ff0909120359g2faf661br463b19518d935110@mail.gmail.com> 
	<4AABD122.2000400@gmail.com> <8b5805ff0909121717w1516c273k2a568779b9c31662@mail.gmail.com> 
	<8b5805ff0909121726g2f1a78c1o1ff7289e059eabe5@mail.gmail.com> 
	<4AAC4315.6010102@pobox.com> <8b5805ff0909121941y38b7764fv3cc4d0b5c1ba6c89@mail.gmail.com> 
	<4AAC632E.3090902@pobox.com>
From: "Jung-Ik (John) Lee" <jilee@google.com>
Date: Sat, 12 Sep 2009 21:55:33 -0700
Message-ID: <8b5805ff0909122155u77a869c5t89a81fbf1a7eb391@mail.gmail.com>
Subject: Re: [PATCH] libata: Add pata_atp867x driver for Artop/Acard ATP867X 
	controllers
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Daniel Walker <dwalker@fifo99.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Grant Grundler <grundler@google.com>,
       Gwendal Grignou <gwendal@google.com>, Eric Uhrhane <ericu@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 8:12 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
> On 09/12/2009 10:41 PM, Jung-Ik (John) Lee wrote:
>>
>> On Sat, Sep 12, 2009 at 5:55 PM, Jeff Garzik<jgarzik@pobox.com>  wrote:
>>>
>>>
>>> General comment:
>>>
>>> * since you use iomap to map the region, you should use ioread{8,16,32} /
>>> iowrite{8,16,32} accessors.  Do not use inb/outb/inl/outl/etc.
>>
>> .
>> I used them for runtime hot registers by separately mapping them
>> simply to avoid an extra overhead of ioread/iowrite, over the
>> portability.
>> I know it's not a good idea but in this case for these hot ports can
>> in/out be used?
>
> It is _highly_ unlikely that the overhead is even measureable above the
> noise, I would think.  Do you have data showing that ioread/iowrite impose a
> noticeable penalty?

I agree in that it's hard to measure/signify the additional overhead,
since those io insts are already too slow.
Anyways, the two extra "if"s and one PIO_MASK on every ioread/iowrite
are pure overhead on top of in/out insts.

Thanks,
-John

>
>
>>
>>
>>>
>>> * run through scripts/checkpatch.pl
>>>
>>
>> Weird. I don't see any WS issues you pointed below in my source code
>> or git diff file, except UT = T/4 below.
>
> My apologies; most of those appear to be problems with Thunderbird.  I think
> it renders <tab> incorrectly.
>
>
>>>> +static void atp867x_set_dmamode(struct ata_port *ap, struct ata_device
>>>> *adev)
>>>> +{
>>>> +       struct pci_dev *pdev    = to_pci_dev(ap->host->dev);
>>>> +       struct atp867x_priv *dp = ap->private_data;
>>>> +       u8 speed = adev->dma_mode;
>>>> +       u8 b;
>>>> +       u8 mode;
>>>> +
>>>> +
>>>> +       switch (speed) {
>>>> +       case XFER_UDMA_6:
>>>> +               mode = ATP867X_IO_DMAMODE_UDMA_6;
>>>> +               break;
>>>> +       case XFER_UDMA_5:
>>>> +               mode = ATP867X_IO_DMAMODE_UDMA_5;
>>>> +               break;
>>>> +       case XFER_UDMA_4:
>>>> +               mode = ATP867X_IO_DMAMODE_UDMA_4;
>>>> +               break;
>>>> +       case XFER_UDMA_3:
>>>> +               mode = ATP867X_IO_DMAMODE_UDMA_3;
>>>> +               break;
>>>> +       case XFER_UDMA_2:
>>>> +               mode = ATP867X_IO_DMAMODE_UDMA_2;
>>>> +               break;
>>>> +       case XFER_UDMA_1:
>>>> +               mode = ATP867X_IO_DMAMODE_UDMA_1;
>>>> +               break;
>>>> +       case XFER_UDMA_0:
>>>> +               mode = ATP867X_IO_DMAMODE_UDMA_0;
>>>> +               break;
>>>> +       default:
>>>> +               printk(KERN_WARNING "ATP867X: Unsupported speed %#x."
>>>> +                       " Default to XFER_UDMA_0.\n", (unsigned)speed);
>>>> +               mode = ATP867X_IO_DMAMODE_UDMA_0;
>>>
>>> a table would be nice, preferred over a switch statement.  You may use
>>> ARRAY_SIZE() macro to generate a constant at compile time for number of
>>> elements in array.
>>
>> OK. I had it in a pure math like mode = speed - XFER_UDMA_0 +1;
>
> That's fine too.
>
>
>
>
>>>> +       /*
>>>> +        * Broken BIOS might not set latency high enough
>>>> +        */
>>>> +       pci_read_config_byte(pdev, PCI_LATENCY_TIMER,&v);
>>>> +       if (v<    0x80) {
>>>> +               v = 0x80;
>>>> +               pci_write_config_byte(pdev, PCI_LATENCY_TIMER, v);
>>>> +               printk(KERN_DEBUG "ATP867X: set latency timer of device
>>>> %s"
>>>> +                       " to %d\n", pci_name(pdev), v);
>>>> +       }
>>>
>>> this seems pointless - pci_set_master() already does this
>>>
>> pci_set_master won't re-set it if BIOS set it to somewhere between 16
>> and 256. This controller wants 0x80.
>> so, if BIOS set to less than 0x80, like 0x20, pci_set_master will keep
>> the value.
>> I could do this via pci fixup or quirks but that seems too much for
>> this simple setting.
>
> Given your explanation, that's fine.
>
>        Jeff
>
>
>
>
