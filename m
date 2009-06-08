Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbZFHWDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbZFHWDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 18:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbZFHWC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 18:02:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45181 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbZFHWC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 18:02:57 -0400
Date: Tue, 9 Jun 2009 00:02:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH v3] printk: add halt_delay parameter for printk delay
	in halt phase
Message-ID: <20090608220253.GD22049@elte.hu>
References: <a8e1da0906080040k7852f770v1e2aa2ebb0f52369@mail.gmail.com> <20090608081439.GB6372@elte.hu> <20090608012845.9c428525.akpm@linux-foundation.org> <a8e1da0906080142u62a45c47g2181a79addfb6168@mail.gmail.com> <20090608084807.GE6372@elte.hu> <20090608092607.8b331bf0.akpm@linux-foundation.org> <20090608171501.GA15399@elte.hu> <20090608143913.749e19c5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608143913.749e19c5.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 8 Jun 2009 19:15:01 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > questions: is it possible for interrupts to be disabled at this 
> > > time? If so, can we get an NMI watchdog hit?
> > 
> > no, we generally turn off the nmi watchdog during shutdown, 
> > disable the lapic and io-apic, etc.
> 
> Is x86 the only architecture which implements an NMI watchdog?

Sparc64 does too IIRC.

> > > Is the softlockup detector still running and if so, can it 
> > > trigger?
> > 
> > in (non-emergency) reboot, last i checked, we stopped all other 
> > CPUs first, and then killed the current one. There's no chance 
> > for the watchdog thread to run.
> 
> OK, but...  See below.
> 
> > Anyway ... you seem to be uncomfortable about this patch - 
> > should i delay it for now to let it all play out? We are close 
> > to the merge window.
> 
> I'm OK - I'm just bouncing ideas and questions off you guys, to 
> make sure that we've thought this through all the way.
> 
> Here's another: why is it a boot option rather than a 
> runtime-tunable? A /proc tweakable is generally preferable because 
> it avoids the oh-crap-i-forgot-to-edit-grub.conf thing.  And we 
> could perhaps then remove all those system_state tests: userspace 
> sets printk_delay immediately prior to running halt/reboot/etc?
> 
> Plus the feature becomes more general - perhaps there are use 
> cases where people want to slow down printks, such as: kernel goes 
> oops, data scrolls off, serial console/netconsole unavailable.  
> pause_on_oops is supposed to help here but last time I tried it, 
> it kinda didn't work, plus pause_on_oops doesn't solve the 
> data-scrolled-off problem.
> 
> Thirdly, if we do this as a general /proc/printk_delay thing, 
> perhaps it can be consolidated with the existing boot_delay= 
> implementation.

Consolidatig with the existing boot delay implementation was one of 
my first suggestions.

The /proc thing definitely makes sense - the boot option was just 
symmetry to the existing boot-delay approach.

I've unapplied this patch - i agree that it needs a bit more work 
and i dont want to hold up other changes in the core/printk branch.

	Ingo
