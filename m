Return-Path: <linux-kernel-owner+w=401wt.eu-S1760620AbYF0UgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbYF0UgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYF0UgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:36:02 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3359 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751402AbYF0UgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:36:00 -0400
Date: Fri, 27 Jun 2008 16:35:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.6.26-rc1 regression since 2.6.25 - problem in 2.6.26-rc8 again
In-Reply-To: <20080627091717.GA4998@ics.muni.cz>
Message-ID: <Pine.LNX.4.44L0.0806271628390.1304-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008, Lukas Hejtmanek wrote:

> > What does usbmon reveal when you dock the laptop again and then plug in
> > the disk (see Documentation/usb/usbmon.txt)?
> 
> attached as 1-26.mon.out (2.6.26-rc8)
>  
> > Can you provide a comparable usbmon log for 2.6.25?
> 
> attached as 1-25.mon.out

This is very confusing.  It appears that the two usbmon logs don't show 
the same actions on your part.

Let's try to keep this as simple as possible.  We'll consider a single 
fixed course of action:

	Make sure the disk isn't mounted and isn't in use.

	Start collecting the usbmon log.

	Remove the disk.

	Wait at least 10 seconds.

	Undock the laptop.

	Wait at least 10 seconds.

	Dock the laptop again.

	Wait at least 10 seconds.

	Plug in the disk.

	Stop the usbmon log.

(The reason for those 10-second delays is because the USB stack will 
automatically suspend an idle hub after a few seconds of inactivity.)

Do exactly the same thing under both operating system versions, and 
then we should have suitably comparable logs.

Alan Stern

