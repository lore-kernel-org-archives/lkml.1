Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbZKQQXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbZKQQXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:23:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZKQQXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:23:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:54297 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbZKQQXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:23:04 -0500
Message-ID: <4B02CD9D.80402@kernel.org>
Date: Wed, 18 Nov 2009 01:21:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, jens.axboe@oracle.com,
       rusty@rustcorp.com.au, cl@linux-foundation.org, dhowells@redhat.com,
       arjan@linux.intel.com, torvalds@linux-foundation.org, avi@redhat.com,
       peterz@infradead.org, andi@firstfloor.org, fweisbec@gmail.com
Subject: Re: [PATCH 17/21] workqueue: simple reimplementation of SINGLE_THREAD
 workqueue
References: <1258391726-30264-1-git-send-email-tj@kernel.org>	 <1258391726-30264-18-git-send-email-tj@kernel.org>	 <1258418872.4096.28.camel@palomino.walls.org>  <4B023340.90004@kernel.org> <1258459525.3214.17.camel@palomino.walls.org>
In-Reply-To: <1258459525.3214.17.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/17/2009 09:05 PM, Andy Walls wrote:
>>   Implementing strict ordering
>> shouldn't be too difficult but I can't help but feeling that such
>> assumption is abuse of implementation detail.
> 
> Hmmm, does not the "queue" in workqueue mean "FIFO"?

I don't think it necessarily means strict execution ordering.

> If not for strict ordering, why else would a driver absolutely need a
> singlethreaded workqueue object?  It seems to me the strict ording is
> the driving requirement for a singlethreaded workqueue at all.  Your
> patch series indicates to me that the performance and synchronization
> use cases are not driving requirements for a singlethreaded workqueue.

I still think the biggest reason why single threaded workqueue is used
is just to reduce the number of threads hanging around.  I tried to
audit single thread users some time ago.  My impression was that many
of single thread work users did synchronization itself anyway while
smaller portion depended on single threadedness.  I didn't notice the
strict ordering requirement but then again I wasn't looking for them.
It seems there are at least two cases depending on FIFO behavior, so
let's see if we can retain the behavior for single threaded
workqueues (maybe it should be renamed to ORDERED?).

Thanks.

-- 
tejun
