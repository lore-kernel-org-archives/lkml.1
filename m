Return-Path: <linux-kernel-owner+w=401wt.eu-S1756320AbXKFNVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbXKFNVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 08:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbXKFNVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 08:21:07 -0500
Received: from morrison.andev.ch ([213.133.123.55]:65412 "EHLO
	morrison.andev.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbXKFNVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 08:21:06 -0500
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Nov 2007 08:21:06 EST
Date: Tue, 6 Nov 2007 14:13:10 +0100
From: Petar Bogdanovic <list+2007@smokva.net>
To: linux-kernel@vger.kernel.org
Subject: dd/mke2fs on loopback hangs
Message-ID: <20071106131310.GA8628@pintail.smokva.net>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I experience some strange problems with my loopback-on-ext3-setup.
After creating a plain `zeroed' dummy-file and doing a /dev/loop/0 on
it, every dd or mke2fs hangs while doing certain write()s. Here are the
steps just in order to show, how simple the setup is:

	1) create a dummy file (size: 1GB or less)
		dd if=/dev/zero of=dummy bs=1M count=1000

	2) create a loopback device on the dummy file
		losetup /dev/loop/0 dummy

	3) write on the loopback device or create a filesystem
		dd if=/dev/zero of=/dev/loop/0 bs=1M
		mke2fs -m 0 /dev/loop/0


mke2fs will take ages to complete but not _every_ time. It has happend
once, that it completed very fast during the first run. The same goes
for dd -- it takes nearly forever:

	# dd if=/dev/zero of=/dev/loop/0 bs=1M count=500
	500+0 records in
	500+0 records out
	524288000 bytes (524 MB) copied, 547.585 s, 957 kB/s
	                                            ^^^^^^^^


While dd/mke2fs hangs, it's worth mentioning that firefox hangs too. I
also do not have any other problems with IO besides this one.

A short test on an external USB-vfat-drive did not show the same
behaviour, so maybe it has to do something with my filesystem options:

	# dumpe2fs -h /dev/sda2
	dumpe2fs 1.40.2 (12-Jul-2007)
	Filesystem volume name:   <none>
	Last mounted on:          <not available>
	Filesystem UUID:          794a82ae-b09b-48d0-901d-234dfdf28116
	Filesystem magic number:  0xEF53
	Filesystem revision #:    1 (dynamic)
	Filesystem features:      has_journal resize_inode dir_index filetype needs_recovery sparse_super large_file
	Filesystem flags:         signed directory hash 
	Default mount options:    (none)
	Filesystem state:         clean
	Errors behavior:          Continue
	Filesystem OS type:       Linux
	Inode count:              9043968
	Block count:              18067100
	Reserved block count:     903355
	Free blocks:              17000463
	Free inodes:              8954830
	First block:              0
	Block size:               4096
	Fragment size:            4096
	Reserved GDT blocks:      1019
	Blocks per group:         32768
	Fragments per group:      32768
	Inodes per group:         16384
	Inode blocks per group:   512
	Filesystem created:       Wed Aug 29 13:27:22 2007
	Last mount time:          Tue Nov  6 12:47:25 2007
	Last write time:          Tue Nov  6 12:47:25 2007
	Mount count:              21
	Maximum mount count:      21
	Last checked:             Tue Oct 30 17:21:00 2007
	Check interval:           15552000 (6 months)
	Next check after:         Sun Apr 27 18:21:00 2008
	Reserved blocks uid:      0 (user root)
	Reserved blocks gid:      0 (group root)
	First inode:              11
	Inode size:               128
	Journal inode:            8
	Default directory hash:   tea
	Directory Hash Seed:      a35cc1dc-1c7d-4fce-9c37-5092b932be09
	Journal backup:           inode blocks
	Journal size:             128M


Thanks for any kind of hint,

Petar


P.S:	$ uname -a
	Linux pintail 2.6.23-ARCH #1 SMP PREEMPT Sat Oct 27 09:04:14 UTC
	2007 i686 Intel(R) Pentium(R) M processor 1.70GHz GenuineIntel
	GNU/Linux
