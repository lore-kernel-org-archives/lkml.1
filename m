Return-Path: <linux-kernel-owner+w=401wt.eu-S1762069AbXGFOjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762069AbXGFOjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 10:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbXGFOjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 10:39:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36759 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753653AbXGFOjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 10:39:01 -0400
Date: Fri, 6 Jul 2007 10:38:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, <linux-kernel@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <1183694347.3388.114.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0707061034540.3737-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007, Benjamin Herrenschmidt wrote:

> What you propose is basically a slightly over-simplistic version of what
> I think (and Paulus think) should be done. We do need to do it via
> driver callbacks down the tree since only drivers can know how to deal
> with their DMA etc... and ordering need to be respected, but that's
> basically it.
> 
> And guess what ? It's what we do on powerbooks, and it works fine,
> without a freezer :-)

I wish you'd stop saying that.  Have you ever done any serious testing?

Here's something to try:  Add a time delay to the end of hub_suspend in
drivers/usb/core/hub.c, so you can provoke a race manually.  Then while
one of your root hubs is being suspended and the system is waiting in
that delay, either plug in a new USB device to that hub or unplug an
existing device.

Be sure that CONFIG_USB_DEBUG is on so that we can figure out what 
happened after the fact.

Alan Stern

