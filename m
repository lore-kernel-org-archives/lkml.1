Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbYDMXdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbYDMXdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 19:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbYDMXc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 19:32:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38027 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbYDMXc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 19:32:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 8)
Date: Mon, 14 Apr 2008 01:33:22 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Nigel Cunningham <ncunningham@crca.org.au>, benh@kernel.crashing.org,
       Greg KH <greg@kroah.com>, pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.0804131916420.3060-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0804131916420.3060-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140133.23781.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of April 2008, Alan Stern wrote:
> On Mon, 14 Apr 2008, Nigel Cunningham wrote:
> 
> > > The ability for prepare() callbacks to sync with userland,
> > > request_firmware, etc... is an important feature that's been needed for
> > > some time imho.
> > > 
> > > Ben.
> > 
> > I agree. These calls have already been changing far too often in
> > mainline. I know it's all been necessary but please, can we try to make
> > one set of changes and just get it right this time?
> 
> In practical terms, it will be easier to keep the freezer where it is 
> for now.  This is because prepare() requires drivers to change their 
> behavior; they aren't allowed to register new children any more.
> 
> But if userspace isn't frozen then user programs can interact with
> drivers in a way that does cause new children to be created.  For
> example this happens in USB, where opening an audio device and
> selecting its bitrate causes a new set of endpoints to be realized,
> along with their representations in sysfs.
> 
> Thus, in addition to making all the interface changes implied by the 
> new callbacks, drivers would also have to change the way they interact 
> with userspace.  Yes, this will have to be done eventually in any case, 
> as the freezer goes away -- but it shouldn't have to be done right now.

That's exactly my point.

Plus in my opinion, while with ->prepare() after the freezer it's possible
to write ->prepare() and ->suspend() that will work just fine when we remove
the freezer, with ->prepare() before the freezer it would be hard to do that,
unless ->prepare() was trivial.

Thanks,
Rafael
