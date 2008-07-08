Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbYGHMp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbYGHMp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757795AbYGHMor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:44:47 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:44206 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758608AbYGHMon convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:44:43 -0400
Message-Id: <48732751.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 08 Jul 2008 06:37:37 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Cc: <mingo@elte.hu>, <rostedt@goodmis.org>, <peterz@infradead.org>,
       <npiggin@suse.de>, <linux-kernel@vger.kernel.org>,
       <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched: terminate newidle balancing once at
	least one task has moved over
References: <20080627202444.3829.21595.stgit@lsg.lsg.lab.novell.com>
 <20080627202955.3829.78937.stgit@lsg.lsg.lab.novell.com>
 <200807081500.18245.nickpiggin@yahoo.com.au>
In-Reply-To: <200807081500.18245.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Jul 8, 2008 at  1:00 AM, in message
<200807081500.18245.nickpiggin@yahoo.com.au>, Nick Piggin
<nickpiggin@yahoo.com.au> wrote: 
> On Saturday 28 June 2008 06:29, Gregory Haskins wrote:
>> Inspired by Peter Zijlstra.
>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> 
> What happened to the feedback I sent about this?
> 
> It is still nack from me.

Ah yes.  Slipped through the cracks...sorry about that.

What if we did "if (idle == CPU_NEWLY_IDLE && need_resched())" instead?

-Greg

> 
> 
>> ---
>>
>>  kernel/sched.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 56722b1..0b9f90e 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -2863,6 +2863,10 @@ static int move_tasks(struct rq *this_rq, int
>> this_cpu, struct rq *busiest, max_load_move - total_load_moved,
>>  				sd, idle, all_pinned, &this_best_prio);
>>  		class = class->next;
>> +
>> +		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
>> +			break;
>> +
>>  	} while (class && max_load_move > total_load_moved);
>>
>>  	return total_load_moved > 0;
>>
>> --



