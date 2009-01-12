Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbZALUMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbZALUMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbZALUMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:12:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755221AbZALUMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:12:22 -0500
Date: Mon, 12 Jan 2009 12:11:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Bernd Schmidt <bernds_cb1@t-online.de>
cc: Andi Kleen <andi@firstfloor.org>, David Woodhouse <dwmw2@infradead.org>,
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
In-Reply-To: <496BA036.3010101@t-online.de>
Message-ID: <alpine.LFD.2.00.0901121209220.6528@localhost.localdomain>
References: <1231676801.25018.150.camel@macbook.infradead.org> <20090111181307.GM26290@one.firstfloor.org> <alpine.LFD.2.00.0901111114230.6528@localhost.localdomain> <20090111201427.GP26290@one.firstfloor.org> <1231704939.25018.548.camel@macbook.infradead.org>
 <20090111203441.GQ26290@one.firstfloor.org> <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain> <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain>
 <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain> <496BA036.3010101@t-online.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Jan 2009, Bernd Schmidt wrote:
> 
> However, if the compiler chooses to put them into the same stack 
> location, the RTL-based alias analysis will happily conclude (based on 
> the differing types) that the reads from A and the writes to B can't 
> possibly conflict, and some passes may end up reordering them. End 
> result: overlapping lifetimes and overlapping stack slots.  Oops.

Yes, I came to the same conclusion.

Of course, I knew a-priori that the real bug was using type-based alais 
analysis to make (statically visible) aliasing decisions, but I realize 
that there are people who never understood things like that. Sadly, some 
of them worked on gcc.

			Linus
