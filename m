Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbZKQQ0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbZKQQ0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZKQQ0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:26:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:54384 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbZKQQ0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:26:16 -0500
Message-ID: <4B02CE28.1070209@kernel.org>
Date: Wed, 18 Nov 2009 01:24:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, peterz@infradead.org,
       andi@firstfloor.org, fweisbec@gmail.com
Subject: Re: [PATCH 17/21] workqueue: simple reimplementation of SINGLE_THREAD
 workqueue
References: <1258391726-30264-1-git-send-email-tj@kernel.org>	 <1258391726-30264-18-git-send-email-tj@kernel.org> <1258466597.3682.11.camel@johannes.local>
In-Reply-To: <1258466597.3682.11.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/17/2009 11:03 PM, Johannes Berg wrote:
> On Tue, 2009-11-17 at 02:15 +0900, Tejun Heo wrote:
>> SINGLE_THREAD workqueues are used to reduce the number of worker
>> threads and ease synchronization.
> 
> Wireless (mac80211) also requires that the order in which different work
> structs are queued up is identical to the processing order. At least
> some code was written with that assumption in mind, and I think it's
> actually required in a few places.

Thanks for pointing it out.

> Also, that unlikely() here:
> 
>> +	if (unlikely(single_thread)) {
>> +		mutex_lock(&wq->single_thread_mutex);
>> +		f(work);
>> +		mutex_unlock(&wq->single_thread_mutex);
>> +	} else
>> +		f(work);
> 
> seems wrong, there are many single-threaded workqueues after all.

Well, most single threaded users which chose single threaded queue to
reduce the number of threads won't need to, so I'm expecting the
number of single threaded users to drop.  I'll probably drop the
unlikely on the next round.

Thanks.

-- 
tejun
