Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbZKTFlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbZKTFlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 00:41:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbZKTFlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 00:41:06 -0500
Received: from 70-90-202-97-Albuquerque.hfc.comcastbusiness.net ([70.90.202.97]:55193
	"EHLO deneb.dwf.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZKTFlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 00:41:05 -0500
X-Greylist: delayed 2382 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 00:41:05 EST
Message-Id: <200911200501.nAK51SYc019858@deneb.dwf.com>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3
To: linux-kernel@vger.kernel.org
Subject: Problems building 2.6.31.6 with 64bit Fedora-11
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 19 Nov 2009 22:01:28 -0700
From: Reg Clemens <reg@dwf.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, Im new to Fedora-11, and this will be my first 64bit
kernel build, so this is probably going to be something
stupid, but I dont see it.

The top of my .config file reads:

---

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.31.6-PPS
# Thu Nov 19 20:08:27 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y

--- 

So it seems that I am really doing a 64bit build, but the problems
start with the first cc/ld, viz

---

[root@deneb linux-2.6.31.6-PPS]# make -j3 mod
ules ; make -j3 bzImage
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf -s arch/x86/Kconfig
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  HOSTCC  scripts/kallsyms
  CC      scripts/mod/empty.o
  HOSTCC  scripts/selinux/mdp/mdp
nm: scripts/mod/empty.o: File format not recognized
objdump: scripts/mod/empty.o: File format not recognized
  HOSTCC  scripts/mod/mk_elfconfig
  HOSTCC  scripts/pnmtologo
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/modpost.o
  HOSTCC  scripts/mod/sumversion.o
  HOSTCC  scripts/conmakehash
  HOSTLD  scripts/mod/modpost
  CC      kernel/bounds.s
  GEN     include/linux/bounds.h
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/asm/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CC [M]  arch/x86/crypto/crc32c-intel.o
  CC [M]  arch/x86/kernel/test_nx.o
  CC [M]  arch/x86/kernel/microcode_core.o
nm: arch/x86/crypto/crc32c-intel.o: File format not recognized
nm: arch/x86/kernel/test_nx.o: File format not recognized
objdump: arch/x86/kernel/test_nx.o: File format not recognized
objdump: arch/x86/crypto/crc32c-intel.o: File format not recognized
  CC [M]  arch/x86/kvm/svm.o
  CC [M]  arch/x86/kvm/vmx.o
nm: arch/x86/kernel/microcode_core.o: File format not recognized

---

So whats going on here?
Why the file-format-not-recognized ???

-- 
                                        Reg.Clemens
                                        reg@dwf.com


