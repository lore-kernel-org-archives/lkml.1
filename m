Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbZC0QGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbZC0QGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 12:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbZC0QFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 12:05:48 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43652 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbZC0QFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 12:05:46 -0400
From: arnd@arndb.de
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 7/13] score - New architecure port to SunplusCT S+CORE processor
Date: Fri, 27 Mar 2009 17:05:29 +0100
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, monstr@monstr.eu,
       john.williams@petalogix.com
References: <OF67FB031C.57858745-ON48257586.000915EE-48257586.00097F4B@sunplusct.com>
In-Reply-To: <OF67FB031C.57858745-ON48257586.000915EE-48257586.00097F4B@sunplusct.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?iso-8859-1?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?iso-8859-1?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ?=
 =?iso-8859-1?q?=0A=098MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?iso-8859-1?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?iso-8859-1?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903271705.29903.arnd@arndb.de>
Organization: IBM Deutschland Research & Development GmbH, Vorsitzender des Aufsichtsrats: Johann Weihen, Geschaeftssfuehrung: Erich Baier, Sitz der Gesellschaft: Boeblingen, Registergericht: Amtsgericht Stuttgart, HRB 243294
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 March 2009, liqin.chen@sunplusct.com wrote:

> +#define __NR_Linux                     0
> +#define __NR_syscall                   (__NR_Linux +   0)
> +#define __NR_exit                      (__NR_Linux +   1)
> +#define __NR_fork                      (__NR_Linux +   2)
> +#define __NR_read                      (__NR_Linux +   3)
> +#define __NR_write                     (__NR_Linux +   4)
> +#define __NR_open                      (__NR_Linux +   5)
> +#define __NR_close                     (__NR_Linux +   6)
> +#define __NR_waitpid                   (__NR_Linux +   7)
> +#define __NR_creat                     (__NR_Linux +   8)
> +#define __NR_link                      (__NR_Linux +   9)
> +#define __NR_unlink                    (__NR_Linux +  10)
> +#define __NR_execve                    (__NR_Linux +  11)
> +#define __NR_chdir                     (__NR_Linux +  12)
> +#define __NR_time                      (__NR_Linux +  13)
> +#define __NR_mknod                     (__NR_Linux +  14)
> +#define __NR_chmod                     (__NR_Linux +  15)
> +#define __NR_lchown                    (__NR_Linux +  16)
> +#define __NR_break                     (__NR_Linux +  17)
> +#define __NR_unused18                  (__NR_Linux +  18)

Do you need to keep backwards compatiblity with existing user
space code? The microblaze developers decided to do a clean
cut for merging their code into Linux, which I think is a good
idea in order to limit the system calls that you need to provide
for backwards compatibility, and to remove all the "unused" ones.

Note that you could also remove some of the traditional ones
like 'open' 'mknod' or 'link' because they implement a subset
of the newer 'openat', 'mknodat' and 'linkat' calls. There
are many other examples. The recommended way for these is to
have your libc wrap the system calls.

I actually hope that we can come up with a minimal list of syscalls
that we can put into asm-generic/unistd.h and share with microblaze
and all future architectures. Unfortunately, the same is not
possible with the existing architectures because of binary
compatibility with existing user binaries.

> +#define __NR_sigsuspend                        (__NR_Linux +  72)
> +#define __NR_sigpending                        (__NR_Linux +  73)

All the 'sig*' syscalls can be left out, in favour of the 'rt_sig*'
variants.

> +#define __NR_profil                    (__NR_Linux +  98)

What is this one?

> +#define __NR_statfs                    (__NR_Linux +  99)
> +#define __NR_fstatfs                   (__NR_Linux + 100)
> +#define __NR_ioperm                    (__NR_Linux + 101)
> +#define __NR_socketcall                        (__NR_Linux + 102)

You should not have socketcall and ipc, but rather use
their subcalls directly. See e.g. how blackfin does it.

> +#define __NR_iopl                      (__NR_Linux + 110)
> +#define __NR_vhangup                   (__NR_Linux + 111)
> +#define __NR_idle                      (__NR_Linux + 112)
> +#define __NR_vm86                      (__NR_Linux + 113)

iopl and vm86 are x86 specific, you should not have them.
sys_idle has been removed a long time ago.

> +#define __NR_create_module             (__NR_Linux + 127)
> +#define __NR_init_module               (__NR_Linux + 128)
> +#define __NR_delete_module             (__NR_Linux + 129)

create_module is long gone as well.

> +#define __NR_get_kernel_syms           (__NR_Linux + 130)
> +#define __NR_quotactl                  (__NR_Linux + 131)
> +#define __NR_getpgid                   (__NR_Linux + 132)
> +#define __NR_fchdir                    (__NR_Linux + 133)
> +#define __NR_bdflush                   (__NR_Linux + 134)
> +#define __NR_sysfs                     (__NR_Linux + 135)

