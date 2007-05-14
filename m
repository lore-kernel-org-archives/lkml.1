Return-Path: <linux-kernel-owner+w=401wt.eu-S1761934AbXENI0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761934AbXENI0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 04:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbXENI0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 04:26:00 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56846 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397AbXENIZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 04:25:59 -0400
Date: Mon, 14 May 2007 14:03:58 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, efault@gmx.de
Cc: tingy@cs.umass.edu, wli@holomorphy.com, linux-kernel@vger.kernel.org
Subject: fair clock use in CFS
Message-ID: <20070514083358.GA29775@in.ibm.com>
Reply-To: vatsa@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	I have been brooding over how fair clock is computed/used in
CFS and thought I would ask the experts to avoid wrong guesses!

As I understand, fair_clock is a monotonously increasing clock which
advances at a pace inversely proportional to the load on the runqueue.
If load = 1 (task), it will advance at same pace as wall clock, as 
load increases it advances slower than wall clock.

In addition, following calculations depend on fair clock: task's wait
time on runqueue and sleep time outside the runqueue (both reflected in
p->wait_run_time).

Few questions that come up are:

1. Why can't fair clock be same as wall clock at all times? i.e fair
   clock progresses at same pace as wall clock independent of the load on
   the runqueue.

   It would still give the ability to measure time spent waiting on runqueue 
   or sleeping and use that calculated time to give latency/bandwidth
   credit? 

   In case of EEVDF, the use of virtual clock seems more
   understandable, if we consider the fact that each client gets 'wi' real
   time units in 1 virtual time unit. That doesnt seem to be the case in
   CFS as Ting Yang explained +/- lags here 
   http://lkml.org/lkml/2007/5/2/612 ..


2. Preemption granularity - sysctl_sched_granularity

	This seems to be measured in the fair clock scale rather than
	wall clock scale. As a consequence of this, the time taken
	for a task to relinquish to competetion is dependent on number N
	of tasks? For ex: if there a million cpu hungry tasks, then the
	time taken to switch between two tasks is more compared to the
	case where just two cpu hungry tasks are running. Is there
	any advantage of using fair clock scale to detect preemtion points?


-- 
Regards,
vatsa
