Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbXENM41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbXENM41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 08:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbXENM4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 08:56:21 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44320 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbXENM4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 08:56:20 -0400
Date: Mon, 14 May 2007 18:34:12 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: efault@gmx.de, tingy@cs.umass.edu, wli@holomorphy.com,
       linux-kernel@vger.kernel.org
Subject: Re: fair clock use in CFS
Message-ID: <20070514130412.GA6103@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070514083358.GA29775@in.ibm.com> <20070514111051.GB23766@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514111051.GB23766@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 01:10:51PM +0200, Ingo Molnar wrote:
> but let me give you some more CFS design background:

Thanks for this excellent explanation. Things are much clearer now to
me. I just want to clarify one thing below:

> > 2. Preemption granularity - sysctl_sched_granularity

[snip]

> This granularity value does not depend on the number of tasks running. 

Hmm ..so does sysctl_sched_granularity represents granularity in
real/wall-clock time scale then? AFAICS that doesnt seem to be the case.

__check_preempt_curr_fair() compares for the distance between the two
task's (current and next-to-be-run task) fair_key values for deciding
preemption point.

Let's say that to begin with, at real time t0, both current task Tc and next 
task Tn's fair_key values are same, at value K. Tc will keep running until its 
fair_key value reaches atleast K + 2000000. The *real/wall-clock* time taken 
for Tc's fair_key value to reach K + 2000000 - is surely dependent on N,
the number of tasks on the queue (more the load, more slowly the fair
clock advances)?

This is what I meant by my earlier remark: "If there a million cpu hungry tasks,
then the (real/wall-clock) time taken to switch between two tasks is more 
compared to the case where just two cpu hungry tasks are running".

-- 
Regards,
vatsa
