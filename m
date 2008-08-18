Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbYHRS10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbYHRS10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbYHRS1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:27:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39131 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbYHRS1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:27:17 -0400
Date: Mon, 18 Aug 2008 14:27:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Scott Wood <scottwood@freescale.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Eran Liberty <liberty@extricom.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
In-Reply-To: <48A9AFA7.8080508@freescale.com>
Message-ID: <alpine.DEB.1.10.0808181425090.796@gandalf.stny.rr.com>
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com> <48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal> <48A9AFA7.8080508@freescale.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 Aug 2008, Scott Wood wrote:

> Mathieu Desnoyers wrote:
> >         asm volatile (
> >                 "1: lwz         %1, 0(%2)\n"
> >                 "   cmpw        %1, %5\n"
> >                 "   bne         2f\n"
> >                 "   stwu        %3, 0(%2)\n"
> >                 "2:\n"
> >                 ".section .fixup, \"ax\"\n"
> >                 "3:     li %0, 1\n"
> >                 "       b 2b\n"
> >                 ".previous\n"
> >                 ".section __ex_table,\"a\"\n"
> >                 _ASM_ALIGN "\n"
> >                 _ASM_PTR "1b, 3b\n"
> >                 ".previous"
> >                 : "=r"(faulted), "=r"(replaced)
> >                 : "r"(ip), "r"(new),
> >                   "0"(faulted), "r"(old)
> >                 : "memory");
> 
> Some (most likely unrelated) nits in the above inline asm:

Thanks,

> 
> Should use a "b" constraint for %2, or you could get r0. 

I will make an updated patch.

> Or, use an "m"
> constraint with %U2%X2 after the lwz/stw. 

The 'b' seems easier ;-)

> Why stwu with an offset of zero,
> BTW?

Because it worked :-)  Really, it has been a while since I did any PPC 
assembly, and I didn't break out the old reference manuals to do this.
I simply looked at other asm code, and followed suit. I compiled and 
tested it, and it worked.  I did make a disclaimer about my rusty PPC
knowledge when I posted the code.

> 
> %1 also needs to be an early clobber.

Not exactly sure what you mean by the above.

-- Steve
