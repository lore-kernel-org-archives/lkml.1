Return-Path: <linux-kernel-owner+w=401wt.eu-S1763776AbYDUQgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763776AbYDUQgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbYDUQfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:35:54 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:6035 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbYDUQfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:35:54 -0400
Message-Id: <480C8A44.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Mon, 21 Apr 2008 10:36:20 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>
Cc: <chinang.ma@intel.com>, <suresh.b.siddha@intel.com>,
       <arjan@linux.intel.com>, <willy@linux.intel.com>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH v2] sched: push rt tasks only if newly activated
	taskshave been added
References: <20080421153438.9212.79406.stgit@novell1.haskins.net>
 <20080421161744.GB10121@elte.hu> <20080421162032.GA12645@elte.hu>
 <Pine.LNX.4.58.0804211224380.18530@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0804211224380.18530@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Mon, Apr 21, 2008 at 12:25 PM, in message
<Pine.LNX.4.58.0804211224380.18530@gandalf.stny.rr.com>, Steven Rostedt
<rostedt@goodmis.org> wrote: 


> 
> I'm betting that this needs a CONFIG_SMP around it.

Indeed, thanks!  Will send update against sched-devel with this fix.


> 
> -- Steve
> 
>>  	inc_cpu_load(rq, p->se.load.weight);
>>  }
>>
>> @@ -913,7 +920,7 @@ static int push_rt_task(struct rq *rq)
>>  	int ret = 0;
>>  	int paranoid = RT_MAX_TRIES;
>>
>> -	if (!rq->rt.overloaded)
>> +	if (!rq->rt.overloaded || rq->rt.pushed)
>>  		return 0;
>>
>>  	next_task = pick_next_highest_task_rt(rq, -1);
>> @@ -973,6 +980,15 @@ out:
>>  }
>>
>>  /*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



