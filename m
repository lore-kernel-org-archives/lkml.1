Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbZLIQCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbZLIQCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 11:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbZLIQCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 11:02:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56172 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752620AbZLIQCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 11:02:51 -0500
Date: Wed, 9 Dec 2009 16:02:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
Message-ID: <20091209160256.GA3229@rakim.wolfsonmicro.main>
References: <20091209133829.GF9018@sirena.org.uk>
 <Pine.LNX.4.44L0.0912091044340.4120-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0912091044340.4120-100000@iolanthe.rowland.org>
X-Cookie: Ignore previous fortune.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 10:49:56AM -0500, Alan Stern wrote:
> On Wed, 9 Dec 2009, Mark Brown wrote:

> > There's some potential for this in embedded audio - it wants to bring
> > down the entire embedded audio subsystem at once before the individual
> > devices (and their parents) get suspended since bringing them down out

> For something like bringing down the entire embedded audio subsystem, 
> which isn't directly tied to a single device, you would probably be 
> better off doing it when the PM core broadcasts a suspend notification
> (see register_pm_notifier() in include/linux/suspend.h).  This occurs 
> before any devices are suspended, so synchronization isn't an issue.

I'm not convinced that helps with the fact that the suspend may take a
long time - ideally we'd be able to start the suspend process off but
let other things carry on while it completes without having to worry
about something we're relying on getting suspended underneath us.

> > Embedded audio does potentially - the resume needs all the individual
> > overall resume time.  Currently we get away with a combination of

> You can do the same thing with the resume notifier.

Similarly, the length of time the resume may take to complete means it'd
be nice to start as soon as we've got the devices and complete it at our
leisure.  This is less pressing since we can tell the PM core we've
resumed but still block userspace.
