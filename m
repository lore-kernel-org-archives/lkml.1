Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbXJIEVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbXJIEVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 00:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbXJIEV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 00:21:29 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:53503 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbXJIEV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 00:21:28 -0400
Subject: Re: [PATCH RT] fix rt-task scheduling issue
From: Gregory Haskins <ghaskins@novell.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Kravetz <kravetz@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20071009024621.GA12915@goodmis.org>
References: <20071006021548.GE4587@monkey.ibm.com>
	 <20071009024621.GA12915@goodmis.org>
Content-Type: text/plain
Date: Tue, 09 Oct 2007 00:18:53 -0400
Message-Id: <1191903533.4281.51.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,
  Nice find!  Comment inline..

(adding linux-rt-users)

 for reference to

 http://lkml.org/lkml/2007/10/8/252

On Mon, 2007-10-08 at 22:46 -0400, Steven Rostedt wrote:
> Index: linux-2.6.23-rc9-rt2/kernel/sched.c
> ===================================================================
> --- linux-2.6.23-rc9-rt2.orig/kernel/sched.c
> +++ linux-2.6.23-rc9-rt2/kernel/sched.c
> @@ -2207,7 +2207,7 @@ static inline void finish_task_switch(st
>  	 * If we pushed an RT task off the runqueue,
>  	 * then kick other CPUs, they might run it:
>  	 */
> -	if (unlikely(rt_task(current) && prev->se.on_rq && rt_task(prev))) {
> +	if (unlikely(rt_task(current) && rq->rt_nr_running > 1)) {
>  		schedstat_inc(rq, rto_schedule);
>  		smp_send_reschedule_allbutself_cpumask(current->cpus_allowed);

the current->cpus_allowed I think probably should have been
"prev->cpus_allowed" in the original code?  However, in light of the new
findings with this bug Mike found, this should probably be sent to
allbutself() without the mask since you don't know what could have been
queued behind you.

Unless I am missing something?

Regards,
-Greg


