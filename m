Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYIZNE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYIZNE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 09:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYIZNEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 09:04:21 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:49321 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751651AbYIZNEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 09:04:20 -0400
Date: Fri, 26 Sep 2008 22:04:18 +0900 (JST)
Message-Id: <20080926.220418.83079316.taka@valinux.co.jp>
To: vgoyal@redhat.com
Cc: ryov@valinux.co.jp, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, xemul@openvz.org, agk@sourceware.org,
       righi.andrea@gmail.com, jens.axboe@oracle.com
Subject: Re: dm-ioband + bio-cgroup benchmarks
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080924145331.GD547@redhat.com>
References: <20080922143042.GA19222@redhat.com>
	<20080924.193414.22923673.taka@valinux.co.jp>
	<20080924145331.GD547@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > > > It's possible the algorithm of dm-ioband can be placed in the block layer
> > > > if it is really a big problem.
> > > > But I doubt it can control every control block I/O as we wish since
> > > > the interface the cgroup supports is quite poor.
> > > 
> > > Had a question regarding cgroup interface. I am assuming that in a system,
> > > one will be using other controllers as well apart from IO-controller.
> > > Other controllers will be using cgroup as a grouping mechanism.
> > > Now coming up with additional grouping mechanism for only io-controller seems
> > > little odd to me. It will make the job of higher level management software
> > > harder.
> > > 
> > > Looking at the dm-ioband grouping examples given in patches, I think cases
> > > of grouping based  in pid, pgrp, uid and kvm can be handled by creating right
> > > cgroup and making sure applications are launched/moved into right cgroup by
> > > user space tools. 
> > 
> > Grouping in pid, pgrp and uid is not the point, which I've been thinking
> > can be replaced with cgroup once the implementation of bio-cgroup is done.
> > 
> > I think problems of cgroup are that they can't support lots of storages
> > and hotplug devices, it just handle them as if they were just one resource.
> > I don't insist the interface of dm-ioband is the best. I just hope the
> > cgroup infrastructure support this kind of resources.
> > 
> 
> Sorry, I did not understand fully. Can you please explain in detail what
> kind of situation will not be covered by cgroup interface.

>From the concept of the cgroup, if you want control several disks
independently, you should make each disk have its own cgroup subsystem,
which only can be defined when compiling the kernel. This is impossible
because every linux box has various number of disks.

So you think it may be possible to make each cgroup have lots of control
files for each device as a workaround. But it isn't allowed to add/remove
control files when some devices are hot-added or hot-removed.

Thanks,
Hirokazu Takahashi.
