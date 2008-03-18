Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436AbYCRLsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbYCRLsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 07:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYCRLrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 07:47:25 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42271 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbYCRLrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 07:47:22 -0400
Date: Tue, 18 Mar 2008 11:01:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks
Message-ID: <20080318100106.GA10830@elf.ucw.cz>
References: <200803170020.55473.rjw@sisk.pl> <200803170022.30345.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803170022.30345.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

> + * The externally visible transitions are handled with the help of the following
> + * callbacks included in this structure:
> + *
> + * @prepare: Prepare the device for the upcoming transition, but do NOT change
> + *	its hardware state.  Prevent new children of the device from being
> + *	registered and prevent new calls to the probe method from being made
> + *	after @prepare() returns.  Also, if a concurrent child registration
> + *	or a call to the probe method already in progress is detected by
> + *	@prepare(), it may return -EAGAIN, so that the PM core can execute it
> + *	once again (e.g. after suspending the newly registered child) to recover
> + *	from the race condition. This method is executed for all kinds of
> + *	suspend transitions and is immediately followed by one of the suspend
> + *	callbacks: @suspend(), @freeze(), @poweroff(), or @quiesce().
> + *
> + * @complete: Undo the changes made by @prepare().  This method is executed for
> + *	all kinds of resume transitions, immediately following one of the resume
> + *	callbacks: @resume(), @thaw(), @restore(), or @recover().  Also executed
> + *	if a suspend callback (@suspend(), @freeze(), @poweroff(), @quiesce())
> + *	immediately following a successful @prepare() fails OR if a new child
> + *	of the device has been registered during @prepare().

So... we do prepare() but it detects new child, so it returns -EAGAIN.
  so we call complete() based on description above
...and then we call prepare() to suspend again?

> + * @suspend: Executed before putting the system into a sleep state in which the
> + *	contents of main memory are preserved.  Quiesce the device, put it into

content....is?

> + * @resume: Executed after waking the system up from a sleep state in which the
> + *	contents of main memory were preserved.  Put the device into the

content...is?

> + * @freeze: Hibernation-specific, executed before creating a hibernation image.
> + *	Quiesce operations so that a consistent image can be created, but do NOT
> + *	otherwise put the device into a low power device state and do NOT emit
> + *	system wakeup events.  Save in main memory the device settings to be

"Save device settings (used by @restore()) into main memory"?

> + * @quiesce: Hibernation-specific, executed after loading a hibernation image
> + *	and before restoring the contents of main memory from it.  Quiesce
> + *	operations so that the contents of main memory can be restored from the

operations, so ?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
