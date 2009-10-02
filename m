Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZJBMXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZJBMXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 08:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755720AbZJBMXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 08:23:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:54926 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722AbZJBMXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 08:23:40 -0400
Message-ID: <4AC5F0AD.2080904@kernel.org>
Date: Fri, 02 Oct 2009 21:23:09 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH 03/19] scheduler: implement workqueue scheduler class
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-4-git-send-email-tj@kernel.org> <alpine.LFD.2.01.0910010953010.6996@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910010953010.6996@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 02 Oct 2009 12:23:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Linus Torvalds wrote:
> On Thu, 1 Oct 2009, Tejun Heo wrote:
>> Implement workqueue scheduler class.  Workqueue sched_class inherits
>> fair sched_class and behaves exactly the same as sched_class except
>> that it has two callback functions which get called when a task is put
>> to sleep and wakes up and doesn't allow switching to different
>> scheduler class.
> 
> So this looks odd to me.
> 
> I agree completely with the callback functions, but what I don't agree 
> with is that this is somehow workqueue-related. I bet that others could 
> use this, and in fact, I suspect that it should not be tied to the 
> scheduler class at all, but to the _thread_.
> 
> Just as an example, I could imagine that we would do lock_kernel() 
> releasing the kernel lock on scheduling (and re-taking it on wakeup) as a 
> callback. Or async IO handling - both done independently of any 
> "workqueue" logic.
> 
> So tying this to the scheduler class seems a bit odd. But maybe I'm 
> missing something?

The only reason why the callbacks are implemented by inheriting
sched_class is because I thought it was a pretty special case, so
slightly lax on the hackish side while staying spartan on adding
hotpath overhead.  If this type of notification mechanism is something
which can be used more widely, it would definitely be better to have
proper per-task callback mechanism instead.  Probably per-task chain
of notifier ops so that only tasks which would be interested in such
events can opt in.

Avi, such per-task notification ops should be useable for kvm too,
right?

Thanks.

-- 
tejun
