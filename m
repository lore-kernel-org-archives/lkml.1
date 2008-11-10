Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbYKJGj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbYKJGj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 01:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYKJGjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 01:39:20 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:33063 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbYKJGjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 01:39:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hRFbwAvCtrQ5+gZtaE6xHGMZl6zRUOx/ZR+YJRPo0nDZKqSD2jbSHxA8zUAZkGDhaW
         Ad+VfihI9Ah22Kmi3yCvk+T+SxeJqZ2ZCT66TDpKZscZJW1BBghWEu8DF9VaRaE+l0HE
         uHJz9WskOASmXcj1ylC7kd/EK7WNF3x6M3NNA=
Message-ID: <8d6898730811092239s3397ef6bw4bb5934de258786e@mail.gmail.com>
Date: Mon, 10 Nov 2008 12:09:17 +0530
From: "Nobin Mathew" <nobin.mathew@gmail.com>
To: "Grant Grundler" <grundler@parisc-linux.org>
Subject: Re: sharing interrupt between PCI device
Cc: "Jiri Slaby" <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, "Robert Hancock" <hancockr@shaw.ca>
In-Reply-To: <8d6898730811092235u4a41c664vd641d2792dee4c50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no>
	 <4910E8AC.7050407@shaw.ca>
	 <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com>
	 <20081108172716.GA28039@colo.lackof.org> <4915E43E.4010206@gmail.com>
	 <20081108191536.GC28039@colo.lackof.org>
	 <8d6898730811092235u4a41c664vd641d2792dee4c50@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lspci -vs 1:4 is taken before inserting the drivers.

Thanks

On Mon, Nov 10, 2008 at 12:05 PM, Nobin Mathew <nobin.mathew@gmail.com> wrote:
> lspci output
>
> [root@localhost ~]# lspci -vs 1:4
> 01:04.0 System peripheral: Compaq Computer Corporation Integrated
> Lights Out Controller (rev 03)
>        Subsystem: Hewlett-Packard Company Unknown device 3305
>        Flags: medium devsel, IRQ 11
>        I/O ports at 2800 [size=256]
>        Memory at fdee0000 (32-bit, non-prefetchable) [size=512]
>        Capabilities: [f0] Power Management version 3
>
> 01:04.2 System peripheral: Compaq Computer Corporation Integrated
> Lights Out  Processor (rev 03)
>        Subsystem: Hewlett-Packard Company Unknown device 3305
>        Flags: medium devsel, IRQ 225
>        BIST result: 00
>        I/O ports at 1400 [disabled] [size=256]
>        Memory at fded0000 (32-bit, non-prefetchable) [disabled] [size=2K]
>        Memory at fdec0000 (32-bit, non-prefetchable) [disabled] [size=8K]
>        Memory at fde00000 (32-bit, non-prefetchable) [disabled] [size=512K]
>        [virtual] Expansion ROM at fdd20000 [disabled] [size=64K]
>        Capabilities: [f0] Power Management version 3
>
> 01:04.4 USB Controller: Hewlett-Packard Company Proliant iLO2 virtual
> USB controller (prog-if 00 [UHCI])
>        Subsystem: Hewlett-Packard Company Unknown device 3305
>        Flags: medium devsel, IRQ 225
>        I/O ports at 1800 [disabled] [size=32]
>        Capabilities: [f0] Power Management version 3
>
> 01:04.6 IPMI SMIC interface: Hewlett-Packard Company Proliant iLO2
> virtual UART (prog-if 01)
>        Subsystem: Hewlett-Packard Company Unknown device 3305
>        Flags: medium devsel, IRQ 50
>        Memory at fddf0000 (32-bit, non-prefetchable) [size=256]
>        Capabilities: [f0] Power Management version 3
>
> dmesg messages and /proc/interupts are attached.
>
>
> command sequence just for reference
>
> insmod hpilo
> insmod uhci_hcd
> cat /proc/interrupts
> dmesg
> rmmod hpilo
> rmmod uhci_hcd
> dmesg
>
> Thanks
> Nobin Mathew
>
> On Sun, Nov 9, 2008 at 12:45 AM, Grant Grundler
> <grundler@parisc-linux.org> wrote:
>> On Sat, Nov 08, 2008 at 08:10:54PM +0100, Jiri Slaby wrote:
>>> Grant Grundler napsal(a):
>>> > So I see how the IRQ is enabled and disabled. I still don't see where
>>> > an interrupt handler is bound to IRQ 225 (output you posted today in
>>> > another email).
>>>
>>> This irq setup is done during pci_enable_device.
>>
>> Sorry, I wasn't quite correct: pci_enable_device() should only assign IRQs,
>> not enable them. request_irq() would enable them.
>>
>>> > Nobin, can you dump /proc/interrupts when both drivers
>>> > are loaded and also send the dmesg output after both are loaded?
>>>
>>> This won't show the hp driver as it doesn't request_irq.
>>
>> Yup - that's what I expect too. But I was afraid something else might
>> be calling request_irq() and I'm just not seeing it. :)
>>
>> grant
>>
>
