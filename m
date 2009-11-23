Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbZKWUIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbZKWUIC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 15:08:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbZKWUIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 15:08:01 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:33988 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbZKWUIA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 15:08:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=k1YeaSIoU/BN3RynAI2beqewMV7KEvFcC6+6Ug8PtDxVrM4cZNzZWCVFX0vjJLukq+
         Og2+/4abnE/Wqvjk/7Yzf4RR+1+47KEJ/TjYEDVbv/LDdUL4DivVXJmiGHOw7lLqR6cN
         wAXvsNIw9PdRo6lXmafodoz1N+GhzBOtuEJK8=
MIME-Version: 1.0
In-Reply-To: <20091122175523.GA4860@atomide.com>
References: <65dfecfd0911191234s585182c3sf88aaebcbd1ccd56@mail.gmail.com> 
	<20091122175523.GA4860@atomide.com>
From: Chris Banker <cbanker@gmail.com>
Date: Mon, 23 Nov 2009 12:07:45 -0800
Message-ID: <65dfecfd0911231207kc07ede4i17b64c728f6d854e@mail.gmail.com>
Subject: Re: NULL pointer dereference with 2.6.31 on OMAP243
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much for the assistance, that seemed to fix the problem.

~Chris


On Sun, Nov 22, 2009 at 9:55 AM, Tony Lindgren <tony@atomide.com> wrote:
> Hi,
>
> Added linux-omap list and Paul to Cc.
>
> * Chris Banker <cbanker@gmail.com> [091119 12:34]:
>> I'm having trouble with the 2.6.31 kernel running on an OMAP2430
>> board.  I was able to get the board to boot using 2.6.31rc1, but am
>> having some issue with 2.6.31.
>>
>> With low-level debugging enabled, I get the output below.  It appears
>> to be an issue with the new hwmod system, which didn't exist in
>> 2.6.31rc1.  It seems to die during the initialization of mpu_hwmod.
>>
>> Anyone have any suggestions as to how to fix this or what to try?
>
> Good to hear somebody is playing with a 2430 :) What's the board
> you're using? I guess it is not an SDP based on the crystal rate at
> 19.2MHz?
>
> We had a similar issue with 2420, that got fixed by
> a7f20b2695eb6a00a5464089bacf75b8ed64725e.
>
> Maybe give it a try and see if it helps? I've attached Paul's patch
> too for reference.
>
> Regards,
>
> Tony
>
>
>> Thanks,
>> Chris
>>
>> ------------------------------------------------------------------------------------------------------------------------------------------------------
>>
>> Starting kernel ...
>>
>> Uncompressing Linux.....................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................
>> done, booting the kernel.
>> <5>Linux version 2.6.31-omap1 (cbanker@vcaeng05) (gcc version 4.3.3
>> (GCC) ) #27 Wed Nov 18 17:23:18 PST 2009
>> CPU: ARMv6-compatible processor [4107b366] revision 6 (ARMv6TEJ), cr=00c5387f
>> CPU: VIPT aliasing data cache, VIPT aliasing instruction cache
>> Machine: BFT Digital Modem
>> Memory policy: ECC disabled, Data cache writeback
>> <7>On node 0 totalpages: 32768
>> <7>free_area_init_node: node 0, pgdat c0f10848, node_mem_map c0f35000
>> <7>  Normal zone: 256 pages used for memmap
>> <7>  Normal zone: 0 pages reserved
>> <7>  Normal zone: 32512 pages, LIFO batch:7
>> <6>OMAP2430<6>
>> <6>SRAM: Mapped pa 0x40200000 to va 0xe3000000 size: 0x100000
>> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
>> <5>Kernel command line: root=/dev/ram0 rw console=ttys2,115200n8
>> PID hash table entries: 512 (order: 9, 2048 bytes)
>> <6>Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
>> <6>Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
>> <6>Memory: 128MB = 128MB total
>> <5>Memory: 114232KB available (3084K code, 327K data, 12124K init, 0K highmem)
>> <6>NR_IRQS:384
>> <6>Clocking rate (Crystal/DPLL/MPU): 19.2/660/330 MHz
>> <1>Unable to handle kernel NULL pointer dereference at virtual address 00000004
>> <1>pgd = c0004000
>> <1>[00000004] *pgd=00000000
>> Internal error: Oops: 5 [#1]
>> <d>Modules linked in:
>> CPU: 0    Not tainted  (2.6.31-omap1 #27)
>> PC is at _enable+0x78/0x208
>> LR is at release_console_sem+0x1a8/0x204
>> pc : [<c0be9098>]    lr : [<c0bff998>]    psr: a00001d3
>> sp : c0ee3f38  ip : c0ee3e80  fp : c0ee3f4c
>> r10: 80022140  r9 : 4107b366  r8 : 80022174
>> r7 : c0ee86b4  r6 : c0be95cc  r5 : c0ee6154  r4 : c0ee6154
>> r3 : 00000000  r2 : 00000000  r1 : 000005b2  r0 : 0000001f
>> Flags: NzCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
>> Control: 00c5387f  Table: 80004000  DAC: 00000017
>> Process swapper (pid: 0, stack limit = 0xc0ee2260)
>> Stack: (0xc0ee3f38 to 0xc0ee4000)
>> 3f20:                                                       c0ee6634 c0ee6154
>> 3f40: c0ee3f68 c0ee3f50 c0be9648 c0be902c 00000000 c0ee6154 c0be95cc c0ee3f88
>> 3f60: c0ee3f6c c0be8a6c c0be95d8 c0eece48 c0eece48 c0bdbe08 c0ee5b34 c0ee3f98
>> 3f80: c0ee3f8c c0be98f4 c0be8a44 c0ee3fb0 c0ee3f9c c000dfc4 c0be98a0 c0f11190
>> 3fa0: c0f11184 c0ee3fc0 c0ee3fb4 c000ef0c c000df50 c0ee3fd0 c0ee3fc4 c000b878
>> 3fc0: c000eee8 c0ee3ff4 c0ee3fd4 c0008a2c c000b84c c0008658 c0bdbe08 00c5387d
>> 3fe0: c0f11440 c0bdc20c 00000000 c0ee3ff8 80008034 c00088fc 00000000 00000000
>> Backtrace:
>> [<c0be9020>] (_enable+0x0/0x208) from [<c0be9648>] (_setup+0x7c/0xb0)
>>  r4:c0ee6154
>> [<c0be95cc>] (_setup+0x0/0xb0) from [<c0be8a6c>] (omap_hwmod_for_each+0x34/0x78)
>>  r6:c0be95cc r5:c0ee6154 r4:00000000
>> [<c0be8a38>] (omap_hwmod_for_each+0x0/0x78) from [<c0be98f4>]
>> (omap_hwmod_late_init+0x60/0x8c)
>>  r7:c0ee5b34 r6:c0bdbe08 r5:c0eece48 r4:c0eece48
>> [<c0be9894>] (omap_hwmod_late_init+0x0/0x8c) from [<c000dfc4>]
>> (omap2_init_common_hw+0x80/0xbc)
>> [<c000df44>] (omap2_init_common_hw+0x0/0xbc) from [<c000ef0c>]
>> (omap2430bft_init_irq+0x30/0x1c4)
>>  r5:c0f11184 r4:c0f11190
>> [<c000eedc>] (omap2430bft_init_irq+0x0/0x1c4) from [<c000b878>]
>> (init_IRQ+0x38/0x44)
>> [<c000b840>] (init_IRQ+0x0/0x44) from [<c0008a2c>] (start_kernel+0x13c/0x2ac)
>> [<c00088f0>] (start_kernel+0x0/0x2ac) from [<80008034>] (0x80008034)
>>  r6:c0bdc20c r5:c0f11440 r4:00c5387d
>> Code: 0a000005 e5933020 e592205c e593305c (e5920004)
>> <4>---[ end trace 1b75b31a2719ed1c ]---
>> <0>Kernel panic - not syncing: Attempted to kill the idle task!
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
