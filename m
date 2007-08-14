Return-Path: <linux-kernel-owner+w=401wt.eu-S1760444AbXHNLpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760444AbXHNLpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 07:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759279AbXHNLng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 07:43:36 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56061 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757930AbXHNLne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 07:43:34 -0400
Date: Tue, 14 Aug 2007 09:46:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andres Salomon <dilinger@queued.net>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: turn serial console suspend a boot rather than compile time option
Message-ID: <20070814074657.GB2905@elf.ucw.cz>
References: <20070808183535.2a2c6edf.dilinger@queued.net> <20070808154130.9cc3a30e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808154130.9cc3a30e.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-08-08 15:41:30, Andrew Morton wrote:
> On Wed, 8 Aug 2007 18:35:35 -0400
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > Currently, there's a CONFIG_DISABLE_CONSOLE_SUSPEND that allows one to stop
> > the serial console from being suspended when the rest of the machine goes
> > to sleep.  This is incredibly useful for debugging power management-related
> > things; however, having it as a compile-time option has proved to be
> > incredibly inconvenient for us (OLPC).  There are plenty of times that we
> > want serial console to not suspend, but for the most part we'd like serial
> > console to be suspended.
> > 
> > This drops CONFIG_DISABLE_CONSOLE_SUSPEND, and replaces it with a kernel
> > boot parameter (no_console_suspend).  By default, the serial console will
> > be suspended along with the rest of the system; by passing
> > 'no_console_suspend' to the kernel during boot, serial console will remain
> > alive during suspend.
> > 
> > I have another version of this patch which keeps #ifdefs around; however,
> > it's uglier.  I prefer this version of the patch, and don't feel that it
> > increases bloat.  If people strongly disagree, let me know and I'll submit
> > the other patch.
> > 
> 
> yep, compile-time options suck.

Run-time options suck, too, for stuff that should not be optional; we
should keep console live if the console driver can handle it, not
otherwise.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
