Return-Path: <linux-kernel-owner+w=401wt.eu-S1033552AbXHMS6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033552AbXHMS6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S974341AbXHMSw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:52:28 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39836 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966845AbXHMSwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:52:24 -0400
Date: Mon, 13 Aug 2007 14:30:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: trenn@suse.de, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, vojtech@suse.cz
Subject: Re: 2.6.22 regression: thermal trip points
Message-ID: <20070813123032.GA12506@elf.ucw.cz>
References: <46B1988C.3090302@t-online.de> <200708031459.07108.lenb@kernel.org> <20070806095504.GA1934@elf.ucw.cz> <200708071458.45687.lenb@kernel.org> <20070807214947.GB4413@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070807214947.GB4413@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > For the
> > > > upstream kernel, I think it is more appropriate to expose and fix
> > > > the fundamental problems.  For distro kernels, I'm less concerned
> > > > if you hide bugs instead of fixing them.
> > > 
> > > This is okay as long as you are willing to work around the fundamental
> > > problems in kernel. You are unable to _fix_ them. They are broken
> > > BIOSes.
> > 
> > The thing Linux needs to figure out is why Windows doesn't
> > get confused by what Linux claims to be broken BIOS.
> 
> Why do you assume that Windows work? Yes, they probably will not have
> 'machine runs at 50% speed' problem, but I'd be very surprised if
> critical shutdown  worked properly on more than 90% of notebooks....
> 
> > So far I have one live sighting to be addressed by
> > the upstream kernel (from Knut).  I'm certainly looking
> > forward to the 2nd live sighting...
> 
> Ok, I guess I should steal that old xe3 I was talking about...

Done, xe3 was re-built from parts.

/proc/acpi/.../trip_points:
critical (S5):		100 C
passive:		83 C...
active[0]:		100 C...

(hmm, active=critical? Interesting. Fortunately fan seems to be driven
by BIOS).

Temperature is ~63 C in "normal" use. Now lets simulate fan failure...
and lets load the cpu...

temperature slowly rises, 1min00 -- 72C, 1min15 -- 75C, 1min30 --
77C, 1min45 -- 80C, 1min00 -- 82C, 1min15 -- 83C, 1min45 -- sudden
powerdown, presumably because of hardware failsafe.

So we have two bugs here: machine should have attempted to use passive
cooling sooner, so that critical temperature would not be reached, and
machine should have attempted shutdown before hardware failsafe killed
the power. I could do both in 2.6.21, with echo of new trip points and
enable of polling.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
