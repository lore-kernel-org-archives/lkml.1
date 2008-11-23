Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbYKWJqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbYKWJqW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 04:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbYKWJqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 04:46:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59937 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbYKWJqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 04:46:11 -0500
Date: Sun, 23 Nov 2008 10:45:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Miklos Szeredi <miklos@szeredi.hu>,
       arjan@linux.intel.com, Linus Torvalds <torvalds@linux-foundation.org>,
       hch@infradead.org, rminnich@sandia.gov, ericvh@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: poll: allow f_op->poll to sleep, take #3
Message-ID: <20081123094551.GQ30453@elte.hu>
References: <E1L3oK1-0001Pz-J9@pomaz-ex.szeredi.hu> <20081122123942.GF5707@parisc-linux.org> <4927FE87.6050005@gmail.com> <20081122105356.87856d04.akpm@linux-foundation.org> <4928B162.9030404@gmail.com> <alpine.DEB.1.10.0811221831550.19456@alien.or.mcafeemobile.com> <20081123085902.GI30453@elte.hu> <49291F06.5040907@gmail.com> <20081123093420.GN30453@elte.hu> <492925B0.9030404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492925B0.9030404@gmail.com>
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


* Tejun Heo <htejun@gmail.com> wrote:

> Ingo Molnar wrote:
> > _sync() is not something that should normally be done from poll 
> > handlers. But ->poll() handlers should all be TASK_INTERRUPTIBLE, 
> > right? So wake_up_process_interruptible() should be the thing you 
> > need?
> > 
> > Anyway, if you really want to pass in a state filter, you can use the 
> > already existing wake_up_state() method as well.
> 
> It's not really about what I want but more about how the interface 
> looks in the first place.  Something like the following is simply 
> ugly.
> 
> int my_callback(param a, param b, param c)
> {
> 	WARN_ON(b != B);
> 	do_something(a);
> }
> 
> And @sync might be useful depending on who's waking it up, so we 
> either need to change the wake interface or give it an easier way to 
> pass those parameters as received.  The callback function isn't the 
> right place to ignore those parameters.  It simply doesn't know why 
> the caller is passing them in or what they mean under the 
> circumstances.

We'll likely eliminate the 'sync' parameter from the scheduler. It's 
not a flag that should be proliferated.

	Ingo
