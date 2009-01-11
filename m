Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbZAKUw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbZAKUw2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 15:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZAKUwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 15:52:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752204AbZAKUwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 15:52:16 -0500
Date: Sun, 11 Jan 2009 12:51:31 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement
 adaptive spinning
In-Reply-To: <20090111203441.GQ26290@one.firstfloor.org>
Message-ID: <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain>
References: <20090109231227.GA25070@elte.hu> <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain> <20090110010125.GA31031@elte.hu> <20090109174158.096dee70.akpm@linux-foundation.org> <20090110030216.GW26290@one.firstfloor.org>
 <1231676801.25018.150.camel@macbook.infradead.org> <20090111181307.GM26290@one.firstfloor.org> <alpine.LFD.2.00.0901111114230.6528@localhost.localdomain> <20090111201427.GP26290@one.firstfloor.org> <1231704939.25018.548.camel@macbook.infradead.org>
 <20090111203441.GQ26290@one.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Jan 2009, Andi Kleen wrote:
> 
> Was -- i think that got fixed in gcc. But again only in newer versions.

I doubt it. People have said that about a million times, it has never 
gotten fixed, and I've never seen any actual proof.

I think that what got fixed was that gcc now at least re-uses stack slots 
for temporary spills. But only for things that fit in registers - not if 
you actually had variables that are big enough to be of type MEM. And the 
latter is what tends to eat stack-space (ie structures etc on stack).

But hey, maybe it really did get fixed. But the last big stack user wasn't 
that long ago, and I saw it and I have a pretty recent gcc (gcc-4.3.2 
right now, it could obviously have been slightly older back a few months 
ago).

		Linus
