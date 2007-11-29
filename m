Return-Path: <linux-kernel-owner+w=401wt.eu-S933575AbXK2WId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575AbXK2WId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934016AbXK2WIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:08:01 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42399 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933338AbXK2WIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:08:00 -0500
Date: Thu, 29 Nov 2007 17:07:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Lord <lkml@rtr.ca>
cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       <linux-usb-devel@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [PATCH] base/class.c: prevent ooops due to
 insert/remove race (v3)
In-Reply-To: <474F2532.5090708@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0711291700260.5666-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Mark Lord wrote:

> > So again, the problem is in the higher up scsi layer, and that is where
> > the problem should already be fixed.
> ..
> 
> Ahhh.. so you figure the Oops should also have been fixed
> as part of the 2.6.24 SCSI fixes ?  That's what I was missing here.

Yes indeed.  I wish I could point you to the exact patch containing the 
fix, but the git software seems to have lost track of it (it's combined
in with a large number of other patches with no obvious way to separate 
it out).  It's also available in the various mailing list archives, but 
I don't have a pointer to it and there's no reasonable way to search 
for it.

The patch in question was written by Matthew Wilcox; it added code to 
the SCSI async-scanning routines to utilize the scan_mutex.  IMO it 
should have been applied to 2.6.23 but it wasn't.

Alan Stern

