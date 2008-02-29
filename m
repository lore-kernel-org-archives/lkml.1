Return-Path: <linux-kernel-owner+w=401wt.eu-S1758928AbYB2HAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928AbYB2HAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 02:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYB2HAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 02:00:32 -0500
Received: from xspect.dk ([212.97.129.87]:54163 "EHLO xspect.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbYB2HAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 02:00:31 -0500
Date: Fri, 29 Feb 2008 08:00:28 +0100
From: "Klaus S. Madsen" <ksm@hjernemadsen.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
Message-ID: <20080229070028.GK17932@hjernemadsen.org>
References: <20080227221033.GR17932@hjernemadsen.org> <20080228091639.GB1133@elte.hu> <20080228092846.GC17932@hjernemadsen.org> <20080228094000.GA2987@elte.hu> <20080228150444.GG17932@hjernemadsen.org> <47C6F4F9.90700@zytor.com> <20080228192404.GH17932@hjernemadsen.org> <47C70C01.4020605@zytor.com> <20080228194920.GJ17932@hjernemadsen.org> <47C739A6.5020608@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C739A6.5020608@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 14:45:58 -0800, H. Peter Anvin wrote:
> I just realized something important.
> 
> Could you please send me a *complete* strace of the execution of s2ram 
> from the beginning?
Sure. Here you go:

execve("/sbin/s2ram", ["s2ram"], [/* 20 vars */]) = 0
brk(0)                                  = 0x8058000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f15000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/home/ksm/downloads/libx86-0.99/tls/i686/sse2/cmov/libx86.so.1", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/home/ksm/downloads/libx86-0.99/tls/i686/sse2/cmov", 0xbff318d8) = -1 ENOENT (No such file or directory)
open("/home/ksm/downloads/libx86-0.99/tls/i686/sse2/libx86.so.1", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/home/ksm/downloads/libx86-0.99/tls/i686/sse2", 0xbff318d8) = -1 ENOENT (No such file or directory)
open("/home/ksm/downloads/libx86-0.99/tls/i686/cmov/libx86.so.1", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/home/ksm/downloads/libx86-0.99/tls/i686/cmov", 0xbff318d8) = -1 ENOENT (No such file or directory)
open("/home/ksm/downloads/libx86-0.99/tls/i686/libx86.so.1", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/home/ksm/downloads/libx86-0.99/tls/i686", 0xbff318d8) = -1 ENOENT (No such file or directory)
open("/home/ksm/downloads/libx86-0.99/tls/sse2/cmov/libx86.so.1", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/home/ksm/downloads/libx86-0.99/tls/sse2/cmov", 0xbff318d8) = -1 ENOENT (No such file or directory)
open("/home/ksm/downloads/libx86-0.99/tls/sse2/libx86.so.1", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/home/ksm/downloads/libx86-0.99/tls/sse2", 0xbff318d8) = -1 ENOENT (No such file or directory)
open("/home/ksm/downloads/libx86-0.99/tls/cmov/libx86.so.1", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/home/ksm/downloads/libx86-0.99/tls/cmov", 0xbff318d8) = -1 ENOENT (No such file or directory)
open("/home/ksm/downloads/libx86-0.99/tls/libx86.so.1", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/home/ksm/downloads/libx86-0.99/tls", 0xbff318d8) = -1 ENOENT (No such file or directory)
open("/home/ksm/downloads/libx86-0.99/i686/sse2/cmov/libx86.so.1", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/home/ksm/downloads/libx86-0.99/i686/sse2/cmov", 0xbff318d8) = -1 ENOENT (No such file or directory)
open("/home/ksm/downloads/libx86-0.99/i686/sse2/libx86.so.1", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/home/ksm/downloads/libx86-0.99/i686/sse2", 0xbff318d8) = -1 ENOENT (No such file or directory)
open("/home/ksm/downloads/libx86-0.99/i686/cmov/libx86.so.1", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/home/ksm/downloads/libx86-0.99/i686/cmov", 0xbff318d8) = -1 ENOENT (No such file or directory)
open("/home/ksm/downloads/libx86-0.99/i686/libx86.so.1", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/home/ksm/downloads/libx86-0.99/i686", 0xbff318d8) = -1 ENOENT (No such file or directory)
open("/home/ksm/downloads/libx86-0.99/sse2/cmov/libx86.so.1", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/home/ksm/downloads/libx86-0.99/sse2/cmov", 0xbff318d8) = -1 ENOENT (No such file or directory)
open("/home/ksm/downloads/libx86-0.99/sse2/libx86.so.1", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/home/ksm/downloads/libx86-0.99/sse2", 0xbff318d8) = -1 ENOENT (No such file or directory)
open("/home/ksm/downloads/libx86-0.99/cmov/libx86.so.1", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/home/ksm/downloads/libx86-0.99/cmov", 0xbff318d8) = -1 ENOENT (No such file or directory)
open("/home/ksm/downloads/libx86-0.99/libx86.so.1", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0P\6\0\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=23446, ...}) = 0
mmap2(NULL, 11664, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7f12000
mmap2(0xb7f14000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1) = 0xb7f14000
close(3)                                = 0
open("/home/ksm/downloads/libx86-0.99/libz.so.1", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=122255, ...}) = 0
mmap2(NULL, 122255, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7ef4000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/usr/lib/libz.so.1", O_RDONLY)    = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\20\31\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=80504, ...}) = 0
mmap2(NULL, 83232, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7edf000
mmap2(0xb7ef3000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x13) = 0xb7ef3000
close(3)                                = 0
open("/home/ksm/downloads/libx86-0.99/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/cmov/libc.so.6", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\260a\1"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=1339816, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7ede000
mmap2(NULL, 1349136, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7d94000
mmap2(0xb7ed8000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x143) = 0xb7ed8000
mmap2(0xb7edb000, 9744, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7edb000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7d93000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7d936b0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
mprotect(0xb7ed8000, 4096, PROT_READ)   = 0
munmap(0xb7ef4000, 122255)              = 0
open("/dev/mem", O_RDONLY|O_LARGEFILE)  = 3
brk(0)                                  = 0x8058000
brk(0x8089000)                          = 0x8089000
mmap2(NULL, 65536, PROT_READ, MAP_SHARED, 3, 0xf0) = 0xb7f02000
munmap(0xb7f02000, 65536)               = 0
close(3)                                = 0
open("/dev/mem", O_RDONLY|O_LARGEFILE)  = 3
mmap2(NULL, 2453, PROT_READ, MAP_SHARED, 3, 0xe0) = 0xb7f11000
munmap(0xb7f11000, 2453)                = 0
close(3)                                = 0
brk(0x8079000)                          = 0x8079000
open("/dev/tty", O_RDWR|O_LARGEFILE)    = 3
ioctl(3, KDGKBTYPE, 0xbff32007)         = -1 EINVAL (Invalid argument)
close(3)                                = 0
open("/dev/tty0", O_RDWR|O_LARGEFILE)   = 3
ioctl(3, KDGKBTYPE, 0xbff32007)         = 0
ioctl(3, VT_GETSTATE, 0xbff32062)       = 0
fstat64(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 1), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f11000
write(1, "Switching from vt7 to vt1\n", 26) = 26
open("/dev/tty", O_RDWR|O_LARGEFILE)    = 4
ioctl(4, KDGKBTYPE, 0xbff32017)         = -1 EINVAL (Invalid argument)
close(4)                                = 0
open("/dev/tty0", O_RDWR|O_LARGEFILE)   = 4
ioctl(4, KDGKBTYPE, 0xbff32017)         = 0
ioctl(4, VIDIOC_G_COMP or VT_ACTIVATE, 0x1) = 0
ioctl(4, VIDIOC_S_COMP or VT_WAITACTIVE, 0x1) = 0
open("/proc/sys/kernel/acpi_video_flags", O_RDONLY|O_LARGEFILE) = 5
fstat64(5, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f10000
read(5, "0\n", 1024)                    = 2
close(5)                                = 0
munmap(0xb7f10000, 4096)                = 0
open("/proc/sys/kernel/acpi_video_flags", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0666) = 5
fstat64(5, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f10000
write(5, "2", 1)                        = 1
close(5)                                = 0
munmap(0xb7f10000, 4096)                = 0
open("/dev/zero", O_RDWR)               = 5
mmap2(0x1000, 655360, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_SHARED|MAP_FIXED, 5, 0) = 0x1000
close(5)                                = 0
open("/dev/mem", O_RDWR)                = 5
mmap2(NULL, 1282, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_SHARED|MAP_FIXED, 5, 0) = 0
mmap2(0xa0000, 393216, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_FIXED, 5, 0xa0) = 0xa0000
close(5)                                = 0
ioperm(0, 0x400, 0x1)                   = 0
iopl(0x3)                               = 0
access("/sys/bus/pci", R_OK)            = 0
write(1, "Calling get_mode\n", 17)      = 17
vm86(0x1, 0xb7f14ccc, 0xb7f14830, 0xc000, 0x18b6 <unfinished ...>
--- SIGSEGV (Segmentation fault) @ 0 (0) ---
+++ killed by SIGSEGV (core dumped) +++

-- 
Kind regards
	Klaus S. Madsen
