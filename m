Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbZBTPPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbZBTPPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbZBTPPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:15:39 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36868 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752440AbZBTPPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:15:38 -0500
Date: Fri, 20 Feb 2009 10:15:37 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mike Lampard <mike@mtgambier.net>
cc: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: long-term regression with some usb mass storage devices
In-Reply-To: <200902201811.52801.mike@mtgambier.net>
Message-ID: <Pine.LNX.4.44L0.0902201012150.3071-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009, Mike Lampard wrote:

> On Fri, 20 Feb 2009 05:17:42 pm Mike Lampard wrote:
> > Hi All,
> >
> > I recently plonked a dvd into my usb-attached Pioneer DVR-107d only to find
> > that the current kernels no longer saw the drive as DVD capable.  In fact,
> > the kernel no longer saw _any_ features of the drive: sr0: scsi3-mmc drive:
> > 0x/0x caddy.  After much bisecting and even more blind luck I narrowed the
> > problem down to this commit:
> >
> > commit bdb2b8cab4392ce41ddfbd6773a3da3334daf836
> > Author: Alan Stern <stern@rowland.harvard.edu>
> > Date:   Tue Jun 24 14:03:14 2008 -0400
> >
> >     [SCSI] erase invalid data returned by device
> >
> >     This patch (as1108) fixes a problem that can occur with certain USB
> >     mass-storage devices: They return invalid data together with a residue
> >     indicating that the data should be ignored.  Rather than leave the
> >     invalid data in a transfer buffer, where it can get misinterpreted,
> >     the patch clears the invalid portion of the buffer.
> >
> >     This solves a problem (wrong write-protect setting detected) reported
> >     by Maciej Rutecki and Peter Teoh.

If this affected your device then the device must not report residues 
correctly.  If you provide the device's entry in /proc/bus/usb/devices, 
I'll write a patch adding a blacklist entry for it.

It would help if you could also provide a usbmon trace showing what 
happens when you plug the drive in.  Instructions are in the kernel 
source file Documentation/usb/usbmon.txt.

Alan Stern

