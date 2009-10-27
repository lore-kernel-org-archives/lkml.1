Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZJ0DfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZJ0DfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 23:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZJ0DfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 23:35:10 -0400
Received: from smtp.tuells.org ([204.188.108.206]:47492 "EHLO tuells.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbZJ0DfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 23:35:09 -0400
X-Greylist: delayed 6442 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2009 23:35:09 EDT
Date: Mon, 26 Oct 2009 19:47:51 -0600
From: marcus hall <marcus@tuells.org>
To: linux-kernel@vger.kernel.org
Message-ID: <20091027014751.GA3144@bagatelle.tuells.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam_score: -1.0
X-Spam_bar: -
Subject: Cannot access non-LVM /boot partiton.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello..

I have a Fedora system that I recently upgraded to Fedora 11 and subsequently
I cannot access my /boot partition.  I have upgraded several systems without
any problems, and I am not sure what to look at that may be the source of
the problem.  I've asked on the fedora list with no response, and although I
don't think that it is a kernel problem, perhaps somebody can point me to
the right corner of userspace to start looking deeper.

The problem system has a pair of SATA disks that are mirrored.  They each
contain two partitions, a /boot partition on /dev/sda1 and /dev/sdb1, and
an LVM setup on /dev/sda2 and /dev/sdb2.  After booting the system, the
only disk device files in /dev are /dev/sda, /dev/sdb, and /dev/sdb2.  Grub
sees the boot partition just fine and gets into the kernel, which fails
after userspace starts mounting the filesystems because it cannot find /boot.
If I run fdisk, it is happy with the partition table on either disk.

During boot, the kernel seems to be recognizing the partitions on both disks,
since it shows "sda: sda1 sda2" etc.  But, something seems to be disabling
access to the first partition later on.  If I manually create a /dev/sda1
or /dev/sdb1 device file, whenever I try to access it I get ENODEV.

When I try to boot an earlier kernel that the system was running happily on
before, I get the same problems, so I believe that this is due to some change
in user space during the "upgrade".  It does seem reasonable to block access
to the /dev/sdaX devices, since the mirroring works from the /dev/sdbX
devices, and I am suspecting that something is removing /dev/sdb1 because
it has no LVM data on it, or something.  I'm suspecting that this might be
something in udev, but that's a weaker guess.

What could remove access to a disk partition in the kernel after it comes
up?  If I cat /proc/partitions, all I see are the LVM partitions.

Thanks in advance!

Marcus Hall
marcus@tuells.org
