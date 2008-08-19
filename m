Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbYHSCBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbYHSCBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 22:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYHSCAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 22:00:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:53368 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbYHSCAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 22:00:53 -0400
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Scott Wood <scottwood@freescale.com>, Eran Liberty <liberty@extricom.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <alpine.DEB.1.10.0808181425090.796@gandalf.stny.rr.com>
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com>
	 <48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal>
	 <48A9AFA7.8080508@freescale.com>
	 <alpine.DEB.1.10.0808181425090.796@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 11:53:34 +1000
Message-Id: <1219110814.8062.2.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 14:27 -0400, Steven Rostedt wrote:
> 
> On Mon, 18 Aug 2008, Scott Wood wrote:
> 
> > Mathieu Desnoyers wrote:
> > >         asm volatile (
> > >                 "1: lwz         %1, 0(%2)\n"
> > >                 "   cmpw        %1, %5\n"
> > >                 "   bne         2f\n"
> > >                 "   stwu        %3, 0(%2)\n"
> > >                 "2:\n"
> > >                 ".section .fixup, \"ax\"\n"
> > >                 "3:     li %0, 1\n"
> > >                 "       b 2b\n"
> > >                 ".previous\n"
> > >                 ".section __ex_table,\"a\"\n"
> > >                 _ASM_ALIGN "\n"
> > >                 _ASM_PTR "1b, 3b\n"
> > >                 ".previous"
> > >                 : "=r"(faulted), "=r"(replaced)
> > >                 : "r"(ip), "r"(new),
> > >                   "0"(faulted), "r"(old)
> > >                 : "memory");
> > 
> > Some (most likely unrelated) nits in the above inline asm:


Why not use __get_user/__put_user ?

Cheers,
Ben.


