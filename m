Return-Path: <linux-kernel-owner+w=401wt.eu-S1758496AbYDBQm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496AbYDBQm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756537AbYDBQmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:42:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42995 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755504AbYDBQmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:42:17 -0400
Date: Wed, 2 Apr 2008 12:42:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation
 callbacks (rev. 6)
In-Reply-To: <200804021728.45823.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0804021238190.5042-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Oliver Neukum wrote:

> Am Mittwoch, 2. April 2008 17:13:11 schrieb Alan Stern:
> > Basically yes.  Subsystems and drivers are allowed to keep devices
> > suspended if they were suspended before the system went to sleep.  
> > Remember, the purpose of the resume method is to let drivers know that
> > the system is now awake, not to force them to put their devices into a
> > high-power state.
> 
> Well, sometimes it is exactly that what we desire, eg. as a side effect
> of lsusb. Should the callbacks have different semantics depending on
> the reason you call them? And how should that information be transferred?

Which callbacks are you referring to?  When lsusb opens a device and
does an autoresume, it does not call the same routine as the PM core
does when resuming from a system sleep.  lsusb ends up calling
usb_autoresume_device() whereas the PM core ends up calling
usb_resume(), which is the function you quoted earlier.

Alan Stern

