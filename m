Return-Path: <linux-kernel-owner+w=401wt.eu-S966131AbYCSVWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966131AbYCSVWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762081AbYCSUA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:00:28 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:60073 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757160AbYCSUAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:00:25 -0400
Date: Wed, 19 Mar 2008 12:59:08 +0900 (JST)
Message-Id: <20080319.125908.14787908.taka@valinux.co.jp>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH O/4] Block I/O tracking
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080318191624.85ca135f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080318.182251.93858044.taka@valinux.co.jp>
	<20080318191624.85ca135f.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> >  # mount -t cgroup -o bio none /cgroup/bio
> > 
> > Then, you make new bio cgroups and put some processes in them.
> > 
> >  # mkdir /cgroup/bio/bgroup1
> >  # mkdir /cgroup/bio/bgroup2
> >  # echo 1234 /cgroup/bio/bgroup1/tasks
> >  # echo 5678 /cgroup/bio/bgroup1/tasks
> > 
> > Now you check the ids of the bio cgroups which you just created.
> > 
> >  # cat /cgroup/bio/bgroup1/bio.id
> >    1
> >  # cat /cgroup/bio/bgroup2/bio.id
> >    2
> > 
> > Finally, you can attach the cgroups to "ioband1" and assign them weights.
> > 
> >  # dmsetup message ioband1 0 type cgroup
> >  # dmsetup message ioband1 0 attach 1
> >  # dmsetup message ioband1 0 attach 2
> >  # dmsetup message ioband1 0 weight 1:30
> >  # dmsetup message ioband1 0 weight 2:60
> > 
> > You can find the manual of dm-ioband at
> > http://people.valinux.co.jp/~ryov/dm-ioband/manual/index.html.
> > But the user interface for the bio cgroup is temporal and it will be
> > changed after the io_context support. 
> > 
> I'm grad if these some kinds of params rather than 'id' are also shown
> under cgroup.

You mean each bio cgroup has to have a lot of files which shows the status
of the cgroup or allows you to control the cgroup.
I think this should be done after the cgroup bio subsystem supports
io_context since the interface will be changed to support it.

> Thanks,
> -Kame

Thank you,
Hirokazu Takahashi.
