Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbYCLBXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbYCLBXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 21:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbYCLBXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 21:23:23 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51195 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbYCLBXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 21:23:22 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5249"; a="1049905"
Message-ID: <47D73086.2030008@qualcomm.com>
Date: Tue, 11 Mar 2008 18:23:18 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: boot cgroup questions
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

Concept of 'boot' cgroup was discussed as part of the cpuset/cpuisol lkml threads.
In short 'boot' group is very much like the 'root' or toplevel group. ie It
contains all tasks, and 'boot' cpuset contains all cpus, mem nodes, irqs, etc.
The difference is that it can be easily shrunk if needed, where as
toplevel/root group cannot.

I just wanted to make sure that we still want to create 'boot' cgroup during
kernel init instead of doing it in the user-space.

After looking into this a little bit I'm thinking of creating 'boot' cgroup
right after cpuset_init_smp() (init/main.c:841). Just before do_basic_setup()
which creates work queues and stuff.

The thing is though that the very next thing we do there is run early
userspace. Which begs the question, shouldn't we just do it from early
user-space then ?
It'd be very simple to mount cgroup, create 'boot' group and move all the
tasks in there.

So kernel or early-userspace ?

If kernel.
Paul M, do you have a suggestion as to what's the best way of creating a
cgroup without mounting cgroup fs. Seems like there is currently no easy way
for doing that. I probably missed it.

Thanx
Max



