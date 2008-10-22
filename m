Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbYJVKvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbYJVKvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbYJVKvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:51:18 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:63274 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829AbYJVKvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:51:17 -0400
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.27.2] Unnamed entry appears in /sys/module/usbcore/parameters/ .
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200810210838.m9L8cegu033608@www262.sakura.ne.jp>
	<20081021170002.GA24940@kroah.com>
In-Reply-To: <20081021170002.GA24940@kroah.com>
Message-Id: <200810221951.JHF56206.JFQFMFSVtLOHOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 22 Oct 2008 19:51:13 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Below four results are obtained using config
at http://I-love.SAKURA.ne.jp/tmp/config-2.6.27.2-2
with CONFIG_USB=y and CONFIG_USB=m .

----------------------------------------
Result of CONFIG_USB=y on Debian Sarge

# ls -ail /sys/module/usbcore/parameters/
total 0
200 drwxr-xr-x  2 root root    0 Oct 22 13:03
200 drwxr-xr-x  2 root root    0 Oct 22 13:03 .
199 drwxr-xr-x  4 root root    0 Oct 22 13:03 ..
201 -rw-r--r--  1 root root 4096 Oct 22 13:03 autosuspend
203 -r--r--r--  1 root root 4096 Oct 22 13:03 blinkenlights
204 -rw-r--r--  1 root root 4096 Oct 22 13:03 old_scheme_first
205 -rw-r--r--  1 root root 4096 Oct 22 13:03 use_both_schemes
# cd /sys/module/usbcore/parameters/ ; strace ls -a
(...snipped...)
open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
fstat64(3, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
getdents64(3, /* 7 entries */, 4096)    = 224
getdents64(3, /* 0 entries */, 4096)    = 0
close(3)                                = 0
fstat64(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 0), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb809b000
write(1, "   .  ..  autosuspend  blinkenli"..., 72   .  ..  autosuspend  blinkenlights  old_scheme_first        use_both_schemes
) = 72
munmap(0xb809b000, 4096)                = 0
exit_group(0)                           = ?

----------------------------------------
Result of CONFIG_USB=m on Debian Sarge

# ls -ail /sys/module/usbcore/parameters/
total 0
3007 drwxr-xr-x  2 root root    0 Oct 22 13:10 .
3005 drwxr-xr-x  6 root root    0 Oct 22 13:10 ..
3008 -rw-r--r--  1 root root 4096 Oct 22 13:10 autosuspend
3010 -r--r--r--  1 root root 4096 Oct 22 13:10 blinkenlights
3009 -r--r--r--  1 root root 4096 Oct 22 13:10 nousb
3011 -rw-r--r--  1 root root 4096 Oct 22 13:10 old_scheme_first
3013 -rw-r--r--  1 root root 4096 Oct 22 13:10 usbfs_snoop
3012 -rw-r--r--  1 root root 4096 Oct 22 13:10 use_both_schemes
# cd /sys/module/usbcore/parameters/ ; strace ls -a
(...snipped...)
open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
fstat64(3, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
getdents64(3, /* 8 entries */, 4096)    = 264
getdents64(3, /* 0 entries */, 4096)    = 0
close(3)                                = 0
fstat64(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 0), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb8081000
write(1, ".  ..  autosuspend  blinkenlight"..., 90.  ..  autosuspend  blinkenlights  nousb  old_scheme_first  usbfs_snoop  use_both_schemes
) = 90
munmap(0xb8081000, 4096)                = 0
exit_group(0)                           = ?

----------------------------------------
Result of CONFIG_USB=y on CentOS 5.2

# ls -ail /sys/module/usbcore/parameters/
total 0
200 drwxr-xr-x 2 root root    0 Oct 22 13:13 .
199 drwxr-xr-x 4 root root    0 Oct 22 13:13 ..
201 -rw-r--r-- 1 root root 4096 Oct 22 13:13 autosuspend
204 -r--r--r-- 1 root root 4096 Oct 22 13:13 blinkenlights
203 -rw-r--r-- 1 root root 4096 Oct 22 13:13 old_scheme_first
205 -rw-r--r-- 1 root root 4096 Oct 22 13:13 usbfs_snoop
202 -rw-r--r-- 1 root root 4096 Oct 22 13:13 use_both_schemes
# cd /sys/module/usbcore/parameters/ ; strace ls -a
(...snipped...)
open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
fstat64(3, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
getdents64(3, /* 7 entries */, 4096)    = 232
getdents64(3, /* 0 entries */, 4096)    = 0
close(3)                                = 0
fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f94000
write(1, ".  ..  autosuspend  blinkenlight"..., 83.  ..  autosuspend  blinkenlights  old_scheme_first  usbfs_snoop  use_both_schemes
) = 83
close(1)                                = 0
munmap(0xb7f94000, 4096)                = 0
exit_group(0)                           = ?

----------------------------------------
Result of CONFIG_USB=m on CentOS 5.2

# ls -ail /sys/module/usbcore/parameters/
total 0
2607 drwxr-xr-x 2 root root    0 Oct 22 13:19 .
2605 drwxr-xr-x 6 root root    0 Oct 22 13:19 ..
2609 -rw-r--r-- 1 root root 4096 Oct 22 13:19 autosuspend
2612 -r--r--r-- 1 root root 4096 Oct 22 13:19 blinkenlights
2608 -r--r--r-- 1 root root 4096 Oct 22 13:19 nousb
2611 -rw-r--r-- 1 root root 4096 Oct 22 13:19 old_scheme_first
2613 -rw-r--r-- 1 root root 4096 Oct 22 13:19 usbfs_snoop
2610 -rw-r--r-- 1 root root 4096 Oct 22 13:19 use_both_schemes
# cd /sys/module/usbcore/parameters/ ; strace ls -a
(...snipped...)
open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
fstat64(3, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
getdents64(3, /* 8 entries */, 4096)    = 264
getdents64(3, /* 0 entries */, 4096)    = 0
close(3)                                = 0
open("/proc/meminfo", O_RDONLY)         = 3
fstat64(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb805f000
read(3, "MemTotal:      1018380 kB\nMemFre"..., 1024) = 806
close(3)                                = 0
munmap(0xb805f000, 4096)                = 0
fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb805f000
write(1, ".  ..  autosuspend  blinkenlight"..., 90.  ..  autosuspend  blinkenlights  nousb  old_scheme_first  usbfs_snoop  use_both_schemes
) = 90
close(1)                                = 0
munmap(0xb805f000, 4096)                = 0
exit_group(0)                           = ?

----------------------------------------

The difference between these results is that
'205 -rw-r--r-- 1 root root 4096 Oct 22 13:13 usbfs_snoop' on CentOS 5.2 is
reported as '200 drwxr-xr-x  2 root root    0 Oct 22 13:03' on Debian Sarge
if CONFIG_USB=y.

Debian Sarge: gcc (GCC) 3.3.5 (Debian 1:3.3.5-13)
CentOS 5.2:   gcc (GCC) 4.1.2 20071124 (Red Hat 4.1.2-42)



Greg KH wrote:
> Wierd, I don't see this on 2.6.27.2 here.
This might be compiler version dependent. What can I do?

> How about on 2.6.27-git releases?
Isn't http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary (as of this posting)
identical to http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.27.2.tar.bz2 ?

Regards.
