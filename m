Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbYLCMN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbYLCMN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYLCMNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:13:48 -0500
Received: from mercuryimc.plus.com ([80.229.200.144]:40700 "EHLO
	mimc.mimc.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751387AbYLCMNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:13:47 -0500
Message-ID: <49367691.5060007@mimc.co.uk>
Date: Wed, 03 Dec 2008 12:07:45 +0000
From: Mark Jackson <mpfj@mimc.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
CC: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Badness at mm/backing-dev.c:179
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit causes a "Badness at mm/backing-dev.c:179":-

f1d0b063d993527754f062c589b73f125024d216 is first bad commit
commit f1d0b063d993527754f062c589b73f125024d216
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Tue Dec 2 10:31:50 2008 -0800

     bdi: register sysfs bdi device only once per queue

     <snip>

     Tested-by: Peter Korsgaard <jacmet@sunsite.dk>
     Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
     Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
     Cc: David Woodhouse <dwmw2@infradead.org>
     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Below is the extract from dmesg:-

physmap platform flash device: 00800000 at 00000000
physmap-flash.0: Found 1 x16 devices at 0x0 in 16-bit bank
  Amd/Fujitsu Extended Query Table at 0x0040
number of CFI chips: 1
cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
RedBoot partition parsing not available
Using physmap partition information
Creating 4 MTD partitions on "physmap-flash.0":
0x00000000-0x00020000 : "u-boot"
0x00020000-0x007e0000 : "root"
------------[ cut here ]------------
Badness at mm/backing-dev.c:179
PC is at bdi_register+0xe/0x44
LR is at bdi_register_dev+0x16/0x20
pc : [<9003f07a>]    lr : [<9003f0c6>]    Not tainted
sp : 91c19ccc  r12: 91c5409c  r11: 00000000
r10: 901c56c8  r9 : 0000001f  r8 : 00000001
r7 : 91c19cd0  r6 : 91c5409c  r5 : 91d0bc00  r4 : 00000000
r3 : 91e9b200  r2 : 901fd3fc  r1 : 00000001  r0 : 00000004
Flags: qvNzc
Mode bits: hjmde....g
CPU Mode: Supervisor
Process: swapper [1] (task: 91c16000 thread: 91c18000)
Call trace:
  [<9003f0c6>] bdi_register_dev+0x16/0x20
  [<900d7cc4>] add_disk+0x88/0xb0
  [<90100148>] add_mtd_blktrans_dev+0x178/0x188
  [<901004ea>] mtdblock_add_mtd+0x36/0x3c
  [<900ffec4>] blktrans_notify_add+0x1a/0x3a
  [<900fe16c>] add_mtd_device+0x60/0xa0
  [<900fef2e>] add_mtd_partitions+0x37e/0x3a4
  [<90105614>] physmap_flash_probe+0x1ec/0x21c
  [<900f9eb4>] platform_drv_probe+0x10/0x12
  [<900f9680>] driver_probe_device+0x84/0xf0
  [<900f9726>] __driver_attach+0x3a/0x50
  [<900f904a>] bus_for_each_dev+0x2e/0x4c
  [<900f9566>] driver_attach+0x12/0x14
  [<900f9324>] bus_add_driver+0x6c/0x170
  [<900f9860>] driver_register+0x58/0xb0
  [<900fa0b6>] platform_driver_register+0x56/0x5c
  [<9000adca>] physmap_init+0xa/0x10
  [<900146da>] do_one_initcall+0x36/0x10c
  [<90000380>] kernel_init+0x48/0x94
  [<9001fca0>] do_exit+0x0/0x49c

0x007e0000-0x007f0000 : "splash"
------------[ cut here ]------------
Badness at mm/backing-dev.c:179
PC is at bdi_register+0xe/0x44
LR is at bdi_register_dev+0x16/0x20
pc : [<9003f07a>]    lr : [<9003f0c6>]    Tainted: G        W
sp : 91c19ccc  r12: 91c5409c  r11: 00000000
r10: 901c56c8  r9 : 0000001f  r8 : 00000002
r7 : 91c19cd0  r6 : 91c5409c  r5 : 91d0bc00  r4 : 00000000
r3 : 91e9b800  r2 : 901fd414  r1 : 00000002  r0 : 00000004
Flags: qvNzc
Mode bits: hjmde....g
CPU Mode: Supervisor
Process: swapper [1] (task: 91c16000 thread: 91c18000)
Call trace:
  [<9003f0c6>] bdi_register_dev+0x16/0x20
  [<900d7cc4>] add_disk+0x88/0xb0
  [<90100148>] add_mtd_blktrans_dev+0x178/0x188
  [<901004ea>] mtdblock_add_mtd+0x36/0x3c
  [<900ffec4>] blktrans_notify_add+0x1a/0x3a
  [<900fe16c>] add_mtd_device+0x60/0xa0
  [<900fef2e>] add_mtd_partitions+0x37e/0x3a4
  [<90105614>] physmap_flash_probe+0x1ec/0x21c
  [<900f9eb4>] platform_drv_probe+0x10/0x12
  [<900f9680>] driver_probe_device+0x84/0xf0
  [<900f9726>] __driver_attach+0x3a/0x50
  [<900f904a>] bus_for_each_dev+0x2e/0x4c
  [<900f9566>] driver_attach+0x12/0x14
  [<900f9324>] bus_add_driver+0x6c/0x170
  [<900f9860>] driver_register+0x58/0xb0
  [<900fa0b6>] platform_driver_register+0x56/0x5c
  [<9000adca>] physmap_init+0xa/0x10
  [<900146da>] do_one_initcall+0x36/0x10c
  [<90000380>] kernel_init+0x48/0x94
  [<9001fca0>] do_exit+0x0/0x49c

0x007f0000-0x00800000 : "env"
------------[ cut here ]------------
Badness at mm/backing-dev.c:179
PC is at bdi_register+0xe/0x44
LR is at bdi_register_dev+0x16/0x20
pc : [<9003f07a>]    lr : [<9003f0c6>]    Tainted: G        W
sp : 91c19ccc  r12: 91c5409c  r11: 00000000
r10: 901c56c8  r9 : 0000001f  r8 : 00000003
r7 : 91c19cd0  r6 : 91c5409c  r5 : 91d0bc00  r4 : 00000000
r3 : 91e9be00  r2 : 901fd42c  r1 : 00000003  r0 : 00000004
Flags: qvNzc
Mode bits: hjmde....g
CPU Mode: Supervisor
Process: swapper [1] (task: 91c16000 thread: 91c18000)
Call trace:
  [<9003f0c6>] bdi_register_dev+0x16/0x20
  [<900d7cc4>] add_disk+0x88/0xb0
  [<90100148>] add_mtd_blktrans_dev+0x178/0x188
  [<901004ea>] mtdblock_add_mtd+0x36/0x3c
  [<900ffec4>] blktrans_notify_add+0x1a/0x3a
  [<900fe16c>] add_mtd_device+0x60/0xa0
  [<900fef2e>] add_mtd_partitions+0x37e/0x3a4
  [<90105614>] physmap_flash_probe+0x1ec/0x21c
  [<900f9eb4>] platform_drv_probe+0x10/0x12
  [<900f9680>] driver_probe_device+0x84/0xf0
  [<900f9726>] __driver_attach+0x3a/0x50
  [<900f904a>] bus_for_each_dev+0x2e/0x4c
  [<900f9566>] driver_attach+0x12/0x14
  [<900f9324>] bus_add_driver+0x6c/0x170
  [<900f9860>] driver_register+0x58/0xb0
  [<900fa0b6>] platform_driver_register+0x56/0x5c
  [<9000adca>] physmap_init+0xa/0x10
  [<900146da>] do_one_initcall+0x36/0x10c
  [<90000380>] kernel_init+0x48/0x94
  [<9001fca0>] do_exit+0x0/0x49c

physmap platform flash device: 00800000 at 08000000
physmap-flash.1: Found 1 x16 devices at 0x0 in 16-bit bank
  Amd/Fujitsu Extended Query Table at 0x0040
number of CFI chips: 1
cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
RedBoot partition parsing not available
Using physmap partition information
Creating 1 MTD partitions on "physmap-flash.1":
0x00000000-0x00800000 : "data"
------------[ cut here ]------------
Badness at mm/backing-dev.c:179
PC is at bdi_register+0xe/0x44
LR is at bdi_register_dev+0x16/0x20
pc : [<9003f07a>]    lr : [<9003f0c6>]    Tainted: G        W
sp : 91c19ccc  r12: 91c5409c  r11: 00000000
r10: 901c56c8  r9 : 0000001f  r8 : 00000004
r7 : 91c19cd0  r6 : 91c5409c  r5 : 91d0bc00  r4 : 00000000
r3 : 91cb9400  r2 : 901fd444  r1 : 00000000  r0 : 00000001
Flags: qvNzc
Mode bits: hjmde....g
CPU Mode: Supervisor
Process: swapper [1] (task: 91c16000 thread: 91c18000)
Call trace:
  [<9003f0c6>] bdi_register_dev+0x16/0x20
  [<900d7cc4>] add_disk+0x88/0xb0
  [<90100148>] add_mtd_blktrans_dev+0x178/0x188
  [<901004ea>] mtdblock_add_mtd+0x36/0x3c
  [<900ffec4>] blktrans_notify_add+0x1a/0x3a
  [<900fe16c>] add_mtd_device+0x60/0xa0
  [<900fef2e>] add_mtd_partitions+0x37e/0x3a4
  [<90105614>] physmap_flash_probe+0x1ec/0x21c
  [<900f9eb4>] platform_drv_probe+0x10/0x12
  [<900f9680>] driver_probe_device+0x84/0xf0
  [<900f9726>] __driver_attach+0x3a/0x50
  [<900f904a>] bus_for_each_dev+0x2e/0x4c
  [<900f9566>] driver_attach+0x12/0x14
  [<900f9324>] bus_add_driver+0x6c/0x170
  [<900f9860>] driver_register+0x58/0xb0
  [<900fa0b6>] platform_driver_register+0x56/0x5c
  [<9000adca>] physmap_init+0xa/0x10
  [<900146da>] do_one_initcall+0x36/0x10c
  [<90000380>] kernel_init+0x48/0x94
  [<9001fca0>] do_exit+0x0/0x49c

Regards
Mark
