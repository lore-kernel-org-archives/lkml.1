Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbYDJOLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbYDJOLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbYDJOLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:11:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49696 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083AbYDJOLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:11:33 -0400
Date: Thu, 10 Apr 2008 10:11:30 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andy Whitcroft <apw@shadowen.org>
cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, akpm@osdl.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       pinskia@gcc.gnu.org
Subject: Re: [PATCH] pop previous section in alternative.c
In-Reply-To: <20080410094637.GW17915@shadowen.org>
Message-ID: <Pine.LNX.4.58.0804101007510.5673@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com>
 <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com> <47FD5D42.5000603@zytor.com>
 <87wsn6m6zt.fsf@basil.nowhere.org> <20080410094637.GW17915@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Apr 2008, Andy Whitcroft wrote:
> >
> > BTW it looks like the problem was added with 121d7bf5a246d282ba91234d03a4edf9ccc9c940,
> > signed off by me, sorry for not catching it in review.
> >
> > Perhaps that is something that would make sense adding to checkpatch.pl?
> > Complain for .section in inline assembler without .previous or popsection
> > (cc Andy). I think such a check would make sense.
>
> Do you have an example of such a bad thing?  My only concern is this
> sounds like a check which could potentially need to see more lines than are
> available in the patch context and so the test might be rather unreliable.
>

>From commit 121d7bf5a246d282ba91234d03a4edf9ccc9c940:

    get them easily into strings. */
-asm("\t.data\nintelnops: "
+asm("\t.section .rodata, \"a\"\nintelnops: "
        GENERIC_NOP1 GENERIC_NOP2 GENERIC_NOP3 GENERIC_NOP4 GENERIC_NOP5 GENERIC
        GENERIC_NOP7 GENERIC_NOP8);
-extern unsigned char intelnops[];


I would say anytime there's a "^+.*\.section" there had better be a
"^-.*\.section" or a "+.*.previous" matching it. Off hand I can't think of
any exceptions to this rule although I may be wrong.

-- Steve


