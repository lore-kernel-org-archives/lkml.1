Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbYIGQ4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbYIGQ4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 12:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbYIGQ4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 12:56:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:48087 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbYIGQ42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 12:56:28 -0400
Date: Sun, 7 Sep 2008 16:56:25 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.37-rc1
Message-ID: <20080907165625.GA997@hera.kernel.org>
Reply-To: w@1wt.eu
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Sep 2008 16:56:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I've just released Linux 2.4.37-rc1.

This version includes all fixes that went into 2.4.36.7, plus a few
add-ons that were requested several times. Most of them are simply IDE
PCI updates to support recent IDE/SATA/AHCI controllers commonly found
on a lot of motherboards. Many of them have been successfully tested
(I personally tested ICH8, ICH9, MV6145 and JMicron 368). In fact, all
my intel-based motherboards had no working IDE or SATA at all and now
are all fully functional after a full week-end of build/boot/test
cycles.

Among other user-visible changes, I've merged Erik Andersen's old
patch to correctly register/unregister SCSI devices when plugging or
unplugging USB devices. Having been using it for the last 3 years, I
forgot how painful it was to use USB storage on a standard kernel 2.4
machine. Fortunately there are still users to remind me that!

Accompanying this patch is another one to add the "rootdelay" command
line parameter, which is necessary to boot on USB devices. This is
something all users (including me) have been using in various forms,
so let's merge it in a form compatible with kernel 2.6 instead of
having everyone patch each new release.

There are two fixes I had in my own tree that will be backported to
2.4.36.8. One fixes build of i386 without CONFIG_VT, and the other one
fixes duplex detection and setting on via-rhine.

The rest consists in minor updates (the Netfilter CLASSIFY target and
support for ADM8515 in Pegasus USB ethernet driver).

As previously announced, I've dropped the -pre naming in favor of -rc.
I expect the 2.4.37 cycle to be short because it's based on very stable
code and only includes minor additions, so the risk of a regression is
particularly low. If you're interested by or feel concerned by a change,
please test it and report your findings. If you are missing one minor
feature or driver which you think might be of interest to other people,
is already present in 2.6, and has a very low risk of regression,
please send it early so that we can merge it in an -rc for people to
test it. Also, if you want to post PCI ID updates (eg: IDE controllers),
it's OK provided that you test them on real hardware ; I don't want to
receive massive resyncs with 2.6 leading to untested drivers.

I was tempted by merging a kbuild-2.4 patch that brings build targets
allmodconfig, allyesconfig, randconfig, etc... and which I use before
every release to ensure everything builds. For instance, I know that
all 1167 modules I can configure on i386 build. But I figured I would
likely be the only user of this patch. If other persons find it useful,
please ask, I may reconsider the option, it's not intrusive at all.

I expect to release 2.4.37 around october or november (depending on my
spare time and reports in fact). There will probably be between 2 and 4
rc, this one is already very polished.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.37-rc1.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.37.log

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git
  http://www.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git/

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/wtarreau/linux-2.4.git

Last point, the changelog seems large because it includes all 2.4.36.X
changes. The diff with 2.4.36.7 only show something like 15 lines.

Now test, have fun and report !

Willy
--
Summary of changes from v2.4.36 to v2.4.37-rc1
============================================

Al Viro (1):
      Fix SMP ordering hole in fcntl_setlk() (CVE-2008-1669)

Axel Reinhold (1):
      add ICH9x support to ahci driver

Carsten (1):
      usb: add support for ADM8515 to pegasus.h

Chris Wright (1):
      asn1: additional sanity checking during BER decoding (CVE-2008-1673)

David Newall (1):
      usb-serial: back-port of pl2303.c from 2.6.24.1

David S. Miller (3):
      sit: Add missing kfree_skb() on pskb_may_pull() failure (CVE-2008-2136)
      sparc: Fix mmap VA span checking (CVE-2008-2137)
      sctp: Make sure N * sizeof(union sctp_addr) does not overflow (CVE-2008-2826)

Emeric Brun (1):
      x86 SMP: don't report error on uniprocessor machines

Erik Andersen (1):
      2.4.x USB and 1394 hotplug

Eugene Teo (1):
      wan: Missing capability checks in sbni_ioctl() (CVE-2008-3525)

Florin Malita (1):
      [PPPOE]: Missing result check in __pppoe_xmit().

Gilbert Ashley (1):
      Kernel patch to add rootdelay feature

Gilbert Ashley Gilbert (1):
      udf: fix uid/gid permissions

Gilles Espinasse (2):
      PCI ID updates for amd74xx
      ahci driver update

Glen Nakamura (3):
      ext2_readdir() filp->f_pos fix (try #2)
      Duplicate id in videodev.h
      Fix typo in acpi_boot_init

Gunnar Larisch (1):
      3c980-TX needs EXTRA_PREAMBLE

Herbert Xu (1):
      net pppoe: Check packet length on all receive paths

Ivaylo Josifov (1):
      ide-generic: Marvell IDE 88SE6101 2.4.XX support

Jesse Brandeburg (1):
      ip-pnp-dhcp: wait lazily when doing dhcp for diskless systems

Li Zefan (1):
      ACPI: check a return value correctly in acpi_power_get_context()

Patrick McHardy (1):
      [TCP]: Fix shrinking windows with window scaling

Roel Kluin (1):
      wireless, airo: waitbusy() won't delay

Solar Designer (1):
      IDE: fix panic during probe with negative IRQ

Stephen Hemminger (1):
      ipv6: use timer pending

Steve Rosenbluth (3):
      signal.h: use an explicit cast to silent compiler warnings
      fix build error with some flavours of gcc 2.95.3
      ata_piix: add PCI ID for intel ICH8 controller

Unknown (1):
      linux-2.4 CLASSIFY patch.

Vlad Yasevich (2):
      sctp: Do not leak memory on multiple listen() calls
      sctp: Allow only 1 listening socket with SO_REUSEADDR

Willy Tarreau (15):
      Do not complain about gcc 4.2 for user-space
      i386: fix setCx86/getCx86 race in macros
      security: insufficient range checks in certain fault handlers
      intermezzo: fix uninitialized use of pointer in error path
      Fix dnotify/close race (CVE-2008-1375)
      ide-generic: add support for JMicron 368
      ide-generic: add support for Marvell 6145 PATA port
      ata_piix: add support for ICH9 in IDE mode
      doc: explain how to build a suitable gcc in Documentation/using-newer-gcc.txt
      sound: fix warning due to incorrect error code checking in ad1889
      sky2: fix uninitialized "mss" variable in sky2_xmit_frame()
      x86 would not build without CONFIG_VT
      via-rhine: fix mii duplex detection during link monitoring
      pc_keyb: fix breakage on ia64/mips/mips64
      Change VERSION to 2.4.37-rc1

Xiong Wu (1):
      Correct the upto value during list conntrack information

dann frazier (8):
      avoid semi-infinite loop when mounting bad ext2
      ext2: skip pages past number of blocks in ext2_find_entry
      memory leak when socket is release()d before PPPIOCGCHAN has been called on it
      2.4: fix memory corruption from misinterpreted bad_inode_ops return values
      2.4: [SCSI] aacraid: Fix security hole
      2.4: USB: fix DoS in pwc USB video driver
      2.4: [POWERPC] CHRP: Fix possible NULL pointer dereference
      old buffer overflow in moxa driver (CVE-2005-0504)

