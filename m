Return-Path: <linux-kernel-owner+w=401wt.eu-S1763649AbYAYIBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763649AbYAYIBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763011AbYAYHtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:49:39 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2083 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762162AbYAYHti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:49:38 -0500
Date: Fri, 25 Jan 2008 07:49:10 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native format.
Message-ID: <20080125074910.GD4134@ucw.cz>
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <47990BDC.4070008@zytor.com> <479912B0.2080506@goop.org> <479913BA.8000506@zytor.com> <47991809.9060903@goop.org> <47991A6C.8060007@zytor.com> <479921F5.9020902@goop.org> <4799247C.6090008@zytor.com> <20080125002054.GA2059@elf.ucw.cz> <47992D0E.2070700@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47992D0E.2070700@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-01-24 16:27:58, H. Peter Anvin wrote:
> Pavel Machek wrote:
> >>>
> >>I just looked at the ACPI suspend code, and it looks 
> >>like it hacks its own identity map at runtime.  Pavel, 
> >>am I reading that code right?
> >
> >Yes, I think so, I believe we do it on both 32 and 64 
> >bit now.
> >
> 
> So the background to this... we need an identity map to 
> trampoline at early boot, obviously, but we'd like it to 
> not stick around more than necessary.  We have 
> zap_low_mappings() now but it's not really sufficient.
> 
> Secondary SMP processors need these mappings during 
> trampolining -- presumably including CPU hotplug -- and 
> I'm suspecting it might simply make sense to use a 
> separate set of page tables (with both the identity and 
> the kernel map) for trampolining and just keep them 
> around.  That way they would be usable for ACPI as well.

That would enable some cleanups, yes.
						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
