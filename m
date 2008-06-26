Return-Path: <linux-kernel-owner+w=401wt.eu-S1761036AbYFZSNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761036AbYFZSNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbYFZSN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:13:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:63076 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbYFZSNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:13:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 59/60] microblaze_v4: syscall_table.S and unistd.h
Date: Thu, 26 Jun 2008 18:31:18 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <1214483429-32360-59-git-send-email-monstr@seznam.cz> <1214483429-32360-60-git-send-email-monstr@seznam.cz>
In-Reply-To: <1214483429-32360-60-git-send-email-monstr@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806261831.19187.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19FqFJNLIoK0U1Y8fPTNYUKapKDRx0I1sbJxwo
 qCZR8ZMEFQG1qXmGh6K/7qoKsuemElaGAH/bY7dHUy8H02TU2w
 ftjx0Zh2rT+Sc64bFvMPQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008, monstr@seznam.cz wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  arch/microblaze/kernel/syscall_table.S |  330 +++++++++++++++++++++++++++
>  include/asm-microblaze/unistd.h        |  390 ++++++++++++++++++++++++++++++++
>  2 files changed, 720 insertions(+), 0 deletions(-)
>  create mode 100644 arch/microblaze/kernel/syscall_table.S
>  create mode 100644 include/asm-microblaze/unistd.h

The two tables don't seem to match:

> diff --git a/arch/microblaze/kernel/syscall_table.S b/arch/microblaze/kernel/syscall_table.S
> new file mode 100644
> index 0000000..0ffa19e
> --- /dev/null
> +++ b/arch/microblaze/kernel/syscall_table.S
> @@ -0,0 +1,330 @@
> +ENTRY(sys_call_table)
> +	.long sys_restart_syscall	/* 0 - old "setup()" system call,
> +					 * used for restarting */
> +	.long sys_exit
> +	.long sys_ni_syscall		/* was fork */

You still set __NR_fork. There is no point defining the number if you
can't actually call the syscall in the first place.

I'd suggest leaving out the definitions for these from unistd.h and
removing the comments. Who cares what the syscall was on an architecture
that you're not running?

> +	.long sys_read
> +	.long sys_write
> +	.long sys_open			/* 5 */
> +	.long sys_close
> +	.long sys_waitpid
> +	.long sys_creat
> +	.long sys_link
> +	.long sys_unlink		/* 10 */
> +	.long sys_execve_wrapper
> +	.long sys_chdir
> +	.long sys_time
> +	.long sys_mknod
> +	.long sys_chmod			/* 15 */
> +	.long sys_lchown
> +	.long sys_ni_syscall		/* old break syscall holder */
> +	.long sys_ni_syscall		/* stat */

also __NR_break and __NR_oldstat

> +	.long sys_lseek
> +	.long sys_getpid		/* 20 */
> +	.long sys_mount
> +	.long sys_oldumount

What applications depend on oldumount?

> +	.long sys_setuid
> +	.long sys_getuid
> +	.long sys_stime			/* 25 */
> +	.long sys_ptrace
> +	.long sys_alarm
> +	.long sys_ni_syscall		/* fstat */
> +	.long sys_pause
> +	.long sys_utime			/* 30 */
> +	.long sys_ni_syscall		/* old stty syscall holder */
> +	.long sys_ni_syscall		/* old gtty syscall holder */

and __NR_stty and __NR_gtty

> +	.long sys_access
> +	.long sys_nice
> +	.long sys_ni_syscall		/* 35 - old ftime syscall holder */

and __NR_ftime

> +	.long sys_sync
> +	.long sys_kill
> +	.long sys_rename
> +	.long sys_mkdir
> +	.long sys_rmdir			/* 40 */
> +	.long sys_dup
> +	.long sys_pipe
> +	.long sys_times
> +	.long sys_ni_syscall		/* old prof syscall holder */

and __NR_prof

