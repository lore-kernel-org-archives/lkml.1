Return-Path: <linux-kernel-owner+w=401wt.eu-S1762750AbZAGXdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762750AbZAGXdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756392AbZAGXdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:33:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753908AbZAGXdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:33:18 -0500
Date: Wed, 7 Jan 2009 15:32:11 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
cc: Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
In-Reply-To: <alpine.DEB.1.10.0901071806240.23456@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.0901071529530.3057@localhost.localdomain>
References: <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
 <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <20090107210923.GV2002@parisc-linux.org> <20090107213924.GP496@one.firstfloor.org> <49652C7C.3000909@novell.com> <20090107223317.GB27629@elte.hu>
 <4965331E.8090202@novell.com> <alpine.DEB.1.10.0901071806240.23456@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Jan 2009, Steven Rostedt wrote:
> 
> What would be interesting is various benchmarks against all three.
> 
> 1) no mutex spinning.
> 2) get_task_struct() implementation.
> 3) spin_or_sched implementation.

One of the issues is that I cannot convince myself that (2) is even 
necessarily correct. At least not without having all cases happen inder 
the mutex spinlock - which they don't. Even with the original patch, the 
uncontended cases set and cleared the owner field outside the lock.

			Linus
