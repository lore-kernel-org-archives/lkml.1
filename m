Return-Path: <linux-kernel-owner+w=401wt.eu-S1752482AbZFHDD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbZFHDD5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 23:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbZFHDDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 23:03:47 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58314 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750927AbZFHDDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 23:03:47 -0400
Date: Sun, 7 Jun 2009 23:03:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: alan-jenkins@tuffmail.co.uk, Pekka Enberg <penberg@cs.helsinki.fi>,
       Corentin Chary <corentin.chary@gmail.com>,
       <acpi4asus-user@lists.sourceforge.net>, <len.brown@intel.com>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
In-Reply-To: <20090607232856.GA1805@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.0906072256190.28801-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, Matthew Garrett wrote:

> On Sun, Jun 07, 2009 at 04:41:30PM +0100, Alan Jenkins wrote:
> 
> > Hmm, some cameras have input devices (i.e. buttons). In fact, uvcvideo
> > registers an input device on my EEE even though it has no buttons.  I
> > think that needs investigating :-(.
> > 
> > It's quite likely that the buttons can stop working when suspended.
> > And there might be other devices with the same IDs, which have a
> > button wired up.
> 
> A change has recently been committed that results in the button only 
> working if the v4l device is open. Otherwise you've got several wakeups 
> a second due to the polling of the button endpoint. I'm assuming that 
> opening the device disables autosuspend, so I wouldn't worry about that.
> 
> It'd be interesting to try enabling autosuspend on all UVC devices. Can 
> a driver indicate that its hardware supports it?

There's no mechanism for this.  It many environments it couldn't work,
because the decision about whether to enable autosuspend is made when
the device is first created (i.e., when the creation uevent is
received), whereas driver binding doesn't occur until later.

Alan Stern

