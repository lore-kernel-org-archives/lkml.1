Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbXGCNAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbXGCNAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 09:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbXGCNAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 09:00:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44558 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380AbXGCM77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 08:59:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 15:07:15 +0200
User-Agent: KMail/1.9.5
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-pm@lists.linux-foundation.org,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
References: <20070703042916.GA17240@srcf.ucam.org> <1183462826.10386.107.camel@localhost.localdomain> <200707031346.57613.oliver@neukum.org>
In-Reply-To: <200707031346.57613.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707031507.16700.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 July 2007 13:46, Oliver Neukum wrote:
> Am Dienstag, 3. Juli 2007 schrieb Benjamin Herrenschmidt:
> > On Tue, 2007-07-03 at 09:44 +0200, Oliver Neukum wrote:
> > > Am Dienstag, 3. Juli 2007 schrieb Benjamin Herrenschmidt:
> > > > So to summarize, the plan that makes things work with fuse is:
> > > > 
> > > >  - For STR, don't do the freezer thing.
> > > > 
> > > >  - For STD, don't sys_sync() after you froze
> > > > 
> > > > There might be -other- issues, but that should get you through some of
> > > 
> > > At the risk of repeating myself. Character device drivers are written
> > > with the assumption that normal io and suspend/resume do not race
> > > with each other due to the freezer.
> > > What do you intend to do about that?
> > 
> > Ugh ... "character devices" ... that's a pretty wide statement...
> > there's lots of those and very different one from the other...
> 
> That is a good summary of the problem ;-(
> 
> > Any sane device-driver will have to cope with being suspended in a
> > "live" system. I've demonstrated multiple times in the past why this is
> > necessary anyway, for things like dynamic power management, among
> > others.
> 
> That is an interesting notion. I'd rather see device drivers reporting
> their devices idle and requsting to be suspended.
> But in any case it doesn't solve the problem.

Agreed.

What I think will solve the problem in the long run is to:

1) Separate the hibernation code from the suspend code (ie. hibernation-related
callbacks should generally be different from suspend-related callback for each
driver).
2) Remove the freezing of kernel threads from each of them (in the hibernation
case, if possible) an fix the things that get broken.
3) Remove the freezing of user space from the suspend code path and fix the
things that get broken.

Going to step 3) before doing 1) and 2) doesn't seem to be the right thing to
me.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
