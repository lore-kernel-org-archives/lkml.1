Return-Path: <linux-kernel-owner+w=401wt.eu-S1761289AbXE1Hi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761289AbXE1Hi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 03:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbXE1Hig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 03:38:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56203 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbXE1Hie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 03:38:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Date: Mon, 28 May 2007 09:43:53 +0200
User-Agent: KMail/1.9.5
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
References: <200705272229.21263.rjw@sisk.pl> <20070527220412.GC22687@srcf.ucam.org> <1180304166.3131.66.camel@lov.localdomain>
In-Reply-To: <1180304166.3131.66.camel@lov.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705280943.54312.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 May 2007 00:16, Kay Sievers wrote:
> On Sun, 2007-05-27 at 23:04 +0100, Matthew Garrett wrote:
> > On Sun, May 27, 2007 at 11:49:30PM +0200, Kay Sievers wrote:
> > 
> > > What exactly is the problem we see here? The timeout of the firmware loader?
> > > What goes wrong with frozen userspace, usually there is only a netlink
> > > message sent from the kernel, which should be received and handled
> > > just fine when userspace is running again.
> > 
> > Driver calls request_firmware in the resume method. The userspace helper 
> > can't be run because it's been frozen, so the firmware never gets loaded 
> > and the call times out. The driver then fails to resume. While all this 
> > is happening, the rest of the kernel is blocking on that resume method. 
> > The firmware can be loaded once userspace has been started again, but by 
> > that time the driver has given up.
> 
> Seems, that's just the broken synchronous firmware loading interface
> with the useless timeout handling. The nowait version of the same loader
> doesn't time out, and should not have that problem. The sync version
> should be removed from the kernel, it just causes all sorts of problems
> since it exists.
> 
> Userspace should handle the async request just fine when it comes back
> running, regardless of the time it was submitted.

Okay, so the solution is to convert the drivers to use
request_firmware_nowait() instead of request_firmware() in their .resume()
routines.

Greetings,
Rafael
