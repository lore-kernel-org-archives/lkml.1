Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbYH2Ogs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbYH2Ogs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbYH2Ogk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:36:40 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:17795 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbYH2Ogj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:36:39 -0400
Date: Fri, 29 Aug 2008 16:28:24 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: "Eirik Aanonsen" <eaa@wprmedical.com>, linux-mtd@lists.infradead.org,
       kernel@avr32linux.org, David Woodhouse <dwmw2@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: MTD/block regression (was Re: Slub debugging NAND error in
 2.6.25.10.atmel.2)
Message-ID: <20080829162824.17f8746b@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080829114828.279b79bc@hskinnemo-gx745.norway.atmel.com>
References: <6B5648EA2E2C2D42AF2FF7691522AD92417C9D@wpr01.wprmedical.local>
	<6B5648EA2E2C2D42AF2FF7691522AD92417CA6@wpr01.wprmedical.local>
	<20080829114828.279b79bc@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Aug 2008 14:28:21.0527 (UTC) FILETIME=[7CF29A70:01C909E3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> Hmm...I just saw this when booting 2.6.27-rc5 on the NGW100:
> 
> physmap platform flash device: 00800000 at 00000000
> physmap-flash.0: Found 1 x16 devices at 0x0 in 16-bit bank
>  Amd/Fujitsu Extended Query Table at 0x0041
> number of CFI chips: 1
> cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
> RedBoot partition parsing not available
> Using physmap partition information
> Creating 3 MTD partitions on "physmap-flash.0":
> 0x00000000-0x00020000 : "u-boot"
> 0x00020000-0x007f0000 : "root"
> kobject (91ce8410): tried to init an initialized object, something is seriously wrong.
> Call trace:
>  [<90017184>] dump_stack+0x18/0x20
>  [<900c1894>] kobject_init+0x28/0x5c
>  [<900c1bf6>] kobject_init_and_add+0xe/0x24
>  [<900beff0>] blk_register_filter+0x28/0x40
>  [<900be224>] add_disk+0x38/0x68
>  [<900e70f0>] add_mtd_blktrans_dev+0x174/0x184
>  [<900e748e>] mtdblock_add_mtd+0x36/0x3c
>  [<900e6e38>] blktrans_notify_add+0x1a/0x3a
>  [<900e533c>] add_mtd_device+0x60/0xa0
>  [<900e5f7e>] add_mtd_partitions+0x37a/0x3a0
>  [<900ec4d0>] physmap_flash_probe+0x1ec/0x21c
>  [<900e0f24>] platform_drv_probe+0x10/0x12
>  [<900e06d0>] driver_probe_device+0x84/0xf0
>  [<900e076a>] __driver_attach+0x2e/0x44
>  [<900e0096>] bus_for_each_dev+0x2e/0x4c
>  [<900e05b6>] driver_attach+0x12/0x14
>  [<900e036c>] bus_add_driver+0x6c/0x178
>  [<900e08a4>] driver_register+0x58/0xb0
>  [<900e1126>] platform_driver_register+0x56/0x5c
>  [<9000aaf6>] physmap_init+0xa/0x10
>  [<9001422a>] do_one_initcall+0x2a/0x10c
>  [<900005b8>] kernel_init+0x48/0x90
>  [<9001fcc0>] do_exit+0x0/0x4cc
> 
> 0x007f0000-0x00800000 : "env"
> kobject (91ce8410): tried to init an initialized object, something is seriously wrong.
> Call trace:
>  [<90017184>] dump_stack+0x18/0x20
>  [<900c1894>] kobject_init+0x28/0x5c
>  [<900c1bf6>] kobject_init_and_add+0xe/0x24
>  [<900beff0>] blk_register_filter+0x28/0x40
>  [<900be224>] add_disk+0x38/0x68
>  [<900e70f0>] add_mtd_blktrans_dev+0x174/0x184
>  [<900e748e>] mtdblock_add_mtd+0x36/0x3c
>  [<900e6e38>] blktrans_notify_add+0x1a/0x3a
>  [<900e533c>] add_mtd_device+0x60/0xa0
>  [<900e5f7e>] add_mtd_partitions+0x37a/0x3a0
>  [<900ec4d0>] physmap_flash_probe+0x1ec/0x21c
>  [<900e0f24>] platform_drv_probe+0x10/0x12
>  [<900e06d0>] driver_probe_device+0x84/0xf0
>  [<900e076a>] __driver_attach+0x2e/0x44
>  [<900e0096>] bus_for_each_dev+0x2e/0x4c
>  [<900e05b6>] driver_attach+0x12/0x14
>  [<900e036c>] bus_add_driver+0x6c/0x178
>  [<900e08a4>] driver_register+0x58/0xb0
>  [<900e1126>] platform_driver_register+0x56/0x5c
>  [<9000aaf6>] physmap_init+0xa/0x10
>  [<9001422a>] do_one_initcall+0x2a/0x10c
>  [<900005b8>] kernel_init+0x48/0x90
>  [<9001fcc0>] do_exit+0x0/0x4cc
> 
> I wonder if it's related?

Ok, it turns out it's not related. It's a newly introduced regression
which I've bisected down to:

commit abf5439370491dd6fbb4fe1a7939680d2a9bc9d4
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Sat Aug 16 14:10:05 2008 +0900

    block: move cmdfilter from gendisk to request_queue

    cmd_filter works only for the block layer SG_IO with SCSI block
    devices. It breaks scsi/sg.c, bsg, and the block layer SG_IO with SCSI
    character devices (such as st). We hit a kernel crash with them.

    The problem is that cmd_filter code accesses to gendisk (having struct
    blk_scsi_cmd_filter) via inode->i_bdev->bd_disk. It works for only
    SCSI block device files. With character device files, inode->i_bdev
    leads you to struct cdev. inode->i_bdev->bd_disk->blk_scsi_cmd_filter
    isn't safe.

    SCSI ULDs don't expose gendisk; they keep it private. bsg needs to be
    independent on any protocols. We shouldn't change ULDs to expose their
    gendisk.

    This patch moves struct blk_scsi_cmd_filter from gendisk to
    request_queue, a common object, which eveyone can access to.

    The user interface doesn't change; users can change the filters via
    /sys/block/. gendisk has a pointer to request_queue so the cmd_filter
    code accesses to struct blk_scsi_cmd_filter.

    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

Unfortunately, I can't revert it cleanly, so it could be a false
positive. But it does sort of make sense, since it makes the filter
per-queue instead of per-gendisk, so if MTD uses the same queue for
several block devices, the filter kobject might end up being
initialized multiple times. Or something.

Haavard
