Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbZIPMP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbZIPMP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757311AbZIPMP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:15:27 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:55450 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbZIPMP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=hRjV2/TjKqS/k4WMcKQPbB4MBqLbkiGwtdP/QqmBv/kjqHcOeMXvaQ6hAt5vXHjYKh
         YhmJNpVSoGg6jsAM9CFpNk2wSbH1uvxG79bGZ1Z3nwiOcRLpn7HPxvmi5ZfAycOxKSbE
         yhCXDBR6zlmLdpL1j4CTOOe2AhSXCq1r9NWPg=
Message-ID: <4AB22891.4080906@gmail.com>
Date: Thu, 17 Sep 2009 15:16:17 +0300
From: Aioanei Rares <krnl.list@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: BUG : drivers/staging/comedi/drivers/cb_pcidio.o linking error
References: <20090916102953.GA18674@wavehammer.waldi.eu.org>
In-Reply-To: <20090916102953.GA18674@wavehammer.waldi.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to compile the latest git kernel pulled today (16.09) greeted me 
with this error :

  BUILD   arch/x86/boot/bzImage
Root device is (8, 2)
Setup is 13996 bytes (padded to 14336 bytes).
System is 2381 kB
CRC bfd3396b
Kernel: arch/x86/boot/bzImage is ready  (#7)
  Building modules, stage 2.
  MODPOST 1250 modules
WARNING: drivers/staging/comedi/drivers/cb_pcidio.o(.text+0xe5): Section 
mismatch in reference from the function pcidio_attach() to the variable 
.devinit.rodata:pcidio_pci_table
The function pcidio_attach() references
the variable __devinitconst pcidio_pci_table.
This is often because pcidio_attach lacks a __devinitconst
annotation or the annotation of pcidio_pci_table is wrong.

ERROR: "per_cpu__cpu_llc_id" [drivers/edac/edac_core.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

I was compiling with make CONFIG_DEBUG_SECTION_MISMATCH=y all
on a Debian testing/unstable system with gcc arares@debian:~/linux-2.6$ 
gcc -v
Using built-in specs.
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Debian 4.3.4-2' 
--with-bugurl=file:///usr/share/doc/gcc-4.3/README.Bugs 
--enable-languages=c,c++,fortran,objc,obj-c++ --prefix=/usr 
--enable-shared --enable-multiarch --enable-linker-build-id 
--with-system-zlib --libexecdir=/usr/lib --without-included-gettext 
--enable-threads=posix --enable-nls 
--with-gxx-include-dir=/usr/include/c++/4.3 --program-suffix=-4.3 
--enable-clocale=gnu --enable-libstdcxx-debug --enable-objc-gc 
--enable-mpfr --with-tune=generic --enable-checking=release 
--build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu
Thread model: posix
gcc version 4.3.4 (Debian 4.3.4-2)

and make arares@debian:~/linux-2.6$ make -v
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for x86_64-pc-linux-gnu

binutils :

arares@debian:~/linux-2.6$ as -v
GNU assembler version 2.19.91 (x86_64-linux-gnu) using BFD version (GNU 
Binutils for Debian) 2.19.91.20090910

arares@debian:~/linux-2.6$ ld -v
GNU ld (GNU Binutils for Debian) 2.19.91.20090910

...and a fully updated system.
