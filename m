Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbYDXU6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbYDXU6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 16:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbYDXU61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 16:58:27 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:59663 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbYDXU6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 16:58:24 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2008 16:58:23 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=In-Reply-To:Received:Date:Cc:To:From:Subject:Mime-Version:Message-Id:Content-Transfer-Encoding:Content-Type:X-Abuse:X-Seznam-User:X-QM-Mark;
	b=h5n9vPbcp6fWu4syDTXbT7pqOitkxvmwZclgKH6FecweuphHpKt8pDd+tloB7P279
	CExZgqm9bMiWz1TSbFU+pA/Gm4t8X3kZKip7n9JcYhuXK5RYizZ7yCCw8yXDtPcOult
	bFEIaR+QLN4HK6BfWibmhAuGeWMbmbwVU0LA2c4=
In-Reply-To: <200804241311.09881.arnd@arndb.de>
Date: Thu, 24 Apr 2008 22:51:22 +0200 (CEST)
Cc: =?us-ascii?Q?Will=20Newton?= <will.newton@gmail.com>,
       =?us-ascii?Q?Linux=20Kernel=20list?= <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au
To: =?us-ascii?Q?Arnd=20Bergmann?= <arnd@arndb.de>
From: =?us-ascii?Q?Michal=20Simek?= <Monstr@seznam.cz>
Subject: =?us-ascii?Q?Re=3A=20microblaze=20syscall=20list?=
Mime-Version: 1.0
Message-Id: <4988.7968-24314-1195487808-1209070282@seznam.cz>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset="us-ascii"
X-Abuse: abuse@seznam.cz
X-Seznam-User: Monstr@seznam.cz
X-QM-Mark: email-qm1<20687557>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,
here is current syscall table - I only rewrite your changes. I remove sys_ni_syscall except from #ifdefs. 
I would like to match syscalls to logical block. Can I do it? (I'll fix unistd.h later)
Can you look at it if I remove old syscalls? 
I will continue tomorrow I am tired.

Michal

ENTRY(sys_call_table)
	.long sys_restart_syscall	/* 0 */
	.long sys_reboot
	.long sys_exit
	.long sys_execve_wrapper
	.long sys_chdir


	.long sys_sync
	.long sys_kill
	.long sys_tkill
	.long sys_tgkill		/* 270 */

	.long sys_dup
	.long sys_pipe
	.long sys_times
	.long sys_brk			/* 45 */




	.long sys_acct
	.long sys_mount
	.long sys_umount		/* recycled never used phys() */

	.long sys_umask			/* 60 */
	.long sys_chroot
	.long sys_dup2


	.long sys_setrlimit		/* 75 */
	.long sys_getrusage
	.long sys_gettimeofday
	.long sys_settimeofday

	.long sys_munmap
	.long sys_fchmod
	.long sys_fchown		/* 95 */
	.long sys_getpriority
	.long sys_setpriority
	.long sys_syslog
	.long sys_setitimer
	.long sys_getitimer		/* 105 */
	.long sys_newstat
	.long sys_newlstat
	.long sys_newfstat
	.long sys_vhangup
	.long sys_swapoff		/* 115 */
	.long sys_sysinfo
	.long sys_fsync

	.long sys_clone_wrapper		/* 120 */
	.long sys_setdomainname
	.long sys_newuname
	.long sys_adjtimex
	.long sys_init_module
	.long sys_delete_module
	.long sys_quotactl

	.long sys_fchdir
	.long sys_personality
	.long sys_llseek		/* 140 */
	.long sys_flock
	.long sys_readv			/* 145 */
	.long sys_writev

	.long sys_fdatasync
	.long sys_sched_setparam
	.long sys_sched_getparam	/* 155 */
	.long sys_sched_setscheduler
	.long sys_sched_getscheduler
	.long sys_sched_yield
	.long sys_sched_get_priority_max
	.long sys_sched_get_priority_min	/* 160 */
	.long sys_sched_rr_get_interval
	.long sys_nanosleep

	.long sys_ppoll
	.long sys_nfsservctl		/* nfsctl in new version */

	.long sys_prctl

@ /* RT signals */
	.long sys_rt_sigreturn_wrapper
	.long sys_rt_sigaction
	.long sys_rt_sigprocmask	/* 175 */
	.long sys_rt_sigpending
	.long sys_rt_sigtimedwait
	.long sys_rt_sigqueueinfo
	.long sys_rt_sigsuspend_wrapper


	.long sys_pread64		/* 180 */
	.long sys_pwrite64
	.long sys_chown
	.long sys_getcwd
	.long sys_capget
	.long sys_capset		/* 185 */
	.long sys_vfork		/* 190 */
	.long sys_getrlimit
	.long sys_mmap2			/* mmap2 */
#ifdef __ARCH_WANT_SYS_TRUNCATE
	.long sys_truncate64
	.long sys_ftruncate64
#else
	.long sys_ni_syscall
	.long sys_ni_syscall
#endif 
	.long sys_stat64		/* 195 */
	.long sys_lstat64
	.long sys_fstat64

	.long sys_chown
	.long sys_lchown
	.long sys_fchown

/* process */
	.long sys_getpid		/* 20 */
	.long sys_getppid

	.long sys_getpgid
	.long sys_setresgid		/* 170 */
	.long sys_getresgid

	.long sys_setsid
	.long sys_getsid



/* permissions */
	.long sys_setresuid
	.long sys_getresuid		/* 165 */
	.long sys_getuid
	.long sys_getgid		/* 200 */
	.long sys_geteuid
	.long sys_getegid
	.long sys_setreuid
	.long sys_setpgid
	.long sys_setregid
	.long sys_getgroups		/* 205 */
	.long sys_setgroups
	.long sys_setresuid
	.long sys_getresuid
	.long sys_setresgid		/* 210 */
	.long sys_getresgid
	.long sys_setuid
	.long sys_setgid
	.long sys_setfsuid		/* 215 */
	.long sys_setfsgid
	.long sys_gettid



	.long sys_pivot_root
	.long sys_getdents64		/* 220 */
	.long sys_fcntl64
	.long sys_readahead		/* 225 */
	.long sys_waitid

	.long sys_setxattr
	.long sys_lsetxattr
	.long sys_fsetxattr
	.long sys_getxattr
	.long sys_lgetxattr		/* 230 */
	.long sys_fgetxattr
	.long sys_listxattr
	.long sys_llistxattr
	.long sys_flistxattr
	.long sys_removexattr		/* 235 */
	.long sys_lremovexattr
	.long sys_fremovexattr

	.long sys_sendfile64
	.long sys_futex			/* 240 */
	.long sys_sched_setaffinity
	.long sys_sched_getaffinity
	.long sys_io_setup		/* 245 */
	.long sys_io_destroy
	.long sys_io_getevents
	.long sys_io_submit
	.long sys_io_cancel
	.long sys_exit_group
	.long sys_lookup_dcookie
	.long sys_epoll_create
	.long sys_epoll_ctl		/* 255 */
	.long sys_epoll_pwait
	.long sys_set_tid_address

	.long sys_statfs64
	.long sys_fstatfs64
	.long sys_utimensat
	.long sys_fadvise64_64
	.long sys_mbind
	.long sys_mq_open
	.long sys_mq_unlink
	.long sys_mq_timedsend
	.long sys_mq_timedreceive	/* 280 */
	.long sys_mq_notify
	.long sys_mq_getsetattr
	.long sys_kexec_load

	.long sys_add_key
	.long sys_request_key
	.long sys_keyctl
	.long sys_ioprio_set
	.long sys_ioprio_get		/* 290 */
	.long sys_inotify_init
	.long sys_inotify_add_watch
	.long sys_inotify_rm_watch

/* FILES */
	.long sys_read
	.long sys_write
	.long sys_open /* will sys_openat */	/* 5 */
	.long sys_openat		/* 295 */
	.long sys_ioctl
	.long sys_close
	.long sys_creat
	.long sys_link
	.long sys_unlink		/* 10 */
	.long sys_mkdirat
	.long sys_mknodat
	.long sys_unlinkat
	.long sys_renameat
	.long sys_linkat
	.long sys_symlinkat
	.long sys_readlinkat


	.long sys_fchmodat
	.long sys_faccessat
	.long sys_pselect6
	.long sys_ppoll
	.long sys_unshare
	.long sys_fstatat64
	.long sys_set_robust_list
	.long sys_get_robust_list
	.long sys_splice
	.long sys_sync_file_range
	.long sys_tee
	.long sys_vmsplice
	.long sys_getcpu

	.long sys_eventfd
	.long sys_fallocate
	.long sys_signalfd

/* Time */
	.long sys_utimensat		/* 320 */
	.long sys_timer_create
	.long sys_timer_settime		/* 260 */
	.long sys_timer_gettime
	.long sys_timer_getoverrun
	.long sys_timer_delete
	.long sys_clock_settime
	.long sys_clock_gettime		/* 265 */
	.long sys_clock_getres
	.long sys_clock_nanosleep
	.long sys_timerfd_create
	.long sys_timerfd_settime
	.long sys_timerfd_gettime

/* NET */
	.long sys_accept
	.long sys_bind		/* 315 */
	.long sys_connect
	.long sys_getpeername
	.long sys_getsockname
	.long sys_getsockopt
	.long sys_listen	/* 320 */
	.long sys_recv
	.long sys_recvfrom
	.long sys_recvmsg
	.long sys_send
	.long sys_sendmsg	/* 325 */
	.long sys_sendto
	.long sys_setsockopt
	.long sys_shutdown
	.long sys_socket
	.long sys_socketpair	/* 330 */
	.long sys_sethostname

/* IPC semaphores */
	.long sys_semtimedop		/* 325 */
	.long sys_semctl
	.long sys_semget
	.long sys_semop
/* IPC messages */
	.long sys_msgctl
	.long sys_msgget	/* 335 */
	.long sys_msgrcv
	.long sys_msgsnd
/* IPC shared memory */
	.long sys_shmat
	.long sys_shmctl
	.long sys_shmdt	/* 340 */
	.long sys_shmget


#ifdef __ARCH_WANT_SYS_SIGNAL
	.long sys_signal
#else
	.long sys_ni_syscall
#endif
#ifdef __ARCH_WANT_SYS_TIME
	.long sys_time
	.long sys_stime
#else
	.long sys_ni_syscall
	.long sys_ni_syscall
#endif
	.long sys_ptrace
#ifdef __ARCH_WANT_SYS_ALARM
	.long sys_alarm
#else
	.long sys_ni_syscall
#endif

#ifdef __ARCH_WANT_SYS_PAUSE
	.long sys_pause
#else
	.long sys_ni_syscall
#endif
#ifdef __ARCH_WANT_SYS_UTIME
	.long sys_utime
#else
	.long sys_ni_syscall
#endif
#ifdef __ARCH_WANT_SYS_NICE
	.long sys_nice			/* maybe sys_setpriority? */
#else
	.long sys_ni_syscall
#endif
#ifdef __ARCH_WANT_SYS_GETPGRP
	.long sys_getpgrp		/* 65 */
#else
	.long sys_ni_syscall
#endif
ifdef __ARCH_WANT_SYS_SGETMASK
	.long sys_sgetmask
	.long sys_ssetmask
#else
	.long sys_ni_syscall
	.long sys_ni_syscall
#endif
#ifdef __ARCH_WANT_SYS_USELIB
	.long sys_uselib
#else
	.long sys_ni_syscall
#endif