> +	.long sys_brk			/* 45 */
> +	.long sys_setgid
> +	.long sys_getgid
> +	.long sys_signal
> +	.long sys_geteuid
> +	.long sys_getegid		/* 50 */
> +	.long sys_acct
> +	.long sys_umount		/* recycled never used phys() */
> +	.long sys_ni_syscall		/* old lock syscall holder */

and __NR_lock

> +	.long sys_ioctl
> +	.long sys_fcntl			/* 55 */
> +	.long sys_ni_syscall		/* old mpx syscall holder */
> +	.long sys_setpgid
> +	.long sys_ni_syscall		/* old ulimit syscall holder */
> +	.long sys_ni_syscall		/* olduname */

and __NR_mpx, __NR_ulimit and __NR_olduname

> +	.long sys_umask			/* 60 */
> +	.long sys_chroot
> +	.long sys_ustat
> +	.long sys_dup2
> +	.long sys_getppid
> +	.long sys_getpgrp		/* 65 */
> +	.long sys_setsid
> +	.long sys_sigaction
> +	.long sys_sgetmask
> +	.long sys_ssetmask
> +	.long sys_setreuid		/* 70 */
> +	.long sys_setregid
> +	.long sys_sigsuspend_wrapper
> +	.long sys_sigpending
> +	.long sys_sethostname
> +	.long sys_setrlimit		/* 75 */
> +	.long sys_ni_syscall		/* old_getrlimit */
> +	.long sys_getrusage
> +	.long sys_gettimeofday
> +	.long sys_settimeofday
> +	.long sys_getgroups		/* 80 */
> +	.long sys_setgroups
> +	.long sys_ni_syscall		/* old_select */
> +	.long sys_symlink
> +	.long sys_ni_syscall		/* lstat */

Three more: getrlimit, select, oldlstat

> +	.long sys_readlink		/* 85 */
> +	.long sys_uselib

Why do you need uselib?

> +	.long sys_swapon
> +	.long sys_reboot
> +	.long sys_ni_syscall		/* old_readdir */

again: remove __NR_readdir

> +	.long sys_mmap			/* 90 */ /* old_mmap */

What does the comment tell us?

> +	.long sys_munmap
> +	.long sys_truncate
> +	.long sys_ftruncate
> +	.long sys_fchmod
> +	.long sys_fchown		/* 95 */
> +	.long sys_getpriority
> +	.long sys_setpriority
> +	.long sys_ni_syscall		/* old profil syscall holder */
> +	.long sys_statfs
> +	.long sys_fstatfs		/* 100 */
> +	.long sys_ni_syscall		/* ioperm */

kill __NR_profil and __NR_ioperm

> +	.long sys_socketcall
> +	.long sys_syslog		/* operation with system console */

That comment seems pointless here

> +	.long sys_setitimer
> +	.long sys_getitimer		/* 105 */
> +	.long sys_newstat
> +	.long sys_newlstat
> +	.long sys_newfstat
> +	.long sys_ni_syscall		/* uname */
> +	.long sys_ni_syscall		/* 110 */ /* iopl */
> +	.long sys_vhangup
> +	.long sys_ni_syscall		/* old "idle" system call */
> +	.long sys_ni_syscall		/* old sys_vm86old */

kill __NR_olduname, __NR_iopl, __NR_idle and __NR_vm86old

> +	.long sys_wait4
> +	.long sys_swapoff		/* 115 */
> +	.long sys_sysinfo
> +	.long sys_ipc
> +	.long sys_fsync
> +	.long sys_sigreturn_wrapper
> +	.long sys_clone_wrapper		/* 120 */
> +	.long sys_setdomainname
> +	.long sys_newuname
> +	.long sys_ni_syscall		/* modify_ldt */
> +	.long sys_adjtimex
> +	.long sys_ni_syscall		/* 125:	sys_mprotect */
> +	.long sys_sigprocmask
> +	.long sys_ni_syscall		/* old "create_module" */
> +	.long sys_init_module
> +	.long sys_delete_module
> +	.long sys_ni_syscall		/* 130:	old "get_kernel_syms" */

kill __NR_modify_ldt, __NR_mprotect, __NR_create_module and __NR_get_kernel_syms

