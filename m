Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbZEKKLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbZEKKLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbZEKKLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:11:19 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:39106 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755918AbZEKKLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:11:18 -0400
Date: Mon, 11 May 2009 19:11:18 +0900 (JST)
Message-Id: <20090511.191118.104045995.ryov@valinux.co.jp>
To: riel@redhat.com
Cc: vgoyal@redhat.com, akpm@linux-foundation.org, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, peterz@infradead.org
Subject: Re: IO scheduler based IO Controller V2
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <4A0440B2.7040300@redhat.com>
References: <20090506023332.GA1212@redhat.com>
	<20090507.091858.226775723.ryov@valinux.co.jp>
	<4A0440B2.7040300@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

From: Rik van Riel <riel@redhat.com>
Subject: Re: IO scheduler based IO Controller V2
Date: Fri, 08 May 2009 10:24:50 -0400

> Ryo Tsuruta wrote:
> > Hi Vivek,
> > 
> >> Ryo, dm-ioband breaks the notion of classes and priority of CFQ because
> >> of FIFO dispatch of buffered bios. Apart from that it tries to provide
> >> fairness in terms of actual IO done and that would mean a seeky workload
> >> will can use disk for much longer to get equivalent IO done and slow down
> >> other applications. Implementing IO controller at IO scheduler level gives
> >> us tigher control. Will it not meet your requirements? If you got specific
> >> concerns with IO scheduler based contol patches, please highlight these and
> >> we will see how these can be addressed.
> > I'd like to avoid making complicated existing IO schedulers and other
> > kernel codes and to give a choice to users whether or not to use it.
> > I know that you chose an approach that using compile time options to
> > get the same behavior as old system, but device-mapper drivers can be
> > added, removed and replaced while system is running.
> 
> I do not believe that every use of cgroups will end up with
> a separate logical volume for each group.
> 
> In fact, if you look at group-per-UID usage, which could be
> quite common on shared web servers and shell servers, I would
> expect all the groups to share the same filesystem.
> 
> I do not believe dm-ioband would be useful in that configuration,
> while the IO scheduler based IO controller will just work.

dm-ioband can control bandwidth on a per cgroup basis as same as
Vivek's IO controller. Could you explain what do you want to do and
how to configure the IO scheduler based IO controller in that case?

Thanks,
Ryo Tsuruta
