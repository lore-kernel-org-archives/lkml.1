Return-Path: <linux-kernel-owner+w=401wt.eu-S936189AbYD1Q7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936189AbYD1Q7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933408AbYD1Q7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:59:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934185AbYD1Q7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:59:46 -0400
Date: Mon, 28 Apr 2008 09:58:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com
Subject: Re: [2.6 patch] fs/buffer.c:init_buffer() mustn't be inline
In-Reply-To: <20080428164807.GW2813@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0804280955120.3119@woody.linux-foundation.org>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu>
 <20080428153829.GB2813@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804280901130.3119@woody.linux-foundation.org> <20080428164807.GW2813@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Apr 2008, Adrian Bunk wrote:
> > 
> > Can somebody tell why this is not a gcc bug?
> 
> It is a gcc bug.
> 
> But having a global function marked as extern was already questionable, 
> and all assumptions an "inline" would always inline the code are anyway 
> now broken in your tree.
> 
> So let's work around a gcc bug by fixing the kernel...

But when doing this, MARK IT LOUDLY AS A GCC BUG!

The thing is, reading that log message, it was not at all clear why that 
change was made. Please make it clear why, rather than quoting a totally 
useless error message that doesn't actually tell what is going on.

I agree that having work-arounds for compiler bugs is worth it (assuming 
the version is common enough to worry about), but I also don't want to 
have unexplained commits doing something that on the face of it is just 
odd

Put another way: looking at the actual diff and looking at the commit 
message, the only sane reaction from somebody who knows the code is: 
"Whaa? WTF?". Saying "This is a gcc bug" would have turned that "WTF?" 
into a "Oh, ok then".

			Linus
