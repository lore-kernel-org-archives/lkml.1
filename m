Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbYDBUM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbYDBUM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbYDBUMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:12:21 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:46797 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbYDBUMU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:12:20 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation callbacks (rev. 6)
Date: Wed, 2 Apr 2008 22:11:35 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <Pine.LNX.4.44L0.0804021238190.5042-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0804021238190.5042-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804022211.36438.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 2. April 2008 18:42:15 schrieb Alan Stern:
> On Wed, 2 Apr 2008, Oliver Neukum wrote:
> 
> > Am Mittwoch, 2. April 2008 17:13:11 schrieb Alan Stern:
> > > Basically yes.  Subsystems and drivers are allowed to keep devices
> > > suspended if they were suspended before the system went to sleep.  
> > > Remember, the purpose of the resume method is to let drivers know that
> > > the system is now awake, not to force them to put their devices into a
> > > high-power state.
> > 
> > Well, sometimes it is exactly that what we desire, eg. as a side effect
> > of lsusb. Should the callbacks have different semantics depending on
> > the reason you call them? And how should that information be transferred?
> 
> Which callbacks are you referring to?  When lsusb opens a device and
> does an autoresume, it does not call the same routine as the PM core
> does when resuming from a system sleep.  lsusb ends up calling
> usb_autoresume_device() whereas the PM core ends up calling
> usb_resume(), which is the function you quoted earlier.

But how is usb_autoresume_device() supposed to take to the driver?
Furthermore suppose the interface woken up is storage. This will have
to work across subsystem borders. Why not put it into generic code?

	Regards
		Oliver

