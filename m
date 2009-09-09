Return-Path: <linux-kernel-owner+w=401wt.eu-S1753007AbZIINvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbZIINvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 09:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZIINvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 09:51:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbZIINvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 09:51:37 -0400
Date: Wed, 9 Sep 2009 15:46:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, rjw@sisk.pl, laijs@cn.fujitsu.com,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] sched: fix cpu_down deadlock
Message-ID: <20090909134557.GA21616@redhat.com>
References: <4AA0FEBF.7040104@gmail.com> <1252496510-11898-1-git-send-email-jirislaby@gmail.com> <1252497225.7235.3.camel@laptop> <4AA79E4F.7010900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA79E4F.7010900@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09, Jiri Slaby wrote:
>
> On 09/09/2009 01:53 PM, Peter Zijlstra wrote:
> > On Wed, 2009-09-09 at 13:41 +0200, Jiri Slaby wrote:
> >> Jiri Slaby wrote:
> >>> Thanks, in the end I found it manually. Goddammit! It's an -mm thing:
> >>> cpu_hotplug-dont-affect-current-tasks-affinity.patch
> >
> > Is there a git tree with -mm in some place? I can't seem to find that
> > patch in my inbox.
> >
> > All I can find is some comments from Oleg that the patch looks funny.
>
> Yes, here:
> git://git.zen-sources.org/zen/mmotm.git
>
> Actually I found Oleg came up with better solution to add
> move_task_off_dead_cpu to take_cpu_down.
>
> A discussion regarding this is at:
> http://lkml.indiana.edu/hypermail/linux/kernel/0907.3/02278.html
>
> So what's the status of the patches, please?

This patch depends on another one, please see

	"[PATCH] cpusets: rework guarantee_online_cpus() to fix deadlock with cpu_down()"
	http://marc.info/?t=124910242400002

	(as the changelog says, the patch is not complete: we need
	 ->cpumask_lock every time we update cs->allowed, but this
	 should be trivial)

In short: cpuset_lock() is buggy. But more importantly it is afaics unneeded,
and imho should die. I seem to answer all Lai's questions, but the patch was
ignored by maintainers.

I noticed another race in update_cpumask() which I was going to fix, but since
maintainers ignore me I lost the motivtion ;) Besides, currently I dont have
the time anyway.

So I think the original patch which creates the kthread is the best option.

Oleg.

