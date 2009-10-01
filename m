Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbZJAQfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbZJAQfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 12:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbZJAQfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 12:35:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:48890 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbZJAQfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 12:35:00 -0400
Message-ID: <4AC4DA0F.2090104@kernel.org>
Date: Fri, 02 Oct 2009 01:34:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH 19/19] workqueue: implement concurrency managed workqueue
References: <1254384558-1018-1-git-send-email-tj@kernel.org>	<1254384558-1018-20-git-send-email-tj@kernel.org> <20091001074959.dbdf6f6a.akpm@linux-foundation.org>
In-Reply-To: <20091001074959.dbdf6f6a.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 16:34:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu,  1 Oct 2009 17:09:18 +0900 Tejun Heo <tj@kernel.org> wrote:
> 
>> To solve the above issues, this patch implements concurrency-managed
>> workqueue.
> 
> Seems reasonable.
> 
> This approach would appear to rule out the option of setting a work
> thread's state (scheduling policy, scheduling priority, uid, etc) to
> anything other than some default.
> 
> I guess that's unlikely to be a problem if we haven't yet had a need to
> do that, but I'd be a bit surprised to discover that nobody has done
> that sort of thing yet?  Nobody has niced up their workqueue threads?

There were only two users in mainline which diddle with the worker
kthread.  The stop machine call which uses RT priority and osl which
binds worker to cpu0.  Both are updated not to do that in earlier
patches.  For most cases, I don't think it would matter.  For special
cases, given the rarity of them, I think we're better off with custom
kthread for now.  If they become more prevalent, we'll need to add
support for it so that it can be done easier but even that turns out
to be the case I think it would better to implement that separately
from generic workqueue.

Thanks.

-- 
tejun
