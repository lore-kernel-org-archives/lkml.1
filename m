Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbYCZOKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbYCZOKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 10:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbYCZOKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 10:10:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44920 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754764AbYCZOKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 10:10:01 -0400
Date: Wed, 26 Mar 2008 10:10:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Introduce new top level
 =?iso-8859-1?q?suspend=09and_hibernation_callbacks?= (rev. 2)
In-Reply-To: <200803252156.12185.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803261003540.4755-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008, Rafael J. Wysocki wrote:

> On Tuesday, 25 of March 2008, Oliver Neukum wrote:
> > Am Dienstag, 25. März 2008 21:41:48 schrieb Rafael J. Wysocki:
> > > On Tuesday, 25 of March 2008, Oliver Neukum wrote:
> > > > Am Dienstag, 25. März 2008 15:33:22 schrieb Alan Stern:
> > > > > > so I'd say a
> > > > > > failure to resume is just a limited subcase of a device vanishing during
> > > > > > sleep.
> > > > > 
> > > > > I'll go along with that.  If a device vanishes during sleep, the PM 
> > > > > core isn't responsible for unregistering it -- the device's subsystem 
> > > > > is.
> > > > 
> > > > Yes, that makes sense. You are right.
> > > 
> > > Still, if ->resume() returns an error, does it make sense, from the PM core's
> > > point of view, to execute ->complete() for that device, for example?
> > 
> > IMO you must always keep the ordering invariant. If a parent returns an error
> > the PM core must not wake its children.

Don't think of it that way.  The PM core doesn't wake anything.  It
merely notifies drivers that the system sleep is ending, so that the
drivers can wake their devices.  It's up to the driver to detect
whether the parent failed to resume, in which case the driver should
take appropriate action.

The situation is no different from what happens when the user tries to 
access a mounted USB disk drive after the USB cable has been unplugged.  
The drivers take care of everything.

> I'm agreeing here, but one of the previous Alan's comments suggests he has a
> differing opinion.  Alan?
> 
> I'm considering to make the PM core skip the resuming of the children of
> devices that failed to resume and skip calling ->complete() for that devices
> and their children.

While that might in principle be a reasonable thing to do, it's 
different from how the PM core has behaved in the past.  I don't see 
any point in making a change like that now.

Alan Stern

