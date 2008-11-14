Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYKNHWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYKNHWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 02:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbYKNHWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 02:22:22 -0500
Received: from mga10.intel.com ([192.55.52.92]:56100 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751159AbYKNHWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 02:22:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,602,1220252400"; 
   d="scan'208";a="403512175"
Subject: Re: system fails to boot
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>, albcamus@gmail.com,
       pjones@redhat.com, alex.shi@intel.com
In-Reply-To: <491D1932.10808@kernel.org>
References: <1226639781.2866.77.camel@ymzhang>
	 <20081114061847.GB2227@x200.localdomain>  <491D1932.10808@kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Nov 2008 15:22:06 +0800
Message-Id: <1226647326.2866.87.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-11-14 at 15:22 +0900, Tejun Heo wrote:
> Alexey Dobriyan wrote:
> >> Would you like to accept the kernel patch into your testing tree? Pls. do CC to me when replying
> >> as I couldn't subscribe LKML emails now.
> >>
> >> ---
> >>
> >> --- linux-2.6.28-rc4/block/genhd.c	2008-11-11 08:37:24.000000000 +0800
> >> +++ linux-2.6.28-rc4_label/block/genhd.c	2008-11-13 04:05:35.000000000 +0800
> >> @@ -1028,6 +1028,7 @@ static int __init proc_genhd_init(void)
> >>  {
> >>  	proc_create("diskstats", 0, NULL, &proc_diskstats_operations);
> >>  	proc_create("partitions", 0, NULL, &proc_partitions_operations);
> >> +	register_blkdev(BLOCK_EXT_MAJOR, "blkext");
> >>  	return 0;
> >>  }
> >>  module_init(proc_genhd_init);
> > 
> > It's procfs-specific init, what's up?
> 
> Ah... right, better to move it to genhd_device_init().  Thanks.
Thanks. I thought nash reads /proc/devices so just added there.
Below patch moves it to ﻿genhd_device_init. I tested it on my Nehalem machine.

---

--- linux-2.6.28-rc4/block/genhd.c	2008-11-14 17:20:29.000000000 +0800
+++ linux-2.6.28-rc4_boot/block/genhd.c	2008-11-14 23:11:43.000000000 +0800
@@ -768,6 +768,8 @@ static int __init genhd_device_init(void
 	bdev_map = kobj_map_init(base_probe, &block_class_lock);
 	blk_dev_init();
 
+	register_blkdev(BLOCK_EXT_MAJOR, "blkext");
+
 #ifndef CONFIG_SYSFS_DEPRECATED
 	/* create top-level block dir */
 	block_depr = kobject_create_and_add("block", NULL);


