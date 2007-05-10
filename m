Return-Path: <linux-kernel-owner+w=401wt.eu-S1760605AbXEJSz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605AbXEJSz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 14:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbXEJSzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 14:55:17 -0400
Received: from holomorphy.com ([66.93.40.71]:57435 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627AbXEJSzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 14:55:16 -0400
Date: Thu, 10 May 2007 11:55:22 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, tingy@cs.umass.edu, tong.n.li@intel.com,
       Davide Libenzi <davidel@xmailserver.org>
Subject: Re: Definition of fairness (was Re: [patch] CFS scheduler, -v11)
Message-ID: <20070510185522.GL19966@holomorphy.com>
References: <20070508150431.GA26977@elte.hu> <20070509180205.GA27462@in.ibm.com> <20070509202418.GE31925@holomorphy.com> <20070510171312.GB27462@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510171312.GB27462@in.ibm.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 01:24:18PM -0700, William Lee Irwin III wrote:
>> It's not even feasible much of the time. Suppose your task ran for
>> 100ms then slept for 900ms. It can't get more than 10% of the CPU in
>> any scheduler, work-conserving or not.

On Thu, May 10, 2007 at 10:43:12PM +0530, Srivatsa Vaddagiri wrote:
> sure. The question of fairnes arises when such a task has to "fight" for
> space/cputime in those 100ms, resulting in lesser than 10% bandwidth.
> Having some statistics shown on cpu demand vs obtained bandwidth may be
> good?

Davide Libenzi has a testcase which can essentially do this sort of
test involving sleep/wakeup behavior for you.


On Wed, May 09, 2007 at 01:24:18PM -0700, William Lee Irwin III wrote:
>> Fairness applies only to running tasks. The fair share of CPU must be
>> granted while the task is running. As for sleep, it has to use its
>> fair share of CPU or lose it. The numerous of pathologies that arise
>> from trying to credit tasks for sleep in this fashion this are why
>> fairness in the orthodox sense I describe is now such a high priority.
>> However, it is possible to credit tasks for sleep in other ways. For
>> instance, EEVDF (which is very close to CFS) has a deadline parameter
>> expressing latency in addition to one expressing bandwidth that could,
>> in principle, be used for the purpose of crediting sleeping tasks. It's
>> not clear to me whether trying to use it for such purposes would be
>> sound, or, for that matter, whether tasks should receive latency
>> credits for sleep as opposed to other sorts of behaviors even if
>> utilizing the latency parameter for credits and bonuses for various
>> sorts of behavior is sound.

On Thu, May 10, 2007 at 10:43:12PM +0530, Srivatsa Vaddagiri wrote:
> I guess fairness interval also matters, as Mike pointed out. Over
> shorter intervals, it may appear more fair to such sleeping tasks
> than over longer intervals.  Btw CFS seems to leave this fairness
> interval undefined (its dependent on N, number of tasks and
> sysctl_sched_granularity?).

Usually things appear fairer over longer than shorter intervals. One
could regard the rate of convergence as a sort of performance metric
for the fairness of a scheduler, provided it converges to fairness at
all.


On Thu, May 10, 2007 at 10:43:12PM +0530, Srivatsa Vaddagiri wrote:
> I suspect container/database/webserver workloads would like to receive
> such latency/bandwidth credits for sleep. Will check with our
> database/workload management folks on this.

Bear in mind that bandwidth credits have soundness issues. Crediting
bandwidth in exchange for sleep will certainly flunk ringtest.c

Crediting latency in exchange for sleep at least has different problems
if it has any at all. I actually expect it to be sound to credit
latency (the l_i in EEVDF) in exchange for sleep, but the experts have
yet to weigh in on the subject.


-- wli
