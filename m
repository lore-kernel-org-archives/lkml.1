Return-Path: <linux-kernel-owner+w=401wt.eu-S1762138AbZAHTPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138AbZAHTPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758537AbZAHTOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:14:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757739AbZAHTOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:14:48 -0500
Date: Thu, 8 Jan 2009 11:13:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Chris Mason <chris.mason@oracle.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
In-Reply-To: <1231441350.14304.48.camel@think.oraclecorp.com>
Message-ID: <alpine.LFD.2.00.0901081109300.3283@localhost.localdomain>
References: <1231441350.14304.48.camel@think.oraclecorp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Jan 2009, Chris Mason wrote:
> 
> It is less fair though, the 50 proc parallel creates had a much bigger
> span between the first and last proc's exit time.  This isn't a huge
> shock, I think it shows the hot path is closer to a real spin lock.

Actually, the real spin locks are now fair. We use ticket locks on x86.

Well, at least we do unless you enable that broken paravirt support. I'm 
not at all clear on why CONFIG_PARAVIRT wants to use inferior locks, but I 
don't much care.

We _could_ certainly aim for using ticket locks for mutexes too, that 
might be quite nice.

But yes, from a throughput standpoint fairness is almost always a bad 
thing, so your numbers could easily go down if we did.

			Linus
