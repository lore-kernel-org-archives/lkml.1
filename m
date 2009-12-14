Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbZLNBxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbZLNBxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 20:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbZLNBxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 20:53:46 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54056 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbZLNBxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 20:53:45 -0500
Date: Sun, 13 Dec 2009 17:53:47 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Al Viro <viro@zeniv.linux.org.uk>,
       James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 0/9] Fix various __task_cred related invalid RCU
	assumptions
Message-ID: <20091214015347.GB7710@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091210001308.247025548@linutronix.de> <20091210022825.GG6938@linux.vnet.ibm.com> <alpine.LFD.2.00.0912091914540.3560@localhost.localdomain> <1260422031.4165.1.camel@twins> <20091210053457.GB6720@linux.vnet.ibm.com> <1260730577.4165.7.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260730577.4165.7.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 07:56:17PM +0100, Peter Zijlstra wrote:
> On Wed, 2009-12-09 at 21:34 -0800, Paul E. McKenney wrote:
> 
> > Ah -- I have a related lockdep question.  Is there a primitive that says
> > whether or not the current task holds at least one lock of any type?
> > If so, I would like to make rcu_dereference() do at least a little crude
> > checking for this problem.
> 
> Hmm, no, but that's not hard to do, however I actually implemented
> something like that for RCU a long while ago and that gives a metric TON
> of false positives due to things like the radix tree which are RCU-safe
> but are not required to be used with RCU.

Understood -- my current guess is that there needs to be a way to tag
a variant of the rcu_dereference() API with the conditions that must be
met, for example, either in an rcu-sched read-side critical section or
holding a specific type of lock.

This does make it a little harder to retroactively add checking to
existing calls to rcu_dereference(), but should allow a good balance
between false positives and false negatives going forward.

Seem reasonable, or am I still missing something?

							Thanx, Paul
