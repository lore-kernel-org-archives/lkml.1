Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbXLVWPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbXLVWPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 17:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbXLVWPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 17:15:11 -0500
Received: from 1wt.eu ([62.212.114.60]:1063 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbXLVWPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 17:15:10 -0500
Date: Sat, 22 Dec 2007 23:10:50 +0100
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071222221050.GA20753@1wt.eu>
References: <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com> <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy> <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com> <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de> <20071222100326.GF26157@elte.hu> <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org> <20071222192550.GD28891@thunk.org> <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2007 at 01:00:09PM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 22 Dec 2007, Theodore Tso wrote:
> > 
> > I have a general problem with things in /sys/slab, and that's just
> > because they are *ugly*.  So yes, you can write ugly shell scripts
> > like this to get out information:
> 
> [ script deleted ]
> 
> > But sometimes when trying to eyeball what is going on, it's a lot
> > nicer just to use "cat /proc/slabinfo".  
> 
> .. and I call BS on this claim.
> 
> /proc/slabinfo was (and is) totally pointless for "trying to eyeball 
> what's going on". The output is totally unreadable, and useless. You end 
> up with exactly the same script as above, except it reads as
> 
> 	cat /proc/slabinfo | (read headerline
> 		while read name active num objsize objsperslab pagesperslab rest
> 		do
> 			realsize=$(( nul * objsize ))
> 			size=$(( active * objsize ))
> 			.. exact same rest of loop ..
> 		done | sort -n | ..
> 
> so no, "cat /proc/slabinfo" was almost never practical on its own.
> 
> The *one* advantage it does have is that you can forward it to others. 
> That's a big advantage. But no, it wasn't ever readable for eyeballing, 
> because it doesn't even give you a memory usage thing (just "number of 
> objects and object size" as separate numbers).

I don't agree with you Linus. I'm one of those used to quickly take a
look at its contents when I don't know where all my memory has gone.
I know by experience that if I find 6-digit values in dentry_cache or
inode_cache, all I was looking for is there, and that's enough for a
quick diag. It doesn't give anything accurate, but it's very useful
to quickly diag out some problems on production systems.

It was this week that I noticed for the first time that slabinfo did
not exist anymore, and did not know what replaced it. Lacking time,
I finally gave up and *supposed* that the memory was eaten by the
usual suspects.

I can understand that it has to go away for technical reasons, but Ted
is right, please don't believe that nobody uses it just because you got
no complaint. While people are not likely to perform all computations
in scripts, at least they're used to find some quickly identifiable
patterns there.

Willy

