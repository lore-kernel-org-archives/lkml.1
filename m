Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbYCEPZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbYCEPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 10:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYCEPZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 10:25:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35773 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbYCEPZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:25:15 -0500
Date: Wed, 5 Mar 2008 16:24:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] balance RT task resched only on runqueue
Message-ID: <20080305152450.GA19300@elte.hu>
References: <1204728101.5241.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204728101.5241.12.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> In the RT kernel we discovered a place that can reschedule a task 
> without holding the tasks runqueue lock.  This was caused by the RT 
> balancing code that pulls RT tasks to the current run queue and will 
> reschedule the current task.
> 
> There's a slight chance that the pulling of the RT tasks will release 
> the current runqueue's lock and retake it (in the 
> double_lock_balance). During this time that the runqueue is released, 
> the current task can migrate to another runqueue.
> 
> In the prio_changed_rt code, after the pull, if the current task is of 
> lesser priority than one of the RT tasks pulled, resched_task is 
> called on the current task. If the current task had migrated in that 
> small window, resched_task will be called without holding the runqueue 
> lock for the runqueue that the task is on.
> 
> This race condition also exists in the mainline kernel and this patch 
> adds a check to make sure the task hasn't migrated before calling 
> resched_task.

thanks Steve, applied.

	Ingo
