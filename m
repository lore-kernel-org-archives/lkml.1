Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbZDYSre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbZDYSre (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 14:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZDYSrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 14:47:24 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:34375 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721AbZDYSrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 14:47:23 -0400
X-Trace: 184265484/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.103.174/None/adrian@newgolddream.info
X-SBRS: None
X-RemoteIP: 79.69.103.174
X-IP-MAIL-FROM: adrian@newgolddream.info
X-SMTP-AUTH: 
X-MUA: Evolution 2.26.1 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag4FAEf38klPRWeu/2dsb2JhbACBUMtjg3QF
X-IronPort-AV: E=Sophos;i="4.40,246,1238972400"; 
   d="scan'208";a="184265484"
Subject: [PATCH] maple: input: fix up maple mouse driver
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: lkml <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 25 Apr 2009 19:46:56 +0100
Message-Id: <1240685216.4808.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The maple mouse driver currently in mainline is broken:

-bash-3.1# modprobe maplemouse
[   56.886378] input: Dreamcast Mouse as /devices/virtual/input/input3
[   56.918379] Unable to handle kernel NULL pointer dereference at virtual address 00000004
[   56.930543] pc = c003304e
[   56.934973] *pde = 00000000
[   56.944948] Oops: 0000 [#1]
[   56.947867] Modules linked in: maplemouse(+)
[   56.952353] 
[   56.953921] Pid : 1157, Comm: \0x09\0x09modprobe
[   56.958021] CPU : 0        \0x09\0x09Not tainted  (2.6.30-rc2-00130-g3e98f9f #1)
[   56.958052] 
[   56.966567] PC is at dc_mouse_open+0xe/0x40 [maplemouse]
[   56.972125] PR is at input_open_device+0x8a/0xc0
[   56.976944] PC  : c003304e SP  : 8c88bdcc SR  : 40008100 TEA : c0033834
[   56.983854] R0  : 000006c4 R1  : 00000000 R2  : 40008101 R3  : 00000000
[   56.990744] R4  : 8c8db800 R5  : c0033080 R6  : 00000005 R7  : 00000200
[   56.997635] R8  : 8c8db800 R9  : 8c8dbe3c R10 : 00000000 R11 : 8c98881c
[   57.004525] R12 : 8c8dbe64 R13 : 8ca50140 R14 : 8c88bdd4
[   57.010063] MACH: 00000497 MACL: 00000348 GBR : 29674440 PR  : 8c1b4d0a
[   57.016939] 
[   57.016954] Call trace:
[   57.021065] [<8c1b4d0a>] input_open_device+0x8a/0xc0
[   57.026267] [<8c1b8572>] mousedev_open_device+0x72/0x120
[   57.031826] [<8c1b4640>] input_attach_handler+0x0/0xa0
[   57.037208] [<8c1b9b24>] mousedev_connect+0x64/0x120
[   57.042407] [<8c1b4640>] input_attach_handler+0x0/0xa0
[   57.047786] [<8c1b4698>] input_attach_handler+0x58/0xa0
[   57.053255] [<8c1b4400>] input_match_device+0x0/0x1c0
[   57.058550] [<8c1b720c>] input_register_device+0x14c/0x240
[   57.064301] [<c0033216>] probe_maple_mouse+0x76/0x100 [maplemouse]
[   57.070782] [<8c19f75c>] driver_probe_device+0x7c/0x1c0
[   57.076267] [<8c19f926>] __driver_attach+0x86/0xa0
[   57.081289] [<8c039e20>] down+0x0/0xa0
[   57.085232] [<8c19eca8>] bus_for_each_dev+0x48/0x80
[   57.090344] [<8c19f8a0>] __driver_attach+0x0/0xa0
[   57.095271] [<8c19e960>] next_device+0x0/0x20
[   57.099845] [<8c19f592>] driver_attach+0x12/0x40
[   57.104688] [<8c03a420>] blocking_notifier_call_chain+0x0/0x20
[   57.110794] [<8c19f2a4>] bus_add_driver+0x84/0x240
[   57.115818] [<8c19fd68>] driver_register+0x48/0x180
[   57.120933] [<c0036000>] dc_mouse_init+0x0/0x20 [maplemouse]
[   57.126853] [<8c03a420>] blocking_notifier_call_chain+0x0/0x20
[   57.132965] [<8c1c65f8>] maple_driver_register+0x18/0x40
[   57.138529] [<c0036000>] dc_mouse_init+0x0/0x20 [maplemouse]
[   57.144451] [<8c03a420>] blocking_notifier_call_chain+0x0/0x20
[   57.150557] [<c003600c>] dc_mouse_init+0xc/0x20 [maplemouse]
[   57.156471] [<8c00208c>] do_one_initcall+0x2c/0x1a0
[   57.161597] [<8c03a432>] blocking_notifier_call_chain+0x12/0x20
[   57.167792] [<8c0493c4>] sys_init_module+0x84/0x1a0
[   57.172907] [<8c268940>] mutex_unlock+0x0/0x60
[   57.177567] [<8c03a420>] blocking_notifier_call_chain+0x0/0x20
[   57.183679] [<8c00823a>] syscall_call+0xc/0x10
[   57.188343] [<8c049340>] sys_init_module+0x0/0x1a0
[   57.193355] 
[   57.194917] Code:
[   57.196935]   c0033048:  mov.l     c0033064 <dc_mouse_open+0x24/0x40 [maplemouse]>, r5  ! c0033080 <dc_mouse_callback+0x0/0xc0 [maplemouse]>
[   57.210215]   c003304a:  mov.l     @(r0,r4), r1
[   57.215028]   c003304c:  mov.w     c0033062 <dc_mouse_open+0x22/0x40 [maplemouse]>, r7  ! 00000200 <0x200>
[   57.225220] ->c003304e:  mov.l     @(4,r1), r4
[   57.229944]   c0033050:  mov.l     c0033068 <dc_mouse_open+0x28/0x40 [maplemouse]>, r1  ! 8c1c6e40 <maple_getcond_callback+0x0/0x20>
[   57.242494]   c0033052:  jsr       @r1
[   57.246458]   c0033054:  mov       r15, r14
[   57.250907]   c0033056:  mov       #0, r0
[   57.255169]   c0033058:  mov       r14, r15
[   57.259610] 
[   57.261185] Process: modprobe (pid: 1157, stack limit = 8c88a001)
[   57.267533] Stack: (0x8c88bdcc to 0x8c88c000)
[   57.272070] bdc0:                            8c1b4d0a 8c88bdd4 8c1b8572 8c88bdf0 8c988850 
[   57.280803] bde0: 8c1b4640 8c33a964 00000000 8c988800 8c1b9b24 8c88be10 8ca50140 00000000 
[   57.289550] be00: 8c1b4640 8c33a964 8c988800 00000000 8c1b4698 8c88be24 8c8db800 8c307e50 
[   57.298298] be20: 8c1b4400 8c1b720c 8c88be38 8c307c2c 8c8db800 8c307e50 c0033216 8c88be54 
[   57.307049] be40: 8cccb200 c00337fc 8cbe1ec0 8cccb33c 8c8db800 8c19f75c 8c88be70 8c33a770 
[   57.315800] be60: c0033800 8cccb338 8cccb344 8cccb304 8c19f926 8c88be90 8ca50140 c0033800 
[   57.324550] be80: 8c039e20 8cccb338 c0033800 8cccb304 8c19eca8 8c88bea8 8c19f8a0 8c19e960 
[   57.333301] bea0: 0001d06f 00000000 8cc04ad8 8cce0a10 8c19f592 8c88becc 8c3085bc 8c03a420 
[   57.342050] bec0: c0033800 0001d06f 00000000 8c19f2a4 8c88bed4 8c19fd68 8c88bef4 8c32a064 
[   57.350799] bee0: c0036000 8c03a420 c0033800 0001d06f 29678000 8c1c65f8 8c88bf14 8c32a064 
[   57.359549] bf00: c0036000 8c03a420 c0033830 0001d06f 29678000 c003600c 8c88bf1c 8c00208c 
[   57.368300] bf20: 8c88bf24 00000000 00000028 00000028 00000640 00000018 c0033622 00000004 
[   57.377046] bf40: c0027030 00000000 00000000 00000000 00000000 00000000 00000000 8c03a432 
[   57.385785] bf60: 8c88bf80 00418d18 8c0493c4 8c88bf88 00418d18 8c268940 8c03a420 c0033830 
[   57.394536] bf80: 0001d06f 29678000 8c00823a 7bf74a8c 004213f0 00000000 00000071 0000007f 
[   57.403284] bfa0: 8c049340 00000000 00000000 7bf74a28 00000080 29678000 0001d06f 00421410 
[   57.412030] bfc0: 00421410 00000000 0040146c 00000000 004208e8 004213f0 00418d18 7bf74a8c 
[   57.420777] bfe0: 7bf74a8c 29611fc6 00403b8c 00008000 29674440 00000100 0655ea20 00000054 
[   57.434018] ---[ end trace 6888d26f86bbc7c8 ]---
Segmentation fault

This patch fixes the driver by ensuring the maple callback is called properly.


Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

iff --git a/drivers/input/mouse/maplemouse.c b/drivers/input/mouse/maplemouse.c
index d196abf..103e5a0 100644
--- a/drivers/input/mouse/maplemouse.c
+++ b/drivers/input/mouse/maplemouse.c
@@ -45,41 +45,30 @@ static void dc_mouse_callback(struct mapleq *mq)
 	input_sync(dev);
 }
 
-static int dc_mouse_open(struct input_dev *dev)
-{
-	struct dc_mouse *mse = dev->dev.platform_data;
-
-	maple_getcond_callback(mse->mdev, dc_mouse_callback, HZ/50,
-		MAPLE_FUNC_MOUSE);
-
-	return 0;
-}
-
-static void dc_mouse_close(struct input_dev *dev)
-{
-	struct dc_mouse *mse = dev->dev.platform_data;
-
-	maple_getcond_callback(mse->mdev, dc_mouse_callback, 0,
-		MAPLE_FUNC_MOUSE);
-}
-
-
+/* allow the mouse to be used */
 static int __devinit probe_maple_mouse(struct device *dev)
 {
-	struct maple_device *mdev = to_maple_dev(dev);
-	struct maple_driver *mdrv = to_maple_driver(dev->driver);
+	struct maple_device *mdev;
+	struct maple_driver *mdrv;
+	int error;
 	struct input_dev *input_dev;
 	struct dc_mouse *mse;
-	int error;
 
-	mse = kzalloc(sizeof(struct dc_mouse), GFP_KERNEL);
-	input_dev = input_allocate_device();
+	mdev = to_maple_dev(dev);
+	mdrv = to_maple_driver(dev->driver);
 
-	if (!mse || !input_dev) {
+	mse = kzalloc(sizeof(struct dc_mouse), GFP_KERNEL);
+	if (!mse) {
 		error = -ENOMEM;
 		goto fail;
 	}
 
+	input_dev = input_allocate_device();
+	if (!input_dev) {
+		error = -ENOMEM;
+		goto fail_nomem;
+	}
+
 	mse->dev = input_dev;
 	mse->mdev = mdev;
 
@@ -91,23 +80,23 @@ static int __devinit probe_maple_mouse(struct device *dev)
 		BIT_MASK(REL_WHEEL);
 	input_dev->name = mdev->product_name;
 	input_dev->id.bustype = BUS_HOST;
-	input_dev->open = dc_mouse_open;
-	input_dev->close = dc_mouse_close;
+	error =	input_register_device(input_dev);
+	if (error)
+		goto fail_register;
 
 	mdev->driver = mdrv;
 	maple_set_drvdata(mdev, mse);
 
-	error =	input_register_device(input_dev);
-	if (error)
-		goto fail;
+	maple_getcond_callback(mdev, dc_mouse_callback, HZ/50,
+		MAPLE_FUNC_MOUSE);
 
-	return 0;
+	return error;
 
-fail:
+fail_register:
 	input_free_device(input_dev);
-	maple_set_drvdata(mdev, NULL);
+fail_nomem:
 	kfree(mse);
-	mdev->driver = NULL;
+fail:
 	return error;
 }
 
@@ -120,7 +109,6 @@ static int __devexit remove_maple_mouse(struct device *dev)
 	input_unregister_device(mse->dev);
 	maple_set_drvdata(mdev, NULL);
 	kfree(mse);
-
 	return 0;
 }
 

