Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbYKZAj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbYKZAj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 19:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYKZAjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 19:39:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55770 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbYKZAjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 19:39:48 -0500
Date: Wed, 26 Nov 2008 01:39:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-return-tracer: set a more human
	readable output
Message-ID: <20081126003936.GA26937@elte.hu>
References: <492C90E5.8070907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492C90E5.8070907@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Here is an example of trace:
> 
> sys_read() {
>   fget_light() {
>   } 526
>   vfs_read() {
>     rw_verify_area() {
>       security_file_permission() {
>         cap_file_permission() {
>         } 519
>       } 1564
>     } 2640
>     do_sync_read() {
>       pipe_read() {
>         __might_sleep() {
>         } 511
>         pipe_wait() {
>           prepare_to_wait() {
>           } 760
>           deactivate_task() {
>             dequeue_task() {
>               dequeue_task_fair() {
>                 dequeue_entity() {
>                   update_curr() {
>                     update_min_vruntime() {
>                     } 504
>                   } 1587
>                   clear_buddies() {
>                   } 512
>                   add_cfs_task_weight() {
>                   } 519
>                   update_min_vruntime() {
>                   } 511
>                 } 5602
>                 dequeue_entity() {
>                   update_curr() {
>                     update_min_vruntime() {
>                     } 496
>                   } 1631
>                   clear_buddies() {
>                   } 496
>                   update_min_vruntime() {
>                   } 527
>                 } 4580
>                 hrtick_update() {
>                   hrtick_start_fair() {
>                   } 488
>                 } 1489
>               } 13700
>             } 14949
>           } 16016
>           msecs_to_jiffies() {
>           } 496
>           put_prev_task_fair() {
>           } 504
>           pick_next_task_fair() {
>           } 489
>           pick_next_task_rt() {
>           } 496
>           pick_next_task_fair() {
>           } 489
>           pick_next_task_idle() {
>           } 489
> 
> ------------8<---------- thread 4 ------------8<----------

Wow, very nice output! :-)

I've applied them, will comment and test on them as well.

	Ingo
