Return-Path: <linux-kernel-owner+w=401wt.eu-S1757748AbXGCVCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748AbXGCVCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbXGCVB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:01:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57386 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751754AbXGCVB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:01:57 -0400
Date: Tue, 3 Jul 2007 17:01:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Ni@m" <niam.niam@gmail.com>
cc: Oliver Neukum <oliver@neukum.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] NIKON D50 problem
In-Reply-To: <200707030802.30516.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0707031659020.8010-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007, Oliver Neukum wrote:

> Am Dienstag, 3. Juli 2007 schrieb Andrew Morton:
> > > Some time ago(I really can't remember version of the kernel)
> > > everything was Ok. I'll try to find out the workable version of the
> > > kernel ... but I've already tried 2.6.20 - the same =(.
> > > I'm not sure, but It's possible that I've had ATA subsystem but not
> > > libata ... I haven't tested this case yet.
> > > 
> > > PS. I can see photos on my camera ... flash card is Ok. I have this
> > > problem even if I changed the flash card in this camera.
> > 
> > It's more likely a usb-storage or scsi layer problem.
> > 
> > The device reports as having 1984001 sectors and the kernel is reporting IO
> > errors around the very end of the device.  Presumably an IO is straddling
> > end-of-device and we're not handling that correctly.
> 
> Now I remember. We recently had a report about a buggy device, that close
> to the end of the medium could handle only requests for single sectors.
> I'll look into the archive.

Most likely this device just needs an unusual_devs entry with
US_FL_FIX_CAPACITY.  I could prepare a patch to add this if you send
the output from "lsusb -v" for the camera or its entry in
/proc/bus/usb/devices.

Alan Stern

