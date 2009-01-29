Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbZA2DkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbZA2DkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 22:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZA2Dj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 22:39:57 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:35860 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752779AbZA2Dj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 22:39:57 -0500
Date: Thu, 29 Jan 2009 12:39:55 +0900 (JST)
Message-Id: <20090129.123955.102562289.ryov@valinux.co.jp>
To: vgoyal@redhat.com
Cc: dm-devel@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com,
       fernando@intellilink.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, arozansk@redhat.com, jmoyer@redhat.com,
       riel@redhat.com, peterz@infradead.org, menage@google.com,
       balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, chrisw@redhat.com
Subject: Hierarchical grouping facility for IO controller (Re: [dm-devel]
 [PATCH 1/2] dm-ioband: I/O bandwidth controller v1.10.0: Source code and
 patch)
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090126162951.GI31802@redhat.com>
References: <20090122161218.GA28795@redhat.com>
	<20090123.191404.39168431.ryov@valinux.co.jp>
	<20090126162951.GI31802@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

This mail is about hierarchical grouping facility for IO controller.

> I think with the introduction of cgroup, IO scheduling has become now
> a hierarhical scheduling. Previously it was flat scheduling where there
> was only one level. Not there can be multiple levels and each level
> can have groups and queues. I don't think that we can break down
> hiearchical scheduling problem in two parts where top level part is moved
> into a module. It is something like saying that lets break out cpu group
> schedling into a separate module and it should not be part of kernel.
> 
> I think we need to implement this hiearchical IO scheduler in kernel which
> can schedule groups as well as end level io queues. (maintained by cfq,
> deadline, as, or noop).

I can implement the hierarchical grouping facility if really necessary
and the patch will be released after dm-ioband is merged into the
kernel. But do you believe the hierarchical grouping facility should
be implemented in the kernel, even if we can do it in the userland?
I think disk bandwidth control doesn't need responsiveness like the
CPU scheduler. I know it's possible to implement in the kernel, but
does it only make the kernel complex?

> > > - Task grouping logic
> > > 	- We already have the notion of cgroup where tasks can be grouped
> > > 	  in hierarhical manner. dm-ioband does not make full use of that and
> > > 	  comes up with own mechansim of grouping tasks (apart from cgroup).
> > > 	  And there are odd ways of specifying cgroup id which configuring the
> > > 	  dm-ioband device. I think once somebody has created the cgroup
> > > 	  hieararchy, any IO controller logic should be able to internally
> > > 	  read that hiearchy and provide control. There should not be need
> > > 	  of any other configuration utity on top of cgroup.
> > > 
> > > 	  My RFC patches had done that.
> > 
> > Dm-ioband can work with the bio-cgroup mechanism, which makes task groups
> > in manner of the cgroup, of course.
> > I already have a basic design to make dm-ioband support the cgroup
> > hierarchy. This should be started after the core code of bio-cgroup,
> > which helps trace each I/O requests, is merged in -mm tree.
> 
> bio-cgroup patches are fine because they provide us the capability to 
> map delayed writes to right cgroup. And it can be used by any IO
> controller. 
> 
> > And the reason dm-ioband uses cgroup id to specify a cgroup is that
> > the current cgroup infrastructure lacks features to manage resources
> > placed in the kernel modules.
> 
> Can you elaborate on that please? We have heard in the past that cgroup 
> does not give you enough flexibility but never got details.

The current cgroup framework can't manage resources dynamically. The
reason for using a cgroup ID to specify a cgroup is that it makes the
implementation quite simple. Although it is possible to implement the
function without using the ID, it makes the kernel complex due to the
function has to be implemented outside of the kernel.

Thanks,
Ryo Tsuruta
