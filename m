Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbZJAJPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbZJAJPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 05:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755938AbZJAJP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 05:15:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949AbZJAJP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 05:15:29 -0400
Message-ID: <4AC4725E.3070509@redhat.com>
Date: Thu, 01 Oct 2009 11:11:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       jeff@garzik.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [RFC PATCHSET] workqueue: implement concurrency managed	workqueue
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <20091001084040.GA15345@elte.hu>
In-Reply-To: <20091001084040.GA15345@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2009 10:40 AM, Ingo Molnar wrote:
> Ok, this looks fairly interesting - and the way you reused scheduler
> classes to auto-regulate with no impact on regular performance is quite
> an ingenious idea as well. (KVM's preempt notifiers should probably use
> this trick too, instead of an ugly notifier in the scheduler hotpath)
>
> This mechanism could be used to implement threadlets/syslets too btw.,
> and other forms of asynchronous IO.
>    

In fact I've thought of implementing threadlets and concurrency-managed 
workqueues with preempt notifiers ;)

Isn't a scheduling class overkill for two existing callbacks?  Note we 
can easily use a thread flag and __switch_to_xtra() to avoid the overhead.

For kvm, we don't want to force a specific scheduling class for vcpu 
threads, so we'd need infrastructure to create a new scheduling class 
out of an existing one to hook the two callbacks.  Seems like quite a 
lot of work, for something that is orthogonal to scheduling.

Tejun, would preempt notifiers work for your workqueues?  see bottom of 
include/linux/preempt.h.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

