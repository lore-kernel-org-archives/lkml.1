Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbZAIJaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbZAIJaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 04:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbZAIJ3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 04:29:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:42457 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbZAIJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 04:28:56 -0500
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
In-Reply-To: <alpine.LFD.2.00.0901081109300.3283@localhost.localdomain>
References: <1231441350.14304.48.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901081109300.3283@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Jan 2009 10:28:25 +0100
Message-Id: <1231493305.11687.528.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 11:13 -0800, Linus Torvalds wrote:
> 
> On Thu, 8 Jan 2009, Chris Mason wrote:
> > 
> > It is less fair though, the 50 proc parallel creates had a much bigger
> > span between the first and last proc's exit time.  This isn't a huge
> > shock, I think it shows the hot path is closer to a real spin lock.
> 
> Actually, the real spin locks are now fair. We use ticket locks on x86.

> We _could_ certainly aim for using ticket locks for mutexes too, that 
> might be quite nice.

Not really, ticket locks cannot handle a spinner going away - and we
need that here.

I've googled around a bit and MCS locks
(http://www.cs.rice.edu/~johnmc/papers/asplos91.pdf) look like a viable
way to gain fairness in our situation.

