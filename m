Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbYFZLIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbYFZLIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 07:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbYFZLIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 07:08:41 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:46436 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbYFZLIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 07:08:40 -0400
Subject: Re: A question about group CFS scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Zhao Forrest <forrest.zhao@gmail.com>
Cc: vatsa@linux.vnet.ibm.com, mingo@elte.hu, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <ac8af0be0806260133u68a5692flab65e4bb6dcf2a13@mail.gmail.com>
References: <ac8af0be0806260019q45fa7285oa0fc79fb02254d28@mail.gmail.com>
	 <1214468112.2794.9.camel@twins.programming.kicks-ass.net>
	 <ac8af0be0806260133u68a5692flab65e4bb6dcf2a13@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 13:08:27 +0200
Message-Id: <1214478507.4922.0.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-26 at 16:33 +0800, Zhao Forrest wrote:
> >
> > Let me explain the cgroup case (the sanest option IMHO):
> >
> > initially all your tasks will belong to the root cgroup, eg:
> >
> > assuming:
> > mkdir -p /cgroup/cpu
> > mount none /cgroup/cpu -t cgroup -o cpu
> >
> > Then the root cgroup (cgroup:/) is /cgroup/cpu/ and all tasks will be
> > found in /cgroup/cpu/tasks.
> >
> > You can then create new groups as sibling from this root group, eg:
> >
> > cgroup:/foo
> > cgroup:/bar
> >
> > They will get a weigth of 1024 by default, exactly as heavy as a nice 0
> > task.
> >
> > That means that no matter how many tasks you stuff into foo, their
> > combined cpu time will be as much as a single tasks in cgroup:/ would
> > get.
> >
> > This is fully recursive, so you can also create:
> >
> > cgroup:/foo/bar and its tasks in turn will get as much combined cpu time
> > as a single task in cgroup:/foo would get.
> >
> > In theory this should go on indefinitely, in practise we'll run into
> > serious numerical issues quite quickly.
> >
> >
> > The USER grouping basically creates a fake root and all uids (including
> > 0) are its siblings. The only special case is that uid-0 (aka root) will
> > get twice the weight of the others.
> >
> 
> Thank you for your detailed explanation! I have one more question:
> cgrouping and USER grouping is mutual exclusive, am I right? That is,
> when enabling cgrouping, USER grouping need to be disabled, vice
> versa.

Yes indeed. That is set at kernel build time. So the kernel either
supports cgroup scheduling or uid stuff.

