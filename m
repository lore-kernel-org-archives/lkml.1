Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbXLKDPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbXLKDPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 22:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbXLKDPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 22:15:43 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:50890 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbXLKDPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 22:15:43 -0500
Message-Id: <20071211030033.632581735@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 10 Dec 2007 22:00:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>, vatsa@linux.vnet.ibm.com,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/4 v2] RT balance updates against sched-devel
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Sorry if this is a repost, but I had a problem with quilt mail, and 
 I don't know if my original post made it out. Unfortunately, I didn't
 save the original "prolog" file, and so this has to be rewritten
 from scratch, and I don't even remember the original subject :-/ ]


This patch series goes against Ingo's sched-devel git tree.

The first patch addresses Ingo's concerns about having hooks in the main
sched.c and replaces them with generic methods that any class may use.
The methods are: pre_schedule, post_schedule and task_wake_up; which
is called before the schedule, after a context switch and when a task
wakes up respectively. The are surrounded by ifdef CONFIG_SMP since they
are currently only used by sched_rt in SMP mode. But if this appears to
be applicable to other sched_classes in UP, then I can rerun this series
without the ifdefs.

The second patch addresses the concerns that Dmitry brought up showing that
the current RT balancing neglected to handle changes in prio and
classes from sched_setscheduler and rt_mutex_setprio. The added methods
are: switched_to, switched_from and prio_changed; these are called in
the when a task is assigned a new sched_class, after it leaves
a sched_class, and when it changes its prio respectively.

The last two patches are from Gregory Haskins where he cleaned up left
over changes that were from previous versions of the balancing code.

-- Steve

