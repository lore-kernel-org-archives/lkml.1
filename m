Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545AbZGXO3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbZGXO3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 10:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZGXO3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 10:29:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36510 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752138AbZGXO3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 10:29:51 -0400
Date: Fri, 24 Jul 2009 10:29:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Valdis.Kletnieks@vt.edu
cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: 31-rc3-mmotm0716 - dead USB trackball mouse kills entire system
In-Reply-To: <7895.1248380585@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.44L0.0907241023110.3165-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009 Valdis.Kletnieks@vt.edu wrote:

> On Thu, 23 Jul 2009 14:19:59 EDT, Alan Stern said:
> 
> > > The "can't reset device" is apparently new with mm-0716 - I've not seen it
> > > before in at least the 6 weeks my logs go back.
> > 
> > I don't think it is new.  You might try using an older kernel with your 
> > decaying trackball to see.
> 
> Umm.. I've *been* using it with older kernels for *months*.  Not a *single*
> hit in my logs, which go back till June 10.  Except for today, when I started
> running -0716, and now I've gotten hit by the same messages, and then
> the same hang 4 times today.

I repeat: The code that logs those messages is not new.

> So either the codepath in -0716 is different from -0702 and -0604 and -0517 and
> every other -mm before, or the trackball spontaneously developed a *different*
> behavior overnight at the same time I upgraded the kernel.
> 
> See the logs below...

You're talking about messages like this:

> Jul 23 11:10:29 turing-police kernel: [  571.965568] drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71

Those messages are produced by the following statement in
drivers/hid/usbhid/hid-core.c:hid_reset():

		err_hid("can't reset device, %s-%s/input%d, status %d",
				hid_to_usb_dev(hid)->bus->bus_name,
				hid_to_usb_dev(hid)->devpath,
				usbhid->ifnum, rc);

I don't know how long that subroutine and in particular that line have
been present, but it has been quite a while.  Certainly since 2.6.20.

> > This is a bug.  For more discussion see this thread:
> > 
> > 	http://marc.info/?t=124807676700001&r=1&w=2
> > 
> > You should try the patch given there.
> 
> OK, will do that, see if it improves things...

Let me know what happens.

Alan Stern