> +	.long sys_quotactl
> +	.long sys_getpgid
> +	.long sys_fchdir
> +	.long sys_bdflush
> +	.long sys_sysfs			/* 135 */
> +	.long sys_personality
> +	.long sys_ni_syscall		/* reserved for afs_syscall */

afs_syscall is not going to make it into the kernel, so no need to
define __NR_afs_syscall.

> +	.long sys_setfsuid
> +	.long sys_setfsgid
> +	.long sys_llseek		/* 140 */
> +	.long sys_getdents
> +	.long sys_select
> +	.long sys_flock
> +	.long sys_ni_syscall		/* sys_msync */
> +	.long sys_readv			/* 145 */
> +	.long sys_writev
> +	.long sys_getsid
> +	.long sys_fdatasync
> +	.long sys_sysctl
> +	.long sys_ni_syscall		/* 150:	sys_mlock */
> +	.long sys_ni_syscall		/* sys_munlock */
> +	.long sys_ni_syscall		/* sys_mlockall */
> +	.long sys_ni_syscall		/* sys_munlockall */

How about killing all of these mmu specific syscall numbers
right now, so you can add them as a nice block later when
you add mmu support to the kernel?

> +	.long sys_sched_setparam
> +	.long sys_sched_getparam	/* 155 */
> +	.long sys_sched_setscheduler
> +	.long sys_sched_getscheduler
> +	.long sys_sched_yield
> +	.long sys_sched_get_priority_max
> +	.long sys_sched_get_priority_min	/* 160 */
> +	.long sys_sched_rr_get_interval
> +	.long sys_nanosleep
> +	.long sys_ni_syscall		/* sys_mremap */

__NR_mremap fits in there as well.

> +	.long sys_setresuid
> +	.long sys_getresuid		/* 165 */
> +	.long sys_ni_syscall		/* sys_vm86 */
> +	.long sys_ni_syscall		/* Old sys_query_module */

__NR_vm86 and __NR_query_module can never be implemented, so kill them.

> +	.long sys_poll
> +	.long sys_nfsservctl
> +	.long sys_setresgid		/* 170 */
> +	.long sys_getresgid
> +	.long sys_prctl
> +	.long sys_rt_sigreturn_wrapper
> +	.long sys_rt_sigaction
> +	.long sys_rt_sigprocmask	/* 175 */
> +	.long sys_rt_sigpending
> +	.long sys_rt_sigtimedwait
> +	.long sys_rt_sigqueueinfo
> +	.long sys_rt_sigsuspend_wrapper
> +	.long sys_pread64		/* 180 */
> +	.long sys_pwrite64
> +	.long sys_chown
> +	.long sys_getcwd
> +	.long sys_capget
> +	.long sys_capset		/* 185 */
> +	.long sys_ni_syscall		/* sigaltstack */
> +	.long sys_sendfile
> +	.long sys_ni_syscall		/* reserved for streams1 */
> +	.long sys_ni_syscall		/* reserved for streams2 */

same for streams support.

For sigaltstack, you define both the syscall number and the function,
but not the sys_call_table entry, so it's not actually usable.

I suggest killing the implementation.

> +	.long sys_vfork_wrapper		/* 190 */
> +	.long sys_getrlimit
> +	.long sys_mmap2			/* mmap2 */
> +	.long sys_truncate64
> +	.long sys_ftruncate64
> +	.long sys_stat64		/* 195 */
> +	.long sys_lstat64
> +	.long sys_fstat64
> +	.long sys_lchown
> +	.long sys_getuid
> +	.long sys_getgid		/* 200 */
> +	.long sys_geteuid
> +	.long sys_getegid
> +	.long sys_setreuid
> +	.long sys_setregid
> +	.long sys_getgroups		/* 205 */
> +	.long sys_setgroups
> +	.long sys_fchown
> +	.long sys_setresuid
> +	.long sys_getresuid
> +	.long sys_setresgid		/* 210 */
> +	.long sys_getresgid
> +	.long sys_chown
> +	.long sys_setuid
> +	.long sys_setgid
> +	.long sys_setfsuid		/* 215 */
> +	.long sys_setfsgid
> +	.long sys_pivot_root
> +	.long sys_ni_syscall		/* sys_mincore */
> +	.long sys_ni_syscall		/* sys_madvise */

