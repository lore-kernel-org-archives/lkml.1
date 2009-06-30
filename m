Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZGAJDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZGAJDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZGAJDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:03:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58682 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbZGAJDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:03:33 -0400
Date: Tue, 30 Jun 2009 08:35:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 3/9] x86/moorestown: add moorestown platform flags
Message-ID: <20090630063513.GJ1351@ucw.cz>
References: <20090626101310.4110a290@lxorguk.ukuu.org.uk> <20090626093859.GA12571@elte.hu> <20090626111603.758ec7fb@lxorguk.ukuu.org.uk> <20090626110429.GB12446@elte.hu> <20090626125653.5e30bae4@lxorguk.ukuu.org.uk> <20090626122254.GA9959@elte.hu> <20090626133318.5b8de81b@lxorguk.ukuu.org.uk> <20090626142937.GA19477@elte.hu> <alpine.LFD.2.00.0906261827490.2767@localhost.localdomain> <20090626095454.6f993a9c@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626095454.6f993a9c@jbarnes-g45>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-06-26 09:54:54, Jesse Barnes wrote:
> On Fri, 26 Jun 2009 18:32:42 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Fri, 26 Jun 2009, Ingo Molnar wrote:
> > > [ Although it is beyond me why ABP was done - why wasnt HPET good
> > >   enough? HPET can do per CPU clockevents too and it's just as 
> > >   off-chip (and hence fundamentally slow) as ABP. ]
> > 
> > Welcome to the wonderful world of embedded systems. Just have a peek
> > into arch/[arm/powerpc/mips] to see what's coming up to us with full
> > force. I would not be surprised when we see an x86 system sharing the
> > device driver for i2c or whatever with an ARM SoC in the foreseable
> > future.
> 
> Ha, yeah I was just going to say "think embedded".  ABP is a much
> simpler spec and programming interface than HPET, and since we were
> designing new custom silicon, it made sense to just do the simple
> thing, rather than butchering an existing spec, then making a partial
> HPET that looks like ABP anyway and forcing any future HPET updates to
> conform to the new standard (very similar reasoning to the ACPI vs SFI
> discussion btw).  Hopefully the technologies we've come up with for

Very similary wrong, I'd say :-(. While you could have created
hpet-lite, where hpet-lite driver would work on hpet system, you went
and created something new.

And yes, SFI is similar disaster, you should just define subset of
acpi ('acpi-lite').

In the end, you are willing to use silicon for compatibility (arm
 instruction set needs less transistors, right?) and wasting millions
 of transistors, then try to save thousands with non-compatible
 devices :-(.
 
								Pavel
 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
