Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130Ab0AWGGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab0AWGGd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 01:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848Ab0AWGGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 01:06:32 -0500
Received: from cantor.suse.de ([195.135.220.2]:57316 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab0AWGGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 01:06:31 -0500
Date: Fri, 22 Jan 2010 22:05:28 -0800
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stern@rowland.harvard.edu, linux-kernel@vger.kernel.org, stable@kernel.org,
       Rohan Hart <rohan.hart17@gmail.com>, Ryan May <rmay31@gmail.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [25/29] USB: fix usbstorage for 2770:915d
	delivers no FAT
Message-ID: <20100123060528.GA14114@suse.de>
References: <20100123001113.401655891@mini.kroah.org> <1264214626.373.21.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264214626.373.21.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 02:43:46AM +0000, Ben Hutchings wrote:
> On Fri, 2010-01-22 at 16:10 -0800, Greg KH wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Ryan May <rmay31@gmail.com>
> > 
> > commit 10d2cdb6102669279bee2d9a00a22431b74583d5 upstream.
> > 
> > Resolves kernel.org bug 14914.
> > 
> > Remove entry for 2770:915d (usb digital camera with mass storage
> > support) from unusual_devs.h. The fix triggered by the entry causes
> > the file system on the camera to be completely inaccessible (no
> > partition table, the device is not mountable).
> > 
> > The patch works, but let me clarify a few things about it.  All the
> > patch does is remove the entry for this device from the
> > drivers/usb/storage/unusual_devs.h, which is supposed to help with a
> > problem with the device's reported size (I think).  I'm pretty sure it
> > was originally added for a reason, so I'm not sure removing it won't
> > cause other problems to reappear.  Also, I should note that this
> > unusual_devs.h entry was present (and activating workarounds) in
> > 2.6.29, but in that version everything works fine.  Starting with
> > 2.6.30, things no longer work.
> [...]
> 
> It doesn't sound like this bug or fix are sufficiently well understood
> yet to be suitable for a stable update.  The bug report is currently
> marked as invalid!

It was marked that way as we couldn't take a patch through a bug report.
The email thread for it said it solved the problem, and I have had a
number of other users report that it solves their problem as well.

So I do think it needs to remain, unless someone has a report to the
contrary?  And if so, I'll be glad to take it out of the main tree, and
then take that back to the -stable tree.

thanks,

greg k-h
