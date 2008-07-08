Return-Path: <linux-kernel-owner+w=401wt.eu-S1759968AbYGHMQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968AbYGHMQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758544AbYGHMND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:13:03 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:27311 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757141AbYGHMM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:12:58 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 57/58] microblaze_v5: syscall_table.S and unistd.h
Date: Tue,  8 Jul 2008 13:59:57 +0200
Message-Id: <4a11ba8b7ae0ee21fbd05ea1881f59fb9fe4bafc.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <41cdea2c3255c0bcc7da940a2a1e76d48dc71d02.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
 <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
 <1f9a1f345caa749cb630cf85f95f217366395069.1215517976.git.monstr@monstr.eu>
 <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
 <e61f5a8579570cf7cd18a22e4106b7f85518928e.1215517976.git.monstr@monstr.eu>
 <59d7e0a5f38b8d38f01f357a071fc93eed36f3a8.1215517976.git.monstr@monstr.eu>
 <143afcf84af583ab66da7e8acfc9eb03b7f3eaa0.1215517976.git.monstr@monstr.eu>
 <a967ee4e5a60b410e2810ce0475e8fd04f99e3ae.1215517976.git.monstr@monstr.eu>
 <c5f0730287365c845746467a9917dbc07d2fca3c.1215517976.git.monstr@monstr.eu>
 <2aa1ac7891af57959237aae3addf4bbe607f55d7.1215517976.git.monstr@monstr.eu>
 <875ba2708f6cd3c585e4d965142e2feb07c39a0e.1215517976.git.monstr@monstr.eu>
 <eb0e741f891335df37c3cd19f1a3ce2f7ce8652a.1215517976.git.monstr@monstr.eu>
 <b28df2ea2419cbda26f9089ed6edcc175c009688.1215517976.git.monstr@monstr.eu>
 <5da1d8f069f18f14faee8c4bff736791179ef6f1.1215517976.git.monstr@monstr.eu>
 <9a32168fe72b772f301216a7090670474af78e49.1215517976.git.monstr@monstr.eu>
 <7ada4bceefc1806a2c8ef73676b7aabd8ac1cad6.1215517976.git.monstr@monstr.eu>
 <701c1dac442ac09f5010cb5356cc1a12bb0abfe1.1215517976.git.monstr@monstr.eu>
 <9b48e9d85b4a5a6dcffce8eef62b232b6bfac8e8.1215517976.git.monstr@monstr.eu>
 <04b0b222b84ba9cfe2507a9081f4d715f2323733.1215517976.git.monstr@monstr.eu>
 <d4c1b3ecfec1bf37ca0ecea6909ad25bbc945630.1215517976.git.monstr@monstr.eu>
 <6e5687d37386334cf122d1eafcca0c6649c955be.1215517976.git.monstr@monstr.eu>
 <689cff1b6d98f60d8f8abc4472193688b524284d.1215517976.git.monstr@monstr.eu>
 <9664f18e7e86af4332018549b29bf0797d6afcd5.1215517976.git.monstr@monstr.eu>
 <c7120d8a6379cb1a18af5330997e30ec974acc2f.1215517976.git.monstr@monstr.eu>
 <d1d33c18956829ec9ac7daf8d0516b17e85ed190.1215517976.git.monstr@monstr.eu>
 <7a16429cfc461420883dbaa80c16047e5a1a91c1.1215517976.git.monstr@monstr.eu>
 <b6a0f3bceb0867c55613463fc43be5328fcedecd.1215517976.git.monstr@monstr.eu>
 <fc26823d77c7180b62022e2d4bcca3c4fe6de574.1215517976.git.monstr@monstr.eu>
 <64089967061955b7a29eb6d4e6269ff75b5442f2.1215517976.git.monstr@monstr.eu>
 <92e3ab88c2174acf4e25c474c1f68ffd4db72ca6.1215517976.git.monstr@monstr.eu>
 <5174afd0eaa5c6cb9344ea3217199e48899be313.1215517976.git.monstr@monstr.eu>
 <bcb94400dca62fb349d0ab1e0a6209291fdcdfc5.1215517976.git.monstr@monstr.eu>
 <5b2ed516b2e51d5117386c1b6eb814acc6e5a157.1215517976.git.monstr@monstr.eu>
 <421f4b613d4dbd983df1545a9a163347e5bd1c56.1215517976.git.monstr@monstr.eu>
 <0d39e8f03c487c004efa226c5ee81a81a8856768.1215517976.git.monstr@monstr.eu>
 <c4f477d71dd4cd2ae884b9c47756c9334f8dac18.1215517976.git.monstr@monstr.eu>
 <a98df8525bf9287d7a8b6077ff20dd61a055a98e.1215517976.git.monstr@monstr.eu>
 <c6651b096ee8a0691f94f8c19574302dbfb61ee4.1215517976.git.monstr@monstr.eu>
 <2ac3915482a9a50f7a4531908305b326baa2008e.1215517976.git.monstr@monstr.eu>
 <3c5eac3dbdbf538c727a4a8fe336cdd55650bb37.1215517976.git.monstr@monstr.eu>
 <6c03dcf8dbfd910ebf6c2f95db61d0456aa943e1.1215517976.git.monstr@monstr.eu>
 <1054e7643bd01351ba67273043203df322b49bea.1215517976.git.monstr@monstr.eu>
 <2bc35758e609ee5b79afe0f58be17d11a01498dc.1215517976.git.monstr@monstr.eu>
 <542a23f9748621b66e6f0ef8e0eb6248d542aa99.1215517976.git.monstr@monstr.eu>
 <5fbc8a35844b0f81291f7cf3ff5030baca819b67.1215517976.git.monstr@monstr.eu>
 <64353f136ffa9f5dba8854168b6ef9d3a71f5a47.1215517976.git.monstr@monstr.eu>
 <41cdea2c3255c0bcc7da940a2a1e76d48dc71d02.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/syscall_table.S |  330 +++++++++++++++++++++++++++
 include/asm-microblaze/unistd.h        |  390 ++++++++++++++++++++++++++++++++
 2 files changed, 720 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/syscall_table.S
 create mode 100644 include/asm-microblaze/unistd.h

