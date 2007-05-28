Return-Path: <linux-kernel-owner+w=401wt.eu-S1760387AbXE1W3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760387AbXE1W3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 18:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbXE1W32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 18:29:28 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3972 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752072AbXE1W32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 18:29:28 -0400
Date: Mon, 28 May 2007 18:29:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before
 hibernation/suspend
In-Reply-To: <20070528205727.GA5911@ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0705281719200.10323-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007, Pavel Machek wrote:

> > The theoretical answer is that it behaves the way we want.  The kernel 
> > thread does selective resumes in response to device requests.  If such 
> > a request comes in while the system is asleep it will awaken the 
> > system; so it's only logical that a request coming in while the system 
> > is in the process of going to sleep should abort the suspend.
> 
> I'd say that it shows ppc being broken. User wanted to suspend the
> system, and now unrelated task did lsusb... and system will not sleep.
> 
> AFAICT it is DoS issue -- if one of your users keeps doing lsusb, root
> will not be able to suspend the system.

This is a matter of one's philosophy.  In suspend-to-RAM, should tasks
be frozen or should I/O queues be frozen?

With the USB subsystem I have followed the approach taken by the PM
core, which is that tasks are frozen.  But one can -- and Linus has on
at least one occasion -- make a good case that tasks should be left
running while only I/O is frozen.  This would require the subsystem to
distinguish between a selective device suspend and a system-wide
suspend-to-RAM, so that selective resume could be enabled on demand in
one case but not the other.

It's quite doable in principle -- it's just not the technique I used.

Alan Stern

