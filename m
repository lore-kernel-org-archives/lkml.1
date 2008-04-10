Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbYDJJsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbYDJJsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 05:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbYDJJsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 05:48:12 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4523 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbYDJJsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 05:48:11 -0400
Date: Thu, 10 Apr 2008 10:46:37 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, akpm@osdl.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       pinskia@gcc.gnu.org
Subject: Re: [PATCH] pop previous section in alternative.c
Message-ID: <20080410094637.GW17915@shadowen.org>
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com> <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com> <47FD5D42.5000603@zytor.com> <87wsn6m6zt.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wsn6m6zt.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 10:47:18AM +0200, Andi Kleen wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> >>>
> >> Oh, and this would not be complete without giving Andrew Pinski
> >> complete
> >> credit for telling me it wasn't a gcc bug but a bug in the toplevel asm
> >> code in the kernel. ;-)
> 
> We've actually had such bugs before, it isn't the first time.
> 
> >
> > In many ways it's kind of silly for this even to be in assembly, since
> > all it is is a sequence of comma-separated byte values; I guess it was
> > the easiest way to deal with it given the ".byte" prefix, but still...
> 
> The nops are primarily used in inline assembler statements (in alternative)
> and only once in this table. Not using this would have meant to write
> them all twice which would have been nasty. There is also no sane 
> way to get standard arrays into inline assembler as instructions.
> 
> BTW it looks like the problem was added with 121d7bf5a246d282ba91234d03a4edf9ccc9c940,
> signed off by me, sorry for not catching it in review.
> 
> Perhaps that is something that would make sense adding to checkpatch.pl?
> Complain for .section in inline assembler without .previous or popsection
> (cc Andy). I think such a check would make sense. 

Do you have an example of such a bad thing?  My only concern is this
sounds like a check which could potentially need to see more lines than are
available in the patch context and so the test might be rather unreliable.

-apw
