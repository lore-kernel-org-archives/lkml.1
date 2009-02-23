Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbZBWIOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbZBWIOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 03:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbZBWIOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 03:14:25 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:51561 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbZBWIOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 03:14:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wVsc/tEHJL+w8RsXikGyCHTsSfRtzug1SAlHahlr4mthx9hIyE0rV/y2oSlSh7XK+p
         Rk7UTw2p5zMY3t+V0W7xWIOb0LrfO8b/lWQH766/o+Q2GdTDNNUpTwmtjEXxfa8B6dcX
         BUPt47B53odro7ywjULOtC+yKljg6Q96WOGIw=
Date: Mon, 23 Feb 2009 11:14:29 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>, Jiri Slaby <jirislaby@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel building procedure changed?
Message-ID: <20090223081429.GB29898@localhost>
References: <20090222220747.GB7279@localhost> <20090222221653.GA30498@uranus.ravnborg.org> <49A1D167.8050801@gmail.com> <20090222230031.GB30619@uranus.ravnborg.org> <20090223074837.GA29898@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223074837.GA29898@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Mon, Feb 23, 2009 at 10:48:37AM +0300]

...

| Sam, it seems I never paid attention on Makefile
| rules before. Which means -- I don't know if kernel
| build procedure should behave like it do now.
| 
| We have the following rule (arch/x86/kernel/Makefile)
| 
| extra-y                := head_$(BITS).o head$(BITS).o head.o init_task.o
| vmlinux.lds
| 
| Does it mean that any obj-y targets should be built before
| extra-y? If "yes" -- all is fine and works well and I'm just
| noising here (sorry for that).
| 
| To be precise -- I don't remember how it worked before :)
| I mean it's possible that my previous workflow was:
| 
| 1) build whole kernel by "make"
| 2) modify head_64.S
| 3) run "make arch/x86/kernel/head_64.o"
| 
| So I will try to repeat these 3 points and report.
| 
| 	- Cyrill -

Ok, I just finished building the whole kernel.
And now building this particular single file is
passed fine.

---

cyrill@lenovo linux-2.6.git $ make
...
Root device is (8, 5)
Setup is 11388 bytes (padded to 11776 bytes).
System is 2819 kB
CRC 3cf5b442
Kernel: arch/x86/boot/bzImage is ready  (#13)
  Building modules, stage 2.
  MODPOST 1 modules
  CC      drivers/scsi/scsi_wait_scan.mod.o
  LD [M]  drivers/scsi/scsi_wait_scan.ko
cyrill@lenovo linux-2.6.git $ patch -p1 < patches/x86-remove-balign 
patching file arch/x86/kernel/head_64.S
cyrill@lenovo linux-2.6.git $ make arch/x86/kernel/head_64.o
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  AS      arch/x86/kernel/head_64.o
  VDSOSYM arch/x86/vdso/vdso-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-syscall-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-syms.lds
  LD      arch/x86/vdso/built-in.o
  CC      kernel/trace/trace.o
  LD      kernel/trace/built-in.o
  CC      kernel/module.o
  CC      kernel/kexec.o
  LD      kernel/built-in.o
---

So all builds fine Sam. But frankly I don't understand why
I have to build the whole kernel to be able to compile
head_64.S.

	- Cyrill -
