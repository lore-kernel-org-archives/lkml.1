Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbXF3Nl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbXF3Nl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 09:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757222AbXF3NlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 09:41:19 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:19939 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756979AbXF3NlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 09:41:17 -0400
X-SBRS: None
X-RemoteIP: 81.1.80.38
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=D19gQVrFAAAA:8 a=Zcu47fyDbWYHQSP2ZgwA:9 a=SKEz_M-l9lk9m9kuVsUA:7 a=H97HimGPGbuaJunIqrQkOVbUXRgA:4 a=g9JnencGIyEA:10
X-IronPort-AV: E=Sophos;i="4.16,480,1175468400"; 
   d="scan'208";a="4966916"
Subject: Re: sh section mismatches [was Re: 2.6.22-rc6 on Dreamcast (SH4)]
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linuxsh-dev@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <a781481a0706280457r4abb5046wc82cff9d49b7975e@mail.gmail.com>
References: <a781481a0706280457r4abb5046wc82cff9d49b7975e@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 30 Jun 2007 14:40:53 +0100
Message-Id: <1183210853.6016.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-28 at 17:27 +0530, Satyam Sharma wrote:
> Hi,
> 
> > On Monday 25 June 2007, Adrian McMenamin wrote:
> > > Still getting this:
> > >
> > >  MODPOST vmlinux
> > > WARNING: arch/sh/boards/dreamcast/built-in.o(.data+0x0): Section
> > > mismatch: reference to .init.text: (between 'mv_dreamcast' and
> > > 'systemasic_int')
> 
> I had sent a patch for this earlier ... Adrian, did you try (build + boot +
> testrun) with it? Does this one go away (and system executes fine)?
> 
> [ http://lkml.org/lkml/diff/2007/6/23/116/1 ]
> 
> [ This has to do with __init functions calling __initmv functions in a
> zillion files in arch/sh/boards/.../setup.c which is problematic when
> __initmv is not __init itself (!SH_GENERIC && !SH_UNKNOWN) ]
> 
> > > WARNING: drivers/built-in.o(.text+0x168e0): Section mismatch: reference
> > > to .init.data: (between 'pvr2fb_check_var' and 'pvr2fb_interrupt')
> > > WARNING: drivers/built-in.o(.text+0x1701c): Section mismatch: reference
> > > to .init.data: (between 'pvr2fb_pci_probe' and 'read_mem')
> > > WARNING: drivers/built-in.o(.text+0x17024): Section mismatch: reference
> > > to .init.text: (between 'pvr2fb_pci_probe' and 'read_mem')
> > > WARNING: drivers/built-in.o(.data+0x738): Section mismatch: reference
> > > to .init.text: (between 'board_list' and 'pvr2fb_pci_driver')
> > > WARNING: drivers/built-in.o(.data+0x750): Section mismatch: reference
> > > to .init.text: (between 'board_list' and 'pvr2fb_pci_driver')
> 
> drivers/video/pvr2fb.c is a mess with __init, __initdata, __devinit and
> __devinitdata (__exit and __devexit variants for good measure) all being
> used and referencing each other freely ... I have no idea what function
> should actually be what. Sam normally knows about such things,
> adding him to Cc: list.
> 

Finally got around to applying this patch, but it doesn't fix the
problem...

adrian@bossclass:~/linux-2.6.21$ patch -p1 <section.patch 
patching file arch/sh/boards/dreamcast/setup.c
patching file arch/sh/boards/hp6xx/setup.c
patching file arch/sh/boards/landisk/setup.c
patching file arch/sh/boards/mpc1211/setup.c
patching file arch/sh/boards/renesas/hs7751rvoip/setup.c
patching file arch/sh/boards/renesas/r7780rp/setup.c
patching file arch/sh/boards/renesas/rts7751r2d/setup.c
patching file arch/sh/boards/se/7343/setup.c
patching file arch/sh/boards/se/770x/setup.c
patching file arch/sh/boards/se/7722/setup.c
patching file arch/sh/boards/se/7780/setup.c
patching file arch/sh/boards/sh03/setup.c
patching file arch/sh/boards/snapgear/setup.c
patching file arch/sh/boards/superh/microdev/setup.c
adrian@bossclass:~/linux-2.6.21$ make ARCH=sh
CROSS_COMPILE=/home/adrian/buildroot/build_sh4/staging_dir/bin/sh4-linux- modules zImage -j3  
  SYMLINK include/asm-sh/cpu -> include/asm-sh/cpu-sh4
  SYMLINK include/asm-sh/mach -> include/asm-sh/dreamcast
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
make[1]: `include/asm-sh/machtypes.h' is up to date.
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CC      arch/sh/boards/dreamcast/setup.o
  LD      arch/sh/boards/dreamcast/built-in.o
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
  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map
  MODPOST vmlinux
WARNING: drivers/built-in.o(.text+0x168e0): Section mismatch: reference
to .init.data: (between 'pvr2fb_check_var' and 'pvr2fb_interrupt')
WARNING: drivers/built-in.o(.text+0x1701c): Section mismatch: reference
to .init.data: (between 'pvr2fb_pci_probe' and 'read_mem')
WARNING: drivers/built-in.o(.text+0x17024): Section mismatch: reference
to .init.text: (between 'pvr2fb_pci_probe' and 'read_mem')
WARNING: drivers/built-in.o(.data+0x738): Section mismatch: reference
to .init.text: (between 'board_list' and 'pvr2fb_pci_driver')
WARNING: drivers/built-in.o(.data+0x750): Section mismatch: reference
to .init.text: (between 'board_list' and 'pvr2fb_pci_driver')
  Building modules, stage 2.
  MODPOST 14 modules
  OBJCOPY arch/sh/boot/compressed/vmlinux.bin
  GZIP    arch/sh/boot/compressed/vmlinux.bin.gz
  LD      arch/sh/boot/compressed/piggy.o
  LD      arch/sh/boot/compressed/vmlinux
  OBJCOPY arch/sh/boot/zImage
  Kernel: arch/sh/boot/zImage is ready

