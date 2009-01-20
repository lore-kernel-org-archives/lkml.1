Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbZATEGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbZATEGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 23:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZATEGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 23:06:41 -0500
Received: from [213.235.205.2] ([213.235.205.2]:57896 "EHLO one.firstfloor.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754417AbZATEGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 23:06:39 -0500
Date: Tue, 20 Jan 2009 05:20:48 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
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
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Message-ID: <20090120042048.GA15750@one.firstfloor.org>
References: <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain> <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain> <20090112193201.GA23848@one.firstfloor.org> <alpine.LFD.2.00.0901121128080.6528@localhost.localdomain> <496BBE27.2020206@t-online.de> <20090119001345.GA9880@elte.hu> <20090119062212.GC22584@wotan.suse.de> <alpine.LFD.2.00.0901200754100.2974@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901200754100.2974@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem with 'restrict' is that almost nobody uses it, and it does 

Also gcc traditionally didn't do a very good job using it (this
might be better in the very latest versions). At least some of the 3.x
often discarded this information. 

> automatically. But it should work well as a way to get Fortran-like 
> performance from HPC workloads written in C - which is where most of the 
> people are who really want the alias analysis.

It's more than just HPC  -- a lot of code has critical loops.

> > it seems like a nice opt-in thing that can be used where the aliases are 
> > verified and the code is particularly performance critical...
> 
> Yes. I think we could use it in the kernel, although I'm not sure how many 
> cases we would ever find where we really care. 

Very little I suspect. Also the optimizations that gcc does with this
often increase the code size. While that can be a win, with people
judging gcc's output apparently *ONLY* on the code size as seen
in this thread[1] it would obviously not compete well.

-Andi 

[1] although there are compilers around that generate smaller code
than gcc at its best.

-- 
ak@linux.intel.com -- Speaking for myself only.
