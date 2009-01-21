Return-Path: <linux-kernel-owner+w=401wt.eu-S1764407AbZAUIwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764407AbZAUIwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763995AbZAUIwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:52:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763718AbZAUIwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:52:16 -0500
Date: Wed, 21 Jan 2009 09:52:08 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Message-ID: <20090121085208.GO24891@wotan.suse.de>
References: <20090119001345.GA9880@elte.hu> <20090119062212.GC22584@wotan.suse.de> <alpine.LFD.2.00.0901200754100.2974@localhost.localdomain> <20090120005124.GD16304@wotan.suse.de> <20090120123824.GD7790@elte.hu> <1232480940.22233.1435.camel@macbook.infradead.org> <20090120210515.GC19710@elte.hu> <alpine.LFD.2.00.0901210814130.2892@localhost.localdomain> <20090120220516.GA10483@elte.hu> <20090121085402.GD15750@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121085402.GD15750@one.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 09:54:02AM +0100, Andi Kleen wrote:
> > GCC 4.3.2. Maybe i missed something obvious?
> 
> The typical use case of restrict is to tell it that multiple given
> arrays are independent and then give the loop optimizer 
> more freedom to handle expressions in the loop that
> accesses these arrays.
> 
> Since there are no loops in the list functions nothing changed.
> 
> Ok presumably there are some other optimizations which 
> rely on that alias information too, but again the list_*
> stuff is probably too simple to trigger any of them.

Any function that does several interleaved loads and stores
through different pointers could have much more freedom to
move loads early and stores late. Big OOOE CPUs won't care
so much, but embedded and things (including in-order x86)
are very important users of the kernel.

