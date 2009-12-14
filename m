Return-Path: <linux-kernel-owner+w=401wt.eu-S1750784AbZLNWil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750784AbZLNWil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbZLNWik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:38:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:44804 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbZLNWij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:38:39 -0500
Message-ID: <4B26BE67.5060107@kernel.org>
Date: Tue, 15 Dec 2009 07:38:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Warn people about flush_scheduled_work()
References: <Pine.LNX.4.44L0.0912141619410.2690-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912141619410.2690-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan Stern.

On 12/15/2009 06:33 AM, Alan Stern wrote:
> You've spent some time working on the workqueue implementation, right?  
> I'd like to add comments or kerneldoc warning people about how 
> dangerous it can be to use flush_scheduled_work() and related 
> functions.  Something like this:
> 
> 	Think twice before calling this function!  It's very easy
> 	to get into trouble if you don't take great care.  Either
> 	of the following situations will lead to deadlock:
> 
> 		Your code is running in the context of a scheduled
> 		work routine.
>
> 		Your code or its caller holds a lock needed by
> 		one of the work items currently on the workqueue.
>
> 	Since you generally don't know who your caller is, what locks
> 	it holds, or what locks are needed by the items on the 
> 	workqueue, avoiding these situations is quite difficult.

I think both problems can be detected by lockdep, right?  So, they
aren't that difficult to detect.

> 	Consider using cancel_work_sync() or cancel_delayed_work_sync()
> 	instead.  In most situations they will accomplish what you 
> 	need.
> 
> Does this sound like a good idea?  Certainly flush_scheduled_work()  
> is used in places where it shouldn't be.

Yeah, recommending more work-specific constructs definitely would be
better.  It's bad that we can't recommend the use of flush_work() as
it doesn't do cross-cpu flushing.  Maybe that needs explanation too.

> If comments like this are added, where do you think would be a good 
> place to put them?

DocBook comment on top of each function, maybe?

Thanks.

-- 
tejun
