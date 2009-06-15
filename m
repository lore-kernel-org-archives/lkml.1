Return-Path: <linux-kernel-owner+w=401wt.eu-S933463AbZFOSxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463AbZFOSxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765015AbZFOSx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:53:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56962 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762801AbZFOSx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:53:28 -0400
Date: Mon, 15 Jun 2009 20:52:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       efault@gmx.de, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [tip:perfcounters/core] x86: Add NMI types for kmap_atomic
Message-ID: <20090615185259.GK11248@elte.hu>
References: <1245077165.6800.497.camel@laptop> <Pine.LNX.4.64.0906151623570.5225@sister.anvils> <1245080486.6800.561.camel@laptop> <1245089065.13761.19316.camel@twins> <20090615181555.GA11248@elte.hu> <1245089943.13761.19334.camel@twins> <20090615182549.GD11248@elte.hu> <1245090608.13761.19349.camel@twins> <20090615184217.GG11248@elte.hu> <1245091674.6741.180.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245091674.6741.180.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2009-06-15 at 20:42 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Mon, 2009-06-15 at 20:25 +0200, Ingo Molnar wrote:
> > > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > but ... look at the APIs i propose above. We dont need _any_ 
> > > > 'types'.
> > > > 
> > > > That type enumeration is basically an open-coded allocator. If we do 
> > > > a _real_ allocator (a balanced stack of atomic kmaps) we dont need 
> > > > any of those indices, and all the potential for mismatch goes away 
> > > > as well - a stack nests trivially with IRQ and NMI and arbitrary 
> > > > other contexts.
> > > 
> > > You want types because:
> > >  - they encode the intent, and can be verified
> > >  - they help keep track of the max nesting depth
> > > 
> > > In the proposed implementation all type code basically falls away 
> > > no ! CONFIG_DEBUG_VM, but is kept around for robustness.
> > 
> > But much of the fragility of the types (and their clumsiness - for 
> > example in highpte ops we have to know at which level of the 
> > pagetables we are, and use the right kind of index) is _precisely_ 
> > because we have the types ...
> 
> How will you manage the max depth?

	if (++depth == MAX_DEPTH) {
		print_all_entries_and_nasty_warning();
		 /* hope we'll live long enough for the syslog to touch disk */
		depth = 0;
	}

unbalanced kmap is a bad bug - the easier we make it to catch, the 
better. The system wouldnt survive anyway.

	Ingo
