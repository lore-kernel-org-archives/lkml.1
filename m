Return-Path: <linux-kernel-owner+w=401wt.eu-S1756987AbYBPP4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbYBPP4j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 10:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYBPP4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 10:56:30 -0500
Received: from rtr.ca ([76.10.145.34]:3660 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbYBPP43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 10:56:29 -0500
Message-ID: <47B707AC.20305@rtr.ca>
Date: Sat, 16 Feb 2008 10:56:28 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>
Subject: hdparm-8.1 now available
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hdparm has now been updated to version 8.1,
and includes some significant new features of
potential interest to Linux kernel storage hackers:

The new --make-bad-sector flag can be used to deliberately
corrupt a sector on the media (creating a media error situation).
This can be very handy for testing error recovery strategies
and timeouts for devices and RAIDs.

It uses the new ATA WRITE_UNC_EXT command (designed for the purpose)
when the drive supports it, otherwise it will try and fall back on
the older WRITE_LONG command (which is limited to LBA28).

The manpage has more information on this option.

There is also a new --write-sector (aka. --repair-sector) flag
to *fix* a bad sector.  This can be used later to undo the bad
sectors created by the --make-bad-sector flag.

The new --read-sector flag can be used to test a sector
for media errors.  I generally use the following sequence here:

   hdparm --make-bad-sector nnnnnnnn /dev/sdb  ## corrup a sector
   hdparm --read-sector nnnnnnnn /dev/sdb    ## verify that it is now bad

   test my device driver etc..

   hdparm --repair-sector nnnnnnn /dev/sdb  ## fix the bad sector
   hdparm --read-sector nnnnnnn /dev/sdb  ## verify that it is now fixed


hdparm also now has a new -N flag for dealing with Host-Protected-Areas (HPA),
and other, more minor, fixes and enhancements.

hdparm-8.1 is available at http://sourceforge.net/projects/hdparm/

Thanks to Bruce Allen for supplying me with test drives
which implement the new WRITE_UNC_EXT command.

Cheers

Mark Lord
