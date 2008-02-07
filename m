Return-Path: <linux-kernel-owner+w=401wt.eu-S934945AbYBGW3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934945AbYBGW3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:29:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761971AbYBGW2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:28:33 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55903 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758826AbYBGW2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:28:31 -0500
Date: Thu, 7 Feb 2008 23:28:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Message-ID: <20080207222845.GA6096@elf.ucw.cz>
References: <20080205190600.GB11613@elf.ucw.cz> <200802060227.14385.rjw@sisk.pl> <200802070049.00461.rjw@sisk.pl> <200802072312.31430.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802072312.31430.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > This rewrites wakeup code to .c, and it fixes stack (should use movl
> > > > ,%esp, not movw). Testers wanted. Makefile infrastructure was done by
> > > > hpa, cleanups by rjw.
> > > 
> > > I'll test it tomorrow
> > 
> > Works on my nx6325 (good sign, the box is easy to break ;-)).
> > 
> > > and I still have some more cleanups (I was distracted by a nasty scheduler
> > > issue in the current mainline).
> > 
> > The cleanups are still in the works (sorry).
> 
> Below is a version with some easy cleanups, rebased on top of the patches that
> move the 64-bit hibernation code to arch/x86/power .

Can you post a delta against my versoin? I do not see any changes from
a quick glance.

This is probably more acceptable version of beep; but there are
probably even better ways to clean it...

        if (wakeup_header.realmode_flags & 4) {
                inb(97);
                outb(0, 0x80);
                outb(3, 97);
                outb(0, 0x80);
                outb(-74, 67);
                outb(0, 0x80);
                outb(-119, 66);
                outb(0, 0x80);
                outb(15, 66);
        }

...like the version that makes beep/pause/beep/pause, so that user can
count them.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
