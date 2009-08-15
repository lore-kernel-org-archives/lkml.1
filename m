Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbZHOPx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbZHOPx3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 11:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbZHOPx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 11:53:28 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45327 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753441AbZHOPx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 11:53:27 -0400
Date: Sat, 15 Aug 2009 11:53:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, <linux-usb@vger.kernel.org>,
       <linux-pci@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [RFC] PCI: Runtime power management
In-Reply-To: <200908151618.10169.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908151143560.18415-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Aug 2009, Rafael J. Wysocki wrote:

> > > Why don't we add a flag indicating whether or not the device is allowed to
> > > be power managed at run time, something like runtime_forbidden, that the
> > > user space will be able to set through sysfs?
> > 
> > I think even having a runtime_wakeup flag (which defaults to on) would 
> > be sufficient.
> 
> Perhaps it would, but then unsetting runtime_wakeup would effectively disable
> runtime PM for devices that need it to be power managed at run time (probably
> all input devices).  Also there may be situations in which user space may
> really want to disable runtime PM for some devices (think of broken hardware
> for one example).

It sounds like there are really three choices here, and the decision 
should largely be left up to the user:

	1. don't use runtime PM,

	2. allow runtime PM but disable remote wakeup,

	3. allow runtime PM with remote wakeup enabled.

Now, a driver may say "I can't do my job without remote wakeup".  Such
a driver would refuse to do runtime_suspend in case 2.  But otherwise
we should follow the preference of the user.

The only remaining question is how to expose this in sysfs in a way 
that won't be confusing and that won't be confused with the "wakeup" 
attribute.  One possibility is to use the "level" attribute introduced 
in USB; possible levels are "on" (no runtime PM) and "auto" (runtime 
PM allowed).  Then a new "runtime_wakeup" attribute could contain 
nothing (if wakeup is not available), "enabled", or "disabled".

Alan Stern

