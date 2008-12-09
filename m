Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbYLIXfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbYLIXfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 18:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYLIXe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 18:34:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972AbYLIXe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 18:34:58 -0500
Date: Tue, 9 Dec 2008 15:34:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: linux-next: Tree for December 9
Message-Id: <20081209153418.4628723d.akpm@linux-foundation.org>
In-Reply-To: <20081209185237.8bb715d7.sfr@canb.auug.org.au>
References: <20081209185237.8bb715d7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2008 18:52:37 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

udevd is sitting there chewing up 100% of a CPU all the time.

The machine is x86_64, running FC6.  It still happens with
CONFIG_SELINUX=n.

config:			http://userweb.kernel.org/~akpm/config-akpm2.txt
dmesg:			http://userweb.kernel.org/~akpm/dmesg-akpm2.txt
strace of udevd:	http://userweb.kernel.org/~akpm/strace.out.txt

excerpt:

close(9)                                = 0
open("/proc/21707/stat", O_RDONLY)      = 9
read(9, "21707 (hald-addon-stor) S 21033 "..., 255) = 240
close(9)                                = 0
open("/proc/22340/stat", O_RDONLY)      = 9
read(9, "22340 (smartd) S 1 22339 22339 0"..., 255) = 245
close(9)                                = 0
open("/proc/22347/stat", O_RDONLY)      = 9
read(9, "22347 (mingetty) S 1 22347 22347"..., 255) = 231
close(9)                                = 0
open("/proc/22348/stat", O_RDONLY)      = 9
read(9, "22348 (mingetty) S 1 22348 22348"..., 255) = 231
close(9)                                = 0
open("/proc/22350/stat", O_RDONLY)      = 9
read(9, "22350 (mingetty) S 1 22350 22350"..., 255) = 231
close(9)                                = 0
open("/proc/22351/stat", O_RDONLY)      = 9
read(9, "22351 (mingetty) S 1 22351 22351"..., 255) = 231
close(9)                                = 0
open("/proc/22352/stat", O_RDONLY)      = 9
read(9, "22352 (mingetty) S 1 22352 22352"..., 255) = 231
close(9)                                = 0
open("/proc/22353/stat", O_RDONLY)      = 9
read(9, "22353 (mingetty) S 1 22353 22353"..., 255) = 231
close(9)                                = 0
getdents(8, /* 0 entries */, 1024)      = 0
close(8)                                = 0
clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7f77a89267a0) = 9474
select(8, [3 4 5 7], NULL, NULL, NULL)  = 2 (in [4 5])
recvfrom(4, "remove@/block/md0\0ACTION=remove\0"..., 2560, 0, NULL, NULL) = 109
open("/dev/.udev/uevent_seqnum", O_WRONLY|O_CREAT|O_TRUNC, 0644) = 8
write(8, "10081\n", 6)                  = 6
close(8)                                = 0
unlink("/dev/.udev/failed/block@md0")   = -1 ENOENT (No such file or directory)
rmdir("/dev/.udev/failed")              = -1 ENOTEMPTY (Directory not empty)
stat("/dev/.udev/queue", {st_mode=S_IFDIR|0755, st_size=80, ...}) = 0
symlink("/sys/block/md0", "/dev/.udev/queue/block@md0") = -1 EEXIST (File exists)
read(5, "\0", 256)                      = 1
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WNOHANG, NULL) = 9470
unlink("/dev/.udev/failed/class@bdi@9:0") = -1 ENOENT (No such file or directory)
rmdir("/dev/.udev/failed")              = -1 ENOTEMPTY (Directory not empty)
wait4(-1, 0x7fffb09643cc, WNOHANG, NULL) = 0
open("/proc/stat", O_RDONLY)            = 8
read(8, "cpu  4028 0 11313 54268 7224 6 2"..., 4095) = 4095
close(8)                                = 0
open("/proc", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 8
fstat(8, {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
fcntl(8, F_SETFD, FD_CLOEXEC)           = 0
getdents(8, /* 33 entries */, 1024)     = 1016
getdents(8, /* 39 entries */, 1024)     = 1024
open("/proc/1/stat", O_RDONLY)          = 9
read(9, "1 (init) S 0 1 1 0 -1 4194560 10"..., 255) = 243
close(9)                                = 0
open("/proc/2/stat", O_RDONLY)          = 9
read(9, "2 (kthreadd) S 0 0 0 0 -1 214961"..., 255) = 156
close(9)                                = 0
open("/proc/3/stat", O_RDONLY)          = 9
read(9, "3 (migration/0) S 2 0 0 0 -1 221"..., 255) = 163
close(9)                                = 0
open("/proc/4/stat", O_RDONLY)          = 9
read(9, "4 (ksoftirqd/0) S 2 0 0 0 -1 221"..., 255) = 160
--- SIGCHLD (Child exited) @ 0 (0) ---
write(6, "\0", 1)                       = 1
rt_sigreturn(0x6)                       = 160
close(9)                                = 0
open("/proc/5/stat", O_RDONLY)          = 9
read(9, "5 (watchdog/0) S 2 0 0 0 -1 2216"..., 255) = 162
close(9)                                = 0
open("/proc/6/stat", O_RDONLY)          = 9
read(9, "6 (migration/1) S 2 0 0 0 -1 221"..., 255) = 163
close(9)                                = 0
open("/proc/7/stat", O_RDONLY)          = 9
read(9, "7 (ksoftirqd/1) S 2 0 0 0 -1 221"..., 255) = 160
close(9)                                = 0
open("/proc/8/stat", O_RDONLY)          = 9
read(9, "8 (watchdog/1) S 2 0 0 0 -1 2216"..., 255) = 162
close(9)                                = 0
open("/proc/9/stat", O_RDONLY)          = 9
read(9, "9 (migration/2) S 2 0 0 0 -1 221"..., 255) = 164
close(9)                                = 0
open("/proc/10/stat", O_RDONLY)         = 9
read(9, "10 (ksoftirqd/2) S 2 0 0 0 -1 22"..., 255) = 162
close(9)                                = 0
open("/proc/11/stat", O_RDONLY)         = 9
read(9, "11 (watchdog/2) S 2 0 0 0 -1 221"..., 255) = 164
close(9)                                = 0
open("/proc/12/stat", O_RDONLY)         = 9
read(9, "12 (migration/3) S 2 0 0 0 -1 22"..., 255) = 165
close(9)                                = 0
open("/proc/13/stat", O_RDONLY)         = 9
read(9, "13 (ksoftirqd/3) S 2 0 0 0 -1 22"..., 255) = 162
close(9)                                = 0
open("/proc/14/stat", O_RDONLY)         = 9
read(9, "14 (watchdog/3) S 2 0 0 0 -1 221"..., 255) = 164
close(9)                                = 0
open("/proc/15/stat", O_RDONLY)         = 9
read(9, "15 (migration/4) S 2 0 0 0 -1 22"..., 255) = 165
close(9)                                = 0
getdents(8, /* 42 entries */, 1024)     = 1008
open("/proc/16/stat", O_RDONLY)         = 9
read(9, "16 (ksoftirqd/4) S 2 0 0 0 -1 22"..., 255) = 162
close(9)                                = 0
open("/proc/17/stat", O_RDONLY)         = 9
read(9, "17 (watchdog/4) S 2 0 0 0 -1 221"..., 255) = 164
close(9)                                = 0
open("/proc/18/stat", O_RDONLY)         = 9
read(9, "18 (migration/5) S 2 0 0 0 -1 22"..., 255) = 165
close(9)                                = 0
open("/proc/19/stat", O_RDONLY)         = 9
read(9, "19 (ksoftirqd/5) S 2 0 0 0 -1 22"..., 255) = 162
close(9)                                = 0
open("/proc/20/stat", O_RDONLY)         = 9
read(9, "20 (watchdog/5) S 2 0 0 0 -1 221"..., 255) = 164

