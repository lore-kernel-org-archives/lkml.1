Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbZLNVkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbZLNVkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756532AbZLNVkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:40:08 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:53691 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756574AbZLNVkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:40:06 -0500
Message-ID: <4B26B0D6.4080809@bluewatersys.com>
Date: Tue, 15 Dec 2009 10:40:38 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.montavista.com>,
       Joao Ramos <joao.ramos@inov.pt>,
       H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: Re: [PATCH] add PATA host controller support for Cirrus Logic's EP93xx
 CPUs
References: <200911261651.40928.bzolnier@gmail.com> <4B15BAA1.2010408@bluewatersys.com> <200912020206.59659.bzolnier@gmail.com>
In-Reply-To: <200912020206.59659.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 02 December 2009 01:53:53 am Ryan Mallon wrote:
>   
>> Bartlomiej Zolnierkiewicz wrote:
>>     
>>> Based on the older IDE host driver by Joao Ramos and review comments
>>> for it from Sergei Shtylyov.  Not yet tested with the real hardware.
>>>
>>>       
>> Hi Bartlomiej,
>>
>> I have got as far as patching this into my kernel and doing a build test
>> (still need to find a hard-disk to test). I got some build errors, see
>> below:
>>     
>
> Hi,
>
> Many thanks for picking this driver up.
>   
Okay, it now patches in cleanly. However, I get the following crash on boot:

ep93xx-ide ep93xx-ide: EP93xx PATA host controller driver initialized
ep93xx-ide: __pata_ep93xx_write - base = ce070000, value = a, addr = 1, t = 0
Unable to handle kernel NULL pointer dereference at virtual address 00000002
pgd = c0004000
[00000002] *pgd=00000000
Internal error: Oops: 5 [#1]
last sysfs file: 
Modules linked in:
CPU: 0    Not tainted  (2.6.32-06794-g17ded11-dirty #544)
PC is at __pata_ep93xx_write+0x38/0xc4
LR is at __pata_ep93xx_write+0x34/0xc4
pc : [<c0189dac>]    lr : [<c0189da8>]    psr: 60000093
sp : cd017e70  ip : 00000c3b  fp : 00000000
r10: cd12a754  r9 : c0351140  r8 : 00000000
r7 : 00000000  r6 : ce070000  r5 : 0000000a  r4 : 00000061
r3 : ce070000  r2 : cd017e64  r1 : c0301bda  r0 : 00000054
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: c000717f  Table: c0004000  DAC: 00000017
Process swapper (pid: 1, stack limit = 0xcd016270)
Stack: (0xcd017e70 to 0xcd018000)
7e60:                                     00000001 00000000 00000001 cd124000
7e80: cd124000 00000000 00000000 c018a148 cd124000 c018180c a0000013 c0181918
7ea0: cd12a750 cd124000 00000000 c01772fc cd12a750 00000028 c0187e6c c0351140
7ec0: c0344220 cd12a750 00000028 c0187e6c 00000000 c0177edc cd12a750 00000028
7ee0: c0187e6c 00000000 c0351140 c0344220 c0344218 ce070000 cd12a750 00000028
7f00: c0344e68 c0014508 c0351140 00000000 c0344220 c0344220 c0351024 cd12a7a0
7f20: c0350428 00000000 00000000 c0164904 c0344220 c0163a78 c0344220 c0344254
7f40: c0351024 cd12a7a0 c0350428 c0163b88 00000000 c0163b2c c0351024 c0163330
7f60: cd0084a8 cd00fb40 c001b3dc c0351024 c0351024 c0162c48 c02e4755 c02e4755
7f80: ffffffff c001b3dc c0351010 c0351024 c0014354 00000000 00000000 c0163e54
7fa0: c001b3dc c0351010 00000000 c0014354 00000000 c0164bec c001b3dc 00000000
7fc0: 00000000 c002038c c0014354 00000000 c035d740 c001b494 c001b3dc 00000000
7fe0: 00000000 00000000 00000000 c0008578 00000000 c0021ea0 c504c134 c504c136
[<c0189dac>] (__pata_ep93xx_write+0x38/0xc4) from [<c018a148>] (pata_ep93xx_freeze+0x40/0x6c)
[<c018a148>] (pata_ep93xx_freeze+0x40/0x6c) from [<c018180c>] (__ata_port_freeze+0x38/0x50)
[<c018180c>] (__ata_port_freeze+0x38/0x50) from [<c0181918>] (ata_eh_freeze_port+0x2c/0x3c)
[<c0181918>] (ata_eh_freeze_port+0x2c/0x3c) from [<c01772fc>] (ata_host_start+0x12c/0x1a4)
[<c01772fc>] (ata_host_start+0x12c/0x1a4) from [<c0177edc>] (ata_host_activate+0x1c/0xe8)
[<c0177edc>] (ata_host_activate+0x1c/0xe8) from [<c0014508>] (pata_ep93xx_probe+0x1a0/0x1c8)
[<c0014508>] (pata_ep93xx_probe+0x1a0/0x1c8) from [<c0164904>] (platform_drv_probe+0x18/0x1c)
[<c0164904>] (platform_drv_probe+0x18/0x1c) from [<c0163a78>] (driver_probe_device+0xa8/0x15c)
[<c0163a78>] (driver_probe_device+0xa8/0x15c) from [<c0163b88>] (__driver_attach+0x5c/0x7c)
[<c0163b88>] (__driver_attach+0x5c/0x7c) from [<c0163330>] (bus_for_each_dev+0x48/0x78)
[<c0163330>] (bus_for_each_dev+0x48/0x78) from [<c0162c48>] (bus_add_driver+0x9c/0x220)
[<c0162c48>] (bus_add_driver+0x9c/0x220) from [<c0163e54>] (driver_register+0xa4/0x130)
[<c0163e54>] (driver_register+0xa4/0x130) from [<c0164bec>] (platform_driver_probe+0x18/0x8c)
[<c0164bec>] (platform_driver_probe+0x18/0x8c) from [<c002038c>] (do_one_initcall+0x5c/0x1b4)
[<c002038c>] (do_one_initcall+0x5c/0x1b4) from [<c0008578>] (kernel_init+0x94/0x10c)
[<c0008578>] (kernel_init+0x94/0x10c) from [<c0021ea0>] (kernel_thread_exit+0x0/0x8)
Code: e58dc000 e58d7004 eb03cb2e e5864000 (e1d700b2) 
---[ end trace ed0490e29e490c57 ]---


I have added some of my own debugging. The problem appears to be that
__pata_ep93xx_write gets called from probe (via ata_host_activate), but
ap->private_data (ata_timing) is still null. The timing private_data is
set by pata_ep93xx_set_piomode, but that needs adev->pio_mode set, but I
don't know where this happens. I assume the ATA core handles this. Do I
need to call pata_ep93xx_set_piomode from pata_ep93xx_probe before
ata_host_activate, or should the private_data timing be set to some
default in the probe?

Thanks,
~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751 
Fax:   +64 3 3779135			  USA 1800 261 2934

