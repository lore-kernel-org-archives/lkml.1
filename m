Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbXJaKCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbXJaKCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXJaKC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:02:29 -0400
Received: from rwcrmhc11.comcast.net ([204.127.192.81]:34907 "EHLO
	rwcrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbXJaKC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:02:29 -0400
Subject: Re: Major SATA / EXT3 Issue?
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20071027134705.310487f3@the-village.bc.nu>
References: <1193451712.6639.13.camel@localhost>
	 <20071027134705.310487f3@the-village.bc.nu>
Content-Type: text/plain
Date: Wed, 31 Oct 2007 05:08:50 -0500
Message-Id: <1193825330.6392.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First, let me thank you for your response, and apologize for taking so
long to get back to you.  I have not been able to "cut loose" from my
day job for the past several days as I have been completly tied up
loading and configuring a dozen Thinkpads scheduled to be sacraficed
next week.

With this failure there was no data to be collected from the time of the
failure- as previously stated, the system "appeared" to lock up.  I
could not switch to an alternitive tty nor could I ssh into the system
from one of my other boxes. 

Nothing showed in the logs at the time of the failure.

On subsequent reboots I received "scrolling" errors on both of the
devices in question of the type previously reported.  This continued
through every attempt to reboot.

Attempts to clean things up with an fsck always resulted in the
following message

fsck.ext2: No such file or directory while trying to open /dev/sdb1

(or /dev/sda1 dependent on which device was being used)

I attempted to run gparted to see what if any file system the system
thought might be lurking on these drives, but gparted would always hang
up "scanning devices"

This morning I plugged the drives back in and brought the system up on a
2.6.24-rc1-git4 kernel and shazamm!  Both drives were seen by the system
and the only errors seen by fsck were a few unused / orphan inodes.  

I am not sure where to go from here - I have been in the game long
enough to be doubtful about multiple INDEPENDENT hardware failures -
which is why after "blowing off" the first dead SATA drive, I took
another look when I had a second one fail in the same manner within a
few days.

Both of the previously failed drives are up and running at this time.
Understandably I am not ready to put "real data" back on them but I will
button up the case, bring the system back up, and come up withsome way
to flow "test data" between these two devices looking for another
failure.

Once again thanks for your time.

Chris






On Sat, 2007-10-27 at 13:47 +0100, Alan Cox wrote:
> On Fri, 26 Oct 2007 21:21:52 -0500
> Chris Holvenstot <cholvenstot@comcast.net> wrote:
> 
> > My SATA controller is integrated on my MSI motherboard and sports four
> > ports.  It is implemented using the Nvidia CK804 chipset.  My processor
> > is an AMD64 X2 4600+ running the 32 bit version of Linux.  
> > 
> > I have had these drives up and running for about six months.=
> 
> You don't provide enough information to even guess. The whole of the
> relevant part of the ata messages would be a lot more useful than the
> cutting/pasting of bits you've provided.

> The BIOS finding the drive is indicating it responds to identify and the
> basic commands (and usually means your cabling is fine), but really the
> rest of the trace is needed to see what occurs next. If the drive has
> gone then the partition table read will fail and you won't
> get /dev/sdb[something] for it.
> 

