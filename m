Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbYDJOsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbYDJOsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756259AbYDJOsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:48:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755985AbYDJOsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:48:31 -0400
Date: Thu, 10 Apr 2008 07:46:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Steven Rostedt <rostedt@goodmis.org>, Andy Whitcroft <apw@shadowen.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       pinskia@gcc.gnu.org
Subject: Re: [PATCH] pop previous section in alternative.c
In-Reply-To: <20080410144114.GH10019@one.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0804100741430.3143@woody.linux-foundation.org>
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com> <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com> <47FD5D42.5000603@zytor.com> <87wsn6m6zt.fsf@basil.nowhere.org> <20080410094637.GW17915@shadowen.org> <Pine.LNX.4.58.0804101007510.5673@gandalf.stny.rr.com>
 <20080410144114.GH10019@one.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Apr 2008, Andi Kleen wrote:
> 
> So in summary valid section patterns are either
> .section / .previous or .pushsection .section .popsection

The thing is, we'd be much better off with some sanity checking in the 
assembler.

Which is likely not going to happen - oh well.

In particular, the assembler should see patterns like

	.size function, .-function

and it should be _trivially_ able to check that "." and "function" are in 
the same section, and warn if they aren't. Because I don't see how it 
could ever be valid to have sizes that cross section boundaries (it's a 
totally nonsensical concept).

But it doesn't. Oh, well.

But maybe we can see it in the resulting object file somehow, and do the 
check there (the same way we do the init-section analysis). I assume the 
.size directive writes some debug info or similar, and we can create a big 
warning when a size is unexpectedly huge and crosses section size 
boundaries?

			Linus
