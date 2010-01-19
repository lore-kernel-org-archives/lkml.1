Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650Ab0ASIrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab0ASIrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601Ab0ASIrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:47:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:47829 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542Ab0ASIrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:47:06 -0500
Message-ID: <4B556D44.1060101@kernel.org>
Date: Tue, 19 Jan 2010 17:28:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 06/40] sched: add wakeup/sleep sched_notifiers and allow
 NULL notifier ops
References: <1263776272-382-1-git-send-email-tj@kernel.org>	 <1263776272-382-7-git-send-email-tj@kernel.org>	 <1263808633.4283.152.camel@laptop>  <4B5446A1.7070306@kernel.org> <1263818967.4283.459.camel@laptop> <4B55050B.5020600@kernel.org>
In-Reply-To: <4B55050B.5020600@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Jan 2010 08:46:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/19/2010 10:04 AM, Tejun Heo wrote:
>> I'm thinking that we can place it next to activate_task(), if it makes
>> you feel better you can place them both at the end up ttwu_activate()
>> instead of in the middle.
>>
>> Esp. with the callback you have it really doesn't matter.
> 
> Alright, if it's safe, there's no reason to keep it separate with an
> extra branch.  I'll move it.

Alright, was trying to convert it and I'm still a bit worried.  One of
the reasons I put it at the end of post_activation() is to allow
calling try_to_wake_up_local() from wakeup callback.  This won't be
used by cmwq right now but making it symmetrical to sleep callback
would be more consistent, so...  If we fire wakeup callback right
after activate_task() and allow try_to_wake_up_local() to be called
from it, wake up logic ends up being nested inside outer wake up which
is still in progress.  Would that be safe too?

Thanks.

-- 
tejun
