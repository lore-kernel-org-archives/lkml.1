Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbYH2GAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbYH2GAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbYH2GAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:00:40 -0400
Received: from sh.osrg.net ([192.16.179.4]:48441 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbYH2GAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:00:39 -0400
Date: Fri, 29 Aug 2008 14:56:38 +0900
To: jens.axboe@oracle.com
Cc: mano@roarinelk.homelinux.net, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: MTD kobject warnings due to block layer changes
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080828100921.GY20055@kernel.dk>
References: <20080828084603.GA17139@roarinelk.homelinux.net>
	<20080828100921.GY20055@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080829145616P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008 12:09:21 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Aug 28 2008, Manuel Lauss wrote:
> > Hello,
> > 
> > Todays -git spits out these wanings during boot, caused by
> > Commit abf5439370491dd6fbb4fe1a7939680d2a9bc9d4
> > ( block: move cmdfilter from gendisk to request_queue ):
> > 
> > Using physmap partition information
> > Creating 3 MTD partitions on "physmap-flash":
> > 0x00000000-0x01c00000 : "User FS"
> > 0x01c00000-0x01c40000 : "booter"
> > kobject (8511c410): tried to init an initialized object, something is seriously wrong.
> > Call Trace:
> > [<8036644c>] dump_stack+0x8/0x34
> > [<8021f050>] kobject_init+0x50/0xcc
> > [<8021fa18>] kobject_init_and_add+0x24/0x58
> > [<8021d20c>] blk_register_filter+0x4c/0x64
> > [<8021c194>] add_disk+0x78/0xe0
> > [<8027d14c>] add_mtd_blktrans_dev+0x254/0x278
> > [<8027c8f0>] blktrans_notify_add+0x40/0x78
> > [<80279c00>] add_mtd_device+0xd0/0x150
> > [<8027b090>] add_mtd_partitions+0x568/0x5d8
> > [<80285458>] physmap_flash_probe+0x2ac/0x334
> > [<802644f8>] driver_probe_device+0x12c/0x244
> > [<8026465c>] __driver_attach+0x4c/0x84
> > [<80263c64>] bus_for_each_dev+0x58/0xac
> > [<802633ec>] bus_add_driver+0xc4/0x24c
> > [<802648e0>] driver_register+0xcc/0x184
> > [<80100460>] _stext+0x60/0x1bc
> > 
> > 0x01c40000-0x01fe0000 : "vmlinux.elf"
> > kobject (8511c410): tried to init an initialized object, something is seriously wrong.
> > Call Trace:
> > [<8036644c>] dump_stack+0x8/0x34
> > [<8021f050>] kobject_init+0x50/0xcc
> > [<8021fa18>] kobject_init_and_add+0x24/0x58
> > [<8021d20c>] blk_register_filter+0x4c/0x64
> > [<8021c194>] add_disk+0x78/0xe0
> > [<8027d14c>] add_mtd_blktrans_dev+0x254/0x278
> > [<8027c8f0>] blktrans_notify_add+0x40/0x78
> > [<80279c00>] add_mtd_device+0xd0/0x150
> > [<8027b090>] add_mtd_partitions+0x568/0x5d8
> > [<80285458>] physmap_flash_probe+0x2ac/0x334
> > [<802644f8>] driver_probe_device+0x12c/0x244
> > [<8026465c>] __driver_attach+0x4c/0x84
> > [<80263c64>] bus_for_each_dev+0x58/0xac
> > [<802633ec>] bus_add_driver+0xc4/0x24c
> > [<802648e0>] driver_register+0xcc/0x184
> > [<80100460>] _stext+0x60/0x1bc
> > 
> > NAND device: Manufacturer ID: 0xec, Chip ID: 0xf1 (Samsung NAND 128MiB 3,3V 8-bit)
> > Scanning device for bad blocks
> > Creating 1 MTD partitions on "gen_nand":
> > 0x00000000-0x08000000 : "NAND FS 0"
> > kobject (8511c410): tried to init an initialized object, something is seriously wrong.
> > Call Trace:
> > [<8036644c>] dump_stack+0x8/0x34
> > [<8021f050>] kobject_init+0x50/0xcc
> > [<8021fa18>] kobject_init_and_add+0x24/0x58
> > [<8021d20c>] blk_register_filter+0x4c/0x64
> > [<8021c194>] add_disk+0x78/0xe0
> > [<8027d14c>] add_mtd_blktrans_dev+0x254/0x278
> > [<8027c8f0>] blktrans_notify_add+0x40/0x78
> > [<80279c00>] add_mtd_device+0xd0/0x150
> > [<8027b090>] add_mtd_partitions+0x568/0x5d8
> > [<804016b0>] plat_nand_probe+0x1e8/0x24c
> > [<802644f8>] driver_probe_device+0x12c/0x244
> > [<8026465c>] __driver_attach+0x4c/0x84
> > [<80263c64>] bus_for_each_dev+0x58/0xac
> > [<802633ec>] bus_add_driver+0xc4/0x24c
> > [<802648e0>] driver_register+0xcc/0x184
> > [<80100460>] _stext+0x60/0x1bc
> 
> Tomo? I don't see how this is happening. The queue is properly zeroed,
> so no chance ->state_initialized being crap.

With MTD, multiple gendisks share a single request_queue?
