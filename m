Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198Ab0AJXPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab0AJXPV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 18:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171Ab0AJXPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 18:15:20 -0500
Received: from borg.medozas.de ([188.40.89.202]:55838 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab0AJXPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 18:15:19 -0500
Date: Mon, 11 Jan 2010 00:15:17 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: fstat seems broken on sparc64
In-Reply-To: <20100110.131158.242584083.davem@davemloft.net>
Message-ID: <alpine.LSU.2.01.1001102347280.23052@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.0912141511280.27692@obet.zrqbmnf.qr> <20091214.233840.236673621.davem@davemloft.net> <alpine.LSU.2.01.1001082355250.20848@obet.zrqbmnf.qr> <20100110.131158.242584083.davem@davemloft.net>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 2010-01-10 22:11, David Miller wrote:
>
>> libc6   2.10.2-4
>
>Perfect, now you just have to audit what changed between the -2 and
>the -4 package to find the bug :-)

I really do not believe you when you say your glibc is not affected.
Maybe some things did not became clear as part of the discussion,
so let me quickly restate:

 - talking about -m64 / libc6-sparc64_2.10.2-*_sparc.deb only

 - syscall is screwed up. strace outputs:

C func  | i386      | x86_64     | sparc32   | sparc64
--------+-----------+------------+-----------+---------------
stat    | stat64    | stat       | stat64    | stat64
lstat   | lstat64   | lstat      | lstat64   | lstat64
fstatat | fstatat64 | newfstatat | fstatat64 | fstatat64
fstat   | fstat64   | fstat      | fstat64   | fstat (*)


 - I now found and fixed the problem, here is the patch for
   you to study (as code speaks louder)

Index: glibc-2.10.1/sysdeps/unix/sysv/linux/sparc/sparc64/fxstat.c
===================================================================
--- glibc-2.10.1.orig/sysdeps/unix/sysv/linux/sparc/sparc64/fxstat.c
+++ glibc-2.10.1/sysdeps/unix/sysv/linux/sparc/sparc64/fxstat.c
@@ -1 +1 @@
-#include "../../fxstat.c"
+#include "../../i386/fxstat.c"

(Hint: Compare with sparc64/lxstat.c)
