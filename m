Return-Path: <linux-kernel-owner+w=401wt.eu-S932433AbXDALXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbXDALXW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 07:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932437AbXDALXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 07:23:22 -0400
Received: from mail.t-c-c.at ([82.150.200.3]:53334 "HELO mail.t-c-c.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932433AbXDALXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 07:23:22 -0400
Message-ID: <460F961C.4050902@gmx.at>
Date: Sun, 01 Apr 2007 11:23:08 +0000
From: "Florian D." <flockmock@gmx.at>
User-Agent: Thunderbird 1.5.0.10 (X11/20070304)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: cannot add device to partitioned raid6 array
References: <460EF263.7020505@gmx.at>	<17935.8101.815473.709581@notabene.brown>	<460F7A87.3030201@gmx.at> <17935.33905.934360.22271@notabene.brown>
In-Reply-To: <17935.33905.934360.22271@notabene.brown>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> Definitely the cause.  If you really need to add this array, you may
> be able to reduce the usage of the array, then reduce the size of the
> array, then add the drive.
> Depending on how you have partitioned the array, and how you are using
> the partitions, you may just need to reduce the filesystem in the last
> partition, then use *fdisk to resize the partition.  Then something
> like:
> 
>    mdadm --grow --size=243000000 /dev/md_d4
> 
> Is is generally safer to reduce the filesystem too much, resize the
> device, then grow the filesystem up to the size of the device.  That
> way avoids fiddly arithmetic and so reduces the chance of failure.
> 
> NeilBrown
> 

thanks, but I decided to begin from scratch(backup is available ;)
now, all partitions have the same size. creating a raid6 array from 2 drives and hot-adding another
one works now. so this could be regarded as solved.

But when I try to create the array with 3 drives at once, the following strange error appears:

flockmock ~ # mdadm --create /dev/md_d4 --level=6 -a mdp --chunk=32 -n 4 /dev/sda2 /dev/sdb2 
/dev/sdc2 missing
mdadm: RUN_ARRAY failed: Input/output error
mdadm: stopped /dev/md_d4

dmesg shows:
[  484.362525] md: bind<sda2>
[  484.363429] md: bind<sdb2>
[  484.364337] md: bind<sdc2>
[  484.364397] md: md_d4: raid array is not clean -- starting background reconstruction
[  484.365876] raid5: device sdc2 operational as raid disk 2
[  484.365879] raid5: device sdb2 operational as raid disk 1
[  484.365881] raid5: device sda2 operational as raid disk 0
[  484.365884] raid5: cannot start dirty degraded array for md_d4
[  484.365886] RAID5 conf printout:
[  484.365887]  --- rd:4 wd:3
[  484.365889]  disk 0, o:1, dev:sda2
[  484.365891]  disk 1, o:1, dev:sdb2
[  484.365893]  disk 2, o:1, dev:sdc2
[  484.365895] raid5: failed to run raid set md_d4
[  484.365897] md: pers->run() failed ...
[  484.366271] md: md_d4 stopped.
[  484.366303] md: unbind<sdc2>
[  484.366309] md: export_rdev(sdc2)
[  484.366314] md: unbind<sdb2>
[  484.366318] md: export_rdev(sdb2)
[  484.366321] md: unbind<sda2>
[  484.366325] md: export_rdev(sda2)


I just wanted to report that FYI, I will take the first route and wait a little...
cheers, florian
