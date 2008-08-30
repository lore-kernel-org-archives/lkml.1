Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYH3RYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYH3RYA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 13:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYH3RXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 13:23:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbYH3RXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 13:23:36 -0400
Date: Sat, 30 Aug 2008 10:20:24 -0700
From: Greg KH <gregkh@suse.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION 2.6.27-rc4-git7] mtd broken by cmdfilter move
Message-ID: <20080830172024.GB12414@suse.de>
References: <200808301704.m7UH48Bn019083@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808301704.m7UH48Bn019083@harpo.it.uu.se>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 07:04:08PM +0200, Mikael Pettersson wrote:
> Starting with kernel 2.6.27-rc4-git7 my n2100 arm box throws a bunch
> of kobject errors at boot:
> 
> Creating 6 MTD partitions on "physmap-flash.0":
> 0x00000000-0x00040000 : "RedBoot"
> 0x00040000-0x00d40000 : "ramdisk"
> kobject (df8fd510): tried to init an initialized object, something is seriously wrong.
> [<c0024c68>] (dump_stack+0x0/0x14) from [<c01136f4>] (kobject_init+0x40/0x78)
> [<c01136b4>] (kobject_init+0x0/0x78) from [<c0113c28>] (kobject_init_and_add+0x20/0x44)
>  r5:df8fd510 r4:df9ee8b0
> [<c0113c0c>] (kobject_init_and_add+0x4/0x44) from [<c010a92c>] (blk_register_filter+0x4c/0x60)
>  r5:df8f6d20 r4:df8fd108
> [<c010a8e0>] (blk_register_filter+0x0/0x60) from [<c010983c>] (add_disk+0x60/0xb8)
>  r4:df9ee800
> [<c01097dc>] (add_disk+0x0/0xb8) from [<c0170bb4>] (add_mtd_blktrans_dev+0x248/0x284)
>  r5:df8f6d20 r4:00000001
> [<c017096c>] (add_mtd_blktrans_dev+0x0/0x284) from [<c01711a8>] (mtdblock_add_mtd+0x5c/0x68)
>  r8:00040000 r7:df8604cc r6:c02c5c98 r5:c02c5cc8 r4:df8602a0
> [<c017114c>] (mtdblock_add_mtd+0x0/0x68) from [<c017075c>] (blktrans_notify_add+0x38/0x64)
>  r5:df8602a0 r4:c02c5cc8
> [<c0170724>] (blktrans_notify_add+0x0/0x64) from [<c016daec>] (add_mtd_device+0xb4/0x110)
>  r6:c02c5c34 r5:df8602a0 r4:c02c5c88
> [<c016da38>] (add_mtd_device+0x0/0x110) from [<c016ee70>] (add_mtd_partitions+0x490/0x54c)
>  r6:df844080 r5:00000c00 r4:df8602a0
> [<c016e9e0>] (add_mtd_partitions+0x0/0x54c) from [<c01789b8>] (physmap_flash_probe+0x27c/0x2e8)
> [<c017873c>] (physmap_flash_probe+0x0/0x2e8) from [<c01468b8>] (platform_drv_probe+0x20/0x24)
> [<c0146898>] (platform_drv_probe+0x0/0x24) from [<c0145b20>] (driver_probe_device+0xd8/0x18c)
> [<c0145a48>] (driver_probe_device+0x0/0x18c) from [<c0145c20>] (__driver_attach+0x4c/0x70)
>  r7:c02c5e1c r6:c02c5e1c r5:c02b8338 r4:c02b828c
> [<c0145bd4>] (__driver_attach+0x0/0x70) from [<c0145180>] (bus_for_each_dev+0x54/0x88)
>  r6:c0145bd4 r5:df821ec0 r4:00000000
> [<c014512c>] (bus_for_each_dev+0x0/0x88) from [<c0145960>] (driver_attach+0x20/0x28)
>  r7:df88c620 r6:00000000 r5:c02c5e1c r4:00000000
> [<c0145940>] (driver_attach+0x0/0x28) from [<c0145618>] (bus_add_driver+0xa8/0x214)
> [<c0145570>] (bus_add_driver+0x0/0x214) from [<c0145e14>] (driver_register+0x98/0x120)
>  r8:00000000 r7:00000000 r6:00000000 r5:c02c5e1c r4:c02cd924
> [<c0145d7c>] (driver_register+0x0/0x120) from [<c0146a78>] (platform_driver_register+0x78/0x94)
> [<c0146a00>] (platform_driver_register+0x0/0x94) from [<c0016ee4>] (physmap_init+0x14/0x1c)
> [<c0016ed0>] (physmap_init+0x0/0x1c) from [<c00202b8>] (__exception_text_end+0x50/0x184)
> [<c0020268>] (__exception_text_end+0x0/0x184) from [<c000874c>] (kernel_init+0x70/0xd8)
> [<c00086dc>] (kernel_init+0x0/0xd8) from [<c003750c>] (do_exit+0x0/0x708)
>  r5:00000000 r4:00000000
> 0x00d40000-0x00ea0000 : "kernel"
> kobject (df8fd510): tried to init an initialized object, something is seriously wrong.
> 
> and so on for every partition except the first one.
> 
> I bisected this to commit abf5439370491dd6fbb4fe1a7939680d2a9bc9d4,
> "block: move cmdfilter from gendisk to request_queue".
> 
> There is a many-to-one mapping from gendisks to queues, so when this commit
> moved the cmd_filter object from the gendisk to the gendisk's queue it
> allowed (by design or by accident, I don't know) gendisks to share cmd_filters.
> However, the commit didn't update blk_register_filter() to handle shared
> cmd_filters: it still unconditionally calls kobject_init_and_add() for the
> gendisk's cmd_filter kobject. When queue and thus cmd_filter sharing is present,
> reinitialisation of already initialised kobjects occur, resulting in loud
> complaints from lib/kobject.c.
> 
> As a quick workaround I added a check to blk_register_filter() to avoid
> reinitialising already initialised cmd_filters, and to log the addresses
> of the disks, queues, and cmd_filters passed to it:
> 
> --- linux-2.6.27-rc4-git6/block/cmd-filter.c.~1~	2008-08-30 17:08:58.000000000 +0200
> +++ linux-2.6.27-rc4-git6/block/cmd-filter.c	2008-08-30 17:36:36.000000000 +0200
> @@ -215,6 +215,13 @@ int blk_register_filter(struct gendisk *
>  	if (!parent)
>  		return -ENODEV;
>  
> +	printk("%s: disk %p queue %p filter %p &filter->kobj %p\n",
> +	       __func__, disk, disk->queue, filter, &filter->kobj);
> +	if (filter->kobj.state_initialized) {
> +		printk("%s: kobj %p already inited, bailing out\n",
> +		       __func__, &filter->kobj);
> +		return 0;
> +	}

Ick, no, don't go poking into the internals of a kobject like this to
fix this kind of problem.  If you really don't know if you have
initialized this kobject or not, then you will have reference counting
problems, which need to be fixed for real.

thanks,

greg k-h
