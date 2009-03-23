Return-Path: <linux-kernel-owner+w=401wt.eu-S1760554AbZCWTWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554AbZCWTWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759973AbZCWTV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:21:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58405 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759863AbZCWTV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:21:57 -0400
Date: Mon, 23 Mar 2009 15:21:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/filters] tracing/events: don't use wake up for
 events
In-Reply-To: <tip-07edf7121374609709ef1b0889f6e7b8d6a62ec1@git.kernel.org>
Message-ID: <alpine.DEB.2.00.0903231520330.3578@gandalf.stny.rr.com>
References: <1237759847-21025-4-git-send-email-fweisbec@gmail.com> <tip-07edf7121374609709ef1b0889f6e7b8d6a62ec1@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 23 Mar 2009, Frederic Weisbecker wrote:
> tracing/events: don't use wake up for events
> 
> Impact: fix hard-lockup with sched switch events
> 
> Some ftrace events, such as sched wakeup, can be traced
> while the runqueue lock is hold. Since they are using
> trace_current_buffer_unlock_commit(), they call wake_up()
> which can try to grab the runqueue lock too, resulting in
> a deadlock.
> 
> Now for all event, we call a new helper:
> trace_nowake_buffer_unlock_commit() which do pretty the same than

Ug, that's an ugly name. It should at least be:

  trace_buffer_unlock_commit_nowake

to be more in line with kernel conventions. That is where the derivitive
has the same name as the original, like preempt_enable_noresched.

-- Steve

> trace_current_buffer_unlock_commit() except than it doesn't call
> trace_wake_up().
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> LKML-Reference: <1237759847-21025-4-git-send-email-fweisbec@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
