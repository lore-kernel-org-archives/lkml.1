Return-Path: <linux-kernel-owner+w=401wt.eu-S1030189AbXAaPVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030189AbXAaPVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030188AbXAaPVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:21:03 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44076 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030182AbXAaPVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:21:00 -0500
Date: Wed, 31 Jan 2007 10:20:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Robert Hancock <hancockr@shaw.ca>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: [linux-usb-devel] 2.6.20-rc6 SCSI error: I/O error - trouble
 with mass storage devices ?!
In-Reply-To: <45BFD0F6.9040201@shaw.ca>
Message-ID: <Pine.LNX.4.44L0.0701311015160.3702-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007, Robert Hancock wrote:

> Alan Stern wrote:
> 
> > The log revealed that the phone's firmware returns garbage values in the 
> > Residue field for some WRITEs.  This patch should take care of it.
> > 
> > Alan Stern
> 
> Is it just me, or should some of these device quirk entries that keep 
> being added be made unconditional? Adding entries for every single 
> device that shows up with these problems seems like not a very scalable 
> approach. These devices obviously work in Windows, can't we just emulate 
> its behavior here?

I have had the same thought...

Just because Windows (and a bunch of clueless firmware writers) does
something wrong shouldn't mean that we do it too.  The fact is, these
devices are in violation of the appropriate SCSI and USB specifications.

Ignoring the residue value can actually lead to undiscovered errors.  
According to the spec, it's perfectly legal for a device to return an
error indication there and nowhere else.

Alan Stern

