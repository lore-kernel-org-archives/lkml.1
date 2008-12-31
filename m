Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbYLaDgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbYLaDgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 22:36:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbYLaDfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 22:35:53 -0500
Received: from phunq.net ([64.81.85.152]:52978 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752230AbYLaDfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 22:35:52 -0500
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: Tux3 report: A Golden Copy
Date: Tue, 30 Dec 2008 19:35:48 -0800
User-Agent: KMail/1.9.5
Cc: linux-fsdevel@vger.kernel.org, tux3@tux3.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812301935.49303.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All versions of Tux3 are special, we think, but this one is a little 
more special than all the rest: for the first time, it survives 
repeated fsx-linux runs.  That is mainly due to a burst of amazingly 
accurate work by Hirofumi, and finishing up the SMP lock coverage.

Here is the HowTo again, lightly updated to install the first official 
Tux3 Golden Copy:

   # Get a kernel tree:
   wget http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.5.tar.bz2
   tar -xjf linux-2.6.26.5.tar.bz2
   cd linux-2.6.26.5

   # Get the Christmas tux3 patch and patch the kernel:
   wget http://tux3.org/patches/tux3-2.6.26.5-4
   patch <tux3-2.6.26.5-4 -p1

   # Build linux with tux3:
   make defconfig
   make CONFIG_TUX3=y
   sudo make install

   # Get the Christmas tux3 userspace snapshot:
   wget http://tux3.org/downloads/snapshots/tux3-20081230.tar.gz
   tar -xzf tux3-20081230.tar.gz
   cd tux3/user
   make

   # make a tux3 filesystem
   sudo ./tux3 mkfs /dev/<testpartition>

Boot and mount!

   cat /proc/filesystems | grep tux3 && mount /dev/<testpartition> /mnt

Recovery after crash or unexpected shutdown is easy:

   tux3 mkfs <volname>

In other words, do not expect Tux3 to survive this kind of treatment 
just yet.  Atomic commit is on the way, and is the last major change 
planned before starting review.

Caveats are the same as before:

   http://kerneltrap.org/mailarchive/linux-fsdevel/2008/12/26/4493214
   "Tux3 for Christmas"

And finally the usual offer:  If you drop by to lend a hand we will 
treat you with respect and admiration for showing such courage, and we 
will make you even more famous than you already are, by carving your 
name in the Tux3 Hall of Fame:

  http://tux3.org/about.html

Regards,

Daniel
