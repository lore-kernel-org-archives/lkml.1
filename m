Return-Path: <linux-kernel-owner+w=401wt.eu-S1762908AbZDHHVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762908AbZDHHVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762901AbZDHHV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:21:27 -0400
Received: from 219-87-157-179.static.tfn.net.tw ([219.87.157.179]:54935 "EHLO
	mswedge1.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762449AbZDHHV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:21:26 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Kyle McMartin <kyle@mcmartin.ca>
MIME-Version: 1.0
Subject: [PATCH 0/14] score - New architecure port to SunplusCT S+CORE
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFC83335DE.A18F9B53-ON48257592.00273C99-48257592.002856A8@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Wed, 8 Apr 2009 15:18:30 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/04/08 ?? 03:18:44,
	Serialize complete at 2009/04/08 ?? 03:18:44
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi tglx, Arnd, Kyle, Sam and linus,

According to your comment last week, We had updated the linux/score code,
use arch blackfin code as reference.
 
because some reasons below, I have not fixed these problems you mentioned
 
1:      bdflush is not a nop, remove it?

2:      because module_arch_cleanup, makcine_halt, machine_power_off and 
some other funcs are global, 
        so i have not move them into .h and not declare them as static 
inline.

3: 
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
I still leave these syscalls there, bacause i think it clear to everybody
even linux have the new syscall replace them.

4:      asm/atomic.h and asm/bitops.h generic version have not finished,
        so I dont updated them.

5: 
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
Once the kernel code update, I will remove these code.

6:      sys_sigaltstack should rename to sys_rt_sigaltstack?

7:      use score-linux compile linux/score kernel still have some 
warning, 
        but we think it not the problems in score head files.
 
8:      score have big and little endian support, now we only use 
        little endian running linux.


        score-linux toolchain could be download from
 
http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch
 
        linux/score lastest patch place at 
 
http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch

-- 
Best regards
Liqin
liqin.chen@sunplusct.com
