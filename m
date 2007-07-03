Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbXGCUwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbXGCUwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750730AbXGCUw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:52:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46344 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbXGCUwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:52:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 22:59:58 +0200
User-Agent: KMail/1.9.5
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
References: <20070703042916.GA17240@srcf.ucam.org> <200707031709.29968.rjw@sisk.pl> <200707031920.59940.oliver@neukum.org>
In-Reply-To: <200707031920.59940.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707032259.59714.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 July 2007 19:20, Oliver Neukum wrote:
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

I don't think that would matter.

Still, I can remove the sync from the suspend code path only, leaving it in
the hibernation code path.  The patch will be bigger, but well.

Any objection to that?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
