Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbYDTWeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbYDTWeF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 18:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYDTWdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 18:33:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37207 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbYDTWdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 18:33:54 -0400
Date: Sun, 20 Apr 2008 15:33:18 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Daniel Hazelton <dhazelton@enter.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420153318.553e5d2d@laptopd505.fenrus.org>
In-Reply-To: <480BA12A.4000307@firstfloor.org>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	<20080420104444.GI1595@cs181133002.pp.htv.fi>
	<87y778aezh.fsf@basil.nowhere.org>
	<200804201144.33308.dhazelton@enter.net>
	<480B7CB2.3080002@firstfloor.org>
	<20080420114845.77bf3fed@laptopd505.fenrus.org>
	<480BA12A.4000307@firstfloor.org>
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

On Sun, 20 Apr 2008 22:01:46 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> 
> 
> > These are real customer workloads; java based "many things going
> > on" at a time showed several thousands of threads fin the system (a
> > dozen or two per request, multiplied by the number of outstanding
> > connections) for *real customers*.
> 
> Several thousands or 50k? Several thousands sounds large, but not
> entirely unreasonable, but it is far from 50k.

it is you who keeps putting up the 50k argument.
What I'm talking about is in the 10k to 20k range; and that is actual workloads
by real customers.
> 
> > That you don't take that serious, fair, you can take serious
> > whatever you want.
> 
> No I don't take 50k threads on 32bit serious. And I hope you do not
> either.

[ removed a bunch of stuff about 50k again ]

> 
> > was the observation that fragmentation is fundamentally unsolvable.
> 
> Where was that observation? 

it was in the commit message from me you quoted, and was rather widely discussed at the time.
It's also basic math; the Linux VM gets to deal with both short and long lasting allocations;
no matter how hard you try to get some degree of fragmentation; especially due to the
15:1 acceleration you get due to the lowmem issue.

And before you say "you should use 64 bit on such machines"; I would love it if more people used 64 bit linux.
Sadly the adoption rate of that is not very good still.... by far ;(

> 
> > Yes 2.4 sucked a lot more than 2.6 does. But even 2.6 will (and
> > does) have fragmentation issues. We don't have effective physical
> > address based reclaim yet for higher order allocs.
> 
> I don't see any evidence that there are serious order 1 fragmentation 
> issues on 2.6. 

I assume you're not asking me to give you customer confidential data from a previous job in public ;)

>If you have any please post it.

just like you're posting the evidence that 4k stacks overflows?

Google scores:

1-order allocation failed		54000 pages
do_IRQ: stack overflow			4560 pages


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
