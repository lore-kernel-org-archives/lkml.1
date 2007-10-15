Return-Path: <linux-kernel-owner+w=401wt.eu-S1765632AbXJOUk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765632AbXJOUk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbXJOUks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:40:48 -0400
Received: from archer.toppoint.de ([217.70.197.1]:54291 "EHLO mail.toppoint.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbXJOUkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:40:47 -0400
Date: Mon, 15 Oct 2007 22:29:56 +0200
From: Wilfried Klaebe <linux-kernel@chaos.in-kiel.de>
To: Rob Landley <rob@landley.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       David Newall <david@davidnewall.com>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: What still uses the block layer?
Message-ID: <20071015202956.GA29461@kaos.in-kiel.de>
References: <200710112011.22000.rob@landley.net> <200710141836.55211.rob@landley.net> <4712FE33.3000400@s5r6.in-berlin.de> <200710150426.04924.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710150426.04924.rob@landley.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mon, Oct 15, 2007 at 04:26:04AM -0500 schrieb Rob Landley:
> To clarify, I think that merging ide, sata, usb, firewire, and others into a 
> single device namespace causes each type of device to inherit that 
> namespace's cumulative ordering issues, which is a bad thing.  I have no real 
> attachment to the underlying scsi or block layers.  I've never seriously 
> worked on either (although I'm trying to understand both).
> 
> For example, usb devices are never easy to order.  IDE devices (back when they 
> had their own namespace) were trivial to order back when /dev/hda couldn't 
> move without use of a screwdriver.  USB and IDE devices are very different in 
> that it's not possible to plug a USB device into an IDE controller (not 
> without one _heck_ of an adapter) and vice versa.  USB devices usually live 
> outside the computer's case, and IDE devices inside the case.  They're not 
> the same thing.
> 
> Combining USB and IDE into the same /dev/sd? namespace makes enumerating the 
> IDE devices much harder than in the traditional "/dev/hdb doesn't move 
> without a screwdriver" model.

I have udev here, and it generates several useful symlinks.
/dev/disk/by-path/pci-0000:00:1f.1-scsi-0:0:0:0-part2 will always point
to the second primary partition of the IDE master on the first IDE
channel here, be there as many USB sticks as there may.

(But still I'd like it if it wasn't named "scsi-0:0:0:0", because the
"0:0:0:0" part could change.)

>  The merger creates a new problem for IDE, one 
> which didn't exist before: the addition or removal of other unrelated types 
> of devices may change this device's location next boot.  It may be possible 
> to add additional complication to the system to compensate, but what was the 
> advantage of merging the namespaces in the first place?

I don't think there was any intent to merge namespaces. It "just happened"
as a byproduct of having sata/pata use the scsi subsystem.

Wilfried
-- 
Irgendwas ist ja immer...
