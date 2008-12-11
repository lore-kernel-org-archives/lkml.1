Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbYLKIn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbYLKIn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 03:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbYLKInU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 03:43:20 -0500
Received: from smtp1.nine.ch ([217.150.241.29]:33042 "EHLO smtp1.nine.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbYLKInT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 03:43:19 -0500
X-Greylist: delayed 1127 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Dec 2008 03:43:18 EST
Message-ID: <4940CE1F.5080605@miromico.ch>
Date: Thu, 11 Dec 2008 09:23:59 +0100
From: Alex Raimondi <mailinglist@miromico.ch>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Segfault in fbcmap.c => Compiler bug?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am using latest atmel avr32 kernel (2.6.27) form git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git. 
I am on it's master branch. I added a few patches specific to our own board (hammerhead). 

When compiling with support for atmel_lcdfb the kernel segfaults at module probe.

This is the segfault output:

**********************************
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler cfq registered (default)
atmel_lcdfb atmel_lcdfb.0: 225KiB frame buffer at 13940000 (mapped at b3940000)
Unable to handle kernel NULL pointer dereference at virtual address 00000000
ptbr = 901de000 pgd = 00000000
Oops: Kernel access of bad area, sig: 11 [#1]
FRAME_POINTER chip: 0x01f:0x1e82 rev 2
Modules linked in:
PC is at fb_set_cmap+0x4e/0xb4
LR is at fb_set_var+0x15a/0x1c4
pc : [<900cf9de>]    lr : [<900cec7e>]    Not tainted
sp : 93819c40  r12: 00000000  r11: 93840c00
r10: 00000000  r9 : 00000000  r8 : 00000100
r7 : 93819c50  r6 : 93840c14  r5 : 93840dec  r4 : 00000000
r3 : 93840c00  r2 : 00000000  r1 : 9397f200  r0 : 9397f000
Flags: qvNzC
Mode bits: hjmde....g
CPU Mode: Supervisor
Process: swapper [1] (task: 93816000 thread: 93818000)
Stack: (0x93819c40 to 0x9381a000)
9c40: 00000000 00000000 93829e00 0000ffff 900cec7e 93819d28 93840c14 93819c78 
9c60: 00000000 93840c00 00000000 93840c14 00000080 00003040 00000000 00021220 
9c80: 00000000 900150d0 93819c98 00000000 10040011 00000000 90015214 93819cac 
9ca0: 00000001 93840c14 00000000 90015426 93819cc0 00000001 93840c14 00000000 
9cc0: 90014626 93819cd4 00400004 93840c14 00000000 900d99d8 93819d28 901e1bd4 
9ce0: 93840c14 00000000 07735940 93840e3c 900cfad4 93819d14 00000000 93840dec 
9d00: 00000000 00000100 00000000 93840c00 93840e3c 900098a4 93819da4 901e1bd4 
9d20: 000000e1 00000000 900098fa 93819da4 901e1bd4 000000e1 00000000 901e1b40 
9d40: 93840c00 93840c00 93840e3c 93840c14 93819d80 901e1b48 00000000 00000000 
9d60: 13940000 b3940000 00000001 00000000 9383ba50 00000000 00000000 00000001 
9d80: 9007b5d0 93819da4 00000000 901e1bb0 00000000 901e1b48 901f4020 901f7d88 
9da0: 00000000 900f04e0 93819dc8 901e1b48 901e1bf4 00000000 901f4020 901f4020 
9dc0: 901f7d88 00000000 900efcac 93819ddc 901e1b48 901e1bf4 00000000 900efd52 
9de0: 93819e00 901e1b48 901e1bf4 00000000 901f4020 901f4020 901f7d88 00000000 
9e00: 900ef672 93819e2c 00000000 93819e24 00000000 900efd18 901f4020 901f7d88 
9e20: 00000000 93803ab8 901e1b90 900efb92 93819e50 00000000 901f4020 00000000 
9e40: 901f7b9c 9383ea20 901f7d88 00000000 900ef948 93819e64 00000000 901f4020 
9e60: 00000000 900efe8c 93819e88 901fea80 901f4020 00000000 900094c4 00000000 
9e80: 90000348 00000000 900f05ee 93819eac 901fea80 901f4000 00000000 900094c4 
9ea0: 00000000 90000348 00000000 900f05fe 93819ec0 901fea80 901f4000 00000000 
9ec0: 900094d2 93819ed4 901fea80 90012734 00000000 90013fba 93819fc8 901fea80 
9ee0: 90012734 00000000 900c22da 93819f2c 00000000 9382bc00 900c23c4 93819f2c 
9f00: 93803380 00000000 00000000 93819f64 93814094 00000000 900c217a 93819f3c 
9f20: 90206844 000000d0 00000000 900c23de 93819f50 90206844 9382bc00 00000000 
9f40: 9382c6c0 90205438 90000348 00000000 90075c6c 93819f68 90206844 9382bc00 
9f60: 00000000 00000068 90075e20 93819f90 9382bc00 901e6090 00000000 00000020 
9f80: 90205438 90000348 00000000 9382c6c0 900361b8 93819fb4 93819fa8 901e6090 
9fa0: 00000000 00000020 33320000 00000000 00005ea8 900361fa 93819fd8 0000011f 
9fc0: 901e9c90 00000000 90000390 93819fec 900128f8 90012734 00000000 00000000 
9fe0: 9001f74c 90000348 00000000 9001f74c 00000000 00000000 00000000 00000000 
Call trace:
 [<900cec7e>] fb_set_var+0x15a/0x1c4
 [<900098fa>] atmel_lcdfb_probe+0x422/0x578
 [<900f04e0>] platform_drv_probe+0x10/0x12
 [<900efcac>] driver_probe_device+0x84/0xf0
 [<900efd52>] __driver_attach+0x3a/0x50
 [<900ef672>] bus_for_each_dev+0x2e/0x4c
 [<900efb92>] driver_attach+0x12/0x14
 [<900ef948>] bus_add_driver+0x6c/0x178
 [<900efe8c>] driver_register+0x58/0xb0
 [<900f05ee>] platform_driver_register+0x56/0x5c
 [<900f05fe>] platform_driver_probe+0xa/0x38
 [<900094d2>] atmel_lcdfb_init+0xe/0x14
 [<90013fba>] do_one_initcall+0x36/0x10c
 [<90000390>] kernel_init+0x48/0x94
 [<9001f74c>] do_exit+0x0/0x4c0

Kernel panic - not syncing: Attempted to kill init!

**************************************************************

I pinned down the problem to the file drivers/video/fbcmap.c function fb_set_cmap( ... ). 
There is a for loop:

		for (i = 0; i < cmap->len; i++) {
			hred = *red++;
			hgreen = *green++;
			hblue = *blue++;

			if (transp) 
				htransp = *transp++;


The segfault happens at the if (transp) statment.

Now to the strange thing, which makes me guess this may be a problem related to a compiler bug:

When I change the if statment to:

			if (transp) {
				printk("e\n");
				htransp = *transp++;
			}

everything works fine. No segfault! The if case is never executed (no "e" is printed). This is reproduceable: Commenting out 
the printk => segfault, compiling with printk => no segfault.

For completeness this is the log with the printk compiled in:

***************************
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler cfq registered (default)
atmel_lcdfb atmel_lcdfb.0: 225KiB frame buffer at 13940000 (mapped at b3940000)
Console: switching to colour frame buffer device 40x30
atmel_lcdfb atmel_lcdfb.0: fb0: Atmel LCDC at 0xff000000 (mapped at ff000000), irq 1
atmel_usart.0: ttyS0 at MMIO 0xffe01000 (irq = 7) is a ATMEL_SERIAL
***********************************

Any ideas? How can I debug this?

Alex


