Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbZKEQjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbZKEQjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 11:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757155AbZKEQjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 11:39:03 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:51597 "EHLO
	QMTA04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808AbZKEQjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 11:39:02 -0500
Message-Id: <200911051638.nA5GcH18028889@deneb.dwf.com>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Cant build 2.6.31.5
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 05 Nov 2009 09:38:17 -0700
From: Reg Clemens <reg@dwf.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are more details on a problem I am having building 2.6.31.5
on a Pentium 4.

My .config file is exactly the same as it is on another Pentium 4 where
I can build with no problem, The difference is that that is Fedora11, and
the problem occurs on Fedora6.

I did a 
	make mrproper
	make -j3 bzImage ; make -j3 modules

I then did a
	make modules_install
	make install

and the install failed with the messages

[root@deneb linux-2.6.31.5-PPSv]# make install
sh /mnt/home/share/usr-src/kernels/linux-2.6.31.5-PPSv/arch/x86/boot/install.sh
 2.6.31.5-PPSv arch/x86/boot/bzImage \
                System.map "/boot"

 *** Missing file: arch/x86/boot/bzImage
 *** You need to run "make" before "make install".

make[1]: *** [install] Error 1
make: *** [install] Error 2

I reran the
	make bzImage
and got the messages

[root@deneb linux-2.6.31.5-PPSv]# make bzImage
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  GEN     .version
  CHK     include/linux/compile.hnm semaphore.o | grep __up

  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
kernel/built-in.o:(__mcount_loc+0x838): undefined reference to 
`sleep_on_common'
kernel/built-in.o:(__mcount_loc+0x83c): undefined reference to 
`sleep_on_common'
kernel/built-in.o:(__mcount_loc+0x840): undefined reference to 
`sleep_on_common'
kernel/built-in.o:(__mcount_loc+0x844): undefined reference to 
`sleep_on_common'
kernel/built-in.o:(__mcount_loc+0x848): undefined reference to 
`sleep_on_common'
kernel/built-in.o:(__mcount_loc+0x84c): more undefined references to 
`sleep_on_common' follow
kernel/built-in.o:(__mcount_loc+0x17a8): undefined reference to `__up'
kernel/built-in.o:(__mcount_loc+0x17ac): undefined reference to `__up'
kernel/built-in.o:(__mcount_loc+0x17b0): undefined reference to `__up'
kernel/built-in.o:(__mcount_loc+0x17b4): undefined reference to `__up'
kernel/built-in.o:(__mcount_loc+0x17b8): undefined reference to `__up'
kernel/built-in.o:(__mcount_loc+0x17bc): more undefined references to `__up' 
follow
make: *** [.tmp_vmlinux1] Error 1

scanning on 
	sleep_on_common
I find it in 
	sched.c
doing a
	nm sched.o | grep sleep_on_common
I see

[reg@deneb kernel]$ nm sched.o | grep sleep_on_common
00000000 ? sleep_on_common
         U sleep_on_common

For __up, it is used in semaphore.c

doing
	nm semaphore.o | grep __up
I see
	00000000 ? __up
         U __up


I will assume that the problem is the '?' that nm is returning.
What can I do about that?
Any way to build this kernel on this OS?
I have tried copying this kernel built on another machine to this
machine, and had other problems (it just stopped during the load).

-- 
                                        Reg.Clemens
                                        reg@dwf.com


