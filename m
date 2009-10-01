Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbZJARIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbZJARIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 13:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZJARIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 13:08:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbZJARIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 13:08:24 -0400
Message-ID: <4AC4E195.8020307@redhat.com>
Date: Thu, 01 Oct 2009 19:06:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       jeff@garzik.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [RFC PATCHSET] workqueue: implement concurrency managed	workqueue
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <20091001084040.GA15345@elte.hu> <4AC4725E.3070509@redhat.com> <4AC4DF07.2090202@kernel.org>
In-Reply-To: <4AC4DF07.2090202@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2009 06:55 PM, Tejun Heo wrote:
>> For kvm, we don't want to force a specific scheduling class for vcpu
>> threads, so we'd need infrastructure to create a new scheduling class
>> out of an existing one to hook the two callbacks.  Seems like quite a
>> lot of work, for something that is orthogonal to scheduling.
>>
>> Tejun, would preempt notifiers work for your workqueues?  see bottom of
>> include/linux/preempt.h.
>>      
> I considered that but the thing is workqueue needs to know when a
> thread wakes up not when it gets scheduled.  Of course we can add
> another notifier op and call it from try_to_wake_up() but I really
> didn't want to add yet another hook in a very hot path which will only
> be useful for very small number of tasks but yet has to be called for
> every operation and the sched_class mechanism means that we already
> have hooks at all the interesting spots, so I think it's better to
> make use of them instead of adding another set of callbacks.
>    

Right, it's a subtle difference that makes p_n unusable for you.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

