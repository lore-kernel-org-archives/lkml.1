Return-Path: <linux-kernel-owner+w=401wt.eu-S1762408AbYBLRLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762408AbYBLRLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 12:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759259AbYBLRLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 12:11:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41613 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758160AbYBLRLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 12:11:30 -0500
Date: Tue, 12 Feb 2008 18:10:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212171027.GA5160@elte.hu>
References: <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu> <alpine.LFD.1.00.0802120829410.2920@woody.linux-foundation.org> <20080212170110.GA31428@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212170110.GA31428@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > In other words, is it perhaps possible to just *get*rid*of* that 
> > "kgdb_active" and "nmicallback" and the whole multi-CPU roundup? 
> > Just use a kgdb spinlock around the stuff that actually sends and 
> > receives individual packets, and expect the debugger side to sort 
> > them out (yeah, I suspect this involves having to add the CPU ID to 
> > each packet).
> 
> i actually think that the notion of "stopping all system state" is 
> rather intuitive from a debugging POV: when you have a bug trigger 
> somewhere then getting an NMI to all CPUs and stopping them dead in 
> their tracks preserves us the system in its most useful state.

on a second thought - i actually think it's rather possible and 
straightforward to do what you suggest. Stopping of all CPUs is still 
useful, but should be an optional property. I'll play with this a bit 
and see how GDB reacts.

	Ingo
