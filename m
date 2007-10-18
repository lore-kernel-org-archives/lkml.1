Return-Path: <linux-kernel-owner+w=401wt.eu-S1763068AbXJRRA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763068AbXJRRA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756724AbXJRRAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:00:19 -0400
Received: from client062.sevenl.net ([66.241.137.62]:2224 "EHLO pcburn.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbXJRRAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:00:18 -0400
Message-ID: <47179116.2070505@pcburn.com>
Date: Thu, 18 Oct 2007 13:00:06 -0400
From: Chris Bergeron <chris@pcburn.com>
Reply-To: chris@pcburn.com
Organization: PCBurn Media
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Andrey Panin <pazke@donpac.ru>
CC: linux-kernel@vger.kernel.org
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
References: <4706AD19.4040605@pcburn.com> <20071010095432.GC30345@pazke.donpac.ru> <470E5714.4040303@pcburn.com> <20071012120826.GB23378@pazke.donpac.ru> <47150B06.3040306@pcburn.com> <20071017064219.GB1953@pazke.donpac.ru> <471689DA.4070008@pcburn.com> <20071018055755.GA9561@pazke.donpac.ru>
In-Reply-To: <20071018055755.GA9561@pazke.donpac.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Panin wrote:
> On 290, 10 17, 2007 at 06:16:58 -0400, Chris Bergeron wrote:
>   
>> Andrey Panin wrote:
>>     
>>> Is it possible to connect two ports and run getty on one port and minicom 
>>> on
>>> another ? We should check that UARTs are really working.
>>>
>>>   
>>>       
>> I used the on-board serial port as a known working control (after getting 
>> it to work with the other onboard serial port) to try and connect over to 
>> one of the Syba card ports (using Cutecom & getty).  The lines light up, 
>> but there's nothing getting sent from the 8-port as far as I can see.
>>     
>
> Oh crap... I missed this fscking "Disabling IRQ #17" line in your dmesg.
> Can you try with firewire controller disabled somehow ?
>
>   
Ah, I forgot to make note of that.  I did actually turn off Firewire in 
the BIOS.  Assuming that worked (and it looks like it did) the following 
section probably contains the relevant bits.  Still getting the IRQ 17 
error.

-- Chris

PCI: Setting latency timer of device 0000:00:05.0 to 64
NET: Registered protocol family 17
eth0: no IPv6 routers present
irq 17: nobody cared (try booting with the "irqpoll" option)
 [<c0104f45>] show_trace_log_lvl+0x1a/0x2f
 [<c0105939>] show_trace+0x12/0x14
 [<c0105951>] dump_stack+0x16/0x18
 [<c0152f90>] __report_bad_irq+0x39/0x79
 [<c01531af>] note_interrupt+0x1df/0x218
 [<c0153754>] handle_fasteoi_irq+0x91/0xb6
 [<c0105fef>] do_IRQ+0x7c/0x95
 [<c0104946>] common_interrupt+0x2e/0x34
 [<c010233a>] cpu_idle+0x1c/0xc2
 [<c02deed9>] rest_init+0x4d/0x4f
 [<c03e7979>] start_kernel+0x32a/0x332
 [<00000000>] 0x0
 =======================
handlers:
[<c023ecae>] (serial8250_interrupt+0x0/0x115)
Disabling IRQ #17
hda: DMA timeout retry


full dmesg output at 
http://pcburn.com/files/Syba_serial_controller/dmesg_with_1394_disabled.txt
