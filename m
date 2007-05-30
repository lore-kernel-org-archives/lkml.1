Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbXE3AFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbXE3AFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 20:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbXE3AF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 20:05:28 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:47877 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbXE3AF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 20:05:27 -0400
Date: Wed, 30 May 2007 03:05:28 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] Dealing with flaky USB storage devices and rootfs
Message-ID: <20070530000528.GA1680@localdomain>
References: <20070529205927.GA24808@localdomain> <Pine.LNX.4.44L0.0705291734390.2974-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0705291734390.2974-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 05:50:49PM -0400, Alan Stern wrote:
> On Tue, 29 May 2007, Dan Aloni wrote:
> 
> > Hello,
> > 
> > We have a system where the rootfs is a partition on a USB device,
> > and I've noticed upon a few rare cases where the USB controller 
> > loses the connection to the USB device after some uptime (days,
> > weeks...), and the USB device reappears a very short time later.
> 
> That failure mode is pretty uncommon.  More often what happens is the
> connection remains intact but communication/protocol/firmware/???  
> errors cause the device to stop working.  It never disappears but it
> can't be used again without unplugging or power-cycling.

Yes this is also what I assume happening. i.e. more likely a USB 
flash disk firmware bug than a controller bug (there are lots of 
crappy USB flash drives out there).
 
> > So, I gave some thoughts about this, I and came up with two 
> > main solutions:
> > 
> > 1) Improve the USB storage error handling - bind the already 
> > existing SCSI host to the USB port that has the device, e.g., 
> > if host2 got created for usb 5-3 then keep it that way for the 
> > sake of EH. /dev/sda1 should come to life when the USB device 
> > recovers, unless a few seconds have passed or some attributes 
> > (such as manufactor id or serial) have changed.
> 
> The difficulty here is that this "error" is indistinguishable from
> normal activity -- someone simply unplugs the device and then later on
> another connection is made.  It might be the same device as before or
> it might be a different one.  In other words, it isn't really an error.  
> You would solve this by relying on "a few seconds" timeout.
[...]
> 
> It also goes against the USB specification.  And it is potentially 
> unsafe, in that it is possible for users to change media or make other 
> alterations that the kernel cannot detect.  The same would be true of 
> your proposal, assuming that somebody was quick enough to unplug one 
> device and plug in another (or swap memory cards) in the span of a few 
> seconds.

The specific use case I refer to is with a flash drive embedded 
inside a locked and closed chassis of a dedicated server. So, 
anyone repluging it must know what they are doing anyway.

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
