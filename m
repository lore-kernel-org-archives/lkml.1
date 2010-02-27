Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968188Ab0B0Mdk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 07:33:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44368 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968159Ab0B0Mdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 07:33:39 -0500
Subject: Re: [PATCH 0/3] sched: use EDF to throttle RT task groups v2
From: Peter Zijlstra <peterz@infradead.org>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Turner <pjt@google.com>,
       Dario Faggioli <faggioli@gandalf.sssup.it>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Dhaval Giani <dhaval@retis.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>, linux-kernel@vger.kernel.org
In-Reply-To: <cover.1266931410.git.fabio@helm.retis>
References: <cover.1266931410.git.fabio@helm.retis>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Feb 2010 13:33:11 +0100
Message-ID: <1267273991.22519.744.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-23 at 19:56 +0100, Fabio Checconi wrote:
>   - Since it is not easy to mix tasks and groups on the same scheduler
>     queue (tasks have no deadlines), the bandwidth reserved to the tasks
>     in a group is controlled with two additional cgroup attributes:
>     rt_task_runtime_us and rt_task_period_us.  These attributes control,
>     within a cgroup, how much bandwidth is reserved to the tasks it
>     contains.  The old attributes, rt_runtime_us and rt_period_us, are
>     still there, and control the bandwidth assigned to the cgroup.  They
>     are used only for admission control. 

We could do this implicitly by simply setting the task_bandwidth to the
cgroup bandwidth - \Sum_children bandwidth.

Having it explicit gives the administrator slightly more control at the
cost of a more complex interface.

Just wondering if you thought about this trade-off?

