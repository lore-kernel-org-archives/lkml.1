Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbXKUPyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbXKUPyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 10:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbXKUPym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 10:54:42 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56139 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752630AbXKUPym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 10:54:42 -0500
Date: Wed, 21 Nov 2007 10:54:40 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Rudolf Marek <r.marek@assembler.cz>, Jiri Slaby <jirislaby@gmail.com>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <lm-sensors@lm-sensors.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [lm-sensors] broken suspend [Was: 2.6.24-rc2-mm1]
In-Reply-To: <200711210100.43049.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0711211053140.3226-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007, Rafael J. Wysocki wrote:

> > Is it possible to unregister a driver on CPU_DOWN_PREPARE_FROZEN?
> 
> No.  In that case the suspend core is holding the device's mutex and your
> attempt to unregister it will deadlock with it.
> 
> Do you _have_ _to_ unregister the device at all?  Why don't you just leave
> it registered on CPU_DOWN_PREPARE_FROZEN?  The CPU is not going away
> physically in this case and it's _guaranteed_ that _cpu_up() will be called on
> it as soon as the hibernation image is ready or we are back from suspend.

This leaves the device registered if for some reason the number of CPUs 
after resuming from hibernation is smaller than the number of CPUs 
before hibernation.  Of course, in theory that's never supposed to 
happen...

Alan Stern

