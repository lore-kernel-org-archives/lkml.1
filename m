Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbYAEVok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbYAEVok (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 16:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757313AbYAEVob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 16:44:31 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53511 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754864AbYAEVoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 16:44:30 -0500
Date: Sat, 5 Jan 2008 22:44:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alessandro Guido <alessandro.guido@gmail.com>
Cc: ACPI mailing list <linux-acpi@vger.kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Kohjinsha sleep problems
Message-ID: <20080105214440.GA10292@elf.ucw.cz>
References: <20080101231955.GA1931@ucw.cz> <200801042233.44827.alessandro.guido@gmail.com> <20080105213536.GA2307@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105213536.GA2307@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > On kohjinsha, wakeup code does not seem to be reached at all. I tried
> > > looking around FACS, but it seems very empty:
> > >
> > > ...
> > 
> > The same on my laptop:
> > 
> > FACS @ 0x2fefafc0
            signature   length      hwsignature waking_vector
> >   0000: 46 41 43 53 40 00 00 00 62 12 00 00 00 00 00 00  FACS@...b.......
> >   0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   0020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > 
> > 
> > I've never been able to resume from STR with Linux (works with Windows Vista). 
> > STD works, although I have to press the power button in order to
> > resume.

Hmm, that is strange. firmware_waking_vector seems to be all
zeros. How can that work?

struct acpi_table_facs {
        char signature[4];      /* ASCII table signature */
        u32 length;             /* Length of structure, in bytes */
        u32 hardware_signature; /* Hardware configuration signature */
        u32 firmware_waking_vector;     /* 32-bit physical address of
the Firmware Waking Vector */

...aha, firmware_waking_vector is to be filled by Linux, so I guess
this was false alarm.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
