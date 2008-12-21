Return-Path: <linux-kernel-owner+w=401wt.eu-S1752486AbYLUW4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbYLUW4m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 17:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbYLUW4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 17:56:33 -0500
Received: from mail.work.de ([212.12.32.20]:39780 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbYLUW4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 17:56:32 -0500
Message-ID: <494EC98A.5020700@gmail.com>
Date: Mon, 22 Dec 2008 02:56:10 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: Grant Grundler <grundler@parisc-linux.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: MSI messages
References: <49438290.1080502@gmail.com>	 <20081214081210.GC13371@colo.lackof.org> <4944EAC3.1020407@gmail.com>	 <20081214185239.GA2039@colo.lackof.org>  <494D5FF7.50807@gmail.com> <1229897516.8269.8.camel@localhost>
In-Reply-To: <1229897516.8269.8.camel@localhost>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman wrote:
> On Sun, 2008-12-21 at 01:13 +0400, Manu Abraham wrote:
>> Grant Grundler wrote:
>>> On Sun, Dec 14, 2008 at 03:15:15PM +0400, Manu Abraham wrote:
>>> ...
>>>>> A "GSI" (Generic Sys Interrupt?) is associated with each entry in
>>>>> the MSI-X table. Driver then calls request_irq() to bind an interrupt
>>>>> handler to each GSI. So the driver never directly sees the "message".
>>>> Oh, you mean the array of irq_handlers in the MSI-X table should 
>>>> correspond to a particular message ?
>>> No. I mean each MSI-X entry has an address+message pair and each MSI-X entry
>>> is associated with the parameters passed to each call of request_irq().
>>> Pass in unique private data to each call of request_irq() and the driver
>>> can determine which message was delivered when the ISR gets called.
>>> (ISR == Interrupt Service Routine, aka driver IRQ handler)
>>
>> Is it possible that even when the config space says that multiple messages 
>> are supported, you cannot enable MSI-X ?
> 
> Yes, absolutely. Have a look at pci_msi_check_device() for starters. MSI
> can be disabled globally, or per-device by a quirk, the bridges above
> your device might not support MSI and the arch code may prevent
> MSI/MSI-X for some reason (ie. platform doesn't support it).
> 
> There's also a check in pci_enable_msix() to make sure the entries you
> pass in are valid.
> 
>>  ------------- with MSI-X -------------
>>
>> saa716x_pci_init (0): found a NEMO reference board PCIe card
>> ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 19 (level, low) -> IRQ 19
>> PCI: Setting latency timer of device 0000:05:00.0 to 64
>> saa716x_request_irq (0): Using MSI-X mode
>> saa716x_enable_msix (0): MSI-X request failed
> 
> For starters you should print the error code returned by
> pci_enable_msix() - unfortunately it returns EINVAL for many different
> reasons, but it will narrow it down a bit.

It does return -22

Regards,
Manu

saa716x_request_irq (0): Using MSI-X mode                                                                      
saa716x_enable_msix (0): MSI-X request failed <-22>                                                            
saa716x_request_irq (0): INT-A Mode                                                                            
    SAA7160 Rev 1 [1131:0000], irq: 19,                                                                        
    mmio: 0xf9480000                                                                                           
    SAA7160 64Bit, MSI Disabled, MSI-X=32 msgs
