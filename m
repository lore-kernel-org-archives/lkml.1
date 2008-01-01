Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbYAAM6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbYAAM6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 07:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbYAAM6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 07:58:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:41463 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbYAAM6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 07:58:38 -0500
Date: Tue, 1 Jan 2008 12:58:37 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.36 released
Message-ID: <20080101125837.GA31679@hera.kernel.org>
Reply-To: w@1wt.eu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

New year, new kernel :-)

Linux 2.4.36 is finally ready and has been checked long enough to
be released. Quite a bunch of bugs, build errors and security issues
have been fixed since 2.4.35, but all of those fixes were merged
into 2.4.35-stable. I should say that I'm quite statisfied of this
dual-branch release model which proves to be very successful at
separating quick fixes from changes which require more thorough testing.
The full changelog between 2.4.35 and 2.4.36 is appended at the end of
this mail.

The remaining changes between 2.4.35.5 and 2.4.36 are just minimal :
 - IDE support for JMicron 20363 and UDMA on ICH7
 - the addition of the mmap_min_addr sysctl which provides the ability to
   prevent processes from mapping the NULL address, thus preventing the
   exploitation of a kind of possibly yet undiscovered kernel bugs (NULL
   dereferences) to escalade privileges. This is the convergence of an
   Openwall kernel 2.4 patch by Solar Designer, and Eric Paris' 2.6 patch.

The mmap_min_addr protection is not enabled by default. In order to
activate it, you have to write the minimum allowed user-space address
in mmap_min_addr :

  # echo 4096 > /proc/sys/vm/mmap_min_addr

or alternatively :

  # sysctl -w vm.mmap_min_addr=4096

I have been running with values between 4096 and 65536 on various machines
without any problem. Default value is zero, thus disabling the protection.
Feedback from the field welcome, of course.

Concerning future versions, I have nothing pending in the queue anymore. I
will then go on with 2.4.36.X when bug fixes come in, and only open 2.4.37
when I get something which I do not consider suitable for 2.4.36.X.

Happy new year 2008 to everyone !
Willy

---
Changelog between 2.4.35 and 2.4.36
---

final:
 - v2.4.36-rc1 was released as 2.4.36 with no changes.

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

Summary of changes from v2.4.36-pre1 to v2.4.36-pre2
============================================

Andi Kleen (1):
      x86_64: Make sure to validate all 64bits of ptrace information

Franck Bourdonnec (1):
      fix missing MODULE_LICENSE in some drivers

Gilles Espinasse (1):
      fix unresolved symbols on alpha

Moritz Muehlenhoff (1):
      corrupted cramfs filesystems cause kernel oops (CVE-2006-5823)

Stephen Hemminger (1):
      Bridge STP timer fixes

Tony Battersby (1):
      sym53c8xx_2 SMP deadlock on driver load

Willy Tarreau (3):
      ATM: avoid kernel panic upon access to /proc/net/atm/arp
      PPP: fix crash using usb-serial on high speed devices
      Change VERSION to 2.4.36-pre2

dann frazier (4):
      [OpenPROM]: Fix signedness bug in openprom char driver
      [OpenPROM]: Fix user-access checking bugs in openpromfs
      [OpenPROM] Prevent overflow of sprintf buffer
      [OpenPROM] Prevent unsigned roll-overs in

ivaylo@bglans.net (2):
      IDE: enable support for JMicron 20363
      IDE: enable PATA UDMA support for ICH7

Summary of changes from v2.4.35 to v2.4.36-pre1
============================================

Marc Haisenko (1):
      b44: fix force mac address before ifconfig up

Willy Tarreau (12):
      build fix for lvm with gcc 4
      fix wdt83627 build breakage with gcc 4.x
      wdt83627: fix wdt_init() return code
      module fdomain_cs requires fdomain_setup()
      do not use gcc's builtin strpbrk
      fix incorrect use of -fno-unit-at-a-time on GCC >= 4
      second build fix for some rare buggy versions of GCC 4
      CVE-2007-3848 Privilege escalation via PR_SET_PDEATHSIG
      i386: do_test_wp_bit() must not be inlined
      restore -fno-unit-at-a-time on GCC >= 4
      sysctl to prevent normal processes from mapping NULL
      Change VERSION to 2.4.36-pre1

