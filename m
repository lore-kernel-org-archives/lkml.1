Return-Path: <linux-kernel-owner+w=401wt.eu-S1762562AbYBLRBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762562AbYBLRBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 12:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758691AbYBLRBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 12:01:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43718 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760082AbYBLRBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 12:01:31 -0500
Date: Tue, 12 Feb 2008 18:01:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212170110.GA31428@elte.hu>
References: <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu> <alpine.LFD.1.00.0802120829410.2920@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802120829410.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> In other words, is it perhaps possible to just *get*rid*of* that 
> "kgdb_active" and "nmicallback" and the whole multi-CPU roundup? Just 
> use a kgdb spinlock around the stuff that actually sends and receives 
> individual packets, and expect the debugger side to sort them out 
> (yeah, I suspect this involves having to add the CPU ID to each 
> packet).

i actually think that the notion of "stopping all system state" is 
rather intuitive from a debugging POV: when you have a bug trigger 
somewhere then getting an NMI to all CPUs and stopping them dead in 
their tracks preserves us the system in its most useful state.

also, when using kgdb to "look at system state" it's best to have as 
little "unrelated" activity as possible.

the timeout argument brought up by Andi was IMO really just pulled here 
by its hair, it never happened to me in practice and i was surprised it 
even came up. (i never before saw "KGDB roundup" fail - and i tried it 
on an 8-way system too) I think the memory-access routine cleanups were 
far more interesting from a failure scenario POV. Maybe Andrew could 
shed some light on his experience and preference here - he's been using 
KGDB for many years.

	Ingo
