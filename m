Return-Path: <linux-kernel-owner+w=401wt.eu-S1751475AbZD3FPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbZD3FPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 01:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbZD3FP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 01:15:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:22380 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZD3FP0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 01:15:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OQrf2p+wErXm2DZahmIha4Dz09lH00f27M6B9G68FEPyNgz4xVvo+bAsAB85flkedr
         dtCyfS17AMBTinwKpx++CLdFqjjM1rdte17vNYnUZxtdsF1u1BAnEB9z5qSAn+gttRLS
         0d8sQ5dTd7KtuAOQPnb1rrHf3ARobfNf1F12c=
MIME-Version: 1.0
In-Reply-To: <20090427.201214.39166983.ryov@valinux.co.jp>
References: <2891419e0904230210w40482535ma3fc25c1e429969d@mail.gmail.com>
	 <20090424.185823.104059944.ryov@valinux.co.jp>
	 <2891419e0904270158n71b25271p6094feba70d0555d@mail.gmail.com>
	 <20090427.201214.39166983.ryov@valinux.co.jp>
Date: Thu, 30 Apr 2009 14:15:24 +0900
Message-ID: <2891419e0904292215x240dfeeg71f3eed0066bc112@mail.gmail.com>
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

Hi Ryo

I am sorry for delayed reply.
I tested range-bw policy as you send me your configuration
and I found some logical bugs in range-bw including big scheduling overhead.

> I used fio 1.22. The below is a script which I actually ran.
>
>  #!/bin/sh
>  dev1=/dev/sdb4 # SATA disk
>  echo "0 $(sudo blockdev --getsize $dev1) ioband $dev1 share2 0 0
>    cgroup range-bw 0" | sudo dmsetup create ioband1
>
>  arg="--time_based --runtime=10 --ioengine=libaio --iodepth=50 \
>       --direct=1 --norandommap"
>
>  dmsetup message ioband1 0 attach 2
>  dmsetup message ioband1 0 attach 3
>  dmsetup message ioband1 0 min-bw 2:100
>  dmsetup message ioband1 0 max-bw 2:100
>  dmsetup message ioband1 0 min-bw 3:200
>  dmsetup message ioband1 0 max-bw 3:200

I recommend it is better to use different value in min-bw and max-bw
because its concept is to support range-bw with the minimum
guaranteeing and maximum limitation.
exampe - min-bw : 1024 / max-bw : 3072

>  echo $$ > /cgroup/grp1/tasks
>  fio $arg --rw=randread --name=grp1 --filename=/dev/mapper/ioband1 \
>          --output=r2-1.log &
>  echo $$ > /cgroup/grp2/tasks
>  fio $arg --rw=randread --name=grp2 --filename=/dev/mapper/ioband1 \
>          --output=r2-2.log &
>  wait
>
> Please feel free to ask me if you need more information.
>
>
> I'm look forward to seeing the results.
>
Thanks for your comments.
And I will fix the bugs and re-release it after several days
at that time, I inform you about that.

Ryo,
now, I am using bio-cgroup.....
but, Is there additional things I have to consider to support AIO or
dealyed I/O?

-- 
Best Regards,
Dong-Jae Kang
