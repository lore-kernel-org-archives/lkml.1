Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbYAYWLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbYAYWLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbYAYWKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:10:52 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44901 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752139AbYAYWKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:10:51 -0500
Date: Fri, 25 Jan 2008 23:11:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
	format.
Message-ID: <20080125221105.GB2261@elf.ucw.cz>
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <47992D0E.2070700@zytor.com> <20080125074910.GD4134@ucw.cz> <200801252302.52164.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801252302.52164.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > >>I just looked at the ACPI suspend code, and it looks 
> > > >>like it hacks its own identity map at runtime.  Pavel, 
> > > >>am I reading that code right?
> > > >
> > > >Yes, I think so, I believe we do it on both 32 and 64 
> > > >bit now.
> > > >
> > > 
> > > So the background to this... we need an identity map to 
> > > trampoline at early boot, obviously, but we'd like it to 
> > > not stick around more than necessary.  We have 
> > > zap_low_mappings() now but it's not really sufficient.
> > > 
> > > Secondary SMP processors need these mappings during 
> > > trampolining -- presumably including CPU hotplug -- and 
> > > I'm suspecting it might simply make sense to use a 
> > > separate set of page tables (with both the identity and 
> > > the kernel map) for trampolining and just keep them 
> > > around.  That way they would be usable for ACPI as well.
> > 
> > That would enable some cleanups, yes.
> 
> Speaking of cleanups, the following one is applicable IMO.

ACK... and BTW ack for that deferred device removal series.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
