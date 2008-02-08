Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbYBHVXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbYBHVXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYBHVXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:23:08 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33098 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751167AbYBHVXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:23:07 -0500
Date: Fri, 8 Feb 2008 22:23:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [linux-pm] Re: [rft] s2ram wakeup moves to .c, could fix few
	machines
Message-ID: <20080208212317.GD12923@elf.ucw.cz>
References: <20080208210004.GA12923@elf.ucw.cz> <Pine.LNX.4.44L0.0802081617280.5958-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0802081617280.5958-100000@iolanthe.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > segments:offsets rear its ugly head here. I need %ds to point to my
> > > > data, and the way to do it is copy it from %cs; that needs start to be
> > > > at 0.
> > > 
> > > Hm, why exactly is that necessay?
> > 
> > It is not _neccessary_. Try to come up with another method that gets
> > relocations right. I could not :-(.
> > 
> > (Actually, putting table at the offset 0 and short jump at beggining
> > of the table would probably do the trick. But that still keeps code at
> > offset 0 :-).
> 
> Pavel, can you explain in greater detail exactly what you need?

I do not think I need anything. I'm just explaining why data need to
go at nonzero offset. Nothing to see here, move on ;-).

> It sounds like you are running in real mode with code stored at some 
> (unknown?) location in memory.  The BIOS calls this code with IP=0 and 
> CS=<something>, which apparently doesn't fit your requirements.

> So just what are your requirements?  The only possibilities I can think 
> of are:
> 
> 	Code stored at a particular location in memory;
> 
> 	CS, IP, etc. initialized to some particular values.
> 
> What am I missing?

See arch/x86/kernel/acpi/realmode/wakeup.S (the version that was sent
to the list). No problem there, but table stored at nonzero
offset. Short jump at the beggining of table would fix it (ugly).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
