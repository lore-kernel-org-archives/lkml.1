Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYIXKeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYIXKeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 06:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYIXKeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 06:34:17 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:36770 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752012AbYIXKeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 06:34:16 -0400
Date: Wed, 24 Sep 2008 19:34:14 +0900 (JST)
Message-Id: <20080924.193414.22923673.taka@valinux.co.jp>
To: vgoyal@redhat.com
Cc: ryov@valinux.co.jp, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, xemul@openvz.org, agk@sourceware.org,
       righi.andrea@gmail.com, jens.axboe@oracle.com
Subject: Re: dm-ioband + bio-cgroup benchmarks
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080922143042.GA19222@redhat.com>
References: <20080919131019.GA3606@redhat.com>
	<20080922.183651.62951479.taka@valinux.co.jp>
	<20080922143042.GA19222@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > It's possible the algorithm of dm-ioband can be placed in the block layer
> > if it is really a big problem.
> > But I doubt it can control every control block I/O as we wish since
> > the interface the cgroup supports is quite poor.
> 
> Had a question regarding cgroup interface. I am assuming that in a system,
> one will be using other controllers as well apart from IO-controller.
> Other controllers will be using cgroup as a grouping mechanism.
> Now coming up with additional grouping mechanism for only io-controller seems
> little odd to me. It will make the job of higher level management software
> harder.
> 
> Looking at the dm-ioband grouping examples given in patches, I think cases
> of grouping based  in pid, pgrp, uid and kvm can be handled by creating right
> cgroup and making sure applications are launched/moved into right cgroup by
> user space tools. 

Grouping in pid, pgrp and uid is not the point, which I've been thinking
can be replaced with cgroup once the implementation of bio-cgroup is done.

I think problems of cgroup are that they can't support lots of storages
and hotplug devices, it just handle them as if they were just one resource.
I don't insist the interface of dm-ioband is the best. I just hope the
cgroup infrastructure support this kind of resources.

> I think keeping grouping mechanism in line with rest of the controllers
> should help because a uniform grouping mechanism should make life simpler.
> 
> I am not very sure about moving dm-ioband algorithm in block layer. Looks
> like it will make life simpler at least in terms of configuration. 


Thanks,
Hirokazu Takahashi.
