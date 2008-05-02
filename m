Return-Path: <linux-kernel-owner+w=401wt.eu-S1760336AbYECIJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336AbYECIJw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 04:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYECIJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 04:09:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33327 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYECIJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 04:09:37 -0400
Date: Fri, 2 May 2008 03:09:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: a.p.zijlstra@chello.nl, efault@gmx.de, elendil@planet.nl,
       parag.warudkar@gmail.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       guichaz@yahoo.fr, andi@firstfloor.org
Subject: Re: 'global' rq->clock
Message-ID: <20080502030930.6098d8ff@infradead.org>
In-Reply-To: <20080502.144827.158329188.davem@davemloft.net>
References: <200805022053.24779.elendil@planet.nl>
	<1209756423.4693.8.camel@marge.simson.net>
	<1209758186.6929.18.camel@lappy>
	<20080502.144827.158329188.davem@davemloft.net>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 May 2008 14:48:27 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri, 02 May 2008 21:56:26 +0200
> 
> > Ok, the the below would need something that relates
> > tick_timestamp's to one another.. probably sucks without it..
> > 
> > OTOH, Andi said he was working on a fastish global sched_clock()
> > thingy, Andi got a link to that code?
> 
> While I'm fine with this kind of stuff being added to constantly cope
> with x86's joke of a TSC register implementation, it's starting to
> become an enormous burdon for platforms where the TICK source actually
> works properly.

it's a sad affair indeed. On some systems it counts cycles, on other
systems it counts time. On most systems it stops while idle, on others
it keeps running. On most systems its not very synchronized between
packages, and on some systems it's not even synchronized between cores.

I'm not convinced TSC is the right thing for the scheduler in the first
place; on current x86 systems TSC counts "time" not "work done". Now of
course "time" is an approximation for "work done", but not a very good
one given the presence of what effectively is variable cpu speeds
(software CPU frequency control is only part of that; there's also the
finegrained hardware level frequency control as done by what marketing
people call "Intel Dynamic Acceleration technology"). [*]

I and others have talked to Peter about this already, and I'm sure we'll
talk more about it in the future as well.. at some point this part of
CFS needs to fundamentally be cleaned up. Since this gets into a debate 
about what fairness means ;(




[*] The converse is also true; cycles aren't a good representation of
time either; this makes cycle based profilers a bit iffy if you're
interested in where the system spends time rather than where it spends
cycles.
