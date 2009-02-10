Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbZBJQ3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbZBJQ3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 11:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbZBJQ3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 11:29:15 -0500
Received: from mail.gmx.net ([213.165.64.20]:46749 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751202AbZBJQ3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 11:29:13 -0500
X-Authenticated: #36390367
X-Provags-ID: V01U2FsdGVkX19axLgmjj1azIeCjNjDwFqA2axmiLdC6gZy2BWCWu
	Y0cF7JkTMdxjBD
From: Markus =?iso-8859-15?q?Ko=DFmann?= <mkossmann_ml1@gmx.de>
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [Regression] hald segfaults at startup on Toshiba Portege R500 x86_64 (bisected)
Date: Tue, 10 Feb 2009 17:28:49 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc4-master_20090209165007_20c19cf8-default; KDE/4.2.0; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       " =?iso-8859-15?q?=C9ric?= Piel" <eric.piel@tremplin-utc.net>
References: <200901080827.02882.rjw@sisk.pl> <20090108093407.3efd0938@mjolnir.drzeus.cx>
In-Reply-To: <20090108093407.3efd0938@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_BtakJ5cJSr7HTBL"
Message-Id: <200902101728.49653.mkossmann_ml1@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_BtakJ5cJSr7HTBL
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Donnerstag, 8. Januar 2009 schrieb Pierre Ossman:
> On Thu, 8 Jan 2009 08:27:02 +0100
>
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > Hi,
> >
> > Unfortunately the following commit:
> >
> > commit 35ff8554d12ecc80a46ea0d9bce34fe28733ff38
> > Author: =C9ric Piel <eric.piel@tremplin-utc.net>
> > Date:   Sat Nov 22 19:29:29 2008 +0100
> >
> >     sdhci: activate led support also when module
> >
> >     CONFIG_LEDS_CLASS is defined only if led-class is built-in, otherwi=
se
> >     when it is a module the option is called CONFIG_LEDS_CLASS_MODULE.
> > Led support should also be activated in this case.
> >
> >     Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
> >     Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
> >
> > causes hald to segfault at startup (not always, but sufficiently often
> > for bisection) on my Toshiba Portege R500 w/ x86_64 kernel/userland.
>
> I have trouble seeing a user space application crashing as a kernel
> bug. Do you have a backtrace or strace of hald to see exactly where it
> crashes?
>
> > While it doesn't revert cleanly, I have applied the appended patch (whi=
ch
> > is a revert of the commit above) and hald doesn't segfault any more her=
e.
>
> Is CONFIG_LEDS_CLASS defined in your config, or are you essentially
> turning of the LED functionality?
>
> Rgds

Hi Pierre;=20
it seems that I see the same problem here on my HP8530w laptop ( 64bit=20
kernel/userland and sdhci compiled as module). When starting up the system=
=20
with SUSEs KOTD 2.6.29-rc4-master_20090209165007_20c19cf8-default=20
hald crashes with something like:=20
=46eb 10 15:23:02 linux-gpi4 kernel: hald[5216]: segfault at 20 ip 00000000=
0042f
4ab sp 00007ffff343b5e0 error 4 in hald[400000+55000]:

After applying Rafaels patch the problem goes away.=20

I attach straces of hald from both unpatched and patched kernel.=20




--Boundary-00=_BtakJ5cJSr7HTBL
Content-Type: text/plain;
  charset="UTF-8";
  name="hald_trace.patched"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="hald_trace.patched"

