Return-Path: <linux-kernel-owner+w=401wt.eu-S1750704AbXBKP4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750704AbXBKP4g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 10:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750706AbXBKP4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 10:56:36 -0500
Received: from wasp.net.au ([203.190.192.17]:41528 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbXBKP4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 10:56:36 -0500
Message-ID: <45CF3CA3.1010704@wasp.net.au>
Date: Sun, 11 Feb 2007 19:56:19 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: Alex Dubov <oakad@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: Recent and not-so problems with tifm_sd driver - one more
References: <113489.35158.qm@web36703.mail.mud.yahoo.com> <45CDC22B.6040408@drzeus.cx> <45CEB1C9.5010103@wasp.net.au> <45CF3904.5070401@drzeus.cx>
In-Reply-To: <45CF3904.5070401@drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> Brad Campbell wrote:
>> I've tested both with and without CONFIG_SYSFS_DEPRECATED on, both fail
>> the same way.
>> hald reports that the device has no parent and decides to ignore it.
>>
> 
> Works fine here. The device tree is:
> 
> /sys/devices/pnp0/00:02/mmc0/mmc0:0001/block:mmcblk0/mmcblk0p1/

Ok, following from that on my machine currently...

brad@bklaptop2:/$ ls /dev/mmc*
/dev/mmcblk0  /dev/mmcblk0p1

brad@bklaptop2:/$ find sys/devices | grep mmc
sys/devices/pci0000:00/0000:00:1e.0/0000:06:05.3/tifm_sd0:3/mmc_host:mmc0

brad@bklaptop2:/$ find /sys/block/ | grep mmc
/sys/block/mmcblk0
/sys/block/mmcblk0/queue
/sys/block/mmcblk0/queue/iosched
/sys/block/mmcblk0/queue/iosched/slice_idle
/sys/block/mmcblk0/queue/iosched/slice_async_rq
/sys/block/mmcblk0/queue/iosched/slice_async
/sys/block/mmcblk0/queue/iosched/slice_sync
/sys/block/mmcblk0/queue/iosched/back_seek_penalty
/sys/block/mmcblk0/queue/iosched/back_seek_max
/sys/block/mmcblk0/queue/iosched/fifo_expire_async
/sys/block/mmcblk0/queue/iosched/fifo_expire_sync
/sys/block/mmcblk0/queue/iosched/quantum
/sys/block/mmcblk0/queue/scheduler
/sys/block/mmcblk0/queue/max_sectors_kb
/sys/block/mmcblk0/queue/max_hw_sectors_kb
/sys/block/mmcblk0/queue/read_ahead_kb
/sys/block/mmcblk0/queue/nr_requests
/sys/block/mmcblk0/mmcblk0p1
/sys/block/mmcblk0/mmcblk0p1/holders
/sys/block/mmcblk0/mmcblk0p1/subsystem
/sys/block/mmcblk0/mmcblk0p1/stat
/sys/block/mmcblk0/mmcblk0p1/size
/sys/block/mmcblk0/mmcblk0p1/start
/sys/block/mmcblk0/mmcblk0p1/dev
/sys/block/mmcblk0/mmcblk0p1/uevent
/sys/block/mmcblk0/slaves
/sys/block/mmcblk0/holders
/sys/block/mmcblk0/subsystem
/sys/block/mmcblk0/device
/sys/block/mmcblk0/stat
/sys/block/mmcblk0/size
/sys/block/mmcblk0/removable
/sys/block/mmcblk0/range
/sys/block/mmcblk0/dev
/sys/block/mmcblk0/uevent

brad@bklaptop2:~$ zcat /proc/config.gz | grep CONFIG_SYSFS_DEPRECATED
CONFIG_SYSFS_DEPRECATED=y

brad@bklaptop2:~$ uname -a
Linux bklaptop2 2.6.20-git4-bkc1 #5 Sat Feb 10 23:49:52 GST 2007 i686 GNU/Linux

Not sure if any of this is relevant info, but none the less, I'm not a sysfs or hal guru.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
