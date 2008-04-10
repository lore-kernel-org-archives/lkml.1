Return-Path: <linux-kernel-owner+w=401wt.eu-S1760510AbYDJPVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760510AbYDJPVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758129AbYDJPVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:21:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758114AbYDJPVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:21:08 -0400
Date: Thu, 10 Apr 2008 08:18:49 -0700 (PDT)
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
In-Reply-To: <20080410150544.GI10019@one.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0804100811400.3143@woody.linux-foundation.org>
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com> <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com> <47FD5D42.5000603@zytor.com> <87wsn6m6zt.fsf@basil.nowhere.org> <20080410094637.GW17915@shadowen.org> <Pine.LNX.4.58.0804101007510.5673@gandalf.stny.rr.com>
 <20080410144114.GH10019@one.firstfloor.org> <alpine.LFD.1.00.0804100741430.3143@woody.linux-foundation.org> <20080410150544.GI10019@one.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Apr 2008, Andi Kleen wrote:
> 
> A simple way to detect it on the assembler level would be checking
> that the section is the same after #NO_APP as before #APP

That would mark gcc itself as buggy, because gcc will move some things 
into the #APP/#NO_APP thing, and sometimes doesn't end the #APP at all!

Try gcc -S on this this trivial "program"

	asm("Hello world");

and at least I personally get

	        .file   "bug.c"
	#APP
	        Hello world
	        .ident  "GCC: (GNU) 4.1.2 20070925 (Red Hat 4.1.2-33)"
	        .section        .note.GNU-stack,"",@progbits

and nothing else. Note the lack of #NO_APP ;)

(I also swear I've seen code or data move _into_ the #NO_APP - ie gcc did 
eventually close the #APP section, but did it too late, after it had 
emitted other things itself - but maybe I just dreamed it because I can't 
seem to reproduce it now. Or maybe it's just a historical gcc bug that got 
fixed)

			Linus
