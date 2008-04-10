Return-Path: <linux-kernel-owner+w=401wt.eu-S1758538AbYDJOnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538AbYDJOnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbYDJOnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:43:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33531 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbYDJOnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:43:41 -0400
Date: Thu, 10 Apr 2008 10:43:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: Andy Whitcroft <apw@shadowen.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, akpm@osdl.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       pinskia@gcc.gnu.org
Subject: Re: [PATCH] pop previous section in alternative.c
In-Reply-To: <20080410144114.GH10019@one.firstfloor.org>
Message-ID: <Pine.LNX.4.58.0804101041430.5673@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com>
 <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com> <47FD5D42.5000603@zytor.com>
 <87wsn6m6zt.fsf@basil.nowhere.org> <20080410094637.GW17915@shadowen.org>
 <Pine.LNX.4.58.0804101007510.5673@gandalf.stny.rr.com>
 <20080410144114.GH10019@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 10 Apr 2008, Andi Kleen wrote:

> > I would say anytime there's a "^+.*\.section" there had better be a
> > "^-.*\.section" or a "+.*.previous" matching it. Off hand I can't think o
> > any exceptions to this rule although I may be wrong.
>
>
> Second section is wrong because the compiler expects that the same
> section is active afterwards and that can be different ones (like
> init.text vs normal text)

No the second section in my example is not wrong, because it starts with a
"-", which in a patch would be a replacement of one .section with another,
not an addition of two sections.

>
> Also pushsection/popsection is also valid
>
> So in summary valid section patterns are either
> ..section / .previous or .pushsection .section .popsection

But you are right with this part. Yeah, either a .section is replaced, or
is added with a .previous, or is encapsulated with push and popsections.

-- Steve

