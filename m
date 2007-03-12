Return-Path: <linux-kernel-owner+w=401wt.eu-S965548AbXCLLEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965548AbXCLLEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965547AbXCLLEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:04:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36628 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965538AbXCLLEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:04:39 -0400
Date: Mon, 12 Mar 2007 12:04:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mm-commits@vger.kernel.org, npiggin@suse.de,
       drepper@redhat.com, oleg@tv-sign.ru, sebastien.dugue@bull.net,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] change futex_wait() to hrtimers
Message-ID: <20070312110417.GA12308@elte.hu>
References: <200703110814.l2B8EaI1007615@shell0.pdx.osdl.net> <20070312011259.3834A1801C4@magilla.sf.frob.com> <20070312091006.GF21024@elte.hu> <p73bqiyaehp.fsf@bingen.suse.de> <1173697220.13341.84.camel@localhost.localdomain> <20070312105826.GB11864@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312105826.GB11864@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Mon, Mar 12, 2007 at 12:00:20PM +0100, Thomas Gleixner wrote:
> > On Mon, 2007-03-12 at 12:27 +0100, Andi Kleen wrote:
> > > Ingo Molnar <mingo@elte.hu> writes:
> > > > 
> > > > the only correct approach is the use of hrtimers, and a patch exists for 
> > > > that - see below. This has been included in -rt for quite some time.
> > > 
> > > But isn't that bad for power management? You'll likely get more
> > > idle wakeups, won't you?
> > 
> > Why so ? It comes more precise, but only once.
> 
> When it's clustered around the jiffies interval then wakeups from 
> multiple processes will be somewhat batched. With a precise wakeup 
> you'll get wakeups all over the jiffies period, won't you?

if HIGH_RES_TIMERS is disabled then that is what happens. But frankly, 
most futex waits are without timeouts - if an application cares about 
micro-effects like that then you are much better off not using a 
per-futex timeout anyway.

	Ingo
