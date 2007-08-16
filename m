Return-Path: <linux-kernel-owner+w=401wt.eu-S933159AbXHPS4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbXHPS4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 14:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761895AbXHPS4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 14:56:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40207 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760010AbXHPS4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 14:56:24 -0400
Message-ID: <46C49DD6.9050508@garzik.org>
Date: Thu, 16 Aug 2007 14:56:22 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Sonic Zhang <sonic.adi@gmail.com>, Linux IDE <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH take #5] [libata] libata driver for bf548 on chip ATAPI
 controller.
References: <1187169256.31383.3.camel@sevens.analog.com>	 <46C3F6FB.2070909@garzik.org>	 <8bd0f97a0708160927s625fd5ax84cd6d12a693d9ad@mail.gmail.com>	 <46C49A0D.5080002@garzik.org> <8bd0f97a0708161146l70eeea69jd5fdedbaa8486590@mail.gmail.com>
In-Reply-To: <8bd0f97a0708161146l70eeea69jd5fdedbaa8486590@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On 8/16/07, Jeff Garzik <jeff@garzik.org> wrote:
>> Mike Frysinger wrote:
>>> On 8/16/07, Jeff Garzik <jeff@garzik.org> wrote:
>>>> Sonic Zhang wrote:
>>>>> +static void bfin_set_piomode(struct ata_port *ap, struct ata_device *adev)
>>>>> +{
>>>>> +     int mode = adev->pio_mode - XFER_PIO_0;
>>>>> +     unsigned long base = (unsigned long)ap->ioaddr.ctl_addr;
>>>> (added Bryan Wu to CC)
>>>>
>>>> Someone needs to need fix the bfin architecture:  the addresses on the
>>>> bfin_read/bfin_write functions should be 'void __iomem *' not unsigned long.
>>> there are no address pointers anymore, so there is nothing to cast ...
>>> the bfin_read/bfin_write macros are done in sexy asm:
>>> #define bfin_write8(addr,val) __asm__ __volatile__("b[%0] = %1;" ::
>>> "a"(addr), "d"(val))
>>> or i'm misunderstanding what you mean ...
>>>
>>> where do you see (unsigned long) ?
>> Look up (into the message you quoted).
> 
> yes, you quoted the driver, not the Blackfin core parts
> 
>> Regardless of the implementation, the C type system should be employed
>> to ensure that 'addr' is known to the compiler as 'void __iomem *'
>> rather than unsigned long.
> 
> i agree the specific pata driver should be declared the way you
> described, however i dont see how that has bearing on the
> bfin_read/bfin_write macros as you seemed to indicate

Macros completely ignore the C type system.  Look at other architectures 
if you cannot figure out how to implement a static inline with stronger 
typing.

	Jeff