These go with the other mmu syscalls.

> +	.long sys_getdents64		/* 220 */
> +	.long sys_fcntl64
> +	.long sys_ni_syscall		/* reserved for TUX */
> +	.long sys_ni_syscall
> +	.long sys_gettid
> +	.long sys_readahead		/* 225 */
> +	.long sys_setxattr
> +	.long sys_lsetxattr
> +	.long sys_fsetxattr
> +	.long sys_getxattr
> +	.long sys_lgetxattr		/* 230 */
> +	.long sys_fgetxattr
> +	.long sys_listxattr
> +	.long sys_llistxattr
> +	.long sys_flistxattr
> +	.long sys_removexattr		/* 235 */
> +	.long sys_lremovexattr
> +	.long sys_fremovexattr
> +	.long sys_tkill
> +	.long sys_sendfile64
> +	.long sys_futex			/* 240 */
> +	.long sys_sched_setaffinity
> +	.long sys_sched_getaffinity
> +	.long sys_ni_syscall		/* set_thread_area */
> +	.long sys_ni_syscall		/* get_thread_area */

same for these two

> +	.long sys_io_setup		/* 245 */
> +	.long sys_io_destroy
> +	.long sys_io_getevents
> +	.long sys_io_submit
> +	.long sys_io_cancel
> +	.long sys_fadvise64		/* 250 */
> +	.long sys_ni_syscall
> +	.long sys_exit_group
> +	.long sys_lookup_dcookie
> +	.long sys_epoll_create
> +	.long sys_epoll_ctl		/* 255 */
> +	.long sys_epoll_wait
> +	.long sys_ni_syscall		/* sys_remap_file_pages */

and this one

> +	.long sys_set_tid_address
> +	.long sys_timer_create
> +	.long sys_timer_settime		/* 260 */
> +	.long sys_timer_gettime
> +	.long sys_timer_getoverrun
> +	.long sys_timer_delete
> +	.long sys_clock_settime
> +	.long sys_clock_gettime		/* 265 */
> +	.long sys_clock_getres
> +	.long sys_clock_nanosleep
> +	.long sys_statfs64
> +	.long sys_fstatfs64
> +	.long sys_tgkill		/* 270 */
> +	.long sys_utimes
> +	.long sys_fadvise64_64
> +	.long sys_ni_syscall		/* sys_vserver */

Everyone seems to define __NR_vserver for a possible future extension,
so just leave this one in.

> +	.long sys_mbind
> +	.long sys_get_mempolicy
> +	.long sys_set_mempolicy
> +	.long sys_mq_open
> +	.long sys_mq_unlink
> +	.long sys_mq_timedsend
> +	.long sys_mq_timedreceive	/* 280 */
> +	.long sys_mq_notify
> +	.long sys_mq_getsetattr
> +	.long sys_kexec_load
> +	.long sys_waitid
> +	.long sys_ni_syscall		/* 285 */ /* available */

You define __NR_setaltroot 285, so I wouldn't call it available.
Better not define the number and also not reuse the syscall.

