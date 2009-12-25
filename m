Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbZLYXrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbZLYXrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 18:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756425AbZLYXrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 18:47:52 -0500
Received: from mail.2ka.mipt.ru ([194.85.80.4]:37186 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203AbZLYXrw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 18:47:52 -0500
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: 2.6.33-rc1: kernel BUG at fs/ext4/inode.c:1063 (sparc)
References: <a4423d670912241428n6917d2adsad887548612cf8ce@mail.gmail.com>
 <a4423d670912241449y2da43d5fi3e5a18c114b84178@mail.gmail.com>
 <87hbrfdylc.fsf@openvz.org>
 <a4423d670912251133u795338a4wd32d5cdef8c36c75@mail.gmail.com>
Date: Sat, 26 Dec 2009 02:47:47 +0300
In-reply-to: <a4423d670912251133u795338a4wd32d5cdef8c36c75@mail.gmail.com>
Message-id: <87eimir4yk.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
Content-transfer-encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Beregalov <a.beregalov@gmail.com> writes:

>>> It seems I can easily reproduce it.
>>> But I can't compile 2.6.33-rc2 :)
BTW what sha1 of the git-commit you have used to reproduce
the bug (2.6.33-rc1 HEAD has no this BUG_ON).
This is important to me to know it, or just post the 
fs/ext4/inode.c file.
>>>
>>> scripts/kconfig/conf -s arch/sparc/Kconfig
>>>   CHK     include/linux/version.h
>>>   CHK     include/generated/utsrelease.h
>>>   CALL    scripts/checksyscalls.sh
>>>   CHK     include/generated/compile.h
>>>   GZIP    kernel/config_data.gz
>>>   CC      fs/configfs/inode.o
>>>   IKCFG   kernel/config_data.h
>>>   LD [M]  fs/btrfs/btrfs.o
>>>   CC      kernel/configs.o
>>> fs/btrfs/sysfs.o: file not recognized: File truncated
>> This happens because of  delayed allocation. Each time BUG or
>> unexpected power off happens during object files usually becomes
>> broken. IMHO this is expected issue. Just recompile from beginning
>> # make clean; make -j4
>
> It does not help, it still fails.
Again strange, please run fsck. What about compile it from very
beginning (start from unpacking tar-ball from kernel.org)
Or may be compile it on another file-system(ext3 or
ext4 with nodelalloc option)
> I will try to crosscompile the kernel with Ted's patch on another host.
>
It is sad, but i still can not reproduce your bug.
At this time i've tested following configurations: 
system   :    2.6.33-rc2, x86 two cores cpu with 2GB of ram 
block dev: real sata drive, loopdev over tmpfs
mkfs     : 4k and 1k blocksize
mount    : w/o quota, quota, journaled quota
quota    : both ON and OFF states
fs-load  : - fsstress with 1,4,16,32 concurrent tasks
           - kernel compilation -j4, -j32
           - In fact currently my mail-dir is under quota control.
Please clarify your use-case:
0) Your system speciffication: cpu_num, mem_size, page_size(i guess 8k)
   block device.
1) mkfs options
2) mount options
3) quota options (if any)
4) your fs load test-case
5) How long does it takes you to reproduce the bug.
>> As soon as your testcase is kernel compilation.
>> Strange i'm living with quota patches on my notebook more than
>> a month( two weeks with the version committed to quota git tree)
>> with and without quota . But this never happens.
>> Currently i'm trying to reproduce the bug on 2.6.33-rc2
>> Please add keep me in cc because seems the bug was introduced
>> (or just triggered) by my quota patches.
>>> make[2]: *** [fs/btrfs/btrfs.o] Error 1
>>> make[1]: *** [fs/btrfs] Error 2
>>> make[1]: *** Waiting for unfinished jobs....
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

>  LocalWords:  speciffication cpu
