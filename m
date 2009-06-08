Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbZFHNyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbZFHNyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbZFHNyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:54:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44829 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbZFHNyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:54:37 -0400
Date: Mon, 8 Jun 2009 14:54:31 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: Run-time PM idea (was: Re: [linux-pm] [RFC][PATCH 0/2] PM:
	Rearrange core suspend code)
Message-ID: <20090608135431.GA16052@srcf.ucam.org>
References: <Pine.LNX.4.44L0.0906071651060.25203-100000@netrider.rowland.org> <200906072347.00580.rjw@sisk.pl> <20090608065419.GA13568@elte.hu> <200906081330.50045.rjw@sisk.pl> <20090608130509.GA3272@elte.hu> <20090608131159.GA15100@srcf.ucam.org> <20090608132235.GC13214@elte.hu> <20090608133215.GA15482@srcf.ucam.org> <20090608134647.GA14234@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608134647.GA14234@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 03:46:47PM +0200, Ingo Molnar wrote:
> 
> * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > How does the kernel know whether the user cares about SATA hotplug 
> > or not?
> 
> The typical user probably doesnt know what 'SATA' means, and 
> probably has very vague concepts about 'hotplug' as well.

eSATA is pretty common now.

> The kernel default should be: 'yes, if the kernel feature is enabled 
> and if the hardware can support it' (it's not on a blacklist of some 
> sort, etc., etc.).

The problem with this kind of default is that you get people who are 
confused that their hardware doesn't work. If the kernel doesn't have 
enough information to make a decision it should err on the side of 
functionality - we're talking about fairly low-level power savings, but 
potentially several years of aggregate confusion on the part of users.

> > It'll be up to the distributions to provide sane defaults and let 
> > them be reconfigured as necessary, depending on the information we 
> > have from the user and maybe platform-specific knowledge. But this 
> > is a difficult problem - we need to be smart about all the 
> > potential sources of information in order to pick an appropriate 
> > policy, and the kernel's not the right layer to do some of this 
> > information collection.
> 
> What sources of information exactly? Again, the user wont enter 
> anything, in 95% of the cases - in the remaining 3% of cases what is 
> entered is wrong and only in another 2% of cases is it correct ;-)

Users are generally ok at realising correlation between a setting change 
and something no longer working, so as long as you provide that they'll 
be happy. I agree that this sucks. What we actually want is some means 
of reliably identifying whether a port is hotplug or not, but eSATA 
makes this very difficult.

> Sure, there might be tradeoffs when a piece of hardware cannot be 
> turned off sanely: obviously the monitor might not know it 
> (currently) whether someone is watching it, and 
> wake-on-packet-for-me is not commonly implemented in wireless and 
> wired networking cards so turning off an active networking card 
> might not be possible without the user asking allowing that 
> imperfect mode of power saving.

These cases can all be handled with sufficiently intelligent userland, 
so I'm not worried about them.

> ( Providing a way to _override_ those defaults is of course natural,
>   via /sysfs, should the user express an interest in tweaking it, or
>   should the kernel get it so wrong that a distro wants to work it
>   around. But your argument seems to be "push configuration and
>   handling into user-space" which is really backwards. )

My argument is "Hardware should work, and if the kernel default is for 
it to be broken then the default is wrong". We went through this for USB 
autosuspend. Userspace simply has more available information than the 
kernel, and it's not just a matter of static configuration (though that 
may be part of it). For instance, Oliver's example of screensavers and 
USB keyboards. If nothing's paying attention to volume keys (or if the 
keyboard doesn't have any) then you can enable remote wakeup and suspend 
the keyboard. If something /is/ paying attention to volume keys, you 
can't do that. That's the kind of case I'm discussing.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
