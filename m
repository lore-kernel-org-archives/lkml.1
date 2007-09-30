Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbXI3UDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbXI3UDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 16:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXI3UDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 16:03:44 -0400
Received: from ara.aytolacoruna.es ([212.51.63.12]:46254 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbXI3UDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 16:03:43 -0400
Date: Sun, 30 Sep 2007 22:03:36 +0200
From: Santiago Garcia Mantinan <manty@manty.net>
To: Mark Lord <lkml@rtr.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] (repost) Fix SMP poweroff hangs
Message-ID: <20070930200336.GA2441@pul.manty.net>
References: <46FD001A.3070309@rtr.ca> <200709281544.30497.rjw@sisk.pl> <46FD05B8.2040302@rtr.ca> <46FD0724.5060009@rtr.ca> <1190991316.18681.38.camel@chaos> <46FD5BAF.8040304@rtr.ca> <20070930090032.GA2405@pul.manty.net> <46FFDB29.9040400@rtr.ca> <20070930175446.GA2472@pul.manty.net> <46FFEF41.8010104@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FFEF41.8010104@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I booted into single mode, then umounted all unneeded stuff and put / to ro,
stopped all unused raids, ... then did...

>    /sbin/halt -f -p
>
> The machine *should* poweroff.

Nope, it didn't and what was curious was that I was left at the bash prompt
:-?

> If not, then do the whole thing again with this command:
>
>    strace /bin/halt -f -p

I tried this and I did the strace with a -o to get the output on a remote
cifs fs, here is the full trace:

execve("/sbin/halt", ["/sbin/halt", "-f", "-p"], [/* 16 vars */]) = 0
brk(0)                                  = 0x804b000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f29000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=52448, ...}) = 0
mmap2(NULL, 52448, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f1c000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\260a\1"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1335536, ...}) = 0
mmap2(NULL, 1340944, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7dd4000
mmap2(0xb7f16000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x142) = 0xb7f16000
mmap2(0xb7f19000, 9744, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f19000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7dd3000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7dd36b0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
mprotect(0xb7f16000, 4096, PROT_READ)   = 0
munmap(0xb7f1c000, 52448)               = 0
geteuid32()                             = 0
chdir("/")                              = 0
open("/var/log/wtmp", O_WRONLY|O_APPEND) = -1 EROFS (Read-only file system)
sync()                                  = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigaction(SIGCHLD, NULL, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
nanosleep({2, 0}, {2, 0})               = 0
reboot(LINUX_REBOOT_MAGIC1, LINUX_REBOOT_MAGIC2, LINUX_REBOOT_CMD_RESTART|0x88888888) = 0
kill(1, SIGTSTP)                        = 0
reboot(LINUX_REBOOT_MAGIC1, LINUX_REBOOT_MAGIC2, LINUX_REBOOT_CMD_POWER_OFF <unfinished ... exit status 0>

Same output on the screen as I commented before, again I got to the shell
and this time I even typed some commands like ps and amazingly they still
worked, even though this was supposed to be halted.

Hope that helps.
-- 
Manty/BestiaTester -> http://manty.net
