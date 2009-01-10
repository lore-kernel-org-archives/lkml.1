Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbZAJWHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbZAJWHh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbZAJWHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:07:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56866 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZAJWHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:07:24 -0500
Date: Sat, 10 Jan 2009 23:21:42 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Theodore Tso <tytso@mit.edu>, Mike Snitzer <snitzer@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       jim owens <jowens@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, sam@ravnborg.org,
       Dave Anderson <anderson@redhat.com>
Subject: Re: source line numbers with x86_64 modules? [Was: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact]
Message-ID: <20090110222142.GI26290@one.firstfloor.org>
References: <170fa0d20901100621m74680e0ewd1916c70f1636c9b@mail.gmail.com> <20090110153446.GA13976@elte.hu> <170fa0d20901101021s3b9a18e9qe6150c374efa4d6f@mail.gmail.com> <20090110211531.GD31579@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110211531.GD31579@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In my experience, there are very few kernel versions and hardware for
> which kdump works. 

I think that's mostly because kexec from arbitary context is a 
somewhat unstable concept. It requires all drivers to be able
to reinit the hardware from an arbitary state, and that's just
hard (it's kind of "make suspend/resume work everywhere"
and then a little harder and we know how long that took)

We also don't really have any tools to help making this
easier to implement for driver developers. Like e.g. some self
test that restarted drivers regularly to check this. 

But you often don't need kdump for crash dumps.
In many cases the system is still alive after an oops
or other problem and you can just do a live dump or even 
live crash session to look at data structures.

I used to do this with gdb regularly, but now
usually use crash because it has better tools.

> they aren't enterprise users.  Heck, until July of last year,
> Systemtap wouldn't even ***compile*** out of the box on a
> non-enterprise distribution like Ubuntu or Debian.

At least on opensuse releases it tends to work for me. 

The biggest PITA used to be the elfutils dependency which
seemed to come out of a all-world-is-redhat mindset at
the developers, but that can be worked around now.

Sometimes on has to patch it up when updating kernels 
because some interface by the runtime has changed again, but 
that shouldn't be a demanding task for kernel hackers really.
At least I didn't find it particularly difficult.

I wish they would merge the runtime into mainline though.

-Andi
-- 
ak@linux.intel.com
