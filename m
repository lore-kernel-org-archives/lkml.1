Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbYEYRr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbYEYRr4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 13:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbYEYRrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 13:47:45 -0400
Received: from rtr.ca ([76.10.145.34]:2054 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999AbYEYRro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 13:47:44 -0400
Message-ID: <4839A63E.4050409@rtr.ca>
Date: Sun, 25 May 2008 13:47:42 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Marvell 88SX7042 [4 Port SATA PCI-Express x4] Support/Questions
References: <alpine.DEB.1.10.0805250757550.18572@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0805250757550.18572@p34.internal.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Jeff has been working on this chipset/patching/etc:
..

Actually, I'm the one working on that chipset etc..  :)

> Looks like there are a couple cards sporting this new chip at the moment
..

There are lots of them out there, including Sonnet, Highpoint, and others.

> If one bought enough of these, one could possibly achieve speeds in 
> excess(!) of 1 gigabyte/second with enough drives and SW RAID in Linux.
> Does anyone have such a card? I would be interested if it could sustain 
> the maximum rate from each disk without any contention.
..

Sure, if the bus and memory are fast enough.  You'll hit the Linux/libata
transactions/sec limit at some point, but I don't know what that is.

Eg. Here's a 4X (I think) card in my PCIe video slot:

beefy:~# mdadm --create /dev/md0 --chunk=256 -l 0 --raid-devices=4 /dev/sd[bcde]
mdadm: array /dev/md0 started.

beefy:~# hdparm -t --direct /dev/sd[bcde] /dev/md0

/dev/sdb:
 Timing O_DIRECT disk reads:  218 MB in  3.01 seconds =  72.46 MB/sec

/dev/sdc:
 Timing O_DIRECT disk reads:  256 MB in  3.01 seconds =  85.00 MB/sec

/dev/sdd:
 Timing O_DIRECT disk reads:  192 MB in  3.01 seconds =  63.79 MB/sec

/dev/sde:
 Timing O_DIRECT disk reads:  256 MB in  3.01 seconds =  85.07 MB/sec

/dev/md0:
 Timing O_DIRECT disk reads:  768 MB in  3.00 seconds = 255.69 MB/sec

Similar results happen without the "--direct" flag as well.

> 2. How 'experimental' is it? 

The 7042 chipset is working rather well right now.
Older Marvell chips should still be considered "experimental"
for the time being.

Cheers
