Return-Path: <linux-kernel-owner+w=401wt.eu-S1765658AbXGYPSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765658AbXGYPSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 11:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757594AbXGYPSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 11:18:33 -0400
Received: from wudika.de ([213.239.211.247]:40441 "EHLO wudika.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001AbXGYPSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 11:18:32 -0400
Message-ID: <46A769C2.6030701@felicis.org>
Date: Wed, 25 Jul 2007 17:18:26 +0200
From: Martin Roehricht <ml@felicis.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mingo@elte.hu
Subject: Re: highest and lowest priority job of a runqueue
References: <8KLFD-G9-5@gated-at.bofh.it>
In-Reply-To: <8KLFD-G9-5@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2007 11:50 AM, Martin Roehricht wrote:
> I thought I might use (given a list with tmp pointers to all CPUs)
> 	rq = cpu_rq(tmp->cpu);
> 	task_load = rq->curr->load_weight;
> but this always returns 128 regardless of the fact if a task currently
> runs on that CPU or not. I guess it returns the load of the migration
> thread, but I'm not sure. I would like to migrate specific tasks
> throughout find_busiest_group().

Okay, I think I found that my assumption should be just fine and I had 
trouble with some debugging output via the show_schedstat() function.
The "rq->curr->load_weight" returns what it is supposed to return. :-)

I am still uncertain on how to resolve the specific highest or lowest 
priority job:
> I was wondering how I may retrieve
> (a) the priority/load of the highest and the lowest priority task of a
>     runqueue (in a multiprocessor system), and
> (b) the corresponding pointer to this task?

I will try something of the form (pseudocode like):

int idx;
struct list_head *head;
struct task_struct *task;

idx = sched_find_first_bit(rq->active->bitmap);
head = array->queue + idx;
task = list_entry(head, struct task_struct, run_list);

For the lowest priority task a function like "sched_find_last_bit()" 
might be useful.
Would this be a good way to succeed?

> Furthermore, is it correct, that the current migration strategy
> (move_tasks()) chooses automatically the highest priority task?

Thanks,
Martin