> +	.long sys_add_key
> +	.long sys_request_key
> +	.long sys_keyctl
> +	.long sys_ioprio_set
> +	.long sys_ioprio_get		/* 290 */
> +	.long sys_inotify_init
> +	.long sys_inotify_add_watch
> +	.long sys_inotify_rm_watch
> +	.long sys_ni_syscall		/* sys_migrate_pages */
> +	.long sys_ni_syscall		/* 295 */ /* sys_openat */
> +	.long sys_ni_syscall		/* sys_mkdirat */
> +	.long sys_ni_syscall		/* sys_mknodat */
> +	.long sys_ni_syscall		/* sys_fchownat */
> +	.long sys_ni_syscall		/* sys_futimesat */
> +	.long sys_ni_syscall		/* 300 */ /* sys_fstatat64 */
> +	.long sys_ni_syscall		/* sys_unlinkat */
> +	.long sys_ni_syscall		/* sys_renameat */
> +	.long sys_ni_syscall		/* sys_linkat */
> +	.long sys_ni_syscall		/* sys_symlinkat */
> +	.long sys_ni_syscall		/* 305 */ /* sys_readlinkat */
> +	.long sys_ni_syscall		/* sys_fchmodat */
> +	.long sys_ni_syscall		/* sys_faccessat */
> +	.long sys_ni_syscall		/* pselect6 */
> +	.long sys_ni_syscall		/* ppoll */
> +	.long sys_ni_syscall		/* 310 */ /* sys_unshare */
> +	.long sys_ni_syscall		/* sys_set_robust_list */
> +	.long sys_ni_syscall		/* sys_get_robust_list */
> +	.long sys_ni_syscall		/* sys_splice */
> +	.long sys_ni_syscall		/* sys_sync_file_range */
> +	.long sys_ni_syscall		/* 315 */ /* sys_tee */
> +	.long sys_ni_syscall		/* sys_vmsplice */

All of these should definitely be activated, with the exception
of __NR_futimesat, which has already been superceded by
__NR_utimensat, so you don't need to introduce it now.

> +	.long sys_move_pages
> +	.long sys_getcpu
> +	.long sys_epoll_pwait
> +	.long sys_utimensat		/* 320 */
> +	.long sys_signalfd
> +	.long sys_timerfd_create
> +	.long sys_eventfd
> +	.long sys_fallocate
> +	.long sys_semtimedop		/* 325 */

Up to this point, you follow the numbering scheme from x86, so why
do you stop here? x86 does not define semtimedop but rather implements
it in sys_ipc.

> +	.long sys_timerfd_settime
> +	.long sys_timerfd_gettime


> +#define __ARCH_WANT_IPC_PARSE_VERSION

I'm pretty sure that no application uses IPC versioning on microblaze,
so just leave this out.

> +/* #define __ARCH_WANT_OLD_READDIR */
> +/* #define __ARCH_WANT_OLD_STAT */
> +#define __ARCH_WANT_STAT64
> +#define __ARCH_WANT_SYS_ALARM
> +#define __ARCH_WANT_SYS_GETHOSTNAME

You don't have sys_gethostname in your sys_call_table, so you can
remove this.

> +#define __ARCH_WANT_SYS_PAUSE
> +#define __ARCH_WANT_SYS_SGETMASK
> +#define __ARCH_WANT_SYS_SIGNAL
> +#define __ARCH_WANT_SYS_TIME
> +#define __ARCH_WANT_SYS_UTIME
> +#define __ARCH_WANT_SYS_WAITPID

These are in all your table, but are you sure that uClibc uses them?
If you have built with your current unistd.h, a modern libc should
not add calls to these.

> +#define __ARCH_WANT_SYS_SOCKETCALL

This one (along with sys_ipc) is unfortunate, there simply
isn't a way to get around it without rebuilding your libc.
OTOH, I have seen that you are now using UID32 as I suggested,
so it seems you have already given up on full binary compatibility
and only care about source level compatibility at this point, right?

> +#define __ARCH_WANT_SYS_FADVISE64

Which one does uClibc use? fadvise, fadvise64 or fadvise64_64?

> +#define __ARCH_WANT_SYS_GETPGRP
> +#define __ARCH_WANT_SYS_LLSEEK
> +#define __ARCH_WANT_SYS_NICE
> +#define __ARCH_WANT_SYS_OLDUMOUNT

Same as the list above, do you really need them for compatibility?

> +#define __ARCH_WANT_SYS_SIGPENDING
> +#define __ARCH_WANT_SYS_SIGPROCMASK
> +#define __ARCH_WANT_SYS_RT_SIGACTION

For these, it seems that they are required, it is just unfortunate
that the logic in the kernel requires them to be set to do the right
thing, instead of left out to get it right, like the others.

	Arnd <><
