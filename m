Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbYDAVDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbYDAVDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760444AbYDAVBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:01:33 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3876 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760831AbYDAVBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:01:30 -0400
Date: Tue, 1 Apr 2008 17:01:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Hans de Goede <j.w.r.degoede@hhs.nl>
cc: Boaz Harrosh <bharrosh@panasas.com>, Oliver Neukum <oliver@neukum.org>,
       Sergey Dolgov <solkaa@gmail.com>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: usb-storage, error reading the last 8 sectors, regression in
 2.6.25-rc7
In-Reply-To: <47F29A04.2040701@hhs.nl>
Message-ID: <Pine.LNX.4.44L0.0804011659500.9362-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Hans de Goede wrote:

> Reverting the patch is easy, edit drivers/usb/storage/scsiglue.c and remove the 
> following line:
> "                sdev->last_sector_bug = 1;"
> 
> Which should be close to line 193 (it is 193 in my source tree, but thats a bit 
> stale).
> 
> > 
> > The old way was not necessarily correct for this type of device bug. Only
> > that it had a very high chance of not appearing.
> > 
> > When discussing the last bug, it was said to enable it by default for USB
> > instead of using blacklists. It looks like this bug, or the other, needs a
> > blacklist.
> > 
> 
> If the splitting of the request is the cause, yes then it looks like that.
> 
> > But to me it looks like this is a 4k thing. I think Windows will always
> > use 4k for FAT, though never triggering either of the bugs.
> > 
> 
> I'm pretty sure the last sector must only be read by itself bug (for lack of a 
> better name) is present under windows too, but won't be triggered as windows 
> normally doesn't access the last sector, where as various pieces of Linux 
> routinely probe the end of the disk, for detection of exotic partition types/ 
> disklabes.etc.
> 
> > The one submitting the last sector patch was, I think, Hans de Goede (CCed)
> > Hans ?
> 
> Correct I wrote the split up requests which touch the last sector changes to 
> the scsi disk handling, and a seperate patch to always set the flag which 
> enables the splitting for usb disks.
> 
> >   If I read last 8 sectors (4k) on a device that exhibits the "last sector bug"
> >   Does it work? (Is 8 a magic number here)
> > 
> 
> I just tried and I'm afraid not, an 8 sector read which includes at the last 
> sector completely kills the device, no other transfers to / from the device 
> will work until the sdcard is removed and reinserted (the troublesome device is 
> a card reader build into a multi function printer, one gets what one pays for).

It sounds like the last_sector_bug setting should be conditional on a 
blacklist entry.  As far as I know it affects only a small proportion 
of devices; most are fine with multi-sector reads at the end.

Alan Stern

