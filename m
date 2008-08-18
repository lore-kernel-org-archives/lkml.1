Return-Path: <linux-kernel-owner+w=401wt.eu-S1758486AbYHRSr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbYHRSr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758163AbYHRSre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:47:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40650 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbYHRSrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:47:33 -0400
Date: Mon, 18 Aug 2008 14:47:32 -0400 (EDT)
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
Message-ID: <alpine.DEB.1.10.0808181445160.796@gandalf.stny.rr.com>
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
> 
> Should use a "b" constraint for %2, or you could get r0.  Or, use an "m"
> constraint with %U2%X2 after the lwz/stw. 

What syntax to do that with?

  lwz %1,0(%U2)
  stu %3, 0(%X2)

I'm new to those. (and the above does not compile)

> Why stwu with an offset of zero,

How else to do it?  stwu %3, (%2) does not compile for me.

-- Steve

