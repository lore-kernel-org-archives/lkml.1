Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbZLTPPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbZLTPPK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 10:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbZLTPPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 10:15:09 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55238 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbZLTPPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 10:15:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:content-type;
        b=H1+OdH1OTnjeOkxh2Jh37iJ+13E76rHAni9Pq4G+201YKZnqGyNxjGImhXtfSO2LHi
         ib1/NRbtpqAEB0LLx9PpH0Pg/9PopVhq9dE7o86sb3aCvoN4lAERXALlgOcR9CzZEmiO
         cwuS3EOYChDE44rarCZsfy+kk37UREaf/tFFo=
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <c68f135e0912200710g7cbb4a3en677270da42d78357@mail.gmail.com>
References: <c68f135e0912200710g7cbb4a3en677270da42d78357@mail.gmail.com>
From: Andrea Merello <andrea.merello@gmail.com>
Date: Sun, 20 Dec 2009 16:14:46 +0100
Message-ID: <c68f135e0912200714o731d5623me8aac46952e294fd@mail.gmail.com>
Subject: Fwd: Linker error on 2.6.32.2 with radeon DRM
To: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just tried to compile last stable kernel with radeon DRM gpu driver
and I got this:

...
 LD      vmlinux.o
 MODPOST vmlinux.o
 GEN     .version
 CHK     include/linux/compile.h
 UPD     include/linux/compile.h
 CC      init/version.o
 LD      init/built-in.o
 LD      .tmp_vmlinux1
drivers/built-in.o(.text+0xf633a): In function `radeon_test_moves':
: undefined reference to `__udivdi3'
make: *** [.tmp_vmlinux1] Error 1
user@daiquiri:~/linux-2.6.32.2>


user@daiquiri:~/linux-2.6.32.2> gcc -v
Reading specs from /usr/lib/gcc-lib/i586-suse-linux/3.3.5/specs
Configured with: ../configure --enable-threads=posix --prefix=/usr
--with-local-prefix=/usr/local --infodir=/usr/share/info
--mandir=/usr/share/man --enable-languages=c,c++,f77,objc,java,ada
--disable-checking --libdir=/usr/lib --enable-libgcj
--with-slibdir=/lib --with-system-zlib --enable-shared
--enable-__cxa_atexit i586-suse-linux
Thread model: posix
gcc version 3.3.5 20050117 (prerelease) (SUSE Linux)

user@daiquiri:~> make --version
GNU Make 3.80
Copyright (C) 2002  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

user@daiquiri:~> ld -v
GNU ld version 2.15.94.0.2.2 20041220 (SuSE Linux)
user@daiquiri:~>


I read in kernel Changes file that versions should be ok..

It is on an old a 32 bit AMD athlon XP processor.

user@daiquiri:~/linux-2.6.32.2> cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 8
model name      : AMD Athlon(tm) XP 2200+
stepping        : 1
cpu MHz         : 1795.500
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow ts
bogomips        : 3624.67
clflush size    : 32


I tracked this issue to be related to the said function
(radeon_test_moves) in the code line where the number of test is
calculated (line 45).

I did a workaround by performing a cast to unsigned of the first
division operand, but I have really no idea about what that code is
doing...

Thanks
Andrea
