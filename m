Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930Ab0A3Vdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab0A3Vdc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 16:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586Ab0A3Vdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 16:33:31 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:53016 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab0A3Vda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 16:33:30 -0500
Subject: Re: [RFC:PATCH 00/03] powerpc: Expose BookE debug registers
 through extended ptrace interface
From: Benjamin Herrenschmidt <benh@au1.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: prasad@linux.vnet.ibm.com, shaggy@linux.vnet.ibm.com,
       linuxppc-dev@ozlabs.org, David Gibson <dwg@au1.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100130204409.GE5675@nowhere>
References: <20100124191830.GB14075@in.ibm.com>
	 <1264365121.3601.43.camel@pasglop>  <20100130204409.GE5675@nowhere>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM Australia
Date: Sun, 31 Jan 2010 08:33:25 +1100
Message-ID: <1264887205.8287.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> We have one field for addr, one for len and one for the memory access
> type.
> 
> I think that those three are enough to express breakpoint ranges.
> Basically a breakpoint range is a breakpoint that can have a high
> len.
> 
> I've looked at the G2 PowerPc core breakpoint implementation, just to
> face one of such tricky examples.

BookE has a richer semantic. We have watchpoints with data value compare
for example, we also have instruction value compare for breakpoints, and
a few other niceties. There's also subtle differences between what
processor variants support.

 .../...

> > I'd rather have this more dedicated and more complete interface merged
> > for gdb's sake, and in a second step look at unifying.
> 
> 
> Perhaps. Supporting ptrace breakpoints should be an easy first
> step as it's basically the responsibility of the user to fill
> the registers, but it's a pretty limited scope work, especially you
> won't have perf support.

But we can add it later. 

> > I believe that the generic breakpoint infrastructure should not be the
> > mid-layer. IE. It cannot be made in any clean shape of form, to express
> > all of the subtle features that a given architecture or platform can
> > support and as such would always be inferior to a dedicated one.
> 
> 
> Actually I think the current interface already does, as I explained
> above.
> 
> What is broken for any other architectures than x86 is the set
> of constraints, but I can easily move it to the arch, unless
> I find a good generic solution (or a cool combination between
> both).

Again, this is all "can do" vs. "already done and working". May I point
you to Linus recent rant against magic infrastructures that try to do
everything and do nothing right ? :-) I much prefer starting with
something dedicated that does exactly what is expected, have that
upstream (and in that regard the patches are good for the next merge
window) and -then- maybe look at how some of it could be re-used for
perf.

> Not at all. It's an attempt to make a generic interface that can
> exploit at best _each_ arch specific features. 

That reminds me of the justifications for utrace :-) It might well be
but I very much doubt that is possible. In any case, it doesn't appear
to be there yet. So let's just get that stuff in so we have our
interface finally working, and we can look at doing fancy things with
perf in a second pass.

> Other than the set
> of constraints that I'm going to rework, the generic interface is powerful
> enough to host what I've seen in term of cpu breakpoints implementations
> for now. But if it's actually not and I'm missing other cases, please
> report it to me.
> 
> The reason that makes the current generic constraints x86
> oriented only is that I've only x86 boxes at home and I needed
> to make a first shot without knowing anything about other archs
> constraints, but in the long term, our motivations (Prasad's and mines)
> are definetely not archX-centric.

Cheers,
Ben.


