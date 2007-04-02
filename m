Return-Path: <linux-kernel-owner+w=401wt.eu-S965957AbXDBVk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965957AbXDBVk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965961AbXDBVk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:40:29 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:51363 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965957AbXDBVk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:40:28 -0400
Date: Mon, 2 Apr 2007 14:39:49 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] x86_64: enable clockevents and dynticks
Message-ID: <20070402213949.GD10574@sequoia.sous-sol.org>
References: <20070331083149.997762000@sous-sol.org> <1175419332.28263.67.camel@localhost.localdomain> <20070401185402.GZ10574@sequoia.sous-sol.org> <1175549504.28263.184.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175549504.28263.184.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> On Sun, 2007-04-01 at 11:54 -0700, Chris Wright wrote:
> > * Thomas Gleixner (tglx@linutronix.de) wrote:
> > > On Sat, 2007-03-31 at 01:31 -0700, Chris Wright wrote:
> > > > This series converts x86_64 timers to clockevents drivers
> > > > and then enables dynticks.  There's some minor cleanups along
> > > > the way.  The lapic broadcast mechanism is untested, I'm sure it
> > > > still needs work, there's still some cruft in lapic_setup_timer.
> > > > 
> > > > This is just for comments at this point, now that it's working
> > > > on my test box in both NO_HZ=n and NO_HZ=n configurations (typically
> > > > using hpet).
> > > 
> > > Have you checked, if we could share the code between i386 and x86_64 at
> > > least for PIT and HPET. I'm not sure about the local APIC, but I think
> > > it might be doable as well.
> > 
> > Yes, that's part of why I did some of the cleanups that way, so that we
> > could merge the two together later.
> 
> I'd prefer to get this done now. If we plug it in as is, the "merge
> later" probably will never happen.

that's fine, this is just RFC to see if there's obvious broken bits, etc.
also, i still need to do some split out of the pit.  it and hpet are nearly
identical though, so i don't noticing any issues with this.

the part i know is broken is lapic broadcast, so i'd like to fix that
up too.  trouble is, it's broken on vanilla too, so i'm not 100% sure
what i'm debugging yet.

thanks,
-chris
