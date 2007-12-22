Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbXLVVBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbXLVVBf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 16:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbXLVVB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 16:01:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53950 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751698AbXLVVB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 16:01:27 -0500
Date: Sat, 22 Dec 2007 13:00:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <20071222192550.GD28891@thunk.org>
Message-ID: <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com> <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org> <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com> <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy>
 <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com> <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de> <20071222100326.GF26157@elte.hu> <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org>
 <20071222192550.GD28891@thunk.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 22 Dec 2007, Theodore Tso wrote:
> 
> I have a general problem with things in /sys/slab, and that's just
> because they are *ugly*.  So yes, you can write ugly shell scripts
> like this to get out information:

[ script deleted ]

> But sometimes when trying to eyeball what is going on, it's a lot
> nicer just to use "cat /proc/slabinfo".  

.. and I call BS on this claim.

/proc/slabinfo was (and is) totally pointless for "trying to eyeball 
what's going on". The output is totally unreadable, and useless. You end 
up with exactly the same script as above, except it reads as

	cat /proc/slabinfo | (read headerline
		while read name active num objsize objsperslab pagesperslab rest
		do
			realsize=$(( nul * objsize ))
			size=$(( active * objsize ))
			.. exact same rest of loop ..
		done | sort -n | ..

so no, "cat /proc/slabinfo" was almost never practical on its own.

The *one* advantage it does have is that you can forward it to others. 
That's a big advantage. But no, it wasn't ever readable for eyeballing, 
because it doesn't even give you a memory usage thing (just "number of 
objects and object size" as separate numbers).

But the "everything in one file" indubitably did make it a lot easier for 
just attaching it to bug-reports.

> Another problem with using /sys/slab is that it is downright *ugly*.
> Why is it for example, that /sys/slab/dentry is a symlink to
> ../slab/:a-0000160?

That's the only really ugly thing there. Otherwise, it's pretty nice, but 
having a million files makes for problems when trying to send somebody 
else the full info. 

		Linus
