Return-Path: <linux-kernel-owner+w=401wt.eu-S932717AbYDPPc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbYDPPc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 11:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932315AbYDPPcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 11:32:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36429 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbYDPPcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:32:50 -0400
Date: Wed, 16 Apr 2008 08:32:19 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       prasad@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080416083219.0f54a22b@laptopd505.fenrus.org>
In-Reply-To: <20080416144814.GA15554@Krystal>
References: <20080415123233.GA19797@Krystal>
	<1208264190.6395.21.camel@twins>
	<20080415131744.GA5248@elte.hu>
	<20080415134705.GB22351@Krystal>
	<20080415164814.GA15842@elte.hu>
	<20080415213832.GC7873@Krystal>
	<20080416131751.GI6304@elte.hu>
	<20080416064630.22428aea@laptopd505.fenrus.org>
	<20080416140009.GA13968@Krystal>
	<20080416072416.7b9ff3d2@laptopd505.fenrus.org>
	<20080416144814.GA15554@Krystal>
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

On Wed, 16 Apr 2008 10:48:14 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Arjan van de Ven (arjan@infradead.org) wrote:
> > On Wed, 16 Apr 2008 10:00:09 -0400
> > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > 
> > > > > > If we want to support NMI context and have the ability to
> > > > > > instrument preemptable code without too much headache, we
> > > > > > must insure that every modification will leave the code in a
> > > > > > "correct" state and that we do not grow the size of any
> > > > > > reachable instruction.  Also, we must insure gcc did not put
> > > > > > code between these instructions. Modifying non-relocatable
> > > > > > instructions would also be a pain, since we would have to
> > > > > > deal with instruction pointer relocation in the breakpoint
> > > > > > code when the code modification is being done.
> > > > 
> > > > you also need to make sure no cpu is executing that code ever.. 
> > > > but you already deal with that right?
> > > > 
> > > 
> > > By "insure that every modification will leave the code in a
> > > "correct" state", I mean that at any given time before, during or
> > > after the code modification, if an NMI comes on any CPU and try
> > > to run the modified code, it should have a valid version of the
> > > code to execute. Does it make more sense ?
> > 
> > I understand your words. My concern is that I don't quite
> > understand how you guarantee that you'll not be executing the code
> > you're modifying. Just saying "it's consistent before and after"
> > sounds nice but probably isn't enough to be safe.
> > 
> Ah, I see. I insert a breakpoint and execute a bypass rather than the
> code being modified. I only put back the 1st instruction byte after
> the rest of the instruction has been modified.

sorry but I'm not convinced that that is safe without a real exclusion mechanism.
