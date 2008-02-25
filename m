Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbYBYV0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbYBYV0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:26:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYBYVZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:25:51 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34445 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751187AbYBYVZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:25:50 -0500
Date: Mon, 25 Feb 2008 22:26:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression
	in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
Message-ID: <20080225212615.GA2659@elf.ucw.cz>
References: <8f53421d0802251119q470a79c1p31048ef136271f84@mail.gmail.com> <20080225114611.d91791f6.akpm@linux-foundation.org> <8f53421d0802251245j5439b37die840e34bb293f995@mail.gmail.com> <200802252157.10412.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802252157.10412.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On Monday, 25 of February 2008, Michael S. Tsirkin wrote:
> > On Mon, Feb 25, 2008 at 9:46 PM, Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> > > On Mon, 25 Feb 2008 21:19:24 +0200 "Michael S. Tsirkin" <m.s.tsirkin@gmail.com> wrote:
> > >
> > >  > On my T61p, 2.6.25-rc2 seems to get acpi events from keypresses
> > >  > such as Fn-F4 and lid open/close, prints them in /var/log/acpid
> > >  > and reacts accordingly (my acpi scripts suspend on lid close and Fn-F4).
> > >
> > >  You mean suspend-to-ram works correctly on your t61p?
> > >
> > >  Mine suspends, then five seconds later magically resumes itself and the
> > >  screen is all black.
> > 
> > Sorry, have not noticed what you were asking about.
> > Yes, rc2 seems to suspend/resume fine.
> > 
> > And after reverting
> > 
> >      revert commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2.
> 
> commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2
> Author: Pavel Machek <pavel@ucw.cz>
> Date:   Thu Feb 21 13:56:55 2008 +0100
> 
>     power_state: get rid of write-only variable in SATA

This is pretty unlikely to be it. Can you double check that this patch
really breaks something?

> >      revert commit 208c70a45624400fafd7511b96bc426bf01f8f5e.
> 
> commit 208c70a45624400fafd7511b96bc426bf01f8f5e
> Author: Alexey Starikovskiy <astarikovskiy@suse.de>
> Date:   Thu Feb 14 15:58:47 2008 -0500
> 
>     ACPI: EC: Use proper handle for boot EC
> 
> > r3 does, too.
> 
> Please, _please_ always add commit subjects to your reports.  Also, please
> include the names of the authors of the commits that turn out to break things
> and send CCs to them.
> 
> It won't hurt to send CCs to the people who signed those commits off, too.

Hmm, as EC is the piece of hw that does the wakeups, yes, EC might be
responsible for autowaking.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
