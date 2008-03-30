Return-Path: <linux-kernel-owner+w=401wt.eu-S1752954AbYC3LM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbYC3LM3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 07:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYC3LMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 07:12:21 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59865 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbYC3LMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 07:12:20 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47EF757F.9080501@s5r6.in-berlin.de>
Date: Sun, 30 Mar 2008 13:11:59 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Martin Michlmayr <tbm@cyrius.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: nobody cared about IRQ 19 (firewire, on a HP 2510p notebook)
References: <20080321153952.GA26354@deprecation.cyrius.com> <47E3E2CF.5070408@s5r6.in-berlin.de>
In-Reply-To: <47E3E2CF.5070408@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote on 2008-03-21:
> Martin Michlmayr wrote:
>> I just got the following in dmesg a few minutes after booting my
>> notebook which was idle at the time this occurred.  This was with
>> 2.6.25-rc6 but I've seen the same with 2.6.22 (see the attached
>> dmesg from 2.6.22).
>>
>> irq 19: nobody cared (try booting with the "irqpoll" option)
>> Pid: 0, comm: swapper Not tainted 2.6.25-rc6-amd64 #1
>>
>> Call Trace:
>>  <IRQ>  [<ffffffff80271c0b>] __report_bad_irq+0x38/0x7c
>>  [<ffffffff80271e51>] note_interrupt+0x202/0x249
>>  [<ffffffff8027274e>] handle_fasteoi_irq+0xab/0xd0
>>  [<ffffffff8020f82c>] do_IRQ+0x6e/0xda
>>  [<ffffffff8020c65d>] ret_from_intr+0x0/0x19
>>  <EOI>  [<ffffffff80221831>] ? native_irq_enable+0x6/0x7
>>  [<ffffffff88006330>] ? :processor:acpi_idle_enter_bm+0x2ab/0x325
>>  [<ffffffff803b5ef3>] ? menu_select+0x70/0x99
>>  [<ffffffff803b52e1>] ? cpuidle_idle_call+0x77/0xa6
>>  [<ffffffff803b526a>] ? cpuidle_idle_call+0x0/0xa6
>>  [<ffffffff8020b187>] ? cpu_idle+0xb1/0xdb
>>  [<ffffffff8042ea16>] ? rest_init+0x5a/0x5c
>>
>> handlers:
>> [<ffffffff8806f0f5>] (irq_handler+0x0/0x207 [firewire_ohci])
>> Disabling IRQ #19
> ...
>> 02:06.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller 
>> (rev 04)
> ...
> 
> According to your 2.6.22 dmesg, this happens a while after the firewire 
> subsystem seemingly successfully initialized the controller.  Could you 
> please post "dmesg | grep firewire" from 2.6.25-rc6 though?

[According to Martin's answer on 2008-03-22, the initialization of 
firewire-ohci also succeeds without noticeable problem under 2.6.25-rc6.]

> The __report_bad_irq() and "Disabling IRQ #..." can only have happened 
> because this condition in fw-ohci.c::irq_handler()
> 
>     event = reg_read(ohci, OHCI1394_IntEventClear);
> 
>     if (!event || !~event)
>         return IRQ_NONE;
> 
> happened a lot of times.  This means either
>   - Some MMIO reads return bogus values (all zero or all ones in a
>     bitfield which should be sparsely populated in a proper interrupt
>     event),
> or
>   - the interrupt was misrouted by the kernel's IRQ infrastructure was
>     unable to detect the misrouting, AFAIU.

Martin, please check whether the same happens if you disable 
firewire-ohci in the kernel config (or blacklist it in the modprobe 
config) and use the ohci1394 driver instead.

Thanks, and sorry for replying so late,
-- 
Stefan Richter
-=====-==--- --== ====-
http://arcgraph.de/sr/
