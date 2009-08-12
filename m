Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbZHLPf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbZHLPf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbZHLPf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:35:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53861 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbZHLPfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:35:55 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-kernel@vger.kernel.org
Date: Wed, 12 Aug 2009 17:35:43 +0200
User-Agent: KMail/1.9.9
Cc: Mel Gorman <mel@csn.ul.ie>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-hotplug@vger.kernel.org
References: <200908111830.03224.jbe@pengutronix.de> <200908121311.35321.jbe@pengutronix.de> <20090812135036.GE19269@csn.ul.ie>
In-Reply-To: <20090812135036.GE19269@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908121735.44439.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: Re: Patch "page-allocator: preserve PFN ordering when __GFP_COLD is set" fails on my system
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 12. August 2009, Mel Gorman wrote:
> On Wed, Aug 12, 2009 at 01:11:34PM +0200, Juergen Beisert wrote:
> > On Mittwoch, 12. August 2009, Mel Gorman wrote:
> > > > > I get the following Ooops message when "udevadm" is running on an
> > > > > ARM S3C2440 CPU based system:
> > >
> > > This is extremely odd. All that patch is doing is changing what order
> > > pages are returned in to the caller when __GFP_COLD is specified. 
> > > valid memory. Does reverting the patch really make the problem go away?
> >
> > At least I can work with the system if I remove this patch. Theres is no
> > oops, so udev creates all the required devnodes and the system comes up
> > into the login prompt.
>
> One reason I can think of that the patch would make a different to booting
> is that there is a buffer overrun somewhere. When the pages in one order,
> the buffer overrun is into pages that are not being used so it's not
> spotted. In the other order, the overrun causes damage. The patch only
> alters the order of pages in a linked list and ordinarily that shouldn't
> make any functional difference.
>
> Can you enable the config option DEBUG_PAGEALLOC please and tell me if
> that blows up in some unexpected fashion? It would also be helpful if
> you could enable all slab/slqb/slub debugging (whichever one you are
> using).

DEBUG_PAGEALLOC=y and DEBUG_SLAB=y does not change anything. Only 
DEBUG_KOBJECT=y shows this:

