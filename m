Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbYDJQP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbYDJQP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 12:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756802AbYDJQPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 12:15:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45635 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791AbYDJQPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 12:15:46 -0400
Message-ID: <47FE3C0C.4090101@zytor.com>
Date: Thu, 10 Apr 2008 09:10:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       pinskia@gcc.gnu.org
Subject: Re: [PATCH] pop previous section in alternative.c
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com> <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com> <47FD5D42.5000603@zytor.com> <87wsn6m6zt.fsf@basil.nowhere.org> <20080410094637.GW17915@shadowen.org> <Pine.LNX.4.58.0804101007510.5673@gandalf.stny.rr.com> <20080410144114.GH10019@one.firstfloor.org> <alpine.LFD.1.00.0804100741430.3143@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0804100741430.3143@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> The thing is, we'd be much better off with some sanity checking in the 
> assembler.
> 
> Which is likely not going to happen - oh well.
> 
> In particular, the assembler should see patterns like
> 
> 	.size function, .-function
> 
> and it should be _trivially_ able to check that "." and "function" are in 
> the same section, and warn if they aren't. Because I don't see how it 
> could ever be valid to have sizes that cross section boundaries (it's a 
> totally nonsensical concept).
> 
> But it doesn't. Oh, well.
> 

Wow.  That is utterly braindamaged on the part of gas.

> But maybe we can see it in the resulting object file somehow, and do the 
> check there (the same way we do the init-section analysis). I assume the 
> .size directive writes some debug info or similar, and we can create a big 
> warning when a size is unexpectedly huge and crosses section size 
> boundaries?

I just tried it, and it output the difference across the sections, 
without any consideration that the base was different.  Didn't know one 
could write an assembler that dumb.

	-hpa

