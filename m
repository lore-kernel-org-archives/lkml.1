Return-Path: <linux-kernel-owner+w=401wt.eu-S1764509AbXJQLdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764509AbXJQLdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 07:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759577AbXJQLdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 07:33:14 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:26505 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759448AbXJQLdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 07:33:13 -0400
Message-ID: <4715F2E5.6000104@panasas.com>
Date: Wed, 17 Oct 2007 13:32:53 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: slight annoyance with new x86 arch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Oct 2007 11:32:54.0712 (UTC) FILETIME=[75875B80:01C810B1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make system is a bit broken in the sense that it recompiles and links right after
a build even if nothing changed.

I have 
# CONFIG_LOCALVERSION_AUTO is not set

make output after a fully built tree:
{ // these are expected off course 
GEN /usr0/export/dev/bharrosh/git/pub/linux-2.6-block/.build_i386/Makefile
CHK include/linux/version.h
CHK include/linux/utsrelease.h
Using /usr0/export/dev/bharrosh/git/pub/linux-2.6-block as source for kernel
CALL /usr0/export/dev/bharrosh/git/pub/linux-2.6-block/scripts/checksyscalls.sh
CHK include/linux/compile.h
}
{ // these cause a recompilation and relink
AS arch/x86/kernel/vsyscall-int80_32.o
AS arch/x86/kernel/vsyscall-sysenter_32.o
SYSCALL arch/x86/kernel/vsyscall-syms.o
SYSCALL arch/x86/kernel/vsyscall-int80_32.so
SYSCALL arch/x86/kernel/vsyscall-sysenter_32.so
AS arch/x86/kernel/vsyscall_32.o
}

LD arch/x86/kernel/built-in.o
GEN .version
...
CC init/version.o
LD init/built-in.o
LD .tmp_vmlinux1
KSYM .tmp_kallsyms1.S
AS .tmp_kallsyms1.o
LD .tmp_vmlinux2
KSYM .tmp_kallsyms2.S
AS .tmp_kallsyms2.o
LD .tmp_vmlinux3
KSYM .tmp_kallsyms3.S
AS .tmp_kallsyms3.o
LD vmlinux.o
MODPOST vmlinux.o
....


I'm cross compiling on an x86_64 fedora7 machine. with
make ARCH=i386 KBUILD_OUTPUT=.build_i386 allmodconfig
and
make ARCH=i386 KBUILD_OUTPUT=.build_i386

Other wise after an mrproper all is well and booting
and the dir structure looks much better

Thanks
Boaz
