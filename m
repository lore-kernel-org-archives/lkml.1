Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbYECV6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbYECV6D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbYECV5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:57:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:63862 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbYECV5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:57:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: microblaze syscall list
Date: Sat, 3 May 2008 23:57:39 +0200
User-Agent: KMail/1.9.9
Cc: microblaze-uclinux@itee.uq.edu.au, Matthew Wilcox <matthew@wil.cx>,
       Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       John Williams <john.williams@petalogix.com>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <4813DF3E.6080800@itee.uq.edu.au> <4814A153.3040600@seznam.cz>
In-Reply-To: <4814A153.3040600@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805032357.41043.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/nQeB1UMORs244tgp8BfLO7dXqK4I3r6Pv0tE
 l73RRgQDz8WwGY9ncZhA+V6WkT2kp6b8bjDl8KH0Z5c7j9NQAI
 AzUzAg+r2ZEXE5UBfKb8g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 April 2008, Michal Simek wrote:
> 
> Arnd commented current syscall table and send me long email about(Thanks again).
> On the base on this email I did converted table for future use - for porting old
> application to new version. Below is my table with syscalls and there is a short
> description. (or http://www.monstr.eu/wiki/doku.php?id=kernel:syscall)

Just an update based on the recent discussion:

> /* fs/exec.c */
> ok	.long sys_uselib /* #ifdef __ARCH_WANT_SYS_USELIB */

remove

> /* fs/fcntl.c */
> ok	.long sys_dup
> ok	.long sys_dup2
> 	.long sys_fcntl /* obsolete -> fcntl64 */
> ok	.long sys_fcntl64

actually, if you have 64 bit off_t, it would be more logical
to use just sys_fcntl and leave out sys_fcntl64.
 
> /* fs/open.c */
> 	.long sys_statfs /* obsolete -> statfs64 */
> ok	.long sys_statfs64
> 	.long sys_fstatfs /* obsolete -> fstatfs64 */
> ok	.long sys_fstatfs64
> 	.long sys_truncate /* obsolete -> truncate64 */
> 	.long sys_ftruncate /* obsolete -> ftruncate64 */
> ok	.long sys_truncate64 /* __ARCH_WANT_SYS_TRUNCATE */
> ok	.long sys_ftruncate64 /* __ARCH_WANT_SYS_TRUNCATE */

right, for all these, the *64 version is the right one.

> ok	.long sys_fallocate
> ok	.long sys_faccessat
> 	.long sys_access /* obsolete -> faccessat */
> ok	.long sys_chdir
> ok	.long sys_fchdir
> ok	.long sys_chroot
> ok	.long sys_fchmod
> ok	.long sys_fchmodat
> 	.long sys_chmod /* obsolete -> fchmodat */
> ok	.long sys_chown
> ok	.long sys_fchownat
> ok	.long sys_lchown
> ok	.long sys_fchown
> 	.long sys_open /* obsolete -> openat */
> ok	.long sys_openat
> ok	.long sys_creat
> ok	.long sys_close
> ok	.long sys_vhangup

also, creat -> openat

> /* fs/readdir.c */
> 	.long sys_getdents /* obsolete -> sys_getdents64 */
> ok	.long sys_getdents64

right
 
> /* fs/read_write.c */
> 	.long sys_lseek /* only lseek or llseek */
> ok	.long sys_llseek /* _ARCH_WANT_SYS_LLSEEK */

in this case, only lseek, not llseek

> ok	.long sys_read
> ok	.long sys_readv
> ok	.long sys_write
> ok	.long sys_writev
> ok	.long sys_pread64
> ok	.long sys_pwrite64
> 	.long sys_sendfile /* obsolete -> sys_sendfile64 */
> ok	.long sys_sendfile64

same here, sendfile instead of sendfile64

> /* fs/stat.c */
> 	.long sys_stat /*_ARCH_WANT_OLD_STAT */
> 	.long sys_lstat /* _ARCH_WANT_OLD_STAT */
> 	.long sys_fstat /* _ARCH_WANT_OLD_STAT */
> ok	.long sys_newstat
> ok	.long sys_newlstat
> 	.long sys_newfstatat /* _ARCH_WANT_SYS_NEWFSTATAT */
> ok	.long sys_newfstat
> ok	.long sys_readlinkat
> 	.long sys_readlink /* obsolete -> sys_readlinkat */
> ok	.long sys_stat64 /* _ARCH_WANT_STAT64 */
> ok	.long sys_lstat64 /* _ARCH_WANT_STAT64 */
> ok	.long sys_fstat64 /* _ARCH_WANT_STAT64 */
> ok	.long sys_fstatat64 /* _ARCH_WANT_STAT64 */

you should have sys_newfstatat, but not any sys_*stat64, and consequently
set neither _ARCH_WANT_SYS_NEWFSTATAT nor _ARCH_WANT_STAT64.

> /* fs/timerfd.c */
> ok	.long sys_timerfd_create
> ok	.long sys_timerfd_settime
> ok	.long sys_timerfd_gettime
> 
> /* fs/utimes.c */
> ok	.long sys_utime	/* _ARCH_WANT_SYS_TIME */
> ok	.long sys_utimensat
> ok	.long sys_futimesat
> 	.long sys_utimes /* obsolete -> sys_futimesat */

no sys_utime or sys_futimesat, only sys_utimensat
 
> /* kernel/acct.c */
> opt	.long sys_acct

put it in the syscall table, kernel/sys_ni.c takes care of the
handling in case it's disabled.
 
> /* kernel/compat.c */
> 	.long compat_sys_nanosleep
> 	.long compat_sys_getitimer
> 	.long compat_sys_setitimer
> 	.long compat_sys_times
> 	.long compat_sys_sigpending
> 	.long compat_sys_sigprocmask
> 	.long compat_sys_setrlimit
> 	.long compat_sys_old_getrlimit
> 	.long compat_sys_getrlimit
> 	.long compat_sys_getrusage
> 	.long compat_sys_waitid
> 	.long compat_sys_sched_setaffinity
> 	.long compat_sys_sched_getaffinity
> 	.long compat_sys_time	/* _ARCH_WANT_COMPAT_SYS_TIME */
> 	.long compat_sys_stime	/* _ARCH_WANT_COMPAT_SYS_TIME */
> ok	.long compat_sys_rt_sigsuspend /* _ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND */
> 	.long compat_sys_adjtimex
> 	.long compat_sys_move_pages
> 	.long compat_sys_migrate_pages

no, you don't want compat_sys_rt_sigsuspend either. it's only for 64 bit
systems runnign 32 bit user space, like all compat_sys_* calls.
 
> /* kernel/sched.c */
> ok	.long sys_nice /* __ARCH_WANT_SYS_NICE */
> ok	.long sys_sched_setparam
> ok	.long sys_sched_setscheduler
> ok	.long sys_sched_getscheduler
> ok	.long sys_sched_getparam
> ok	.long sys_sched_setaffinity
> ok	.long sys_sched_getaffinity
> ok	.long sys_sched_yield
> ok	.long sys_sched_get_priority_max
> ok	.long sys_sched_get_priority_min
> ok	.long sys_sched_rr_get_interval

no sys_nice, it can be implemented using sys_setpriority

> /* kernel/signal.c */
> ok	.long sys_restart_syscall
> ok	.long sys_kill
> ok	.long sys_tkill
> ok	.long sys_tgkill
> ok	.long sys_rt_sigsuspend /* _ARCH_WANT_SYS_RT_SIGSUSPEND */
> ok	.long sys_rt_sigaction /* _ARCH_WANT_SYS_RT_SIGACTION */
> ok	.long sys_rt_sigprocmask /* _ARCH_WANT_SYS_SIGPROCMASK */
> ok	.long sys_rt_sigpending	/* _ARCH_WANT_SYS_SIGPENDING */
> ok	.long sys_rt_sigtimedwait
> ok	.long sys_rt_sigqueueinfo
> 	.long sys_sigprocmask /* obsolete -> sys_rt_sigprocmask */
> 	.long sys_sigpending /* obsolete -> sys_rt_sigpending */
> ok	.long sys_signal	/* __ARCH_WANT_SYS_SIGNAL */
> ok	.long sys_pause		/* __ARCH_WANT_SYS_PAUSE */
> ok	.long sys_sgetmask /* __ARCH_WANT_SYS_SGETMASK */
> ok	.long sys_ssetmask /* __ARCH_WANT_SYS_SGETMASK */

signal -> rt_sigaction
sgetmask, ssetmask -> rt_sigprocmask
pause -> rt_sigtimedwait
 
 
> /* kernel/sys.c */
> ok	.long sys_setpriority
> ok	.long sys_getpriority
> ok	.long sys_reboot
> ok	.long sys_setregid
> ok	.long sys_setgid
> ok	.long sys_setreuid
> ok	.long sys_setuid
> ok	.long sys_setresuid
> ok	.long sys_getresuid
> ok	.long sys_setresgid
> ok	.long sys_getresgid
> ok	.long sys_setfsuid
> ok	.long sys_setfsgid
> ok	.long sys_times
> ok	.long sys_setpgid
> ok	.long sys_getpgid
> ok	.long sys_getpgrp /* __ARCH_WANT_SYS_GETPGRP */

getpgrp -> getpgid

> /* kernel/time.c */
> ok	.long sys_time /* __ARCH_WANT_SYS_TIME */
> ok	.long sys_stime /* __ARCH_WANT_SYS_TIME */

time -> gettimeofday
stime -> settimeofday

	.
> /* kernel/timer.c */
> ok	.long sys_alarm /* __ARCH_WANT_SYS_ALARM */
> ok	.long sys_getpid
> ok	.long sys_getppid
> ok	.long sys_getuid
> ok	.long sys_geteuid
> ok	.long sys_getgid
> ok	.long sys_getegid
> ok	.long sys_gettid
> ok	.long sys_sysinfo

alarm -> setitimer

> /* net/socket.c */
> 	.long sys_socket
> 	.long sys_socketpair
> 	.long sys_bind
> 	.long sys_listen
> 	.long sys_accept
> 	.long sys_connect
> 	.long sys_getsockname
> 	.long sys_getpeername
> 	.long sys_sendto
> 	.long sys_send
> 	.long sys_recvfrom
> 	.long sys_recv
> 	.long sys_setsockopt
> 	.long sys_getsockopt
> 	.long sys_shutdown
> 	.long sys_sendmsg
> 	.long sys_recvmsg
> 	.long sys_socketcall /* _ARCH_WANT_SYS_SOCKETCALL - deprecated */

You need all of these, except sys_socketcall, which should not be there.

> /* mm/fremap.c */
> 	.long sys_remap_file_pages

Just put it in there as well, you'll need it for the mmu version.

> /* mm/madvise.c */
> 	.long sys_madvise

same here.

> /* mm/mincore.c */
> 	.long sys_mincore

and here

> /* mm/mremap.c */
> 	.long sys_mremap
> 
> /* mm/msync.c */
> 	.long sys_msync

and here, both

> /* mm/nommu.c */
> ok	.long sys_brk
> ok	.long sys_munmap
> 	.long sys_mremap

mremap is a duplicate, you only need it once ;-)

> /*arch/microblaze/kernel/sys_microblaze.c*/
> 	.long sys_vfork		/* I don't need it if I have clone vfork_wrapper */
> ok	.long sys_clone		/* .long sys_clone_wrapper */
> ok	.long sys_execve	/* .long sys_execve_wrapper */
> ok	.long sys_pipe
> ok	.long sys_mmap2
> 	.long sys_mmap	/* obsolete -> sys_mmap2 */
> 	.long sys_ipc /* obsolete -> replace by subcall */

right. sys_pipe and sys_mmap2 should probably go to fs/pipe.c and mm/mmap.c, but
that does not need to be your worry right now, it's not part of the ABI.

	Arnd <><
