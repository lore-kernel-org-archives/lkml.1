Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbZEDWhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbZEDWhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 18:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbZEDWg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 18:36:56 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:38241 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751491AbZEDWgz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 18:36:55 -0400
Date: Tue, 05 May 2009 07:36:55 +0900 (JST)
Message-Id: <20090505.073655.193711315.ryov@valinux.co.jp>
To: baramsori72@gmail.com
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
Subject: Re: [PATCH] range-bw: Another I/O scheduling policy of dm-ioband
 supporting the predicable I/O bandwidth (range bandwidth)
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <2891419e0905040423y27f25ce7y61e5211aded85f99@mail.gmail.com>
References: <2891419e0904292215x240dfeeg71f3eed0066bc112@mail.gmail.com>
	<20090430.165310.226796026.ryov@valinux.co.jp>
	<2891419e0905040423y27f25ce7y61e5211aded85f99@mail.gmail.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dong-Jae

From: Dong-Jae Kang <baramsori72@gmail.com>
Subject: Re: [PATCH] range-bw: Another I/O scheduling policy of dm-ioband supporting the predicable I/O bandwidth (range bandwidth)
Date: Mon, 4 May 2009 20:23:04 +0900

> Hi, Ryo
> 
> I released bug-fixed range-bw(V1) controller several minutes ago
> 
> Although several WARNINGs of checkpatch are remained,
> but patch file was strictly checked by checkpatch.pl
> It was very time-consuming job :)
> Thank you for your advice
> 
> >>
> >> > I used fio 1.22. The below is a script which I actually ran.
> >> >
> >> >  #!/bin/sh
> >> >  dev1=/dev/sdb4 # SATA disk
> >> >  echo "0 $(sudo blockdev --getsize $dev1) ioband $dev1 share2 0 0
> >> >    cgroup range-bw 0" | sudo dmsetup create ioband1
> >> >
> >> >  arg="--time_based --runtime=10 --ioengine=libaio --iodepth=50 \
> >> >       --direct=1 --norandommap"
> >> >
> >> >  dmsetup message ioband1 0 attach 2
> >> >  dmsetup message ioband1 0 attach 3
> >> >  dmsetup message ioband1 0 min-bw 2:100
> >> >  dmsetup message ioband1 0 max-bw 2:100
> >> >  dmsetup message ioband1 0 min-bw 3:200
> >> >  dmsetup message ioband1 0 max-bw 3:200
> >>
> >> I recommend it is better to use different value in min-bw and max-bw
> >> because its concept is to support range-bw with the minimum
> >> guaranteeing and maximum limitation.
> >> exampe - min-bw : 1024 / max-bw : 3072
> >>
> >> >  echo $$ > /cgroup/grp1/tasks
> >> >  fio $arg --rw=randread --name=grp1 --filename=/dev/mapper/ioband1 \
> >> >          --output=r2-1.log &
> >> >  echo $$ > /cgroup/grp2/tasks
> >> >  fio $arg --rw=randread --name=grp2 --filename=/dev/mapper/ioband1 \
> >> >          --output=r2-2.log &
> >> >  wait
> 
> after bug-fix,I evaluated range-bw according to your configuration and
> test environment
> the result is in new relesed range-bw mail, [PATCH 0/2]
> and more detailed documentation is also available and it can be
> referred in [PATCH 1/2]
> 
> Ryo,
> can you check the result ?

O.K. I'll check it and report back to you.

> 
> > bio-cgroup is renamed to bklio-cgroup. :)
> > I don't clearly understand about range-bw but I think that you don't
> > need to consider to support them and it should be taken care of by
> > blkio-cgroup and the common part of dm-ioband, not the policy
> > implementation. Do you have any problems with AIO or delayed write?
> 
> if you are interested in range-bw, more information is available to you
> and any questions and comments about range-bw is always welcom.  :)
> 
> Ryo,
> blkio-cgroup can be applied to dm-ioband ver1.10.3 without modification?
> I didn't check blkio-cgroup yet.

Yes, it can. Please try it.

Thanks,
Ryo Tsuruta
