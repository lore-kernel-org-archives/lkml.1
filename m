Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZFHOZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZFHOZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbZFHOZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:25:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48702 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbZFHOZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:25:02 -0400
Date: Mon, 8 Jun 2009 16:24:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: Run-time PM idea (was: Re: [linux-pm] [RFC][PATCH 0/2] PM:
	Rearrange core suspend code)
Message-ID: <20090608142450.GE14234@elte.hu>
References: <Pine.LNX.4.44L0.0906071651060.25203-100000@netrider.rowland.org> <200906072347.00580.rjw@sisk.pl> <20090608065419.GA13568@elte.hu> <200906081330.50045.rjw@sisk.pl> <20090608130509.GA3272@elte.hu> <20090608131159.GA15100@srcf.ucam.org> <20090608132235.GC13214@elte.hu> <20090608133215.GA15482@srcf.ucam.org> <20090608134647.GA14234@elte.hu> <20090608135431.GA16052@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608135431.GA16052@srcf.ucam.org>
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


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Mon, Jun 08, 2009 at 03:46:47PM +0200, Ingo Molnar wrote:
> > 
> > * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> > > How does the kernel know whether the user cares about SATA 
> > > hotplug or not?
> > 
> > The typical user probably doesnt know what 'SATA' means, and 
> > probably has very vague concepts about 'hotplug' as well.
> 
> eSATA is pretty common now.

[ And 99% of the CPUs have an IDT still 99.9% of the users dont know 
  what it is :) ]

> > The kernel default should be: 'yes, if the kernel feature is 
> > enabled and if the hardware can support it' (it's not on a 
> > blacklist of some sort, etc., etc.).
> 
> The problem with this kind of default is that you get people who 
> are confused that their hardware doesn't work.

If the hardware 'doesnt work' that is a kernel bug. Hardware that 
_cannot be suspended_ safely (physically) should not be 
auto-suspended, of course.

> If the kernel doesn't have enough information to make a decision 
> it should err on the side of functionality - we're talking about 
> fairly low-level power savings, but potentially several years of 
> aggregate confusion on the part of users.

the difference between a 10W and a 1W footprint is a long series of 
'low-level power savings'.

If users are getting confused and if hardware gets broken then tha's 
a plain bug and the wrong path is being walked.

> > What sources of information exactly? Again, the user wont enter 
> > anything, in 95% of the cases - in the remaining 3% of cases 
> > what is entered is wrong and only in another 2% of cases is it 
> > correct ;-)
> 
> Users are generally ok at realising correlation between a setting 
> change and something no longer working, so as long as you provide 
> that they'll be happy. I agree that this sucks. What we actually 
> want is some means of reliably identifying whether a port is 
> hotplug or not, but eSATA makes this very difficult.

Is it impossible?

> > Sure, there might be tradeoffs when a piece of hardware cannot 
> > be turned off sanely: obviously the monitor might not know it 
> > (currently) whether someone is watching it, and 
> > wake-on-packet-for-me is not commonly implemented in wireless 
> > and wired networking cards so turning off an active networking 
> > card might not be possible without the user asking allowing that 
> > imperfect mode of power saving.
> 
> These cases can all be handled with sufficiently intelligent 
> userland, so I'm not worried about them.
> 
> > ( Providing a way to _override_ those defaults is of course natural,
> >   via /sysfs, should the user express an interest in tweaking it, or
> >   should the kernel get it so wrong that a distro wants to work it
> >   around. But your argument seems to be "push configuration and
> >   handling into user-space" which is really backwards. )
> 
> My argument is "Hardware should work, and if the kernel default is 
> for it to be broken then the default is wrong". We went through 
> this for USB autosuspend. Userspace simply has more available 
> information than the kernel, and it's not just a matter of static 
> configuration (though that may be part of it). For instance, 
> Oliver's example of screensavers and USB keyboards. If nothing's 
> paying attention to volume keys (or if the keyboard doesn't have 
> any) then you can enable remote wakeup and suspend the keyboard. 
> If something /is/ paying attention to volume keys, you can't do 
> that. That's the kind of case I'm discussing.

See my reply to Oliver. This is really advocating a broken model of 
device usage. That volume key usage dependency is being hidden from 
the kernel, and then you want to kludge it around by pushing suspend 
functionality to user-space? That way lies madness. The proper way 
is to close the device if it's not used by anything. Then the kernel 
can auto-suspend it just like it could auto-suspend network 
interfaces that are not in use, or like it could auto-suspend a 
dislay port that has no monitor or other output device attached.

	Ingo
