Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbZAMQjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbZAMQjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 11:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZAMQjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 11:39:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36106 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbZAMQjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 11:39:35 -0500
Date: Tue, 13 Jan 2009 17:39:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH -v9][RFC] mutex: implement adaptive spinning
Message-ID: <20090113163907.GA24996@elte.hu>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231863710.7141.3.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> > Now you're forcing the slow-path on unlock. Maybe it was intentional, 
> > maybe it wasn't. Did you perhaps mean
> > 
> > 	if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
> > 
> > here? I thought we agreed it was safe, if only because it should be 
> > equivalent to just having done "mutex_trylock()" instead of a "real" 
> > lock sequence.
> 
> Yes, that was an 'accident' from -v8, yes we did think the cmpxchg was 
> good, however I did get some spurious lockups on -v7, and I only noticed 
> the thing after I'd done most of the testing, so I decided to let it be 
> for now.
> 
> Let me put the cmpxchg back in and see if this is all still good (only 
> 3*2*2 configs to test :-).

i saw sporadic lockups with -v7 too, so if you send a -v10 with Linus's 
sequence for the unlock it takes about an hour of testing to check whether 
it still occurs.

	Ingo
