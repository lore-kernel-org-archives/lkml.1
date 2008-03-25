Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbYCYC37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbYCYC37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 22:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbYCYC3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 22:29:51 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:55154 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbYCYC3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 22:29:51 -0400
Date: Mon, 24 Mar 2008 22:29:43 -0400
Message-Id: <200803250229.m2P2Th2D004970@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Subject: non-idempotent Makefile in 2.6.25-rc6?
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.24.x, after building a kernel+modules, successive runs of make do
very little:

[24]$ make
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
Kernel: arch/x86/boot/bzImage is ready  (#21)
  Building modules, stage 2.
  MODPOST 27 modules

But in v2.6.25-rc6-294-gcc7feea, re-running make seems to rebuild stuff that
may not need to be rebuilt, wasting cycles:

[25]$ make
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  LD      vmlinux.o
  MODPOST vmlinux.o
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
  KSYM    .tmp_kallsyms1.S
  AS      .tmp_kallsyms1.o
  LD      .tmp_vmlinux2
  KSYM    .tmp_kallsyms2.S
  AS      .tmp_kallsyms2.o
  LD      .tmp_vmlinux3
  KSYM    .tmp_kallsyms3.S
  AS      .tmp_kallsyms3.o
  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map
  CC      arch/x86/boot/version.o
  LD      arch/x86/boot/setup.elf
  OBJCOPY arch/x86/boot/setup.bin
  OBJCOPY arch/x86/boot/compressed/vmlinux.bin
  GZIP    arch/x86/boot/compressed/vmlinux.bin.gz
  LD      arch/x86/boot/compressed/piggy.o
  LD      arch/x86/boot/compressed/vmlinux
  OBJCOPY arch/x86/boot/vmlinux.bin
  BUILD   arch/x86/boot/bzImage
Root device is (8, 1)
Setup is 11192 bytes (padded to 11264 bytes).
System is 1382 kB
Kernel: arch/x86/boot/bzImage is ready  (#215)
  Building modules, stage 2.
  MODPOST 26 modules


Why all the re-linking and such?  Is this a known issue/problem, or intended
functionality?

BTW, my files' timestamps and machine times (ntpd, etc.) are fine.

Thanks,
Erez.
