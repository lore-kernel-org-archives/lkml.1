Return-Path: <linux-kernel-owner+w=401wt.eu-S1757747AbXGKAz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747AbXGKAz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 20:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbXGKAzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 20:55:20 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:55500 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477AbXGKAzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 20:55:18 -0400
Date: Tue, 10 Jul 2007 20:55:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Thread Migration Preemption
Message-ID: <20070711005514.GA29071@Krystal>
References: <20070705215152.GA4865@Krystal> <468DDD3A.6010308@yahoo.com.au> <20070710233938.GT11166@waste.org> <46941E0F.3040209@yahoo.com.au> <20070711003611.GY11115@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070711003611.GY11115@waste.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:43:17 up 3 days, 14:48,  2 users,  load average: 0.76, 0.74, 0.48
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Mackall (mpm@selenic.com) wrote:
> On Wed, Jul 11, 2007 at 10:02:23AM +1000, Nick Piggin wrote:
> > >I like this patch a lot. Even if we don't add the underlying mechanism
> > >right now, adding migration_disable as an alias for preempt_disable
> > >will much better document quite a number of the users.
> > 
> > I'd have no problem with that, and it might make it easier in future to
> > justify a more complex scheme.
> 
> What do you think, Mathieu?
> 

That's an excellent idea. It should probably come with some
documentation explaining what difference should be expected between
preempt_disable and migrate_disable in the future so that people can
choose the right alternative for their code.

> Also, small nit: it ought to be migrate_disable to match the form of
> preempt_disable.

Yes, that's fine with me. :)

I though a little more about this whole concept of migrate_disable, and
I think it could be brought further. One of the main problems with per
cpu variables is that this concept cannot be ported to this grey place
called "user-space" because preemption cannot be disabled. The
equivalent (kind of) is currently per thread variables, but it can
consume a lot of space if many threads are running.

However, it could be possible, if we implement a vsyscall based
migration preemption counter accessible with read/write access from
user-space, to tie a thread to a CPU during a user-space critical path.
If we combine this with local atomic operations done in user-space, we
could have highly scalable access to per cpu data structures reentrant
with respect to signal handlers.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
