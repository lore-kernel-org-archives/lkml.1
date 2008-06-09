Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbYFITMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbYFITMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYFITLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:11:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48369 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbYFITLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:11:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <484D8019.3090900@s5r6.in-berlin.de>
Date: Mon, 09 Jun 2008 21:10:17 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Chris Clayton <chris2553@googlemail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Hannes Reinecke <hare@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
References: <Pine.LNX.4.44L0.0806091040440.2943-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0806091040440.2943-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> In fact the log shows that the 30-second delay occurs in the middle of
> ohci1394 (Firewire) initialization, not USB initialization:
> 
> Jun  8 05:26:35 upstairs kernel: ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]  MMIO=[fbfff000-fbfff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8] 
> Jun  8 05:26:35 upstairs kernel: ohci_hcd 0000:02:0a.0: urb f71cb680 path 2 ep1in 5e160000 cc 5 --> status -62 
> Jun  8 05:26:35 upstairs kernel: hub 1-2:1.0: transfer --> -62 
> Jun  8 05:27:08 upstairs kernel: driver: '0000:02:0b.0': driver_bound: bound to device 'ohci1394' 
> Jun  8 05:27:08 upstairs kernel: bus: 'pci': really_probe: bound device 0000:02:0b.0 to driver ohci1394 

The log at http://lkml.org/lkml/2008/6/6/317 shows two pauses.  One in 
the middle of USB related messages with no FireWire stuff around 
(17:25:19 to 17:25:44).  The other with parport, ieee1394, USB messages 
around it (17:25:44 to 17:26:31).

 From there, the last 17:25:44 message is strange:  The device 
00110666000013cc which is the controller is reported as being removed. 
Chris, did you do something at this point?

Also, in http://lkml.org/lkml/2008/6/1/2 you reported a patch which 
changes the SCSI core's interaction with the driver core as first bad 
commit.  Did you check that going before this commit removes _all_ the 
pauses, even those around USB or FireWire messages?  Or did you only 
check whether disk drives appear quickly?
-- 
Stefan Richter
-=====-==--- -==- -=--=
http://arcgraph.de/sr/
