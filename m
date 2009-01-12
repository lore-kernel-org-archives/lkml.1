Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbZALMoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbZALMoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbZALMoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:44:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46817 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbZALMoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:44:09 -0500
Date: Mon, 12 Jan 2009 13:44:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: remove byte locks
Message-ID: <20090112124401.GA31939@elte.hu>
References: <alpine.LNX.1.10.0901121247430.5377@jikos.suse.cz> <20090112120743.GC24266@elte.hu> <alpine.LNX.1.10.0901121334510.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0901121334510.5377@jikos.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3601]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Mon, 12 Jan 2009, Ingo Molnar wrote:
> 
> > > Remove byte locks implementation, which was introduced by Jeremy in 
> > > 8efcbab6 ("paravirt: introduce a "lock-byte" spinlock implementation"), 
> > > but turned out to be dead code that is not used by any in-kernel 
> > > virtualization guest (Xen uses its own variant of spinlocks implementation 
> > > and KVM is not planning to move to byte locks).
> > > 
> > > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > > ---
> > >  arch/x86/include/asm/paravirt.h      |    2 -
> > >  arch/x86/include/asm/spinlock.h      |   66 +--------------------------------
> > >  arch/x86/kernel/paravirt-spinlocks.c |   10 -----
> > >  3 files changed, 2 insertions(+), 76 deletions(-)
> > didnt you send a patch in this lkml thread:
> > 
> >   Subject: Re: Is 386 processor still supported?
> 
> > that makes use of byte-locks on i386 ?
> 
> I did, but that patch was bogus, as we indeed don't support smp on M386.
> 
> This is totally independent -- it just removes dead code (byte locks) that 
> has no in-tree user at all.
> 
> > But i guess we should solve M386 and M486 by only allowing it on !SMP, 
> > hence spinlock support is moot there, right?
> 
> Agreed. But that's a different issue.

ok. Jeremy, can we apply Jiri's patch or do you still have plans with that 
code?

	Ingo
