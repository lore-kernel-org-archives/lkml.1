Return-Path: <linux-kernel-owner+w=401wt.eu-S1757702AbZBZU7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702AbZBZU7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 15:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbZBZU7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 15:59:24 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:48196 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752903AbZBZU7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 15:59:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uuCJuUCWNEWcOQw3uz9bWUI+ae/HM7SDgZ++DmaZ2qOXvrh4CblV/n+fp4OkSwnIqyNI/XgyVXfd2Orefx+KLFxlAPQajXBJk5MxD4VNEzIrWO6xca48e1dA3rOO3VH6vFmh+Tfy/VKAUl9qoj5K0bL4MfBgq5iVRITMVNpYfvo=  ;
X-YMail-OSG: ZuGCUEsVM1nyPTcbAP0yKoMA9LZF1yAF8Gd2TSaf7VJcHMRsPbvPga3Oxil9prB4cDP0CAX8daQ2Mbba8VBhROg9hcjQv.zgrOUGjJ.KEHnxp1wiGqVgmH454qh9hJUPJrOuAh8cYDYY1LsJyTXH0MtN
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [patch/rfc 2.6.29-rc6 1/2] regulator: enumerate voltages
Date: Thu, 26 Feb 2009 12:59:18 -0800
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@sirena.org.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902261138.34859.david-b@pacbell.net> <1235678548.31223.47.camel@vega.slimlogic.co.uk>
In-Reply-To: <1235678548.31223.47.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902261259.19029.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, Liam Girdwood wrote:
> > 
> > Semi-related:  someone with time to spend on it might
> > find and fix the bug causing the regulator framework
> > to oops when regulator/core.c::set_machine_constraints()
> > returns an error code.
> 
> Any chance you can post the oops. Is it happening within the
> set_constraints() error path or sometime later on ?  

Later, after it returns.  This particular oops went away
with the tweak eliminating the need for pointless init of
constraints for fixed voltage (1.8V in this case) regulators.

- Dave


