Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbYCYOYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbYCYOYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbYCYOYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:24:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44484 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753463AbYCYOYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:24:05 -0400
Date: Tue, 25 Mar 2008 10:24:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation
 callbacks (rev. 3)
In-Reply-To: <200803251437.17268.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0803251020530.4838-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008, Oliver Neukum wrote:

> Am Dienstag, 25. März 2008 13:40:53 schrieb Rafael J. Wysocki:
> > On Tuesday, 25 of March 2008, Oliver Neukum wrote:
> > > Am Montag 24 März 2008 schrieb Rafael J. Wysocki:
> 
> > > > + *     after @prepare() returns.  If @prepare() detects a situation it cannot
> > > > + *     handle (e.g. registration of a child already in progress), it may return
> > > > + *     -EAGAIN, so that the PM core can execute it once again (e.g. after the
> > > > + *     new child has been registered) to recover from the race condition. This
> > > > + *     method is executed for all kinds of suspend transitions and is followed
> > > > + *     by one of the suspend callbacks: @suspend(), @freeze(), or @poweroff().
> > > 
> > > This could be understood so that disconnect() cannot be called.
> > 
> > At what time exactly?
> 
> I see no locking that would would prevent disconnect() in the window between
> prepare() and suspend()/...

There is no such locking.  It's perfectly legal for a device to be 
unregistered between prepare() and suspend().  I suppose it wouldn't 
hurt to add a general comment explaining that a device can be 
unregistered at any time except when one of its methods is running.

Alan Stern

