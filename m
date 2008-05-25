Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbYEYUqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbYEYUqH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 16:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbYEYUpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 16:45:51 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40087 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720AbYEYUpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 16:45:06 -0400
Date: Sun, 25 May 2008 23:42:29 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>
Subject: Re: x86_64 panic on latest linux-2.6
Message-ID: <20080525204229.GL1791@cs181133002.pp.htv.fi>
References: <200805251051.33781.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200805251051.33781.m.kozlowski@tuxland.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2008 at 10:51:33AM +0200, Mariusz Kozlowski wrote:
> Hello,

Hi Mariusz,

> 	My x86_64 box is not willing to boot.
> 
> http://tuxland.pl/tmp/s7300372.jpg (275kB)
> 
> (gdb) p blk_lookup_devt
> $1 = {dev_t (const char *, int)} 0xffffffff8032a430 <blk_lookup_devt>
> (gdb) l *(0xffffffff8032a430+0x7f)
> 0xffffffff8032a4af is in blk_lookup_devt (block/genhd.c:664).
> 659             dev_t devt = MKDEV(0, 0);
> 660     
> 661             mutex_lock(&block_class_lock);
> 662             list_for_each_entry(dev, &block_class.devices, node) {
> 663                     if (strcmp(dev->bus_id, name) == 0) {
> 664                             struct gendisk *disk = dev_to_disk(dev);
> 665     
> 666                             if (part < disk->minors)
> 667                                     devt = MKDEV(MAJOR(dev->devt),
> 668                                                  MINOR(dev->devt) + part);
> (gdb) 

thanks for your report.

Does reverting of commit 30f2f0eb4bd2c43d10a8b0d872c6e5ad8f31c9a0
(block: do_mounts - accept root=<non-existant partition>) fix it?

> 	Mariusz
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

