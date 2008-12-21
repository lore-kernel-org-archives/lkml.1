Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbYLUXGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbYLUXGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 18:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYLUXGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 18:06:40 -0500
Received: from mail.work.de ([212.12.32.20]:58568 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbYLUXGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 18:06:39 -0500
Message-ID: <494ECBC5.1040703@gmail.com>
Date: Mon, 22 Dec 2008 03:05:41 +0400
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

It seems that the bridge does support MSI. It looks like my video device is 
using MSI.


Regards,
Manu

pci 0000:01:00.0: Boot video device                                                                            
PCI: Setting latency timer of device 0000:00:01.0 to 64                                                        
assign_interrupt_mode Found MSI capability                                                                     
Allocate Port Service[0000:00:01.0:pcie00]                                                                     
PCI: Setting latency timer of device 0000:00:1c.0 to 64                                                        
assign_interrupt_mode Found MSI capability                                                                     
Allocate Port Service[0000:00:1c.0:pcie00]                                                                     
Allocate Port Service[0000:00:1c.0:pcie02]                                                                     
PCI: Setting latency timer of device 0000:00:1c.1 to 64                                                        
assign_interrupt_mode Found MSI capability                                                                     
Allocate Port Service[0000:00:1c.1:pcie00]                                                                     
Allocate Port Service[0000:00:1c.1:pcie02]                                                                     
PCI: Setting latency timer of device 0000:00:1c.2 to 64                                                        
assign_interrupt_mode Found MSI capability                                                                     
Allocate Port Service[0000:00:1c.2:pcie00]                                                                     
Allocate Port Service[0000:00:1c.2:pcie02]                                                                     
PCI: Setting latency timer of device 0000:00:1c.3 to 64                                                        
assign_interrupt_mode Found MSI capability                                                                     
Allocate Port Service[0000:00:1c.3:pcie00]                                                                     
Allocate Port Service[0000:00:1c.3:pcie02]                                                                     
PCI: Setting latency timer of device 0000:00:1c.4 to 64                                                        
assign_interrupt_mode Found MSI capability                                                                     
Allocate Port Service[0000:00:1c.4:pcie00]                                                                     
Allocate Port Service[0000:00:1c.4:pcie02]                                                                     
vesafb: framebuffer at 0x91000000, mapped to 0xf8880000, using 10240k, total 14336k                            
vesafb: mode is 1280x1024x16, linelength=2560, pages=1


04:00.0 Multimedia controller: Philips Semiconductors Device 7160 (rev 02)
        Subsystem: Technotrend Systemtechnik GmbH Device 3009
        Flags: bus master, fast devsel, latency 0, IRQ 11
        Memory at 93b00000 (64-bit, non-prefetchable) [size=1M]
        Capabilities: <access denied>

05:00.0 Multimedia controller: Philips Semiconductors Device 7160 (rev 01)
        Subsystem: Philips Semiconductors Device 0000
        Flags: bus master, fast devsel, latency 0, IRQ 19
        Memory at 93a00000 (64-bit, non-prefetchable) [size=1M]
        Capabilities: <access denied>
        Kernel driver in use: SAA716x Hybrid