execve("/usr/sbin/hald", ["/usr/sbin/hald", "--daemon=yes"], [/* 23 vars */]) = 0
brk(0)                                  = 0x65b000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9e17e35000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9e17e34000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 4
fstat(4, {st_mode=S_IFREG|0644, st_size=185059, ...}) = 0
mmap(NULL, 185059, PROT_READ, MAP_PRIVATE, 4, 0) = 0x7f9e17e06000
close(4)                                = 0
open("/usr/lib64/libdbus-glib-1.so.2", O_RDONLY) = 4
read(4, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\360\226\0\0\0\0\0\0"..., 832) = 832
fstat(4, {st_mode=S_IFREG|0755, st_size=135848, ...}) = 0
mmap(NULL, 2231168, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0x7f9e179f8000
fadvise64(4, 0, 2231168, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f9e17a18000, 2093056, PROT_NONE) = 0
mmap(0x7f9e17c17000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x1f000) = 0x7f9e17c17000
close(4)                                = 0
open("/usr/lib64/libgobject-2.0.so.0", O_RDONLY) = 4
read(4, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0@\222\0\0\0\0\0\0"..., 832) = 832
fstat(4, {st_mode=S_IFREG|0755, st_size=277928, ...}) = 0
mmap(NULL, 2375880, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0x7f9e177b3000
fadvise64(4, 0, 2375880, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f9e177f5000, 2097152, PROT_NONE) = 0
mmap(0x7f9e179f5000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x42000) = 0x7f9e179f5000
mmap(0x7f9e179f7000, 200, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f9e179f7000
close(4)                                = 0
open("/usr/lib64/libglib-2.0.so.0", O_RDONLY) = 4
read(4, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340R\1\0\0\0\0\0"..., 832) = 832
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9e17e05000
fstat(4, {st_mode=S_IFREG|0755, st_size=803112, ...}) = 0
mmap(NULL, 2900104, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0x7f9e174ee000
fadvise64(4, 0, 2900104, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f9e175b1000, 2093056, PROT_NONE) = 0
mmap(0x7f9e177b0000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0xc2000) = 0x7f9e177b0000
mmap(0x7f9e177b2000, 136, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f9e177b2000
close(4)                                = 0
open("/lib64/libdbus-1.so.3", O_RDONLY) = 4
read(4, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`u\0\0\0\0\0\0"..., 832) = 832
fstat(4, {st_mode=S_IFREG|0755, st_size=253488, ...}) = 0
mmap(NULL, 2349256, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0x7f9e172b0000
fadvise64(4, 0, 2349256, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f9e172ed000, 2093056, PROT_NONE) = 0
mmap(0x7f9e174ec000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x3c000) = 0x7f9e174ec000
close(4)                                = 0
open("/usr/lib64/libpolkit.so.2", O_RDONLY) = 4
read(4, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0a\0\0\0\0\0\0"..., 832) = 832
fstat(4, {st_mode=S_IFREG|0755, st_size=106040, ...}) = 0
mmap(NULL, 2201064, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0x7f9e17096000
fadvise64(4, 0, 2201064, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f9e170af000, 2093056, PROT_NONE) = 0
mmap(0x7f9e172ae000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x18000) = 0x7f9e172ae000
close(4)                                = 0
open("/lib64/libm.so.6", O_RDONLY)      = 4
read(4, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`>\0\0\0\0\0\0"..., 832) = 832
fstat(4, {st_mode=S_IFREG|0755, st_size=350648, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9e17e04000
mmap(NULL, 2445496, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0x7f9e16e40000
fadvise64(4, 0, 2445496, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f9e16e95000, 2093056, PROT_NONE) = 0
mmap(0x7f9e17094000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x54000) = 0x7f9e17094000
close(4)                                = 0
open("/lib64/libc.so.6", O_RDONLY)      = 4
read(4, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\240\346\1\0\0\0\0\0"..., 832) = 832
fstat(4, {st_mode=S_IFREG|0755, st_size=1406248, ...}) = 0
mmap(NULL, 3506872, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0x7f9e16ae7000
fadvise64(4, 0, 3506872, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f9e16c36000, 2097152, PROT_NONE) = 0
mmap(0x7f9e16e36000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x14f000) = 0x7f9e16e36000
mmap(0x7f9e16e3b000, 17080, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f9e16e3b000
close(4)                                = 0
open("/lib64/libnsl.so.1", O_RDONLY)    = 4
read(4, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340@\0\0\0\0\0\0"..., 832) = 832
fstat(4, {st_mode=S_IFREG|0755, st_size=89232, ...}) = 0
mmap(NULL, 2194128, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0x7f9e168cf000
fadvise64(4, 0, 2194128, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f9e168e4000, 2093056, PROT_NONE) = 0
mmap(0x7f9e16ae3000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x14000) = 0x7f9e16ae3000
mmap(0x7f9e16ae5000, 6864, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f9e16ae5000
close(4)                                = 0
open("/usr/lib64/libpcre.so.0", O_RDONLY) = 4
read(4, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340\26\0\0\0\0\0\0"..., 832) = 832
fstat(4, {st_mode=S_IFREG|0755, st_size=194816, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9e17e03000
mmap(NULL, 2289920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0x7f9e1669f000
fadvise64(4, 0, 2289920, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f9e166ce000, 2093056, PROT_NONE) = 0
mmap(0x7f9e168cd000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x2e000) = 0x7f9e168cd000
close(4)                                = 0
open("/lib64/libexpat.so.1", O_RDONLY)  = 4
read(4, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0@>\0\0\0\0\0\0"..., 832) = 832
fstat(4, {st_mode=S_IFREG|0755, st_size=170240, ...}) = 0
mmap(NULL, 2265264, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0x7f9e16475000
fadvise64(4, 0, 2265264, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f9e1649c000, 2097152, PROT_NONE) = 0
mmap(0x7f9e1669c000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x27000) = 0x7f9e1669c000
close(4)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9e17e02000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9e17e01000
arch_prctl(ARCH_SET_FS, 0x7f9e17e016f0) = 0
open("/dev/urandom", O_RDONLY)          = 4
read(4, "h\365wS\300\327\370!", 8)      = 8
close(4)                                = 0
mprotect(0x7f9e1669c000, 8192, PROT_READ) = 0
mprotect(0x7f9e168cd000, 4096, PROT_READ) = 0
mprotect(0x7f9e16ae3000, 4096, PROT_READ) = 0
mprotect(0x7f9e16e36000, 16384, PROT_READ) = 0
mprotect(0x7f9e17094000, 4096, PROT_READ) = 0
mprotect(0x7f9e172ae000, 4096, PROT_READ) = 0
mprotect(0x7f9e174ec000, 4096, PROT_READ) = 0
mprotect(0x7f9e177b0000, 4096, PROT_READ) = 0
mprotect(0x7f9e179f5000, 4096, PROT_READ) = 0
mprotect(0x7f9e17c17000, 4096, PROT_READ) = 0
mprotect(0x655000, 4096, PROT_READ)     = 0
mprotect(0x7f9e17e36000, 4096, PROT_READ) = 0
munmap(0x7f9e17e06000, 185059)          = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9e17e32000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9e17e31000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9e17e30000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9e17e2f000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9e17e2e000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9e17e2d000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9e17e2c000
brk(0)                                  = 0x65b000
brk(0x67c000)                           = 0x67c000
pipe([4, 5])                            = 0
chdir("/")                              = 0
clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7f9e17e01780) = 2964
rt_sigaction(SIGCHLD, {0x413650, [CHLD], SA_RESTORER|SA_RESTART, 0x7f9e16b196e0}, {SIG_DFL, [], 0}, 8) = 0
select(5, [4], NULL, [4], {250, 0})     = 1 (in [4], left {248, 979720})
exit_group(0)                           = ?

--Boundary-00=_BtakJ5cJSr7HTBL
Content-Type: text/plain;
  charset="UTF-8";
  name="hald_trace.unpatched"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="hald_trace.unpatched"

execve("/usr/sbin/hald", ["/usr/sbin/hald", "--daemon=yes"], [/* 61 vars */]) = 0
brk(0)                                  = 0x65b000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f29eb43b000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f29eb43a000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/usr/lib64/mpi/gcc/openmpi/lib64/tls/x86_64/libdbus-glib-1.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat("/usr/lib64/mpi/gcc/openmpi/lib64/tls/x86_64", 0x7ffff343bde0) = -1 ENOENT (No such file or directory)
open("/usr/lib64/mpi/gcc/openmpi/lib64/tls/libdbus-glib-1.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat("/usr/lib64/mpi/gcc/openmpi/lib64/tls", 0x7ffff343bde0) = -1 ENOENT (No such file or directory)
open("/usr/lib64/mpi/gcc/openmpi/lib64/x86_64/libdbus-glib-1.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat("/usr/lib64/mpi/gcc/openmpi/lib64/x86_64", 0x7ffff343bde0) = -1 ENOENT (No such file or directory)
open("/usr/lib64/mpi/gcc/openmpi/lib64/libdbus-glib-1.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat("/usr/lib64/mpi/gcc/openmpi/lib64", {st_mode=S_IFDIR|0755, st_size=584, ...}) = 0
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=185059, ...}) = 0
mmap(NULL, 185059, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f29eb40c000
close(3)                                = 0
open("/usr/lib64/libdbus-glib-1.so.2", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\360\226\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=135848, ...}) = 0
mmap(NULL, 2231168, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f29eaffe000
fadvise64(3, 0, 2231168, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f29eb01e000, 2093056, PROT_NONE) = 0
mmap(0x7f29eb21d000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1f000) = 0x7f29eb21d000
close(3)                                = 0
open("/usr/lib64/mpi/gcc/openmpi/lib64/libgobject-2.0.so.0", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/lib64/libgobject-2.0.so.0", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0@\222\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=277928, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f29eb40b000
mmap(NULL, 2375880, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f29eadb9000
fadvise64(3, 0, 2375880, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f29eadfb000, 2097152, PROT_NONE) = 0
mmap(0x7f29eaffb000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x42000) = 0x7f29eaffb000
mmap(0x7f29eaffd000, 200, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f29eaffd000
close(3)                                = 0
open("/usr/lib64/mpi/gcc/openmpi/lib64/libglib-2.0.so.0", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/lib64/libglib-2.0.so.0", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340R\1\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=803112, ...}) = 0
mmap(NULL, 2900104, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f29eaaf4000
fadvise64(3, 0, 2900104, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f29eabb7000, 2093056, PROT_NONE) = 0
mmap(0x7f29eadb6000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xc2000) = 0x7f29eadb6000
mmap(0x7f29eadb8000, 136, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f29eadb8000
close(3)                                = 0
open("/usr/lib64/mpi/gcc/openmpi/lib64/libdbus-1.so.3", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/lib64/libdbus-1.so.3", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`u\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=253488, ...}) = 0
mmap(NULL, 2349256, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f29ea8b6000
fadvise64(3, 0, 2349256, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f29ea8f3000, 2093056, PROT_NONE) = 0
mmap(0x7f29eaaf2000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3c000) = 0x7f29eaaf2000
close(3)                                = 0
open("/usr/lib64/mpi/gcc/openmpi/lib64/libpolkit.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/lib64/libpolkit.so.2", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0a\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=106040, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f29eb40a000
mmap(NULL, 2201064, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f29ea69c000
fadvise64(3, 0, 2201064, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f29ea6b5000, 2093056, PROT_NONE) = 0
mmap(0x7f29ea8b4000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x18000) = 0x7f29ea8b4000
close(3)                                = 0
open("/usr/lib64/mpi/gcc/openmpi/lib64/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/lib64/libm.so.6", O_RDONLY)      = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`>\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=350648, ...}) = 0
mmap(NULL, 2445496, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f29ea446000
fadvise64(3, 0, 2445496, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f29ea49b000, 2093056, PROT_NONE) = 0
mmap(0x7f29ea69a000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x54000) = 0x7f29ea69a000
close(3)                                = 0
open("/usr/lib64/mpi/gcc/openmpi/lib64/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/lib64/libc.so.6", O_RDONLY)      = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\240\346\1\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1406248, ...}) = 0
mmap(NULL, 3506872, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f29ea0ed000
fadvise64(3, 0, 3506872, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f29ea23c000, 2097152, PROT_NONE) = 0
mmap(0x7f29ea43c000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x14f000) = 0x7f29ea43c000
mmap(0x7f29ea441000, 17080, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f29ea441000
close(3)                                = 0
open("/usr/lib64/mpi/gcc/openmpi/lib64/libnsl.so.1", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/lib64/libnsl.so.1", O_RDONLY)    = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340@\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=89232, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f29eb409000
mmap(NULL, 2194128, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f29e9ed5000
fadvise64(3, 0, 2194128, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f29e9eea000, 2093056, PROT_NONE) = 0
mmap(0x7f29ea0e9000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x14000) = 0x7f29ea0e9000
mmap(0x7f29ea0eb000, 6864, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f29ea0eb000
close(3)                                = 0
open("/usr/lib64/mpi/gcc/openmpi/lib64/libpcre.so.0", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/lib64/libpcre.so.0", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340\26\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=194816, ...}) = 0
mmap(NULL, 2289920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f29e9ca5000
fadvise64(3, 0, 2289920, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f29e9cd4000, 2093056, PROT_NONE) = 0
mmap(0x7f29e9ed3000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2e000) = 0x7f29e9ed3000
close(3)                                = 0
open("/usr/lib64/mpi/gcc/openmpi/lib64/libexpat.so.1", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/lib64/libexpat.so.1", O_RDONLY)  = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0@>\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=170240, ...}) = 0
mmap(NULL, 2265264, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f29e9a7b000
fadvise64(3, 0, 2265264, POSIX_FADV_WILLNEED) = 0
mprotect(0x7f29e9aa2000, 2097152, PROT_NONE) = 0
mmap(0x7f29e9ca2000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x27000) = 0x7f29e9ca2000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f29eb408000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f29eb407000
arch_prctl(ARCH_SET_FS, 0x7f29eb4076f0) = 0
open("/dev/urandom", O_RDONLY)          = 3
read(3, "\326!_\271\3474;D", 8)         = 8
close(3)                                = 0
mprotect(0x7f29e9ca2000, 8192, PROT_READ) = 0
mprotect(0x7f29e9ed3000, 4096, PROT_READ) = 0
mprotect(0x7f29ea0e9000, 4096, PROT_READ) = 0
mprotect(0x7f29ea43c000, 16384, PROT_READ) = 0
mprotect(0x7f29ea69a000, 4096, PROT_READ) = 0
mprotect(0x7f29ea8b4000, 4096, PROT_READ) = 0
mprotect(0x7f29eaaf2000, 4096, PROT_READ) = 0
mprotect(0x7f29eadb6000, 4096, PROT_READ) = 0
mprotect(0x7f29eaffb000, 4096, PROT_READ) = 0
mprotect(0x7f29eb21d000, 4096, PROT_READ) = 0
mprotect(0x655000, 4096, PROT_READ)     = 0
mprotect(0x7f29eb43c000, 4096, PROT_READ) = 0
munmap(0x7f29eb40c000, 185059)          = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f29eb438000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f29eb437000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f29eb436000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f29eb435000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f29eb434000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f29eb433000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f29eb432000
brk(0)                                  = 0x65b000
brk(0x67c000)                           = 0x67c000
pipe([3, 4])                            = 0
chdir("/")                              = 0
clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7f29eb407780) = 5216
rt_sigaction(SIGCHLD, {0x413650, [CHLD], SA_RESTORER|SA_RESTART, 0x7f29ea11f6e0}, {SIG_DFL, [], 0}, 8) = 0
select(4, [3], NULL, [3], {250, 0})     = ? ERESTARTNOHAND (To be restarted)
--- SIGCHLD (Child exited) @ 0 (0) ---
rt_sigreturn(0x11)                      = -1 EINTR (Interrupted system call)
exit_group(1)                           = ?

--Boundary-00=_BtakJ5cJSr7HTBL--
