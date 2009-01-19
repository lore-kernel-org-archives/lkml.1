Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbZASVDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbZASVDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbZASVDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:03:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753403AbZASVDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:03:38 -0500
Date: Tue, 20 Jan 2009 08:01:52 +1100 (EST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Andi Kleen <andi@firstfloor.org>, David Woodhouse <dwmw2@infradead.org>,
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
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement
 adaptive spinning
In-Reply-To: <20090119062212.GC22584@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0901200754100.2974@localhost.localdomain>
References: <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain> <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain> <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de>
 <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain> <20090112193201.GA23848@one.firstfloor.org> <alpine.LFD.2.00.0901121128080.6528@localhost.localdomain> <496BBE27.2020206@t-online.de> <20090119001345.GA9880@elte.hu>
 <20090119062212.GC22584@wotan.suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 Jan 2009, Nick Piggin wrote:
> 
> I want to know what is the problem with the restrict keyword?
> I'm sure I've read Linus ranting about how bad it is in the
> past...

No, I don't think I've ranted about 'restrict'. I think it's a reasonable 
solution for performance-critical code, and unlike the whole type-aliasing 
model, it actually works for the _sane_ cases (ie doing some operation 
over two arrays of the same type, and letting the compiler know that it 
can access the arrays without fearing that writing to one would affect 
reading from the other).

The problem with 'restrict' is that almost nobody uses it, and it does 
obviously require programmer input rather than the compiler doing it 
automatically. But it should work well as a way to get Fortran-like 
performance from HPC workloads written in C - which is where most of the 
people are who really want the alias analysis.

> it seems like a nice opt-in thing that can be used where the aliases are 
> verified and the code is particularly performance critical...

Yes. I think we could use it in the kernel, although I'm not sure how many 
cases we would ever find where we really care. 

			Linus
