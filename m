Return-Path: <linux-kernel-owner+w=401wt.eu-S1760324AbZALXC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760324AbZALXC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 18:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbZALXCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 18:02:13 -0500
Received: from mail2.shareable.org ([80.68.89.115]:49231 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbZALXCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 18:02:11 -0500
Date: Mon, 12 Jan 2009 23:01:17 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Message-ID: <20090112230117.GC26430@shareable.org>
References: <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain> <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain> <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain> <20090112193201.GA23848@one.firstfloor.org> <496B9890.1090002@zytor.com> <alpine.LFD.2.00.0901121143070.6528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901121143070.6528@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> > This is about storage allocation, not aliases.  Storage allocation only
> > depends on lifetime.
> 
> Well, the thing is, code motion does extend life-times, and if you think 
> you can move stores across each other (even when you can see that they 
> alias statically) due to type-based alias decisions, that does essentially 
> end up making what _used_ to be disjoint lifetimes now be potentially 
> overlapping.

Sometimes code motion makes code faster and/or smaller but use more
stack space.  If you want to keep the stack use down, it blocks some
other optimisations.

Register allocation is similar: code motion optimisations may use more
registers due to overlapping lifetimes, which causes more register
spills and changes the code.  The two interact; it's not trivial to
optimise fully.

-- Jamie
