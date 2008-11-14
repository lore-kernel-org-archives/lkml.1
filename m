Return-Path: <linux-kernel-owner+w=401wt.eu-S1751945AbYKNGXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbYKNGXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 01:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbYKNGXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 01:23:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:37269 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbYKNGXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 01:23:04 -0500
Message-ID: <491D1932.10808@kernel.org>
Date: Fri, 14 Nov 2008 15:22:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       albcamus@gmail.com, pjones@redhat.com, alex.shi@intel.com
Subject: Re: system fails to boot
References: <1226639781.2866.77.camel@ymzhang> <20081114061847.GB2227@x200.localdomain>
In-Reply-To: <20081114061847.GB2227@x200.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 14 Nov 2008 06:22:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
>> Would you like to accept the kernel patch into your testing tree? Pls. do CC to me when replying
>> as I couldn't subscribe LKML emails now.
>>
>> ---
>>
>> --- linux-2.6.28-rc4/block/genhd.c	2008-11-11 08:37:24.000000000 +0800
>> +++ linux-2.6.28-rc4_label/block/genhd.c	2008-11-13 04:05:35.000000000 +0800
>> @@ -1028,6 +1028,7 @@ static int __init proc_genhd_init(void)
>>  {
>>  	proc_create("diskstats", 0, NULL, &proc_diskstats_operations);
>>  	proc_create("partitions", 0, NULL, &proc_partitions_operations);
>> +	register_blkdev(BLOCK_EXT_MAJOR, "blkext");
>>  	return 0;
>>  }
>>  module_init(proc_genhd_init);
> 
> It's procfs-specific init, what's up?

Ah... right, better to move it to genhd_device_init().  Thanks.

-- 
tejun
