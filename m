Return-Path: <linux-kernel-owner+w=401wt.eu-S933050AbYEGWq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050AbYEGWq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759144AbYEGWp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:45:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757167AbYEGWp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:45:56 -0400
Date: Wed, 7 May 2008 15:44:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
In-Reply-To: <20080507222205.GC8276@duo.random>
Message-ID: <alpine.LFD.1.10.0805071540300.3024@woody.linux-foundation.org>
References: <6b384bb988786aa78ef0.1210170958@duo.random> <alpine.LFD.1.10.0805071349200.3024@woody.linux-foundation.org> <20080507212650.GA8276@duo.random> <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org> <20080507222205.GC8276@duo.random>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 May 2008, Andrea Arcangeli wrote:
> 
> Unfortunately the lock you're talking about would be:
> 
> static spinlock_t global_lock = ...
> 
> There's no way to make it more granular.

Right. So what? 

It's still about a million times faster than what the code does now.

You comment about "great smp scalability optimization" just shows that 
you're a moron. It is no such thing. The fact is, it's a horrible 
pessimization, since even SMP will be *SLOWER*. It will just be "less 
slower" when you have a million CPU's and they all try to do this at the 
same time (which probably never ever happens).

In other words, "scalability" is totally meaningless. The only thing that 
matters is *performance*. If the "scalable" version performs WORSE, then 
it is simply worse. Not better. End of story.

> mmu_notifier_register can take ages. No problem.

So what you're saying is that performance doesn't matter?

So why do you do the ugly crazy hundred-line implementation, when a simple 
two-liner would do equally well?

Your arguments are crap.

Anyway, discussion over. This code doesn't get merged. It doesn't get 
merged before 2.6.26, and it doesn't get merged _after_ either.

Rewrite the code, or not. I don't care. I'll very happily not merge crap 
for the rest of my life.

		Linus
