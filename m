Return-Path: <linux-kernel-owner+w=401wt.eu-S1760109AbYDPNrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109AbYDPNrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 09:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbYDPNrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 09:47:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55526 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbYDPNrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:47:05 -0400
Date: Wed, 16 Apr 2008 06:46:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080416064630.22428aea@laptopd505.fenrus.org>
In-Reply-To: <20080416131751.GI6304@elte.hu>
References: <20080415115058.GA6788@in.ibm.com>
	<20080415115314.GA6975@in.ibm.com>
	<1208260942.6395.6.camel@twins>
	<20080415123233.GA19797@Krystal>
	<1208264190.6395.21.camel@twins>
	<20080415131744.GA5248@elte.hu>
	<20080415134705.GB22351@Krystal>
	<20080415164814.GA15842@elte.hu>
	<20080415213832.GC7873@Krystal>
	<20080416131751.GI6304@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >     4631:       b0 00                   mov    $0x0,%al
> >     4633:       84 c0                   test   %al,%al
> >     4635:       0f 85 c6 00 00 00       jne    4701

the use of partial registers here is unfortunate and probably quite expensive ;(


> > If we want to support NMI context and have the ability to
> > instrument preemptable code without too much headache, we must
> > insure that every modification will leave the code in a "correct"
> > state and that we do not grow the size of any reachable
> > instruction.  Also, we must insure gcc did not put code between
> > these instructions. Modifying non-relocatable instructions would
> > also be a pain, since we would have to deal with instruction
> > pointer relocation in the breakpoint code when the code
> > modification is being done.

you also need to make sure no cpu is executing that code ever.. 
but you already deal with that right?

> > 
> > Luckily, gcc almost never place any code between the mov, test and
> > jne instructions. But since we cannot we sure, we could dynamically
> > check for this code pattern after the mov instruction. If we find
> > it, then we play with it as if it was a single asm block, but if we
> > don't find what we expect, then we use standard immediate values
> > for that. I expect the heavily optimised version will be usable
> > almost all the time.

I expect gcc to start using the macro-fusion capable ones more and more over time at least,
and for that the compare and jmp need to be consecutive.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
