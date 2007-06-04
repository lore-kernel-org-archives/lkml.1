Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbXFDSod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbXFDSod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758135AbXFDSoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:44:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:49519 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbXFDSoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:44:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=RWLnJwKersSK+k5qD027Y02cHBBc2F+a/S31Oeww7mnRiF/J9IANYXdys2emzOSdGEtczSvpZdld1iTKkLgwrQbB6ygQXBIogVToYe33f632QCHnEqeS/WDR6A2mktUoVj8Jgxir+8Z5h1kTMs1RKx89cpmXTdTR/nZBd7gWaKk=
Message-ID: <46645DC9.8080003@gmail.com>
Date: Mon, 04 Jun 2007 11:45:29 -0700
From: Tom <fivemiletom@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: RE : Building kernel 2.6.21.3 for arm on cygwin
References: <46608757.4020503@gmail.com><20070601212208.GA4559@uranus.ravnborg.org> <4660971E.5020609@gmail.com> <12D4B80525C5B744A216276E209921D9CE8016@MIAMI.xi-lite.lan>
In-Reply-To: <12D4B80525C5B744A216276E209921D9CE8016@MIAMI.xi-lite.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam


enclosed is the 'k_smf.patch' which modifies three files to enable the 
kernel 2.6.21.3 to be built under cygwin:
host:  cygwin 1.5.24, hostcc= gcc 3.4.4
cross: arm-linux-uclibcgnueabi-gcc (GCC) 4.1.2
cmd:   make ARCH=arm CROSS_COMPILE=arm-linux- \
        HOST_LOADLIBES="-lcurses -lintl" at91rm9200dk_defconfig

I verified that this does not break building on a linux-host on this config:
host:  FC5, gcc 4.1.1-1
cross: arm-none-linux-gnueabi-gcc 4.1.1
cmd:   make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi-


Let me know if I can help any further.
Tom


k_smf.patch:
------------
diff -Naur -r o21.1/scripts/mod/file2alias.c
2.6.21.1/scripts/mod/file2alias.c
--- o21.1/scripts/mod/file2alias.c	2007-04-27 14:49:26.000000000
-0700
+++ 2.6.21.1/scripts/mod/file2alias.c	2007-05-29 20:35:01.209115300
-0700
@@ -29,7 +29,11 @@

  #include <ctype.h>

+#ifdef __CYGWIN__
+typedef __uint32_t      __u32;
+#else
  typedef uint32_t	__u32;
+#endif
  typedef uint16_t	__u16;
  typedef unsigned char	__u8;

diff -Naur -r o21.1/scripts/mod/modpost.h 2.6.21.1/scripts/mod/modpost.h
--- o21.1/scripts/mod/modpost.h	2007-04-27 14:49:26.000000000 -0700
+++ 2.6.21.1/scripts/mod/modpost.h	2007-05-29 20:35:01.599732800
-0700
@@ -9,6 +9,11 @@
  #include <unistd.h>
  #include <elf.h>

+#ifdef __CYGWIN__
+typedef uint16_t Elf32_Section;
+typedef uint16_t Elf64_Section;
+#endif
+
  #include "elfconfig.h"

  #if KERNEL_ELFCLASS == ELFCLASS32

diff -Naur -r o21.1/scripts/mod/sumversion.c
2.6.21.1/scripts/mod/sumversion.c
--- o21.1/scripts/mod/sumversion.c	2007-04-27 14:49:26.000000000
-0700
+++ 2.6.21.1/scripts/mod/sumversion.c	2007-05-29 20:35:01.677856300
-0700
@@ -7,6 +7,7 @@
  #include <ctype.h>
  #include <errno.h>
  #include <string.h>
+#include <limits.h>
  #include "modpost.h"

  /*

linux host error (old gcc!):
----------------------------

   CC      mm/bootmem.o
   CC      mm/filemap.o
   CC      mm/mempool.o
   CC      mm/oom_kill.o
   CC      mm/fadvise.o
   CC      mm/page_alloc.o
mm/page_alloc.c:684: warning: `setup_nr_node_ids' defined but not used
/tmp/ccj7iwRd.s: Assembler messages:
/tmp/ccj7iwRd.s:3089: Error: .err encountered
make[1]: *** [mm/page_alloc.o] Error 1
make: *** [mm] Error 2



arm-linux-gcc (GCC) 3.3.2 20030820 (prerelease)
Copyright (C) 2003 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is
NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.



