Return-Path: <linux-kernel-owner+w=401wt.eu-S932389AbXLPXir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbXLPXir (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 18:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761629AbXLPXij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 18:38:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:34547 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761490AbXLPXii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 18:38:38 -0500
Date: Sun, 16 Dec 2007 23:38:33 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.36-rc1
Message-ID: <20071216233833.GA16691@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.4.36-rc1.

It fixes several vulnerabilities, some of them discovered in 2.6.
Among them, we find 2 ISDN overflows, one case of insufficient
permissions checking on core dumps, the ability for a process to
escape ptrace-based syscall policy checking, and the possibility
for a specially crafted ELF binary to bypass the recently added
restrictions on the minimum MMAP address.

Due to several reports of mis-compilations with GCC 4.2, I have
explicitly disabled its use with an explicit message.

I got one report from Krzysztof Strasburger of a good old 386 not
booting anymore due to a misplaced "HAS_TSC" in the config. His
fix made perfect sense and looked good, but please complain if you
notice a related problem on old hardware.

It was also not possible to build for ia32 on x86_64 due to a
recent vulnerability fix in which an update to the size of the
instruction was missing (cmpl -> cmpq).

I'm still planning on releasing 2.4.36 around the end of the year
(eg: last week-end), if nothing new is discovered since. If new
fixes are merged by that time, I may delay it a little bit to the
beginning of January.

Please test it, beat it and report any problems (build or bugs).

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.36-rc1.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.36.log

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git
  http://www.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git/

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/wtarreau/linux-2.4.git

Thanks,
Willy

---

Summary of changes from v2.4.36-pre2 to v2.4.36-rc1
============================================

Jonas Danielsson (1):
      net/ipv4/arp.c: Fix arp reply when sender ip 0

Krzysztof Strasburger (1):
      fix arch/i386/config.in to be able to boot on 386

Pete Zaitcev (1):
      usb: Move linux-usb-devel

Willy Tarreau (8):
      GCC >= 4.2 miscompiles the kernel
      prevent do_brk() from allocating below mmap_min_addr
      fix build of ia32entry.S on x86_64
      vfs: coredumping fix
      isdn: avoid copying overly-long strings
      prevent SIGCONT from waking up a PTRACED process (CVE-2007-4774)
      isdn: fix isdn_ioctl memory overrun vulnerability
      Change VERSION to 2.4.36-rc1

