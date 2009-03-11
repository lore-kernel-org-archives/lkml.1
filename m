Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbZCKNgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbZCKNgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbZCKNgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:36:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50711 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035AbZCKNgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:36:12 -0400
Date: Wed, 11 Mar 2009 14:35:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 01/11] Introducing generic hardware breakpoint handler
	interfaces
Message-ID: <20090311133533.GD1074@elte.hu>
References: <20090310135018.GB3850@elte.hu> <Pine.LNX.4.44L0.0903101017040.2962-100000@iolanthe.rowland.org> <20090310145036.GI3850@elte.hu> <20090311125705.GB9547@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311125705.GB9547@in.ibm.com>
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


* K.Prasad <prasad@linux.vnet.ibm.com> wrote:

> For the benefit of continuing discussion on this topic, here's 
> an extract from an old mail 
> (http://lkml.org/lkml/2007/2/5/465) from Roland, explaining 
> the need for prioritisation of requests. It must have been 
> utrace as a potential user that made him suggest this.
> 
> "I am all in favor of a facility to manage shared use of the 
> debug registers, such as your debugreg.h additions.  I just 
> think it needs to be a little more flexible.  An unobtrusive 
> kernel facility has to get out of the way when user-mode 
> decides to use all its debug registers.  It's not immediately 
> important what it's going to about it when contention arises, 
> but there has to be a way for the user-mode facilities to say 
> they need to allocate debugregs with priority and evict other 
> squatters.  So, something like code allocating a debugreg can 
> supply a callback that's made when its allocation has to taken 
> by something with higher priority.
> 
> Even after utrace, there will always be the possibility of a 
> traditional uncoordinated user of the raw debug registers, if 
> nothing else ptrace compatibility will always be there for old 
> users.  So anything new and fancy needs to be prepared to back 
> out of the way gracefully.  In the case of kwatch, it can just 
> have a handler function given by the caller to start with.  
> It's OK if individual callers can specially declare "I am not 
> well-behaved" and eat debugregs so that well-behaved 
> high-priority users like ptrace just have to lose (breaking 
> compatibility).  But no well-behaved caller of kwatch will do 
> that.
> 
> I certainly intend for later features based on utrace to 
> include higher-level treatment of watchpoints so that user 
> debugging facilities can also become responsive to debugreg 
> allocation pressure.  (Eventually, the user facilities might 
> have easier ways of falling back to other methods and getting 
> out of the way of kernel debugreg consumers, than can be done 
> for the kernel-mode-tracing facilities.)  To that end, I'd 
> like to see a clear and robust interface for debugreg sharing, 
> below the level of kwatch."

This argument ignores the reality of debug registers: 
overcommitted usage of them causes silent failures and
unobvious behavior.

I think the simple reservation scheme i outlined in the
previous mail is the minimum amount of complexity that
still gets kernel-space hw-breakpoints going robustly.
If we add anything more fancy we want it based on actual
need and desire.

	Ingo
