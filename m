Return-Path: <linux-kernel-owner+w=401wt.eu-S1757038AbYFITkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbYFITkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbYFITko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:40:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51794 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753263AbYFITko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:40:44 -0400
Date: Mon, 9 Jun 2008 15:40:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Chris Clayton <chris2553@googlemail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Hannes Reinecke <hare@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux1394-devel@lists.sourceforge.net>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
In-Reply-To: <484D8019.3090900@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.44L0.0806091533160.14688-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008, Stefan Richter wrote:

> The log at http://lkml.org/lkml/2008/6/6/317 shows two pauses.  One in 
> the middle of USB related messages with no FireWire stuff around 
> (17:25:19 to 17:25:44).  The other with parport, ieee1394, USB messages 
> around it (17:25:44 to 17:26:31).
> 
>  From there, the last 17:25:44 message is strange:  The device 
> 00110666000013cc which is the controller is reported as being removed. 
> Chris, did you do something at this point?

It's also worth noting that the first 17:25:44 message is highly 
suspicious.  It is the initial output of the ohci-hcd driver, 
indicating that the udev/hotplug system had just loaded that driver.  
This doesn't seem to have anything to do with the SCSI stack.

Whatever caused the delay, it also managed to pause the other hotplug 
task which was in the midst of loading uhci-hcd.

Alan Stern

