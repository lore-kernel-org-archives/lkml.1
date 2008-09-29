Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbYI2Kku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbYI2Kku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 06:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYI2Kkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 06:40:42 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:34367 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751323AbYI2Kkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 06:40:41 -0400
Date: Mon, 29 Sep 2008 19:40:36 +0900 (JST)
Message-Id: <20080929.194036.105502812.taka@valinux.co.jp>
To: righi.andrea@gmail.com
Cc: vgoyal@redhat.com, ryov@valinux.co.jp, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, xemul@openvz.org, agk@sourceware.org,
       jens.axboe@oracle.com
Subject: Re: dm-ioband + bio-cgroup benchmarks
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <48DD0617.3050403@gmail.com>
References: <20080924145331.GD547@redhat.com>
	<20080926.220418.83079316.taka@valinux.co.jp>
	<48DD0617.3050403@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> >>>>> It's possible the algorithm of dm-ioband can be placed in the block layer
> >>>>> if it is really a big problem.
> >>>>> But I doubt it can control every control block I/O as we wish since
> >>>>> the interface the cgroup supports is quite poor.
> >>>> Had a question regarding cgroup interface. I am assuming that in a system,
> >>>> one will be using other controllers as well apart from IO-controller.
> >>>> Other controllers will be using cgroup as a grouping mechanism.
> >>>> Now coming up with additional grouping mechanism for only io-controller seems
> >>>> little odd to me. It will make the job of higher level management software
> >>>> harder.
> >>>>
> >>>> Looking at the dm-ioband grouping examples given in patches, I think cases
> >>>> of grouping based  in pid, pgrp, uid and kvm can be handled by creating right
> >>>> cgroup and making sure applications are launched/moved into right cgroup by
> >>>> user space tools. 
> >>> Grouping in pid, pgrp and uid is not the point, which I've been thinking
> >>> can be replaced with cgroup once the implementation of bio-cgroup is done.
> >>>
> >>> I think problems of cgroup are that they can't support lots of storages
> >>> and hotplug devices, it just handle them as if they were just one resource.
> >>> I don't insist the interface of dm-ioband is the best. I just hope the
> >>> cgroup infrastructure support this kind of resources.
> >>>
> >> Sorry, I did not understand fully. Can you please explain in detail what
> >> kind of situation will not be covered by cgroup interface.
> > 
> > From the concept of the cgroup, if you want control several disks
> > independently, you should make each disk have its own cgroup subsystem,
> > which only can be defined when compiling the kernel. This is impossible
> > because every linux box has various number of disks.
> 
> mmh? not true. You can define a single cgroup subsystem that implements
> the opportune interfaces to apply your type of control, and use many
> structures allocated dynamically for each controlled object (one for
> each block device, disk, partition, ... or using any kind of
> grouping/splitting policy). Actually, this is how cgroup-io-throttle, as
> well as any other cgroup subsystem, is implemented.
> 
> > So you think it may be possible to make each cgroup have lots of control
> > files for each device as a workaround. But it isn't allowed to add/remove
> > control files when some devices are hot-added or hot-removed.
> 
> Why not a single control file for all the devices?

This is possible but I wonder if this is really the way we should go.
It looks like you tried implementing another ioctl-like interface
on the cgroup control file interface. You can do anything you want
with this interface though.

I guess there should be at least some rules to implement this kind of
ioctl-like interface if they don't want to enhance the cgroup interface, 

Thank you,
Hirokazu Takahashi.



