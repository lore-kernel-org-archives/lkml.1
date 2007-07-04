Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbXGDXjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbXGDXjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 19:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbXGDXjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 19:39:18 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54730 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755473AbXGDXjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 19:39:17 -0400
Date: Thu, 5 Jul 2007 01:39:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070704233909.GB2719@elf.ucw.cz>
References: <20070703042916.GA17240@srcf.ucam.org> <200707031508.45595.rjw@sisk.pl> <200707031709.29968.rjw@sisk.pl> <200707031920.59940.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707031920.59940.oliver@neukum.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-07-03 19:20:59, Oliver Neukum wrote:
> Am Dienstag, 3. Juli 2007 schrieb Rafael J. Wysocki:
> > On Tuesday, 3 July 2007 15:08, Rafael J. Wysocki wrote:
> > > On Tuesday, 3 July 2007 07:51, Benjamin Herrenschmidt wrote:
> > > > On Tue, 2007-07-03 at 05:29 +0100, Matthew Garrett wrote:
> > > > > Suspend to RAM on a machine with / on a fuse filesystem turns out to be 
> > > > > a screaming nightmare - either the suspend fails because syslog (for 
> > > > > instance) can't be frozen, or the machine deadlocks for some other 
> > > > > reason I haven't tracked down. We could "fix" fuse, or alternatively we 
> > > > > could do what we do for suspend to RAM on other platforms (PPC and APM) 
> > > > > and just not use the freezer.
> > > > 
> > > > The main reason for deadlocks is because we do a sys_sync() after the
> > > > freeze, which we shouldn't do.
> > > 
> > > So why don't we remove the sys_sync() from freeze_processes() instead?
> > 
> > The patch follows (untested).
> > 
> > Greetings,
> > Rafael
> > 
> > 
> > ---
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > We shouldn't sync filesystems from within the freezer, because it's not needed
> > for suspend to RAM and leads to problems with FUSE.
> 
> This seems fishy. Swsusp needs enough clean memory to make enough
> room for the image. If you sync before you freeze, the running tasks can
> redirty memory.
> What makes you sure that you don't die as shrink_all_memory() writes out
> pages?

Shrink_all_memory should just free enough memory, what's the problem?
Yes, we can have dirty memory, shrink_all_memory() can write that out
just fine.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
