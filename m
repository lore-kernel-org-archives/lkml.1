Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344AbYK3Esr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbYK3Esr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 23:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbYK3Esh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 23:48:37 -0500
Received: from phunq.net ([64.81.85.152]:59339 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752848AbYK3Esh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 23:48:37 -0500
From: Daniel Phillips <phillips@phunq.net>
To: tux3@tux3.org
Subject: Developing Tux3 with UML
Date: Sat, 29 Nov 2008 20:48:32 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811292048.33651.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Running the Tux3 kernel code under UML is easy, fast and safe.  Here is
a recipe where you can be up and running in about ten minutes from a
standing start:

   # get a kernel tree
   wget http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.5.tar.bz2
   tar -xjf linux-2.6.26.5.tar.bz2
   cd linux-2.6.26.5

   # get the latest tux3 patch and patch the kernel
   wget http://tux3.org/patches/tux3-2.6.26.5
   patch <tux3-2.6.26.5 -p1

   # build uml linux with tux3
   make defconfig ARCH=um
   make linux ARCH=um CONFIG_TUX3=y

   # get a root filesystem
   wget http://tux3.org/downloads/tuxroot.tar.bz2

   # make a tux3 filesystem in a file
   dd if=/dev/zero of=testdev bs=1M count=1
   tux3 mkfs testdev

   # boot uml using loop back on the root fs and tux3 test fs
   tar -xjf tuxroot.tar.bz2
   ./linux ubda=tuxroot ubdb=testdev

Log in to uml as root and:

   mount /dev/ubdb /mnt
   ls -l /mnt

To debug tux3/uml under gdb:
   gdb -args ./linux ubda=tuxroot ubdb=testdev
   run
   cont <a bunch of times, don't ask>
   <log in>

You can also run uml using real partitions for root and test:

   ./linux ubda=/dev/sdaX ubdb=/dev/sdaX

The only thing that needs to be special about the root filesystem is,
/etc/inittab has to refer to the uml ttys.  See umlroot/etc/inittab.

Regards,

Daniel
