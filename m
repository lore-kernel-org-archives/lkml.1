Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbZBQC4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbZBQC4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 21:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZBQC4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 21:56:30 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1862 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751919AbZBQC4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 21:56:30 -0500
Date: Mon, 16 Feb 2009 21:56:29 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Arjan van de Ven <arjan@infradead.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
In-Reply-To: <200902170002.37973.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0902162144010.24097-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009, Rafael J. Wysocki wrote:

> On Monday 16 February 2009, Alan Stern wrote:
> > On Mon, 16 Feb 2009, Rafael J. Wysocki wrote:
> > 
> > > OK, so I think there are two things that user space may be allowed to do as
> > > far as putting devices into low power states is concerned:
> > > * disable/enable the automatic power management of the device (provided that
> > >   the driver supports the automatic PM)
> > 
> > Set the automatic PM parameters (idle timeout, state to go to, etc.).  
> 
> Yes.  I'm not sure about the state part, though.

Maybe, maybe not.  IMO it's too early to tell whether anyone will need 
this ability, so we shouldn't rule it out.

> > What about situations where we want to distinguish between the power 
> > state of the device itself and the power state of the link?  For a disk 
> > drive we may want to power the link on and off quite a lot, as that 
> > has low latency, but spinning the disk up and down takes a long time 
> > and so should have a longer idle-time value.
> 
> Well, I'm not sure at the moment.
> 
> Do you have any suggestions?

Not very well fleshed-out ones.  I've got a vague idea for allowing a
disk to have a 3-level power arrangement: full power, link disabled but
drive still spinning, and device suspended.  Arranging for automatic
transitions among those states will be a little clumsy but it can be
done.  As an example of the clumsiness, this scheme requires that the
drive has _two_ idle-timeout values, one for the link and one for the
drive itself.

Another possibility is to set up independent runtime PM for the
transport and the device.  This means allowing the possibility that the
transport is suspended while its child (the device) is not.  This is a
little simpler (there's only one idle-timeout per device, since the
link is treated as an independent device), but it violates the
principle of never suspending a parent while there is an active child.

Alan Stern

