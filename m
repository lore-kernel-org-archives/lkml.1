Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbZAJXAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbZAJXAX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 18:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbZAJXAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 18:00:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753247AbZAJW77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:59:59 -0500
Date: Sat, 10 Jan 2009 14:58:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: Theodore Tso <tytso@mit.edu>, Mike Snitzer <snitzer@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Nicholas Miell <nmiell@comcast.net>,
       jim owens <jowens@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, sam@ravnborg.org,
       Dave Anderson <anderson@redhat.com>
Subject: Re: source line numbers with x86_64 modules? [Was: Re: [patch]
 measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact]
In-Reply-To: <20090110222142.GI26290@one.firstfloor.org>
Message-ID: <alpine.LFD.2.00.0901101454090.6528@localhost.localdomain>
References: <170fa0d20901100621m74680e0ewd1916c70f1636c9b@mail.gmail.com> <20090110153446.GA13976@elte.hu> <170fa0d20901101021s3b9a18e9qe6150c374efa4d6f@mail.gmail.com> <20090110211531.GD31579@mit.edu> <20090110222142.GI26290@one.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Jan 2009, Andi Kleen wrote:
> 
> I think that's mostly because kexec from arbitary context is a 
> somewhat unstable concept.

I think that's the understatement of the year.

We have tons of problems with standard suspend-to-ram, and that's when the 
suspend sequence has done its best to make everything quiescent. Expecting 
that we can reinitialize all the hardware at some random point when things 
are going haywire is "optimistic" at best.

So of course it will work on some hardware and not others.

I think we've been fairly successful at keeping a running system for 
_most_ of our bugs. Even when things go bad with X running, it's quite 
often possible to ssh in over the network (although it's often better if 
you were already connected) and see the dump.

Not always, obviously. Many dumps really are painful. I'm hoping that 
kernel-mode-setting will at least give us the oops message _more_ of the 
time.

As far as I'm concerned, digital cameras have been more useful than kernel 
dumps to kernel debugging. 

			Linus
