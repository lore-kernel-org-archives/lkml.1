Return-Path: <linux-kernel-owner+w=401wt.eu-S934508AbYAaXNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934508AbYAaXNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 18:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbYAaXNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 18:13:41 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:32410 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbYAaXNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 18:13:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=rm4GT1mxDC/bKGZSdIbhowjKghqazqkDVZJkFrsBcSK8Q1XQPH2V7+q/afSKPJid5TmUK2lwgnHVx0EnxWUdHPWywBdwkfWGtNVGgacVESa/Z6KnEeWoipyqw0ncfD1GTpXw1HgKt0GCIH/7dIVvVVP+iGZLFsDBIIYqO1P9Q+Q=
Message-ID: <ec36785a0801311513g4172b915w7bdb7ca97035efde@mail.gmail.com>
Date: Thu, 31 Jan 2008 23:13:36 +0000
From: "Reinaldo Carvalho" <reinaldow@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: missing asm-x86_64 detection
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

:/# uname -a
Linux devil 2.6.22.16-amd64 #15 SMP Sat Jan 19 13:58:02 BRT 2008
x86_64 GNU/Linux

:/# cd /usr/src/linux-2.6.22
:/# patch -p1 -R < ../patch-2.6.22.16
:/# patch -p1 < ../patch-2.6.23
:/# patch -p1 < ../patch-2.6.24
:/# cd /usr/src/ ; mv linux-2.6.22 linux-2.6.24; cd linux-2.6.24
:/usr/src/linux-2.6.24# make oldconfig
:/usr/src/linux-2.6.24# make all
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
ERROR: the symlink include/asm points to asm-x86_64 but asm-x86 was expected
       set ARCH or save .config and run 'make mrproper' to fix it
make: ** [include/asm] Erro 1

:/usr/src/linux-2.6.24# cp .config ../config-2.6.24
:/usr/src/linux-2.6.24# make mrproper
  CLEAN   scripts/basic
  CLEAN   scripts/genksyms
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config
  CLEAN   .config .config.old include/asm .version
include/linux/autoconf.h include/linux/version.h
include/linux/utsrelease.h Module.symvers
devil:/usr/src/linux-2.6.24# cp ../config-2.6.24 .config
devil:/usr/src/linux-2.6.24# make oldconfig
devil:/usr/src/linux-2.6.24# make all
scripts/kconfig/conf -s arch/x86/Kconfig
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/asm-x86/asm-offsets.h
...

system is x86_64!

:/# grep model\ name /proc/cpuinfo
model name      : AMD Turion(tm) 64 X2
model name      : AMD Turion(tm) 64 X2

:/# uname -a
Linux devil 2.6.22.16-amd64 #15 SMP Sat Jan 19 13:58:02 BRT 2008
x86_64 GNU/Linux


-- 
Reinaldo Carvalho
