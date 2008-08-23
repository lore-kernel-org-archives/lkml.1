Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYHWUQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYHWUQL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 16:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbYHWUP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 16:15:56 -0400
Received: from smtp2.tech.numericable.fr ([82.216.111.38]:42413 "EHLO
	smtp2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbYHWUPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 16:15:55 -0400
Message-ID: <48B06FF9.1030404@numericable.fr>
Date: Sat, 23 Aug 2008 22:15:53 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird/3.0a2 (X11; 2008081609)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kenrel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user
 with the same regression
References: <48B0563B.2040207@numericable.fr>	 <86802c440808231217q3eebc738v863170b178bb03ab@mail.gmail.com>	 <48B067B3.6020008@numericable.fr> <86802c440808231310hdafc30aw6931b77ea926338e@mail.gmail.com>
In-Reply-To: <86802c440808231310hdafc30aw6931b77ea926338e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Sat, Aug 23, 2008 at 12:40 PM, Rufus&  Azrael
> <rufus-azrael@numericable.fr>  wrote:
>    
>> Yinghai Lu wrote:
>>      
>>> On Sat, Aug 23, 2008 at 11:26 AM, Rufus&   Azrael
>>> <rufus-azrael@numericable.fr>   wrote:
>>>
>>>        
>>>>> On Sat, Aug 23, 2008 at 4:58 AM, David Witbrodt<dawitbro@sbcglobal.net>
>>>>>   wrote:
>>>>>
>>>>>            
>>>>>>              
>>>>>>>   please send out after booting with hpet=disable
>>>>>>>   lspci -tv
>>>>>>>   lspci -vvxxx
>>>>>>>
>>>>>>>                
>>>>>>   Info attached:
>>>>>>
>>>>>>              
>>>>> 00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 13)
>>>>>         Subsystem: Elitegroup Computer Systems Device 2621
>>>>>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx+
>>>>>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium>TAbort-
>>>>> <TAbort-<MAbort->SERR-<PERR- INTx-
>>>>>         Region 0: I/O ports at fa00 [size=16]
>>>>>         Region 1: Memory at 80000000 (32-bit, non-prefetchable) [size=1K]
>>>>>         Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+
>>>>>         Kernel driver in use: piix4_smbus
>>>>> 00: 02 10 85 43 03 04 30 02 13 00 05 0c 00 00 80 00
>>>>> 10: 01 fa 00 00 00 00 00 80 00 00 00 00 00 00 00 00
>>>>> 20: 00 00 00 00 00 00 00 00 00 00 00 00 19 10 21 26
>>>>> 30: 00 00 00 00 b0 00 00 00 00 00 00 00 00 00 00 00
>>>>> 40: d4 3b 00 05 00 00 00 00 0f ff 00 00 00 00 00 00
>>>>> 50: f0 01 f0 0e f0 0f f0 07 11 0b f0 0f 00 00 00 00
>>>>> 60: 01 00 24 00 bf fd de 8f 3f 90 00 00 20 00 00 00
>>>>> 70: 00 01 00 00 08 00 c0 fe ff 6e 00 00 00 00 f0 0f
>>>>> 80: f0 0a f0 0f 00 00 00 00 00 00 00 00 8c 00 00 80
>>>>> 90: 01 fa 00 00 fa de ff 00 00 00 00 00 00 00 00 00
>>>>> a0: 00 00 ff ff ff ff f0 08 ff fd 12 02 16 7b 20 00
>>>>> b0: 08 00 02 a8 00 00 00 00 00 00 00 00 f0 0f 08 1a
>>>>> c0: ff ff ff ff 00 00 00 00 00 00 00 00 00 00 00 00
>>>>> d0: 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
>>>>> e0: 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>>>> f0: d8 0c 00 00 00 00 44 00 00 00 00 00 aa 00 10 01
>>>>> it seems kernel update BAR1 from 0xfed00000 to 0x80000000 after it can
>>>>> not give 0xfed00000 to that device.
>>>>> please try attached patch, and send out lspci -vvxxxx again.
>>>>> YH
>>>>> [PATCH] x86: protect hpet in BAR for one ATI chipset
>>>>>
>>>>> so avoid kernel don't allocate nre resource for it because it can not
>>>>> allocate the old
>>>>> address from BIOS.
>>>>>
>>>>> the same way like some IO APIC address in BAR handling
>>>>>
>>>>> Signed-off-by: Yinghai Lu<yhlu.kenrel@gmail.com>
>>>>>
>>>>> ---
>>>>>   drivers/pci/quirks.c |   16 ++++++++++++++++
>>>>>   1 file changed, 16 insertions(+)
>>>>> Index: linux-2.6/drivers/pci/quirks.c
>>>>> ===================================================================
>>>>> --- linux-2.6.orig/drivers/pci/quirks.c
>>>>> +++ linux-2.6/drivers/pci/quirks.c
>>>>> @@ -1918,6 +1918,22 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_B
>>>>>                          PCI_DEVICE_ID_NX2_5709S,
>>>>>                          quirk_brcm_570x_limit_vpd);
>>>>>
>>>>> +static void __init quirk_hpet_in_bar(struct pci_dev *pdev)
>>>>> +{
>>>>> +       int i;
>>>>> +       unsigned int base, size;
>>>>> +
>>>>> +       /* the BAR1 is the location of the HPET...we must
>>>>> +        * not touch this, so forcibly insert it into the resource tree
>>>>> */
>>>>> +       base = pci_resource_start(pdev, 1);
>>>>> +       size = pci_resource_len(pdev, 1);
>>>>> +       if (base&&    size) {
>>>>> +               insert_resource(&iomem_resource,&pdev->resource[1]);
>>>>> +               dev_info(&dev->dev, "HPET at %04x-%04x\n", name, base,
>>>>> base + size - 1);
>>>>> +       }
>>>>> +}
>>>>> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, 0x3485, quirk_hpet_in_bar);
>>>>> +
>>>>>   #ifdef CONFIG_PCI_MSI
>>>>>   /* Some chipsets do not support MSI. We cannot easily rely on setting
>>>>>    * PCI_BUS_FLAGS_NO_MSI in its bus flags because there are actually
>>>>>
>>>>>            
>>>> Hi Yinghai,
>>>>
>>>>
>>>> Your patch seems to be broken, see :
>>>>
>>>>
>>>>          
>>>>>   CC      drivers/pci/quirks.o
>>>>> drivers/pci/quirks.c: In function 'quirk_hpet_in_bar':
>>>>> drivers/pci/quirks.c:1804: erreur: 'dev' undeclared (first use in this
>>>>> function)
>>>>> drivers/pci/quirks.c:1804: erreur: (Each undeclared identifier is
>>>>> reported
>>>>> only once
>>>>> drivers/pci/quirks.c:1804: erreur: for each function it appears in.)
>>>>> drivers/pci/quirks.c:1804: erreur: 'name' undeclared (first use in this
>>>>> function)
>>>>> drivers/pci/quirks.c:1804: attention : trop d'arguments pour le format
>>>>> drivers/pci/quirks.c:1795: attention : unused variable 'i'
>>>>> make[2]: *** [drivers/pci/quirks.o] Erreur 1
>>>>>
>>>>>            
>>> please check v2.
>>>
>>> YH
>>>
>>>        
>> Thanks Yinghai,
>>
>> Your patch applied, I attach lspci -vvxxxx.
>>
>> Regards.
>>
>>
>> 00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 14)
>>         Subsystem: Micro-Star International Co., Ltd. Device 7327
>>         Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium>TAbort-
>> <TAbort-<MAbort->SERR-<PERR- INTx-
>>         Region 0: I/O ports at 0b00 [size=16]
>>         Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+
>>         Kernel driver in use: piix4_smbus
>> 00: 02 10 85 43 01 04 30 02 14 00 05 0c 00 00 80 00
>> 10: 01 0b 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 20: 00 00 00 00 00 00 00 00 00 00 00 00 62 14 27 73
>> 30: 00 00 00 00 b0 00 00 00 00 00 00 00 00 00 00 00
>> 40: d4 2b 00 05 00 00 00 00 0f ff 00 00 00 00 00 00
>> 50: 10 01 00 00 00 00 80 08 11 0b f0 0f 00 00 00 00
>> 60: 01 00 24 00 bf fd 9e 83 3f 90 00 00 20 00 00 00
>> 70: 00 01 00 00 08 00 c0 fe ff 2e 00 00 00 00 f0 0f
>> 80: f4 0a f0 0f 00 00 00 00 00 00 00 00 8c 00 00 80
>> 90: 01 0b 00 00 3b de ff 00 00 00 00 00 00 00 00 00
>> a0: 00 00 ff ff ff ff f0 08 02 f0 02 00 16 79 00 18
>> b0: 08 00 02 a8 00 00 00 00 00 00 00 00 f0 0f 08 1a
>> c0: ff ff ff ff 00 00 00 00 00 00 00 00 00 00 00 00
>> d0: 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
>> e0: 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> f0: d8 0c 00 00 00 00 44 00 00 00 00 00 aa 00 10 01
>>      
>
> bios didn't set HPET in BAR1?
>
> YH
>
>    
Yinghai,

How do I check this ?
