Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbYLDFQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbYLDFQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 00:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYLDFQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 00:16:48 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36368 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbYLDFQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 00:16:39 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: sshd segmentation fault on ia64 on 28-rc7-mmotm-081203
Cc: kosaki.motohiro@jp.fujitsu.com,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-netdev@vger.kernel.org, linux-ia64 <linux-ia64@vger.kernel.org>
In-Reply-To: <1228322600.6693.61.camel@lts-notebook>
References: <1228322600.6693.61.camel@lts-notebook>
Message-Id: <20081204141052.1D6B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  4 Dec 2008 14:16:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I couldn't find anything on the list about this.
> 
> I've built and booted 28-rc7-mmotm-081203 on both x86_64 and ia64.  I
> can ssh into the x86_64 platform fine.  On the ia64, I'm seeing sshd
> [from RHEL5 distro] seg faulting.  [Same sshd worked on the
> 28-rc6-mmotm-081201 kernel.]
> 
> Has anyone else seen this?

In my ia64 box, dhclient command failed by SEGV ;-)

# ifup eth7

   Determining IP information for eth7.../etc/sysconfig/network-scripts/ifup-eth: line 282: 49393 Segmentation fault      /sbin/dhclient ${DHCLIENTARGS} ${DEVICE} failed.


strace log here
-----------------------

