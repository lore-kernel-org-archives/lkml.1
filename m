Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbZJAQ74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbZJAQ74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 12:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbZJAQ74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 12:59:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755425AbZJAQ7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 12:59:55 -0400
Date: Thu, 1 Oct 2009 09:57:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tejun Heo <tj@kernel.org>
cc: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH 03/19] scheduler: implement workqueue scheduler class
In-Reply-To: <1254384558-1018-4-git-send-email-tj@kernel.org>
Message-ID: <alpine.LFD.2.01.0910010953010.6996@localhost.localdomain>
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-4-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Oct 2009, Tejun Heo wrote:
>
> Implement workqueue scheduler class.  Workqueue sched_class inherits
> fair sched_class and behaves exactly the same as sched_class except
> that it has two callback functions which get called when a task is put
> to sleep and wakes up and doesn't allow switching to different
> scheduler class.

So this looks odd to me.

I agree completely with the callback functions, but what I don't agree 
with is that this is somehow workqueue-related. I bet that others could 
use this, and in fact, I suspect that it should not be tied to the 
scheduler class at all, but to the _thread_.

Just as an example, I could imagine that we would do lock_kernel() 
releasing the kernel lock on scheduling (and re-taking it on wakeup) as a 
callback. Or async IO handling - both done independently of any 
"workqueue" logic.

So tying this to the scheduler class seems a bit odd. But maybe I'm 
missing something?

		Linus
