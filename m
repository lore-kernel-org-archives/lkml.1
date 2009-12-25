Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbZLYTdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbZLYTdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 14:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbZLYTdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 14:33:12 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:36422 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbZLYTdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 14:33:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r0rpvvBljUB08SVP5flRru9leRn+3XZoDFrLadG+7g+5S0a74to1lz0AIaUsMpDNa5
         PSrxl3y1w/eCD/Wz0GyVd2Dvntc2oOPFHgTzM3bnODu+U3Z8BWZ0o+r0QMQM5kMKz3Wi
         tX4TGbp7ke1+I8bPdDIPeyMCbggHvTqNiK2is=
MIME-Version: 1.0
In-Reply-To: <87hbrfdylc.fsf@openvz.org>
References: <a4423d670912241428n6917d2adsad887548612cf8ce@mail.gmail.com>
	 <a4423d670912241449y2da43d5fi3e5a18c114b84178@mail.gmail.com>
	 <87hbrfdylc.fsf@openvz.org>
Date: Fri, 25 Dec 2009 22:33:05 +0300
Message-ID: <a4423d670912251133u795338a4wd32d5cdef8c36c75@mail.gmail.com>
Subject: Re: 2.6.33-rc1: kernel BUG at fs/ext4/inode.c:1063 (sparc)
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> It seems I can easily reproduce it.
>> But I can't compile 2.6.33-rc2 :)
>>
>> scripts/kconfig/conf -s arch/sparc/Kconfig
>>   CHK     include/linux/version.h
>>   CHK     include/generated/utsrelease.h
>>   CALL    scripts/checksyscalls.sh
>>   CHK     include/generated/compile.h
>>   GZIP    kernel/config_data.gz
>>   CC      fs/configfs/inode.o
>>   IKCFG   kernel/config_data.h
>>   LD [M]  fs/btrfs/btrfs.o
>>   CC      kernel/configs.o
>> fs/btrfs/sysfs.o: file not recognized: File truncated
> This happens because of  delayed allocation. Each time BUG or
> unexpected power off happens during object files usually becomes
> broken. IMHO this is expected issue. Just recompile from beginning
> # make clean; make -j4

It does not help, it still fails.
I will try to crosscompile the kernel with Ted's patch on another host.

> As soon as your testcase is kernel compilation.
> Strange i'm living with quota patches on my notebook more than
> a month( two weeks with the version committed to quota git tree)
> with and without quota . But this never happens.
> Currently i'm trying to reproduce the bug on 2.6.33-rc2
> Please add keep me in cc because seems the bug was introduced
> (or just triggered) by my quota patches.
>> make[2]: *** [fs/btrfs/btrfs.o] Error 1
>> make[1]: *** [fs/btrfs] Error 2
>> make[1]: *** Waiting for unfinished jobs....
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
