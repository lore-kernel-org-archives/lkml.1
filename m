Return-Path: <linux-kernel-owner+w=401wt.eu-S934108AbYD1TjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108AbYD1TjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764983AbYD1Tiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:38:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763088AbYD1Tix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:38:53 -0400
Date: Mon, 28 Apr 2008 12:37:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] bitops: simplify generic bit finding functions
In-Reply-To: <alpine.LFD.1.10.0804282038160.3261@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0804281233090.3119@woody.linux-foundation.org>
References: <1209327591.14173.74.camel@brick> <alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org> <alpine.LFD.1.10.0804281534530.3261@apollo.tec.linutronix.de> <alpine.LFD.1.10.0804280924270.3119@woody.linux-foundation.org>
 <alpine.LFD.1.10.0804281845250.3261@apollo.tec.linutronix.de> <alpine.LFD.1.10.0804280953570.3119@woody.linux-foundation.org> <alpine.LFD.1.10.0804282038160.3261@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Apr 2008, Thomas Gleixner wrote:
> 
> I doubt that that is worth the trouble and we should just remove those
> inlines alltogether. This was discussed before, but Andi objected to
> remove those micro optimizations and nobody had time to actually
> verify the real benefits.

Thanks for checking.

In general, I think we should act the other way: we should *assume* that 
inlines and complex macros in header files are not worth it and we'd be 
better off with just plain function calls, unless it's really obvious that 
the inline function is always worth it.

We have tons of good examples of inline functions in headers that really 
*really* want to be that way: <linux/list.h> is generally a collection of 
things that clearly expand to somthing that is (a) easily critical and (b) 
inlining things generally really causes a smaller code footprint than 
having a "call" instruction and all the argument setup - regardless of how 
many times it is done.

So we do have cases where the inlines are obviously worth it. But in 
general, I think we should try to move things from the header files into 
*.c files unless there is a really clear reason for keeping it that way.

(Some inline functions do depend on things like constant arguments goign 
away, with kmalloc() being a good example of some really nasty header file 
tricks that are likely worth it despite their extreme ugliness)

		Linus
