Return-Path: <linux-kernel-owner+w=401wt.eu-S1760745AbXGCT1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745AbXGCT1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbXGCT1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:27:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48298 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756020AbXGCT1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:27:44 -0400
Date: Tue, 3 Jul 2007 21:27:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070703192729.GA2125@elf.ucw.cz>
References: <20070703042916.GA17240@srcf.ucam.org> <1183441887.10386.77.camel@localhost.localdomain> <200707031508.45595.rjw@sisk.pl> <200707031709.29968.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707031709.29968.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > The main reason for deadlocks is because we do a sys_sync() after the
> > > freeze, which we shouldn't do.
> > 
> > So why don't we remove the sys_sync() from freeze_processes() instead?
> 
> The patch follows (untested).
> 
> Greetings,
> Rafael
> 
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> We shouldn't sync filesystems from within the freezer, because it's not needed
> for suspend to RAM and leads to problems with FUSE.

Actually... It is not _needed_ for suspend to disk, either. Snapshot is
atomic, so it should be okay to suspend with filesystems dirty.

_But_, if anything goes wrong, we'd prefer to have at least
filesystems synced. Battery running out during s2ram is not quite
uncommon, so we perhaps should do sync somewhere there. (But we can do
it before freezer just fine).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
