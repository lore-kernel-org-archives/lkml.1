Return-Path: <linux-kernel-owner+w=401wt.eu-S1760687AbZAHPbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbZAHPbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 10:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbZAHPap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 10:30:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35362 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbZAHPao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 10:30:44 -0500
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
In-Reply-To: <alpine.DEB.1.10.0901081026120.22642@gandalf.stny.rr.com>
References: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
	 <1231347442.11687.344.camel@twins>
	 <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
	 <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
	 <1231365115.11687.361.camel@twins>
	 <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>
	 <1231366716.11687.377.camel@twins>
	 <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>
	 <1231408718.11687.400.camel@twins>  <20090108141808.GC11629@elte.hu>
	 <1231426014.11687.456.camel@twins>
	 <alpine.DEB.1.10.0901081003050.22642@gandalf.stny.rr.com>
	 <1231428220.11687.464.camel@twins>
	 <alpine.DEB.1.10.0901081026120.22642@gandalf.stny.rr.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Jan 2009 16:30:05 +0100
Message-Id: <1231428605.11687.466.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 10:28 -0500, Steven Rostedt wrote:
> On Thu, 8 Jan 2009, Peter Zijlstra wrote:

> > in the unlikely case we schedule(), that seems expensive enough to want
> > to make the spin case ever so slightly faster.
> 
> OK, that makes sense, but I would comment that. Otherwise, it just looks 
> like another misuse of the unlikely annotation.

OK, sensible enough.

> > > Should we need to do a "get_cpu" or something? Couldn't the CPU disappear 
> > > between these two calls. Or does it do a stop-machine and the preempt 
> > > disable will protect us?
> > 
> > Did you miss the preempt_disable() a bit up?
> 
> No, let me rephrase it better. Does the preempt_disable protect against
> another CPU from going off line? Does taking a CPU off line do a 
> stop_machine?

Yes and yes.
