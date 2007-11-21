Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbXKUTCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbXKUTCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 14:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbXKUTC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 14:02:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50318 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbXKUTC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 14:02:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [lm-sensors] broken suspend [Was: 2.6.24-rc2-mm1]
Date: Wed, 21 Nov 2007 20:19:43 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Rudolf Marek <r.marek@assembler.cz>, Jiri Slaby <jirislaby@gmail.com>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org, Andrew Morton <akpm@linux-foundation.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0711211053140.3226-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0711211053140.3226-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711212019.45071.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 21 of November 2007, Alan Stern wrote:
> On Wed, 21 Nov 2007, Rafael J. Wysocki wrote:
> 
> > > Is it possible to unregister a driver on CPU_DOWN_PREPARE_FROZEN?
> > 
> > No.  In that case the suspend core is holding the device's mutex and your
> > attempt to unregister it will deadlock with it.
> > 
> > Do you _have_ _to_ unregister the device at all?  Why don't you just leave
> > it registered on CPU_DOWN_PREPARE_FROZEN?  The CPU is not going away
> > physically in this case and it's _guaranteed_ that _cpu_up() will be called on
> > it as soon as the hibernation image is ready or we are back from suspend.
> 
> This leaves the device registered if for some reason the number of CPUs 
> after resuming from hibernation is smaller than the number of CPUs 
> before hibernation.  Of course, in theory that's never supposed to 
> happen...

Yes, that clearly would be a bug.

Rafael
