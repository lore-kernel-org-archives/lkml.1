Return-Path: <linux-kernel-owner+w=401wt.eu-S1030555AbXCDDAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030555AbXCDDAq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 22:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030515AbXCDDAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 22:00:46 -0500
Received: from hot.fatooh.org ([63.99.9.127]:58335 "EHLO hot.fatooh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030236AbXCDDAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 22:00:37 -0500
X-Greylist: delayed 1275 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Mar 2007 22:00:37 EST
Message-ID: <45EA3159.4020508@fatooh.org>
Date: Sat, 03 Mar 2007 18:39:21 -0800
From: Corey Hickey <bugfood-ml@fatooh.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.20.1: reproducible hard lockup (with some configurations)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am experiencing a hard lockup with 2.6.20.1. Whenever the system locks
up, it locks up hard: nothing is printed to the console and the magic
SysRQ key has no effect--the only thing I can do is poke the reset
button. I have reasonable faith in the stability of my hardware: I can
run memtest86+ for hours without problems; likewise with burnK7,
mencoder, and various other programs that stress the CPU. I've never had
this problem (or any similar one) with 2.6.19 and earlier.

The problem originally manifested whenever I initiated a RAID-5 resync.
I reported the problem to linux-raid, but Neil Brown wasn't able to
reproduce it and he suggested I was having trouble with a lower-level
driver. I've messed around for many hours with many different kernel
configurations, but all I've been able to find out is that, with some
configurations, the RAID resync doesn't immediately cause a lockup, but
a lockup happens later (sometimes hours later) nonetheless. Since the
late lockup isn't as easily reproducible, I'll concentrate the rest of
this report on conditions that lead to immediate lockup.

When the lockup is triggered by a resync, it is very easy to reproduce:
1. Boot with 'init=/bin/bash'.
2. Run 'mdadm -A /dev/md2 -U resync'.
3. Wait about 1 second. The system will lock up.

System information:
Athlon64 3400+
64-bit Linux 2.6.20.1 compiled with GCC 4.1.2
64-bit Debian Sid
RAID-5 of 5 devices:
   /dev/hda   (IDE hard drive)
   /dev/sda6  (partition on SATA hard drive)
   /dev/sdb   (SATA hard drive)
   /dev/sdc6  (partition on SATA hard drive)
   /dev/sdd   (SATA hard drive)
SATA and IDE drives mounted to onboard nVidia controllers
I'm using the libata SATA driver and the old IDE driver

My full kernel .config is here:
http://fatooh.org/files/tmp/config-2.6.20.1
...and the output of 'lspci -v' is here:
http://fatooh.org/files/tmp/lspci-v

If anybody has any suggestions, I would be very grateful. I'd also be
happy to run further tests or provide any other information that may be
useful.

Thank you,
Corey
