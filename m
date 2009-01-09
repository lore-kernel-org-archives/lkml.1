Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbZAIR40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbZAIR40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 12:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbZAIRzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 12:55:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752893AbZAIRzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 12:55:49 -0500
Date: Fri, 9 Jan 2009 09:54:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matthew Wilcox <matthew@wil.cx>
cc: Andi Kleen <andi@firstfloor.org>, Dirk Hohndel <hohndel@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       jim owens <jowens@hp.com>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, jh@suse.cz,
       richard.guenther@gmail.com
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
In-Reply-To: <20090109173914.GD6936@parisc-linux.org>
Message-ID: <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain>
References: <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu> <49677CB1.3030701@zytor.com> <20090109084620.3c711aad@infradead.org>
 <20090109172011.GD26290@one.firstfloor.org> <20090109172801.GC6936@parisc-linux.org> <20090109174719.GG26290@one.firstfloor.org> <20090109173914.GD6936@parisc-linux.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Jan 2009, Matthew Wilcox wrote:
> 
> That seems like valuable feedback to give to the GCC developers.

Well, one thing we should remember is that the kernel really _is_ special.

The kernel not only does things no other program tends to do (inline asms 
are unusual in the first place - many of them are literally due to system 
issues like atomic accesses and interrupts that simply aren't an issue in 
user space, or that need so much abstraction that they aren't inlinable 
anyway).

But the kernel also has totally different requirements in other ways. When 
was the last time you did user space programming and needed to get a 
backtrace from a user with register info because you simply don't have the 
hardware that he has? 

IOW, debugging in user space tends to be much more about trying to 
reproduce the bug - in a way that we often cannot in the kernel. User 
space in general is much more reproducible, since it's seldom as hardware- 
or timing-dependent (threading does change the latter, but usually user 
space threading is not _nearly_ as aggressive as the kernel has to be).

So the thing is, even if gcc was "perfect", it would likely be perfect for 
a different audience than the kernel. 

Do you think _any_ user space programmer worries about the stack space 
being a few hundred bytes larger because the compiler inlined two 
functions, and caused stack usage to be sum of them instead of just the 
maximum of the two?

So we do have special issues. And exactly _because_ we have special issues 
we should also expect that some compiler defaults simply won't ever really 
be appropriate for us.

			Linus
