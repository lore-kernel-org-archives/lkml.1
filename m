Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbZAIVYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbZAIVYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756264AbZAIVYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:24:11 -0500
Received: from thunk.org ([69.25.196.29]:56236 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154AbZAIVYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:24:08 -0500
Date: Fri, 9 Jan 2009 16:23:35 -0500
From: Theodore Tso <tytso@mit.edu>
To: Richard Guenther <richard.guenther@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Dirk Hohndel <hohndel@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, jim owens <jowens@hp.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
	impact
Message-ID: <20090109212335.GH23869@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Richard Guenther <richard.guenther@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
	Dirk Hohndel <hohndel@infradead.org>,
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
	Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
References: <20090109172011.GD26290@one.firstfloor.org> <20090109172801.GC6936@parisc-linux.org> <20090109174719.GG26290@one.firstfloor.org> <20090109173914.GD6936@parisc-linux.org> <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain> <84fc9c000901091109t2c2aef2fu596f8807b0962688@mail.gmail.com> <alpine.LFD.2.00.0901091128170.6528@localhost.localdomain> <84fc9c000901091214i16fc74b7q349433a5586d5619@mail.gmail.com> <alpine.LFD.2.00.0901091217530.6528@localhost.localdomain> <84fc9c000901091237i68b2e495tab55e61fb3dbd565@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84fc9c000901091237i68b2e495tab55e61fb3dbd565@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm beginning to think that for the kernel, we should just simply
remove CONFIG_OPTIMIZE_INLINING (so that inline means
"always_inline"), and -fno-inline-functions
-fno-inline-functions-called-one (so that gcc never inlines functions
behind our back) --- and then we create tools that count how many times functions get used, and how big functions are, so that we can flag if some 
function really should be marked inline when it isn't or vice versa.   

But given that this is a very hard thing for an automated program
todo, let's write some tools so we can easily put a human in the loop,
who can add or remove inline keywords where it makes sense, and let's
give up on gcc being able to "guess" correctly.

For some things, like register allocation, I can accept that the
compiler will usually get these things right.  But whether or not to
inline a function seems to be one of those things that humans (perhaps
with some tools assist) can still do a better job than compilers.

     	  		    	     - Ted