<3>set_machine_constraints: invalid 'VUSB1V8' voltage constraints
<1>Unable to handle kernel NULL pointer dereference at virtual address 00000004
<1>pgd = c0004000
<1>[00000004] *pgd=00000000
Internal error: Oops: 805 [#1] PREEMPT
CPU: 0    Not tainted  (2.6.29-rc6-omap1 #517)
PC is at kobj_kset_leave+0x34/0x5c
LR is at _spin_lock+0x50/0x58
pc : [<c01748a0>]    lr : [<c0336e84>]    psr: 20000013
sp : c7821978  ip : c7821950  fp : c782198c
r10: c785f8a8  r9 : c7888a08  r8 : c78dade0
r7 : ffffffea  r6 : 00000000  r5 : c785f8a8  r4 : c785f908
r3 : 00000000  r2 : c7888a6c  r1 : c785f90c  r0 : c7815308
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c5387f  Table: 80004019  DAC: 00000017
Process swapper (pid: 1, stack limit = 0xc78202e8)
Stack: (0xc7821978 to 0xc7822000)
1960:                                                       c785f908 c785f8a8 
1980: 		... deletia ...
1fe0: 00000000 00000000 00000000 c7821ff8 c004d6c8 c0008668 8b77de58 01fbdd0a 
Backtrace: 
[<c017486c>] (kobj_kset_leave+0x0/0x5c) from [<c01748f4>] (kobject_del+0x2c/0x40)
 r5:c785f8a8 r4:c785f908
[<c01748c8>] (kobject_del+0x0/0x40) from [<c01a94fc>] (device_del+0x158/0x170)
 r5:c785f8a8 r4:c785f908
[<c01a93a4>] (device_del+0x0/0x170) from [<c01a9528>] (device_unregister+0x14/0x20)
 r7:ffffffea r6:c785f808 r5:c0437150 r4:c785f8a8
[<c01a9514>] (device_unregister+0x0/0x20) from [<c0188614>] (regulator_register+0x208/0x248)
 r5:c0437150 r4:c785f800
[<c018840c>] (regulator_register+0x0/0x248) from [<c0189894>] (twl4030reg_probe+0xa4/0x108)
[<c01897f0>] (twl4030reg_probe+0x0/0x108) from [<c01ac778>] (platform_drv_probe+0x20/0x24)
 r6:c04371b0 r5:c7888a08 r4:c04371b0
[<c01ac758>] (platform_drv_probe+0x0/0x24) from [<c01ab920>] (really_probe+0x9c/0x148)
[<c01ab884>] (really_probe+0x0/0x148) from [<c01aba20>] (driver_probe_device+0x54/0x58)
 r7:c7888a68 r6:c7888a08 r5:c7888a08 r4:c04371b0
[<c01ab9cc>] (driver_probe_device+0x0/0x58) from [<c01abac0>] (__device_attach+0x10/0x14)
 r5:c01abab0 r4:00000000
[<c01abab0>] (__device_attach+0x0/0x14) from [<c01aae9c>] (bus_for_each_drv+0x50/0x84)
[<c01aae4c>] (bus_for_each_drv+0x0/0x84) from [<c01abb48>] (device_attach+0x58/0x70)
 r6:00000000 r5:c7888aac r4:c7888a08
[<c01abaf0>] (device_attach+0x0/0x70) from [<c01aacb8>] (bus_attach_device+0x30/0x64)
 r5:c7888a08 r4:c043b3f8
[<c01aac88>] (bus_attach_device+0x0/0x64) from [<c01a9830>] (device_add+0x148/0x284)
 r5:c7886820 r4:c7888a08
[<c01a96e8>] (device_add+0x0/0x284) from [<c01ace24>] (platform_device_add+0xf8/0x150)
 r7:c7888a8c r6:c7888a00 r5:00000000 r4:00000000
[<c01acd2c>] (platform_device_add+0x0/0x150) from [<c01b0714>] (add_numbered_child+0xe4/0x130)
 r7:00000120 r6:c7821bc0 r5:c7888a00 r4:00000000
[<c01b0630>] (add_numbered_child+0x0/0x130) from [<c01b07b0>] (add_regulator_linked+0x50/0x5c)
[<c01b0760>] (add_regulator_linked+0x0/0x5c) from [<c01b09f8>] (add_children+0x220/0x2d4)
[<c01b07d8>] (add_children+0x0/0x2d4) from [<c01b0eac>] (twl4030_probe+0x148/0x174)
 r8:c08010f4 r7:c041e848 r6:c7886200 r5:00000004 r4:00000178
[<c01b0d64>] (twl4030_probe+0x0/0x174) from [<c01cf6dc>] (i2c_device_probe+0x70/0x88)
[<c01cf66c>] (i2c_device_probe+0x0/0x88) from [<c01ab920>] (really_probe+0x9c/0x148)
 r7:c7886280 r6:c043b6f8 r5:c7886220 r4:c043b6f8
[<c01ab884>] (really_probe+0x0/0x148) from [<c01aba20>] (driver_probe_device+0x54/0x58)
 r7:c7886280 r6:c7886220 r5:c7886220 r4:c043b6f8
[<c01ab9cc>] (driver_probe_device+0x0/0x58) from [<c01abac0>] (__device_attach+0x10/0x14)
 r5:c01abab0 r4:00000000
[<c01abab0>] (__device_attach+0x0/0x14) from [<c01aae9c>] (bus_for_each_drv+0x50/0x84)
[<c01aae4c>] (bus_for_each_drv+0x0/0x84) from [<c01abb48>] (device_attach+0x58/0x70)
 r6:00000000 r5:c78862c4 r4:c7886220
[<c01abaf0>] (device_attach+0x0/0x70) from [<c01aacb8>] (bus_attach_device+0x30/0x64)
 r5:c7886220 r4:c043d558
[<c01aac88>] (bus_attach_device+0x0/0x64) from [<c01a9830>] (device_add+0x148/0x284)
 r5:c785ecf8 r4:c7886220
[<c01a96e8>] (device_add+0x0/0x284) from [<c01a9988>] (device_register+0x1c/0x20)
 r7:00000000 r6:c785ec50 r5:c7886200 r4:c7886220
[<c01a996c>] (device_register+0x0/0x20) from [<c01d069c>] (i2c_attach_client+0xc0/0x150)
 r5:c7886200 r4:c7886220
[<c01d05dc>] (i2c_attach_client+0x0/0x150) from [<c01d0d48>] (i2c_new_device+0x64/0x84)
 r7:c0420c90 r6:c785ec50 r5:c78064cc r4:c7886200
[<c01d0ce4>] (i2c_new_device+0x0/0x84) from [<c01d1388>] (i2c_scan_static_board_info+0x44/0x8c)
 r7:c0420c90 r6:00000000 r5:c785ec50 r4:c78064c0
[<c01d1344>] (i2c_scan_static_board_info+0x0/0x8c) from [<c01d145c>] (i2c_register_adapter+0x8c/0x144)
 r5:c785ec50 r4:00000000
[<c01d13d0>] (i2c_register_adapter+0x0/0x144) from [<c01d15b4>] (i2c_add_numbered_adapter+0xa0/0xb8)
 r5:c785ec50 r4:00000000
[<c01d1514>] (i2c_add_numbered_adapter+0x0/0xb8) from [<c0018c60>] (omap_i2c_probe+0x254/0x304)
 r5:c0420858 r4:c785ec00
[<c0018a0c>] (omap_i2c_probe+0x0/0x304) from [<c01ac778>] (platform_drv_probe+0x20/0x24)
 r8:00000001 r7:c043b3f8 r6:c043d7c8 r5:c0420860 r4:c043d7c8
[<c01ac758>] (platform_drv_probe+0x0/0x24) from [<c01ab920>] (really_probe+0x9c/0x148)
[<c01ab884>] (really_probe+0x0/0x148) from [<c01aba20>] (driver_probe_device+0x54/0x58)
 r7:c043b3f8 r6:c043d7c8 r5:c0420860 r4:c043d7c8
[<c01ab9cc>] (driver_probe_device+0x0/0x58) from [<c01aba8c>] (__driver_attach+0x68/0x8c)
 r5:c0420904 r4:c0420860
[<c01aba24>] (__driver_attach+0x0/0x8c) from [<c01ab170>] (bus_for_each_dev+0x4c/0x80)
 r7:c043b3f8 r6:c043d7c8 r5:c01aba24 r4:00000000
[<c01ab124>] (bus_for_each_dev+0x0/0x80) from [<c01ab79c>] (driver_attach+0x20/0x28)
 r6:c7887300 r5:00000000 r4:c043d7c8
[<c01ab77c>] (driver_attach+0x0/0x28) from [<c01aaaec>] (bus_add_driver+0xa4/0x170)
[<c01aaa48>] (bus_add_driver+0x0/0x170) from [<c01abd40>] (driver_register+0x98/0xcc)
 r7:c0018970 r6:00000000 r5:00000000 r4:c043d7c8
[<c01abca8>] (driver_register+0x0/0xcc) from [<c01accb0>] (platform_driver_register+0x6c/0x88)
 r5:00000000 r4:c0023fd8
[<c01acc44>] (platform_driver_register+0x0/0x88) from [<c0018984>] (omap_i2c_init_driver+0x14/0x1c)
[<c0018970>] (omap_i2c_init_driver+0x0/0x1c) from [<c002923c>] (__exception_text_end+0x5c/0x1a0)
[<c00291e0>] (__exception_text_end+0x0/0x1a0) from [<c000861c>] (do_initcalls+0x1c/0x38)
 r8:00000000 r7:00000000 r6:00000000 r5:00000000 r4:c0023fd8
[<c0008600>] (do_initcalls+0x0/0x38) from [<c0008658>] (do_basic_setup+0x20/0x24)
 r5:00000000 r4:c044b640
[<c0008638>] (do_basic_setup+0x0/0x24) from [<c00086b0>] (kernel_init+0x54/0xa8)
[<c000865c>] (kernel_init+0x0/0xa8) from [<c004d6c8>] (do_exit+0x0/0x254)
 r4:00000000
Code: e5942008 e5943004 e2841004 e5823000 (e5832004) 
<4>---[ end trace 1b75b31a2719ed1c ]---
<6>note: swapper[1] exited with preempt_count 2
<0>Kernel panic - not syncing: Attempted to kill init!



