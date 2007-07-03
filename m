Return-Path: <linux-kernel-owner+w=401wt.eu-S1760970AbXGCVTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760970AbXGCVTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbXGCVTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:19:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46482 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbXGCVTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:19:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 23:25:41 +0200
User-Agent: KMail/1.9.5
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Nigel Cunningham <nigel@nigel.suspend2.net>
References: <20070703042916.GA17240@srcf.ucam.org> <200707031709.29968.rjw@sisk.pl> <20070703192729.GA2125@elf.ucw.cz>
In-Reply-To: <20070703192729.GA2125@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707032325.41952.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 July 2007 21:27, Pavel Machek wrote:
> Hi!
> 
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
> Actually... It is not _needed_ for suspend to disk, either. Snapshot is
> atomic, so it should be okay to suspend with filesystems dirty.
> 
> _But_, if anything goes wrong, we'd prefer to have at least
> filesystems synced. Battery running out during s2ram is not quite
> uncommon, so we perhaps should do sync somewhere there. (But we can do
> it before freezer just fine).

OK

So, should I add the sync() to suspend_prepare(), before freeze_processes()
(in analogy with hibernate())?

Greetings
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
