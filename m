Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbXIUDrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbXIUDrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 23:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbXIUDrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 23:47:01 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:53492 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbXIUDrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 23:47:01 -0400
Date: Thu, 20 Sep 2007 23:46:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Chris Rigg <cdrigg@comcast.net>
Cc: Ingo Molnar <mingo@elte.hu>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org
Subject: Re: MAX_RT_PRIO - 1 Highest prio?
Message-ID: <20070921034648.GA15171@goodmis.org>
References: <46EEE498.1080500@comcast.net> <20070918050043.GE10199@1wt.eu> <20070918062606.GA5138@elte.hu> <46F1AEBB.6000809@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F1AEBB.6000809@comcast.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 05:20:27PM -0600, Chris Rigg wrote:
> Hello,

Hi Chris,

>
> First, I'm assuming that if I want my task to have the HIGHEST priority in 
> the system (i.e. preempt any other task whenever it is put into the ready 
> queue (assuming I have preemption turned on/configured)), I use 
> sched_setscheduler (...) and use the sched_priority in sched_param for 
> MAX_RT_PRIO -1. Is this correct?

Actually it's probably best to use sched_get_priority_max for the max
prio.

>
> Second, assuming that MAX_RT_PRIO-1 is the highest, would it be bad on an 
> SMP/Hyperthreading system (that's using the migration thread balancing in 
> 2.6.20.7) to set a task's priority to MAX_RT_PRIO -1 given the fact that 
> the migration threads are already set to MAX_RT_PRIO -1? Should I be 
> setting my task's prio to MAX_RT_PRIO-2 to not interfere with the load 
> balancing?

The migrate task of a given CPU isn't the only one that will take
tasks off its CPU to push them to others (although it does do that).
But there's other load balancing work going on in the scheduler
(looking at the 2.6.20 sched.c).

Although it would be interesting to see what the result would be if you
had N+1 tasks running on N CPUs all doing busy loops, and make one of
the tasks with the prio of MAX_RT_PRIO-1, and see if we have one task
that is starved and never schedules. But I'm sure this should be fixed
(if it was ever broken) with the latest scheduling work that's being
done in the most recent kernels.

-- Steve

