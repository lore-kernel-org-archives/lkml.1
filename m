Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbYLAIA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbYLAIA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 03:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYLAIAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 03:00:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49288 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbYLAIAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 03:00:48 -0500
Date: Mon, 1 Dec 2008 09:00:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest@ozlabs.org, Avi Kivity <avi@redhat.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>, jeremy@xensource.com,
       LKML <linux-kernel@vger.kernel.org>, Mike Travis <travis@sgi.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Lguest] [PATCH RFC/RFB] x86_64, i386: interrupt dispatch
	changes
Message-ID: <20081201080023.GD27768@elte.hu>
References: <20081104150729.GC21470@localhost> <20081129154516.GA26579@mailshack.com> <49318871.8010501@redhat.com> <200812011502.37170.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812011502.37170.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Sunday 30 November 2008 04:52:41 Avi Kivity wrote:
> > Alexander van Heukelum wrote:
> > > I now did the benchmarks for the same -rc6 with hpa's 4-byte stubs
> > > too. Same machine. It's significantly better than the other two
> > > options in terms of speed. It takes about 7% less cpu to handle
> > > the interrupts. (0.64% cpu instead of 0.69%.) I have to run now,
> > > I'll let interpreting the histogram to someone else ;).
> >
> > This is noise. 0.05% cpu on a 1GHz machine servicing 1000 interrupt/sec
> > boils down to 500 cycles/interrupt.  These changes shouldn't amount to
> > so much (and I doubt you have 1000 interrupts/sec with a single disk)..
> 
> Sure, but smallest cache wins.  Which is why I thought hpa chose the 3 byte 
> option.
> 
> > I'm sorry, but the whole effort is misguided, in my opinion.
> 
> Respectfully disagree.  I wouldn't do it, but it warms my heart that 
> others are.  It's are not subtractive from other optimization efforts.

Yeah, the efforts from Alexander, Peter and Cyrill are fantastic.

The most positive effects of it isnt just the optimizations and code 
compression. What is important is the fact that this piece of code 
(entry_*.S) has not gotten systematic attention for a decade, and has 
become a rather crufty patchwork of hit-and-run changes. It has become 
very hard to review and it has become a reoccuring source of nasty bugs.

It is now being reworked and re-measured. It does not matter how small 
and hard to measure the gain is in one specific case - we are mainly 
concerned about not creating measurable _harm_, and we are after the 
cleanups and the increase in maintainability. Once the code is cleaner, 
improvements are much easier to do and bugs are much easier to fix.

	Ingo
