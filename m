Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbYCYNhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbYCYNhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 09:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbYCYNhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 09:37:23 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:48001 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbYCYNhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:37:22 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation callbacks (rev. 3)
Date: Tue, 25 Mar 2008 14:37:16 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <Pine.LNX.4.44L0.0803241519090.24400-100000@iolanthe.rowland.org> <200803251255.31482.oliver@neukum.org> <200803251340.55210.rjw@sisk.pl>
In-Reply-To: <200803251340.55210.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803251437.17268.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 25. März 2008 13:40:53 schrieb Rafael J. Wysocki:
> On Tuesday, 25 of March 2008, Oliver Neukum wrote:
> > Am Montag 24 März 2008 schrieb Rafael J. Wysocki:

> > > + *     after @prepare() returns.  If @prepare() detects a situation it cannot
> > > + *     handle (e.g. registration of a child already in progress), it may return
> > > + *     -EAGAIN, so that the PM core can execute it once again (e.g. after the
> > > + *     new child has been registered) to recover from the race condition. This
> > > + *     method is executed for all kinds of suspend transitions and is followed
> > > + *     by one of the suspend callbacks: @suspend(), @freeze(), or @poweroff().
> > 
> > This could be understood so that disconnect() cannot be called.
> 
> At what time exactly?

I see no locking that would would prevent disconnect() in the window between
prepare() and suspend()/...
  
> > > + *     The PM core executes @prepare() for all devices before starting to
> > > + *     execute suspend callbacks for any of them, so drivers may assume all of
> > > + *     the other devices to be present and functional while @prepare() is being
> > > + *     executed.  However, they may NOT assume anything about the availability
> > > + *     of the user space at that time.
> > 
> > Probably it should be mentioned that this is the time to allocate memory
> > if you have to.
> 
> Well, not exactly.  Afterwards you cannot use GFP_KERNEL allocations, but
> GFP_NOIO should still work, although for hibernation it's quite possible that
> they'll fail if substantial amounts of memory are requested.
> 
> > And it is too late to request firmware. 
> 
> Yes.

This is better documented explicitly.

	Regards
		Oliver

