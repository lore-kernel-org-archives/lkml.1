Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbZAFRCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbZAFRCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 12:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZAFRCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 12:02:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52114 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbZAFRCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 12:02:34 -0500
Date: Tue, 6 Jan 2009 18:02:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Message-ID: <20090106170204.GB32608@elte.hu>
References: <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu> <alpine.LFD.2.00.0901060750410.3057@localhost.localdomain> <alpine.LFD.2.00.0901060808260.3057@localhost.localdomain> <alpine.LFD.2.00.0901060833060.3057@localhost.localdomain> <alpine.LFD.2.00.0901060841000.3057@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901060841000.3057@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 6 Jan 2009, Linus Torvalds wrote:
> > 
> > Right now, if some process deadlocks on a mutex, we get hung process, 
> > but with a nice backtrace and hopefully other things (that don't need 
> > that lock) still continue to work.
> 
> Clarification: the "nice backtrace" we only get with something like 
> sysrq-W, of course. We don't get a backtrace _automatically_, but with 
> an otherwise live machine, there's a better chance that people do get 
> wchan or other info. IOW, it's at least a fairly debuggable situation.

btw., the softlockup watchdog detects non-progressing uninterruptible 
tasks (regardless of whether they locked up due to mutexes or any other 
reason).

This does occasionally help in debugging deadlocks:

  http://marc.info/?l=linux-mm&m=122889587725061&w=2

but it would indeed be also good to have the most common self-deadlock 
case checked unconditionally in the mutex slowpath.

	Ingo