bdflush is not a nop, sysfs (the syscall, not the file system)
is deprecated.

> +#define __NR_cacheflush                        (__NR_Linux + 147)
> +#define __NR_cachectl                  (__NR_Linux + 148)
> +#define __NR_sysscore                  (__NR_Linux + 149)

Are these your own? Do you really need them?

> +#define _syscall0(type,name)                           \
> +type name(void)                                                \
> +{                                                      \
> +       register unsigned long __v0;                    \
> +       register unsigned long __a3;                    \
> +                                                       \
> +       __asm__ volatile (                              \
> +       "ldi\tr27, %2\n\t"                              \
> +       "syscall\n\t"                                   \
> +       "mv\t%0, r4\n\t"                                \
> +       "mv\t%1, r7\n\t"                                \
> +       : "=&r" (__v0), "=r" (__a3)                     \
> +       : "i" (__NR_##name)                             \
> +       : "r4","r7", "r8", "r9", "r10", "r11", "r22", "r23", "r24", "r25", 
> "r26", "r27");  \
> +                                                       \
> +       if (__a3 == 0)                                  \
> +               return (type) __v0;                     \
> +       errno = __v0; \
> +       return -1; \
> +}

These macros were traditionally part of the kernel headers, but are
no more, you should remove them here.

> +#define __ARCH_WANT_SYS_FADVISE64
> +#define __ARCH_OMIT_COMPAT_SYS_GETDENTS64
> +#define __ARCH_WANT_IPC_PARSE_VERSION
> +#define __ARCH_WANT_OLD_READDIR
> +#define __ARCH_WANT_SYS_ALARM
> +#define __ARCH_WANT_SYS_GETHOSTNAME
> +#define __ARCH_WANT_SYS_PAUSE
> +#define __ARCH_WANT_SYS_SGETMASK
> +#define __ARCH_WANT_SYS_UTIME
> +#define __ARCH_WANT_SYS_WAITPID
> +#define __ARCH_WANT_SYS_SOCKETCALL
> +#define __ARCH_WANT_SYS_GETPGRP
> +#define __ARCH_WANT_SYS_LLSEEK
> +#define __ARCH_WANT_SYS_NICE
> +#define __ARCH_WANT_SYS_OLD_GETRLIMIT
> +#define __ARCH_WANT_SYS_OLDUMOUNT
> +#define __ARCH_WANT_SYS_SIGPENDING
> +#define __ARCH_WANT_SYS_SIGPROCMASK
> +#define __ARCH_WANT_SYS_RT_SIGACTION
> +#define __ARCH_WANT_STAT64
> +#define __ARCH_WANT_SYS_TIME

This list should be empty. A new architecture should
not need any of them, because they have all been
superceded. I'm trying to clean this list up to make
sure it is up-to-date and you also don't get other
syscalls that you don't need any more.

> +/* whitelists for checksyscalls */
> +#define __IGNORE_select
> +#define __IGNORE_vfork
> +#define __IGNORE_time
> +#define __IGNORE_uselib

It's good that you don't implement these syscalls, because they
have been superceded, but the right solution would be to change
checksyscalls to no longer require them.

> +#define __IGNORE_fadvise64_64
> +#define __IGNORE_getdents64

I believe you actually need these two syscalls.

> +menu "Machine selection"
> +
> +choice
> +       prompt "System type"
> +       default MACH_SPCT6600
> +
> +config MACH_SPCT6600
> +       bool "SPCT6600 series based machines"
> +       select SYS_SUPPORTS_32BIT_KERNEL
> +       select SYS_SUPPORTS_LITTLE_ENDIAN
> +       select CPU_SCORE7
> +       select GENERIC_HAS_IOMAP
> +
> +config MACH_SPG300
> +       bool "SPG300 series based machines"
> +       select SYS_SUPPORTS_32BIT_KERNEL
> +       select SYS_SUPPORTS_LITTLE_ENDIAN
> +       select CPU_SCORE7
> +       select GENERIC_HAS_IOMAP
> +
> +config SCORE_SIM
> +       bool "Score simulator"
> +       select SYS_SUPPORTS_32BIT_KERNEL
> +       select SYS_SUPPORTS_LITTLE_ENDIAN
> +       select CPU_SCORE7
> +       select GENERIC_HAS_IOMAP
> +endchoice

On powerpc and x86, we found it very helpful to be able to build a
kernel that actually runs on all the machines, rather than a subset.

You may want to think about changing your code to enable that as
well, though that is not something you should do before merging
your tree.

> +config HZ
> +       int
> +       default 48 if HZ_48
> +       default 100 if HZ_100
> +       default 128 if HZ_128
> +       default 250 if HZ_250
> +       default 256 if HZ_256

This is an unusual selection of clock tick frequencies. Are you
limited by the hardware implementation here?
If not, you should consider implementing tickless operation, which
is often more efficient.

	Arnd <><
