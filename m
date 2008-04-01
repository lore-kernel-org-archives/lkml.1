Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbYDAXBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbYDAXBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 19:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYDAXAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 19:00:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49036 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbYDAXAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 19:00:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation callbacks (rev. 6)
Date: Wed, 2 Apr 2008 01:00:13 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>
References: <200803292317.50218.rjw@sisk.pl> <200804012357.30529.rjw@sisk.pl> <1207089138.23143.117.camel@nigel-laptop>
In-Reply-To: <1207089138.23143.117.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804020100.14962.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 2 of April 2008, Nigel Cunningham wrote:
> Hi.
> 
> On Tue, 2008-04-01 at 23:57 +0200, Rafael J. Wysocki wrote:
> > On Tuesday, 1 of April 2008, Nigel Cunningham wrote:
> > > Hi Rafael etc.
> > > 
> > > On Tue, 2008-04-01 at 22:12 +0200, Rafael J. Wysocki wrote:
[--snip--]
> > > 
> > > > > > + *	However, drivers may NOT assume anything about the availability of the
> > > > > > + *	user space at that time and it is not correct to request firmware from
> > > > > > + *	within @prepare() (it's too late to do that).
> > > > > 
> > > > > That doesn't sound good. It would be good to be able to get drivers to
> > > > > request firmware early in the process.
> > > > 
> > > > That will be possible when we drop the freezer.
> > > 
> > > Yeah, but right now, it seems to me to be a bogus limitation for drivers
> > > to have no way of automatically loading firmware when you're about to
> > > hibernate. (Of course I've since been reminded of the notifier chain -
> > > that should probably be mentioned here as the way of achieving this).
> > 
> > This is a tricky stuff, though, because the notifier is used for disabling the
> > user mode helpers too ...
> 
> Hmm. Yet another notifier?

Well, perhaps it's better to disable user mode helpers directly from
freeze_processes().

Still, let's do one thing at a time. :-)

> > > By the way, I'm going to go on record now as saying I think dropping the
> > > freezer is a silly idea. I'm therefore currently considering including
> > > the freezer in TuxOnice from the time it gets dropped from mainline. I
> > > know that will only make it less likely that TuxOnIce gets merged, but
> > > I've given up caring about that anyway - caring about merging is
> > > pointless when the people who decide if it gets merged don't care.
> > 
> > Well, I'm just not sure if dropping the freezer entirely will actually work,
> > but we won't know that if we don't try.
> > 
> > There's been a lot of pressure on going into this direction recently and
> > in principle it seems to be doable at least for suspend.  Hibernation is
> > another issue, but IMO it's better to focus on suspend first.
> 
> For suspend, I agree with dropping its use. For hibernation...

I'm not sure and that's why I added the comment about the availability of
the user space during ->prepare().

Besides, for now, the freezer is necessary anyway, even for suspend.

Thanks,
Rafael
