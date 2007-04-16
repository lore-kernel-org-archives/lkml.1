Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbXDPRVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbXDPRVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 13:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbXDPRVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 13:21:49 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52345 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752965AbXDPRVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 13:21:48 -0400
Date: Mon, 16 Apr 2007 19:21:55 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>
Cc: Mike Snitzer <snitzer@gmail.com>, Neil Brown <neilb@suse.de>,
       "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
Message-ID: <20070416172155.GF10338@stusta.de>
References: <op.tqqwdfzcftfxs2@localhost.localdomain> <17952.5537.364603.419364@notabene.brown> <170fa0d20704140704l29d9db76q59195a3d9cad868a@mail.gmail.com> <Pine.BSO.4.63.0704161140460.11088@rudy.mif.pg.gda.pl> <170fa0d20704160507w4af4cb92ua259a55789f95c3e@mail.gmail.com> <Pine.BSO.4.63.0704161419260.11088@rudy.mif.pg.gda.pl> <20070416143012.GC10338@stusta.de> <Pine.BSO.4.63.0704161633320.11088@rudy.mif.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.BSO.4.63.0704161633320.11088@rudy.mif.pg.gda.pl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 05:27:51PM +0200, Tomasz Kłoczko wrote:
> On Mon, 16 Apr 2007, Adrian Bunk wrote:
>
>> On Mon, Apr 16, 2007 at 04:01:23PM +0200, Tomasz Kłoczko wrote:
>>> ...
>>> Few days ago I'm swich two backup servers with few TB storage from Linux 
>>> to
>>> Solaris .. only because client want use ZFS .. because ZFS is EXCELENT 
>>> for
>>> this kind tasks (only because it allow save many thousands of
>>> <put_your_currency_name> because it allow better utilize the same 
>>> storage)
>>> and trust me .. cases like this will be more .. much more and changing
>>> licensing Linux code will be MUCH more easier than reinventing wheel 
>>> (wich
>>> will be reimplemnting ZFS under GPL).
>>
>> This is a technical mailing list, so let's start with technical
>> arguments:
>>
>> Why did this client want to use ZFS?
>
> Because switching to Solaris was chipper than buying next faster FC/SCSI 
> storage. Simple ?
>
>> Because his boss was convinced by a marketing guy that ZFS was the best
>> invention since sliced bread?
>
> In this scenario ther is no place for "marketing guy" .. try again .. 
> (maybe it can occure in US or Germany but trust me .. not in Poland 8-)
>
>> Or due to technical limitations in what Linux currently offers
>> resulting in ZFS bringing him direct advantages on these servers?
>
> Yes .. it is Linux limitiations because it is very hard to provide 
> simultanouse streams of backup data with threaded compression (using in 
> this case pbzip2) with good CPUs utilization because most streams waits on 
> I/Os and most of CPUs are not fully utilized. All this becase single stram 
> of compressed data can't be easy dinamically switched to another (not busy) 
> disk in JBOD. ZFS by two level allocation (on device and block level) will 
> not wait for finish I/O but will try use another/not busy device in ZFS 
> pool. This is *main* reason integrate in one layer VFS and LVM in case ZFS. 
> By integrate this two layers you can make deciion where data will be 
> written depending on *current* devices utilization. In all other "classic" 
> ways you will break layered OS model .. so in ZFS case conclution like "we 
> must integrate this two layers in one" it is not bug but feacture and was 
> FUNDAMENTAL.

You are having IO problems doing bzip2 ???

This sounds as if your application is doing something silly like e.g. 
using O_DIRECT or you are mounting your filesystems with "-o sync".

On my 1.8 GHz Athlon, it takes 2.5 minutes to compress a 250 MB kernel 
tar to 40 MB - and this is with the data cached in RAM, so no IO 
involved. That's 1.7 MB/s resp. 0.3 MB/s.

I'm even having problems to imagine IO problems with 4 or 8 CPU 
machines doing parallel bzip2 to a single disk - with any filesystem.

> This is not all .. backup data must be safe in best possible form .. in 
> time .. and it mean in this case that checksumming is NECCESSARY. Look .. 
> ext4 for now only have plans for implemting checksuming 
> (http://www.bullopensource.org/ext4/files/ext4.txt) and ATM on Linux there 
> is no FS with this kind abilities .. so yes again: this was Linux technical 
> limitation.

bzip2 already checksums all data, so why do you need a second checksum 
at the filesystem level for your backups?

>>> Problem is not on technical area but on licensing and it is plain Linux
>>> word problem because neccessary in this case changes on CDDL side will 
>>> make
>>> this code less oppended than now .. so you can (probably ?) forget about
>>> GPLing ZFS code (and ZFS it is not all what will good to have from Sol in
>>> Linux).
>>> IMO current Linux licensing less is importand than bringing in possible
>>> simpler way things like ZFS to Linux. So best/simpler way will be start
>>> change Linux licensing for save all GPL goodies and allow interract with
>>> code on license like CDDL.
>>>
>>> Licensing is for allow keep in best possible form Linux. If it can't do
>>> this in best possible way it must be change (must evolve .. like many 
>>> othes
>>> things around).
>>
>> There are at about 10.000 people who contributed to the Linux kernel,
>> some of them unreachable or even dead.
>
> Do you know who was Paracelsus ? He was medic hundriet years ago. They 
> discover and verbalise some kind fundamental (?) law for medicine which can 
> be used not only on medicine area. He sayd "kills not subtance but dose of 
> substance". So anything can kill you/animal/project .. you can kill someon 
> also using oxigen (not only low level of oxigen kills but also to much can 
> kill). Try to think on how this law on how many diffret ways can be 
> trasformed/appied to this kind of arguments. Look on how many developers 
> migrate to another unices in last few years (count only two for simplicity 
> like Solaris and MOX). Try looking for public forums statistics for example 
> Linux vs. Solaris and after this try to answer on "is it 10k is it realy 
> big number in this case or not ?" (IIRC google provides very good tools for 
> anyone who want this kind answers).

I don't need Google for this.

It's easy to extract from git that patches that were applied to the 
Linux kernel during the last 2 years contained 3196 unique 
Signed-off-by: lines.

Some people might have lines with different email addresses, but this 
still makes > 2000 contributors during the last 2 years alone. Plus all 
the other people who contributed during the first 14 years of Linux 
kernel development but didn't during the last 2 years.

You could argue whether there were really 10.000 people or "only"
5.000 people who contributed code to the Linux kernel, but 
that doesn't make a real difference.

> kloczek

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

