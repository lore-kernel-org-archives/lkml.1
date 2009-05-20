Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbZETKcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbZETKcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbZETKcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:32:32 -0400
Received: from www.tglx.de ([62.245.132.106]:50960 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757265AbZETKcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:32:31 -0400
Date: Wed, 20 May 2009 12:31:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Anton Blanchard <anton@samba.org>
cc: rostedt@goodmis.org, mingo@elte.hu, tzanussi@gmail.com, jbaron@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/events: Add timer and high res timer
 tracepoints
In-Reply-To: <20090520101334.GA23442@kryten>
Message-ID: <alpine.LFD.2.00.0905201229280.5983@localhost.localdomain>
References: <20090520101334.GA23442@kryten>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009, Anton Blanchard wrote:
> 
> Add tracepoints for timer and high res timer execution. We add entry and
> exit tracepoints so we can calculate timer latency.
> 
> Example ftrace output:
> 
> <idle>-0     [000]   264.040506: hrtimer_entry: func=.tick_sched_timer+0x0/0xf0
> <idle>-0     [000]   264.040508: hrtimer_exit: func=.tick_sched_timer+0x0/0xf0 restart=HRTIMER_RESTART
> <idle>-0     [000]   264.040530: timer_entry: func=.e1000_watchdog+0x0/0x8fc
> <idle>-0     [000]   264.040728: timer_exit: func=.e1000_watchdog+0x0/0x8fc
> 
> Here we can see e1000_watchdog is taking 0.2ms - it might make sense to
> move this into a workqueue or kernel thread.

Cute. That should help us to pinpoint more such timer abusers :)

> Signed-off-by: Anton Blanchard <anton@samba.org>

Acked-by: Thomas Gleixner <tglx@linutronix.de>
