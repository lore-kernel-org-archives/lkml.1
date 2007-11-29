Return-Path: <linux-kernel-owner+w=401wt.eu-S933288AbXK2TUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288AbXK2TUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761678AbXK2TU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:20:28 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34331 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759973AbXK2TU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:20:27 -0500
Date: Thu, 29 Nov 2007 14:20:26 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Lord <lkml@rtr.ca>
cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [PATCH] base/class.c: prevent ooops due to
 insert/remove race (v3)
In-Reply-To: <474F0129.5080306@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0711291417530.5666-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Mark Lord wrote:

> Mark Lord wrote:
> > ..
> > 
> > While doing insert/remove (quickly) tests on USB,
> > I managed to trigger an Oops on 2.6.23.8 on a call
> > to strlen() in make_class_name().

Does this oops occur under 2.6.24?  The SCSI async scanning code was
changed between 2.6.23 and 2.6.24, in a way intended to prevent exactly 
this sort of thing.

> And below is a "prevented Oops", courtesy of the patch.
> The next bug to fix is whereever the code resides that
> repeatedly continues to flog the unplugged device
> after the test, despite SCSI returning host_byte=DID_NO_CONNECT.

It has probably already been fixed.

Besides, it's not the flogging an unplugged device that causes the 
oops.  It's trying to unregister a device that was never registered in 
the first place.

Alan Stern

