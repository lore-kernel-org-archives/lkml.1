Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbYDJOgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbYDJOgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbYDJOgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:36:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54849 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757AbYDJOgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:36:39 -0400
Date: Thu, 10 Apr 2008 16:41:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Whitcroft <apw@shadowen.org>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, akpm@osdl.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       pinskia@gcc.gnu.org
Subject: Re: [PATCH] pop previous section in alternative.c
Message-ID: <20080410144114.GH10019@one.firstfloor.org>
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com> <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com> <47FD5D42.5000603@zytor.com> <87wsn6m6zt.fsf@basil.nowhere.org> <20080410094637.GW17915@shadowen.org> <Pine.LNX.4.58.0804101007510.5673@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0804101007510.5673@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would say anytime there's a "^+.*\.section" there had better be a
> "^-.*\.section" or a "+.*.previous" matching it. Off hand I can't think o
> any exceptions to this rule although I may be wrong.


Second section is wrong because the compiler expects that the same
section is active afterwards and that can be different ones (like
init.text vs normal text)

Also pushsection/popsection is also valid

So in summary valid section patterns are either
.section / .previous or .pushsection .section .popsection

-Andi



