Return-Path: <linux-kernel-owner+w=401wt.eu-S1756838AbYGRKok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbYGRKok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 06:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbYGRKoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 06:44:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:58244 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbYGRKob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 06:44:31 -0400
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
	(part1: use kprobe symbol_name/offset instead of address)
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org,
       jbeulich@novell.com, arjan <arjan@infradead.org>
In-Reply-To: <488070F1.9030903@firstfloor.org>
References: <1216146802.3312.95.camel@localhost.localdomain>
	 <87ej5rsgk4.fsf@basil.nowhere.org> <1216373009.5232.130.camel@twins>
	 <488070F1.9030903@firstfloor.org>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 12:44:57 +0200
Message-Id: <1216377897.28405.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-18 at 12:31 +0200, Andi Kleen wrote:

> > But while the x86 might not be perfect, its fairly ok these days. Its
> > not the utter piece of shite x86_64 had for a long time 
> 
> Not sure what you're referring to with this. AFAIK the x86-64 unwinder
> for a normal frame pointer less kernel was not any worse (or better)
> than a i386 kernel without frame pointers.

I hardly ever compile a kernel without frame pointers, as debugability
is top priority for me, so I'm afraid I'm not sure how bad it gets
without.

But it used to be that x86_64 was crap even with frame pointers, and
without it it was just random gibberish - Arjan fixed that up somewhere
around .25 iirc.

> - today's traces
> > mostly make sense.
> 
> If you enable frame pointers? Making your complete kernel slower?
> Generating much worse code on i386 by wasting >20% of its available
> registers?  Getting pipeline stalls on each function call/exit on many CPUs?
> 
> Right now unfortunately there are a few rogue CONFIGs who select that
> so more and more kernels have, but I found that always distateful because
> enabling frame pointers has such a large impact on all kernel code, especially
> on the register starved i386.
> 
> I still think the right solution eventually is to have a dwarf2 unwinder
> by default for i386/x86-64 and get rid of all these nasty "select
> FRAME_POINTER"s which have unfortunately sneaked in.

No argument on i386 vs frame pointers, fortunately I hardly ever build a
32bit kernel these days, 32bit hardware is disappearing fast here :-) 

As to merging the dwarf unwinder, I have no particular objection to
getting that merged as I'm rather ignorant on these matters - but from
reading emails around the last merge attempt, Linus had some strong
opinions on the matter.

Have those been resolved since?

