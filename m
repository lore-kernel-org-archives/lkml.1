Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab0CAPMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:12:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:53064 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab0CAPMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:12:22 -0500
Message-ID: <4B8BD934.4050908@kernel.org>
Date: Tue, 02 Mar 2010 00:11:48 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-3.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 10/43] stop_machine: reimplement without using workqueue
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-11-git-send-email-tj@kernel.org> <20100228143405.GA13236@redhat.com>
In-Reply-To: <20100228143405.GA13236@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 15:08:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On 02/28/2010 11:34 PM, Oleg Nesterov wrote:
> On 02/26, Tejun Heo wrote:
>>
>> @@ -164,19 +259,18 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
>>  	idle.fn = chill;
>>  	idle.data = NULL;
>>
>> +	smp_wmb();			/* -> stop_cpu()::set_current_state() */
>> ...
>> +	for_each_online_cpu(i)
>> +		wake_up_process(*per_cpu_ptr(stop_machine_threads, i));
> 
> Afaics, this smp_wmb() is not needed, wake_up_process() (try_to_wake_up)
> should ensure we can't race with set_current_state() + check_condition.
> It does, note the wmb() in try_to_wake_up().

Yeap, the initial version was like that and it was awkward to explain
in the comment in stop_cpu() so I basically put it there as a
documentation anchor.  Do you think removing it would be better?

Thanks.

-- 
tejun
