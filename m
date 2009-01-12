Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbZALXU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbZALXU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 18:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755674AbZALXUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 18:20:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136AbZALXUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 18:20:40 -0500
Date: Mon, 12 Jan 2009 15:19:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jamie Lokier <jamie@shareable.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
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
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement
 adaptive spinning
In-Reply-To: <20090112230117.GC26430@shareable.org>
Message-ID: <alpine.LFD.2.00.0901121515560.6528@localhost.localdomain>
References: <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain> <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain> <20090112005228.GS26290@one.firstfloor.org>
 <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain> <20090112193201.GA23848@one.firstfloor.org> <496B9890.1090002@zytor.com> <alpine.LFD.2.00.0901121143070.6528@localhost.localdomain>
 <20090112230117.GC26430@shareable.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Jan 2009, Jamie Lokier wrote:
> 
> Sometimes code motion makes code faster and/or smaller but use more
> stack space.  If you want to keep the stack use down, it blocks some
> other optimisations.

Uhh. Yes. Compiling is an exercise in trade-offs.

That doesn't mean that you should try to find the STUPID trade-offs, 
though.

The thing is, there is no excuse for gcc's stupid alias analysis. Other 
compilers actually take advantage of things like the C standards type 
alias ambiguity by (a) realizing that it's insane as a general thing and 
(b) limiting it to the real special cases, like assuming that pointers to 
floats and pointers to integers do not alias.

That, btw, is where the whole concept comes from. It should be passed off 
as an "unsafe FP optimization", where it actually makes sense, exactly 
like a lot of other unsafe FP optimizations.

			Linus
