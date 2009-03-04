Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbZCDICa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbZCDICa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 03:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZCDICW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 03:02:22 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59531 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZCDICW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 03:02:22 -0500
Date: Wed, 4 Mar 2009 09:02:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
	standard config registers of all devices early)
Message-ID: <20090304080212.GA1489@ucw.cz>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902032253.42709.rjw@sisk.pl> <1233700390.16867.97.camel@pasglop> <200902032344.22348.rjw@sisk.pl> <1233702327.16867.109.camel@pasglop> <alpine.LFD.2.00.0902031514510.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902031514510.3247@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-02-03 15:18:14, Linus Torvalds wrote:
> 
> 
> On Wed, 4 Feb 2009, Benjamin Herrenschmidt wrote:
> > 
> > Wait wait wait ... the -whole- point of the exercise, wether using
> > local_irq_save or disable_irq, -is- to put the ACPI bit -after- setting
> > the device in low power state and before the restore on wakeup...
> 
> You're missing context.
> 
> ACPI isn't just for the device power settings. It's for the CPU's too, and 
> it's for things like "prepare to sleep". And they all have _different_ 
> requirements.

As long as we claim to support cpu hotplug, suspending the cpus early
should work. User might have unplugged the cpu manually...

If something is broken in acpi, we may need to disable  cpu*/onlone on
 affected systems.
								Pavel

> 
> What Rafael is trying to tell you is that we have ACPI-initiated ordering 
> requirements between turning CPU's off, and turning devices off, and he's 
> not willing to change that.
> 
> > The -one- thing that indeed conflicts here is that we disable nonboot
> > CPUs earlier. Right ?
> 
> This.
> 
> > Now, I doubt that would be a big issue
> 
> With ACPI, there is no such thing as a "big issue". There are only tons of 
> small horrid details that. And the "big issue" is that all the small 
> details are insane.
> 
> 		Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
