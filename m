Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbZJBMKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbZJBMKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 08:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbZJBMKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 08:10:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:42152 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbZJBMKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 08:10:07 -0400
Message-ID: <4AC5ED72.7090201@kernel.org>
Date: Fri, 02 Oct 2009 21:09:22 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, ar@firstfloor.org
Subject: Re: [PATCH 19/19] workqueue: implement concurrency managed workqueue
References: <1254384558-1018-1-git-send-email-tj@kernel.org>	<1254384558-1018-20-git-send-email-tj@kernel.org> <87ws3esk1m.fsf@basil.nowhere.org>
In-Reply-To: <87ws3esk1m.fsf@basil.nowhere.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 02 Oct 2009 12:09:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andi.

Andi Kleen wrote:
> Tejun Heo <tj@kernel.org> writes:
> 
>> Currently each workqueue has its own dedicated worker pool.  This
>> causes the following problems.
> 
> I definitely like the basic idea (without having read all the code so
> far).  Thanks for doing that work. On large systems the number of
> kernel threads around can be mind boggling, and it will also get rid
> of bizarreness like the ps2mouse thread.
> 
> I wonder have you ever thought about exposing this to user space too?
> It can face similar problems for parallelization.

Yeah, some similar mechanism could be useful to manage userland worker
pool too but determining what to export would be the difficult
question.  Events when all of certain groups of threads are blocked
could be useful and cpu idleness is too.

One thing is that for userspace there's already pretty thick layer of
abstraction in place and having this type of bare metal mechanism
might not buy much.  In most cases, monitoring system parameters
periodically and supplying a bit of extra threads should be able to
achieve about the same result.  Do you have anything specific on your
mind?

Thanks.

-- 
tejun
