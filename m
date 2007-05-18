Return-Path: <linux-kernel-owner+w=401wt.eu-S1761014AbXERGki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761014AbXERGki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbXERGkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:40:31 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56355 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbXERGk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:40:29 -0400
Date: Fri, 18 May 2007 08:41:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: sam@ravnborg.org
Subject: kbuild fixes for -rc1 (touches all arch .lds files)
Message-ID: <20070518064126.GA12193@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have following set of fixes queued for -rc1.
I no major comments are raised I will request for
inclusion tomorrow.


This patchset include the discussed infrastructure to silence
section mismatch warnings in the legitimite cases.
Included are also a few section mismatch fixes so my x86_64
and i386 defconfig builds are with no section mismatchs warnings.
modpost saw various improvements too.

Mike Frysinger have improved gen_initramfs.list and made the
source in scripts/ a tad more portable.

The most important bugfix is the MODALIAS fix for powerpc.


Patches will follow.

	Sam


Git repository:
  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git


Atsushi Nemoto (1):
      kbuild: make better section mismatch reports on i386, arm and mips

Li Yang (1):
      kbuild: add "Section mismatch" warning whitelist for powerpc

Mike Frysinger (4):
      kbuild: add support for reading stdin with gen_init_cpio
      kbuild: add support for squashing uid/gid in gen_initramfs_list.sh
      kbuild: include limits.h in sumversion.c for PATH_MAX
      kconfig: search harder for curses library in check-lxdialog.sh

Russell King (1):
      kbuild: make modpost section warnings clearer

Sam Ravnborg (6):
      all-archs: consolidate .text section definition in asm-generic
      all-archs: consolidate .data section definition in asm-generic
      kbuild: introduce __init_refok/__initdata_refok to supress section mismatch warnings
      init/main: use __init_refok to fix section mismatch
      mm: fix section mismatch warnings
      mm/slab: fix section mismatch warning

Sylvain Munaut (1):
      powerpc: Fix the MODALIAS generation in modpost for of devices

 arch/alpha/kernel/vmlinux.lds.S            |    4 +-
 arch/arm/kernel/vmlinux.lds.S              |    4 +-
 arch/arm26/kernel/vmlinux-arm26-xip.lds.in |    4 +-
 arch/arm26/kernel/vmlinux-arm26.lds.in     |    4 +-
 arch/avr32/kernel/vmlinux.lds.c            |    4 +-
 arch/blackfin/kernel/vmlinux.lds.S         |    4 +-
 arch/frv/kernel/vmlinux.lds.S              |    6 +-
 arch/h8300/kernel/vmlinux.lds.S            |    4 +-
 arch/i386/kernel/vmlinux.lds.S             |    4 +-
 arch/ia64/kernel/vmlinux.lds.S             |    9 +-
 arch/m32r/kernel/vmlinux.lds.S             |    4 +-
 arch/m68k/kernel/vmlinux-std.lds           |    4 +-
 arch/m68k/kernel/vmlinux-sun3.lds          |    4 +-
 arch/m68knommu/kernel/vmlinux.lds.S        |    4 +-
 arch/mips/kernel/vmlinux.lds.S             |    4 +-
 arch/parisc/kernel/vmlinux.lds.S           |    4 +-
 arch/powerpc/kernel/vmlinux.lds.S          |    5 +-
 arch/ppc/kernel/vmlinux.lds.S              |    4 +-
 arch/s390/kernel/vmlinux.lds.S             |    4 +-
 arch/sh/kernel/vmlinux.lds.S               |    4 +-
 arch/sh64/kernel/vmlinux.lds.S             |    4 +-
 arch/sparc/kernel/vmlinux.lds.S            |    4 +-
 arch/sparc64/kernel/vmlinux.lds.S          |    4 +-
 arch/um/kernel/dyn.lds.S                   |    5 +-
 arch/um/kernel/uml.lds.S                   |    4 +-
 arch/v850/kernel/vmlinux.lds.S             |    4 +-
 arch/x86_64/kernel/vmlinux.lds.S           |    4 +-
 arch/xtensa/kernel/vmlinux.lds.S           |    6 +-
 include/asm-generic/vmlinux.lds.h          |   12 ++
 include/linux/init.h                       |   13 ++
 init/main.c                                |    2 +-
 mm/page_alloc.c                            |    4 +-
 mm/slab.c                                  |    2 +-
 mm/sparse.c                                |    2 +-
 scripts/gen_initramfs_list.sh              |   12 +-
 scripts/kconfig/lxdialog/check-lxdialog.sh |   24 ++---
 scripts/mod/file2alias.c                   |   11 ++-
 scripts/mod/modpost.c                      |  169 +++++++++++++++++++---------
 scripts/mod/modpost.h                      |    3 +
 scripts/mod/sumversion.c                   |    1 +
 usr/gen_init_cpio.c                        |    4 +-
 41 files changed, 243 insertions(+), 139 deletions(-)