diff --git a/arch/microblaze/kernel/syscall_table.S b/arch/microblaze/kernel/syscall_table.S
new file mode 100644
index 0000000..28d1b3b
--- /dev/null
+++ b/arch/microblaze/kernel/syscall_table.S
@@ -0,0 +1,330 @@
+ENTRY(sys_call_table)
+	.long sys_restart_syscall	/* 0 - old "setup()" system call,
+					 * used for restarting */
+	.long sys_exit
+	.long sys_ni_syscall		/* was fork */
+	.long sys_read
+	.long sys_write
+	.long sys_open			/* 5 */
+	.long sys_close
+	.long sys_waitpid
+	.long sys_creat
+	.long sys_link
+	.long sys_unlink		/* 10 */
+	.long sys_execve_wrapper
+	.long sys_chdir
+	.long sys_time
+	.long sys_mknod
+	.long sys_chmod			/* 15 */
+	.long sys_lchown
+	.long sys_ni_syscall		/* old break syscall holder */
+	.long sys_ni_syscall		/* old stat */
+	.long sys_lseek
+	.long sys_getpid		/* 20 */
+	.long sys_mount
+	.long sys_oldumount
+	.long sys_setuid
+	.long sys_getuid
+	.long sys_stime			/* 25 */
+	.long sys_ptrace
+	.long sys_alarm
+	.long sys_ni_syscall		/* oldfstat */
+	.long sys_pause
+	.long sys_utime			/* 30 */
+	.long sys_ni_syscall		/* stty syscall holder */
+	.long sys_ni_syscall		/* gtty syscall holder */
+	.long sys_access
+	.long sys_nice
+	.long sys_ni_syscall		/* 35 - ftime syscall holder */
+	.long sys_sync
+	.long sys_kill
+	.long sys_rename
+	.long sys_mkdir
+	.long sys_rmdir			/* 40 */
+	.long sys_dup
+	.long sys_pipe
+	.long sys_times
+	.long sys_ni_syscall		/* prof syscall holder */
+	.long sys_brk			/* 45 */
+	.long sys_setgid
+	.long sys_getgid
+	.long sys_signal
+	.long sys_geteuid
+	.long sys_getegid		/* 50 */
+	.long sys_acct
+	.long sys_umount		/* umount2 recycled never used phys() */
+	.long sys_ni_syscall		/* lock syscall holder */
+	.long sys_ioctl
+	.long sys_fcntl			/* 55 */
+	.long sys_ni_syscall		/* mpx syscall holder */
+	.long sys_setpgid
+	.long sys_ni_syscall		/* ulimit syscall holder */
+	.long sys_ni_syscall		/* oldolduname*/
+	.long sys_umask			/* 60 */
+	.long sys_chroot
+	.long sys_ustat
+	.long sys_dup2
+	.long sys_getppid
+	.long sys_getpgrp		/* 65 */
+	.long sys_setsid
+	.long sys_sigaction
+	.long sys_sgetmask
+	.long sys_ssetmask
+	.long sys_setreuid		/* 70 */
+	.long sys_setregid
+	.long sys_sigsuspend_wrapper
+	.long sys_sigpending
+	.long sys_sethostname
+	.long sys_setrlimit		/* 75 */
+	.long sys_ni_syscall		/* old_getrlimit */
+	.long sys_getrusage
+	.long sys_gettimeofday
+	.long sys_settimeofday
+	.long sys_getgroups		/* 80 */
+	.long sys_setgroups
+	.long sys_ni_syscall		/* old_select */
+	.long sys_symlink
+	.long sys_ni_syscall		/* oldlstat */
+	.long sys_readlink		/* 85 */
+	.long sys_uselib
+	.long sys_swapon
+	.long sys_reboot
+	.long sys_ni_syscall		/* old_readdir */
+	.long sys_mmap			/* 90 */ /* old_mmap */
+	.long sys_munmap
+	.long sys_truncate
+	.long sys_ftruncate
+	.long sys_fchmod
+	.long sys_fchown		/* 95 */
+	.long sys_getpriority
+	.long sys_setpriority
+	.long sys_ni_syscall		/* old profil syscall holder */
+	.long sys_statfs
+	.long sys_fstatfs		/* 100 */
+	.long sys_ni_syscall		/* ioperm */
+	.long sys_socketcall
+	.long sys_syslog		/* operation with system console */
+	.long sys_setitimer
+	.long sys_getitimer		/* 105 */
+	.long sys_newstat
+	.long sys_newlstat
+	.long sys_newfstat
+	.long sys_ni_syscall		/* uname */
+	.long sys_ni_syscall		/* 110 */ /* iopl */
+	.long sys_vhangup
+	.long sys_ni_syscall		/* old "idle" system call */
+	.long sys_ni_syscall		/* old sys_vm86old */
+	.long sys_wait4
+	.long sys_swapoff		/* 115 */
+	.long sys_sysinfo
+	.long sys_ipc
+	.long sys_fsync
+	.long sys_sigreturn_wrapper
+	.long sys_clone_wrapper		/* 120 */
+	.long sys_setdomainname
+	.long sys_newuname
+	.long sys_ni_syscall		/* modify_ldt */
+	.long sys_adjtimex
+	.long sys_ni_syscall		/* 125:	sys_mprotect */
+	.long sys_sigprocmask
+	.long sys_ni_syscall		/* old "create_module" */
+	.long sys_init_module
+	.long sys_delete_module
+	.long sys_ni_syscall		/* 130:	old "get_kernel_syms" */
+	.long sys_quotactl
+	.long sys_getpgid
+	.long sys_fchdir
+	.long sys_bdflush
+	.long sys_sysfs			/* 135 */
+	.long sys_personality
+	.long sys_ni_syscall		/* reserved for afs_syscall */
+	.long sys_setfsuid
+	.long sys_setfsgid
+	.long sys_llseek		/* 140 */
+	.long sys_getdents
+	.long sys_select
+	.long sys_flock
+	.long sys_ni_syscall		/* sys_msync */
+	.long sys_readv			/* 145 */
+	.long sys_writev
+	.long sys_getsid
+	.long sys_fdatasync
+	.long sys_sysctl
+	.long sys_ni_syscall		/* 150:	sys_mlock */
+	.long sys_ni_syscall		/* sys_munlock */
+	.long sys_ni_syscall		/* sys_mlockall */
+	.long sys_ni_syscall		/* sys_munlockall */
+	.long sys_sched_setparam
+	.long sys_sched_getparam	/* 155 */
+	.long sys_sched_setscheduler
+	.long sys_sched_getscheduler
+	.long sys_sched_yield
+	.long sys_sched_get_priority_max
+	.long sys_sched_get_priority_min	/* 160 */
+	.long sys_sched_rr_get_interval
+	.long sys_nanosleep
+	.long sys_ni_syscall		/* sys_mremap */
+	.long sys_setresuid
+	.long sys_getresuid		/* 165 */
+	.long sys_ni_syscall		/* sys_vm86 */
+	.long sys_ni_syscall		/* Old sys_query_module */
+	.long sys_poll
+	.long sys_nfsservctl
+	.long sys_setresgid		/* 170 */
+	.long sys_getresgid
+	.long sys_prctl
+	.long sys_rt_sigreturn_wrapper
+	.long sys_rt_sigaction
+	.long sys_rt_sigprocmask	/* 175 */
+	.long sys_rt_sigpending
+	.long sys_rt_sigtimedwait
+	.long sys_rt_sigqueueinfo
+	.long sys_rt_sigsuspend_wrapper
+	.long sys_pread64		/* 180 */
+	.long sys_pwrite64
+	.long sys_chown
+	.long sys_getcwd
+	.long sys_capget
+	.long sys_capset		/* 185 */
+	.long sys_ni_syscall		/* sigaltstack */
+	.long sys_sendfile
+	.long sys_ni_syscall		/* reserved for streams1 */
+	.long sys_ni_syscall		/* reserved for streams2 */
+	.long sys_vfork_wrapper		/* 190 */
+	.long sys_getrlimit
+	.long sys_mmap2			/* mmap2 */
+	.long sys_truncate64
+	.long sys_ftruncate64
+	.long sys_stat64		/* 195 */
+	.long sys_lstat64
+	.long sys_fstat64
+	.long sys_lchown
+	.long sys_getuid
+	.long sys_getgid		/* 200 */
+	.long sys_geteuid
+	.long sys_getegid
+	.long sys_setreuid
+	.long sys_setregid
+	.long sys_getgroups		/* 205 */
+	.long sys_setgroups
+	.long sys_fchown
+	.long sys_setresuid
+	.long sys_getresuid
+	.long sys_setresgid		/* 210 */
+	.long sys_getresgid
+	.long sys_chown
+	.long sys_setuid
+	.long sys_setgid
+	.long sys_setfsuid		/* 215 */
+	.long sys_setfsgid
+	.long sys_pivot_root
+	.long sys_ni_syscall		/* sys_mincore */
+	.long sys_ni_syscall		/* sys_madvise */
+	.long sys_getdents64		/* 220 */
+	.long sys_fcntl64
+	.long sys_ni_syscall		/* reserved for TUX */
+	.long sys_ni_syscall
+	.long sys_gettid
+	.long sys_readahead		/* 225 */
+	.long sys_setxattr
+	.long sys_lsetxattr
+	.long sys_fsetxattr
+	.long sys_getxattr
+	.long sys_lgetxattr		/* 230 */
+	.long sys_fgetxattr
+	.long sys_listxattr
+	.long sys_llistxattr
+	.long sys_flistxattr
+	.long sys_removexattr		/* 235 */
+	.long sys_lremovexattr
+	.long sys_fremovexattr
+	.long sys_tkill
+	.long sys_sendfile64
+	.long sys_futex			/* 240 */
+	.long sys_sched_setaffinity
+	.long sys_sched_getaffinity
+	.long sys_ni_syscall		/* set_thread_area */
+	.long sys_ni_syscall		/* get_thread_area */
+	.long sys_io_setup		/* 245 */
+	.long sys_io_destroy
+	.long sys_io_getevents
+	.long sys_io_submit
+	.long sys_io_cancel
+	.long sys_fadvise64		/* 250 */
+	.long sys_ni_syscall
+	.long sys_exit_group
+	.long sys_lookup_dcookie
+	.long sys_epoll_create
+	.long sys_epoll_ctl		/* 255 */
+	.long sys_epoll_wait
+	.long sys_ni_syscall		/* sys_remap_file_pages */
+	.long sys_set_tid_address
+	.long sys_timer_create
+	.long sys_timer_settime		/* 260 */
+	.long sys_timer_gettime
+	.long sys_timer_getoverrun
+	.long sys_timer_delete
+	.long sys_clock_settime
+	.long sys_clock_gettime		/* 265 */
+	.long sys_clock_getres
+	.long sys_clock_nanosleep
+	.long sys_statfs64
+	.long sys_fstatfs64
+	.long sys_tgkill		/* 270 */
+	.long sys_utimes
+	.long sys_fadvise64_64
+	.long sys_ni_syscall		/* sys_vserver */
+	.long sys_mbind
+	.long sys_get_mempolicy
+	.long sys_set_mempolicy
+	.long sys_mq_open
+	.long sys_mq_unlink
+	.long sys_mq_timedsend
+	.long sys_mq_timedreceive	/* 280 */
+	.long sys_mq_notify
+	.long sys_mq_getsetattr
+	.long sys_kexec_load
+	.long sys_waitid
+	.long sys_ni_syscall		/* 285 */ /* available */
+	.long sys_add_key
+	.long sys_request_key
+	.long sys_keyctl
+	.long sys_ioprio_set
+	.long sys_ioprio_get		/* 290 */
+	.long sys_inotify_init
+	.long sys_inotify_add_watch
+	.long sys_inotify_rm_watch
+	.long sys_ni_syscall		/* sys_migrate_pages */
+	.long sys_ni_syscall		/* 295 */ /* sys_openat */
+	.long sys_ni_syscall		/* sys_mkdirat */
+	.long sys_ni_syscall		/* sys_mknodat */
+	.long sys_ni_syscall		/* sys_fchownat */
+	.long sys_ni_syscall		/* sys_futimesat */
+	.long sys_ni_syscall		/* 300 */ /* sys_fstatat64 */
+	.long sys_ni_syscall		/* sys_unlinkat */
+	.long sys_ni_syscall		/* sys_renameat */
+	.long sys_ni_syscall		/* sys_linkat */
+	.long sys_ni_syscall		/* sys_symlinkat */
+	.long sys_ni_syscall		/* 305 */ /* sys_readlinkat */
+	.long sys_ni_syscall		/* sys_fchmodat */
+	.long sys_ni_syscall		/* sys_faccessat */
+	.long sys_ni_syscall		/* pselect6 */
+	.long sys_ni_syscall		/* ppoll */
+	.long sys_ni_syscall		/* 310 */ /* sys_unshare */
+	.long sys_ni_syscall		/* sys_set_robust_list */
+	.long sys_ni_syscall		/* sys_get_robust_list */
+	.long sys_ni_syscall		/* sys_splice */
+	.long sys_ni_syscall		/* sys_sync_file_range */
+	.long sys_ni_syscall		/* 315 */ /* sys_tee */
+	.long sys_ni_syscall		/* sys_vmsplice */
+	.long sys_move_pages
+	.long sys_getcpu
+	.long sys_epoll_pwait
+	.long sys_utimensat		/* 320 */
+	.long sys_signalfd
+	.long sys_timerfd_create
+	.long sys_eventfd
+	.long sys_fallocate
+	.long sys_semtimedop		/* 325 */
+	.long sys_timerfd_settime
+	.long sys_timerfd_gettime
diff --git a/include/asm-microblaze/unistd.h b/include/asm-microblaze/unistd.h
new file mode 100644
index 0000000..dc3d7f8
--- /dev/null
+++ b/include/asm-microblaze/unistd.h
@@ -0,0 +1,390 @@
+/*
+ * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_UNISTD_H
+#define _ASM_MICROBLAZE_UNISTD_H
+
+#define __NR_restart_syscall	0
+#define __NR_exit		1
+#define __NR_fork		2
+#define __NR_read		3
+#define __NR_write		4
+#define __NR_open		5
+#define __NR_close		6
+#define __NR_waitpid		7
+#define __NR_creat		8
+#define __NR_link		9
+#define __NR_unlink		10
+#define __NR_execve		11
+#define __NR_chdir		12
+#define __NR_time		13
+#define __NR_mknod		14
+#define __NR_chmod		15
+#define __NR_lchown		16
+#define __NR_break		17
+#define __NR_oldstat		18
+#define __NR_lseek		19
+#define __NR_getpid		20
+#define __NR_mount		21
+#define __NR_umount		22
+#define __NR_setuid		23
+#define __NR_getuid		24
+#define __NR_stime		25
+#define __NR_ptrace		26
+#define __NR_alarm		27
+#define __NR_oldfstat		28
+#define __NR_pause		29
+#define __NR_utime		30
+#define __NR_stty		31
+#define __NR_gtty		32
+#define __NR_access		33
+#define __NR_nice		34
+#define __NR_ftime		35
+#define __NR_sync		36
+#define __NR_kill		37
+#define __NR_rename		38
+#define __NR_mkdir		39
+#define __NR_rmdir		40
+#define __NR_dup		41
+#define __NR_pipe		42
+#define __NR_times		43
+#define __NR_prof		44
+#define __NR_brk		45
+#define __NR_setgid		46
+#define __NR_getgid		47
+#define __NR_signal		48
+#define __NR_geteuid		49
+#define __NR_getegid		50
+#define __NR_acct		51
+#define __NR_umount2		52
+#define __NR_lock		53
+#define __NR_ioctl		54
+#define __NR_fcntl		55
+#define __NR_mpx		56
+#define __NR_setpgid		57
+#define __NR_ulimit		58
+#define __NR_oldolduname	59
+#define __NR_umask		60
+#define __NR_chroot		61
+#define __NR_ustat		62
+#define __NR_dup2		63
+#define __NR_getppid		64
+#define __NR_getpgrp		65
+#define __NR_setsid		66
+#define __NR_sigaction		67
+#define __NR_sgetmask		68
+#define __NR_ssetmask		69
+#define __NR_setreuid		70
+#define __NR_setregid		71
+#define __NR_sigsuspend		72
+#define __NR_sigpending		73
+#define __NR_sethostname	74
+#define __NR_setrlimit		75
+#define __NR_getrlimit		76 /* Back compatible 2Gig limited rlimit */
+#define __NR_getrusage		77
+#define __NR_gettimeofday	78
+#define __NR_settimeofday	79
+#define __NR_getgroups		80
+#define __NR_setgroups		81
+#define __NR_select		82
+#define __NR_symlink		83
+#define __NR_oldlstat		84
+#define __NR_readlink		85
+#define __NR_uselib		86
+#define __NR_swapon		87
+#define __NR_reboot		88
+#define __NR_readdir		89
+#define __NR_mmap		90
+#define __NR_munmap		91
+#define __NR_truncate		92
+#define __NR_ftruncate		93
+#define __NR_fchmod		94
+#define __NR_fchown		95
+#define __NR_getpriority	96
+#define __NR_setpriority	97
+#define __NR_profil		98
+#define __NR_statfs		99
+#define __NR_fstatfs		100
+#define __NR_ioperm		101
+#define __NR_socketcall		102
+#define __NR_syslog		103
+#define __NR_setitimer		104
+#define __NR_getitimer		105
+#define __NR_stat		106
+#define __NR_lstat		107
+#define __NR_fstat		108
+#define __NR_olduname		109
+#define __NR_iopl		110
+#define __NR_vhangup		111
+#define __NR_idle		112
+#define __NR_vm86old		113
+#define __NR_wait4		114
+#define __NR_swapoff		115
+#define __NR_sysinfo		116
+#define __NR_ipc		117
+#define __NR_fsync		118
+#define __NR_sigreturn		119
+#define __NR_clone		120
+#define __NR_setdomainname	121
+#define __NR_uname		122
+#define __NR_modify_ldt		123
+#define __NR_adjtimex		124
+#define __NR_mprotect		125
+#define __NR_sigprocmask	126
+#define __NR_create_module	127
+#define __NR_init_module	128
+#define __NR_delete_module	129
+#define __NR_get_kernel_syms	130
+#define __NR_quotactl		131
+#define __NR_getpgid		132
+#define __NR_fchdir		133
+#define __NR_bdflush		134
+#define __NR_sysfs		135
+#define __NR_personality	136
+#define __NR_afs_syscall	137 /* Syscall for Andrew File System */
+#define __NR_setfsuid		138
+#define __NR_setfsgid		139
+#define __NR__llseek		140
+#define __NR_getdents		141
+#define __NR__newselect		142
+#define __NR_flock		143
+#define __NR_msync		144
+#define __NR_readv		145
+#define __NR_writev		146
+#define __NR_getsid		147
+#define __NR_fdatasync		148
+#define __NR__sysctl		149
+#define __NR_mlock		150
+#define __NR_munlock		151
+#define __NR_mlockall		152
+#define __NR_munlockall		153
+#define __NR_sched_setparam		154
+#define __NR_sched_getparam		155
+#define __NR_sched_setscheduler		156
+#define __NR_sched_getscheduler		157
+#define __NR_sched_yield		158
+#define __NR_sched_get_priority_max	159
+#define __NR_sched_get_priority_min	160
+#define __NR_sched_rr_get_interval	161
+#define __NR_nanosleep		162
+#define __NR_mremap		163
+#define __NR_setresuid		164
+#define __NR_getresuid		165
+#define __NR_vm86		166
+#define __NR_query_module	167
+#define __NR_poll		168
+#define __NR_nfsservctl		169
+#define __NR_setresgid		170
+#define __NR_getresgid		171
+#define __NR_prctl		172
+#define __NR_rt_sigreturn	173
+#define __NR_rt_sigaction	174
+#define __NR_rt_sigprocmask	175
+#define __NR_rt_sigpending	176
+#define __NR_rt_sigtimedwait	177
+#define __NR_rt_sigqueueinfo	178
+#define __NR_rt_sigsuspend	179
+#define __NR_pread64		180
+#define __NR_pwrite64		181
+#define __NR_chown		182
+#define __NR_getcwd		183
+#define __NR_capget		184
+#define __NR_capset		185
+#define __NR_sigaltstack	186
+#define __NR_sendfile		187
+#define __NR_getpmsg		188 /* some people actually want streams */
+#define __NR_putpmsg		189 /* some people actually want streams */
+#define __NR_vfork		190
+#define __NR_ugetrlimit		191 /* SuS compliant getrlimit */
+#define __NR_mmap2		192
+#define __NR_truncate64		193
+#define __NR_ftruncate64	194
+#define __NR_stat64		195
+#define __NR_lstat64		196
+#define __NR_fstat64		197
+#define __NR_lchown32		198
+#define __NR_getuid32		199
+#define __NR_getgid32		200
+#define __NR_geteuid32		201
+#define __NR_getegid32		202
+#define __NR_setreuid32		203
+#define __NR_setregid32		204
+#define __NR_getgroups32	205
+#define __NR_setgroups32	206
+#define __NR_fchown32		207
+#define __NR_setresuid32	208
+#define __NR_getresuid32	209
+#define __NR_setresgid32	210
+#define __NR_getresgid32	211
+#define __NR_chown32		212
+#define __NR_setuid32		213
+#define __NR_setgid32		214
+#define __NR_setfsuid32		215
+#define __NR_setfsgid32		216
+#define __NR_pivot_root		217
+#define __NR_mincore		218
+#define __NR_madvise		219
+#define __NR_madvise1		219 /* delete when C lib stub is removed */
+#define __NR_getdents64		220
+#define __NR_fcntl64		221
+/* 223 is unused */
+#define __NR_gettid		224
+#define __NR_readahead		225
+#define __NR_setxattr		226
+#define __NR_lsetxattr		227
+#define __NR_fsetxattr		228
+#define __NR_getxattr		229
+#define __NR_lgetxattr		230
+#define __NR_fgetxattr		231
+#define __NR_listxattr		232
+#define __NR_llistxattr		233
+#define __NR_flistxattr		234
+#define __NR_removexattr	235
+#define __NR_lremovexattr	236
+#define __NR_fremovexattr	237
+#define __NR_tkill		238
+#define __NR_sendfile64		239
+#define __NR_futex		240
+#define __NR_sched_setaffinity	241
+#define __NR_sched_getaffinity	242
+#define __NR_set_thread_area	243
+#define __NR_get_thread_area	244
+#define __NR_io_setup		245
+#define __NR_io_destroy		246
+#define __NR_io_getevents	247
+#define __NR_io_submit		248
+#define __NR_io_cancel		249
+#define __NR_fadvise64		250
+/* 251 is available for reuse (was briefly sys_set_zone_reclaim) */
+#define __NR_exit_group		252
+#define __NR_lookup_dcookie	253
+#define __NR_epoll_create	254
+#define __NR_epoll_ctl		255
+#define __NR_epoll_wait		256
+#define __NR_remap_file_pages	257
+#define __NR_set_tid_address	258
+#define __NR_timer_create	259
+#define __NR_timer_settime	(__NR_timer_create+1)
+#define __NR_timer_gettime	(__NR_timer_create+2)
+#define __NR_timer_getoverrun	(__NR_timer_create+3)
+#define __NR_timer_delete	(__NR_timer_create+4)
+#define __NR_clock_settime	(__NR_timer_create+5)
+#define __NR_clock_gettime	(__NR_timer_create+6)
+#define __NR_clock_getres	(__NR_timer_create+7)
+#define __NR_clock_nanosleep	(__NR_timer_create+8)
+#define __NR_statfs64		268
+#define __NR_fstatfs64		269
+#define __NR_tgkill		270
+#define __NR_utimes		271
+#define __NR_fadvise64_64	272
+#define __NR_vserver		273
+#define __NR_mbind		274
+#define __NR_get_mempolicy	275
+#define __NR_set_mempolicy	276
+#define __NR_mq_open		277
+#define __NR_mq_unlink		(__NR_mq_open+1)
+#define __NR_mq_timedsend	(__NR_mq_open+2)
+#define __NR_mq_timedreceive	(__NR_mq_open+3)
+#define __NR_mq_notify		(__NR_mq_open+4)
+#define __NR_mq_getsetattr	(__NR_mq_open+5)
+#define __NR_kexec_load		283
+#define __NR_waitid		284
+/* #define __NR_sys_setaltroot	285 */
+#define __NR_add_key		286
+#define __NR_request_key	287
+#define __NR_keyctl		288
+#define __NR_ioprio_set		289
+#define __NR_ioprio_get		290
+#define __NR_inotify_init	291
+#define __NR_inotify_add_watch	292
+#define __NR_inotify_rm_watch	293
+#define __NR_migrate_pages	294
+#define __NR_openat		295
+#define __NR_mkdirat		296
+#define __NR_mknodat		297
+#define __NR_fchownat		298
+#define __NR_futimesat		299
+#define __NR_fstatat64		300
+#define __NR_unlinkat		301
+#define __NR_renameat		302
+#define __NR_linkat		303
+#define __NR_symlinkat		304
+#define __NR_readlinkat		305
+#define __NR_fchmodat		306
+#define __NR_faccessat		307
+#define __NR_pselect6		308
+#define __NR_ppoll		309
+#define __NR_unshare		310
+#define __NR_set_robust_list	311
+#define __NR_get_robust_list	312
+#define __NR_splice		313
+#define __NR_sync_file_range	314
+#define __NR_tee		315
+#define __NR_vmsplice		316
+#define __NR_move_pages		317
+#define __NR_getcpu		318
+#define __NR_epoll_pwait	319
+#define __NR_utimensat		320
+#define __NR_signalfd		321
+#define __NR_timerfd_create	322
+#define __NR_eventfd		323
+#define __NR_fallocate		324
+#define __NR_semtimedop		325
+#define __NR_timerfd_settime	326
+#define __NR_timerfd_gettime	327
+
+#ifdef __KERNEL__
+
+#define __NR_syscalls		327
+
+#define __NR__exit __NR_exit
+#define NR_syscalls	__NR_syscalls
+
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+
+#define __ARCH_WANT_IPC_PARSE_VERSION
+/* #define __ARCH_WANT_OLD_READDIR */
+/* #define __ARCH_WANT_OLD_STAT */
+#define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SYS_ALARM
+#define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_PAUSE
+#define __ARCH_WANT_SYS_SGETMASK
+#define __ARCH_WANT_SYS_SIGNAL
+#define __ARCH_WANT_SYS_TIME
+#define __ARCH_WANT_SYS_UTIME
+#define __ARCH_WANT_SYS_WAITPID
+#define __ARCH_WANT_SYS_SOCKETCALL
+#define __ARCH_WANT_SYS_FADVISE64
+#define __ARCH_WANT_SYS_GETPGRP
+#define __ARCH_WANT_SYS_LLSEEK
+#define __ARCH_WANT_SYS_NICE
+/* #define __ARCH_WANT_SYS_OLD_GETRLIMIT */
+#define __ARCH_WANT_SYS_OLDUMOUNT
+#define __ARCH_WANT_SYS_SIGPENDING
+#define __ARCH_WANT_SYS_SIGPROCMASK
+#define __ARCH_WANT_SYS_RT_SIGACTION
+/* #define __ARCH_WANT_SYS_RT_SIGSUSPEND */
+
+/*
+ * "Conditional" syscalls
+ *
+ * What we want is __attribute__((weak,alias("sys_ni_syscall"))),
+ * but it doesn't work on all toolchains, so we just do it by hand
+ */
+#define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall");
+
+#endif /* __ASSEMBLY__ */
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_MICROBLAZE_UNISTD_H */
-- 
1.5.4.GIT

