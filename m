Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbYHHMvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbYHHMvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 08:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYHHMvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 08:51:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65002 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYHHMvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 08:51:37 -0400
Date: Fri, 8 Aug 2008 08:51:34 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/5] ftrace: enable mcount recording for modules
In-Reply-To: <200808081643.51942.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.1.10.0808080849020.19865@gandalf.stny.rr.com>
References: <20080807182013.984175558@goodmis.org> <20080807182117.136812885@goodmis.org> <200808081643.51942.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 8 Aug 2008, Rusty Russell wrote:

> On Friday 08 August 2008 04:20:16 Steven Rostedt wrote:
> > This patch enables the loading of the __mcount_section of modules and
> > changing all the callers of mcount into nops.
> >
> > The modification is done before the init_module function is called, so
> > again, we do not need to use kstop_machine to make these changes.
> 
> Importantly, before parameter parsing too (which can use module functions 
> before the module's init()).

It happens before "module_finalize", so I'm guessing it is also before 
parameter passing.

Even if we did it after parameter passing, as long as the code does not 
run on another CPU we are fine. Unless the module is setting up interrupt 
handlers or kicking off kernel threads, doing the change after parameter 
passing would not hurt.

But it looks like we are doing it before that anyway, so it is not an 
issue.

Thanks,

-- Steve

