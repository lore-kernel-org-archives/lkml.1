Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbZAFS3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbZAFS3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZAFS3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:29:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbZAFS3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:29:42 -0500
Date: Tue, 6 Jan 2009 10:28:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
cc: Peter Zijlstra <peterz@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
In-Reply-To: <alpine.DEB.1.10.0901061314310.10871@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.0901061026240.3057@localhost.localdomain>
References: <1230722935.4680.5.camel@think.oraclecorp.com>  <20081231104533.abfb1cf9.akpm@linux-foundation.org>  <1230765549.7538.8.camel@think.oraclecorp.com>  <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org>  <1231093310.27690.5.camel@twins>
  <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <alpine.LFD.2.00.0901060948220.3057@localhost.localdomain> <alpine.DEB.1.10.0901061314310.10871@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Jan 2009, Steven Rostedt wrote:
> 
> Caching the rq is an interesting idea. But since the rq struct is local to 
> sched.c, what would be a good API to do this?

Just move the whole "spin_or_schedule()" into sched.c, and you're all 
done.

Yeah, that requires having sched.c know a bit about mutex locking rules, 
but the data structures are already exported in <linux/mutex.h>, and while 
_normal_ code should never care or know exactly how it is used, I think 
the scheduler might as well. Mutexes are clearly very much a scheduling 
entity, so it's not too much of a break with internal knowledge.

		Linus
