Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbYHZQ71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbYHZQ71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756337AbYHZQ7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:59:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755044AbYHZQ7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:59:19 -0400
Date: Tue, 26 Aug 2008 09:58:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Al Viro <viro@ZenIV.linux.org.uk>,
       hch@infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH 2/2] poll: allow f_op->poll to sleep
In-Reply-To: <48B40C2F.3050700@gmail.com>
Message-ID: <alpine.LFD.1.10.0808260954040.3363@nehalem.linux-foundation.org>
References: <48B40BD4.7040004@kernel.org> <48B40C2F.3050700@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Aug 2008, Tejun Heo wrote:
> 
> This patch converts poll/select to use custom wake up function and use
> separate triggered variable to synchronize against wake up events.
> The only added overhead is an extra function call during wake up and
> negligible.

I don't really see the point.

poll() isn't allowed to sleep for many reasons. Some are technical. But 
the most obvious one is that a sleeping "poll()" is totally against the 
whole point of polling in the first place!

So is there some big conceptual reason to change how poll() has always 
worked?

If you worry about debuggability, then we could just add a 

	preempt_enable();
	..
	preempt_disable();

around the poll calls (purely for catching errors) to get a big warning if 
somebody tries to call a sleepable function.

		Linus
