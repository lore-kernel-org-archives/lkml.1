Return-Path: <linux-kernel-owner+w=401wt.eu-S1757625AbZA2WiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbZA2WiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZA2WiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:38:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42396 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752274AbZA2WiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:38:08 -0500
Date: Thu, 29 Jan 2009 17:38:05 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Jarod Wilson <jarod@redhat.com>, <linux1394-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
Subject: Re: [PATCH RFT 7/7] firewire: sbp2: add workarounds for 2nd and 3rd
 generation iPods
In-Reply-To: <49821F99.4070108@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.44L0.0901291735080.2453-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009, Stefan Richter wrote:

> Hmm, I'm beginning to suspect that I should duplicate usb-storage's
> 
> 	if (sdev->type == TYPE_DISK)
> 		sdev->last_sector_bug = 1;
> 
> into the FireWire drivers.  There aren't any fundamental downsides to
> this, are there?

No, not really.  Accesses to the last few sectors will be slightly 
slower, but those sectors don't get used much anyway and the slowdown 
isn't very big.  In theory there might be a device which doesn't like 
single-sector accesses near the end... but what can you do about 
something like that?  If the device doesn't let you read sectors one at 
a time, it's not worth worrying about.

> > Linux uses the last-sector accesses to check whether or not the device 
> > is part of a RAID.  Apparently Windows and OS X don't support the kinds 
> > of RAID that need this.
> 
> Or they don't support these kinds of RAID over certain transports like
> USB and FireWire...?

Maybe.  I don't know any of the details.

Alan Stern