[...]
kobject: 'default' (c399af48): fill_kobj_path: path = '/class/bdi/default'
kobject: 'gpiochip0' (c3946f48): kobject_uevent_env
kobject: 'gpiochip0' (c3946f48): fill_kobj_path: path 
= '/class/gpio/gpiochip0'
kobject: 'gpiochip128' (c396af48): kobject_uevent_env
kobject: 'gpiochip128' (c396af48): fill_kobj_path: path 
= '/class/gpio/gpiochip128'
kobject: 'gpiochip160' (c396cf48): kobject_uevent_env
kobject: 'gpiochip160' (c396cf48): fill_kobj_path: path 
= '/class/gpio/gpiochip160'
kobject: 'gpiochip192' (c3962f48): kobject_uevent_env
kobject: 'gpiochip192' (c3962f48): fill_kobj_path: path 
= '/class/gpio/gpiochip192'
kobject: 'gpiochip224' (c3970f48): kobject_uevent_env
kobject: 'gpiochip224' (c3970f48): fill_kobj_path: path 
= '/class/gpio/gpiochip224'
kobject: 'gpiochip32' (c3964f48): kobject_uevent_env
kobject: 'gpiochip32' (c3964f48): fill_kobj_path: path 
= '/class/gpio/gpiochip32'
kobject: 'gpiochip64' (c3966f48): kobject_uevent_env
kobject: 'gpiochip64' (c3966f48): fill_kobj_path: path 
= '/class/gpio/gpiochip64'
kobject: 'gpiochip96' (c3969f48): kobject_uevent_env
kobject: 'gpiochip96' (c3969f48): fill_kobj_path: path 
= '/class/gpio/gpiochip96'
kobject: 'fb0' (c3bbff48): kobject_uevent_env
kobject: 'fb0' (c3bbff48): fill_kobj_path: path = '/class/graphics/fb0'
kobject: 's3c2410-lcd' (c02dc468): fill_kobj_path: path 
= '/devices/platform/s3c2410-lcd'
kobject: 'fbcon' (c3b62f48): kobject_uevent_env
kobject: 'fbcon' (c3b62f48): fill_kobj_path: path = '/class/graphics/fbcon'
kobject: 'i2c-0' (c39a3e78): kobject_uevent_env
kobject: 'i2c-0' (c39a3e78): fill_kobj_path: path = '/class/i2c-adapter/i2c-0'
kobject: 's3c2440-i2c' (c02de368): fill_kobj_path: path 
= '/devices/platform/s3c2440-i2c'
kobject: '0-0068' (c3996f28): kobject_uevent_env
kobject: '0-0068' (c3996f28): fill_kobj_path: path 
= '/class/i2c-adapter/i2c-0/0-0068'
kobject: 'input0' (c3bba780): kobject_uevent_env
kobject: 'input0' (c3bba780): fill_kobj_path: path = '/class/input/input0'
Unable to handle kernel paging request at virtual address e3540000
pgd = c3ef8000
[e3540000] *pgd=00000000
Internal error: Oops: 5 [#1]
Modules linked in:
CPU: 0    Not tainted  (2.6.31-rc5 #8)
PC is at strlen+0xc/0x20
LR is at kobject_get_path+0x28/0xd0
pc : [<c011a3a4>]    lr : [<c0116ee4>]    psr: a0000013
sp : c3ebde90  ip : 00000005  fp : c029fdce
r10: c02ea490  r9 : 00000000  r8 : c001de30
r7 : c3e58000  r6 : 000000d0  r5 : 00000001  r4 : c001de30
r3 : e3550001  r2 : e3540000  r1 : 000000d0  r0 : e3540000
Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: c000717f  Table: 33ef8000  DAC: 00000015
Process udevadm (pid: 332, stack limit = 0xc3ebc270)
Stack: (0xc3ebde90 to 0xc3ebe000)
de80:                                     ffffffff ffffffff a0000013 c001de28
dea0: c3bba780 c3bba778 c3e58000 c3802ce0 c02ea490 c0153a68 c029fdce c01171c4
dec0: c3bba780 00000000 c3bba780 c3d07da0 c3e58000 c0117420 00000000 00020001
dee0: 00000000 00000000 c3f2a6c0 c0286d79 c3e67f70 c3797f70 c380bf40 00000000
df00: 00000000 c3bba778 00000003 c3d07da0 c3bba780 c02ea4d0 c3d07db8 c3ebdf88
df20: 00019cb0 c0153b08 c3efcf78 00000000 c3d07db8 c3d00d10 00000003 c01531ec
df40: c3d00d10 c00c3f6c c3efcf78 00019cb0 c3ebdf88 00000004 00000003 c3ebc000
df60: 00000000 c0085734 c3797f70 00000020 00000000 00000000 c3efcf78 00000004
df80: c0025fa8 c0085894 00000000 00000000 be878250 00000000 00026e20 00000003
dfa0: be878250 c0025e00 00026e20 00000003 00000003 00019cb0 00000003 00000000
dfc0: 00026e20 00000003 be878250 00000004 00022a90 be878678 00019cb0 00019cb0
dfe0: 00022a94 be878250 00018114 400d8f1c 40000010 00000003 aaaaaaaa aaaaaaaa
[<c011a3a4>] (strlen+0xc/0x20) from [<c0116ee4>] (kobject_get_path+0x28/0xd0)
[<c0116ee4>] (kobject_get_path+0x28/0xd0) from [<c0153a68>] 
(dev_uevent+0x1dc/0x208)
[<c0153a68>] (dev_uevent+0x1dc/0x208) from [<c0117420>] 
(kobject_uevent_env+0x1e8/0x450)
[<c0117420>] (kobject_uevent_env+0x1e8/0x450) from [<c0153b08>] 
(store_uevent+0x74/0x88)
[<c0153b08>] (store_uevent+0x74/0x88) from [<c01531ec>] 
(dev_attr_store+0x20/0x28)
[<c01531ec>] (dev_attr_store+0x20/0x28) from [<c00c3f6c>] 
(sysfs_write_file+0x104/0x13c)
[<c00c3f6c>] (sysfs_write_file+0x104/0x13c) from [<c0085734>] 
(vfs_write+0xb0/0x15c)
[<c0085734>] (vfs_write+0xb0/0x15c) from [<c0085894>] (sys_write+0x40/0x6c)
[<c0085894>] (sys_write+0x40/0x6c) from [<c0025e00>] 
(ret_fast_syscall+0x0/0x2c)
Code: c02e5eb8 e1a02000 ea000000 e2800001 (e5d03000)
---[ end trace a8d7bdeb081ef0e0 ]---
Segmentation fault
[...]

After this oops, system startup continues. Then the next oops occurs:

This one is new, since I try to mount the connected SD card.

[...]
Unable to handle kernel paging request at virtual address fcd00004
pgd = c3fec000
[fcd00004] *pgd=00000000
Internal error: Oops: 5 [#2]
Modules linked in:
CPU: 0    Tainted: G      D     (2.6.31-rc5 #8)
PC is at s3c2410_gpio_getpin+0xc/0x20
LR is at s3cmci_card_present+0x1c/0x38
pc : [<c002fe50>]    lr : [<c01a250c>]    psr: 20000013
sp : c3d8de48  ip : 00000200  fp : 00000000
r10: c3d7dfa4  r9 : c3d8de90  r8 : 00000001
r7 : c3d28e00  r6 : c3d8de90  r5 : c3d42800  r4 : c001ded8
r3 : fcd00000  r2 : 00000000  r1 : c3d8de90  r0 : 03a00002
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: c000717f  Table: 33fec000  DAC: 00000017
Process mmcqd (pid: 305, stack limit = 0xc3d8c270)
Stack: (0xc3d8de48 to 0xc3d8e000)
de40:                   c3d42940 c01a2ba0 c3d8de90 c3d42800 c3f1df28 c0199d04
de60: c3d7dfa4 00000000 c3d8de68 c3d8de68 c3d8de90 c3f1df28 c3d7dfa4 c019f630
de80: 90cf85d1 3d2e1a39 47260d9e c3d8dea4 c3d8dea4 c3d8defc 00000000 c3d8de64
dea0: c0199d8c 00000011 00004000 00000000 00000000 00000000 00000000 000000b5
dec0: 00000000 00000000 c3d8defc c3d8de90 0000000c 00000000 00000000 00000000
dee0: 00000000 00000000 0000049d 00000000 00000000 00000000 00000000 02faf080
df00: 00000000 00000200 00000001 00000000 00000200 00000000 00000000 c3d8de90
df20: 00000001 c3d89800 c02de5a0 c38bcd40 c02de5a0 c0034114 c3d73d08 c02de568
df40: c38bcd38 c39f001c c3d73d08 00000017 c3d73d08 c3d82ba0 00000000 00000000
df60: c3d7dfa4 00000000 c3d7dfa4 c3d82ba0 00000000 c010b4e4 c3d73d08 c3f1df28
df80: 00000000 c3f1df28 c3d7dfa4 c3d8c000 c3d7dfac c3d82ba0 00000000 c3d82cb0
dfa0: 00000001 c019fea8 c39f1dfc c3d8dfd4 c39f1dfc c3d7dfa4 c019fdc4 00000000
dfc0: 00000000 00000000 00000000 c004a7e8 00000000 00000000 c3d8dfd8 c3d8dfd8
dfe0: 00000000 00000000 00000000 00000000 00000000 c0026dd8 fb0f7272 885b61ba
[<c002fe50>] (s3c2410_gpio_getpin+0xc/0x20) from [<c01a250c>] 
(s3cmci_card_present+0x1c/0x38)
[<c01a250c>] (s3cmci_card_present+0x1c/0x38) from [<c01a2ba0>] 
(s3cmci_request+0x28/0x60)
[<c01a2ba0>] (s3cmci_request+0x28/0x60) from [<c0199d04>] 
(mmc_wait_for_req+0x104/0x11c)
[<c0199d04>] (mmc_wait_for_req+0x104/0x11c) from [<c019f630>] 
(mmc_blk_issue_rq+0x1c4/0x53c)
[<c019f630>] (mmc_blk_issue_rq+0x1c4/0x53c) from [<c019fea8>] 
(mmc_queue_thread+0xe4/0xe8)
[<c019fea8>] (mmc_queue_thread+0xe4/0xe8) from [<c004a7e8>] 
(kthread+0x74/0x78)
[<c004a7e8>] (kthread+0x74/0x78) from [<c0026dd8>] 
(kernel_thread_exit+0x0/0x8)
Code: e8bd8010 e3c0301f e1a030a3 e28334fb (e5933004)
---[ end trace a8d7bdeb081ef0e1 ]---

Seems something GPIO related. Because also the '/class/input/input0' is a GPIO 
based button. I will continue tomorrow.

Regards,
Juergen

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | Phone: +49-8766-939 228     |
Vertretung Sued/Muenchen, Germany             | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686              | http://www.pengutronix.de/  |