# strace -f ifup eth7
execve("/sbin/ifup", ["ifup", "eth7"], [/* 19 vars */]) = 0
brk(0)                                  = 0x6000000000030000
uname({sys="Linux", node="PQ-muneda", ...}) = 0
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2000000000050000
close(3)                                = 0
open("/lib/libtermcap.so.2", O_RDONLY)  = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\300\25\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=25272, ...}) = 0
mmap(NULL, 88760, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000060000
mmap(0x2000000000070000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x2000000000070000
close(3)                                = 0
open("/lib/libdl.so.2", O_RDONLY)       = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\300\24\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=27088, ...}) = 0
mmap(NULL, 84288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000080000
mmap(0x2000000000090000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x2000000000090000
close(3)                                = 0
open("/lib/libc.so.6.1", O_RDONLY)      = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x20000000000a0000
mmap(0x2000000000310000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x2000000000310000
close(3)                                = 0
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000320000
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000330000
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000340000
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000350000
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000360000
munmap(0x2000000000050000, 55440)       = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
open("/dev/tty", O_RDWR|O_NONBLOCK)     = 3
close(3)                                = 0
brk(0)                                  = 0x6000000000030000
brk(0x6000000000060000)                 = 0x6000000000060000
getuid()                                = 0
getgid()                                = 0
geteuid()                               = 0
getegid()                               = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
gettimeofday({1228368335, 508540}, NULL) = 0
open("/proc/meminfo", O_RDONLY)         = 3
fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
read(3, "MemTotal:        7985856 kB\nMemF"..., 1024) = 1024
close(3)                                = 0
munmap(0x2000000000050000, 65536)       = 0
rt_sigaction(SIGCHLD, {SIG_DFL}, {SIG_DFL}, 8) = 0
rt_sigaction(SIGCHLD, {SIG_DFL}, {SIG_DFL}, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {SIG_DFL}, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {SIG_DFL}, 8) = 0
rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_DFL}, 8) = 0
rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigaction(SIGQUIT, {SIG_IGN}, {SIG_DFL}, 8) = 0
uname({sys="Linux", node="PQ-muneda", ...}) = 0
stat("/root", {st_mode=S_IFDIR|0750, st_size=4096, ...}) = 0
stat(".", {st_mode=S_IFDIR|0750, st_size=4096, ...}) = 0
getpid()                                = 43542
getppid()                               = 43541
getpgid(0)                              = 43541
rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0}, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
open("/sbin/ifup", O_RDONLY)            = 3
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, 0x600fffffffc1f6d0) = -1 ENOTTY (Inappropriate ioctl for device)
lseek(3, 0, SEEK_CUR)                   = 0
read(3, "#!/bin/bash\n# Network Interface "..., 80) = 80
lseek(3, 0, SEEK_SET)                   = 0
getrlimit(RLIMIT_NOFILE, {rlim_cur=1024, rlim_max=1024}) = 0
dup2(3, 255)                            = 255
close(3)                                = 0
fcntl(255, F_SETFD, FD_CLOEXEC)         = 0
fcntl(255, F_GETFL)                     = 0x8000 (flags O_RDONLY|0x8000)
fstat(255, {st_mode=S_IFREG|0755, st_size=3810, ...}) = 0
lseek(255, 0, SEEK_CUR)                 = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
read(255, "#!/bin/bash\n# Network Interface "..., 3810) = 3810
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("/etc/init.d/functions", {st_mode=S_IFREG|0755, st_size=13913, ...}) = 0
access("/etc/init.d/functions", X_OK)   = 0
access("/etc/init.d/functions", R_OK)   = 0
open("/etc/init.d/functions", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0755, st_size=13913, ...}) = 0
read(3, "# -*-Shell-script-*-\n#\n# functio"..., 13913) = 13913
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
umask(022)                              = 022
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
clone2(Process 43543 attached
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43543
[pid 43542] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43543] close(255 <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43543] <... close resumed> )       = 0
[pid 43542] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 43543] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43542] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43543] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] close(4 <unfinished ...>
[pid 43543] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43542] <... close resumed> )       = 0
[pid 43542] read(3,  <unfinished ...>
[pid 43543] rt_sigaction(SIGTTIN, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43543] rt_sigaction(SIGTTOU, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43543] rt_sigaction(SIGINT, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43543] rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43543] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43543] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0}, {SIG_DFL}, 8) = 0
[pid 43543] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {SIG_DFL}, 8) = 0
[pid 43543] dup2(4, 1)                  = 1
[pid 43543] close(4)                    = 0
[pid 43543] close(3)                    = 0
[pid 43543] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43543] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43543] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43543] rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
[pid 43543] clone2(Process 43544 attached (waiting for parent)
Process 43544 resumed (parent 43543 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43544
[pid 43544] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43544] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43543] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43544] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43544] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43543] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43544] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43544] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43543] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43544] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43544] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43543] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43544] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43544] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43543] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43544] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43544] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43543] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43544] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43544] execve("/sbin/consoletype", ["/sbin/consoletype"...], [/* 19 vars */] <unfinished ...>
[pid 43543] rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
[pid 43543] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 43544] <... execve resumed> )      = 0
[pid 43543] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43544] brk(0 <unfinished ...>
[pid 43543] wait4(-1, Process 43543 suspended
 <unfinished ...>
[pid 43544] <... brk resumed> )         = 0x6000000000010000
[pid 43544] uname({sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43544] access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
[pid 43544] open("/etc/ld.so.cache", O_RDONLY) = 3
[pid 43544] fstat(3, {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43544] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2000000000050000
[pid 43544] close(3)                    = 0
[pid 43544] open("/lib/libc.so.6.1", O_RDONLY) = 3
[pid 43544] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43544] fstat(3, {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43544] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000060000
[pid 43544] mmap(0x20000000002d0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x20000000002d0000
[pid 43544] close(3)                    = 0
[pid 43544] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000002e0000
[pid 43544] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000002f0000
[pid 43544] munmap(0x2000000000050000, 55440) = 0
[pid 43544] fstat(0, {st_mode=S_IFCHR|0620, st_rdev=makedev(4, 64), ...}) = 0
[pid 43544] ioctl(0, TIOCLINUX, 0x600fffffffedf9df) = -1 EINVAL (Invalid argument)
[pid 43544] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43544] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 43544] write(1, "serial\n", 7 <unfinished ...>
[pid 43542] <... read resumed> "serial\n", 128) = 7
[pid 43544] <... write resumed> )       = 7
[pid 43542] read(3,  <unfinished ...>
[pid 43544] exit_group(1)               = ?
Process 43543 resumed
Process 43544 detached
[pid 43543] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 1}], 0, NULL) = 43544
[pid 43543] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43543] --- SIGCHLD (Child exited) @ a000000000010721 (aa18) ---
[pid 43543] wait4(-1, 0x600fffffffc1e11c, WNOHANG, NULL) = -1 ECHILD (No child processes)
[pid 43543] rt_sigreturn()              = ? (mask now [HUP INT QUIT FPE PIPE ALRM TERM STKFLT CONT STOP TTIN XCPU PROF WINCH IO PWR SYS RT17 RT21 RT22])
[pid 43543] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {0x400000000015c560, [], 0}, 8) = 0
[pid 43543] exit_group(1)               = ?
Process 43543 detached
<... read resumed> "", 128)             = 0
--- SIGCHLD (Child exited) @ a000000000010721 (aa17) ---
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 1}], WNOHANG, NULL) = 43543
wait4(-1, 0x600fffffffc1e35c, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [])
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigaction(SIGINT, {0x400000000015c560, [], 0}, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("/etc/sysconfig/i18n", {st_mode=S_IFREG|0644, st_size=57, ...}) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
stat("/etc/profile.d/lang.sh", {st_mode=S_IFREG|0755, st_size=3154, ...}) = 0
access("/etc/profile.d/lang.sh", X_OK)  = 0
access("/etc/profile.d/lang.sh", R_OK)  = 0
open("/etc/profile.d/lang.sh", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0755, st_size=3154, ...}) = 0
read(3, "# /etc/profile.d/lang.sh - set i"..., 3154) = 3154
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("/etc/sysconfig/i18n", {st_mode=S_IFREG|0644, st_size=57, ...}) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
stat("/etc/sysconfig/i18n", {st_mode=S_IFREG|0644, st_size=57, ...}) = 0
access("/etc/sysconfig/i18n", X_OK)     = -1 EACCES (Permission denied)
access("/etc/sysconfig/i18n", R_OK)     = 0
open("/etc/sysconfig/i18n", O_RDONLY)   = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=57, ...}) = 0
read(3, "#LANG=\"ja_JP.UTF-8\"\nLANG=\"C\"\nSYS"..., 57) = 57
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("/root/.i18n", 0x600fffffffc1e6d8) = -1 ENOENT (No such file or directory)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
clone2(Process 43545 attached
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43545
[pid 43542] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43545] close(255 <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43545] <... close resumed> )       = 0
[pid 43542] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 43545] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43545] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43542] close(4 <unfinished ...>
[pid 43545] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 43542] read(3,  <unfinished ...>
[pid 43545] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43545] rt_sigaction(SIGTTIN, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43545] rt_sigaction(SIGTTOU, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43545] rt_sigaction(SIGINT, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43545] rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43545] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43545] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0}, {SIG_DFL}, 8) = 0
[pid 43545] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {SIG_DFL}, 8) = 0
[pid 43545] dup2(4, 1)                  = 1
[pid 43545] close(4)                    = 0
[pid 43545] close(3)                    = 0
[pid 43545] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43545] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43545] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43545] rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
[pid 43545] clone2(Process 43546 attached (waiting for parent)
Process 43546 resumed (parent 43545 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43546
[pid 43546] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43546] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43545] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43546] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43546] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43545] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43546] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43546] rt_sigaction(SIGTTOU, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43545] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43546] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43545] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43546] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43545] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43546] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43545] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43546] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43545] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43546] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43545] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43546] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43545] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 43546] execve("/sbin/consoletype", ["/sbin/consoletype"...], [/* 19 vars */] <unfinished ...>
[pid 43545] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43545] wait4(-1, Process 43545 suspended
 <unfinished ...>
[pid 43546] <... execve resumed> )      = 0
[pid 43546] brk(0)                      = 0x6000000000010000
[pid 43546] uname({sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43546] access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
[pid 43546] open("/etc/ld.so.cache", O_RDONLY) = 3
[pid 43546] fstat(3, {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43546] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2000000000050000
[pid 43546] close(3)                    = 0
[pid 43546] open("/lib/libc.so.6.1", O_RDONLY) = 3
[pid 43546] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43546] fstat(3, {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43546] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000060000
[pid 43546] mmap(0x20000000002d0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x20000000002d0000
[pid 43546] close(3)                    = 0
[pid 43546] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000002e0000
[pid 43546] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000002f0000
[pid 43546] munmap(0x2000000000050000, 55440) = 0
[pid 43546] fstat(0, {st_mode=S_IFCHR|0620, st_rdev=makedev(4, 64), ...}) = 0
[pid 43546] ioctl(0, TIOCLINUX, 0x600fffffff8ef9df) = -1 EINVAL (Invalid argument)
[pid 43546] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43546] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 43546] write(1, "serial\n", 7)     = 7
[pid 43546] exit_group(1)               = ?
Process 43545 resumed
Process 43546 detached
[pid 43542] <... read resumed> "serial\n", 128) = 7
[pid 43545] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 1}], 0, NULL) = 43546
[pid 43542] read(3,  <unfinished ...>
[pid 43545] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43545] --- SIGCHLD (Child exited) @ a000000000010721 (aa1a) ---
[pid 43545] wait4(-1, 0x600fffffffc1d68c, WNOHANG, NULL) = -1 ECHILD (No child processes)
[pid 43545] rt_sigreturn()              = ? (mask now [RT17 RT21 RT22])
[pid 43545] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {0x400000000015c560, [], 0}, 8) = 0
[pid 43545] exit_group(1)               = ?
Process 43545 detached
<... read resumed> "", 128)             = 0
--- SIGCHLD (Child exited) @ a000000000010721 (aa19) ---
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 1}], WNOHANG, NULL) = 43545
wait4(-1, 0x600fffffffc1d8cc, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [])
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigaction(SIGINT, {0x400000000015c560, [], 0}, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("/etc/sysconfig/init", {st_mode=S_IFREG|0644, st_size=1068, ...}) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
stat("/etc/sysconfig/init", {st_mode=S_IFREG|0644, st_size=1068, ...}) = 0
access("/etc/sysconfig/init", X_OK)     = -1 EACCES (Permission denied)
access("/etc/sysconfig/init", R_OK)     = 0
open("/etc/sysconfig/init", O_RDONLY)   = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=1068, ...}) = 0
read(3, "# color => new RH6.0 bootup\n# ve"..., 1068) = 1068
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
brk(0x6000000000090000)                 = 0x6000000000090000
brk(0x6000000000080000)                 = 0x6000000000080000
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("/etc", {st_mode=S_IFDIR|0755, st_size=12288, ...}) = 0
stat("/etc/sysconfig", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
stat("/etc/sysconfig/network-scripts", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
chdir("/etc/sysconfig/network-scripts") = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("./network-functions", {st_mode=S_IFREG|0644, st_size=10392, ...}) = 0
access("./network-functions", X_OK)     = -1 EACCES (Permission denied)
access("./network-functions", R_OK)     = 0
open("./network-functions", O_RDONLY)   = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=10392, ...}) = 0
read(3, "# -*-Shell-script-*-\n#\n# This fi"..., 10392) = 10392
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
brk(0x60000000000b0000)                 = 0x60000000000b0000
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("../network", {st_mode=S_IFREG|0644, st_size=73, ...}) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
stat("../network", {st_mode=S_IFREG|0644, st_size=73, ...}) = 0
access("../network", X_OK)              = -1 EACCES (Permission denied)
access("../network", R_OK)              = 0
open("../network", O_RDONLY)            = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=73, ...}) = 0
read(3, "NETWORKING=yes\nNETWORKING_IPV6=n"..., 73) = 73
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("ifcfg-eth7", {st_mode=S_IFREG|0644, st_size=133, ...}) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("ifcfg-eth7", {st_mode=S_IFREG|0644, st_size=133, ...}) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
lseek(255, -2720, SEEK_CUR)             = 1090
clone2(Process 43550 attached (waiting for parent)
Process 43550 resumed (parent 43542 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43550
[pid 43542] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43550] close(255 <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43550] <... close resumed> )       = 0
[pid 43542] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 43550] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43550] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43542] close(4 <unfinished ...>
[pid 43550] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 43542] read(3,  <unfinished ...>
[pid 43550] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43550] rt_sigaction(SIGTTIN, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43550] rt_sigaction(SIGTTOU, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43550] rt_sigaction(SIGINT, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43550] rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43550] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43550] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0}, {SIG_DFL}, 8) = 0
[pid 43550] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {SIG_DFL}, 8) = 0
[pid 43550] dup2(4, 1)                  = 1
[pid 43550] close(4)                    = 0
[pid 43550] close(3)                    = 0
[pid 43550] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43550] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43550] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43550] rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
[pid 43550] pipe([3, 4])                = 3
[pid 43550] rt_sigprocmask(SIG_BLOCK, [INT CHLD], [CHLD], 8) = 0
[pid 43550] clone2(Process 43551 attached (waiting for parent)
Process 43551 resumed (parent 43550 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43551
[pid 43551] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43551] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43550] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43551] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43551] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43550] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43551] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43551] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43550] close(4 <unfinished ...>
[pid 43551] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43551] close(3 <unfinished ...>
[pid 43550] <... close resumed> )       = 0
[pid 43551] <... close resumed> )       = 0
[pid 43551] dup2(4, 1 <unfinished ...>
[pid 43550] close(4 <unfinished ...>
[pid 43551] <... dup2 resumed> )        = 1
[pid 43551] close(4 <unfinished ...>
[pid 43550] <... close resumed> )       = -1 EBADF (Bad file descriptor)
[pid 43551] <... close resumed> )       = 0
[pid 43551] stat(".",  <unfinished ...>
[pid 43550] rt_sigprocmask(SIG_BLOCK, [INT CHLD],  <unfinished ...>
[pid 43551] <... stat resumed> {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43551] stat("/sbin/basename",  <unfinished ...>
[pid 43550] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43551] <... stat resumed> 0x600fffffffc1e3e0) = -1 ENOENT (No such file or directory)
[pid 43550] clone2( <unfinished ...>
[pid 43551] stat("/usr/sbin/basename", Process 43552 attached (waiting for parent)
0x600fffffffc1e3e0) = -1 ENOENT (No such file or directory)
Process 43552 resumed (parent 43550 ready)
[pid 43550] <... clone2 resumed> child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43552
[pid 43551] stat("/bin/basename",  <unfinished ...>
[pid 43552] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43551] <... stat resumed> {st_mode=S_IFREG|0755, st_size=29472, ...}) = 0
[pid 43552] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43551] access("/bin/basename", X_OK <unfinished ...>
[pid 43552] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43551] <... access resumed> )      = 0
[pid 43552] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43551] access("/bin/basename", R_OK <unfinished ...>
[pid 43552] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43551] <... access resumed> )      = 0
[pid 43552] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43551] stat("/bin/basename",  <unfinished ...>
[pid 43552] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43551] <... stat resumed> {st_mode=S_IFREG|0755, st_size=29472, ...}) = 0
[pid 43552] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43551] access("/bin/basename", X_OK <unfinished ...>
[pid 43552] dup2(3, 0 <unfinished ...>
[pid 43551] <... access resumed> )      = 0
[pid 43552] <... dup2 resumed> )        = 0
[pid 43551] access("/bin/basename", R_OK <unfinished ...>
[pid 43552] close(3 <unfinished ...>
[pid 43551] <... access resumed> )      = 0
[pid 43552] <... close resumed> )       = 0
[pid 43552] stat(".",  <unfinished ...>
[pid 43551] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43552] <... stat resumed> {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43551] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43552] stat("/sbin/sed", 0x600fffffffc1e3e0) = -1 ENOENT (No such file or directory)
[pid 43551] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43552] stat("/usr/sbin/sed",  <unfinished ...>
[pid 43551] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43552] <... stat resumed> 0x600fffffffc1e3e0) = -1 ENOENT (No such file or directory)
[pid 43551] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43552] stat("/bin/sed",  <unfinished ...>
[pid 43551] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43550] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43552] <... stat resumed> {st_mode=S_IFREG|0755, st_size=104144, ...}) = 0
[pid 43551] execve("/bin/basename", ["basename"..., "ifcfg-eth7"...], [/* 20 vars */] <unfinished ...>
[pid 43552] access("/bin/sed", X_OK <unfinished ...>
[pid 43550] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43552] <... access resumed> )      = 0
[pid 43552] access("/bin/sed", R_OK <unfinished ...>
[pid 43550] close(3 <unfinished ...>
[pid 43552] <... access resumed> )      = 0
[pid 43551] <... execve resumed> )      = 0
[pid 43550] <... close resumed> )       = 0
[pid 43552] stat("/bin/sed",  <unfinished ...>
[pid 43551] brk(0 <unfinished ...>
[pid 43552] <... stat resumed> {st_mode=S_IFREG|0755, st_size=104144, ...}) = 0
[pid 43550] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43552] access("/bin/sed", X_OK <unfinished ...>
[pid 43550] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43551] <... brk resumed> )         = 0x6000000000010000
[pid 43552] <... access resumed> )      = 0
[pid 43550] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43552] access("/bin/sed", R_OK <unfinished ...>
[pid 43550] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43552] <... access resumed> )      = 0
[pid 43551] uname( <unfinished ...>
[pid 43550] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43552] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43550] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43551] <... uname resumed> {sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43552] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43550] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 43551] access("/etc/ld.so.preload", R_OK <unfinished ...>
[pid 43552] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43550] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43552] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43550] wait4(-1, Process 43550 suspended
 <unfinished ...>
[pid 43551] <... access resumed> )      = -1 ENOENT (No such file or directory)
[pid 43552] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43551] open("/etc/ld.so.cache", O_RDONLY <unfinished ...>
[pid 43552] execve("/bin/sed", ["sed"..., "s/^ifcfg-//g"...], [/* 20 vars */] <unfinished ...>
[pid 43551] <... open resumed> )        = 3
[pid 43551] fstat(3,  <unfinished ...>
[pid 43552] <... execve resumed> )      = 0
[pid 43551] <... fstat resumed> {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43552] brk(0 <unfinished ...>
[pid 43551] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0 <unfinished ...>
[pid 43552] <... brk resumed> )         = 0x6000000000020000
[pid 43552] uname( <unfinished ...>
[pid 43551] <... mmap resumed> )        = 0x2000000000050000
[pid 43552] <... uname resumed> {sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43551] close(3 <unfinished ...>
[pid 43552] access("/etc/ld.so.preload", R_OK <unfinished ...>
[pid 43551] <... close resumed> )       = 0
[pid 43552] <... access resumed> )      = -1 ENOENT (No such file or directory)
[pid 43551] open("/lib/libc.so.6.1", O_RDONLY <unfinished ...>
[pid 43552] open("/etc/ld.so.cache", O_RDONLY <unfinished ...>
[pid 43551] <... open resumed> )        = 3
[pid 43551] read(3,  <unfinished ...>
[pid 43552] <... open resumed> )        = 3
[pid 43551] <... read resumed> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43552] fstat(3,  <unfinished ...>
[pid 43551] fstat(3,  <unfinished ...>
[pid 43552] <... fstat resumed> {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43551] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43551] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0 <unfinished ...>
[pid 43552] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0 <unfinished ...>
[pid 43551] <... mmap resumed> )        = 0x2000000000060000
[pid 43552] <... mmap resumed> )        = 0x2000000000050000
[pid 43551] mmap(0x20000000002d0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000 <unfinished ...>
[pid 43552] close(3 <unfinished ...>
[pid 43551] <... mmap resumed> )        = 0x20000000002d0000
[pid 43552] <... close resumed> )       = 0
[pid 43551] close(3 <unfinished ...>
[pid 43552] open("/lib/libc.so.6.1", O_RDONLY <unfinished ...>
[pid 43551] <... close resumed> )       = 0
[pid 43552] <... open resumed> )        = 3
[pid 43551] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43552] read(3,  <unfinished ...>
[pid 43551] <... mmap resumed> )        = 0x20000000002e0000
[pid 43552] <... read resumed> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43551] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43552] fstat(3,  <unfinished ...>
[pid 43551] <... mmap resumed> )        = 0x20000000002f0000
[pid 43552] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43551] munmap(0x2000000000050000, 55440 <unfinished ...>
[pid 43552] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0 <unfinished ...>
[pid 43551] <... munmap resumed> )      = 0
[pid 43552] <... mmap resumed> )        = 0x2000000000060000
[pid 43551] brk(0 <unfinished ...>
[pid 43552] mmap(0x20000000002d0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000 <unfinished ...>
[pid 43551] <... brk resumed> )         = 0x6000000000010000
[pid 43552] <... mmap resumed> )        = 0x20000000002d0000
[pid 43551] brk(0x6000000000040000 <unfinished ...>
[pid 43552] close(3 <unfinished ...>
[pid 43551] <... brk resumed> )         = 0x6000000000040000
[pid 43552] <... close resumed> )       = 0
[pid 43551] fstat(1,  <unfinished ...>
[pid 43552] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43551] <... fstat resumed> {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43552] <... mmap resumed> )        = 0x20000000002e0000
[pid 43551] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 43552] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43551] write(1, "ifcfg-eth7\n", 11 <unfinished ...>
[pid 43552] <... mmap resumed> )        = 0x20000000002f0000
[pid 43551] <... write resumed> )       = 11
[pid 43551] close(1)                    = 0
[pid 43552] munmap(0x2000000000050000, 55440 <unfinished ...>
[pid 43551] munmap(0x2000000000050000, 65536 <unfinished ...>
[pid 43552] <... munmap resumed> )      = 0
[pid 43551] <... munmap resumed> )      = 0
[pid 43551] exit_group(0)               = ?
Process 43550 resumed
Process 43551 detached
[pid 43550] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43551
[pid 43552] brk(0 <unfinished ...>
[pid 43550] wait4(-1, Process 43550 suspended
 <unfinished ...>
[pid 43552] <... brk resumed> )         = 0x6000000000020000
[pid 43552] brk(0x6000000000050000)     = 0x6000000000050000
[pid 43552] fstat(0, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43552] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 43552] read(0, "ifcfg-eth7\n", 65536) = 11
[pid 43552] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43552] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000300000
[pid 43552] read(0, "", 65536)          = 0
[pid 43552] write(1, "eth7\n", 5 <unfinished ...>
[pid 43542] <... read resumed> "eth7\n", 128) = 5
[pid 43542] read(3,  <unfinished ...>
[pid 43552] <... write resumed> )       = 5
[pid 43552] close(1)                    = 0
[pid 43552] munmap(0x2000000000300000, 65536) = 0
[pid 43552] close(2)                    = 0
[pid 43552] exit_group(0)               = ?
Process 43550 resumed
Process 43552 detached
[pid 43550] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43552
[pid 43550] rt_sigprocmask(SIG_SETMASK, [CHLD], NULL, 8) = 0
[pid 43550] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {0x400000000015c560, [], 0}, 8) = 0
[pid 43550] close(3)                    = -1 EBADF (Bad file descriptor)
[pid 43550] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43550] --- SIGCHLD (Child exited) @ a000000000010721 (aa1f) ---
[pid 43550] wait4(-1, 0x600fffffffc1db2c, WNOHANG, NULL) = -1 ECHILD (No child processes)
[pid 43550] rt_sigreturn()              = ? (mask now [])
[pid 43550] exit_group(0)               = ?
Process 43550 detached
<... read resumed> "", 128)             = 0
--- SIGCHLD (Child exited) @ a000000000010721 (aa1e) ---
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WNOHANG, NULL) = 43550
wait4(-1, 0x600fffffffc1dc6c, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [])
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigaction(SIGINT, {0x400000000015c560, [], 0}, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [CHLD], 8) = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [INT CHLD], 8) = 0
rt_sigprocmask(SIG_SETMASK, [INT CHLD], NULL, 8) = 0
clone2(Process 43553 attached
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43553
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43553] close(255 <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43553] <... close resumed> )       = 0
[pid 43542] close(4 <unfinished ...>
[pid 43553] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 43542] close(4 <unfinished ...>
[pid 43553] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43542] <... close resumed> )       = -1 EBADF (Bad file descriptor)
[pid 43553] rt_sigaction(SIGTSTP, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43542] rt_sigprocmask(SIG_BLOCK, [INT CHLD],  <unfinished ...>
[pid 43553] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43553] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43542] clone2( <unfinished ...>
[pid 43553] rt_sigaction(SIGTTOU, {SIG_DFL}, Process 43554 attached (waiting for parent)
{SIG_IGN}, 8) = 0
Process 43554 resumed (parent 43542 ready)
[pid 43542] <... clone2 resumed> child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43554
[pid 43553] close(3 <unfinished ...>
[pid 43554] close(255 <unfinished ...>
[pid 43553] <... close resumed> )       = 0
[pid 43553] dup2(4, 1 <unfinished ...>
[pid 43554] <... close resumed> )       = 0
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43553] <... dup2 resumed> )        = 1
[pid 43554] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43553] close(4 <unfinished ...>
[pid 43554] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43554] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] close(3)                    = 0
[pid 43554] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43542] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43554] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43554] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43554] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43553] <... close resumed> )       = 0
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43554] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43553] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43554] dup2(3, 0 <unfinished ...>
[pid 43553] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43554] <... dup2 resumed> )        = 0
[pid 43554] close(3 <unfinished ...>
[pid 43553] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43554] <... close resumed> )       = 0
[pid 43554] stat(".",  <unfinished ...>
[pid 43553] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43554] <... stat resumed> {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43553] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43554] stat("/sbin/grep",  <unfinished ...>
[pid 43553] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43554] <... stat resumed> 0x600fffffffc1e590) = -1 ENOENT (No such file or directory)
[pid 43553] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43554] stat("/usr/sbin/grep",  <unfinished ...>
[pid 43553] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43554] <... stat resumed> 0x600fffffffc1e590) = -1 ENOENT (No such file or directory)
[pid 43553] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43554] stat("/bin/grep",  <unfinished ...>
[pid 43553] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43554] <... stat resumed> {st_mode=S_IFREG|0755, st_size=174960, ...}) = 0
[pid 43553] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 43554] access("/bin/grep", X_OK <unfinished ...>
[pid 43553] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43554] <... access resumed> )      = 0
[pid 43553] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0},  <unfinished ...>
[pid 43554] access("/bin/grep", R_OK <unfinished ...>
[pid 43553] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43554] <... access resumed> )      = 0
[pid 43554] stat("/bin/grep",  <unfinished ...>
[pid 43553] rt_sigprocmask(SIG_BLOCK, NULL,  <unfinished ...>
[pid 43554] <... stat resumed> {st_mode=S_IFREG|0755, st_size=174960, ...}) = 0
[pid 43553] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43554] access("/bin/grep", X_OK)   = 0
[pid 43553] fstat(1,  <unfinished ...>
[pid 43554] access("/bin/grep", R_OK <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43554] <... access resumed> )      = 0
[pid 43553] <... fstat resumed> {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43542] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43554] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43553] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43554] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43554] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43553] <... mmap resumed> )        = 0x2000000000050000
[pid 43542] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 43554] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43553] write(1, "ifcfg-eth7\n", 11 <unfinished ...>
[pid 43554] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43553] <... write resumed> )       = 11
[pid 43554] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43553] exit_group(0)               = ?
Process 43553 detached
[pid 43554] execve("/bin/grep", ["grep"..., "-q"..., "[^g]-"...], [/* 20 vars */] <unfinished ...>
[pid 43542] wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43553
[pid 43554] <... execve resumed> )      = 0
[pid 43542] wait4(-1, Process 43542 suspended
 <unfinished ...>
[pid 43554] brk(0)                      = 0x6000000000010000
[pid 43554] uname({sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43554] access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
[pid 43554] open("/etc/ld.so.cache", O_RDONLY) = 3
[pid 43554] fstat(3, {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43554] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2000000000050000
[pid 43554] close(3)                    = 0
[pid 43554] open("/lib/libpcre.so.0", O_RDONLY) = 3
[pid 43554] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240!\0\0\0\0\0\0"..., 832) = 832
[pid 43554] fstat(3, {st_mode=S_IFREG|0755, st_size=193224, ...}) = 0
[pid 43554] mmap(NULL, 256616, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000060000
[pid 43554] mmap(0x2000000000090000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000) = 0x2000000000090000
[pid 43554] close(3)                    = 0
[pid 43554] open("/lib/libc.so.6.1", O_RDONLY) = 3
[pid 43554] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43554] fstat(3, {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43554] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x20000000000a0000
[pid 43554] mmap(0x2000000000310000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x2000000000310000
[pid 43554] close(3)                    = 0
[pid 43554] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000320000
[pid 43554] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000330000
[pid 43554] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000340000
[pid 43554] munmap(0x2000000000050000, 55440) = 0
[pid 43554] brk(0)                      = 0x6000000000010000
[pid 43554] brk(0x6000000000040000)     = 0x6000000000040000
[pid 43554] read(0, "ifcfg-eth7\n", 65536) = 11
[pid 43554] read(0, "", 65536)          = 0
[pid 43554] close(1)                    = 0
[pid 43554] exit_group(1)               = ?
Process 43542 resumed
Process 43554 detached
<... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 1}], 0, NULL) = 43554
rt_sigprocmask(SIG_SETMASK, [CHLD], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
close(3)                                = -1 EBADF (Bad file descriptor)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
--- SIGCHLD (Child exited) @ a000000000010721 (aa21) ---
wait4(-1, 0x600fffffffc1dcdc, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [])
stat(".", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
stat("/sbin/ifcfg-eth7", 0x600fffffffc1e8f0) = -1 ENOENT (No such file or directory)
stat("/usr/sbin/ifcfg-eth7", 0x600fffffffc1e8f0) = -1 ENOENT (No such file or directory)
stat("/bin/ifcfg-eth7", 0x600fffffffc1e8f0) = -1 ENOENT (No such file or directory)
stat("/usr/bin/ifcfg-eth7", 0x600fffffffc1e8f0) = -1 ENOENT (No such file or directory)
open("ifcfg-eth7", O_RDONLY)            = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=133, ...}) = 0
read(3, "# Intel Corporation 82562ET/EZ/G"..., 133) = 133
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
access("keys-eth7", R_OK)               = -1 ENOENT (No such file or directory)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
clone2(Process 43558 attached (waiting for parent)
Process 43558 resumed (parent 43542 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43558
[pid 43558] close(255)                  = 0
[pid 43558] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43558] rt_sigaction(SIGTSTP, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43558] rt_sigaction(SIGTTIN, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43558] rt_sigaction(SIGTTOU, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43558] rt_sigaction(SIGINT, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43558] rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43558] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43558] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0}, {SIG_DFL}, 8) = 0
[pid 43558] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {SIG_DFL}, 8) = 0
[pid 43558] dup2(4, 1)                  = 1
[pid 43558] close(4)                    = 0
[pid 43558] close(3)                    = 0
[pid 43558] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43558] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43558] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43558] rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
[pid 43558] pipe([3, 4])                = 3
[pid 43558] rt_sigprocmask(SIG_BLOCK, [INT CHLD], [CHLD], 8) = 0
[pid 43558] clone2(Process 43559 attached
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43559
[pid 43559] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43558] rt_sigprocmask(SIG_SETMASK, [CHLD], NULL, 8) = 0
[pid 43542] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43558] close(4)                    = 0
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43558] close(4)                    = -1 EBADF (Bad file descriptor)
[pid 43542] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 43558] rt_sigprocmask(SIG_BLOCK, [INT CHLD],  <unfinished ...>
[pid 43542] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43558] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43542] close(4 <unfinished ...>
[pid 43558] clone2( <unfinished ...>
[pid 43542] <... close resumed> )       = 0
Process 43560 attached (waiting for parent)
[pid 43542] read(3,  <unfinished ...>
[pid 43559] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43559] rt_sigaction(SIGTSTP, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43559] rt_sigaction(SIGTTIN, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43559] rt_sigaction(SIGTTOU, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43559] close(3)                    = 0
[pid 43559] dup2(4, 1)                  = 1
[pid 43559] close(4)                    = 0
[pid 43559] rt_sigaction(SIGINT, {SIG_DFL}, {0x200000000004adc0, [], 0}, 8) = 0
[pid 43559] rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43559] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43559] rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
[pid 43559] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43559] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0}, {SIG_DFL}, 8) = 0
[pid 43559] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {SIG_DFL}, 8) = 0
[pid 43559] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43559] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43559] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 43559] write(1, "eth7\n", 5)       = 5
[pid 43559] exit_group(0)               = ?
Process 43559 detached
Process 43560 resumed (parent 43558 ready)
[pid 43558] <... clone2 resumed> child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43560
[pid 43560] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43560] rt_sigaction(SIGTSTP, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43560] rt_sigaction(SIGTTIN, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43560] rt_sigaction(SIGTTOU, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43560] dup2(3, 0)                  = 0
[pid 43560] close(3)                    = 0
[pid 43560] stat(".", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43560] stat("/sbin/sed", 0x600fffffffc1e740) = -1 ENOENT (No such file or directory)
[pid 43560] stat("/usr/sbin/sed", 0x600fffffffc1e740) = -1 ENOENT (No such file or directory)
[pid 43560] stat("/bin/sed", {st_mode=S_IFREG|0755, st_size=104144, ...}) = 0
[pid 43560] access("/bin/sed", X_OK)    = 0
[pid 43560] access("/bin/sed", R_OK)    = 0
[pid 43560] stat("/bin/sed", {st_mode=S_IFREG|0755, st_size=104144, ...}) = 0
[pid 43560] access("/bin/sed", X_OK)    = 0
[pid 43560] access("/bin/sed", R_OK)    = 0
[pid 43560] rt_sigaction(SIGINT, {SIG_DFL}, {0x200000000004adc0, [], 0}, 8) = 0
[pid 43560] rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43560] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43560] execve("/bin/sed", ["sed"..., "s/[0-9]*$//"...], [/* 20 vars */] <unfinished ...>
[pid 43558] rt_sigprocmask(SIG_SETMASK, [CHLD], NULL, 8) = 0
[pid 43558] close(3 <unfinished ...>
[pid 43560] <... execve resumed> )      = 0
[pid 43558] <... close resumed> )       = 0
[pid 43558] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43560] brk(0)                      = 0x6000000000020000
[pid 43558] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43560] uname( <unfinished ...>
[pid 43558] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43560] <... uname resumed> {sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43558] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43560] access("/etc/ld.so.preload", R_OK <unfinished ...>
[pid 43558] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43560] <... access resumed> )      = -1 ENOENT (No such file or directory)
[pid 43558] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43558] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 43560] open("/etc/ld.so.cache", O_RDONLY <unfinished ...>
[pid 43558] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43560] <... open resumed> )        = 3
[pid 43558] wait4(-1,  <unfinished ...>
[pid 43560] fstat(3,  <unfinished ...>
[pid 43558] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43559
[pid 43558] wait4(-1, Process 43558 suspended
 <unfinished ...>
[pid 43560] <... fstat resumed> {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43560] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2000000000050000
[pid 43560] close(3)                    = 0
[pid 43560] open("/lib/libc.so.6.1", O_RDONLY) = 3
[pid 43560] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43560] fstat(3, {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43560] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000060000
[pid 43560] mmap(0x20000000002d0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x20000000002d0000
[pid 43560] close(3)                    = 0
[pid 43560] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000002e0000
[pid 43560] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000002f0000
[pid 43560] munmap(0x2000000000050000, 55440) = 0
[pid 43560] brk(0)                      = 0x6000000000020000
[pid 43560] brk(0x6000000000050000)     = 0x6000000000050000
[pid 43560] fstat(0, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43560] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 43560] read(0, "eth7\n", 65536)    = 5
[pid 43560] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43560] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000300000
[pid 43560] read(0, "", 65536)          = 0
[pid 43560] write(1, "eth\n", 4)        = 4
[pid 43560] close(1)                    = 0
[pid 43560] munmap(0x2000000000300000, 65536) = 0
[pid 43560] close(2)                    = 0
[pid 43560] exit_group(0)               = ?
Process 43558 resumed
Process 43560 detached
[pid 43542] <... read resumed> "eth\n", 128) = 4
[pid 43558] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43560
[pid 43542] read(3,  <unfinished ...>
[pid 43558] rt_sigprocmask(SIG_SETMASK, [CHLD], NULL, 8) = 0
[pid 43558] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {0x400000000015c560, [], 0}, 8) = 0
[pid 43558] close(3)                    = -1 EBADF (Bad file descriptor)
[pid 43558] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43558] --- SIGCHLD (Child exited) @ a000000000010721 (aa27) ---
[pid 43558] wait4(-1, 0x600fffffffc1de8c, WNOHANG, NULL) = -1 ECHILD (No child processes)
[pid 43558] rt_sigreturn()              = ? (mask now [])
[pid 43558] exit_group(0)               = ?
Process 43558 detached
<... read resumed> "", 128)             = 0
--- SIGCHLD (Child exited) @ a000000000010721 (aa26) ---
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WNOHANG, NULL) = 43558
wait4(-1, 0x600fffffffc1dfcc, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [])
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigaction(SIGINT, {0x400000000015c560, [], 0}, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
clone2(Process 43689 attached
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43689
[pid 43542] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43689] close(255 <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43689] <... close resumed> )       = 0
[pid 43542] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 43689] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43689] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43542] close(4 <unfinished ...>
[pid 43689] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 43542] read(3,  <unfinished ...>
[pid 43689] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43689] rt_sigaction(SIGTTIN, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43689] rt_sigaction(SIGTTOU, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43689] rt_sigaction(SIGINT, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43689] rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43689] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43689] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0}, {SIG_DFL}, 8) = 0
[pid 43689] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {SIG_DFL}, 8) = 0
[pid 43689] dup2(4, 1)                  = 1
[pid 43689] close(4)                    = 0
[pid 43689] close(3)                    = 0
[pid 43689] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43689] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43689] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43689] rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
[pid 43689] pipe([3, 4])                = 3
[pid 43689] rt_sigprocmask(SIG_BLOCK, [INT CHLD], [CHLD], 8) = 0
[pid 43689] clone2(Process 43690 attached (waiting for parent)
Process 43690 resumed (parent 43689 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43690
[pid 43690] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43690] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43689] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43690] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43690] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43689] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43690] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43690] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43689] close(4 <unfinished ...>
[pid 43690] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43690] close(3 <unfinished ...>
[pid 43689] <... close resumed> )       = 0
[pid 43690] <... close resumed> )       = 0
[pid 43690] dup2(4, 1 <unfinished ...>
[pid 43689] close(4 <unfinished ...>
[pid 43690] <... dup2 resumed> )        = 1
[pid 43690] close(4 <unfinished ...>
[pid 43689] <... close resumed> )       = -1 EBADF (Bad file descriptor)
[pid 43690] <... close resumed> )       = 0
[pid 43690] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43689] rt_sigprocmask(SIG_BLOCK, [INT CHLD],  <unfinished ...>
[pid 43690] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43689] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43690] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43689] clone2( <unfinished ...>
[pid 43690] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43690] rt_sigaction(SIGCHLD, {SIG_DFL}, Process 43691 attached (waiting for parent)
{0x400000000015c520, [], 0}, 8) = 0
Process 43691 resumed (parent 43689 ready)
[pid 43689] <... clone2 resumed> child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43691
[pid 43690] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43691] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43690] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43691] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43690] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43689] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43691] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43690] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43689] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43691] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43690] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 43689] close(3 <unfinished ...>
[pid 43691] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43690] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43689] <... close resumed> )       = 0
[pid 43691] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43690] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0},  <unfinished ...>
[pid 43689] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43691] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43690] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43691] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43689] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43691] dup2(3, 0 <unfinished ...>
[pid 43690] rt_sigprocmask(SIG_BLOCK, NULL,  <unfinished ...>
[pid 43691] <... dup2 resumed> )        = 0
[pid 43690] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43689] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43691] close(3)                    = 0
[pid 43690] fstat(1,  <unfinished ...>
[pid 43689] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43691] stat(".",  <unfinished ...>
[pid 43690] <... fstat resumed> {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43691] <... stat resumed> {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43691] stat("/sbin/awk",  <unfinished ...>
[pid 43690] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43691] <... stat resumed> 0x600fffffffc1ebc0) = -1 ENOENT (No such file or directory)
[pid 43691] stat("/usr/sbin/awk",  <unfinished ...>
[pid 43690] <... mmap resumed> )        = 0x2000000000050000
[pid 43691] <... stat resumed> 0x600fffffffc1ebc0) = -1 ENOENT (No such file or directory)
[pid 43691] stat("/bin/awk",  <unfinished ...>
[pid 43690] write(1, "00:0b:5d:6e:00:10\n", 18 <unfinished ...>
[pid 43691] <... stat resumed> {st_mode=S_IFREG|0755, st_size=718168, ...}) = 0
[pid 43690] <... write resumed> )       = 18
[pid 43691] access("/bin/awk", X_OK)    = 0
[pid 43690] exit_group(0)               = ?
Process 43690 detached
[pid 43691] access("/bin/awk", R_OK)    = 0
[pid 43691] stat("/bin/awk", {st_mode=S_IFREG|0755, st_size=718168, ...}) = 0
[pid 43691] access("/bin/awk", X_OK)    = 0
[pid 43691] access("/bin/awk", R_OK)    = 0
[pid 43691] rt_sigaction(SIGINT, {SIG_DFL}, {0x200000000004adc0, [], 0}, 8) = 0
[pid 43691] rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43691] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43691] execve("/bin/awk", ["awk"..., "{ print toupper($0) }"...], [/* 20 vars */] <unfinished ...>
[pid 43689] rt_sigprocmask(SIG_BLOCK, [CHLD], [CHLD], 8) = 0
[pid 43691] <... execve resumed> )      = 0
[pid 43689] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 43691] brk(0)                      = 0x6000000000020000
[pid 43689] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43691] uname( <unfinished ...>
[pid 43689] wait4(-1,  <unfinished ...>
[pid 43691] <... uname resumed> {sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43689] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43690
[pid 43691] access("/etc/ld.so.preload", R_OK <unfinished ...>
[pid 43689] wait4(-1, Process 43689 suspended
 <unfinished ...>
[pid 43691] <... access resumed> )      = -1 ENOENT (No such file or directory)
[pid 43691] open("/etc/ld.so.cache", O_RDONLY) = 3
[pid 43691] fstat(3, {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43691] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2000000000050000
[pid 43691] close(3)                    = 0
[pid 43691] open("/lib/libdl.so.2", O_RDONLY) = 3
[pid 43691] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\300\24\0\0\0\0\0\0"..., 832) = 832
[pid 43691] fstat(3, {st_mode=S_IFREG|0755, st_size=27088, ...}) = 0
[pid 43691] mmap(NULL, 84288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000060000
[pid 43691] mmap(0x2000000000070000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x2000000000070000
[pid 43691] close(3)                    = 0
[pid 43691] open("/lib/libm.so.6.1", O_RDONLY) = 3
[pid 43691] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\300L\0\0\0\0\0\0"..., 832) = 832
[pid 43691] fstat(3, {st_mode=S_IFREG|0755, st_size=897304, ...}) = 0
[pid 43691] mmap(NULL, 861216, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000080000
[pid 43691] mmap(0x2000000000150000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xc0000) = 0x2000000000150000
[pid 43691] close(3)                    = 0
[pid 43691] open("/lib/libc.so.6.1", O_RDONLY) = 3
[pid 43691] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43691] fstat(3, {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43691] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000160000
[pid 43691] mmap(0x20000000003d0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x20000000003d0000
[pid 43691] close(3)                    = 0
[pid 43691] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000003e0000
[pid 43691] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000003f0000
[pid 43691] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000400000
[pid 43691] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000410000
[pid 43691] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000420000
[pid 43691] munmap(0x2000000000050000, 55440) = 0
[pid 43691] brk(0)                      = 0x6000000000020000
[pid 43691] brk(0x6000000000050000)     = 0x6000000000050000
[pid 43691] rt_sigaction(SIGFPE, {0x40000000000a5430, [], SA_RESTART}, {SIG_DFL}, 8) = 0
[pid 43691] rt_sigaction(SIGSEGV, {0x40000000000a5430, [], SA_RESTART}, {SIG_DFL}, 8) = 0
[pid 43691] rt_sigaction(SIGBUS, {0x40000000000a5430, [], SA_RESTART}, {SIG_DFL}, 8) = 0
[pid 43691] fstat(0, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43691] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43691] fstat(2, {st_mode=S_IFCHR|0620, st_rdev=makedev(4, 64), ...}) = 0
[pid 43691] getgroups(0, NULL)          = 7
[pid 43691] getgroups(7, [0, 1, 2, 3, 4, 6, 10]) = 7
[pid 43691] ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, 0x600fffffffc6f890) = -1 EINVAL (Invalid argument)
[pid 43691] fstat(0, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43691] ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, 0x600fffffffc6f7f0) = -1 EINVAL (Invalid argument)
[pid 43691] fstat(0, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43691] read(0, "00:0b:5d:6e:00:10\n", 65536) = 18
[pid 43691] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43691] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 43691] read(0, "", 65536)          = 0
[pid 43691] write(1, "00:0B:5D:6E:00:10\n", 18) = 18
[pid 43542] <... read resumed> "00:0B:5D:6E:00:10\n", 128) = 18
[pid 43691] exit_group(0)               = ?
Process 43689 resumed
Process 43691 detached
[pid 43542] read(3,  <unfinished ...>
[pid 43689] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43691
[pid 43689] rt_sigprocmask(SIG_SETMASK, [CHLD], NULL, 8) = 0
[pid 43689] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {0x400000000015c560, [], 0}, 8) = 0
[pid 43689] close(3)                    = -1 EBADF (Bad file descriptor)
[pid 43689] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43689] --- SIGCHLD (Child exited) @ a000000000010721 (aaaa) ---
[pid 43689] wait4(-1, 0x600fffffffc1e30c, WNOHANG, NULL) = -1 ECHILD (No child processes)
[pid 43689] rt_sigreturn()              = ? (mask now [])
[pid 43689] exit_group(0)               = ?
Process 43689 detached
<... read resumed> "", 128)             = 0
--- SIGCHLD (Child exited) @ a000000000010721 (aaa9) ---
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WNOHANG, NULL) = 43689
wait4(-1, 0x600fffffffc1e44c, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [])
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigaction(SIGINT, {0x400000000015c560, [], 0}, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
read(255, "\nif [ \"foo$2\" = \"fooboot\" ] && ["..., 3810) = 2720
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
access("/sbin/vconfig", X_OK)           = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
access("/sbin/ifup-pre-local", X_OK)    = -1 ENOENT (No such file or directory)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
access("/etc/sysconfig/network-scripts/ifup-eth", X_OK) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigaction(SIGINT, {SIG_DFL}, {SIG_DFL}, 8) = 0
rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_IGN}, 8) = 0
rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
execve("/etc/sysconfig/network-scripts/ifup-eth", ["/etc/sysconfig/network-scripts/i"..., "ifcfg-eth7"...], [/* 19 vars */]) = 0
brk(0)                                  = 0x6000000000030000
uname({sys="Linux", node="PQ-muneda", ...}) = 0
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2000000000050000
close(3)                                = 0
open("/lib/libtermcap.so.2", O_RDONLY)  = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\300\25\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=25272, ...}) = 0
mmap(NULL, 88760, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000060000
mmap(0x2000000000070000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x2000000000070000
close(3)                                = 0
open("/lib/libdl.so.2", O_RDONLY)       = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\300\24\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=27088, ...}) = 0
mmap(NULL, 84288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000080000
mmap(0x2000000000090000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x2000000000090000
close(3)                                = 0
open("/lib/libc.so.6.1", O_RDONLY)      = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x20000000000a0000
mmap(0x2000000000310000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x2000000000310000
close(3)                                = 0
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000320000
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000330000
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000340000
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000350000
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000360000
munmap(0x2000000000050000, 55440)       = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
open("/dev/tty", O_RDWR|O_NONBLOCK)     = 3
close(3)                                = 0
brk(0)                                  = 0x6000000000030000
brk(0x6000000000060000)                 = 0x6000000000060000
getuid()                                = 0
getgid()                                = 0
geteuid()                               = 0
getegid()                               = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
gettimeofday({1228368339, 783560}, NULL) = 0
open("/proc/meminfo", O_RDONLY)         = 3
fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
read(3, "MemTotal:        7985856 kB\nMemF"..., 1024) = 1024
close(3)                                = 0
munmap(0x2000000000050000, 65536)       = 0
rt_sigaction(SIGCHLD, {SIG_DFL}, {SIG_DFL}, 8) = 0
rt_sigaction(SIGCHLD, {SIG_DFL}, {SIG_DFL}, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {SIG_DFL}, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {SIG_DFL}, 8) = 0
rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_DFL}, 8) = 0
rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigaction(SIGQUIT, {SIG_IGN}, {SIG_DFL}, 8) = 0
uname({sys="Linux", node="PQ-muneda", ...}) = 0
stat("/etc/sysconfig/network-scripts", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
stat(".", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
getpid()                                = 43542
getppid()                               = 43541
getpgid(0)                              = 43541
rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0}, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
open("/etc/sysconfig/network-scripts/ifup-eth", O_RDONLY) = 3
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, 0x600fffffffc6f6d0) = -1 ENOTTY (Inappropriate ioctl for device)
lseek(3, 0, SEEK_CUR)                   = 0
read(3, "#!/bin/bash\n# Network Interface "..., 80) = 80
lseek(3, 0, SEEK_SET)                   = 0
getrlimit(RLIMIT_NOFILE, {rlim_cur=1024, rlim_max=1024}) = 0
dup2(3, 255)                            = 255
close(3)                                = 0
fcntl(255, F_SETFD, FD_CLOEXEC)         = 0
fcntl(255, F_GETFL)                     = 0x8000 (flags O_RDONLY|0x8000)
fstat(255, {st_mode=S_IFREG|0755, st_size=10160, ...}) = 0
lseek(255, 0, SEEK_CUR)                 = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
read(255, "#!/bin/bash\n# Network Interface "..., 8192) = 8192
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("/etc/init.d/functions", {st_mode=S_IFREG|0755, st_size=13913, ...}) = 0
access("/etc/init.d/functions", X_OK)   = 0
access("/etc/init.d/functions", R_OK)   = 0
open("/etc/init.d/functions", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0755, st_size=13913, ...}) = 0
read(3, "# -*-Shell-script-*-\n#\n# functio"..., 13913) = 13913
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
umask(022)                              = 022
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
clone2(Process 43694 attached (waiting for parent)
Process 43694 resumed (parent 43542 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43694
[pid 43694] close(255)                  = 0
[pid 43694] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43694] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43694] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43694] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43542] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 43694] rt_sigaction(SIGTTIN, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43542] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43694] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43542] close(4 <unfinished ...>
[pid 43694] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43542] <... close resumed> )       = 0
[pid 43694] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43542] read(3,  <unfinished ...>
[pid 43694] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43694] rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43694] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43694] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0}, {SIG_DFL}, 8) = 0
[pid 43694] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {SIG_DFL}, 8) = 0
[pid 43694] dup2(4, 1)                  = 1
[pid 43694] close(4)                    = 0
[pid 43694] close(3)                    = 0
[pid 43694] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43694] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43694] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43694] rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
[pid 43694] clone2(Process 43695 attached (waiting for parent)
Process 43695 resumed (parent 43694 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43695
[pid 43695] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43695] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43694] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43695] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43695] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43694] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43695] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43695] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43694] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43695] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43695] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43694] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43695] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43695] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43694] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43695] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43695] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43694] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43695] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43695] execve("/sbin/consoletype", ["/sbin/consoletype"...], [/* 19 vars */] <unfinished ...>
[pid 43694] rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
[pid 43695] <... execve resumed> )      = 0
[pid 43694] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 43695] brk(0 <unfinished ...>
[pid 43694] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43695] <... brk resumed> )         = 0x6000000000010000
[pid 43694] wait4(-1, Process 43694 suspended
 <unfinished ...>
[pid 43695] uname({sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43695] access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
[pid 43695] open("/etc/ld.so.cache", O_RDONLY) = 3
[pid 43695] fstat(3, {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43695] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2000000000050000
[pid 43695] close(3)                    = 0
[pid 43695] open("/lib/libc.so.6.1", O_RDONLY) = 3
[pid 43695] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43695] fstat(3, {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43695] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000060000
[pid 43695] mmap(0x20000000002d0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x20000000002d0000
[pid 43695] close(3)                    = 0
[pid 43695] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000002e0000
[pid 43695] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000002f0000
[pid 43695] munmap(0x2000000000050000, 55440) = 0
[pid 43695] fstat(0, {st_mode=S_IFCHR|0620, st_rdev=makedev(4, 64), ...}) = 0
[pid 43695] ioctl(0, TIOCLINUX, 0x600ffffffffbf9cf) = -1 EINVAL (Invalid argument)
[pid 43695] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43695] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 43695] write(1, "serial\n", 7 <unfinished ...>
[pid 43542] <... read resumed> "serial\n", 128) = 7
[pid 43542] read(3,  <unfinished ...>
[pid 43695] <... write resumed> )       = 7
[pid 43695] exit_group(1)               = ?
Process 43694 resumed
Process 43695 detached
[pid 43694] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 1}], 0, NULL) = 43695
[pid 43694] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43694] --- SIGCHLD (Child exited) @ a000000000010721 (aaaf) ---
[pid 43694] wait4(-1, 0x600fffffffc6e11c, WNOHANG, NULL) = -1 ECHILD (No child processes)
[pid 43694] rt_sigreturn()              = ? (mask now [HUP INT QUIT FPE PIPE ALRM TERM STKFLT CONT STOP TTIN XCPU PROF WINCH IO PWR SYS RT17 RT21 RT22])
[pid 43694] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {0x400000000015c560, [], 0}, 8) = 0
[pid 43694] exit_group(1)               = ?
Process 43694 detached
<... read resumed> "", 128)             = 0
--- SIGCHLD (Child exited) @ a000000000010721 (aaae) ---
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 1}], WNOHANG, NULL) = 43694
wait4(-1, 0x600fffffffc6e35c, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [])
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigaction(SIGINT, {0x400000000015c560, [], 0}, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("/etc/sysconfig/i18n", {st_mode=S_IFREG|0644, st_size=57, ...}) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
stat("/etc/profile.d/lang.sh", {st_mode=S_IFREG|0755, st_size=3154, ...}) = 0
access("/etc/profile.d/lang.sh", X_OK)  = 0
access("/etc/profile.d/lang.sh", R_OK)  = 0
open("/etc/profile.d/lang.sh", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0755, st_size=3154, ...}) = 0
read(3, "# /etc/profile.d/lang.sh - set i"..., 3154) = 3154
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("/etc/sysconfig/i18n", {st_mode=S_IFREG|0644, st_size=57, ...}) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
stat("/etc/sysconfig/i18n", {st_mode=S_IFREG|0644, st_size=57, ...}) = 0
access("/etc/sysconfig/i18n", X_OK)     = -1 EACCES (Permission denied)
access("/etc/sysconfig/i18n", R_OK)     = 0
open("/etc/sysconfig/i18n", O_RDONLY)   = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=57, ...}) = 0
read(3, "#LANG=\"ja_JP.UTF-8\"\nLANG=\"C\"\nSYS"..., 57) = 57
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("/root/.i18n", 0x600fffffffc6e6d8) = -1 ENOENT (No such file or directory)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
clone2(Process 43696 attached (waiting for parent)
Process 43696 resumed (parent 43542 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43696
[pid 43696] close(255)                  = 0
[pid 43696] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43696] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43696] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43696] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43696] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43542] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 43696] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43696] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43696] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43542] close(4 <unfinished ...>
[pid 43696] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 43696] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43542] read(3,  <unfinished ...>
[pid 43696] rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43696] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43696] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0}, {SIG_DFL}, 8) = 0
[pid 43696] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {SIG_DFL}, 8) = 0
[pid 43696] dup2(4, 1)                  = 1
[pid 43696] close(4)                    = 0
[pid 43696] close(3)                    = 0
[pid 43696] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43696] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43696] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43696] rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
[pid 43696] clone2(Process 43697 attached (waiting for parent)
Process 43697 resumed (parent 43696 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43697
[pid 43697] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43697] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43696] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43697] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43697] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43696] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43697] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43697] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43696] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43697] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43697] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43696] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43697] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43697] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43696] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43697] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43697] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43696] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43697] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43697] execve("/sbin/consoletype", ["/sbin/consoletype"...], [/* 19 vars */] <unfinished ...>
[pid 43696] rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
[pid 43696] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 43697] <... execve resumed> )      = 0
[pid 43696] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43697] brk(0)                      = 0x6000000000010000
[pid 43696] wait4(-1, Process 43696 suspended
 <unfinished ...>
[pid 43697] uname({sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43697] access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
[pid 43697] open("/etc/ld.so.cache", O_RDONLY) = 3
[pid 43697] fstat(3, {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43697] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2000000000050000
[pid 43697] close(3)                    = 0
[pid 43697] open("/lib/libc.so.6.1", O_RDONLY) = 3
[pid 43697] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43697] fstat(3, {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43697] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000060000
[pid 43697] mmap(0x20000000002d0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x20000000002d0000
[pid 43697] close(3)                    = 0
[pid 43697] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000002e0000
[pid 43697] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000002f0000
[pid 43697] munmap(0x2000000000050000, 55440) = 0
[pid 43697] fstat(0, {st_mode=S_IFCHR|0620, st_rdev=makedev(4, 64), ...}) = 0
[pid 43697] ioctl(0, TIOCLINUX, 0x600fffffffb3f9cf) = -1 EINVAL (Invalid argument)
[pid 43697] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43697] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 43697] write(1, "serial\n", 7 <unfinished ...>
[pid 43542] <... read resumed> "serial\n", 128) = 7
[pid 43542] read(3,  <unfinished ...>
[pid 43697] <... write resumed> )       = 7
[pid 43697] exit_group(1)               = ?
Process 43696 resumed
Process 43697 detached
[pid 43696] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 1}], 0, NULL) = 43697
[pid 43696] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43696] --- SIGCHLD (Child exited) @ a000000000010721 (aab1) ---
[pid 43696] wait4(-1, 0x600fffffffc6d68c, WNOHANG, NULL) = -1 ECHILD (No child processes)
[pid 43696] rt_sigreturn()              = ? (mask now [RT17 RT21 RT22])
[pid 43696] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {0x400000000015c560, [], 0}, 8) = 0
[pid 43696] exit_group(1)               = ?
Process 43696 detached
<... read resumed> "", 128)             = 0
--- SIGCHLD (Child exited) @ a000000000010721 (aab0) ---
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 1}], WNOHANG, NULL) = 43696
wait4(-1, 0x600fffffffc6d8cc, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [])
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigaction(SIGINT, {0x400000000015c560, [], 0}, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("/etc/sysconfig/init", {st_mode=S_IFREG|0644, st_size=1068, ...}) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
stat("/etc/sysconfig/init", {st_mode=S_IFREG|0644, st_size=1068, ...}) = 0
access("/etc/sysconfig/init", X_OK)     = -1 EACCES (Permission denied)
access("/etc/sysconfig/init", R_OK)     = 0
open("/etc/sysconfig/init", O_RDONLY)   = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=1068, ...}) = 0
read(3, "# color => new RH6.0 bootup\n# ve"..., 1068) = 1068
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
brk(0x6000000000090000)                 = 0x6000000000090000
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("/etc", {st_mode=S_IFDIR|0755, st_size=12288, ...}) = 0
stat("/etc/sysconfig", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
stat("/etc/sysconfig/network-scripts", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
chdir("/etc/sysconfig/network-scripts") = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("./network-functions", {st_mode=S_IFREG|0644, st_size=10392, ...}) = 0
access("./network-functions", X_OK)     = -1 EACCES (Permission denied)
access("./network-functions", R_OK)     = 0
open("./network-functions", O_RDONLY)   = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=10392, ...}) = 0
read(3, "# -*-Shell-script-*-\n#\n# This fi"..., 10392) = 10392
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("../network", {st_mode=S_IFREG|0644, st_size=73, ...}) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
stat("../network", {st_mode=S_IFREG|0644, st_size=73, ...}) = 0
access("../network", X_OK)              = -1 EACCES (Permission denied)
access("../network", R_OK)              = 0
open("../network", O_RDONLY)            = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=73, ...}) = 0
read(3, "NETWORKING=yes\nNETWORKING_IPV6=n"..., 73) = 73
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("ifcfg-ifcfg-eth7", 0x600fffffffc6ea68) = -1 ENOENT (No such file or directory)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("ifcfg-eth7", {st_mode=S_IFREG|0644, st_size=133, ...}) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
lseek(255, -7627, SEEK_CUR)             = 565
clone2(Process 43701 attached (waiting for parent)
Process 43701 resumed (parent 43542 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43701
[pid 43701] close(255)                  = 0
[pid 43701] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43701] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43701] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43701] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43701] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43542] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 43701] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43701] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43701] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43542] close(4 <unfinished ...>
[pid 43701] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 43701] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43542] read(3,  <unfinished ...>
[pid 43701] rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43701] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43701] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0}, {SIG_DFL}, 8) = 0
[pid 43701] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {SIG_DFL}, 8) = 0
[pid 43701] dup2(4, 1)                  = 1
[pid 43701] close(4)                    = 0
[pid 43701] close(3)                    = 0
[pid 43701] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43701] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43701] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43701] rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
[pid 43701] pipe([3, 4])                = 3
[pid 43701] rt_sigprocmask(SIG_BLOCK, [INT CHLD], [CHLD], 8) = 0
[pid 43701] clone2(Process 43702 attached (waiting for parent)
Process 43702 resumed (parent 43701 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43702
[pid 43702] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43702] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43701] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43702] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43702] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43701] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43702] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43702] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43701] close(4 <unfinished ...>
[pid 43702] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43701] <... close resumed> )       = 0
[pid 43702] close(3)                    = 0
[pid 43701] close(4 <unfinished ...>
[pid 43702] dup2(4, 1)                  = 1
[pid 43701] <... close resumed> )       = -1 EBADF (Bad file descriptor)
[pid 43702] close(4)                    = 0
[pid 43702] stat(".", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43702] stat("/sbin/basename", 0x600fffffffc6e3e0) = -1 ENOENT (No such file or directory)
[pid 43702] stat("/usr/sbin/basename", 0x600fffffffc6e3e0) = -1 ENOENT (No such file or directory)
[pid 43702] stat("/bin/basename", {st_mode=S_IFREG|0755, st_size=29472, ...}) = 0
[pid 43702] access("/bin/basename", X_OK) = 0
[pid 43702] access("/bin/basename", R_OK) = 0
[pid 43702] stat("/bin/basename", {st_mode=S_IFREG|0755, st_size=29472, ...}) = 0
[pid 43702] access("/bin/basename", X_OK) = 0
[pid 43702] access("/bin/basename", R_OK) = 0
[pid 43702] rt_sigaction(SIGINT, {SIG_DFL}, {0x200000000004adc0, [], 0}, 8) = 0
[pid 43702] rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43702] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43702] execve("/bin/basename", ["basename"..., "ifcfg-eth7"...], [/* 20 vars */] <unfinished ...>
[pid 43701] rt_sigprocmask(SIG_BLOCK, [INT CHLD], [CHLD], 8) = 0
[pid 43702] <... execve resumed> )      = 0
[pid 43701] clone2( <unfinished ...>
[pid 43702] brk(0)                      = 0x6000000000010000
[pid 43702] uname(Process 43703 attached (waiting for parent)
{sys="Linux", node="PQ-muneda", ...}) = 0
Process 43703 resumed (parent 43701 ready)
[pid 43701] <... clone2 resumed> child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43703
[pid 43702] access("/etc/ld.so.preload", R_OK <unfinished ...>
[pid 43703] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43702] <... access resumed> )      = -1 ENOENT (No such file or directory)
[pid 43701] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43703] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43703] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43702] open("/etc/ld.so.cache", O_RDONLY <unfinished ...>
[pid 43701] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43703] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43702] <... open resumed> )        = 3
[pid 43701] close(3 <unfinished ...>
[pid 43703] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43702] fstat(3,  <unfinished ...>
[pid 43701] <... close resumed> )       = 0
[pid 43703] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43702] <... fstat resumed> {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43701] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43703] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43702] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0 <unfinished ...>
[pid 43701] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43703] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43702] <... mmap resumed> )        = 0x2000000000050000
[pid 43701] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43703] dup2(3, 0 <unfinished ...>
[pid 43702] close(3 <unfinished ...>
[pid 43701] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43703] <... dup2 resumed> )        = 0
[pid 43702] <... close resumed> )       = 0
[pid 43701] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43703] close(3)                    = 0
[pid 43702] open("/lib/libc.so.6.1", O_RDONLY <unfinished ...>
[pid 43701] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43703] stat(".",  <unfinished ...>
[pid 43702] <... open resumed> )        = 3
[pid 43703] <... stat resumed> {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43702] read(3,  <unfinished ...>
[pid 43701] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 43703] stat("/sbin/sed",  <unfinished ...>
[pid 43702] <... read resumed> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43701] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43703] <... stat resumed> 0x600fffffffc6e3e0) = -1 ENOENT (No such file or directory)
[pid 43702] fstat(3,  <unfinished ...>
[pid 43701] wait4(-1, Process 43701 suspended
 <unfinished ...>
[pid 43703] stat("/usr/sbin/sed",  <unfinished ...>
[pid 43702] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43703] <... stat resumed> 0x600fffffffc6e3e0) = -1 ENOENT (No such file or directory)
[pid 43702] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0 <unfinished ...>
[pid 43703] stat("/bin/sed",  <unfinished ...>
[pid 43702] <... mmap resumed> )        = 0x2000000000060000
[pid 43703] <... stat resumed> {st_mode=S_IFREG|0755, st_size=104144, ...}) = 0
[pid 43702] mmap(0x20000000002d0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000 <unfinished ...>
[pid 43703] access("/bin/sed", X_OK <unfinished ...>
[pid 43702] <... mmap resumed> )        = 0x20000000002d0000
[pid 43703] <... access resumed> )      = 0
[pid 43702] close(3 <unfinished ...>
[pid 43703] access("/bin/sed", R_OK <unfinished ...>
[pid 43702] <... close resumed> )       = 0
[pid 43703] <... access resumed> )      = 0
[pid 43702] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43703] stat("/bin/sed",  <unfinished ...>
[pid 43702] <... mmap resumed> )        = 0x20000000002e0000
[pid 43703] <... stat resumed> {st_mode=S_IFREG|0755, st_size=104144, ...}) = 0
[pid 43702] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43703] access("/bin/sed", X_OK <unfinished ...>
[pid 43702] <... mmap resumed> )        = 0x20000000002f0000
[pid 43703] <... access resumed> )      = 0
[pid 43702] munmap(0x2000000000050000, 55440 <unfinished ...>
[pid 43703] access("/bin/sed", R_OK <unfinished ...>
[pid 43702] <... munmap resumed> )      = 0
[pid 43703] <... access resumed> )      = 0
[pid 43702] brk(0 <unfinished ...>
[pid 43703] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43702] <... brk resumed> )         = 0x6000000000010000
[pid 43703] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43702] brk(0x6000000000040000 <unfinished ...>
[pid 43703] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43702] <... brk resumed> )         = 0x6000000000040000
[pid 43703] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43702] fstat(1,  <unfinished ...>
[pid 43703] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43702] <... fstat resumed> {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43703] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43702] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43703] execve("/bin/sed", ["sed"..., "s/^ifcfg-//g"...], [/* 20 vars */] <unfinished ...>
[pid 43702] <... mmap resumed> )        = 0x2000000000050000
[pid 43702] write(1, "ifcfg-eth7\n", 11) = 11
[pid 43702] close(1 <unfinished ...>
[pid 43703] <... execve resumed> )      = 0
[pid 43702] <... close resumed> )       = 0
[pid 43703] brk(0 <unfinished ...>
[pid 43702] munmap(0x2000000000050000, 65536 <unfinished ...>
[pid 43703] <... brk resumed> )         = 0x6000000000020000
[pid 43702] <... munmap resumed> )      = 0
[pid 43702] exit_group(0)               = ?
Process 43701 resumed
Process 43702 detached
[pid 43703] uname({sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43701] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43702
[pid 43703] access("/etc/ld.so.preload", R_OK <unfinished ...>
[pid 43701] wait4(-1, Process 43701 suspended
 <unfinished ...>
[pid 43703] <... access resumed> )      = -1 ENOENT (No such file or directory)
[pid 43703] open("/etc/ld.so.cache", O_RDONLY) = 3
[pid 43703] fstat(3, {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43703] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2000000000050000
[pid 43703] close(3)                    = 0
[pid 43703] open("/lib/libc.so.6.1", O_RDONLY) = 3
[pid 43703] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43703] fstat(3, {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43703] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000060000
[pid 43703] mmap(0x20000000002d0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x20000000002d0000
[pid 43703] close(3)                    = 0
[pid 43703] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000002e0000
[pid 43703] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000002f0000
[pid 43703] munmap(0x2000000000050000, 55440) = 0
[pid 43703] brk(0)                      = 0x6000000000020000
[pid 43703] brk(0x6000000000050000)     = 0x6000000000050000
[pid 43703] fstat(0, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43703] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 43703] read(0, "ifcfg-eth7\n", 65536) = 11
[pid 43703] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43703] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000300000
[pid 43703] read(0, "", 65536)          = 0
[pid 43703] write(1, "eth7\n", 5 <unfinished ...>
[pid 43542] <... read resumed> "eth7\n", 128) = 5
[pid 43542] read(3,  <unfinished ...>
[pid 43703] <... write resumed> )       = 5
[pid 43703] close(1)                    = 0
[pid 43703] munmap(0x2000000000300000, 65536) = 0
[pid 43703] close(2)                    = 0
[pid 43703] exit_group(0)               = ?
Process 43701 resumed
Process 43703 detached
[pid 43701] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43703
[pid 43701] rt_sigprocmask(SIG_SETMASK, [CHLD], NULL, 8) = 0
[pid 43701] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {0x400000000015c560, [], 0}, 8) = 0
[pid 43701] close(3)                    = -1 EBADF (Bad file descriptor)
[pid 43701] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43701] --- SIGCHLD (Child exited) @ a000000000010721 (aab6) ---
[pid 43701] wait4(-1, 0x600fffffffc6db2c, WNOHANG, NULL) = -1 ECHILD (No child processes)
[pid 43701] rt_sigreturn()              = ? (mask now [])
[pid 43701] exit_group(0)               = ?
Process 43701 detached
<... read resumed> "", 128)             = 0
--- SIGCHLD (Child exited) @ a000000000010721 (aab5) ---
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WNOHANG, NULL) = 43701
wait4(-1, 0x600fffffffc6dc6c, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [])
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigaction(SIGINT, {0x400000000015c560, [], 0}, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [CHLD], 8) = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [INT CHLD], 8) = 0
rt_sigprocmask(SIG_SETMASK, [INT CHLD], NULL, 8) = 0
clone2(Process 43835 attached
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43835
[pid 43835] close(255 <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43835] <... close resumed> )       = 0
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43542] close(4 <unfinished ...>
[pid 43835] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 43835] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43542] close(4)                    = -1 EBADF (Bad file descriptor)
[pid 43835] rt_sigaction(SIGTSTP, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43542] rt_sigprocmask(SIG_BLOCK, [INT CHLD],  <unfinished ...>
[pid 43835] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43835] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43542] clone2( <unfinished ...>
[pid 43835] rt_sigaction(SIGTTOU, {SIG_DFL}, {SIG_IGN}, 8) = 0
Process 43836 attached (waiting for parent)
[pid 43835] close(3Process 43836 resumed (parent 43542 ready)
 <unfinished ...>
[pid 43542] <... clone2 resumed> child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43836
[pid 43835] <... close resumed> )       = 0
[pid 43835] dup2(4, 1)                  = 1
[pid 43836] close(255 <unfinished ...>
[pid 43835] close(4 <unfinished ...>
[pid 43836] <... close resumed> )       = 0
[pid 43835] <... close resumed> )       = 0
[pid 43836] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43836] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43835] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43836] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43836] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43835] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43836] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43835] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43836] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43835] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43836] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43835] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43836] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43835] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43836] dup2(3, 0 <unfinished ...>
[pid 43835] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43836] <... dup2 resumed> )        = 0
[pid 43836] close(3 <unfinished ...>
[pid 43835] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43836] <... close resumed> )       = 0
[pid 43836] stat(".",  <unfinished ...>
[pid 43835] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43836] <... stat resumed> {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43835] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43836] stat("/sbin/grep",  <unfinished ...>
[pid 43835] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 43836] <... stat resumed> 0x600fffffffc6e590) = -1 ENOENT (No such file or directory)
[pid 43835] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43836] stat("/usr/sbin/grep",  <unfinished ...>
[pid 43835] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0},  <unfinished ...>
[pid 43836] <... stat resumed> 0x600fffffffc6e590) = -1 ENOENT (No such file or directory)
[pid 43835] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43836] stat("/bin/grep",  <unfinished ...>
[pid 43835] rt_sigprocmask(SIG_BLOCK, NULL,  <unfinished ...>
[pid 43836] <... stat resumed> {st_mode=S_IFREG|0755, st_size=174960, ...}) = 0
[pid 43835] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43836] access("/bin/grep", X_OK)   = 0
[pid 43835] fstat(1,  <unfinished ...>
[pid 43836] access("/bin/grep", R_OK)   = 0
[pid 43835] <... fstat resumed> {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43836] stat("/bin/grep",  <unfinished ...>
[pid 43835] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43836] <... stat resumed> {st_mode=S_IFREG|0755, st_size=174960, ...}) = 0
[pid 43542] close(3 <unfinished ...>
[pid 43836] access("/bin/grep", X_OK <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 43836] <... access resumed> )      = 0
[pid 43542] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43836] access("/bin/grep", R_OK <unfinished ...>
[pid 43835] <... mmap resumed> )        = 0x2000000000050000
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43836] <... access resumed> )      = 0
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43836] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43835] write(1, "ifcfg-eth7\n", 11 <unfinished ...>
[pid 43836] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43835] <... write resumed> )       = 11
[pid 43836] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43836] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43835] exit_group(0)               = ?
Process 43835 detached
[pid 43542] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43836] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43836] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43836] execve("/bin/grep", ["grep"..., "-q"..., "[^g]-"...], [/* 20 vars */] <unfinished ...>
[pid 43542] rt_sigaction(SIGINT, {0x400000000015c560, [], 0}, {SIG_DFL}, 8) = 0
[pid 43542] wait4(-1,  <unfinished ...>
[pid 43836] <... execve resumed> )      = 0
[pid 43542] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43835
[pid 43836] brk(0)                      = 0x6000000000010000
[pid 43542] wait4(-1, Process 43542 suspended
 <unfinished ...>
[pid 43836] uname({sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43836] access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
[pid 43836] open("/etc/ld.so.cache", O_RDONLY) = 3
[pid 43836] fstat(3, {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43836] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2000000000050000
[pid 43836] close(3)                    = 0
[pid 43836] open("/lib/libpcre.so.0", O_RDONLY) = 3
[pid 43836] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240!\0\0\0\0\0\0"..., 832) = 832
[pid 43836] fstat(3, {st_mode=S_IFREG|0755, st_size=193224, ...}) = 0
[pid 43836] mmap(NULL, 256616, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000060000
[pid 43836] mmap(0x2000000000090000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000) = 0x2000000000090000
[pid 43836] close(3)                    = 0
[pid 43836] open("/lib/libc.so.6.1", O_RDONLY) = 3
[pid 43836] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43836] fstat(3, {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43836] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x20000000000a0000
[pid 43836] mmap(0x2000000000310000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x2000000000310000
[pid 43836] close(3)                    = 0
[pid 43836] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000320000
[pid 43836] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000330000
[pid 43836] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000340000
[pid 43836] munmap(0x2000000000050000, 55440) = 0
[pid 43836] brk(0)                      = 0x6000000000010000
[pid 43836] brk(0x6000000000040000)     = 0x6000000000040000
[pid 43836] read(0, "ifcfg-eth7\n", 65536) = 11
[pid 43836] read(0, "", 65536)          = 0
[pid 43836] close(1)                    = 0
[pid 43836] exit_group(1)               = ?
Process 43542 resumed
Process 43836 detached
<... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 1}], 0, NULL) = 43836
rt_sigprocmask(SIG_SETMASK, [CHLD], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
close(3)                                = -1 EBADF (Bad file descriptor)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
--- SIGCHLD (Child exited) @ a000000000010721 (ab3b) ---
wait4(-1, 0x600fffffffc6dcdc, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [])
stat(".", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
stat("/sbin/ifcfg-eth7", 0x600fffffffc6e8f0) = -1 ENOENT (No such file or directory)
stat("/usr/sbin/ifcfg-eth7", 0x600fffffffc6e8f0) = -1 ENOENT (No such file or directory)
stat("/bin/ifcfg-eth7", 0x600fffffffc6e8f0) = -1 ENOENT (No such file or directory)
stat("/usr/bin/ifcfg-eth7", 0x600fffffffc6e8f0) = -1 ENOENT (No such file or directory)
open("ifcfg-eth7", O_RDONLY)            = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=133, ...}) = 0
read(3, "# Intel Corporation 82562ET/EZ/G"..., 133) = 133
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
access("keys-eth7", R_OK)               = -1 ENOENT (No such file or directory)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
clone2(Process 43837 attached
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43837
[pid 43542] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43837] close(255 <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43837] <... close resumed> )       = 0
[pid 43542] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 43837] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43837] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43542] close(4 <unfinished ...>
[pid 43837] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 43837] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43542] read(3,  <unfinished ...>
[pid 43837] rt_sigaction(SIGTTIN, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43837] rt_sigaction(SIGTTOU, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43837] rt_sigaction(SIGINT, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43837] rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43837] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43837] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0}, {SIG_DFL}, 8) = 0
[pid 43837] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {SIG_DFL}, 8) = 0
[pid 43837] dup2(4, 1)                  = 1
[pid 43837] close(4)                    = 0
[pid 43837] close(3)                    = 0
[pid 43837] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43837] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43837] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43837] rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
[pid 43837] pipe([3, 4])                = 3
[pid 43837] rt_sigprocmask(SIG_BLOCK, [INT CHLD], [CHLD], 8) = 0
[pid 43837] clone2(Process 43838 attached
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43838
[pid 43837] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43838] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43837] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43838] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43837] close(4 <unfinished ...>
[pid 43838] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43837] <... close resumed> )       = 0
[pid 43837] close(4 <unfinished ...>
[pid 43838] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43837] <... close resumed> )       = -1 EBADF (Bad file descriptor)
[pid 43838] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43837] rt_sigprocmask(SIG_BLOCK, [INT CHLD],  <unfinished ...>
[pid 43838] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43837] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43838] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43837] clone2( <unfinished ...>
[pid 43838] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43838] close(3Process 43839 attached (waiting for parent)
Process 43839 resumed (parent 43837 ready)
 <unfinished ...>
[pid 43837] <... clone2 resumed> child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43839
[pid 43838] <... close resumed> )       = 0
[pid 43838] dup2(4, 1 <unfinished ...>
[pid 43839] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43838] <... dup2 resumed> )        = 1
[pid 43839] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43838] close(4 <unfinished ...>
[pid 43839] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43838] <... close resumed> )       = 0
[pid 43839] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43839] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43838] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43839] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43838] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43839] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43838] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43837] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43839] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43838] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43837] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43839] dup2(3, 0 <unfinished ...>
[pid 43838] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43837] close(3 <unfinished ...>
[pid 43839] <... dup2 resumed> )        = 0
[pid 43838] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43837] <... close resumed> )       = 0
[pid 43839] close(3 <unfinished ...>
[pid 43838] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43837] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43839] <... close resumed> )       = 0
[pid 43838] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43837] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43839] stat(".",  <unfinished ...>
[pid 43838] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43837] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43839] <... stat resumed> {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43838] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43837] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43839] stat("/sbin/sed",  <unfinished ...>
[pid 43838] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 43837] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43839] <... stat resumed> 0x600fffffffc6e740) = -1 ENOENT (No such file or directory)
[pid 43838] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43837] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43839] stat("/usr/sbin/sed",  <unfinished ...>
[pid 43838] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0},  <unfinished ...>
[pid 43837] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 43839] <... stat resumed> 0x600fffffffc6e740) = -1 ENOENT (No such file or directory)
[pid 43838] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43837] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43839] stat("/bin/sed",  <unfinished ...>
[pid 43838] rt_sigprocmask(SIG_BLOCK, NULL,  <unfinished ...>
[pid 43837] wait4(-1, Process 43837 suspended
 <unfinished ...>
[pid 43839] <... stat resumed> {st_mode=S_IFREG|0755, st_size=104144, ...}) = 0
[pid 43838] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43839] access("/bin/sed", X_OK)    = 0
[pid 43838] fstat(1,  <unfinished ...>
[pid 43839] access("/bin/sed", R_OK)    = 0
[pid 43838] <... fstat resumed> {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43839] stat("/bin/sed", {st_mode=S_IFREG|0755, st_size=104144, ...}) = 0
[pid 43838] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43839] access("/bin/sed", X_OK <unfinished ...>
[pid 43838] <... mmap resumed> )        = 0x2000000000050000
[pid 43839] <... access resumed> )      = 0
[pid 43839] access("/bin/sed", R_OK <unfinished ...>
[pid 43838] write(1, "eth7\n", 5 <unfinished ...>
[pid 43839] <... access resumed> )      = 0
[pid 43839] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43838] <... write resumed> )       = 5
[pid 43839] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43838] exit_group(0)               = ?
Process 43837 resumed
Process 43838 detached
[pid 43839] rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43837] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43838
[pid 43839] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43837] wait4(-1, Process 43837 suspended
 <unfinished ...>
[pid 43839] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43839] execve("/bin/sed", ["sed"..., "s/[0-9]*$//"...], [/* 20 vars */]) = 0
[pid 43839] brk(0)                      = 0x6000000000020000
[pid 43839] uname({sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43839] access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
[pid 43839] open("/etc/ld.so.cache", O_RDONLY) = 3
[pid 43839] fstat(3, {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43839] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2000000000050000
[pid 43839] close(3)                    = 0
[pid 43839] open("/lib/libc.so.6.1", O_RDONLY) = 3
[pid 43839] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43839] fstat(3, {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43839] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000060000
[pid 43839] mmap(0x20000000002d0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x20000000002d0000
[pid 43839] close(3)                    = 0
[pid 43839] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000002e0000
[pid 43839] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000002f0000
[pid 43839] munmap(0x2000000000050000, 55440) = 0
[pid 43839] brk(0)                      = 0x6000000000020000
[pid 43839] brk(0x6000000000050000)     = 0x6000000000050000
[pid 43839] fstat(0, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43839] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 43839] read(0, "eth7\n", 65536)    = 5
[pid 43839] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43839] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000300000
[pid 43839] read(0, "", 65536)          = 0
[pid 43839] write(1, "eth\n", 4)        = 4
[pid 43839] close(1)                    = 0
[pid 43839] munmap(0x2000000000300000, 65536) = 0
[pid 43839] close(2)                    = 0
[pid 43839] exit_group(0)               = ?
Process 43837 resumed
Process 43839 detached
[pid 43542] <... read resumed> "eth\n", 128) = 4
[pid 43837] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43839
[pid 43542] read(3,  <unfinished ...>
[pid 43837] rt_sigprocmask(SIG_SETMASK, [CHLD], NULL, 8) = 0
[pid 43837] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {0x400000000015c560, [], 0}, 8) = 0
[pid 43837] close(3)                    = -1 EBADF (Bad file descriptor)
[pid 43837] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43837] --- SIGCHLD (Child exited) @ a000000000010721 (ab3e) ---
[pid 43837] wait4(-1, 0x600fffffffc6de8c, WNOHANG, NULL) = -1 ECHILD (No child processes)
[pid 43837] rt_sigreturn()              = ? (mask now [])
[pid 43837] exit_group(0)               = ?
Process 43837 detached
<... read resumed> "", 128)             = 0
--- SIGCHLD (Child exited) @ a000000000010721 (ab3d) ---
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WNOHANG, NULL) = 43837
wait4(-1, 0x600fffffffc6dfcc, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [])
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigaction(SIGINT, {0x400000000015c560, [], 0}, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
clone2(Process 43840 attached
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43840
[pid 43542] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43840] close(255 <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43840] <... close resumed> )       = 0
[pid 43542] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 43840] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43840] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43542] close(4 <unfinished ...>
[pid 43840] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 43542] read(3,  <unfinished ...>
[pid 43840] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43840] rt_sigaction(SIGTTIN, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43840] rt_sigaction(SIGTTOU, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43840] rt_sigaction(SIGINT, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43840] rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43840] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43840] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0}, {SIG_DFL}, 8) = 0
[pid 43840] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {SIG_DFL}, 8) = 0
[pid 43840] dup2(4, 1)                  = 1
[pid 43840] close(4)                    = 0
[pid 43840] close(3)                    = 0
[pid 43840] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43840] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43840] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43840] rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
[pid 43840] pipe([3, 4])                = 3
[pid 43840] rt_sigprocmask(SIG_BLOCK, [INT CHLD], [CHLD], 8) = 0
[pid 43840] clone2(Process 43841 attached
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43841
[pid 43840] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43841] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43840] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43841] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43840] close(4)                    = 0
[pid 43841] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43840] close(4)                    = -1 EBADF (Bad file descriptor)
[pid 43841] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43840] rt_sigprocmask(SIG_BLOCK, [INT CHLD],  <unfinished ...>
[pid 43841] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43840] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43841] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43840] clone2( <unfinished ...>
[pid 43841] rt_sigaction(SIGTTOU, {SIG_DFL}, Process 43842 attached (waiting for parent)
{SIG_DFL}, 8) = 0
Process 43842 resumed (parent 43840 ready)
[pid 43840] <... clone2 resumed> child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43842
[pid 43841] close(3)                    = 0
[pid 43842] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43841] dup2(4, 1 <unfinished ...>
[pid 43842] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43841] <... dup2 resumed> )        = 1
[pid 43842] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43840] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43841] close(4 <unfinished ...>
[pid 43842] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43841] <... close resumed> )       = 0
[pid 43842] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43841] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43842] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43841] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43842] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43841] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43842] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43841] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43842] dup2(3, 0 <unfinished ...>
[pid 43841] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43842] <... dup2 resumed> )        = 0
[pid 43841] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43842] close(3)                    = 0
[pid 43841] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43840] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43842] stat(".",  <unfinished ...>
[pid 43841] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43842] <... stat resumed> {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43841] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43842] stat("/sbin/awk",  <unfinished ...>
[pid 43840] close(3 <unfinished ...>
[pid 43841] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43842] <... stat resumed> 0x600fffffffc6ebc0) = -1 ENOENT (No such file or directory)
[pid 43840] <... close resumed> )       = 0
[pid 43842] stat("/usr/sbin/awk",  <unfinished ...>
[pid 43841] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 43840] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43842] <... stat resumed> 0x600fffffffc6ebc0) = -1 ENOENT (No such file or directory)
[pid 43841] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43842] stat("/bin/awk",  <unfinished ...>
[pid 43840] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43841] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0},  <unfinished ...>
[pid 43842] <... stat resumed> {st_mode=S_IFREG|0755, st_size=718168, ...}) = 0
[pid 43841] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43842] access("/bin/awk", X_OK <unfinished ...>
[pid 43840] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43842] <... access resumed> )      = 0
[pid 43841] rt_sigprocmask(SIG_BLOCK, NULL,  <unfinished ...>
[pid 43840] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43842] access("/bin/awk", R_OK <unfinished ...>
[pid 43841] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43842] <... access resumed> )      = 0
[pid 43840] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43842] stat("/bin/awk",  <unfinished ...>
[pid 43841] fstat(1,  <unfinished ...>
[pid 43840] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43842] <... stat resumed> {st_mode=S_IFREG|0755, st_size=718168, ...}) = 0
[pid 43841] <... fstat resumed> {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43840] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 43842] access("/bin/awk", X_OK <unfinished ...>
[pid 43840] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43841] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43842] <... access resumed> )      = 0
[pid 43840] wait4(-1, Process 43840 suspended
 <unfinished ...>
[pid 43842] access("/bin/awk", R_OK <unfinished ...>
[pid 43841] <... mmap resumed> )        = 0x2000000000050000
[pid 43842] <... access resumed> )      = 0
[pid 43842] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43841] write(1, "00:0b:5d:6e:00:10\n", 18 <unfinished ...>
[pid 43842] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43841] <... write resumed> )       = 18
[pid 43842] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43841] exit_group(0)               = ?
Process 43840 resumed
Process 43841 detached
[pid 43842] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43840] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43841
[pid 43842] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43840] wait4(-1, Process 43840 suspended
 <unfinished ...>
[pid 43842] execve("/bin/awk", ["awk"..., "{ print toupper($0) }"...], [/* 20 vars */]) = 0
[pid 43842] brk(0)                      = 0x6000000000020000
[pid 43842] uname({sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43842] access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
[pid 43842] open("/etc/ld.so.cache", O_RDONLY) = 3
[pid 43842] fstat(3, {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43842] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2000000000050000
[pid 43842] close(3)                    = 0
[pid 43842] open("/lib/libdl.so.2", O_RDONLY) = 3
[pid 43842] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\300\24\0\0\0\0\0\0"..., 832) = 832
[pid 43842] fstat(3, {st_mode=S_IFREG|0755, st_size=27088, ...}) = 0
[pid 43842] mmap(NULL, 84288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000060000
[pid 43842] mmap(0x2000000000070000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x2000000000070000
[pid 43842] close(3)                    = 0
[pid 43842] open("/lib/libm.so.6.1", O_RDONLY) = 3
[pid 43842] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\300L\0\0\0\0\0\0"..., 832) = 832
[pid 43842] fstat(3, {st_mode=S_IFREG|0755, st_size=897304, ...}) = 0
[pid 43842] mmap(NULL, 861216, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000080000
[pid 43842] mmap(0x2000000000150000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xc0000) = 0x2000000000150000
[pid 43842] close(3)                    = 0
[pid 43842] open("/lib/libc.so.6.1", O_RDONLY) = 3
[pid 43842] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43842] fstat(3, {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43842] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000160000
[pid 43842] mmap(0x20000000003d0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x20000000003d0000
[pid 43842] close(3)                    = 0
[pid 43842] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000003e0000
[pid 43842] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000003f0000
[pid 43842] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000400000
[pid 43842] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000410000
[pid 43842] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000420000
[pid 43842] munmap(0x2000000000050000, 55440) = 0
[pid 43842] brk(0)                      = 0x6000000000020000
[pid 43842] brk(0x6000000000050000)     = 0x6000000000050000
[pid 43842] rt_sigaction(SIGFPE, {0x40000000000a5430, [], SA_RESTART}, {SIG_DFL}, 8) = 0
[pid 43842] rt_sigaction(SIGSEGV, {0x40000000000a5430, [], SA_RESTART}, {SIG_DFL}, 8) = 0
[pid 43842] rt_sigaction(SIGBUS, {0x40000000000a5430, [], SA_RESTART}, {SIG_DFL}, 8) = 0
[pid 43842] fstat(0, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43842] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43842] fstat(2, {st_mode=S_IFCHR|0620, st_rdev=makedev(4, 64), ...}) = 0
[pid 43842] getgroups(0, NULL)          = 7
[pid 43842] getgroups(7, [0, 1, 2, 3, 4, 6, 10]) = 7
[pid 43842] ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, 0x600fffffffd8f880) = -1 EINVAL (Invalid argument)
[pid 43842] fstat(0, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43842] ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, 0x600fffffffd8f7e0) = -1 EINVAL (Invalid argument)
[pid 43842] fstat(0, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43842] read(0, "00:0b:5d:6e:00:10\n", 65536) = 18
[pid 43842] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43842] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 43842] read(0, "", 65536)          = 0
[pid 43842] write(1, "00:0B:5D:6E:00:10\n", 18) = 18
[pid 43542] <... read resumed> "00:0B:5D:6E:00:10\n", 128) = 18
[pid 43842] exit_group(0)               = ?
Process 43840 resumed
Process 43842 detached
[pid 43542] read(3,  <unfinished ...>
[pid 43840] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43842
[pid 43840] rt_sigprocmask(SIG_SETMASK, [CHLD], NULL, 8) = 0
[pid 43840] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {0x400000000015c560, [], 0}, 8) = 0
[pid 43840] close(3)                    = -1 EBADF (Bad file descriptor)
[pid 43840] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43840] --- SIGCHLD (Child exited) @ a000000000010721 (ab41) ---
[pid 43840] wait4(-1, 0x600fffffffc6e30c, WNOHANG, NULL) = -1 ECHILD (No child processes)
[pid 43840] rt_sigreturn()              = ? (mask now [])
[pid 43840] exit_group(0)               = ?
Process 43840 detached
<... read resumed> "", 128)             = 0
--- SIGCHLD (Child exited) @ a000000000010721 (ab40) ---
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WNOHANG, NULL) = 43840
wait4(-1, 0x600fffffffc6e44c, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [])
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigaction(SIGINT, {0x400000000015c560, [], 0}, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
read(255, "\n# Old BOOTP variable\nif [ \"${BO"..., 8192) = 8192
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [CHLD], 8) = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [INT CHLD], 8) = 0
rt_sigprocmask(SIG_SETMASK, [INT CHLD], NULL, 8) = 0
lseek(255, -7922, SEEK_CUR)             = 835
clone2(Process 43845 attached (waiting for parent)
Process 43845 resumed (parent 43542 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43845
[pid 43845] close(255)                  = 0
[pid 43845] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43845] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43845] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43845] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43845] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43542] close(4 <unfinished ...>
[pid 43845] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43845] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 43845] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43845] close(3 <unfinished ...>
[pid 43542] close(4 <unfinished ...>
[pid 43845] <... close resumed> )       = 0
[pid 43845] dup2(4, 1 <unfinished ...>
[pid 43542] <... close resumed> )       = -1 EBADF (Bad file descriptor)
[pid 43845] <... dup2 resumed> )        = 1
[pid 43845] close(4)                    = 0
[pid 43845] stat(".",  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_BLOCK, [INT CHLD],  <unfinished ...>
[pid 43845] <... stat resumed> {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43845] stat("/sbin/ip",  <unfinished ...>
[pid 43542] clone2( <unfinished ...>
[pid 43845] <... stat resumed> {st_mode=S_IFREG|0755, st_size=337272, ...}) = 0
Process 43846 attached (waiting for parent)
[pid 43845] access("/sbin/ip", X_OKProcess 43846 resumed (parent 43542 ready)
 <unfinished ...>
[pid 43542] <... clone2 resumed> child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43846
[pid 43845] <... access resumed> )      = 0
[pid 43846] close(255 <unfinished ...>
[pid 43845] access("/sbin/ip", R_OK <unfinished ...>
[pid 43846] <... close resumed> )       = 0
[pid 43845] <... access resumed> )      = 0
[pid 43846] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43845] stat("/sbin/ip",  <unfinished ...>
[pid 43846] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43845] <... stat resumed> {st_mode=S_IFREG|0755, st_size=337272, ...}) = 0
[pid 43846] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43845] access("/sbin/ip", X_OK <unfinished ...>
[pid 43846] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43845] <... access resumed> )      = 0
[pid 43846] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43845] access("/sbin/ip", R_OK <unfinished ...>
[pid 43846] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43845] <... access resumed> )      = 0
[pid 43846] rt_sigaction(SIGTTOU, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43845] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43846] dup2(3, 0 <unfinished ...>
[pid 43845] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43846] <... dup2 resumed> )        = 0
[pid 43846] close(3 <unfinished ...>
[pid 43845] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43846] <... close resumed> )       = 0
[pid 43846] stat(".",  <unfinished ...>
[pid 43845] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43846] <... stat resumed> {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43845] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43846] stat("/sbin/grep",  <unfinished ...>
[pid 43845] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43846] <... stat resumed> 0x600fffffffc6e8f0) = -1 ENOENT (No such file or directory)
[pid 43845] execve("/sbin/ip", ["ip"..., "-o"..., "link"...], [/* 21 vars */] <unfinished ...>
[pid 43846] stat("/usr/sbin/grep", 0x600fffffffc6e8f0) = -1 ENOENT (No such file or directory)
[pid 43846] stat("/bin/grep",  <unfinished ...>
[pid 43845] <... execve resumed> )      = 0
[pid 43846] <... stat resumed> {st_mode=S_IFREG|0755, st_size=174960, ...}) = 0
[pid 43846] access("/bin/grep", X_OK <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43846] <... access resumed> )      = 0
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43846] access("/bin/grep", R_OK <unfinished ...>
[pid 43542] close(3 <unfinished ...>
[pid 43846] <... access resumed> )      = 0
[pid 43542] <... close resumed> )       = 0
[pid 43846] stat("/bin/grep",  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43846] <... stat resumed> {st_mode=S_IFREG|0755, st_size=174960, ...}) = 0
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43846] access("/bin/grep", X_OK <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43846] <... access resumed> )      = 0
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43846] access("/bin/grep", R_OK <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43846] <... access resumed> )      = 0
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43846] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43542] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 43846] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43542] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43846] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43542] wait4(-1, Process 43542 suspended
 <unfinished ...>
[pid 43846] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43846] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43846] execve("/bin/grep", ["grep"..., "-q"..., "eth7"...], [/* 20 vars */] <unfinished ...>
[pid 43845] brk(0)                      = 0x6000000000020000
[pid 43846] <... execve resumed> )      = 0
[pid 43845] uname( <unfinished ...>
[pid 43846] brk(0 <unfinished ...>
[pid 43845] <... uname resumed> {sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43846] <... brk resumed> )         = 0x6000000000010000
[pid 43846] uname( <unfinished ...>
[pid 43845] access("/etc/ld.so.preload", R_OK <unfinished ...>
[pid 43846] <... uname resumed> {sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43845] <... access resumed> )      = -1 ENOENT (No such file or directory)
[pid 43846] access("/etc/ld.so.preload", R_OK <unfinished ...>
[pid 43845] open("/etc/ld.so.cache", O_RDONLY <unfinished ...>
[pid 43846] <... access resumed> )      = -1 ENOENT (No such file or directory)
[pid 43845] <... open resumed> )        = 3
[pid 43846] open("/etc/ld.so.cache", O_RDONLY <unfinished ...>
[pid 43845] fstat(3,  <unfinished ...>
[pid 43846] <... open resumed> )        = 3
[pid 43845] <... fstat resumed> {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43846] fstat(3,  <unfinished ...>
[pid 43845] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0 <unfinished ...>
[pid 43846] <... fstat resumed> {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43845] <... mmap resumed> )        = 0x2000000000050000
[pid 43846] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0 <unfinished ...>
[pid 43845] close(3 <unfinished ...>
[pid 43846] <... mmap resumed> )        = 0x2000000000050000
[pid 43845] <... close resumed> )       = 0
[pid 43846] close(3 <unfinished ...>
[pid 43845] open("/lib/libresolv.so.2", O_RDONLY <unfinished ...>
[pid 43846] <... close resumed> )       = 0
[pid 43845] <... open resumed> )        = 3
[pid 43846] open("/lib/libpcre.so.0", O_RDONLY <unfinished ...>
[pid 43845] read(3,  <unfinished ...>
[pid 43846] <... open resumed> )        = 3
[pid 43846] read(3,  <unfinished ...>
[pid 43845] <... read resumed> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240=\0\0\0\0\0\0"..., 832) = 832
[pid 43846] <... read resumed> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240!\0\0\0\0\0\0"..., 832) = 832
[pid 43845] fstat(3,  <unfinished ...>
[pid 43846] fstat(3,  <unfinished ...>
[pid 43845] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=152968, ...}) = 0
[pid 43846] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=193224, ...}) = 0
[pid 43845] mmap(NULL, 212640, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0 <unfinished ...>
[pid 43846] mmap(NULL, 256616, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0 <unfinished ...>
[pid 43845] <... mmap resumed> )        = 0x2000000000060000
[pid 43846] <... mmap resumed> )        = 0x2000000000060000
[pid 43845] mmap(0x2000000000090000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000 <unfinished ...>
[pid 43846] mmap(0x2000000000090000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000 <unfinished ...>
[pid 43845] <... mmap resumed> )        = 0x2000000000090000
[pid 43846] <... mmap resumed> )        = 0x2000000000090000
[pid 43845] close(3 <unfinished ...>
[pid 43846] close(3 <unfinished ...>
[pid 43845] <... close resumed> )       = 0
[pid 43846] <... close resumed> )       = 0
[pid 43845] open("/lib/libc.so.6.1", O_RDONLY <unfinished ...>
[pid 43846] open("/lib/libc.so.6.1", O_RDONLY <unfinished ...>
[pid 43845] <... open resumed> )        = 3
[pid 43846] <... open resumed> )        = 3
[pid 43845] read(3,  <unfinished ...>
[pid 43846] read(3,  <unfinished ...>
[pid 43845] <... read resumed> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43846] <... read resumed> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43845] fstat(3,  <unfinished ...>
[pid 43846] fstat(3,  <unfinished ...>
[pid 43845] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43846] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43845] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0 <unfinished ...>
[pid 43846] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0 <unfinished ...>
[pid 43845] <... mmap resumed> )        = 0x20000000000a0000
[pid 43846] <... mmap resumed> )        = 0x20000000000a0000
[pid 43845] mmap(0x2000000000310000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000 <unfinished ...>
[pid 43846] mmap(0x2000000000310000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000 <unfinished ...>
[pid 43845] <... mmap resumed> )        = 0x2000000000310000
[pid 43846] <... mmap resumed> )        = 0x2000000000310000
[pid 43845] close(3 <unfinished ...>
[pid 43846] close(3 <unfinished ...>
[pid 43845] <... close resumed> )       = 0
[pid 43846] <... close resumed> )       = 0
[pid 43845] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43846] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43845] <... mmap resumed> )        = 0x2000000000320000
[pid 43846] <... mmap resumed> )        = 0x2000000000320000
[pid 43845] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43846] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43845] <... mmap resumed> )        = 0x2000000000330000
[pid 43846] <... mmap resumed> )        = 0x2000000000330000
[pid 43846] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43845] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43846] <... mmap resumed> )        = 0x2000000000340000
[pid 43845] <... mmap resumed> )        = 0x2000000000340000
[pid 43846] munmap(0x2000000000050000, 55440) = 0
[pid 43845] munmap(0x2000000000050000, 55440) = 0
[pid 43846] brk(0 <unfinished ...>
[pid 43845] socket(PF_NETLINK, SOCK_RAW, 0) = 3
[pid 43845] setsockopt(3, SOL_SOCKET, SO_SNDBUF, [32768], 4 <unfinished ...>
[pid 43846] <... brk resumed> )         = 0x6000000000010000
[pid 43845] <... setsockopt resumed> )  = 0
[pid 43845] setsockopt(3, SOL_SOCKET, SO_RCVBUF, [32768], 4 <unfinished ...>
[pid 43846] brk(0x6000000000040000 <unfinished ...>
[pid 43845] <... setsockopt resumed> )  = 0
[pid 43845] bind(3, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 0
[pid 43846] <... brk resumed> )         = 0x6000000000040000
[pid 43845] getsockname(3, {sa_family=AF_NETLINK, pid=43845, groups=00000000}, [12]) = 0
[pid 43845] gettimeofday( <unfinished ...>
[pid 43846] read(0,  <unfinished ...>
[pid 43845] <... gettimeofday resumed> {1228368344, 71430}, NULL) = 0
[pid 43845] sendto(3, "\24\0\0\0\22\0\1\3\331i7I\0\0\0\0\21\0\0\0", 20, 0, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 20
[pid 43845] recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"\360\0\0\0\20\0\2\0\331i7IE\253\0\0\0\0\4\3\1\0\0\0I\0\1\0\0\0\0\0"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 1724
[pid 43845] brk(0)                      = 0x6000000000020000
[pid 43845] brk(0x6000000000050000)     = 0x6000000000050000
[pid 43845] recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"\24\0\0\0\3\0\2\0\331i7IE\253\0\0\0\0\0\0\1\0\0\0I\0\1\0\0\0\0\0"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 20
[pid 43845] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43845] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 43845] socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 4
[pid 43845] ioctl(4, SIOCGIFTXQLEN, {ifr_name="lo", ifr_qlen=0}) = 0
[pid 43845] close(4)                    = 0
[pid 43845] write(1, "1: lo: <LOOPBACK,UP,LOWER_UP> mt"..., 113) = 113
[pid 43845] socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 4
[pid 43845] ioctl(4, SIOCGIFTXQLEN, {ifr_name="eth3", ifr_qlen=1000}) = 0
[pid 43845] close(4)                    = 0
[pid 43845] write(1, "2: eth3: <BROADCAST,MULTICAST,UP"..., 134) = 134
[pid 43845] socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 4
[pid 43845] ioctl(4, SIOCGIFTXQLEN, {ifr_name="eth5", ifr_qlen=1000}) = 0
[pid 43845] close(4)                    = 0
[pid 43845] write(1, "3: eth5: <BROADCAST,MULTICAST,UP"..., 134) = 134
[pid 43845] socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 4
[pid 43845] ioctl(4, SIOCGIFTXQLEN, {ifr_name="eth", ifr_qlen=1000}) = 0
[pid 43845] close(4)                    = 0
[pid 43845] write(1, "4: eth: <BROADCAST,MULTICAST,UP,"..., 133) = 133
[pid 43845] socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 4
[pid 43845] ioctl(4, SIOCGIFTXQLEN, {ifr_name="eth2", ifr_qlen=1000}) = 0
[pid 43845] close(4)                    = 0
[pid 43845] write(1, "5: eth2: <BROADCAST,MULTICAST,UP"..., 134) = 134
[pid 43845] socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 4
[pid 43845] ioctl(4, SIOCGIFTXQLEN, {ifr_name="eth6", ifr_qlen=1000}) = 0
[pid 43845] close(4)                    = 0
[pid 43845] write(1, "6: eth6: <BROADCAST,MULTICAST,UP"..., 134) = 134
[pid 43845] socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 4
[pid 43845] ioctl(4, SIOCGIFTXQLEN, {ifr_name="eth7", ifr_qlen=1000}) = 0
[pid 43845] close(4)                    = 0
[pid 43845] write(1, "7: eth7: <BROADCAST,MULTICAST,UP"..., 134) = 134
[pid 43845] exit_group(0)               = ?
Process 43542 resumed
Process 43845 detached
[pid 43846] <... read resumed> "1: lo: <LOOPBACK,UP,LOWER_UP> mt"..., 65536) = 916
[pid 43542] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43845
[pid 43846] close(1)                    = 0
[pid 43542] wait4(-1, Process 43542 suspended
 <unfinished ...>
[pid 43846] exit_group(0)               = ?
Process 43542 resumed
Process 43846 detached
<... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43846
rt_sigprocmask(SIG_SETMASK, [CHLD], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
close(3)                                = -1 EBADF (Bad file descriptor)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
--- SIGCHLD (Child exited) @ a000000000010721 (ab45) ---
wait4(-1, 0x600fffffffc6e03c, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [])
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
read(255, "\n# remap, if the device is bound"..., 8192) = 8192
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
lseek(255, -7697, SEEK_CUR)             = 1330
clone2(Process 43847 attached (waiting for parent)
Process 43847 resumed (parent 43542 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43847
[pid 43847] close(255)                  = 0
[pid 43847] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43847] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43847] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43847] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43847] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43542] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 43847] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43847] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43847] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43847] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43542] close(4 <unfinished ...>
[pid 43847] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43847] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 43847] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43847] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43542] read(3,  <unfinished ...>
[pid 43847] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43847] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0}, {SIG_DFL}, 8) = 0
[pid 43847] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {SIG_DFL}, 8) = 0
[pid 43847] dup2(4, 1)                  = 1
[pid 43847] close(4)                    = 0
[pid 43847] close(3)                    = 0
[pid 43847] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43847] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43847] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43847] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43847] stat("/sys/class/net/eth7/address", {st_mode=S_IFREG|0444, st_size=65536, ...}) = 0
[pid 43847] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43847] stat(".", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43847] stat("/sbin/awk", 0x600fffffffc6ece0) = -1 ENOENT (No such file or directory)
[pid 43847] stat("/usr/sbin/awk", 0x600fffffffc6ece0) = -1 ENOENT (No such file or directory)
[pid 43847] stat("/bin/awk", {st_mode=S_IFREG|0755, st_size=718168, ...}) = 0
[pid 43847] access("/bin/awk", X_OK)    = 0
[pid 43847] access("/bin/awk", R_OK)    = 0
[pid 43847] stat("/bin/awk", {st_mode=S_IFREG|0755, st_size=718168, ...}) = 0
[pid 43847] access("/bin/awk", X_OK)    = 0
[pid 43847] access("/bin/awk", R_OK)    = 0
[pid 43847] rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
[pid 43847] clone2(Process 43848 attached (waiting for parent)
Process 43848 resumed (parent 43847 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43848
[pid 43848] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43848] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43847] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43848] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43848] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43847] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43848] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43848] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43847] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43848] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43848] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43847] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43848] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43848] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43847] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43848] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43848] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43847] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43848] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43848] open("/sys/class/net/eth7/address", O_RDONLY <unfinished ...>
[pid 43847] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43848] <... open resumed> )        = 3
[pid 43848] dup2(3, 0 <unfinished ...>
[pid 43847] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43848] <... dup2 resumed> )        = 0
[pid 43848] close(3 <unfinished ...>
[pid 43847] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 43848] <... close resumed> )       = 0
[pid 43848] execve("/bin/awk", ["awk"..., "{ print toupper($0) }"...], [/* 20 vars */] <unfinished ...>
[pid 43847] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43847] wait4(-1, Process 43847 suspended
 <unfinished ...>
[pid 43848] <... execve resumed> )      = 0
[pid 43848] brk(0)                      = 0x6000000000020000
[pid 43848] uname({sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43848] access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
[pid 43848] open("/etc/ld.so.cache", O_RDONLY) = 3
[pid 43848] fstat(3, {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43848] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2000000000050000
[pid 43848] close(3)                    = 0
[pid 43848] open("/lib/libdl.so.2", O_RDONLY) = 3
[pid 43848] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\300\24\0\0\0\0\0\0"..., 832) = 832
[pid 43848] fstat(3, {st_mode=S_IFREG|0755, st_size=27088, ...}) = 0
[pid 43848] mmap(NULL, 84288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000060000
[pid 43848] mmap(0x2000000000070000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x2000000000070000
[pid 43848] close(3)                    = 0
[pid 43848] open("/lib/libm.so.6.1", O_RDONLY) = 3
[pid 43848] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\300L\0\0\0\0\0\0"..., 832) = 832
[pid 43848] fstat(3, {st_mode=S_IFREG|0755, st_size=897304, ...}) = 0
[pid 43848] mmap(NULL, 861216, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000080000
[pid 43848] mmap(0x2000000000150000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xc0000) = 0x2000000000150000
[pid 43848] close(3)                    = 0
[pid 43848] open("/lib/libc.so.6.1", O_RDONLY) = 3
[pid 43848] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43848] fstat(3, {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43848] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000160000
[pid 43848] mmap(0x20000000003d0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x20000000003d0000
[pid 43848] close(3)                    = 0
[pid 43848] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000003e0000
[pid 43848] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000003f0000
[pid 43848] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000400000
[pid 43848] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000410000
[pid 43848] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000420000
[pid 43848] munmap(0x2000000000050000, 55440) = 0
[pid 43848] brk(0)                      = 0x6000000000020000
[pid 43848] brk(0x6000000000050000)     = 0x6000000000050000
[pid 43848] rt_sigaction(SIGFPE, {0x40000000000a5430, [], SA_RESTART}, {SIG_DFL}, 8) = 0
[pid 43848] rt_sigaction(SIGSEGV, {0x40000000000a5430, [], SA_RESTART}, {SIG_DFL}, 8) = 0
[pid 43848] rt_sigaction(SIGBUS, {0x40000000000a5430, [], SA_RESTART}, {SIG_DFL}, 8) = 0
[pid 43848] fstat(0, {st_mode=S_IFREG|0444, st_size=65536, ...}) = 0
[pid 43848] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43848] fstat(2, {st_mode=S_IFCHR|0620, st_rdev=makedev(4, 64), ...}) = 0
[pid 43848] getgroups(0, NULL)          = 7
[pid 43848] getgroups(7, [0, 1, 2, 3, 4, 6, 10]) = 7
[pid 43848] ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, 0x600fffffff88f880) = -1 EINVAL (Invalid argument)
[pid 43848] fstat(0, {st_mode=S_IFREG|0444, st_size=65536, ...}) = 0
[pid 43848] ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, 0x600fffffff88f7e0) = -1 ENOTTY (Inappropriate ioctl for device)
[pid 43848] fstat(0, {st_mode=S_IFREG|0444, st_size=65536, ...}) = 0
[pid 43848] read(0, "00:0b:5d:6e:00:10\n", 65536) = 18
[pid 43848] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43848] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 43848] read(0, "", 65536)          = 0
[pid 43848] write(1, "00:0B:5D:6E:00:10\n", 18) = 18
[pid 43542] <... read resumed> "00:0B:5D:6E:00:10\n", 128) = 18
[pid 43848] exit_group(0)               = ?
Process 43847 resumed
Process 43848 detached
[pid 43542] read(3,  <unfinished ...>
[pid 43847] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43848
[pid 43847] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43847] --- SIGCHLD (Child exited) @ a000000000010721 (ab48) ---
[pid 43847] wait4(-1, 0x600fffffffc6e20c, WNOHANG, NULL) = -1 ECHILD (No child processes)
[pid 43847] rt_sigreturn()              = ? (mask now [RT21 RT22])
[pid 43847] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {0x400000000015c560, [], 0}, 8) = 0
[pid 43847] exit_group(0)               = ?
Process 43847 detached
<... read resumed> "", 128)             = 0
--- SIGCHLD (Child exited) @ a000000000010721 (ab47) ---
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WNOHANG, NULL) = 43847
wait4(-1, 0x600fffffffc6e7fc, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [])
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigaction(SIGINT, {0x400000000015c560, [], 0}, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
read(255, "\nif [ \"${TYPE}\" = \"Bridge\" ]; th"..., 8192) = 8192
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [CHLD], 8) = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [INT CHLD], 8) = 0
rt_sigprocmask(SIG_SETMASK, [INT CHLD], NULL, 8) = 0
lseek(255, -7140, SEEK_CUR)             = 2382
clone2(Process 43849 attached (waiting for parent)
Process 43849 resumed (parent 43542 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43849
[pid 43849] close(255)                  = 0
[pid 43849] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43849] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43849] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43849] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43542] close(4 <unfinished ...>
[pid 43849] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 43849] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43849] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43542] close(4 <unfinished ...>
[pid 43849] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43849] close(3 <unfinished ...>
[pid 43542] <... close resumed> )       = -1 EBADF (Bad file descriptor)
[pid 43849] <... close resumed> )       = 0
[pid 43849] dup2(4, 1)                  = 1
[pid 43542] rt_sigprocmask(SIG_BLOCK, [INT CHLD],  <unfinished ...>
[pid 43849] close(4)                    = 0
[pid 43849] stat(".",  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43849] <... stat resumed> {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43849] stat("/sbin/ip",  <unfinished ...>
[pid 43542] clone2( <unfinished ...>
[pid 43849] <... stat resumed> {st_mode=S_IFREG|0755, st_size=337272, ...}) = 0
[pid 43849] access("/sbin/ip", X_OKProcess 43850 attached (waiting for parent)
)    = 0
Process 43850 resumed (parent 43542 ready)
[pid 43542] <... clone2 resumed> child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43850
[pid 43849] access("/sbin/ip", R_OK <unfinished ...>
[pid 43850] close(255 <unfinished ...>
[pid 43849] <... access resumed> )      = 0
[pid 43850] <... close resumed> )       = 0
[pid 43849] stat("/sbin/ip",  <unfinished ...>
[pid 43850] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43849] <... stat resumed> {st_mode=S_IFREG|0755, st_size=337272, ...}) = 0
[pid 43850] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43849] access("/sbin/ip", X_OK <unfinished ...>
[pid 43850] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43849] <... access resumed> )      = 0
[pid 43850] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43849] access("/sbin/ip", R_OK <unfinished ...>
[pid 43850] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43849] <... access resumed> )      = 0
[pid 43850] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43849] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43850] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43849] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43850] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43849] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43850] dup2(3, 0 <unfinished ...>
[pid 43849] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43850] <... dup2 resumed> )        = 0
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43850] close(3 <unfinished ...>
[pid 43542] close(3 <unfinished ...>
[pid 43850] <... close resumed> )       = 0
[pid 43542] <... close resumed> )       = 0
[pid 43850] stat(".",  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43850] <... stat resumed> {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43850] stat("/sbin/grep",  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43850] <... stat resumed> 0x600fffffffc6e7d0) = -1 ENOENT (No such file or directory)
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43850] stat("/usr/sbin/grep",  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43850] <... stat resumed> 0x600fffffffc6e7d0) = -1 ENOENT (No such file or directory)
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43850] stat("/bin/grep",  <unfinished ...>
[pid 43542] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 43850] <... stat resumed> {st_mode=S_IFREG|0755, st_size=174960, ...}) = 0
[pid 43542] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43850] access("/bin/grep", X_OK)   = 0
[pid 43542] wait4(-1, Process 43542 suspended
 <unfinished ...>
[pid 43850] access("/bin/grep", R_OK <unfinished ...>
[pid 43849] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43850] <... access resumed> )      = 0
[pid 43849] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43850] stat("/bin/grep",  <unfinished ...>
[pid 43849] execve("/sbin/ip", ["ip"..., "-o"..., "link"...], [/* 21 vars */] <unfinished ...>
[pid 43850] <... stat resumed> {st_mode=S_IFREG|0755, st_size=174960, ...}) = 0
[pid 43850] access("/bin/grep", X_OK)   = 0
[pid 43850] access("/bin/grep", R_OK)   = 0
[pid 43849] <... execve resumed> )      = 0
[pid 43850] rt_sigaction(SIGINT, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43849] brk(0)                      = 0x6000000000020000
[pid 43850] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43849] uname( <unfinished ...>
[pid 43850] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43849] <... uname resumed> {sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43850] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43849] access("/etc/ld.so.preload", R_OK <unfinished ...>
[pid 43850] execve("/bin/grep", ["grep"..., "-q"..., "eth7"...], [/* 20 vars */] <unfinished ...>
[pid 43849] <... access resumed> )      = -1 ENOENT (No such file or directory)
[pid 43849] open("/etc/ld.so.cache", O_RDONLY <unfinished ...>
[pid 43850] <... execve resumed> )      = 0
[pid 43849] <... open resumed> )        = 3
[pid 43850] brk(0 <unfinished ...>
[pid 43849] fstat(3,  <unfinished ...>
[pid 43850] <... brk resumed> )         = 0x6000000000010000
[pid 43850] uname( <unfinished ...>
[pid 43849] <... fstat resumed> {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43850] <... uname resumed> {sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43850] access("/etc/ld.so.preload", R_OK <unfinished ...>
[pid 43849] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0 <unfinished ...>
[pid 43850] <... access resumed> )      = -1 ENOENT (No such file or directory)
[pid 43850] open("/etc/ld.so.cache", O_RDONLY <unfinished ...>
[pid 43849] <... mmap resumed> )        = 0x2000000000050000
[pid 43850] <... open resumed> )        = 3
[pid 43849] close(3 <unfinished ...>
[pid 43850] fstat(3,  <unfinished ...>
[pid 43849] <... close resumed> )       = 0
[pid 43849] open("/lib/libresolv.so.2", O_RDONLY <unfinished ...>
[pid 43850] <... fstat resumed> {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43849] <... open resumed> )        = 3
[pid 43850] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0 <unfinished ...>
[pid 43849] read(3,  <unfinished ...>
[pid 43850] <... mmap resumed> )        = 0x2000000000050000
[pid 43849] <... read resumed> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240=\0\0\0\0\0\0"..., 832) = 832
[pid 43850] close(3 <unfinished ...>
[pid 43849] fstat(3,  <unfinished ...>
[pid 43850] <... close resumed> )       = 0
[pid 43849] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=152968, ...}) = 0
[pid 43850] open("/lib/libpcre.so.0", O_RDONLY) = 3
[pid 43849] mmap(NULL, 212640, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0 <unfinished ...>
[pid 43850] read(3,  <unfinished ...>
[pid 43849] <... mmap resumed> )        = 0x2000000000060000
[pid 43850] <... read resumed> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240!\0\0\0\0\0\0"..., 832) = 832
[pid 43849] mmap(0x2000000000090000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000 <unfinished ...>
[pid 43850] fstat(3,  <unfinished ...>
[pid 43849] <... mmap resumed> )        = 0x2000000000090000
[pid 43850] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=193224, ...}) = 0
[pid 43849] close(3 <unfinished ...>
[pid 43850] mmap(NULL, 256616, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0 <unfinished ...>
[pid 43849] <... close resumed> )       = 0
[pid 43850] <... mmap resumed> )        = 0x2000000000060000
[pid 43849] open("/lib/libc.so.6.1", O_RDONLY <unfinished ...>
[pid 43850] mmap(0x2000000000090000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000) = 0x2000000000090000
[pid 43849] <... open resumed> )        = 3
[pid 43850] close(3 <unfinished ...>
[pid 43849] read(3,  <unfinished ...>
[pid 43850] <... close resumed> )       = 0
[pid 43849] <... read resumed> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43850] open("/lib/libc.so.6.1", O_RDONLY <unfinished ...>
[pid 43849] fstat(3,  <unfinished ...>
[pid 43850] <... open resumed> )        = 3
[pid 43849] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43850] read(3,  <unfinished ...>
[pid 43849] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0 <unfinished ...>
[pid 43850] <... read resumed> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43849] <... mmap resumed> )        = 0x20000000000a0000
[pid 43850] fstat(3,  <unfinished ...>
[pid 43849] mmap(0x2000000000310000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000 <unfinished ...>
[pid 43850] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43849] <... mmap resumed> )        = 0x2000000000310000
[pid 43850] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0 <unfinished ...>
[pid 43849] close(3 <unfinished ...>
[pid 43850] <... mmap resumed> )        = 0x20000000000a0000
[pid 43849] <... close resumed> )       = 0
[pid 43850] mmap(0x2000000000310000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000 <unfinished ...>
[pid 43849] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43850] <... mmap resumed> )        = 0x2000000000310000
[pid 43849] <... mmap resumed> )        = 0x2000000000320000
[pid 43850] close(3)                    = 0
[pid 43849] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43850] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43849] <... mmap resumed> )        = 0x2000000000330000
[pid 43850] <... mmap resumed> )        = 0x2000000000320000
[pid 43850] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43849] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43850] <... mmap resumed> )        = 0x2000000000330000
[pid 43849] <... mmap resumed> )        = 0x2000000000340000
[pid 43850] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43849] munmap(0x2000000000050000, 55440) = 0
[pid 43850] <... mmap resumed> )        = 0x2000000000340000
[pid 43849] socket(PF_NETLINK, SOCK_RAW, 0) = 3
[pid 43850] munmap(0x2000000000050000, 55440 <unfinished ...>
[pid 43849] setsockopt(3, SOL_SOCKET, SO_SNDBUF, [32768], 4) = 0
[pid 43850] <... munmap resumed> )      = 0
[pid 43849] setsockopt(3, SOL_SOCKET, SO_RCVBUF, [32768], 4) = 0
[pid 43849] bind(3, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12 <unfinished ...>
[pid 43850] brk(0 <unfinished ...>
[pid 43849] <... bind resumed> )        = 0
[pid 43849] getsockname(3,  <unfinished ...>
[pid 43850] <... brk resumed> )         = 0x6000000000010000
[pid 43849] <... getsockname resumed> {sa_family=AF_NETLINK, pid=43849, groups=00000000}, [12]) = 0
[pid 43849] gettimeofday( <unfinished ...>
[pid 43850] brk(0x6000000000040000 <unfinished ...>
[pid 43849] <... gettimeofday resumed> {1228368348, 281999}, NULL) = 0
[pid 43849] sendto(3, "\24\0\0\0\22\0\1\3\335i7I\0\0\0\0\21\0\0\0", 20, 0, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12 <unfinished ...>
[pid 43850] <... brk resumed> )         = 0x6000000000040000
[pid 43849] <... sendto resumed> )      = 20
[pid 43849] recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"\360\0\0\0\20\0\2\0\335i7II\253\0\0\0\0\4\3\1\0\0\0I\0\1\0\0\0\0\0"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 1724
[pid 43850] read(0,  <unfinished ...>
[pid 43849] brk(0)                      = 0x6000000000020000
[pid 43849] brk(0x6000000000050000)     = 0x6000000000050000
[pid 43849] recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"\24\0\0\0\3\0\2\0\335i7II\253\0\0\0\0\0\0\1\0\0\0I\0\1\0\0\0\0\0"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 20
[pid 43849] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43849] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 43849] socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 4
[pid 43849] ioctl(4, SIOCGIFTXQLEN, {ifr_name="lo", ifr_qlen=0}) = 0
[pid 43849] close(4)                    = 0
[pid 43849] write(1, "1: lo: <LOOPBACK,UP,LOWER_UP> mt"..., 113) = 113
[pid 43850] <... read resumed> "1: lo: <LOOPBACK,UP,LOWER_UP> mt"..., 65536) = 113
[pid 43849] socket(PF_INET, SOCK_STREAM, IPPROTO_IP <unfinished ...>
[pid 43850] read(0,  <unfinished ...>
[pid 43849] <... socket resumed> )      = 4
[pid 43849] ioctl(4, SIOCGIFTXQLEN, {ifr_name="eth3", ifr_qlen=1000}) = 0
[pid 43849] close(4)                    = 0
[pid 43849] write(1, "2: eth3: <BROADCAST,MULTICAST,UP"..., 134) = 134
[pid 43850] <... read resumed> "2: eth3: <BROADCAST,MULTICAST,UP"..., 65536) = 134
[pid 43849] socket(PF_INET, SOCK_STREAM, IPPROTO_IP <unfinished ...>
[pid 43850] read(0,  <unfinished ...>
[pid 43849] <... socket resumed> )      = 4
[pid 43849] ioctl(4, SIOCGIFTXQLEN, {ifr_name="eth5", ifr_qlen=1000}) = 0
[pid 43849] close(4)                    = 0
[pid 43849] write(1, "3: eth5: <BROADCAST,MULTICAST,UP"..., 134) = 134
[pid 43850] <... read resumed> "3: eth5: <BROADCAST,MULTICAST,UP"..., 65536) = 134
[pid 43849] socket(PF_INET, SOCK_STREAM, IPPROTO_IP <unfinished ...>
[pid 43850] read(0,  <unfinished ...>
[pid 43849] <... socket resumed> )      = 4
[pid 43849] ioctl(4, SIOCGIFTXQLEN, {ifr_name="eth", ifr_qlen=1000}) = 0
[pid 43849] close(4)                    = 0
[pid 43849] write(1, "4: eth: <BROADCAST,MULTICAST,UP,"..., 133) = 133
[pid 43850] <... read resumed> "4: eth: <BROADCAST,MULTICAST,UP,"..., 65536) = 133
[pid 43849] socket(PF_INET, SOCK_STREAM, IPPROTO_IP <unfinished ...>
[pid 43850] read(0,  <unfinished ...>
[pid 43849] <... socket resumed> )      = 4
[pid 43849] ioctl(4, SIOCGIFTXQLEN, {ifr_name="eth2", ifr_qlen=1000}) = 0
[pid 43849] close(4)                    = 0
[pid 43849] write(1, "5: eth2: <BROADCAST,MULTICAST,UP"..., 134) = 134
[pid 43850] <... read resumed> "5: eth2: <BROADCAST,MULTICAST,UP"..., 65536) = 134
[pid 43849] socket(PF_INET, SOCK_STREAM, IPPROTO_IP <unfinished ...>
[pid 43850] read(0,  <unfinished ...>
[pid 43849] <... socket resumed> )      = 4
[pid 43849] ioctl(4, SIOCGIFTXQLEN, {ifr_name="eth6", ifr_qlen=1000}) = 0
[pid 43849] close(4)                    = 0
[pid 43849] write(1, "6: eth6: <BROADCAST,MULTICAST,UP"..., 134) = 134
[pid 43850] <... read resumed> "6: eth6: <BROADCAST,MULTICAST,UP"..., 65536) = 134
[pid 43849] socket(PF_INET, SOCK_STREAM, IPPROTO_IP <unfinished ...>
[pid 43850] read(0,  <unfinished ...>
[pid 43849] <... socket resumed> )      = 4
[pid 43849] ioctl(4, SIOCGIFTXQLEN, {ifr_name="eth7", ifr_qlen=1000}) = 0
[pid 43849] close(4)                    = 0
[pid 43849] write(1, "7: eth7: <BROADCAST,MULTICAST,UP"..., 134) = 134
[pid 43850] <... read resumed> "7: eth7: <BROADCAST,MULTICAST,UP"..., 65536) = 134
[pid 43849] exit_group(0)               = ?
Process 43542 resumed
Process 43849 detached
[pid 43850] close(1)                    = 0
[pid 43542] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43849
[pid 43850] exit_group(0)               = ?
Process 43850 detached
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43850
rt_sigprocmask(SIG_SETMASK, [CHLD], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
close(3)                                = -1 EBADF (Bad file descriptor)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
--- SIGCHLD (Child exited) @ a000000000010721 (ab49) ---
wait4(-1, 0x600fffffffc6df1c, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [BUS FPE USR1 SEGV TSTP RT30 RT31])
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
read(255, "\n# is the device wireless? If so"..., 8192) = 7778
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
access("/sbin/iwconfig", X_OK)          = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [CHLD], 8) = 0
lseek(255, -7658, SEEK_CUR)             = 2502
clone2(Process 43986 attached
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43986
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43986] close(255 <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43986] <... close resumed> )       = 0
[pid 43542] close(4 <unfinished ...>
[pid 43986] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 43986] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43542] close(4)                    = -1 EBADF (Bad file descriptor)
[pid 43986] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_BLOCK, [INT CHLD],  <unfinished ...>
[pid 43986] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43542] clone2( <unfinished ...>
[pid 43986] rt_sigaction(SIGTTIN, {SIG_DFL}, Process 43988 attached (waiting for parent)
{SIG_IGN}, 8) = 0
Process 43988 resumed (parent 43542 ready)
[pid 43542] <... clone2 resumed> child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43988
[pid 43986] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43988] close(255 <unfinished ...>
[pid 43986] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43988] <... close resumed> )       = 0
[pid 43986] close(3 <unfinished ...>
[pid 43988] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43986] <... close resumed> )       = 0
[pid 43988] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43988] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43986] dup2(4, 1 <unfinished ...>
[pid 43988] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43986] <... dup2 resumed> )        = 1
[pid 43988] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43986] close(4 <unfinished ...>
[pid 43988] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43986] <... close resumed> )       = 0
[pid 43988] rt_sigaction(SIGTTOU, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43986] stat(".",  <unfinished ...>
[pid 43988] dup2(3, 0 <unfinished ...>
[pid 43986] <... stat resumed> {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43988] <... dup2 resumed> )        = 0
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43988] close(3)                    = 0
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43988] stat(".",  <unfinished ...>
[pid 43542] close(3 <unfinished ...>
[pid 43988] <... stat resumed> {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43542] <... close resumed> )       = 0
[pid 43988] stat("/sbin/grep",  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43988] <... stat resumed> 0x600fffffffc6ed70) = -1 ENOENT (No such file or directory)
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43986] stat("/sbin/iwconfig",  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43988] stat("/usr/sbin/grep",  <unfinished ...>
[pid 43986] <... stat resumed> {st_mode=S_IFREG|0755, st_size=48432, ...}) = 0
[pid 43988] <... stat resumed> 0x600fffffffc6ed70) = -1 ENOENT (No such file or directory)
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43986] access("/sbin/iwconfig", X_OK <unfinished ...>
[pid 43988] stat("/bin/grep",  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43988] <... stat resumed> {st_mode=S_IFREG|0755, st_size=174960, ...}) = 0
[pid 43986] <... access resumed> )      = 0
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43988] access("/bin/grep", X_OK <unfinished ...>
[pid 43986] access("/sbin/iwconfig", R_OK <unfinished ...>
[pid 43542] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 43988] <... access resumed> )      = 0
[pid 43986] <... access resumed> )      = 0
[pid 43542] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43988] access("/bin/grep", R_OK <unfinished ...>
[pid 43986] stat("/sbin/iwconfig",  <unfinished ...>
[pid 43542] wait4(-1, Process 43542 suspended
 <unfinished ...>
[pid 43988] <... access resumed> )      = 0
[pid 43986] <... stat resumed> {st_mode=S_IFREG|0755, st_size=48432, ...}) = 0
[pid 43988] stat("/bin/grep",  <unfinished ...>
[pid 43986] access("/sbin/iwconfig", X_OK <unfinished ...>
[pid 43988] <... stat resumed> {st_mode=S_IFREG|0755, st_size=174960, ...}) = 0
[pid 43986] <... access resumed> )      = 0
[pid 43988] access("/bin/grep", X_OK <unfinished ...>
[pid 43986] access("/sbin/iwconfig", R_OK <unfinished ...>
[pid 43988] <... access resumed> )      = 0
[pid 43986] <... access resumed> )      = 0
[pid 43988] access("/bin/grep", R_OK <unfinished ...>
[pid 43986] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43988] <... access resumed> )      = 0
[pid 43986] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43986] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43988] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43986] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43988] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43986] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43988] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43986] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43988] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43986] dup2(1, 2 <unfinished ...>
[pid 43988] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43986] <... dup2 resumed> )        = 2
[pid 43988] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43986] fcntl(1, F_GETFD <unfinished ...>
[pid 43988] execve("/bin/grep", ["grep"..., "-q"..., "no wireless extensions"...], [/* 20 vars */] <unfinished ...>
[pid 43986] <... fcntl resumed> )       = 0
[pid 43986] execve("/sbin/iwconfig", ["iwconfig"..., "eth7"...], [/* 21 vars */] <unfinished ...>
[pid 43988] <... execve resumed> )      = 0
[pid 43986] <... execve resumed> )      = 0
[pid 43988] brk(0)                      = 0x6000000000010000
[pid 43986] brk(0 <unfinished ...>
[pid 43988] uname( <unfinished ...>
[pid 43986] <... brk resumed> )         = 0x6000000000010000
[pid 43988] <... uname resumed> {sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43986] uname( <unfinished ...>
[pid 43988] access("/etc/ld.so.preload", R_OK <unfinished ...>
[pid 43986] <... uname resumed> {sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43988] <... access resumed> )      = -1 ENOENT (No such file or directory)
[pid 43986] access("/etc/ld.so.preload", R_OK <unfinished ...>
[pid 43988] open("/etc/ld.so.cache", O_RDONLY <unfinished ...>
[pid 43986] <... access resumed> )      = -1 ENOENT (No such file or directory)
[pid 43988] <... open resumed> )        = 3
[pid 43986] open("/etc/ld.so.cache", O_RDONLY <unfinished ...>
[pid 43988] fstat(3,  <unfinished ...>
[pid 43986] <... open resumed> )        = 3
[pid 43988] <... fstat resumed> {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43986] fstat(3,  <unfinished ...>
[pid 43988] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0 <unfinished ...>
[pid 43986] <... fstat resumed> {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43988] <... mmap resumed> )        = 0x2000000000050000
[pid 43986] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0 <unfinished ...>
[pid 43988] close(3 <unfinished ...>
[pid 43986] <... mmap resumed> )        = 0x2000000000050000
[pid 43988] <... close resumed> )       = 0
[pid 43988] open("/lib/libpcre.so.0", O_RDONLY <unfinished ...>
[pid 43986] close(3 <unfinished ...>
[pid 43988] <... open resumed> )        = 3
[pid 43986] <... close resumed> )       = 0
[pid 43988] read(3,  <unfinished ...>
[pid 43986] open("/lib/libiw.so.28", O_RDONLY <unfinished ...>
[pid 43988] <... read resumed> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240!\0\0\0\0\0\0"..., 832) = 832
[pid 43986] <... open resumed> )        = 3
[pid 43986] read(3,  <unfinished ...>
[pid 43988] fstat(3,  <unfinished ...>
[pid 43986] <... read resumed> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\300\'\0\0\0\0\0\0"..., 832) = 832
[pid 43988] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=193224, ...}) = 0
[pid 43986] fstat(3,  <unfinished ...>
[pid 43988] mmap(NULL, 256616, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0 <unfinished ...>
[pid 43986] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=55368, ...}) = 0
[pid 43988] <... mmap resumed> )        = 0x2000000000060000
[pid 43986] mmap(NULL, 118760, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0 <unfinished ...>
[pid 43988] mmap(0x2000000000090000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000 <unfinished ...>
[pid 43986] <... mmap resumed> )        = 0x2000000000060000
[pid 43988] <... mmap resumed> )        = 0x2000000000090000
[pid 43986] mmap(0x2000000000070000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x2000000000070000
[pid 43988] close(3)                    = 0
[pid 43986] close(3)                    = 0
[pid 43988] open("/lib/libc.so.6.1", O_RDONLY <unfinished ...>
[pid 43986] open("/lib/libm.so.6.1", O_RDONLY <unfinished ...>
[pid 43988] <... open resumed> )        = 3
[pid 43986] <... open resumed> )        = 3
[pid 43988] read(3,  <unfinished ...>
[pid 43986] read(3,  <unfinished ...>
[pid 43988] <... read resumed> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43986] <... read resumed> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\300L\0\0\0\0\0\0"..., 832) = 832
[pid 43988] fstat(3,  <unfinished ...>
[pid 43986] fstat(3,  <unfinished ...>
[pid 43988] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43986] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=897304, ...}) = 0
[pid 43988] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0 <unfinished ...>
[pid 43986] mmap(NULL, 861216, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0 <unfinished ...>
[pid 43988] <... mmap resumed> )        = 0x20000000000a0000
[pid 43986] <... mmap resumed> )        = 0x2000000000080000
[pid 43988] mmap(0x2000000000310000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000 <unfinished ...>
[pid 43986] mmap(0x2000000000150000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xc0000 <unfinished ...>
[pid 43988] <... mmap resumed> )        = 0x2000000000310000
[pid 43986] <... mmap resumed> )        = 0x2000000000150000
[pid 43988] close(3 <unfinished ...>
[pid 43986] close(3 <unfinished ...>
[pid 43988] <... close resumed> )       = 0
[pid 43986] <... close resumed> )       = 0
[pid 43988] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43986] open("/lib/libc.so.6.1", O_RDONLY <unfinished ...>
[pid 43988] <... mmap resumed> )        = 0x2000000000320000
[pid 43986] <... open resumed> )        = 3
[pid 43988] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43986] read(3,  <unfinished ...>
[pid 43988] <... mmap resumed> )        = 0x2000000000330000
[pid 43986] <... read resumed> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43986] fstat(3,  <unfinished ...>
[pid 43988] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43986] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43988] <... mmap resumed> )        = 0x2000000000340000
[pid 43986] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0 <unfinished ...>
[pid 43988] munmap(0x2000000000050000, 55440 <unfinished ...>
[pid 43986] <... mmap resumed> )        = 0x2000000000160000
[pid 43988] <... munmap resumed> )      = 0
[pid 43986] mmap(0x20000000003d0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x20000000003d0000
[pid 43988] brk(0 <unfinished ...>
[pid 43986] close(3 <unfinished ...>
[pid 43988] <... brk resumed> )         = 0x6000000000010000
[pid 43986] <... close resumed> )       = 0
[pid 43988] brk(0x6000000000040000 <unfinished ...>
[pid 43986] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43988] <... brk resumed> )         = 0x6000000000040000
[pid 43986] <... mmap resumed> )        = 0x20000000003e0000
[pid 43988] read(0,  <unfinished ...>
[pid 43986] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000003f0000
[pid 43986] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000400000
[pid 43986] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000410000
[pid 43986] munmap(0x2000000000050000, 55440) = 0
[pid 43986] socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 3
[pid 43986] ioctl(3, SIOCGIWNAME, 0x600ffffffff8f218) = -1 EINVAL (Invalid argument)
[pid 43986] ioctl(3, SIOCGIFFLAGS, {ifr_name="eth7", ifr_flags=IFF_UP|IFF_BROADCAST|IFF_RUNNING|IFF_MULTICAST}) = 0
[pid 43986] write(2, "eth7      no wireless extensions"..., 35 <unfinished ...>
[pid 43988] <... read resumed> "eth7      no wireless extensions"..., 65536) = 35
[pid 43986] <... write resumed> )       = 35
[pid 43988] close(1 <unfinished ...>
[pid 43986] close(3 <unfinished ...>
[pid 43988] <... close resumed> )       = 0
[pid 43986] <... close resumed> )       = 0
[pid 43988] exit_group(0)               = ?
Process 43542 resumed
Process 43988 detached
[pid 43986] exit_group(0)               = ?
Process 43986 detached
<... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43988
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43986
rt_sigprocmask(SIG_SETMASK, [CHLD], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
close(3)                                = -1 EBADF (Bad file descriptor)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
--- SIGCHLD (Child exited) @ a000000000010721 (abd4) ---
wait4(-1, 0x600fffffffc6e4bc, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [])
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
read(255, "\nif [ -n \"${BRIDGE}\" -a -x /usr/"..., 8192) = 7658
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
access("/usr/sbin/brctl", X_OK)         = -1 ENOENT (No such file or directory)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("/sys/class/net/eth7/bonding/slaves", 0x600fffffffc6f128) = -1 ENOENT (No such file or directory)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
access("/sbin/dhclient", X_OK)          = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
access("/etc/dhclient-eth7.conf", W_OK) = -1 ENOENT (No such file or directory)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("/etc/dhclient-eth7.conf", 0x600fffffffc6eab8) = -1 ENOENT (No such file or directory)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("/dev/.dhclient-eth7.leases", 0x600fffffffc6ebd8) = -1 ENOENT (No such file or directory)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(4, 64), ...}) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B9600 opost isig icanon echo ...}) = 0
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
write(1, "\n", 1
)                       = 1
write(1, "Determining IP information for e"..., 38Determining IP information for eth7...) = 38
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
access("/sbin/mii-tool", X_OK)          = 0
access("/sbin/ethtool", X_OK)           = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [CHLD], 8) = 0
lseek(255, -684, SEEK_CUR)              = 9476
clone2(Process 43989 attached (waiting for parent)
Process 43989 resumed (parent 43542 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43989
[pid 43989] close(255 <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43989] <... close resumed> )       = 0
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43542] close(4 <unfinished ...>
[pid 43989] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 43989] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43542] close(4)                    = -1 EBADF (Bad file descriptor)
[pid 43989] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_BLOCK, [INT CHLD],  <unfinished ...>
[pid 43989] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43989] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43542] clone2( <unfinished ...>
[pid 43989] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43989] rt_sigaction(SIGTTOU, {SIG_DFL}, Process 43990 attached (waiting for parent)
Process 43990 resumed (parent 43542 ready)
 <unfinished ...>
[pid 43542] <... clone2 resumed> child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43990
[pid 43989] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43989] close(3)                    = 0
[pid 43990] close(255 <unfinished ...>
[pid 43989] dup2(4, 1 <unfinished ...>
[pid 43990] <... close resumed> )       = 0
[pid 43989] <... dup2 resumed> )        = 1
[pid 43990] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43989] close(4 <unfinished ...>
[pid 43990] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43989] <... close resumed> )       = 0
[pid 43990] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43990] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43989] stat(".",  <unfinished ...>
[pid 43990] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43542] close(3 <unfinished ...>
[pid 43989] <... stat resumed> {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43990] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43542] <... close resumed> )       = 0
[pid 43990] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43989] stat("/sbin/ip",  <unfinished ...>
[pid 43990] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43542] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43990] dup2(3, 0 <unfinished ...>
[pid 43989] <... stat resumed> {st_mode=S_IFREG|0755, st_size=337272, ...}) = 0
[pid 43990] <... dup2 resumed> )        = 0
[pid 43990] close(3 <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43989] access("/sbin/ip", X_OK <unfinished ...>
[pid 43990] <... close resumed> )       = 0
[pid 43989] <... access resumed> )      = 0
[pid 43990] stat(".",  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43989] access("/sbin/ip", R_OK <unfinished ...>
[pid 43990] <... stat resumed> {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43990] stat("/sbin/grep",  <unfinished ...>
[pid 43989] <... access resumed> )      = 0
[pid 43990] <... stat resumed> 0x600fffffffc6e350) = -1 ENOENT (No such file or directory)
[pid 43989] stat("/sbin/ip",  <unfinished ...>
[pid 43990] stat("/usr/sbin/grep",  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43989] <... stat resumed> {st_mode=S_IFREG|0755, st_size=337272, ...}) = 0
[pid 43990] <... stat resumed> 0x600fffffffc6e350) = -1 ENOENT (No such file or directory)
[pid 43989] access("/sbin/ip", X_OK <unfinished ...>
[pid 43990] stat("/bin/grep",  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43990] <... stat resumed> {st_mode=S_IFREG|0755, st_size=174960, ...}) = 0
[pid 43989] <... access resumed> )      = 0
[pid 43990] access("/bin/grep", X_OK <unfinished ...>
[pid 43989] access("/sbin/ip", R_OK <unfinished ...>
[pid 43542] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 43990] <... access resumed> )      = 0
[pid 43989] <... access resumed> )      = 0
[pid 43990] access("/bin/grep", R_OK)   = 0
[pid 43542] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43990] stat("/bin/grep",  <unfinished ...>
[pid 43989] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43990] <... stat resumed> {st_mode=S_IFREG|0755, st_size=174960, ...}) = 0
[pid 43989] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43990] access("/bin/grep", X_OK <unfinished ...>
[pid 43542] wait4(-1, Process 43542 suspended
 <unfinished ...>
[pid 43990] <... access resumed> )      = 0
[pid 43989] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43990] access("/bin/grep", R_OK)   = 0
[pid 43989] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43990] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43989] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43990] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43989] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43990] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43989] open("/dev/null", O_WRONLY|O_CREAT|O_TRUNC, 0666 <unfinished ...>
[pid 43990] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43989] <... open resumed> )        = 3
[pid 43990] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43989] dup2(3, 2)                  = 2
[pid 43990] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43989] close(3 <unfinished ...>
[pid 43990] execve("/bin/grep", ["grep"..., "-q"..., "UP"...], [/* 20 vars */] <unfinished ...>
[pid 43989] <... close resumed> )       = 0
[pid 43989] execve("/sbin/ip", ["ip"..., "link"..., "show"..., "dev"..., "eth7"...], [/* 21 vars */] <unfinished ...>
[pid 43990] <... execve resumed> )      = 0
[pid 43989] <... execve resumed> )      = 0
[pid 43990] brk(0)                      = 0x6000000000010000
[pid 43989] brk(0 <unfinished ...>
[pid 43990] uname( <unfinished ...>
[pid 43989] <... brk resumed> )         = 0x6000000000020000
[pid 43990] <... uname resumed> {sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43989] uname( <unfinished ...>
[pid 43990] access("/etc/ld.so.preload", R_OK <unfinished ...>
[pid 43989] <... uname resumed> {sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43990] <... access resumed> )      = -1 ENOENT (No such file or directory)
[pid 43989] access("/etc/ld.so.preload", R_OK <unfinished ...>
[pid 43990] open("/etc/ld.so.cache", O_RDONLY <unfinished ...>
[pid 43989] <... access resumed> )      = -1 ENOENT (No such file or directory)
[pid 43990] <... open resumed> )        = 3
[pid 43989] open("/etc/ld.so.cache", O_RDONLY <unfinished ...>
[pid 43990] fstat(3,  <unfinished ...>
[pid 43989] <... open resumed> )        = 3
[pid 43990] <... fstat resumed> {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43989] fstat(3,  <unfinished ...>
[pid 43990] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0 <unfinished ...>
[pid 43989] <... fstat resumed> {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43990] <... mmap resumed> )        = 0x2000000000050000
[pid 43989] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0 <unfinished ...>
[pid 43990] close(3 <unfinished ...>
[pid 43989] <... mmap resumed> )        = 0x2000000000050000
[pid 43990] <... close resumed> )       = 0
[pid 43989] close(3 <unfinished ...>
[pid 43990] open("/lib/libpcre.so.0", O_RDONLY <unfinished ...>
[pid 43989] <... close resumed> )       = 0
[pid 43990] <... open resumed> )        = 3
[pid 43990] read(3,  <unfinished ...>
[pid 43989] open("/lib/libresolv.so.2", O_RDONLY <unfinished ...>
[pid 43990] <... read resumed> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240!\0\0\0\0\0\0"..., 832) = 832
[pid 43989] <... open resumed> )        = 3
[pid 43990] fstat(3,  <unfinished ...>
[pid 43989] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240=\0\0\0\0\0\0"..., 832) = 832
[pid 43990] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=193224, ...}) = 0
[pid 43990] mmap(NULL, 256616, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0 <unfinished ...>
[pid 43989] fstat(3,  <unfinished ...>
[pid 43990] <... mmap resumed> )        = 0x2000000000060000
[pid 43989] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=152968, ...}) = 0
[pid 43990] mmap(0x2000000000090000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000 <unfinished ...>
[pid 43989] mmap(NULL, 212640, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0 <unfinished ...>
[pid 43990] <... mmap resumed> )        = 0x2000000000090000
[pid 43989] <... mmap resumed> )        = 0x2000000000060000
[pid 43990] close(3 <unfinished ...>
[pid 43989] mmap(0x2000000000090000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000 <unfinished ...>
[pid 43990] <... close resumed> )       = 0
[pid 43989] <... mmap resumed> )        = 0x2000000000090000
[pid 43990] open("/lib/libc.so.6.1", O_RDONLY <unfinished ...>
[pid 43989] close(3 <unfinished ...>
[pid 43990] <... open resumed> )        = 3
[pid 43989] <... close resumed> )       = 0
[pid 43990] read(3,  <unfinished ...>
[pid 43989] open("/lib/libc.so.6.1", O_RDONLY <unfinished ...>
[pid 43990] <... read resumed> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43989] <... open resumed> )        = 3
[pid 43990] fstat(3,  <unfinished ...>
[pid 43989] read(3,  <unfinished ...>
[pid 43990] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43989] <... read resumed> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43990] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x20000000000a0000
[pid 43989] fstat(3,  <unfinished ...>
[pid 43990] mmap(0x2000000000310000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000 <unfinished ...>
[pid 43989] <... fstat resumed> {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43990] <... mmap resumed> )        = 0x2000000000310000
[pid 43989] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0 <unfinished ...>
[pid 43990] close(3 <unfinished ...>
[pid 43989] <... mmap resumed> )        = 0x20000000000a0000
[pid 43990] <... close resumed> )       = 0
[pid 43989] mmap(0x2000000000310000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000 <unfinished ...>
[pid 43990] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43989] <... mmap resumed> )        = 0x2000000000310000
[pid 43990] <... mmap resumed> )        = 0x2000000000320000
[pid 43989] close(3 <unfinished ...>
[pid 43990] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43989] <... close resumed> )       = 0
[pid 43990] <... mmap resumed> )        = 0x2000000000330000
[pid 43989] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000320000
[pid 43990] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43989] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43990] <... mmap resumed> )        = 0x2000000000340000
[pid 43989] <... mmap resumed> )        = 0x2000000000330000
[pid 43990] munmap(0x2000000000050000, 55440 <unfinished ...>
[pid 43989] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 43990] <... munmap resumed> )      = 0
[pid 43989] <... mmap resumed> )        = 0x2000000000340000
[pid 43990] brk(0 <unfinished ...>
[pid 43989] munmap(0x2000000000050000, 55440 <unfinished ...>
[pid 43990] <... brk resumed> )         = 0x6000000000010000
[pid 43989] <... munmap resumed> )      = 0
[pid 43989] socket(PF_NETLINK, SOCK_RAW, 0 <unfinished ...>
[pid 43990] brk(0x6000000000040000 <unfinished ...>
[pid 43989] <... socket resumed> )      = 3
[pid 43989] setsockopt(3, SOL_SOCKET, SO_SNDBUF, [32768], 4) = 0
[pid 43990] <... brk resumed> )         = 0x6000000000040000
[pid 43989] setsockopt(3, SOL_SOCKET, SO_RCVBUF, [32768], 4) = 0
[pid 43989] bind(3, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 0
[pid 43990] read(0,  <unfinished ...>
[pid 43989] getsockname(3, {sa_family=AF_NETLINK, pid=43989, groups=00000000}, [12]) = 0
[pid 43989] gettimeofday({1228368348, 352578}, NULL) = 0
[pid 43989] sendto(3, "\24\0\0\0\22\0\1\3\335i7I\0\0\0\0\21\0\0\0", 20, 0, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 20
[pid 43989] recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"\360\0\0\0\20\0\2\0\335i7I\325\253\0\0\0\0\4\3\1\0\0\0I\0\1\0\0\0\0\0"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 1724
[pid 43989] brk(0)                      = 0x6000000000020000
[pid 43989] brk(0x6000000000050000)     = 0x6000000000050000
[pid 43989] recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"\24\0\0\0\3\0\2\0\335i7I\325\253\0\0\0\0\0\0\1\0\0\0I\0\1\0\0\0\0\0"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 20
[pid 43989] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43989] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 43989] socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 4
[pid 43989] ioctl(4, SIOCGIFTXQLEN, {ifr_name="eth7", ifr_qlen=1000}) = 0
[pid 43989] close(4)                    = 0
[pid 43989] write(1, "7: eth7: <BROADCAST,MULTICAST,UP"..., 134) = 134
[pid 43990] <... read resumed> "7: eth7: <BROADCAST,MULTICAST,UP"..., 65536) = 134
[pid 43989] exit_group(0)               = ?
Process 43542 resumed
Process 43989 detached
[pid 43990] close(1)                    = 0
[pid 43542] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43989
[pid 43990] exit_group(0)               = ?
Process 43990 detached
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43990
rt_sigprocmask(SIG_SETMASK, [CHLD], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
close(3)                                = -1 EBADF (Bad file descriptor)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
--- SIGCHLD (Child exited) @ a000000000010721 (abd5) ---
wait4(-1, 0x600fffffffc6da9c, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [])
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
access("/sbin/mii-tool", X_OK)          = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
clone2(Process 43991 attached
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43991
[pid 43542] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43542] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 43991] close(255 <unfinished ...>
[pid 43542] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43991] <... close resumed> )       = 0
[pid 43542] close(4 <unfinished ...>
[pid 43991] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 43991] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43542] read(3,  <unfinished ...>
[pid 43991] rt_sigaction(SIGTSTP, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43991] rt_sigaction(SIGTTIN, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43991] rt_sigaction(SIGTTOU, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43991] rt_sigaction(SIGINT, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43991] rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43991] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43991] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0}, {SIG_DFL}, 8) = 0
[pid 43991] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {SIG_DFL}, 8) = 0
[pid 43991] dup2(4, 1)                  = 1
[pid 43991] close(4)                    = 0
[pid 43991] close(3)                    = 0
[pid 43991] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43991] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43991] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 43991] stat(".", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43991] stat("/sbin/mii-tool", {st_mode=S_IFREG|0755, st_size=23536, ...}) = 0
[pid 43991] access("/sbin/mii-tool", X_OK) = 0
[pid 43991] access("/sbin/mii-tool", R_OK) = 0
[pid 43991] stat("/sbin/mii-tool", {st_mode=S_IFREG|0755, st_size=23536, ...}) = 0
[pid 43991] access("/sbin/mii-tool", X_OK) = 0
[pid 43991] access("/sbin/mii-tool", R_OK) = 0
[pid 43991] rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
[pid 43991] clone2(Process 43992 attached (waiting for parent)
Process 43992 resumed (parent 43991 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43992
[pid 43992] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43992] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43991] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43992] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43992] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43991] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43992] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43992] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43991] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43992] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43991] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43992] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43991] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43992] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43991] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43992] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43991] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43992] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43991] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43992] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43991] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 43992] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43991] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 43992] dup2(1, 2)                  = 2
[pid 43991] wait4(-1, Process 43991 suspended
 <unfinished ...>
[pid 43992] fcntl(1, F_GETFD)           = 0
[pid 43992] execve("/sbin/mii-tool", ["mii-tool"..., "eth7"...], [/* 21 vars */]) = 0
[pid 43992] brk(0)                      = 0x6000000000010000
[pid 43992] uname({sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43992] access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
[pid 43992] open("/etc/ld.so.cache", O_RDONLY) = 3
[pid 43992] fstat(3, {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43992] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2000000000050000
[pid 43992] close(3)                    = 0
[pid 43992] open("/lib/libselinux.so.1", O_RDONLY) = 3
[pid 43992] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0@V\0\0\0\0\0\0"..., 832) = 832
[pid 43992] fstat(3, {st_mode=S_IFREG|0755, st_size=165160, ...}) = 0
[pid 43992] mmap(NULL, 233064, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000060000
[pid 43992] mmap(0x2000000000090000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000) = 0x2000000000090000
[pid 43992] close(3)                    = 0
[pid 43992] open("/lib/libc.so.6.1", O_RDONLY) = 3
[pid 43992] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43992] fstat(3, {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43992] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x20000000000a0000
[pid 43992] mmap(0x2000000000310000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x2000000000310000
[pid 43992] close(3)                    = 0
[pid 43992] open("/lib/libdl.so.2", O_RDONLY) = 3
[pid 43992] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\300\24\0\0\0\0\0\0"..., 832) = 832
[pid 43992] fstat(3, {st_mode=S_IFREG|0755, st_size=27088, ...}) = 0
[pid 43992] mmap(NULL, 84288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000320000
[pid 43992] mmap(0x2000000000330000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x2000000000330000
[pid 43992] close(3)                    = 0
[pid 43992] open("/lib/libsepol.so.1", O_RDONLY) = 3
[pid 43992] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\340U\0\0\0\0\0\0"..., 832) = 832
[pid 43992] fstat(3, {st_mode=S_IFREG|0755, st_size=517600, ...}) = 0
[pid 43992] mmap(NULL, 623496, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000340000
[pid 43992] mmap(0x20000000003c0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x70000) = 0x20000000003c0000
[pid 43992] mmap(0x20000000003d0000, 33672, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x20000000003d0000
[pid 43992] close(3)                    = 0
[pid 43992] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000003e0000
[pid 43992] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000003f0000
[pid 43992] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000400000
[pid 43992] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000410000
[pid 43992] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000420000
[pid 43992] munmap(0x2000000000050000, 55440) = 0
[pid 43992] access("/etc/selinux/", F_OK) = 0
[pid 43992] brk(0)                      = 0x6000000000010000
[pid 43992] brk(0x6000000000040000)     = 0x6000000000040000
[pid 43992] open("/etc/selinux/config", O_RDONLY) = 3
[pid 43992] fstat(3, {st_mode=S_IFREG|0644, st_size=468, ...}) = 0
[pid 43992] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 43992] read(3, "# This file controls the state o"..., 4096) = 468
[pid 43992] read(3, "", 4096)           = 0
[pid 43992] close(3)                    = 0
[pid 43992] munmap(0x2000000000050000, 65536) = 0
[pid 43992] open("/proc/mounts", O_RDONLY) = 3
[pid 43992] fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
[pid 43992] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 43992] read(3, "rootfs / rootfs rw 0 0\n/dev/root"..., 1024) = 483
[pid 43992] read(3, "", 1024)           = 0
[pid 43992] close(3)                    = 0
[pid 43992] munmap(0x2000000000050000, 65536) = 0
[pid 43992] socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 3
[pid 43992] ioctl(3, SIOCGMIIPHY, 0x6000000000005328) = 0
[pid 43992] ioctl(3, SIOCGMIIREG, 0x6000000000005328) = 0
[pid 43992] ioctl(3, SIOCGMIIREG, 0x6000000000005328) = 0
[pid 43992] ioctl(3, SIOCGMIIREG, 0x6000000000005328) = 0
[pid 43992] ioctl(3, SIOCGMIIREG, 0x6000000000005328) = 0
[pid 43992] ioctl(3, SIOCGMIIREG, 0x6000000000005328) = 0
[pid 43992] ioctl(3, SIOCGMIIREG, 0x6000000000005328) = 0
[pid 43992] ioctl(3, SIOCGMIIREG, 0x6000000000005328) = 0
[pid 43992] ioctl(3, SIOCGMIIREG, 0x6000000000005328) = 0
[pid 43992] ioctl(3, SIOCGMIIREG, 0x6000000000005328) = 0
[pid 43992] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 43992] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 43992] write(1, "eth7: negotiated 100baseTx-FD fl"..., 52) = 52
[pid 43992] close(3)                    = 0
[pid 43992] exit_group(0)               = ?
Process 43991 resumed
Process 43992 detached
[pid 43542] <... read resumed> "eth7: negotiated 100baseTx-FD fl"..., 128) = 52
[pid 43991] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43992
[pid 43542] read(3,  <unfinished ...>
[pid 43991] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43991] --- SIGCHLD (Child exited) @ a000000000010721 (abd8) ---
[pid 43991] wait4(-1, 0x600fffffffc6cc5c, WNOHANG, NULL) = -1 ECHILD (No child processes)
[pid 43991] rt_sigreturn()              = ? (mask now [RT21 RT22])
[pid 43991] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {0x400000000015c560, [], 0}, 8) = 0
[pid 43991] exit_group(0)               = ?
Process 43991 detached
<... read resumed> "", 128)             = 0
--- SIGCHLD (Child exited) @ a000000000010721 (abd7) ---
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WNOHANG, NULL) = 43991
wait4(-1, 0x600fffffffc6ce9c, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [])
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigaction(SIGINT, {0x400000000015c560, [], 0}, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [CHLD], 8) = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [INT CHLD], 8) = 0
rt_sigprocmask(SIG_SETMASK, [INT CHLD], NULL, 8) = 0
clone2(Process 43993 attached
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43993
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43993] close(255 <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43993] <... close resumed> )       = 0
[pid 43542] close(4 <unfinished ...>
[pid 43993] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 43993] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43542] close(4)                    = -1 EBADF (Bad file descriptor)
[pid 43993] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_BLOCK, [INT CHLD],  <unfinished ...>
[pid 43993] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43993] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43542] clone2( <unfinished ...>
[pid 43993] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43993] rt_sigaction(SIGTTOU, {SIG_DFL}, Process 43994 attached
 <unfinished ...>
[pid 43542] <... clone2 resumed> child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 43994
[pid 43993] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43994] close(255 <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43994] <... close resumed> )       = 0
[pid 43993] close(3 <unfinished ...>
[pid 43542] close(3 <unfinished ...>
[pid 43994] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 43994] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43993] <... close resumed> )       = 0
[pid 43542] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43994] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43993] dup2(4, 1 <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 43994] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43993] <... dup2 resumed> )        = 1
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 43994] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43993] close(4 <unfinished ...>
[pid 43994] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43993] <... close resumed> )       = 0
[pid 43994] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_BLOCK, [CHLD], [CHLD], 8) = 0
[pid 43993] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43994] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43993] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43994] dup2(3, 0 <unfinished ...>
[pid 43993] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43994] <... dup2 resumed> )        = 0
[pid 43993] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 43994] close(3 <unfinished ...>
[pid 43993] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43994] <... close resumed> )       = 0
[pid 43993] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 43994] stat(".",  <unfinished ...>
[pid 43993] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 43994] <... stat resumed> {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 43993] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43542] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 43993] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43994] stat("/sbin/grep",  <unfinished ...>
[pid 43993] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 43542] wait4(-1, Process 43542 suspended
 <unfinished ...>
[pid 43994] <... stat resumed> 0x600fffffffc6d8e0) = -1 ENOENT (No such file or directory)
[pid 43993] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 43994] stat("/usr/sbin/grep",  <unfinished ...>
[pid 43993] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43994] <... stat resumed> 0x600fffffffc6d8e0) = -1 ENOENT (No such file or directory)
[pid 43993] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0},  <unfinished ...>
[pid 43994] stat("/bin/grep",  <unfinished ...>
[pid 43993] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43994] <... stat resumed> {st_mode=S_IFREG|0755, st_size=174960, ...}) = 0
[pid 43993] rt_sigprocmask(SIG_BLOCK, NULL,  <unfinished ...>
[pid 43994] access("/bin/grep", X_OK <unfinished ...>
[pid 43993] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43994] <... access resumed> )      = 0
[pid 43993] write(1, "eth7: negotiated 100baseTx-FD fl"..., 52 <unfinished ...>
[pid 43994] access("/bin/grep", R_OK <unfinished ...>
[pid 43993] <... write resumed> )       = 52
[pid 43994] <... access resumed> )      = 0
[pid 43994] stat("/bin/grep",  <unfinished ...>
[pid 43993] exit_group(0)               = ?
Process 43542 resumed
Process 43993 detached
[pid 43994] <... stat resumed> {st_mode=S_IFREG|0755, st_size=174960, ...}) = 0
[pid 43542] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43993
[pid 43994] access("/bin/grep", X_OK)   = 0
[pid 43542] wait4(-1, Process 43542 suspended
 <unfinished ...>
[pid 43994] access("/bin/grep", R_OK)   = 0
[pid 43994] rt_sigaction(SIGINT, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43994] rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43994] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43994] execve("/bin/grep", ["grep"..., "-q"..., "link ok"...], [/* 21 vars */]) = 0
[pid 43994] brk(0)                      = 0x6000000000010000
[pid 43994] uname({sys="Linux", node="PQ-muneda", ...}) = 0
[pid 43994] access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
[pid 43994] open("/etc/ld.so.cache", O_RDONLY) = 3
[pid 43994] fstat(3, {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 43994] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2000000000050000
[pid 43994] close(3)                    = 0
[pid 43994] open("/lib/libpcre.so.0", O_RDONLY) = 3
[pid 43994] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240!\0\0\0\0\0\0"..., 832) = 832
[pid 43994] fstat(3, {st_mode=S_IFREG|0755, st_size=193224, ...}) = 0
[pid 43994] mmap(NULL, 256616, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000060000
[pid 43994] mmap(0x2000000000090000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000) = 0x2000000000090000
[pid 43994] close(3)                    = 0
[pid 43994] open("/lib/libc.so.6.1", O_RDONLY) = 3
[pid 43994] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 43994] fstat(3, {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 43994] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x20000000000a0000
[pid 43994] mmap(0x2000000000310000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x2000000000310000
[pid 43994] close(3)                    = 0
[pid 43994] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000320000
[pid 43994] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000330000
[pid 43994] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000340000
[pid 43994] munmap(0x2000000000050000, 55440) = 0
[pid 43994] brk(0)                      = 0x6000000000010000
[pid 43994] brk(0x6000000000040000)     = 0x6000000000040000
[pid 43994] read(0, "eth7: negotiated 100baseTx-FD fl"..., 65536) = 52
[pid 43994] close(1)                    = 0
[pid 43994] exit_group(0)               = ?
Process 43542 resumed
Process 43994 detached
<... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 43994
rt_sigprocmask(SIG_SETMASK, [CHLD], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
close(3)                                = -1 EBADF (Bad file descriptor)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
--- SIGCHLD (Child exited) @ a000000000010721 (abd9) ---
wait4(-1, 0x600fffffffc6d02c, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [ILL TRAP ABRT USR1 CONT TSTP TTOU RT30])
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
access("/sbin/ethtool", X_OK)           = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
clone2(Process 44121 attached (waiting for parent)
Process 44121 resumed (parent 43542 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 44121
[pid 44121] close(255)                  = 0
[pid 44121] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43542] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 44121] rt_sigaction(SIGTSTP, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 44121] rt_sigaction(SIGTTIN, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43542] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 44121] rt_sigaction(SIGTTOU, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43542] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 44121] rt_sigaction(SIGINT, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43542] close(4 <unfinished ...>
[pid 44121] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 44121] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 44121] rt_sigaction(SIGCHLD, {SIG_DFL},  <unfinished ...>
[pid 43542] read(3,  <unfinished ...>
[pid 44121] <... rt_sigaction resumed> {0x400000000015c520, [], 0}, 8) = 0
[pid 44121] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0}, {SIG_DFL}, 8) = 0
[pid 44121] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0}, {SIG_DFL}, 8) = 0
[pid 44121] dup2(4, 1)                  = 1
[pid 44121] close(4)                    = 0
[pid 44121] close(3)                    = 0
[pid 44121] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 44121] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 44121] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid 44121] stat(".", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 44121] stat("/sbin/ethtool", {st_mode=S_IFREG|0755, st_size=182040, ...}) = 0
[pid 44121] access("/sbin/ethtool", X_OK) = 0
[pid 44121] access("/sbin/ethtool", R_OK) = 0
[pid 44121] stat("/sbin/ethtool", {st_mode=S_IFREG|0755, st_size=182040, ...}) = 0
[pid 44121] access("/sbin/ethtool", X_OK) = 0
[pid 44121] access("/sbin/ethtool", R_OK) = 0
[pid 44121] rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
[pid 44121] clone2(Process 44122 attached
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 44122
[pid 44122] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 44121] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 44122] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 44121] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 44122] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 44121] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 44122] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 44121] <... rt_sigprocmask resumed> [], 8) = 0
[pid 44122] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 44121] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 44122] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 44121] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 44122] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 44121] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 44122] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 44121] <... rt_sigprocmask resumed> [], 8) = 0
[pid 44122] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 44121] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 44122] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 44121] <... rt_sigaction resumed> {0x200000000004adc0, [], 0}, 8) = 0
[pid 44122] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 44121] wait4(-1, Process 44121 suspended
 <unfinished ...>
[pid 44122] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 44122] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 44122] dup2(1, 2)                  = 2
[pid 44122] fcntl(1, F_GETFD)           = 0
[pid 44122] execve("/sbin/ethtool", ["ethtool"..., "eth7"...], [/* 21 vars */]) = 0
[pid 44122] brk(0)                      = 0x6000000000010000
[pid 44122] uname({sys="Linux", node="PQ-muneda", ...}) = 0
[pid 44122] access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
[pid 44122] open("/etc/ld.so.cache", O_RDONLY) = 3
[pid 44122] fstat(3, {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 44122] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2000000000050000
[pid 44122] close(3)                    = 0
[pid 44122] open("/lib/libc.so.6.1", O_RDONLY) = 3
[pid 44122] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 44122] fstat(3, {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 44122] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000060000
[pid 44122] mmap(0x20000000002d0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x20000000002d0000
[pid 44122] close(3)                    = 0
[pid 44122] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000002e0000
[pid 44122] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000002f0000
[pid 44122] munmap(0x2000000000050000, 55440) = 0
[pid 44122] socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 3
[pid 44122] fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
[pid 44122] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000050000
[pid 44122] ioctl(3, SIOCETHTOOL, 0x600ffffffff2f928) = 0
[pid 44122] ioctl(3, SIOCETHTOOL, 0x600ffffffff2f928) = 0
[pid 44122] ioctl(3, SIOCETHTOOL, 0x600ffffffff2f928) = 0
[pid 44122] ioctl(3, SIOCETHTOOL, 0x600ffffffff2f928) = 0
[pid 44122] write(1, "Settings for eth7:\n\tSupported po"..., 514) = 514
[pid 43542] <... read resumed> "Settings for eth7:\n\tSupported po"..., 128) = 128
[pid 44122] exit_group(0)               = ?
Process 44121 resumed
Process 44122 detached
[pid 43542] read(3,  <unfinished ...>
[pid 44121] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 44122
[pid 43542] <... read resumed> "baseT/Half 100baseT/Full \n\tSuppo"..., 128) = 128
[pid 44121] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43542] read(3,  <unfinished ...>
[pid 44121] --- SIGCHLD (Child exited) @ a000000000010721 (ac5a) ---
[pid 44121] wait4(-1,  <unfinished ...>
[pid 43542] <... read resumed> "       100baseT/Half 100baseT/Fu"..., 128) = 128
[pid 44121] <... wait4 resumed> 0x600fffffffc6cd7c, WNOHANG, NULL) = -1 ECHILD (No child processes)
[pid 43542] read(3,  <unfinished ...>
[pid 44121] rt_sigreturn( <unfinished ...>
[pid 43542] <... read resumed> "eiver: internal\n\tAuto-negotiatio"..., 128) = 128
[pid 44121] <... rt_sigreturn resumed> ) = ? (mask now [RT21 RT22])
[pid 44121] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0},  <unfinished ...>
[pid 43542] read(3,  <unfinished ...>
[pid 44121] <... rt_sigaction resumed> {0x400000000015c560, [], 0}, 8) = 0
[pid 43542] <... read resumed> "s\n", 128) = 2
[pid 44121] exit_group(0)               = ?
Process 44121 detached
read(3, "", 128)                        = 0
--- SIGCHLD (Child exited) @ a000000000010721 (ac59) ---
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WNOHANG, NULL) = 44121
wait4(-1, 0x600fffffffc6cfbc, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [])
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigaction(SIGINT, {0x400000000015c560, [], 0}, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
pipe([3, 4])                            = 3
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [CHLD], 8) = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [INT CHLD], 8) = 0
rt_sigprocmask(SIG_SETMASK, [INT CHLD], NULL, 8) = 0
clone2(Process 44131 attached (waiting for parent)
Process 44131 resumed (parent 43542 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 44131
[pid 44131] close(255)                  = 0
[pid 44131] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 44131] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 44131] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 44131] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 44131] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43542] close(4 <unfinished ...>
[pid 44131] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 44131] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 44131] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 44131] close(3 <unfinished ...>
[pid 43542] close(4 <unfinished ...>
[pid 44131] <... close resumed> )       = 0
[pid 44131] dup2(4, 1 <unfinished ...>
[pid 43542] <... close resumed> )       = -1 EBADF (Bad file descriptor)
[pid 44131] <... dup2 resumed> )        = 1
[pid 44131] close(4 <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_BLOCK, [INT CHLD],  <unfinished ...>
[pid 44131] <... close resumed> )       = 0
[pid 44131] rt_sigaction(SIGINT, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 44131] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 44131] rt_sigaction(SIGQUIT, {SIG_DFL},  <unfinished ...>
[pid 43542] clone2( <unfinished ...>
[pid 44131] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 44131] rt_sigaction(SIGCHLD, {SIG_DFL}, Process 44132 attached (waiting for parent)
{0x400000000015c520, [], 0}, 8) = 0
[pid 44131] rt_sigprocmask(SIG_BLOCK, [CHLD], Process 44132 resumed (parent 43542 ready)
 <unfinished ...>
[pid 43542] <... clone2 resumed> child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 44132
[pid 44131] <... rt_sigprocmask resumed> [], 8) = 0
[pid 44132] close(255 <unfinished ...>
[pid 44131] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 44131] rt_sigaction(SIGCHLD, {0x400000000015c520, [], 0},  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 44131] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43542] close(3 <unfinished ...>
[pid 44131] rt_sigaction(SIGINT, {0x200000000004adc0, [], 0},  <unfinished ...>
[pid 43542] <... close resumed> )       = 0
[pid 44131] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 43542] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 44131] rt_sigprocmask(SIG_BLOCK, NULL,  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 44131] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43542] rt_sigprocmask(SIG_SETMASK, [CHLD],  <unfinished ...>
[pid 44131] write(1, "Settings for eth7: Supported por"..., 442 <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 44131] <... write resumed> )       = 442
[pid 43542] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 44131] exit_group(0)               = ?
Process 44131 detached
[pid 43542] <... rt_sigprocmask resumed> [CHLD], 8) = 0
[pid 44132] <... close resumed> )       = 0
[pid 43542] rt_sigaction(SIGINT, {0x400000000015c560, [], 0},  <unfinished ...>
[pid 44132] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 44132] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 44132] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] wait4(-1,  <unfinished ...>
[pid 44132] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 44132] rt_sigaction(SIGTTIN, {SIG_DFL},  <unfinished ...>
[pid 43542] <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 44131
[pid 44132] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 44132] rt_sigaction(SIGTTOU, {SIG_DFL},  <unfinished ...>
[pid 43542] wait4(-1, Process 43542 suspended
 <unfinished ...>
[pid 44132] <... rt_sigaction resumed> {SIG_IGN}, 8) = 0
[pid 44132] dup2(3, 0)                  = 0
[pid 44132] close(3)                    = 0
[pid 44132] stat(".", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid 44132] stat("/sbin/grep", 0x600fffffffc6da00) = -1 ENOENT (No such file or directory)
[pid 44132] stat("/usr/sbin/grep", 0x600fffffffc6da00) = -1 ENOENT (No such file or directory)
[pid 44132] stat("/bin/grep", {st_mode=S_IFREG|0755, st_size=174960, ...}) = 0
[pid 44132] access("/bin/grep", X_OK)   = 0
[pid 44132] access("/bin/grep", R_OK)   = 0
[pid 44132] stat("/bin/grep", {st_mode=S_IFREG|0755, st_size=174960, ...}) = 0
[pid 44132] access("/bin/grep", X_OK)   = 0
[pid 44132] access("/bin/grep", R_OK)   = 0
[pid 44132] rt_sigaction(SIGINT, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 44132] rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 44132] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 44132] execve("/bin/grep", ["grep"..., "-q"..., "Link detected: yes"...], [/* 21 vars */]) = 0
[pid 44132] brk(0)                      = 0x6000000000010000
[pid 44132] uname({sys="Linux", node="PQ-muneda", ...}) = 0
[pid 44132] access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
[pid 44132] open("/etc/ld.so.cache", O_RDONLY) = 3
[pid 44132] fstat(3, {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 44132] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2000000000050000
[pid 44132] close(3)                    = 0
[pid 44132] open("/lib/libpcre.so.0", O_RDONLY) = 3
[pid 44132] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240!\0\0\0\0\0\0"..., 832) = 832
[pid 44132] fstat(3, {st_mode=S_IFREG|0755, st_size=193224, ...}) = 0
[pid 44132] mmap(NULL, 256616, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000000060000
[pid 44132] mmap(0x2000000000090000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000) = 0x2000000000090000
[pid 44132] close(3)                    = 0
[pid 44132] open("/lib/libc.so.6.1", O_RDONLY) = 3
[pid 44132] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 44132] fstat(3, {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 44132] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x20000000000a0000
[pid 44132] mmap(0x2000000000310000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x2000000000310000
[pid 44132] close(3)                    = 0
[pid 44132] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000320000
[pid 44132] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000330000
[pid 44132] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000340000
[pid 44132] munmap(0x2000000000050000, 55440) = 0
[pid 44132] brk(0)                      = 0x6000000000010000
[pid 44132] brk(0x6000000000040000)     = 0x6000000000040000
[pid 44132] read(0, "Settings for eth7: Supported por"..., 65536) = 442
[pid 44132] close(1)                    = 0
[pid 44132] exit_group(0)               = ?
Process 43542 resumed
Process 44132 detached
<... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 44132
rt_sigprocmask(SIG_SETMASK, [CHLD], NULL, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
close(3)                                = -1 EBADF (Bad file descriptor)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
--- SIGCHLD (Child exited) @ a000000000010721 (ac63) ---
wait4(-1, 0x600fffffffc6d14c, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [ILL TRAP ABRT USR1 CONT TSTP TTOU RT30])
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
clone2(Process 44133 attached (waiting for parent)
Process 44133 resumed (parent 43542 ready)
child_stack=0, stack_size=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x20000000003204a0) = 44133
[pid 44133] close(255)                  = 0
[pid 44133] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 43542] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 44133] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 44133] rt_sigaction(SIGTSTP, {SIG_DFL},  <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 44133] <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
[pid 44133] rt_sigaction(SIGTTIN, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43542] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 44133] rt_sigaction(SIGTTOU, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43542] <... rt_sigprocmask resumed> [], 8) = 0
[pid 44133] rt_sigaction(SIGINT, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 43542] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 44133] rt_sigaction(SIGQUIT, {SIG_DFL}, {SIG_IGN}, 8) = 0
[pid 43542] <... rt_sigprocmask resumed> NULL, 8) = 0
[pid 44133] rt_sigaction(SIGCHLD, {SIG_DFL}, {0x400000000015c520, [], 0}, 8) = 0
[pid 43542] rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
[pid 44133] execve("/sbin/dhclient", ["/sbin/dhclient"..., "-1"..., "-q"..., "-lf"..., "/var/lib/dhclient/dhclient-eth7."..., "-pf"..., "/var/run/dhclient-eth7.pid"..., "eth7"...], [/* 20 vars */] <unfinished ...>
[pid 43542] <... rt_sigprocmask resumed> [], 8) = 0
[pid 43542] rt_sigaction(SIGINT, {0x400000000015c560, [], 0}, {SIG_DFL}, 8) = 0
[pid 44133] <... execve resumed> )      = 0
[pid 43542] wait4(-1, Process 43542 suspended
 <unfinished ...>
[pid 44133] brk(0)                      = 0x2000000800100000
[pid 44133] uname({sys="Linux", node="PQ-muneda", ...}) = 0
[pid 44133] access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
[pid 44133] open("/etc/ld.so.cache", O_RDONLY) = 3
[pid 44133] fstat(3, {st_mode=S_IFREG|0644, st_size=55440, ...}) = 0
[pid 44133] mmap(NULL, 55440, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2000000800150000
[pid 44133] close(3)                    = 0
[pid 44133] open("/lib/libc.so.6.1", O_RDONLY) = 3
[pid 44133] read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0002\0\1\0\0\0\240:\2\0\0\0\0\0"..., 832) = 832
[pid 44133] fstat(3, {st_mode=S_IFREG|0755, st_size=2844880, ...}) = 0
[pid 44133] mmap(NULL, 2613288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2000000800160000
[pid 44133] mmap(0x20000008003d0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x260000) = 0x20000008003d0000
[pid 44133] close(3)                    = 0
[pid 44133] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000008003e0000
[pid 44133] mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000008003f0000
[pid 44133] --- SIGSEGV (Segmentation fault) @ 2000000800118530 (20e0210850000808) ---
Process 43542 resumed
Process 44133 detached
<... wait4 resumed> [{WIFSIGNALED(s) && WTERMSIG(s) == SIGSEGV}], 0, NULL) = 44133
fstat(2, {st_mode=S_IFCHR|0620, st_rdev=makedev(4, 64), ...}) = 0
ioctl(2, SNDCTL_TMR_TIMEBASE or TCGETS, {B9600 opost isig icanon echo ...}) = 0
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2000000000370000
write(2, "/etc/sysconfig/network-scripts/i"..., 122/etc/sysconfig/network-scripts/ifup-eth: line 282: 44133 Segmentation fault      /sbin/dhclient ${DHCLIENTARGS} ${DEVICE}
) = 122
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
--- SIGCHLD (Child exited) @ a000000000010721 (ac65) ---
wait4(-1, 0x600fffffffc6e76c, WNOHANG, NULL) = -1 ECHILD (No child processes)
rt_sigreturn()                          = ? (mask now [RT1 RT5 RT6 RT9 RT10 RT13 RT14 RT17 RT20 RT21 RT22])
rt_sigaction(SIGINT, {SIG_DFL}, {0x400000000015c560, [], 0}, 8) = 0
write(1, " failed.\n", 9 failed.
)               = 9
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
exit_group(1)                           = ?





