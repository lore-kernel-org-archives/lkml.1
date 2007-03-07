Return-Path: <linux-kernel-owner+w=401wt.eu-S2992546AbXCGUWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992546AbXCGUWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992549AbXCGUWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:22:13 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43743 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965635AbXCGUWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:22:09 -0500
Date: Wed, 7 Mar 2007 15:22:05 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: ebuddington@wesleyan.edu
cc: Oliver Neukum <oneukum@suse.de>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] khubd and ent:sda1 sucking CPU with reiser4
 + USB HD
In-Reply-To: <20070307163220.GC889@pool-71-123-121-36.spfdma.east.verizon.net>
Message-ID: <Pine.LNX.4.44L0.0703071513490.8656-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007, Eric Buddington,,, wrote:

> > > So SysRq-t doesn't show anything about khubd, and SysRq-p doesn't give
> > > me anything at all. What else can I try?

How about SysRq-r?

> > I'm baffled.  khubd should have shown up as the process with ID 163.  Is 
> > that process listed under a different name?
> 
> It does show up under /proc/163, for whatever that's worth.

Maybe that means the process is dying but isn't completely dead yet, and 
it's stuck running something inside the reiser4 driver.  Unless we can 
find out what it is, though, there isn't much we can do.

> Going through the list of processes dumped by SysRq-t, here are the
> ones I didn't knowingly start myself:
> 
> aio/0
> ata/0
> ata_aux
> ent:md1.
> events/0
> ib_addr
> ib_cm/0
> ib_mcast
> iw_cm_wq
> kacpid
> kblockd/0
> kcryptd/0
> khelper
> khpsbpkt
> kmirrord
> kmpathd/0
> kprefetchd
> kpsmoused
> kseriod
> ksnapd
> ksuspend_usbd
> kswapd0
> kthread
> ktxnmgrd:md1:
> ktxnmgrd:sda1
> md2_raid1
> pdflush
> rdma_cm
> reiserfs/0
> scsi_eh_0 
> watchdog/0

Most of those (maybe all of them) are built-in kernel threads.

> And khubd is still showing up as a major CPU consumer.  Interestingly,
> ent:sda1! is also absent from the SysRq-t listing, though present (and
> using lost of CPU) according to 'top' (ps, oddly, hangs in 'D' state
> after listing some processes).

Something is badly messed up somewhere, but I have no idea what it could 
be.

These problems start with some USB resets, right?  Did they occur with 
earlier kernel versions, or is this new behavior?

How often does the problem occur?

Alan Stern

