Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbYHOWp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbYHOWp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 18:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbYHOWpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 18:45:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752111AbYHOWpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:45:10 -0400
Date: Fri, 15 Aug 2008 15:44:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, srostedt@redhat.com
Subject: Re: [PATCH] ftrace: use only 5 byte nops for x86
In-Reply-To: <48A6037B.6030202@zytor.com>
Message-ID: <alpine.LFD.1.10.0808151542330.3324@nehalem.linux-foundation.org>
References: <alpine.DEB.1.10.0808141755030.2911@gandalf.stny.rr.com> <48A4C491.4050301@goop.org> <20080815092231.GB22209@elte.hu> <48A6037B.6030202@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Aug 2008, H. Peter Anvin wrote:

> Ingo Molnar wrote:
> > > > 
> > > > TODO: Examine the cpuid to determine the nop to use.
> > > >   
> > > Don't think that will help in general.  qemu claims its a Pentium II.
> > 
> > ok. I've applied Steve's patch as it's a good bugfix. The extra paranoia
> > about faulting on 0x90 seems excessive but doesnt hurt ;-)
> > 
> 
> I think what we need to do is to test the NOPL instruction and create a
> Linux-specific CPUID bit for it.  I'll do that and submit to tip:x86/cpu.

I also suspect that we'd really be much better off just fixing the generic 
NOP tables for the 5-byte nop. As far as I could tell, from all the 
numbers that have been posted, absolutely _none_ show that there is any 
point at all to the 2-instruction 3/2-byte sequence.

So instead of having a magic special ftrace-only thing, why not just do it 
right, and fix the generic 5-byte nop sequence?

		Linus
