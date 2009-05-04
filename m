Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbZEDLXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbZEDLXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 07:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZEDLXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 07:23:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:1491 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZEDLXG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 07:23:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lBfEbmjVluxT3aa7Bd8IfBEyv3Br2tOVmiLs8XGVXD2Bzceyy14qLTCAPHHrmEApGo
         Of3CL263J0UMik5Lh7j/Gc6rYya/YyLIgHyLDyuV5cjwZRD17WLILCrSdvlni9DjEX7C
         UP6CBSySlvFPTkC4x59dmMv8QtIwLDx31gebA=
MIME-Version: 1.0
In-Reply-To: <20090430.165310.226796026.ryov@valinux.co.jp>
References: <2891419e0904270158n71b25271p6094feba70d0555d@mail.gmail.com>
	 <20090427.201214.39166983.ryov@valinux.co.jp>
	 <2891419e0904292215x240dfeeg71f3eed0066bc112@mail.gmail.com>
	 <20090430.165310.226796026.ryov@valinux.co.jp>
Date: Mon, 4 May 2009 20:23:04 +0900
Message-ID: <2891419e0905040423y27f25ce7y61e5211aded85f99@mail.gmail.com>
Subject: Re: [PATCH] range-bw: Another I/O scheduling policy of dm-ioband 
	supporting the predicable I/O bandwidth (range bandwidth)
From: Dong-Jae Kang <baramsori72@gmail.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: righi.andrea@gmail.com, menage@google.com, balbir@linux.vnet.ibm.com,
       guijianfeng@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       chlunde@ping.uio.no, dave@linux.vnet.ibm.com, dpshah@google.com,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp, taka@valinux.co.jp,
       lizf@cn.fujitsu.com, matt@bluehost.com, dradford@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, nauman@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, corsetproject@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ryo

I released bug-fixed range-bw(V1) controller several minutes ago

Although several WARNINGs of checkpatch are remained,
but patch file was strictly checked by checkpatch.pl
It was very time-consuming job :)
Thank you for your advice

>>
>> > I used fio 1.22. The below is a script which I actually ran.
>> >
>> >  #!/bin/sh
>> >  dev1=/dev/sdb4 # SATA disk
>> >  echo "0 $(sudo blockdev --getsize $dev1) ioband $dev1 share2 0 0
>> >    cgroup range-bw 0" | sudo dmsetup create ioband1
>> >
>> >  arg="--time_based --runtime=10 --ioengine=libaio --iodepth=50 \
>> >       --direct=1 --norandommap"
>> >
>> >  dmsetup message ioband1 0 attach 2
>> >  dmsetup message ioband1 0 attach 3
>> >  dmsetup message ioband1 0 min-bw 2:100
>> >  dmsetup message ioband1 0 max-bw 2:100
>> >  dmsetup message ioband1 0 min-bw 3:200
>> >  dmsetup message ioband1 0 max-bw 3:200
>>
>> I recommend it is better to use different value in min-bw and max-bw
>> because its concept is to support range-bw with the minimum
>> guaranteeing and maximum limitation.
>> exampe - min-bw : 1024 / max-bw : 3072
>>
>> >  echo $$ > /cgroup/grp1/tasks
>> >  fio $arg --rw=randread --name=grp1 --filename=/dev/mapper/ioband1 \
>> >          --output=r2-1.log &
>> >  echo $$ > /cgroup/grp2/tasks
>> >  fio $arg --rw=randread --name=grp2 --filename=/dev/mapper/ioband1 \
>> >          --output=r2-2.log &
>> >  wait

after bug-fix,I evaluated range-bw according to your configuration and
test environment
the result is in new relesed range-bw mail, [PATCH 0/2]
and more detailed documentation is also available and it can be
referred in [PATCH 1/2]

Ryo,
can you check the result ?

> bio-cgroup is renamed to bklio-cgroup. :)
> I don't clearly understand about range-bw but I think that you don't
> need to consider to support them and it should be taken care of by
> blkio-cgroup and the common part of dm-ioband, not the policy
> implementation. Do you have any problems with AIO or delayed write?

if you are interested in range-bw, more information is available to you
and any questions and comments about range-bw is always welcom.  :)

Ryo,
blkio-cgroup can be applied to dm-ioband ver1.10.3 without modification?
I didn't check blkio-cgroup yet.

Thank you
>> --
>> Best Regards,
>> Dong-Jae Kang
>



-- 
Best Regards,
Dong-Jae Kang
