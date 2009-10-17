Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbZJQT2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbZJQT2G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 15:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZJQT2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 15:28:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58880 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZJQT2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 15:28:04 -0400
Date: Sat, 17 Oct 2009 21:28:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Cihula, Joseph" <joseph.cihula@intel.com>
Cc: Roland Dreier <rdreier@cisco.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Wang, Shane" <shane.wang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86/txt for v2.6.32
Message-ID: <20091017192800.GM16532@elf.ucw.cz>
References: <20090929171318.GC14405@elf.ucw.cz>
 <20090929191951.18315e94@infradead.org>
 <037F493892196B458CD3E193E8EBAD4F01ED9FE3B1@pdsmsx502.ccr.corp.intel.com>
 <20090930065448.GB11652@elf.ucw.cz>
 <037F493892196B458CD3E193E8EBAD4F01ED9FE6E3@pdsmsx502.ccr.corp.intel.com>
 <20091003201959.GA16047@elf.ucw.cz>
 <20091003203619.GA27182@khazad-dum.debian.net>
 <ada4oqgp5qx.fsf@cisco.com>
 <20091006081258.GB1469@ucw.cz>
 <4F65016F6CB04E49BFFA15D4F7B798D9AC1C49D6@orsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F65016F6CB04E49BFFA15D4F7B798D9AC1C49D6@orsmsx506.amr.corp.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >  > Shows the attack being used to read sensitive keys, but you can use it also
> > >  > to *modify* system running state (it will be more difficult, as you need to
> > >  > remove and replace the RAM while on S3 instead of S5, but it should be
> > >  > doable by someone who knows what he is doing).
> > >
> > > I believe the whole point of this TXT / S3 handling is that the resume
> > > from S3 will then be able to detect that the contents of RAM have been
> > > modified while the system was asleep.
> >
> > ...and you are able to read out any keys, etc. Maybe that's expected &
> > ok, but Doc*/intel_txt.txt does not actually tell me what it protects
> > against and is pretty much useless... making patches impossible to
> > review.
> >
> > So... what does txt protect?
> 
> >From Documentation/intel_txt.txt:
>         Intel TXT in Brief:
>         o  Provides dynamic root of trust for measurement (DRTM)
>         o  Data protection in case of improper shutdown
>         o  Measurement and verification of launched environment
> 
> Intel TXT doesn't protect anything itself--it provides a foundation for software to provide protections and security.  tboot and the associated Linux patches do this.  The section of intel_txt.txt titled "Value Proposition for Linux or "Why should you care?"" tries to describe what is provided.
> 
> > Data integrity only?
> 
> Data integrity, yes, but not only.  The code also provides for DRTM-based measurements, data protection in case of improper shutdown, etc.
> 
> > Data privacy, too?
> 
> No.

So why does it protect data "in case of improper shutdown"?

> > Who is it designed to protect against?
> >
> > Remote attacker?
> 
> Yes.

Existing mechanisms should be adequate to protect against then.

> > Local user trying to subvert it?
> 
> No.

Then again, why does it protect data "in case of improper shutdown"?

> > > TXT simply produces a reasonably trustworthy measurement of system
> > > state.  If you modify RAM while the system is asleep, then you will not
> > > be able to produce a measurement showing an unmodified system state.
> >
> > Well, actually I see some auditing to be done in proposed patches.
> 
> All comments are welcome.

Well, without detailed design goals, comments are pretty much
impossible. Please improve Documentation/intel_txt.txt to explain what
it protects, and against who.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
