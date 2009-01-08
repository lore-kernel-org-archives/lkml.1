Return-Path: <linux-kernel-owner+w=401wt.eu-S1759928AbZAHOYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928AbZAHOYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbZAHOYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:24:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45046 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737AbZAHOYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:24:06 -0500
Date: Thu, 8 Jan 2009 09:24:03 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
In-Reply-To: <20090108065235.GX496@one.firstfloor.org>
Message-ID: <alpine.DEB.1.10.0901080919540.22642@gandalf.stny.rr.com>
References: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
 <1231365115.11687.361.camel@twins> <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain> <1231368870.6686.16.camel@norville.austin.ibm.com> <alpine.LFD.2.00.0901071518570.3057@localhost.localdomain> <alpine.DEB.1.10.0901071848431.23456@gandalf.stny.rr.com>
 <20090108065235.GX496@one.firstfloor.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 8 Jan 2009, Andi Kleen wrote:

> > What about memory hotplug as Ingo mentioned?
> > 
> > Should that be:
> > 
> > #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_MEMORY_HOTPLUG)
> 
> We expect memory hotunplug to only really work in movable zones
> (all others should at least have one kernel object somewhere that prevents
> unplug) and you can't have task structs in movable zones obviously
> 
> So it's probably a non issue in practice.

Sure, it probably is a non issue, but I'm afraid that non issues of today 
might become issues of tomorrow. Where does it say that we can never put a 
task struct in a movable zone. Perhaps, we could someday have a CPU with 
memory local to it, and pinned tasks to that CPU in that memory. Then 
there can be cases where we remove the CPU and memory together.

Because of preemption in the mutex spin part, there's no guarantee that a 
the task in that removed memory will not be referenced again. Of course 
this thought is purely theoretical, but I like to solve bugs that might 
might happen tomorrow too. ;-)

-- Steve

