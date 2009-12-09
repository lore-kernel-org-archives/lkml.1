Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZLIQW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZLIQW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 11:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbZLIQWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 11:22:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47619 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751417AbZLIQWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 11:22:53 -0500
Date: Wed, 9 Dec 2009 11:23:00 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <20091209160256.GA3229@rakim.wolfsonmicro.main>
Message-ID: <Pine.LNX.4.44L0.0912091117080.4120-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009, Mark Brown wrote:

> On Wed, Dec 09, 2009 at 10:49:56AM -0500, Alan Stern wrote:
> > On Wed, 9 Dec 2009, Mark Brown wrote:
> 
> > > There's some potential for this in embedded audio - it wants to bring
> > > down the entire embedded audio subsystem at once before the individual
> > > devices (and their parents) get suspended since bringing them down out
> 
> > For something like bringing down the entire embedded audio subsystem, 
> > which isn't directly tied to a single device, you would probably be 
> > better off doing it when the PM core broadcasts a suspend notification
> > (see register_pm_notifier() in include/linux/suspend.h).  This occurs 
> > before any devices are suspended, so synchronization isn't an issue.
> 
> I'm not convinced that helps with the fact that the suspend may take a
> long time - ideally we'd be able to start the suspend process off but
> let other things carry on while it completes without having to worry
> about something we're relying on getting suspended underneath us.

The suspend procedure is oriented around device structures, and what 
you're talking about isn't.  It's something separate which has to be 
finished before _any_ of the audio devices are suspended.

How long does it take to bring down the entire embedded audio 
subsystem?  And how critical is the timing for typical systems?

Alan Stern

