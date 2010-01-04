Return-Path: <linux-kernel-owner+w=401wt.eu-S1752033Ab0ADMCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab0ADMCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 07:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694Ab0ADMCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 07:02:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab0ADMCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 07:02:52 -0500
Message-ID: <4B41D8E5.1000908@suse.de>
Date: Mon, 04 Jan 2010 17:32:45 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-12.1 Thunderbird/3.0
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] sched: avoid huge bonus to sleepers on busy machines
References: <1262596842-17392-1-git-send-email-sjayaraman@suse.de> <1262603675.9734.36.camel@marge.simson.net>
In-Reply-To: <1262603675.9734.36.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2010 04:44 PM, Mike Galbraith wrote:
> On Mon, 2010-01-04 at 14:50 +0530, Suresh Jayaraman wrote:
>> As I understand the idea of sleeper fairness is to consider sleeping tasks
>> similar to the ones on the runqueue and credit the sleepers in a way that it
>> would get CPU as if it were running.
>>
>> Currently, when fair sleepers are enabled, the task that was sleeping seem to
>> get a bonus of cfs_rq->min_vruntime - sched_latency (in most cases). While with
>> gentle fair sleepers this effect was reduced to half, there still remains a
>> chance that on busy machines with more number of tasks, the sleepers might get
>> a huge undue bonus.
> 
> There is no bonus.  Sleepers simply get to keep some of their lag, but
> any lag beyond sched_latency is trashed in the interest of reasonable
> latency for non-sleepers as the sleeper preempts and tries to catch up.
> 

Sorry, perhaps it's not a bonus, but it seems that the credit to
sleepers due to their lag (when it was sleeping) doesn't appear to take
in to account the number of tasks in the run_queue currently. IOW, the
credit to sleepers is same irrespective of the number of current tasks.
This might mean sleepers are getting an edge (since this will slow down
current tasks) when the number of tasks is more, isn't?

Would it be a good idea to make the threshold dependent on number of
tasks? This can help us achieve sleeper fairness with respect to the
current context and not relevant to when the task went to sleep, I think.

Does this make sense?

Thanks,

-- 
Suresh Jayaraman
