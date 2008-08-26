Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbYHZOJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbYHZOJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 10:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbYHZOJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 10:09:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35569 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956AbYHZOJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 10:09:36 -0400
Date: Tue, 26 Aug 2008 16:09:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, hch@infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH 1/2] wait: kill is_sync_wait()
Message-ID: <20080826140900.GA13062@elte.hu>
References: <48B40BD4.7040004@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B40BD4.7040004@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> is_sync_wait() is used to distinguish between sync and async waits.
> Basically sync waits are the ones initialized with
> init_waitqueue_entry() and async ones with init_waitqueue_func_entry().
> The sync/async distinction is used only in prepare_to_wait[_exclusive]()
> and its only function is to skip setting the current task state if the
> wait is async.  This has a few problems.
> 
> * No one uses it.  None of func_entry users use prepare_to_wait()
>   functions, so the code path never gets executed.
> 
> * The distinction is bogus.  Maybe back when func_entry is used only
>   by aio but it's now also used by epoll and in future possibly by 9p
>   and poll/select.
> 
> * Taking @state as argument and ignoring it silenly depending on how
>   @wait is initialized is just a bad error-prone API.
> 
> * It prevents func_entry waits from using wait->private for no good
>   reason.
> 
> This patch kills is_sync_wait() and the associated code paths from
> prepare_to_wait[_exclusive]().  As there was no user of these code
> paths, this patch doesn't cause any behavior difference.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

good spotting.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
