Return-Path: <linux-kernel-owner+w=401wt.eu-S1760388AbYBLPA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbYBLPA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759326AbYBLPAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:00:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36482 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759234AbYBLPAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:00:42 -0500
Date: Tue, 12 Feb 2008 16:36:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212153612.GA2944@one.firstfloor.org>
References: <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <47B19F67.5050105@windriver.com> <20080212143949.GA2258@one.firstfloor.org> <47B1AEC3.2080402@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B1AEC3.2080402@windriver.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Basically when you reach this chunk of code it is before the hand off
> to the source debugger.  We cannot continue because there was a
> breakpoint in a part of the system kgdb was using while doing its
> normal work.  The reality is that KGDB is not self contained.  It
> relies on some external I/O methods, atomic page fault handling and
> some other pieces.  If you take an exception there, the kgdb integrity
> check absolutely needs to fail.

Don't you just need a simple recursion counter for this? 

I cannot think of a reliable simple way to check for this using the instruction
pointer. The only way would be to use explicit annotations for all
possible code similar to what kprobes does (__kprobes), but that would be 
hugely intrusive all over the tree.

With the recursion counter the only problem would be someone 
setting a break point on the early notifier code itself that contains
a recursion check, but that would be only a few lines of code
so the risk of someone setting a break point exactly there would
be low.

> This check is absolutely required to help prevent silent death via
> dumb breakpoints or stepping around in random places (which is ill
> advised anyway).

I believe you, but I don't believe that your implementation
of this handles all cases.

-Andi
