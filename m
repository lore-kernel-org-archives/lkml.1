Return-Path: <linux-kernel-owner+w=401wt.eu-S1751788AbXHZIK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbXHZIK1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 04:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbXHZIKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 04:10:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56007 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711AbXHZIKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 04:10:11 -0400
Date: Sun, 26 Aug 2007 01:09:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: ego@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       Cliff Wickman <cpw@sgi.com>, mingo@elte.hu, vatsa@in.ibm.com,
       pj@sgi.com, linux-kernel@vger.kernel.org, ntl@in.ibm.com,
       Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-Id: <20070826010903.7599c22e.akpm@linux-foundation.org>
In-Reply-To: <1188089244.19877.3.camel@localhost.localdomain>
References: <20070824221806.GA3602@sgi.com>
	<20070824155455.cc161b61.akpm@linux-foundation.org>
	<20070825094740.GA106@tv-sign.ru>
	<20070826001625.GA17962@in.ibm.com>
	<1188089244.19877.3.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Aug 2007 10:47:24 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Sun, 2007-08-26 at 05:46 +0530, Gautham R Shenoy wrote:
> > On Sat, Aug 25, 2007 at 01:47:40PM +0400, Oleg Nesterov wrote:
> > > Before this patch, process leaves its ->cpuset and migrates to some "random"
> > > any_online_cpu(). With this patch it stays within ->cpuset and migrates to
> > > CPU 3.
> > 
> > The decision to bind a task to a specific cpu, was taken by the userspace
> > for a reason, which is _unknown_ to the kernel.
> > So logically, shouldn't the userspace decide what should be 
> > the fate of those exclusive-affined tasks, whose cpu is about to go
> > offline? After all, the reason to offline the cpu is, again, unknown to
> > the kernel.
> 
> Userspace is not monolithic.  If you refuse to take a CPU offline
> because a task is affine, then any user can prevent a CPU from going
> offline.

That's a kernel bug.

> You could, perhaps, introduce a "gentle" offline which fails if process
> affinity can no longer be met.

Suitably privileged userspace should be able to

1) prevent tasks from binding to CPU N then
2) migrate all tasks which can use CPU N over to other CPU(s) then
3) offline CPU N.

