Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab0BVUMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:12:46 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39913 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753759Ab0BVUMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:12:45 -0500
Date: Mon, 22 Feb 2010 15:12:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Anssi Hannula <anssi.hannula@iki.fi>, Oliver Neukum <oliver@neukum.org>,
       <dvomlehn@cisco.com>, <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes"
 causes gobi_loader to hang
In-Reply-To: <20100222191432.GA27418@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.1002221510570.1328-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010, Matthew Garrett wrote:

> On Mon, Feb 22, 2010 at 02:10:33PM -0500, Alan Stern wrote:
> > On Mon, 22 Feb 2010, Anssi Hannula wrote:
> > > Does this mean a tty interface is ill-suited for the microcode upload, and 
> > > instead qcserial should use the kernel's generic microcode upload mechanism or 
> > > the userspace should use libusb to do it?
> > 
> > I don't know.  Didn't the old successful code use a tty interface?
> 
> Yes. The kfifo changes have caused some sort of alteration in behaviour.
> 
> > > Any idea what could be causing the hang, then?
> > 
> > No idea, unless it's the device.
> 
> Once the device hangs, it then tends to refuse any input until power 
> cycled. So it's clearly getting into some sort of undefined state, 
> though whether that's because it only gets sent half of its firmware 
> (ie, the hang occurs and as a result the hardware dies) or whether it's 
> causing the hang by dying is unclear.

The latest logs did show all the firmware getting sent -- or at least, 
they show that as much data was sent by the nonworking driver as by the 
working driver.  So I'd say the device causes the hang by dying, 
although I don't know where the hang is or why a dead device should 
cause it.

Alan Stern

