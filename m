Return-Path: <linux-kernel-owner+w=401wt.eu-S965879AbXCLONC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965879AbXCLONC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:13:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965883AbXCLONB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:13:01 -0400
Received: from thunk.org ([69.25.196.29]:35611 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965879AbXCLONA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:13:00 -0400
Date: Mon, 12 Mar 2007 10:12:14 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, npiggin@suse.de, drepper@redhat.com,
       oleg@tv-sign.ru, sebastien.dugue@bull.net, linux-kernel@vger.kernel.org
Subject: Re: [patch] change futex_wait() to hrtimers
Message-ID: <20070312141214.GG4372@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
	mm-commits@vger.kernel.org, npiggin@suse.de, drepper@redhat.com,
	oleg@tv-sign.ru, sebastien.dugue@bull.net,
	linux-kernel@vger.kernel.org
References: <200703110814.l2B8EaI1007615@shell0.pdx.osdl.net> <20070312011259.3834A1801C4@magilla.sf.frob.com> <20070312091006.GF21024@elte.hu> <p73bqiyaehp.fsf@bingen.suse.de> <1173697220.13341.84.camel@localhost.localdomain> <20070312105826.GB11864@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312105826.GB11864@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 11:58:26AM +0100, Andi Kleen wrote:
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
> multiple processes will be somewhat batched. With a precise wakeup you'll
> get wakeups all over the jiffies period, won't you?

What we probably need in the long-term, and not just for high
precision wakeups, is we need a way for waiters (either in the kernel
or in userspace) to specify a desired precision in their timers.  Is
it, "wake me up in a second, exactly", or "wake me up in a second,
plus or minus 10ms"?   (or 50ms?  or 100ms?).

This becomes especially important if we want the tickless code to
really shine as far as power management is concerned.  Unfortunately,
the POSIX timer abstraction doesn't give this kind of flexibility
easily, so it's going to be a while before we see significant
userspace adoption of such a kernel feature, but I think it's
something that would be still worthwhile to add.

Regards,

						- Ted
