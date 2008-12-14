Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbYLNRGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbYLNRGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 12:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbYLNRGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 12:06:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62333 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbYLNRGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 12:06:36 -0500
Date: Sun, 14 Dec 2008 12:06:35 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <clark.williams@gmail.com>
Subject: Re: [PATCH] rt/workqueue: fix an early crash and some warnings
In-Reply-To: <49444A44.3030206@gmail.com>
Message-ID: <alpine.DEB.1.10.0812141206100.20467@gandalf.stny.rr.com>
References: <49444A44.3030206@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 14 Dec 2008, Frederic Weisbecker wrote:

> Impact: fix early crash and build warnings
> 
> While building the broken/rt/workqueue topic, I got various warnings:
> 
> kernel/workqueue.c: In function ?delayed_work_timer_fn?:
> kernel/workqueue.c:214: attention : passing argument 3 of ?__queue_work? makes integer from pointer without a cast
> 
> This one is the cause of an early crash: the adress of the priority is passed instead of its
> value, hence the following BUG_ON() triggering on sched.c:rt_mutex_setprio()
> 
> BUG_ON(prio < 0 || prio > MAX_PRIO)
> 
> Various warnings are displayed because of confusion between common linked-list and priority
> sorted linked-list:
> 
> kernel/workqueue.c: In function ?flush_work?:
> kernel/workqueue.c:527: attention : passing argument 1 of ?list_empty? from incompatible pointer type
> kernel/workqueue.c:535: attention : assignment from incompatible pointer type
> kernel/workqueue.c:539: attention : assignment from incompatible pointer type
> 
> This patch fixes them (hopefully correctly).
> 
> broken/rt/workqueue boots correctly now.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks! I'll give this a try on Monday.

-- Steve

