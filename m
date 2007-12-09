Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbXLISh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbXLISh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 13:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbXLISht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 13:37:49 -0500
Received: from mcclure-nat.wal.novell.com ([130.57.22.22]:26303 "EHLO
	mcclure.wal.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750956AbXLIShs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 13:37:48 -0500
Message-Id: <475BEE6B.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Sun, 09 Dec 2007 13:32:27 -0500
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Steven Rostedt" <srostedt@redhat.com>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       "Balbir Singh" <balbir@in.ibm.com>, <vatsa@linux.vnet.ibm.com>,
       "LKML Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: RT Load balance changes in sched-devel
References: <20071130145939.GN5681@linux.vnet.ibm.com>
 <b647ffbd0712011156p252ae29dnfa75494e4d2c845c@mail.gmail.com>
 <20071203182223.GA4133@linux.vnet.ibm.com> <47556B23.2060909@redhat.com>
 <20071204153542.GC3388@linux.vnet.ibm.com>
 <b647ffbd0712040828l51a26a82jc0f38d3f4aa2291e@mail.gmail.com>
 <20071205134036.GA21933@linux.vnet.ibm.com> <4756B8E9.3080709@redhat.com>
 <20071205164800.GA24767@linux.vnet.ibm.com> <4756D709.1020901@redhat.com>
 <b647ffbd0712090916l4eb9a944r4726680a5fdcae46@mail.gmail.com>
In-Reply-To: <b647ffbd0712090916l4eb9a944r4726680a5fdcae46@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

>>> On Sun, Dec 9, 2007 at 12:16 PM, in message
<b647ffbd0712090916l4eb9a944r4726680a5fdcae46@mail.gmail.com>, "Dmitry
Adamushko" <dmitry.adamushko@gmail.com> wrote: 
> [ cc'ed lkml ]
> 
> I guess, one possible load-balancing point is out of consideration --
> sched_setscheduler()
> (also rt_mutex_setprio()).
> 
> (1)  NORMAL --> RT, when p->se.on_rq == 1 && ! task_running(rq, p)
> 
> (2) RT --> NORMAL, when task_running(rq, p) == 1
> 
> e.g. for (2) we may even get a completely idle rq (schedule() -->
> schedule_balance_rt() will not help due to schedule_balance_rt()
> having a rt_task(prev) check in place... and 'prev' is of NORMAL type
> when it's scheduled out).

Indeed.  I think you are correct on both counts.  This is an oversight, so good eyes!

> 
> 
> btw., both cases would be addressed by placing load-balance points
> into sched_class_rt->{enqueue,dequeue}_task_rt()... push_rt_tasks()
> and pull_rt_tasks() respectively. As a side effect (I think,
> technically, it would be possible), 3 out of 4 *_balance_rt() calls
> (the exception: schedule_tail_balance_rt()) in schedule() would become
> unnecessary.
> 
> _BUT_
> 
> the enqueue/dequeue() interface would become less straightforward,
> logically-wise.
> Something like:
> 
> rq = activate_task(rq, ...) ; /* may unlock rq and lock/return another one 
> */
> 
> would complicate the existing use cases.
> 

I think I would prefer to just fix the setscheduler/setprio cases for the class transition than change the behavior of these enqueue/dequeue calls.  But I will keep an open mind as I look into this issue.

Thanks for the review!
-Greg



