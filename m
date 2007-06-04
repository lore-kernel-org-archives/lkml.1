Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbXFDM5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbXFDM5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 08:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbXFDM5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 08:57:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:2000 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbXFDM5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 08:57:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HZ8IFUIjDzDwe2mjX7+OT8uLUlMCc5hcslkLNGg1jVpooOGmDfxVNa41S830zISkrSvSH9u46vApeHP1hP9QoIZvc5AWO73njhVpgdUonRPM7oK7xYcCl1aaE5ZJtD8sUL2W8hOS9vkxfVaLxyCOYIoSBB+9SS/FXR10TkOTqM8=
Message-ID: <46640C30.9050808@gmail.com>
Date: Mon, 04 Jun 2007 14:57:20 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Korb <ml@akana.de>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/1] ide: ide-generic, add another device exception
References: <20601315171560711667@wsc.cz> <46640ABA.7010308@ru.mvista.com>
In-Reply-To: <46640ABA.7010308@ru.mvista.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov napsal(a):
> Hello.
> 
> Jiri Slaby wrote:
> 
>> diff --git a/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
>> index f2c5a14..0d51a11 100644
>> --- a/drivers/ide/pci/generic.c
>> +++ b/drivers/ide/pci/generic.c
>> @@ -198,32 +198,41 @@ static ide_pci_device_t generic_chipsets[]
>> __devinitdata = {
>>  static int __devinit generic_init_one(struct pci_dev *dev, const
>> struct pci_device_id *id)
>>  {
>>      ide_pci_device_t *d = &generic_chipsets[id->driver_data];
>> -    u16 command;
>>      int ret = -ENODEV;
>>  
>>      /* Don't use the generic entry unless instructed to do so */
>>      if (id->driver_data == 0 && ide_generic_all == 0)
>>              goto out;
>>  
>> -    if (dev->vendor == PCI_VENDOR_ID_UMC &&
>> -        dev->device == PCI_DEVICE_ID_UMC_UM8886A &&
>> -        (!(PCI_FUNC(dev->devfn) & 1)))
>> -        goto out; /* UM8886A/BF pair */
>> -
>> -    if (dev->vendor == PCI_VENDOR_ID_OPTI &&
>> -        dev->device == PCI_DEVICE_ID_OPTI_82C558 &&
>> -        (!(PCI_FUNC(dev->devfn) & 1)))
>> -        goto out;
>> -
>> -    if (dev->vendor == PCI_VENDOR_ID_JMICRON) {
>> -        if (dev->device != PCI_DEVICE_ID_JMICRON_JMB368 &&
>> PCI_FUNC(dev->devfn) != 1)
>> +    switch (dev->vendor) {
>> +    case PCI_VENDOR_ID_UMC:
>> +        if (dev->device == PCI_DEVICE_ID_UMC_UM8886A &&
>> +                !(PCI_FUNC(dev->devfn) & 1))
>> +            goto out; /* UM8886A/BF pair */
>> +        break;
>> +    case PCI_VENDOR_ID_OPTI:
>> +        if (dev->device == PCI_DEVICE_ID_OPTI_82C558 &&
>> +                !(PCI_FUNC(dev->devfn) & 1))
>> +            goto out;
>> +        break;
>> +    case PCI_VENDOR_ID_JMICRON:
>> +        if (dev->device != PCI_DEVICE_ID_JMICRON_JMB368 &&
>> +                PCI_FUNC(dev->devfn) != 1)
>> +            goto out;
>> +        break;
>> +    case PCI_VENDOR_ID_NS:
>> +        if (dev->device == PCI_DEVICE_ID_NS_87410 &&
>> +                (dev->class >> 8) != PCI_CLASS_STORAGE_IDE)
>>              goto out;
>> +        break;
>>      }
> 
>   Could you intend the if() conditions carried to another line the way
> they were intended before?

I could, if you tell me the reason.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
