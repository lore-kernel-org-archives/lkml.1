Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbZANVUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbZANVUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZANVUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:20:14 -0500
Received: from mail.gmx.net ([213.165.64.20]:33474 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754333AbZANVUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:20:01 -0500
X-Authenticated: #4875094
X-Provags-ID: V01U2FsdGVkX18CZOgrzUsCEADc1SI92LdXWYb0npoR4yzhq3yyNk
	DA15RnxJfyXI0V
Message-ID: <496E56EB.2030301@gmx.de>
Date: Wed, 14 Jan 2009 22:19:39 +0100
From: wk <handygewinnspiel@gmx.de>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       rjw@sisk.pl, HWerner4@gmx.de, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mchehab@infradead.org
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
References: <20090112190420.51f75853@pedra.chehab.org>	 <20090112132130.6c932b85.akpm@linux-foundation.org>	 <20090112220624.4fbfee34@pedra.chehab.org>	 <20090112162337.318dd61d.akpm@linux-foundation.org>	 <20090113184755.87720@gmx.net>	 <20090113105947.9e774b69.akpm@linux-foundation.org>	 <20090113191757.74290@gmx.net>	 <20090113113700.776a94b5.akpm@linux-foundation.org>	 <20090113203843.GJ29283@parisc-linux.org> <1231957750.8269.28.camel@think.oraclecorp.com>
In-Reply-To: <1231957750.8269.28.camel@think.oraclecorp.com>
Content-Type: multipart/mixed;
 boundary="------------020008030406090103030808"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55,0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020008030406090103030808
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Chris Mason wrote:
> On Tue, 2009-01-13 at 13:38 -0700, Matthew Wilcox wrote:
>   
>> On Tue, Jan 13, 2009 at 11:37:00AM -0800, Andrew Morton wrote:
>>     
>>> I'd have expected to see stat() returning -EOVERFLOW, but it isn't there.
>>>
>>> googling around a bit seems to indcate that this might be a glibc issue:
>>>
>>> http://sourceware.org/bugzilla/show_bug.cgi?id=1864
>>> http://bugs.gentoo.org/show_bug.cgi?id=146951
>>>
>>> But the traces are all using stat64() and fstat64().  And why would it
>>> just start occurring now?
>>>       
>> Maybe glibc is using the 64-bit stat calls and returning -EOVERFLOW to
>> the application when the results from the kernel turn out to be > 32-bit
>> in size?
>>
>>     
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6c31b93a14a453c8756ffd228e24910ffdf30c5d
>
> I'd guess the commit above is related, although I don't see any way for
> it to make things interesting without the user doing mount -o inode64.
>
> strace -v should show us more, it would show if the inode numbers coming
> out of stat64 are big.
>
> -chris
>
>   
I cannot fully understand what strace -v outputs (see attachment), but 
what i see is that 'find' stops after finding a file with d_off = 4294967295
4294967295  =  0xFFFFFFFF, adding any number greater that zero will be 
greater that 32bits, so this could be the reason for the message "value 
too large".



I also noticed that i cannot access these files through samba if i boot 
from 2.6.28 - really strange.
If i reboot older kernels these are visible in samba again and fully 
accessible.

Attached the log from stracing the command which was ivoked by the 
Makefile from v4l-dvb.
I guess this is all i could contribute to that problem. Thats stuff for 
xfs filesystem experts now..

-Winfried





--------------020008030406090103030808
Content-Type: text/plain;
 name="find-4.1.20.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="find-4.1.20.log"

execve("/usr/src/findutils-4.1.20/find/find", ["/usr/src/findutils-4.1.20=
/find/f"..., "../linux/drivers/media", "-name", "*.[ch]", "-type", "f", "=
-print0"], ["TERM=3Dxterm", "SHELL=3D/bin/bash", "SSH_CLIENT=3D192.168.6.=
106 2197 22"..., "QTDIR=3D/opt/qt", "OLDPWD=3D/usr/src", "SSH_TTY=3D/dev/=
pts/0", "LC_ALL=3Dde_DE", "USER=3Droot", "LD_LIBRARY_PATH=3D/lib:/usr/lib=
:/u"..., "KDEDIR=3D/opt/kde",  "PATH=3D/usr/bin:/usr/sbin:/usr/loc"..., "=
INPUTRC=3D/etc/inputrc", "PWD=3D/usr/src/v4l-dvb-985ecd81d99"..., "LANG=3D=
de_DE", "SHLVL=3D1", "HOME=3D/root", "SSH_CONNECTION=3D192.168.6.106 219"=
=2E.., "PKG_CONFIG_PATH=3D/usr/lib/pkgconf"..., "_=3D/usr/bin/strace"]) =3D=
 0
uname({sysname=3D"Linux", nodename=3D"TopLap", release=3D"2.6.28", versio=
n=3D"#5 Mon Jan 12 19:58:18 CET 2009", machine=3D"i686"}) =3D 0
brk(0)                                  =3D 0x873c000
open("/etc/ld.so.preload", O_RDONLY)    =3D -1 ENOENT (No such file or di=
rectory)
open("/lib/tls/i686/libc.so.6", O_RDONLY) =3D -1 ENOENT (No such file or =
directory)
stat64("/lib/tls/i686", 0xbfbd4200)     =3D -1 ENOENT (No such file or di=
rectory)
open("/lib/tls/libc.so.6", O_RDONLY)    =3D -1 ENOENT (No such file or di=
rectory)
stat64("/lib/tls", 0xbfbd4200)          =3D -1 ENOENT (No such file or di=
rectory)
open("/lib/i686/libc.so.6", O_RDONLY)   =3D -1 ENOENT (No such file or di=
rectory)
stat64("/lib/i686", 0xbfbd4200)         =3D -1 ENOENT (No such file or di=
rectory)
open("/lib/libc.so.6", O_RDONLY)        =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0PK\1\000"..., 512=
) =3D 512
fstat64(3, {st_dev=3Dmakedev(3, 1), st_ino=3D46188823, st_mode=3DS_IFREG|=
0755, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
10312, st_size=3D5277124, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2005=
/06/04-01:45:19, st_ctime=3D2005/06/04-01:45:19}) =3D 0
mmap2(NULL, 1137644, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0=
) =3D 0xb7ea6000
mmap2(0xb7fb6000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_=
DENYWRITE, 3, 0x10f) =3D 0xb7fb6000
mmap2(0xb7fba000, 7148, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_A=
NONYMOUS, -1, 0) =3D 0xb7fba000
close(3)                                =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)=
 =3D 0xb7ea5000
mprotect(0xb7fb6000, 8192, PROT_READ)   =3D 0
mprotect(0xb7fd4000, 4096, PROT_READ)   =3D 0
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7ea54f0, limit:104857=
5, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_p=
resent:0, useable:1}) =3D 0
open("/usr/lib/locale/locale-archive", O_RDONLY|O_LARGEFILE) =3D 3
fstat64(3, {st_dev=3Dmakedev(3, 1), st_ino=3D29501697, st_mode=3DS_IFREG|=
0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
6232, st_size=3D3187264, st_atime=3D2009/01/14-21:15:55, st_mtime=3D2005/=
06/04-01:45:38, st_ctime=3D2005/06/04-01:45:38}) =3D 0
mmap2(NULL, 2097152, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0xb7ca5000
close(3)                                =3D 0
brk(0)                                  =3D 0x873c000
brk(0x875d000)                          =3D 0x875d000
brk(0)                                  =3D 0x875d000
time(NULL)                              =3D 1231964163
open(".", O_RDONLY|O_LARGEFILE)         =3D 3
fchdir(3)                               =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D61033319, st_mode=3DS_IFDI=
R|0755, st_nlink=3D6, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D8, st_size=3D4096, st_atime=3D2009/01/12-20:30:32, st_mtime=3D2009/01=
/14-21:14:45, st_ctime=3D2009/01/14-21:14:45}) =3D 0
lstat64("../linux/drivers/media", {st_dev=3Dmakedev(3, 1), st_ino=3D64507=
419, st_mode=3DS_IFDIR|0755, st_nlink=3D6, st_uid=3D0, st_gid=3D0, st_blk=
size=3D4096, st_blocks=3D0, st_size=3D141, st_atime=3D2009/01/14-21:15:55=
, st_mtime=3D2009/01/08-19:36:31, st_ctime=3D2009/01/08-19:36:31}) =3D 0
chdir("../linux/drivers/media")         =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D64507419, st_mode=3DS_IFDI=
R|0755, st_nlink=3D6, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D0, st_size=3D141, st_atime=3D2009/01/14-21:15:55, st_mtime=3D2009/01/=
08-19:36:31, st_ctime=3D2009/01/08-19:36:31}) =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D64507419, st_mode=3DS_IFDI=
R|0755, st_nlink=3D6, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D0, st_size=3D141, st_atime=3D2009/01/14-21:15:55, st_mtime=3D2009/01/=
08-19:36:31, st_ctime=3D2009/01/08-19:36:31}) =3D 0
open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D64507419, st_mode=3DS_IFDIR|=
0755, st_nlink=3D6, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
0, st_size=3D141, st_atime=3D2009/01/14-21:15:55, st_mtime=3D2009/01/08-1=
9:36:31, st_ctime=3D2009/01/08-19:36:31}) =3D 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         =3D 0
getdents64(4, {{d_ino=3D64507419, d_off=3D4, d_type=3DDT_DIR, d_reclen=3D=
24, d_name=3D"."} {d_ino=3D35039336, d_off=3D6, d_type=3DDT_DIR, d_reclen=
=3D24, d_name=3D".."} {d_ino=3D64507420, d_off=3D9, d_type=3DDT_UNKNOWN, =
d_reclen=3D32, d_name=3D"Kconfig"} {d_ino=3D64507421, d_off=3D12, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"Makefile"} {d_ino=3D68767839, d_off=3D=
15, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"common"} {d_ino=3D31581=
62, d_off=3D17, d_type=3DDT_UNKNOWN, d_reclen=3D24, d_name=3D"dvb"} {d_in=
o=3D48977814, d_off=3D19, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"r=
adio"} {d_ino=3D53193825, d_off=3D21, d_type=3DDT_UNKNOWN, d_reclen=3D32,=
 d_name=3D"video"} {d_ino=3D64570554, d_off=3D24, d_type=3DDT_UNKNOWN, d_=
reclen=3D32, d_name=3D"built-in.o"} {d_ino=3D64570555, d_off=3D28, d_type=
=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".built-in.o.cmd"} {d_ino=3D645839=
14, d_off=3D512, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"modules.or=
der"}}, 4096) =3D 344
getdents64(4, {}, 4096)                 =3D 0
close(4)                                =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D64507419, st_mode=3DS_IFDI=
R|0755, st_nlink=3D6, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D0, st_size=3D141, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01/=
08-19:36:31, st_ctime=3D2009/01/08-19:36:31}) =3D 0
lstat64("Kconfig", {st_dev=3Dmakedev(3, 1), st_ino=3D64507420, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D8, st_size=3D3391, st_atime=3D2009/01/08-18:34:03, st_mtime=3D2=
008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:05}) =3D 0
lstat64("Makefile", {st_dev=3Dmakedev(3, 1), st_ino=3D64507421, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D8, st_size=3D149, st_atime=3D2009/01/08-18:34:03, st_mtime=3D20=
08/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:05}) =3D 0
lstat64("common", {st_dev=3Dmakedev(3, 1), st_ino=3D68767839, st_mode=3DS=
_IFDIR|0755, st_nlink=3D3, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_=
blocks=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:15:55, st_mtime=3D20=
09/01/08-19:38:44, st_ctime=3D2009/01/08-19:38:44}) =3D 0
open("common", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D68767839, st_mode=3DS_IFDIR|=
0755, st_nlink=3D3, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
8, st_size=3D4096, st_atime=3D2009/01/14-21:15:55, st_mtime=3D2009/01/08-=
19:38:44, st_ctime=3D2009/01/08-19:38:44}) =3D 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         =3D 0
getdents64(4, {{d_ino=3D68767839, d_off=3D4, d_type=3DDT_UNKNOWN, d_recle=
n=3D24, d_name=3D"."} {d_ino=3D64507419, d_off=3D6, d_type=3DDT_UNKNOWN, =
d_reclen=3D24, d_name=3D".."} {d_ino=3D68769536, d_off=3D9, d_type=3DDT_U=
NKNOWN, d_reclen=3D32, d_name=3D"Kconfig"} {d_ino=3D68769537, d_off=3D12,=
 d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"Makefile"} {d_ino=3D687695=
38, d_off=3D16, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"ir-function=
s.c"} {d_ino=3D68769539, d_off=3D19, d_type=3DDT_UNKNOWN, d_reclen=3D32, =
d_name=3D"ir-keymaps.c"} {d_ino=3D68769540, d_off=3D23, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D"saa7146_core.c"} {d_ino=3D68769541, d_off=3D=
27, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"saa7146_fops.c"} {d_ino=
=3D68769542, d_off=3D30, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"sa=
a7146_hlp.c"} {d_ino=3D68769543, d_off=3D33, d_type=3DDT_UNKNOWN, d_recle=
n=3D40, d_name=3D"saa7146_i2c.c"} {d_ino=3D68769544, d_off=3D36, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D"saa7146_vbi.c"} {d_ino=3D68769545, d=
_off=3D40, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"saa7146_video.c"=
} {d_ino=3D72929321, d_off=3D43, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_na=
me=3D"tuners"} {d_ino=3D68801740, d_off=3D46, d_type=3DDT_UNKNOWN, d_recl=
en=3D32, d_name=3D"built-in.o"} {d_ino=3D68801741, d_off=3D62, d_type=3DD=
T_UNKNOWN, d_reclen=3D40, d_name=3D".built-in.o.cmd"} {d_ino=3D68804149, =
d_off=3D70, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"ir-functions.o"=
} {d_ino=3D68804146, d_off=3D86, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_na=
me=3D".ir-functions.o.cmd"} {d_ino=3D68804151, d_off=3D93, d_type=3DDT_UN=
KNOWN, d_reclen=3D32, d_name=3D"ir-keymaps.o"} {d_ino=3D68804147, d_off=3D=
105, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".ir-keymaps.o.cmd"} {d=
_ino=3D68804148, d_off=3D112, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
"saa7146_i2c.o"} {d_ino=3D68804152, d_off=3D128, d_type=3DDT_UNKNOWN, d_r=
eclen=3D40, d_name=3D".saa7146_i2c.o.cmd"} {d_ino=3D68804155, d_off=3D136=
, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"saa7146_core.o"} {d_ino=3D=
68804150, d_off=3D152, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".saa=
7146_core.o.cmd"} {d_ino=3D68804157, d_off=3D160, d_type=3DDT_UNKNOWN, d_=
reclen=3D40, d_name=3D"saa7146_fops.o"} {d_ino=3D68804153, d_off=3D177, d=
_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".saa7146_fops.o.cmd"} {d_ino=
=3D68804159, d_off=3D185, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"s=
aa7146_video.o"} {d_ino=3D68804154, d_off=3D201, d_type=3DDT_UNKNOWN, d_r=
eclen=3D40, d_name=3D".saa7146_video.o.cmd"} {d_ino=3D68804161, d_off=3D2=
08, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"saa7146_hlp.o"} {d_ino=3D=
68804156, d_off=3D220, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".saa=
7146_hlp.o.cmd"} {d_ino=3D68804158, d_off=3D227, d_type=3DDT_UNKNOWN, d_r=
eclen=3D40, d_name=3D"saa7146_vbi.o"} {d_ino=3D68804162, d_off=3D231, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".saa7146_vbi.o.cmd"} {d_ino=3D=
68804160, d_off=3D234, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"saa7=
146.o"} {d_ino=3D68804163, d_off=3D238, d_type=3DDT_UNKNOWN, d_reclen=3D4=
0, d_name=3D".saa7146.o.cmd"} {d_ino=3D68804164, d_off=3D241, d_type=3DDT=
_UNKNOWN, d_reclen=3D32, d_name=3D"saa7146_vv.o"} {d_ino=3D68804165, d_of=
f=3D245, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".saa7146_vv.o.cmd"=
} {d_ino=3D68804166, d_off=3D248, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_n=
ame=3D"ir-common.o"} {d_ino=3D68804167, d_off=3D252, d_type=3DDT_UNKNOWN,=
 d_reclen=3D40, d_name=3D".ir-common.o.cmd"} {d_ino=3D68804168, d_off=3D2=
55, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"modules.order"} {d_ino=3D=
68808070, d_off=3D259, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"saa7=
146_vv.mod.c"} {d_ino=3D68808071, d_off=3D262, d_type=3DDT_UNKNOWN, d_rec=
len=3D40, d_name=3D"saa7146.mod.c"} {d_ino=3D68808072, d_off=3D266, d_typ=
e=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"ir-common.mod.c"} {d_ino=3D68808=
078, d_off=3D278, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"ir-common=
=2Emod.o"} {d_ino=3D68808080, d_off=3D282, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D".ir-common.mod.o.cmd"} {d_ino=3D68808079, d_off=3D285, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"ir-common.ko"} {d_ino=3D6880808=
1, d_off=3D289, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".ir-common.=
ko.cmd"} {d_ino=3D68808082, d_off=3D300, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D"saa7146.mod.o"} {d_ino=3D68808084, d_off=3D304, d_type=3DDT=
_UNKNOWN, d_reclen=3D40, d_name=3D".saa7146.mod.o.cmd"} {d_ino=3D68808083=
, d_off=3D307, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"saa7146.ko"}=
 {d_ino=3D68808085, d_off=3D311, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_na=
me=3D".saa7146.ko.cmd"} {d_ino=3D68808086, d_off=3D323, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D"saa7146_vv.mod.o"} {d_ino=3D68808088, d_off=3D=
327, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D".saa7146_vv.mod.o.cmd"=
} {d_ino=3D68808087, d_off=3D330, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_n=
ame=3D"saa7146_vv.ko"} {d_ino=3D68808089, d_off=3D512, d_type=3DDT_UNKNOW=
N, d_reclen=3D40, d_name=3D".saa7146_vv.ko.cmd"}}, 4096) =3D 2008
getdents64(4, {}, 4096)                 =3D 0
close(4)                                =3D 0
chdir("common")                         =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D68767839, st_mode=3DS_IFDI=
R|0755, st_nlink=3D3, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01=
/08-19:38:44, st_ctime=3D2009/01/08-19:38:44}) =3D 0
lstat64("Kconfig", {st_dev=3Dmakedev(3, 1), st_ino=3D68769536, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D8, st_size=3D158, st_atime=3D2009/01/08-18:34:03, st_mtime=3D20=
08/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:05}) =3D 0
lstat64("Makefile", {st_dev=3Dmakedev(3, 1), st_ino=3D68769537, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D8, st_size=3D317, st_atime=3D2009/01/08-18:34:03, st_mtime=3D20=
08/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:05}) =3D 0
lstat64("ir-functions.c", {st_dev=3Dmakedev(3, 1), st_ino=3D68769538, st_=
mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4=
096, st_blocks=3D24, st_size=3D8506, st_atime=3D2009/01/08-18:34:03, st_m=
time=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:05}) =3D 0
fstat64(1, {st_dev=3Dmakedev(0, 9), st_ino=3D2, st_mode=3DS_IFCHR|0620, s=
t_nlink=3D1, st_uid=3D0, st_gid=3D4, st_blksize=3D1024, st_blocks=3D0, st=
_rdev=3Dmakedev(136, 0), st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/=
01/14-21:16:03, st_ctime=3D2009/01/14-20:01:53}) =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)=
 =3D 0xb7ca4000
lstat64("ir-keymaps.c", {st_dev=3Dmakedev(3, 1), st_ino=3D68769539, st_mo=
de=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D409=
6, st_blocks=3D136, st_size=3D66130, st_atime=3D2009/01/08-18:34:03, st_m=
time=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:05}) =3D 0
lstat64("saa7146_core.c", {st_dev=3Dmakedev(3, 1), st_ino=3D68769540, st_=
mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4=
096, st_blocks=3D32, st_size=3D15238, st_atime=3D2009/01/08-18:34:03, st_=
mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:05}) =3D 0
lstat64("saa7146_fops.c", {st_dev=3Dmakedev(3, 1), st_ino=3D68769541, st_=
mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4=
096, st_blocks=3D32, st_size=3D15207, st_atime=3D2009/01/08-18:34:03, st_=
mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:05}) =3D 0
lstat64("saa7146_hlp.c", {st_dev=3Dmakedev(3, 1), st_ino=3D68769542, st_m=
ode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D40=
96, st_blocks=3D64, st_size=3D30652, st_atime=3D2009/01/08-18:34:03, st_m=
time=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:05}) =3D 0
lstat64("saa7146_i2c.c", {st_dev=3Dmakedev(3, 1), st_ino=3D68769543, st_m=
ode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D40=
96, st_blocks=3D32, st_size=3D13026, st_atime=3D2009/01/08-18:34:03, st_m=
time=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:05}) =3D 0
lstat64("saa7146_vbi.c", {st_dev=3Dmakedev(3, 1), st_ino=3D68769544, st_m=
ode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D40=
96, st_blocks=3D32, st_size=3D14273, st_atime=3D2009/01/08-18:34:03, st_m=
time=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:05}) =3D 0
lstat64("saa7146_video.c", {st_dev=3Dmakedev(3, 1), st_ino=3D68769545, st=
_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D80, st_size=3D37068, st_atime=3D2009/01/08-18:34:03, st=
_mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:05}) =3D 0
lstat64("tuners", {st_dev=3Dmakedev(3, 1), st_ino=3D72929321, st_mode=3DS=
_IFDIR|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_=
blocks=3D24, st_size=3D8192, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2=
009/01/12-20:03:28, st_ctime=3D2009/01/12-20:03:28}) =3D 0
open("tuners", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D72929321, st_mode=3DS_IFDIR|=
0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
24, st_size=3D8192, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2009/01/12=
-20:03:28, st_ctime=3D2009/01/12-20:03:28}) =3D 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         =3D 0
getdents64(4, {{d_ino=3D72929321, d_off=3D4, d_type=3DDT_UNKNOWN, d_recle=
n=3D24, d_name=3D"."} {d_ino=3D68767839, d_off=3D6, d_type=3DDT_UNKNOWN, =
d_reclen=3D24, d_name=3D".."} {d_ino=3D72929322, d_off=3D9, d_type=3DDT_U=
NKNOWN, d_reclen=3D32, d_name=3D"Kconfig"} {d_ino=3D72929323, d_off=3D12,=
 d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"Makefile"} {d_ino=3D729293=
24, d_off=3D15, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mt2060.c"} =
{d_ino=3D72929325, d_off=3D18, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=
=3D"mt2060.h"} {d_ino=3D72929326, d_off=3D21, d_type=3DDT_UNKNOWN, d_recl=
en=3D40, d_name=3D"mt2060_priv.h"} {d_ino=3D72929327, d_off=3D24, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"mt20xx.c"} {d_ino=3D72929328, d_off=3D=
27, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mt20xx.h"} {d_ino=3D729=
29329, d_off=3D30, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mt2131.c=
"} {d_ino=3D72929330, d_off=3D33, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_n=
ame=3D"mt2131.h"} {d_ino=3D72929331, d_off=3D36, d_type=3DDT_UNKNOWN, d_r=
eclen=3D40, d_name=3D"mt2131_priv.h"} {d_ino=3D72929332, d_off=3D39, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mt2266.c"} {d_ino=3D72929333, d=
_off=3D42, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mt2266.h"} {d_in=
o=3D72929334, d_off=3D45, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"m=
xl5005s.c"} {d_ino=3D72929335, d_off=3D48, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"mxl5005s.h"} {d_ino=3D72929336, d_off=3D51, d_type=3DDT_UNK=
NOWN, d_reclen=3D32, d_name=3D"mxl5007t.c"} {d_ino=3D72929337, d_off=3D54=
, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mxl5007t.h"} {d_ino=3D729=
29338, d_off=3D57, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"qt1010.c=
"} {d_ino=3D72929339, d_off=3D60, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_n=
ame=3D"qt1010.h"} {d_ino=3D72929340, d_off=3D63, d_type=3DDT_UNKNOWN, d_r=
eclen=3D40, d_name=3D"qt1010_priv.h"} {d_ino=3D72929341, d_off=3D67, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tda18271-common.c"} {d_ino=3D72=
929342, d_off=3D70, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tda1827=
1-fe.c"} {d_ino=3D72929343, d_off=3D74, d_type=3DDT_UNKNOWN, d_reclen=3D4=
0, d_name=3D"tda18271-maps.c"} {d_ino=3D72931424, d_off=3D78, d_type=3DDT=
_UNKNOWN, d_reclen=3D40, d_name=3D"tda18271-priv.h"} {d_ino=3D72931425, d=
_off=3D81, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda18271.h"} {d_=
ino=3D72931426, d_off=3D84, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"tda827x.c"} {d_ino=3D72931427, d_off=3D87, d_type=3DDT_UNKNOWN, d_reclen=
=3D32, d_name=3D"tda827x.h"} {d_ino=3D72931428, d_off=3D90, d_type=3DDT_U=
NKNOWN, d_reclen=3D32, d_name=3D"tda8290.c"} {d_ino=3D72931429, d_off=3D9=
3, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda8290.h"} {d_ino=3D729=
31430, d_off=3D96, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda9887.=
c"} {d_ino=3D72931431, d_off=3D99, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_=
name=3D"tda9887.h"} {d_ino=3D72931432, d_off=3D102, d_type=3DDT_UNKNOWN, =
d_reclen=3D32, d_name=3D"tea5761.c"} {d_ino=3D72931433, d_off=3D105, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tea5761.h"} {d_ino=3D72931434, =
d_off=3D108, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tea5767.c"} {d=
_ino=3D72931435, d_off=3D111, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"tea5767.h"} {d_ino=3D72931436, d_off=3D114, d_type=3DDT_UNKNOWN, d_recle=
n=3D32, d_name=3D"tuner-i2c.h"} {d_ino=3D72931437, d_off=3D118, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D"tuner-simple.c"} {d_ino=3D72931438, =
d_off=3D122, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tuner-simple.h=
"} {d_ino=3D72931439, d_off=3D125, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_=
name=3D"tuner-types.c"} {d_ino=3D72931440, d_off=3D129, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D"tuner-xc2028-types.h"} {d_ino=3D72931441, d_=
off=3D133, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tuner-xc2028.c"}=
 {d_ino=3D72931442, d_off=3D137, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_na=
me=3D"tuner-xc2028.h"} {d_ino=3D72931443, d_off=3D140, d_type=3DDT_UNKNOW=
N, d_reclen=3D32, d_name=3D"xc5000.c"} {d_ino=3D72931444, d_off=3D143, d_=
type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"xc5000.h"} {d_ino=3D72962935,=
 d_off=3D146, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"built-in.o"} =
{d_ino=3D72962936, d_off=3D150, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_nam=
e=3D".built-in.o.cmd"} {d_ino=3D72971076, d_off=3D153, d_type=3DDT_UNKNOW=
N, d_reclen=3D40, d_name=3D".xc5000.o.cmd"} {d_ino=3D72975470, d_off=3D15=
7, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tuner-simple.mod.c"} {d_=
ino=3D72977907, d_off=3D161, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
".tda9887.ko.cmd"} {d_ino=3D72971045, d_off=3D165, d_type=3DDT_UNKNOWN, d=
_reclen=3D40, d_name=3D"tuner-xc2028.o"} {d_ino=3D72977906, d_off=3D170, =
d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tea5767.mod.o"} {d_ino=3D72=
971056, d_off=3D174, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tuner=
-xc2028.o.cmd"} {d_ino=3D72971089, d_off=3D177, d_type=3DDT_UNKNOWN, d_re=
clen=3D40, d_name=3D"modules.order"} {d_ino=3D72975471, d_off=3D180, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tea5767.mod.c"} {d_ino=3D729779=
24, d_off=3D183, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"xc5000.ko"=
} {d_ino=3D72971049, d_off=3D187, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_n=
ame=3D"tuner-simple.o"} {d_ino=3D72971059, d_off=3D190, d_type=3DDT_UNKNO=
WN, d_reclen=3D32, d_name=3D"mt20xx.o"} {d_ino=3D72977908, d_off=3D194, d=
_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tea5767.ko"} {d_ino=3D729710=
62, d_off=3D198, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tuner-sim=
ple.o.cmd"} {d_ino=3D72971085, d_off=3D201, d_type=3DDT_UNKNOWN, d_reclen=
=3D40, d_name=3D"tda8290.mod.o"} {d_ino=3D72975472, d_off=3D204, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D"tea5761.mod.c"} {d_ino=3D72977903, d=
_off=3D208, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda8290.ko.cmd=
"} {d_ino=3D72971055, d_off=3D213, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_=
name=3D"tuner-types.o"} {d_ino=3D72977915, d_off=3D217, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D".tea5767.ko.cmd"} {d_ino=3D72971064, d_off=3D=
221, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tuner-types.o.cmd"} {=
d_ino=3D72975469, d_off=3D225, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=
=3D"tuner-types.mod.c"} {d_ino=3D72975481, d_off=3D229, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D".tda8290.mod.o.cmd"} {d_ino=3D72971061, d_of=
f=3D232, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tea5767.o"} {d_ino=
=3D72971063, d_off=3D237, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"t=
ea5761.o"} {d_ino=3D72971066, d_off=3D240, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D".mt20xx.o.cmd"} {d_ino=3D72971087, d_off=3D244, d_type=3DDT=
_UNKNOWN, d_reclen=3D40, d_name=3D".mxl5005s.o.cmd"} {d_ino=3D72977899, d=
_off=3D248, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda827x.ko.cmd=
"} {d_ino=3D72971071, d_off=3D251, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_=
name=3D"mt20xx.ko"} {d_ino=3D72975480, d_off=3D254, d_type=3DDT_UNKNOWN, =
d_reclen=3D32, d_name=3D"tda8290.ko"} {d_ino=3D72977909, d_off=3D258, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tea5767.mod.o.cmd"} {d_ino=3D=
72971068, d_off=3D262, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda=
8290.o.cmd"} {d_ino=3D72971090, d_off=3D265, d_type=3DDT_UNKNOWN, d_recle=
n=3D32, d_name=3D"mt2131.o"} {d_ino=3D72977892, d_off=3D269, d_type=3DDT_=
UNKNOWN, d_reclen=3D40, d_name=3D"tda18271.mod.o"} {d_ino=3D72977910, d_o=
ff=3D273, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tuner-simple.mod.=
o"} {d_ino=3D72971067, d_off=3D276, d_type=3DDT_UNKNOWN, d_reclen=3D32, d=
_name=3D"xc5000.o"} {d_ino=3D72977919, d_off=3D280, d_type=3DDT_UNKNOWN, =
d_reclen=3D40, d_name=3D".tuner-simple.ko.cmd"} {d_ino=3D72971070, d_off=3D=
284, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tea5767.o.cmd"} {d_in=
o=3D72975467, d_off=3D287, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"=
xc5000.mod.c"} {d_ino=3D72977893, d_off=3D293, d_type=3DDT_UNKNOWN, d_rec=
len=3D32, d_name=3D"tda18271.ko"} {d_ino=3D72971065, d_off=3D296, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"tda9887.o"} {d_ino=3D72977912, d_off=
=3D302, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tuner-simple.ko"} {=
d_ino=3D72971072, d_off=3D306, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=
=3D".tea5761.o.cmd"} {d_ino=3D72971092, d_off=3D309, d_type=3DDT_UNKNOWN,=
 d_reclen=3D32, d_name=3D"mxl5005s.o"} {d_ino=3D72977895, d_off=3D313, d_=
type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda18271.ko.cmd"} {d_ino=3D7=
2977914, d_off=3D317, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tuner=
-types.mod.o"} {d_ino=3D72975482, d_off=3D320, d_type=3DDT_UNKNOWN, d_rec=
len=3D40, d_name=3D"tda9887.mod.o"} {d_ino=3D72977923, d_off=3D324, d_typ=
e=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tuner-types.ko.cmd"} {d_ino=3D7=
2971074, d_off=3D328, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda9=
887.o.cmd"} {d_ino=3D72975468, d_off=3D332, d_type=3DDT_UNKNOWN, d_reclen=
=3D40, d_name=3D"tuner-xc2028.mod.c"} {d_ino=3D72977916, d_off=3D339, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tuner-types.ko"} {d_ino=3D7297=
1078, d_off=3D342, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda827x.=
o"} {d_ino=3D72977918, d_off=3D346, d_type=3DDT_UNKNOWN, d_reclen=3D40, d=
_name=3D"tuner-xc2028.mod.o"} {d_ino=3D72971073, d_off=3D350, d_type=3DDT=
_UNKNOWN, d_reclen=3D40, d_name=3D".tda827x.o.cmd"} {d_ino=3D72977894, d_=
off=3D354, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda18271.mod.o.=
cmd"} {d_ino=3D72977927, d_off=3D358, d_type=3DDT_UNKNOWN, d_reclen=3D40,=
 d_name=3D".tuner-xc2028.ko.cmd"} {d_ino=3D72971075, d_off=3D362, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D"tda18271-maps.o"} {d_ino=3D72977920,=
 d_off=3D366, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tuner-xc2028.=
ko"} {d_ino=3D72971079, d_off=3D370, d_type=3DDT_UNKNOWN, d_reclen=3D40, =
d_name=3D".tda18271-maps.o.cmd"} {d_ino=3D72975473, d_off=3D373, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D"tda9887.mod.c"} {d_ino=3D72977900, d=
_off=3D379, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda9887.ko"} {d=
_ino=3D72971077, d_off=3D383, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
"tda18271-common.o"} {d_ino=3D72977902, d_off=3D388, d_type=3DDT_UNKNOWN,=
 d_reclen=3D40, d_name=3D"tea5761.mod.o"} {d_ino=3D72971081, d_off=3D393,=
 d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D".tda18271-common.o.cmd"} {=
d_ino=3D72971086, d_off=3D396, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=
=3D".mt2131.o.cmd"} {d_ino=3D72975474, d_off=3D399, d_type=3DDT_UNKNOWN, =
d_reclen=3D40, d_name=3D"tda8290.mod.c"} {d_ino=3D72977901, d_off=3D405, =
d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda9887.mod.o.cmd"}}, 4096=
) =3D 4088
getdents64(4, {{d_ino=3D72971084, d_off=3D408, d_type=3DDT_UNKNOWN, d_rec=
len=3D40, d_name=3D"tda18271-fe.o"} {d_ino=3D72977922, d_off=3D412, d_typ=
e=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"xc5000.mod.o"} {d_ino=3D72971080=
, d_off=3D416, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda18271-fe=
=2Eo.cmd"} {d_ino=3D72971082, d_off=3D419, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"tda18271.o"} {d_ino=3D72971083, d_off=3D423, d_type=3DDT_UN=
KNOWN, d_reclen=3D40, d_name=3D".tda18271.o.cmd"} {d_ino=3D72975475, d_of=
f=3D426, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tda827x.mod.c"} {d=
_ino=3D72975476, d_off=3D430, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
"tda18271.mod.c"} {d_ino=3D72975477, d_off=3D434, d_type=3DDT_UNKNOWN, d_=
reclen=3D40, d_name=3D"mxl5005s.mod.c"} {d_ino=3D72975478, d_off=3D437, d=
_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mt2131.mod.c"} {d_ino=3D7297=
5479, d_off=3D440, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mt20xx.m=
od.c"} {d_ino=3D72971069, d_off=3D443, d_type=3DDT_UNKNOWN, d_reclen=3D32=
, d_name=3D"mt20xx.mod.o"} {d_ino=3D72977896, d_off=3D446, d_type=3DDT_UN=
KNOWN, d_reclen=3D40, d_name=3D"tda827x.mod.o"} {d_ino=3D72977905, d_off=3D=
451, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tea5761.mod.o.cmd"} {=
d_ino=3D72971088, d_off=3D455, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=
=3D".mt20xx.mod.o.cmd"} {d_ino=3D72971060, d_off=3D458, d_type=3DDT_UNKNO=
WN, d_reclen=3D32, d_name=3D"tda8290.o"} {d_ino=3D72975483, d_off=3D462, =
d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".mt20xx.ko.cmd"} {d_ino=3D7=
2975484, d_off=3D465, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mt213=
1.mod.o"} {d_ino=3D72977898, d_off=3D469, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D".tda827x.mod.o.cmd"} {d_ino=3D72977925, d_off=3D473, d_type=
=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".xc5000.mod.o.cmd"} {d_ino=3D7297=
5486, d_off=3D477, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".mt2131.=
mod.o.cmd"} {d_ino=3D72975485, d_off=3D480, d_type=3DDT_UNKNOWN, d_reclen=
=3D32, d_name=3D"mt2131.ko"} {d_ino=3D72975487, d_off=3D484, d_type=3DDT_=
UNKNOWN, d_reclen=3D40, d_name=3D".mt2131.ko.cmd"} {d_ino=3D72977888, d_o=
ff=3D488, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"mxl5005s.mod.o"} =
{d_ino=3D72977897, d_off=3D491, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_nam=
e=3D"tda827x.ko"} {d_ino=3D72977904, d_off=3D496, d_type=3DDT_UNKNOWN, d_=
reclen=3D32, d_name=3D"tea5761.ko"} {d_ino=3D72977890, d_off=3D500, d_typ=
e=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".mxl5005s.mod.o.cmd"} {d_ino=3D7=
2977889, d_off=3D503, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mxl50=
05s.ko"} {d_ino=3D72977891, d_off=3D507, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D".mxl5005s.ko.cmd"} {d_ino=3D72977911, d_off=3D519, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D".tea5761.ko.cmd"} {d_ino=3D72977913,=
 d_off=3D529, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D".tuner-simple=
=2Emod.o.cmd"} {d_ino=3D72977917, d_off=3D539, d_type=3DDT_UNKNOWN, d_rec=
len=3D48, d_name=3D".tuner-types.mod.o.cmd"} {d_ino=3D72977921, d_off=3D5=
44, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D".tuner-xc2028.mod.o.cmd=
"} {d_ino=3D72977931, d_off=3D4294967295, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D".xc5000.ko.cmd"}}, 4096) =3D 1256
_llseek(4, 544, [544], SEEK_SET)        =3D 0
getdents64(4, {{d_ino=3D72977931, d_off=3D4294967295, d_type=3DDT_UNKNOWN=
, d_reclen=3D40, d_name=3D".xc5000.ko.cmd"}}, 4096) =3D 40
close(4)                                =3D 0
write(1, "../linux/drivers/media/common/ir"..., 356) =3D 356
write(2, "/usr/src/findutils-4.1.20/find/f"..., 37) =3D 37
write(2, "../linux/drivers/media/common/tu"..., 36) =3D 36
open("/usr/share/locale/locale.alias", O_RDONLY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D50401633, st_mode=3DS_IFREG|=
0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
8, st_size=3D2586, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2005/06/04-=
01:43:07, st_ctime=3D2005/06/04-01:43:07}) =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)=
 =3D 0xb7ca3000
read(4, "# Locale name alias data base.\n#"..., 4096) =3D 2586
read(4, "", 4096)                       =3D 0
close(4)                                =3D 0
munmap(0xb7ca3000, 4096)                =3D 0
open("/usr/share/locale/de_DE/LC_MESSAGES/libc.mo", O_RDONLY) =3D -1 ENOE=
NT (No such file or directory)
open("/usr/share/locale/de/LC_MESSAGES/libc.mo", O_RDONLY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D33633140, st_mode=3DS_IFREG|=
0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
176, st_size=3D90059, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2005/06/=
04-01:44:16, st_ctime=3D2005/06/04-01:44:16}) =3D 0
mmap2(NULL, 90059, PROT_READ, MAP_PRIVATE, 4, 0) =3D 0xb7c8e000
close(4)                                =3D 0
open("/usr/lib/gconv/gconv-modules.cache", O_RDONLY) =3D -1 ENOENT (No su=
ch file or directory)
open("/usr/lib/gconv/gconv-modules", O_RDONLY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D12640048, st_mode=3DS_IFREG|=
0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
96, st_size=3D45501, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2005/06/0=
4-01:42:34, st_ctime=3D2005/06/04-01:42:34}) =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)=
 =3D 0xb7c8d000
read(4, "# GNU libc iconv configuration.\n"..., 4096) =3D 4096
read(4, "lias\tJS//\t\t\tJUS_I.B1.002//\nalias"..., 4096) =3D 4096
read(4, "ule\tINTERNAL\t\tISO-8859-3//\t\tISO8"..., 4096) =3D 4096
read(4, "s\tLATIN8//\t\tISO-8859-14//\nalias\t"..., 4096) =3D 4096
read(4, "/\t\tEBCDIC-ES//\nalias\tEBCDICES//\t"..., 4096) =3D 4096
read(4, "ias\tEBCDIC-CP-ES//\t\tIBM284//\nali"..., 4096) =3D 4096
read(4, "\tIBM864//\nalias\tCSIBM864//\t\tIBM8"..., 4096) =3D 4096
read(4, "module\tINTERNAL\t\tIBM937//\t\tIBM93"..., 4096) =3D 4096
read(4, "ule\tEUC-JP//\t\tINTERNAL\t\tEUC-JP\t\t"..., 4096) =3D 4096
read(4, "/\tIEC_P27-1//\nalias\tIEC_P271//\t\t"..., 4096) =3D 4096
read(4, "ERNAL\t\tISO_10367-BOX//\t\tISO_1036"..., 4096) =3D 4096
read(4, "le\t\tcost\nmodule\tShift_JISX0213//"..., 4096) =3D 445
read(4, "", 4096)                       =3D 0
close(4)                                =3D 0
munmap(0xb7c8d000, 4096)                =3D 0
write(2, ": Der Wert ist zu gro\337 f\374r den d"..., 51) =3D 51
write(2, "\n", 1)                       =3D 1
lstat64("saa7146_vv.mod.c", {st_dev=3Dmakedev(3, 1), st_ino=3D68808070, s=
t_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D8, st_size=3D3114, st_atime=3D2009/01/08-19:38:44, st_m=
time=3D2009/01/08-19:38:27, st_ctime=3D2009/01/08-19:38:27}) =3D 0
lstat64("saa7146.mod.c", {st_dev=3Dmakedev(3, 1), st_ino=3D68808071, st_m=
ode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D40=
96, st_blocks=3D8, st_size=3D2149, st_atime=3D2009/01/08-19:38:44, st_mti=
me=3D2009/01/08-19:38:27, st_ctime=3D2009/01/08-19:38:27}) =3D 0
lstat64("ir-common.mod.c", {st_dev=3Dmakedev(3, 1), st_ino=3D68808072, st=
_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D8, st_size=3D791, st_atime=3D2009/01/08-19:38:44, st_mt=
ime=3D2009/01/08-19:38:27, st_ctime=3D2009/01/08-19:38:27}) =3D 0
chdir("..")                             =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D64507419, st_mode=3DS_IFDI=
R|0755, st_nlink=3D6, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D0, st_size=3D141, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01/=
08-19:36:31, st_ctime=3D2009/01/08-19:36:31}) =3D 0
lstat64("dvb", {st_dev=3Dmakedev(3, 1), st_ino=3D3158162, st_mode=3DS_IFD=
IR|0755, st_nlink=3D13, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blo=
cks=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2009/=
01/08-19:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
open("dvb", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D3158162, st_mode=3DS_IFDIR|0=
755, st_nlink=3D13, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
8, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2009/01/08-=
19:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         =3D 0
getdents64(4, {{d_ino=3D3158162, d_off=3D4, d_type=3DDT_UNKNOWN, d_reclen=
=3D24, d_name=3D"."} {d_ino=3D64507419, d_off=3D6, d_type=3DDT_UNKNOWN, d=
_reclen=3D24, d_name=3D".."} {d_ino=3D3158163, d_off=3D9, d_type=3DDT_UNK=
NOWN, d_reclen=3D32, d_name=3D"Kconfig"} {d_ino=3D3158164, d_off=3D12, d_=
type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"Makefile"} {d_ino=3D3158165, =
d_off=3D14, d_type=3DDT_UNKNOWN, d_reclen=3D24, d_name=3D"b2c2"} {d_ino=3D=
6862927, d_off=3D16, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"bt8xx"=
} {d_ino=3D9948257, d_off=3D19, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_nam=
e=3D"dm1105"} {d_ino=3D15629739, d_off=3D22, d_type=3DDT_UNKNOWN, d_recle=
n=3D32, d_name=3D"dvb-core"} {d_ino=3D19537968, d_off=3D25, d_type=3DDT_U=
NKNOWN, d_reclen=3D32, d_name=3D"dvb-usb"} {d_ino=3D22601094, d_off=3D28,=
 d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"frontends"} {d_ino=3D31869=
976, d_off=3D31, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"pluto2"} {=
d_ino=3D31869980, d_off=3D33, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"siano"} {d_ino=3D35036777, d_off=3D35, d_type=3DDT_UNKNOWN, d_reclen=3D3=
2, d_name=3D"ttpci"} {d_ino=3D41058301, d_off=3D38, d_type=3DDT_UNKNOWN, =
d_reclen=3D32, d_name=3D"ttusb-budget"} {d_ino=3D43812597, d_off=3D41, d_=
type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"ttusb-dec"} {d_ino=3D3204243,=
 d_off=3D44, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"built-in.o"} {=
d_ino=3D3204244, d_off=3D48, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
".built-in.o.cmd"} {d_ino=3D3216983, d_off=3D512, d_type=3DDT_UNKNOWN, d_=
reclen=3D40, d_name=3D"modules.order"}}, 4096) =3D 568
getdents64(4, {}, 4096)                 =3D 0
close(4)                                =3D 0
chdir("dvb")                            =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D3158162, st_mode=3DS_IFDIR=
|0755, st_nlink=3D13, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01=
/08-19:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
lstat64("Kconfig", {st_dev=3Dmakedev(3, 1), st_ino=3D3158163, st_mode=3DS=
_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_=
blocks=3D8, st_size=3D1184, st_atime=3D2009/01/08-18:34:03, st_mtime=3D20=
08/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("Makefile", {st_dev=3Dmakedev(3, 1), st_ino=3D3158164, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D8, st_size=3D172, st_atime=3D2009/01/08-18:34:03, st_mtime=3D20=
08/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("b2c2", {st_dev=3Dmakedev(3, 1), st_ino=3D3158165, st_mode=3DS_IF=
DIR|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blo=
cks=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2009/=
01/08-19:38:48, st_ctime=3D2009/01/08-19:38:48}) =3D 0
open("b2c2", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D3158165, st_mode=3DS_IFDIR|0=
755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
8, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2009/01/08-=
19:38:48, st_ctime=3D2009/01/08-19:38:48}) =3D 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         =3D 0
getdents64(4, {{d_ino=3D3158165, d_off=3D4, d_type=3DDT_UNKNOWN, d_reclen=
=3D24, d_name=3D"."} {d_ino=3D3158162, d_off=3D6, d_type=3DDT_UNKNOWN, d_=
reclen=3D24, d_name=3D".."} {d_ino=3D3158166, d_off=3D9, d_type=3DDT_UNKN=
OWN, d_reclen=3D32, d_name=3D"Kconfig"} {d_ino=3D3158167, d_off=3D12, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"Makefile"} {d_ino=3D3158168, d=
_off=3D16, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"flexcop-common.h=
"} {d_ino=3D3158169, d_off=3D19, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_na=
me=3D"flexcop-dma.c"} {d_ino=3D3158170, d_off=3D23, d_type=3DDT_UNKNOWN, =
d_reclen=3D40, d_name=3D"flexcop-eeprom.c"} {d_ino=3D3158171, d_off=3D27,=
 d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"flexcop-fe-tuner.c"} {d_in=
o=3D3158172, d_off=3D31, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"fl=
excop-hw-filter.c"} {d_ino=3D3158173, d_off=3D34, d_type=3DDT_UNKNOWN, d_=
reclen=3D40, d_name=3D"flexcop-i2c.c"} {d_ino=3D3158174, d_off=3D38, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"flexcop-misc.c"} {d_ino=3D31581=
75, d_off=3D41, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"flexcop-pci=
=2Ec"} {d_ino=3D3158208, d_off=3D44, d_type=3DDT_UNKNOWN, d_reclen=3D40, =
d_name=3D"flexcop-reg.h"} {d_ino=3D3158209, d_off=3D48, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D"flexcop-sram.c"} {d_ino=3D3158210, d_off=3D5=
1, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"flexcop-usb.c"} {d_ino=3D=
3158211, d_off=3D54, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"flexco=
p-usb.h"} {d_ino=3D3158212, d_off=3D57, d_type=3DDT_UNKNOWN, d_reclen=3D3=
2, d_name=3D"flexcop.c"} {d_ino=3D3158213, d_off=3D60, d_type=3DDT_UNKNOW=
N, d_reclen=3D32, d_name=3D"flexcop.h"} {d_ino=3D3158214, d_off=3D65, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D"flexcop_ibi_value_be.h"} {d_in=
o=3D3158215, d_off=3D70, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D"fl=
excop_ibi_value_le.h"} {d_ino=3D3204241, d_off=3D73, d_type=3DDT_UNKNOWN,=
 d_reclen=3D32, d_name=3D"built-in.o"} {d_ino=3D3204242, d_off=3D85, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".built-in.o.cmd"} {d_ino=3D3011=
304, d_off=3D92, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"flexcop-pc=
i.o"} {d_ino=3D3011306, d_off=3D107, d_type=3DDT_UNKNOWN, d_reclen=3D40, =
d_name=3D".flexcop-pci.o.cmd"} {d_ino=3D3011309, d_off=3D114, d_type=3DDT=
_UNKNOWN, d_reclen=3D32, d_name=3D"flexcop.o"} {d_ino=3D3011305, d_off=3D=
127, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".flexcop.o.cmd"} {d_in=
o=3D3011307, d_off=3D136, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"f=
lexcop-fe-tuner.o"} {d_ino=3D3011310, d_off=3D153, d_type=3DDT_UNKNOWN, d=
_reclen=3D48, d_name=3D".flexcop-fe-tuner.o.cmd"} {d_ino=3D3011313, d_off=
=3D160, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"flexcop-i2c.o"} {d_=
ino=3D3011308, d_off=3D176, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
".flexcop-i2c.o.cmd"} {d_ino=3D3011315, d_off=3D184, d_type=3DDT_UNKNOWN,=
 d_reclen=3D40, d_name=3D"flexcop-sram.o"} {d_ino=3D3011311, d_off=3D201,=
 d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".flexcop-sram.o.cmd"} {d_i=
no=3D3011317, d_off=3D209, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"=
flexcop-eeprom.o"} {d_ino=3D3011312, d_off=3D225, d_type=3DDT_UNKNOWN, d_=
reclen=3D48, d_name=3D".flexcop-eeprom.o.cmd"} {d_ino=3D3011319, d_off=3D=
233, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"flexcop-misc.o"} {d_in=
o=3D3011314, d_off=3D247, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".=
flexcop-misc.o.cmd"} {d_ino=3D3011316, d_off=3D256, d_type=3DDT_UNKNOWN, =
d_reclen=3D40, d_name=3D"flexcop-hw-filter.o"} {d_ino=3D3011320, d_off=3D=
273, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D".flexcop-hw-filter.o.c=
md"} {d_ino=3D3011323, d_off=3D280, d_type=3DDT_UNKNOWN, d_reclen=3D40, d=
_name=3D"flexcop-dma.o"} {d_ino=3D3011318, d_off=3D284, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D".flexcop-dma.o.cmd"} {d_ino=3D3011321, d_off=
=3D288, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"b2c2-flexcop.o"} {d=
_ino=3D3011322, d_off=3D292, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
".b2c2-flexcop.o.cmd"} {d_ino=3D3011325, d_off=3D296, d_type=3DDT_UNKNOWN=
, d_reclen=3D40, d_name=3D"b2c2-flexcop-pci.o"} {d_ino=3D3011326, d_off=3D=
301, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D".b2c2-flexcop-pci.o.cm=
d"} {d_ino=3D3216928, d_off=3D304, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_=
name=3D"modules.order"} {d_ino=3D3727994, d_off=3D308, d_type=3DDT_UNKNOW=
N, d_reclen=3D40, d_name=3D"b2c2-flexcop.mod.c"} {d_ino=3D3727995, d_off=3D=
313, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D"b2c2-flexcop-pci.mod.c=
"} {d_ino=3D3730594, d_off=3D328, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_n=
ame=3D"b2c2-flexcop-pci.mod.o"} {d_ino=3D3730596, d_off=3D333, d_type=3DD=
T_UNKNOWN, d_reclen=3D48, d_name=3D".b2c2-flexcop-pci.mod.o.cmd"} {d_ino=3D=
3730595, d_off=3D337, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"b2c2-=
flexcop-pci.ko"} {d_ino=3D3730597, d_off=3D342, d_type=3DDT_UNKNOWN, d_re=
clen=3D48, d_name=3D".b2c2-flexcop-pci.ko.cmd"} {d_ino=3D3730598, d_off=3D=
355, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"b2c2-flexcop.mod.o"} {=
d_ino=3D3730600, d_off=3D360, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D=
".b2c2-flexcop.mod.o.cmd"} {d_ino=3D3730599, d_off=3D364, d_type=3DDT_UNK=
NOWN, d_reclen=3D40, d_name=3D"b2c2-flexcop.ko"} {d_ino=3D3730601, d_off=3D=
512, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".b2c2-flexcop.ko.cmd"}=
}, 4096) =3D 2208
getdents64(4, {}, 4096)                 =3D 0
close(4)                                =3D 0
chdir("b2c2")                           =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D3158165, st_mode=3DS_IFDIR=
|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=
=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01/=
08-19:38:48, st_ctime=3D2009/01/08-19:38:48}) =3D 0
lstat64("flexcop-common.h", {st_dev=3Dmakedev(3, 1), st_ino=3D3158168, st=
_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D16, st_size=3D5720, st_atime=3D2009/01/08-18:34:03, st_=
mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("flexcop-dma.c", {st_dev=3Dmakedev(3, 1), st_ino=3D3158169, st_mo=
de=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D409=
6, st_blocks=3D16, st_size=3D4362, st_atime=3D2009/01/08-18:34:03, st_mti=
me=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("flexcop-eeprom.c", {st_dev=3Dmakedev(3, 1), st_ino=3D3158170, st=
_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D8, st_size=3D3452, st_atime=3D2009/01/08-18:34:03, st_m=
time=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("flexcop-fe-tuner.c", {st_dev=3Dmakedev(3, 1), st_ino=3D3158171, =
st_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D40, st_size=3D17145, st_atime=3D2009/01/08-18:34:03, st=
_mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("flexcop-hw-filter.c", {st_dev=3Dmakedev(3, 1), st_ino=3D3158172,=
 st_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=
=3D4096, st_blocks=3D16, st_size=3D6533, st_atime=3D2009/01/08-18:34:03, =
st_mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("flexcop-i2c.c", {st_dev=3Dmakedev(3, 1), st_ino=3D3158173, st_mo=
de=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D409=
6, st_blocks=3D16, st_size=3D7650, st_atime=3D2009/01/08-18:34:03, st_mti=
me=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("flexcop-misc.c", {st_dev=3Dmakedev(3, 1), st_ino=3D3158174, st_m=
ode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D40=
96, st_blocks=3D8, st_size=3D2197, st_atime=3D2009/01/08-18:34:03, st_mti=
me=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("flexcop-pci.c", {st_dev=3Dmakedev(3, 1), st_ino=3D3158175, st_mo=
de=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D409=
6, st_blocks=3D24, st_size=3D12260, st_atime=3D2009/01/08-18:34:03, st_mt=
ime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("flexcop-reg.h", {st_dev=3Dmakedev(3, 1), st_ino=3D3158208, st_mo=
de=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D409=
6, st_blocks=3D8, st_size=3D3703, st_atime=3D2009/01/08-18:34:03, st_mtim=
e=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("flexcop-sram.c", {st_dev=3Dmakedev(3, 1), st_ino=3D3158209, st_m=
ode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D40=
96, st_blocks=3D24, st_size=3D8812, st_atime=3D2009/01/08-18:34:03, st_mt=
ime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("flexcop-usb.c", {st_dev=3Dmakedev(3, 1), st_ino=3D3158210, st_mo=
de=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D409=
6, st_blocks=3D40, st_size=3D16598, st_atime=3D2009/01/08-18:34:03, st_mt=
ime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("flexcop-usb.h", {st_dev=3Dmakedev(3, 1), st_ino=3D3158211, st_mo=
de=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D409=
6, st_blocks=3D8, st_size=3D3351, st_atime=3D2009/01/08-18:34:03, st_mtim=
e=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("flexcop.c", {st_dev=3Dmakedev(3, 1), st_ino=3D3158212, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D24, st_size=3D8800, st_atime=3D2009/01/08-18:34:03, st_mtime=3D=
2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("flexcop.h", {st_dev=3Dmakedev(3, 1), st_ino=3D3158213, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D8, st_size=3D845, st_atime=3D2009/01/08-18:34:03, st_mtime=3D20=
08/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("flexcop_ibi_value_be.h", {st_dev=3Dmakedev(3, 1), st_ino=3D31582=
14, st_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blks=
ize=3D4096, st_blocks=3D32, st_size=3D14146, st_atime=3D2009/01/08-18:34:=
03, st_mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D =
0
lstat64("flexcop_ibi_value_le.h", {st_dev=3Dmakedev(3, 1), st_ino=3D31582=
15, st_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blks=
ize=3D4096, st_blocks=3D32, st_size=3D14146, st_atime=3D2009/01/08-18:34:=
03, st_mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D =
0
lstat64("b2c2-flexcop.mod.c", {st_dev=3Dmakedev(3, 1), st_ino=3D3727994, =
st_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D8, st_size=3D2684, st_atime=3D2009/01/08-19:38:48, st_m=
time=3D2009/01/08-19:38:27, st_ctime=3D2009/01/08-19:38:27}) =3D 0
lstat64("b2c2-flexcop-pci.mod.c", {st_dev=3Dmakedev(3, 1), st_ino=3D37279=
95, st_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blks=
ize=3D4096, st_blocks=3D8, st_size=3D2074, st_atime=3D2009/01/08-19:38:47=
, st_mtime=3D2009/01/08-19:38:27, st_ctime=3D2009/01/08-19:38:27}) =3D 0
chdir("..")                             =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D3158162, st_mode=3DS_IFDIR=
|0755, st_nlink=3D13, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01=
/08-19:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
lstat64("bt8xx", {st_dev=3Dmakedev(3, 1), st_ino=3D6862927, st_mode=3DS_I=
FDIR|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_bl=
ocks=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2009=
/01/08-19:38:49, st_ctime=3D2009/01/08-19:38:49}) =3D 0
open("bt8xx", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D6862927, st_mode=3DS_IFDIR|0=
755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
8, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2009/01/08-=
19:38:49, st_ctime=3D2009/01/08-19:38:49}) =3D 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         =3D 0
getdents64(4, {{d_ino=3D6862927, d_off=3D4, d_type=3DDT_UNKNOWN, d_reclen=
=3D24, d_name=3D"."} {d_ino=3D3158162, d_off=3D6, d_type=3DDT_UNKNOWN, d_=
reclen=3D24, d_name=3D".."} {d_ino=3D6862928, d_off=3D9, d_type=3DDT_UNKN=
OWN, d_reclen=3D32, d_name=3D"Kconfig"} {d_ino=3D6862929, d_off=3D12, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"Makefile"} {d_ino=3D6862930, d=
_off=3D15, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"bt878.c"} {d_ino=
=3D6862931, d_off=3D18, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"bt8=
78.h"} {d_ino=3D6862932, d_off=3D20, d_type=3DDT_UNKNOWN, d_reclen=3D32, =
d_name=3D"dst.c"} {d_ino=3D6862933, d_off=3D23, d_type=3DDT_UNKNOWN, d_re=
clen=3D32, d_name=3D"dst_ca.c"} {d_ino=3D6862934, d_off=3D26, d_type=3DDT=
_UNKNOWN, d_reclen=3D32, d_name=3D"dst_ca.h"} {d_ino=3D6862935, d_off=3D2=
9, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dst_common.h"} {d_ino=3D=
6862936, d_off=3D32, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dst_pr=
iv.h"} {d_ino=3D6862937, d_off=3D35, d_type=3DDT_UNKNOWN, d_reclen=3D32, =
d_name=3D"dvb-bt8xx.c"} {d_ino=3D6862938, d_off=3D38, d_type=3DDT_UNKNOWN=
, d_reclen=3D32, d_name=3D"dvb-bt8xx.h"} {d_ino=3D6901731, d_off=3D41, d_=
type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"built-in.o"} {d_ino=3D6901732=
, d_off=3D55, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".built-in.o.c=
md"} {d_ino=3D7026444, d_off=3D61, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_=
name=3D"bt878.o"} {d_ino=3D7026441, d_off=3D72, d_type=3DDT_UNKNOWN, d_re=
clen=3D32, d_name=3D".bt878.o.cmd"} {d_ino=3D7026442, d_off=3D79, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"dvb-bt8xx.o"} {d_ino=3D7026445, d_of=
f=3D92, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dvb-bt8xx.o.cmd"} =
{d_ino=3D7026448, d_off=3D97, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"dst.o"} {d_ino=3D7026443, d_off=3D110, d_type=3DDT_UNKNOWN, d_reclen=3D3=
2, d_name=3D".dst.o.cmd"} {d_ino=3D7026450, d_off=3D116, d_type=3DDT_UNKN=
OWN, d_reclen=3D32, d_name=3D"dst_ca.o"} {d_ino=3D7026446, d_off=3D119, d=
_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dst_ca.o.cmd"} {d_ino=3D702=
6447, d_off=3D122, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"modules.=
order"} {d_ino=3D7026461, d_off=3D126, d_type=3DDT_UNKNOWN, d_reclen=3D40=
, d_name=3D"dvb-bt8xx.mod.c"} {d_ino=3D7026462, d_off=3D129, d_type=3DDT_=
UNKNOWN, d_reclen=3D32, d_name=3D"dst_ca.mod.c"} {d_ino=3D7026463, d_off=3D=
132, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dst.mod.c"} {d_ino=3D7=
026464, d_off=3D135, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"bt878.=
mod.c"} {d_ino=3D7026480, d_off=3D146, d_type=3DDT_UNKNOWN, d_reclen=3D32=
, d_name=3D"bt878.mod.o"} {d_ino=3D7026482, d_off=3D150, d_type=3DDT_UNKN=
OWN, d_reclen=3D40, d_name=3D".bt878.mod.o.cmd"} {d_ino=3D7026481, d_off=3D=
153, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"bt878.ko"} {d_ino=3D70=
26483, d_off=3D156, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".bt878.=
ko.cmd"} {d_ino=3D7026484, d_off=3D166, d_type=3DDT_UNKNOWN, d_reclen=3D3=
2, d_name=3D"dst.mod.o"} {d_ino=3D7026486, d_off=3D170, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D".dst.mod.o.cmd"} {d_ino=3D7026485, d_off=3D1=
73, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dst.ko"} {d_ino=3D70264=
87, d_off=3D176, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D".dst.ko.cm=
d"} {d_ino=3D7026488, d_off=3D187, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_=
name=3D"dst_ca.mod.o"} {d_ino=3D7026490, d_off=3D191, d_type=3DDT_UNKNOWN=
, d_reclen=3D40, d_name=3D".dst_ca.mod.o.cmd"} {d_ino=3D7026489, d_off=3D=
194, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dst_ca.ko"} {d_ino=3D7=
026491, d_off=3D198, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dst_c=
a.ko.cmd"} {d_ino=3D7026492, d_off=3D210, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D"dvb-bt8xx.mod.o"} {d_ino=3D7026494, d_off=3D214, d_type=3DD=
T_UNKNOWN, d_reclen=3D40, d_name=3D".dvb-bt8xx.mod.o.cmd"} {d_ino=3D70264=
93, d_off=3D217, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dvb-bt8xx.=
ko"} {d_ino=3D7026495, d_off=3D512, d_type=3DDT_UNKNOWN, d_reclen=3D40, d=
_name=3D".dvb-bt8xx.ko.cmd"}}, 4096) =3D 1496
getdents64(4, {}, 4096)                 =3D 0
close(4)                                =3D 0
chdir("bt8xx")                          =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D6862927, st_mode=3DS_IFDIR=
|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=
=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01/=
08-19:38:49, st_ctime=3D2009/01/08-19:38:49}) =3D 0
lstat64("bt878.c", {st_dev=3Dmakedev(3, 1), st_ino=3D6862930, st_mode=3DS=
_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_=
blocks=3D32, st_size=3D16180, st_atime=3D2009/01/08-18:34:03, st_mtime=3D=
2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
write(1, "../linux/drivers/media/common/sa"..., 1024) =3D 1024
lstat64("bt878.h", {st_dev=3Dmakedev(3, 1), st_ino=3D6862931, st_mode=3DS=
_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_=
blocks=3D16, st_size=3D4113, st_atime=3D2009/01/08-18:34:03, st_mtime=3D2=
008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dst.c", {st_dev=3Dmakedev(3, 1), st_ino=3D6862932, st_mode=3DS_I=
FREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_bl=
ocks=3D104, st_size=3D50083, st_atime=3D2009/01/08-18:34:03, st_mtime=3D2=
008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dst_ca.c", {st_dev=3Dmakedev(3, 1), st_ino=3D6862933, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D48, st_size=3D21588, st_atime=3D2009/01/08-18:34:03, st_mtime=3D=
2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dst_ca.h", {st_dev=3Dmakedev(3, 1), st_ino=3D6862934, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D8, st_size=3D1591, st_atime=3D2009/01/08-18:34:03, st_mtime=3D2=
008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dst_common.h", {st_dev=3Dmakedev(3, 1), st_ino=3D6862935, st_mod=
e=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096=
, st_blocks=3D16, st_size=3D4277, st_atime=3D2009/01/08-18:34:03, st_mtim=
e=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dst_priv.h", {st_dev=3Dmakedev(3, 1), st_ino=3D6862936, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D8, st_size=3D598, st_atime=3D2009/01/08-18:34:03, st_mtime=3D20=
08/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dvb-bt8xx.c", {st_dev=3Dmakedev(3, 1), st_ino=3D6862937, st_mode=
=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096,=
 st_blocks=3D56, st_size=3D28087, st_atime=3D2009/01/08-18:34:03, st_mtim=
e=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dvb-bt8xx.h", {st_dev=3Dmakedev(3, 1), st_ino=3D6862938, st_mode=
=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096,=
 st_blocks=3D8, st_size=3D1816, st_atime=3D2009/01/08-18:34:03, st_mtime=3D=
2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dvb-bt8xx.mod.c", {st_dev=3Dmakedev(3, 1), st_ino=3D7026461, st_=
mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4=
096, st_blocks=3D8, st_size=3D2514, st_atime=3D2009/01/08-19:38:49, st_mt=
ime=3D2009/01/08-19:38:27, st_ctime=3D2009/01/08-19:38:27}) =3D 0
lstat64("dst_ca.mod.c", {st_dev=3Dmakedev(3, 1), st_ino=3D7026462, st_mod=
e=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096=
, st_blocks=3D8, st_size=3D1316, st_atime=3D2009/01/08-19:38:48, st_mtime=
=3D2009/01/08-19:38:27, st_ctime=3D2009/01/08-19:38:27}) =3D 0
lstat64("dst.mod.c", {st_dev=3Dmakedev(3, 1), st_ino=3D7026463, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D8, st_size=3D1107, st_atime=3D2009/01/08-19:38:48, st_mtime=3D2=
009/01/08-19:38:27, st_ctime=3D2009/01/08-19:38:27}) =3D 0
lstat64("bt878.mod.c", {st_dev=3Dmakedev(3, 1), st_ino=3D7026464, st_mode=
=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096,=
 st_blocks=3D8, st_size=3D2437, st_atime=3D2009/01/08-19:38:48, st_mtime=3D=
2009/01/08-19:38:27, st_ctime=3D2009/01/08-19:38:27}) =3D 0
chdir("..")                             =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D3158162, st_mode=3DS_IFDIR=
|0755, st_nlink=3D13, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01=
/08-19:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
lstat64("dm1105", {st_dev=3Dmakedev(3, 1), st_ino=3D9948257, st_mode=3DS_=
IFDIR|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_b=
locks=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D200=
9/01/09-18:14:49, st_ctime=3D2009/01/09-18:14:49}) =3D 0
open("dm1105", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D9948257, st_mode=3DS_IFDIR|0=
755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
8, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2009/01/09-=
18:14:49, st_ctime=3D2009/01/09-18:14:49}) =3D 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         =3D 0
getdents64(4, {{d_ino=3D9948257, d_off=3D4, d_type=3DDT_UNKNOWN, d_reclen=
=3D24, d_name=3D"."} {d_ino=3D3158162, d_off=3D6, d_type=3DDT_UNKNOWN, d_=
reclen=3D24, d_name=3D".."} {d_ino=3D9948258, d_off=3D9, d_type=3DDT_UNKN=
OWN, d_reclen=3D32, d_name=3D"Kconfig"} {d_ino=3D9948259, d_off=3D12, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"Makefile"} {d_ino=3D9948260, d=
_off=3D15, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dm1105.c"} {d_in=
o=3D10008175, d_off=3D18, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"b=
uilt-in.o"} {d_ino=3D10008176, d_off=3D22, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D".built-in.o.cmd"} {d_ino=3D10008218, d_off=3D31, d_type=3DD=
T_UNKNOWN, d_reclen=3D40, d_name=3D"modules.order"} {d_ino=3D10015400, d_=
off=3D37, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dm1105.o"} {d_ino=
=3D10015402, d_off=3D40, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".d=
m1105.o.cmd"} {d_ino=3D10015401, d_off=3D43, d_type=3DDT_UNKNOWN, d_recle=
n=3D32, d_name=3D"dm1105.mod.c"} {d_ino=3D10015403, d_off=3D54, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"dm1105.mod.o"} {d_ino=3D10015405, d_=
off=3D58, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dm1105.mod.o.cmd=
"} {d_ino=3D10015404, d_off=3D61, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_n=
ame=3D"dm1105.ko"} {d_ino=3D10015406, d_off=3D512, d_type=3DDT_UNKNOWN, d=
_reclen=3D40, d_name=3D".dm1105.ko.cmd"}}, 4096) =3D 504
getdents64(4, {}, 4096)                 =3D 0
close(4)                                =3D 0
chdir("dm1105")                         =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D9948257, st_mode=3DS_IFDIR=
|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=
=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01/=
09-18:14:49, st_ctime=3D2009/01/09-18:14:49}) =3D 0
lstat64("dm1105.c", {st_dev=3Dmakedev(3, 1), st_ino=3D9948260, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D48, st_size=3D23167, st_atime=3D2009/01/08-18:34:03, st_mtime=3D=
2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dm1105.mod.c", {st_dev=3Dmakedev(3, 1), st_ino=3D10015401, st_mo=
de=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D409=
6, st_blocks=3D8, st_size=3D2964, st_atime=3D2009/01/09-18:14:49, st_mtim=
e=3D2009/01/09-18:14:49, st_ctime=3D2009/01/09-18:14:49}) =3D 0
chdir("..")                             =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D3158162, st_mode=3DS_IFDIR=
|0755, st_nlink=3D13, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01=
/08-19:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
lstat64("dvb-core", {st_dev=3Dmakedev(3, 1), st_ino=3D15629739, st_mode=3D=
S_IFDIR|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2=
009/01/12-20:03:29, st_ctime=3D2009/01/12-20:03:29}) =3D 0
open("dvb-core", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D15629739, st_mode=3DS_IFDIR|=
0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
8, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2009/01/12-=
20:03:29, st_ctime=3D2009/01/12-20:03:29}) =3D 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         =3D 0
getdents64(4, {{d_ino=3D15629739, d_off=3D4, d_type=3DDT_UNKNOWN, d_recle=
n=3D24, d_name=3D"."} {d_ino=3D3158162, d_off=3D6, d_type=3DDT_UNKNOWN, d=
_reclen=3D24, d_name=3D".."} {d_ino=3D15629740, d_off=3D9, d_type=3DDT_UN=
KNOWN, d_reclen=3D32, d_name=3D"Makefile"} {d_ino=3D15629741, d_off=3D12,=
 d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"demux.h"} {d_ino=3D1562974=
2, d_off=3D15, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dmxdev.c"} {=
d_ino=3D15629743, d_off=3D18, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"dmxdev.h"} {d_ino=3D15629744, d_off=3D22, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D"dvb_ca_en50221.c"} {d_ino=3D15629745, d_off=3D26, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D"dvb_ca_en50221.h"} {d_ino=3D15629746=
, d_off=3D29, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dvb_demux.c"}=
 {d_ino=3D15629747, d_off=3D32, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_nam=
e=3D"dvb_demux.h"} {d_ino=3D15629748, d_off=3D35, d_type=3DDT_UNKNOWN, d_=
reclen=3D32, d_name=3D"dvb_filter.c"} {d_ino=3D15629749, d_off=3D38, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dvb_filter.h"} {d_ino=3D1562975=
0, d_off=3D42, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dvb_frontend=
=2Ec"} {d_ino=3D15629751, d_off=3D46, d_type=3DDT_UNKNOWN, d_reclen=3D40,=
 d_name=3D"dvb_frontend.h"} {d_ino=3D15629752, d_off=3D49, d_type=3DDT_UN=
KNOWN, d_reclen=3D32, d_name=3D"dvb_math.c"} {d_ino=3D15629753, d_off=3D5=
2, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dvb_math.h"} {d_ino=3D15=
629754, d_off=3D55, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dvb_net=
=2Ec"} {d_ino=3D15629755, d_off=3D58, d_type=3DDT_UNKNOWN, d_reclen=3D32,=
 d_name=3D"dvb_net.h"} {d_ino=3D15629756, d_off=3D62, d_type=3DDT_UNKNOWN=
, d_reclen=3D40, d_name=3D"dvb_ringbuffer.c"} {d_ino=3D15629757, d_off=3D=
66, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dvb_ringbuffer.h"} {d_i=
no=3D15629758, d_off=3D69, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"=
dvbdev.c"} {d_ino=3D15629759, d_off=3D72, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"dvbdev.h"} {d_ino=3D15736135, d_off=3D75, d_type=3DDT_UNKNO=
WN, d_reclen=3D32, d_name=3D"built-in.o"} {d_ino=3D15736136, d_off=3D95, =
d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".built-in.o.cmd"} {d_ino=3D=
15851944, d_off=3D114, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dvb=
dev.o.cmd"} {d_ino=3D15851945, d_off=3D136, d_type=3DDT_UNKNOWN, d_reclen=
=3D40, d_name=3D".dmxdev.o.cmd"} {d_ino=3D15740138, d_off=3D159, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D".dvb_demux.o.cmd"} {d_ino=3D15740135=
, d_off=3D184, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dvb_filter.=
o.cmd"} {d_ino=3D15737849, d_off=3D208, d_type=3DDT_UNKNOWN, d_reclen=3D4=
8, d_name=3D".dvb_ca_en50221.o.cmd"} {d_ino=3D15737851, d_off=3D230, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dvb_frontend.o.cmd"} {d_ino=3D=
15737853, d_off=3D255, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dvb=
_net.o.cmd"} {d_ino=3D15737855, d_off=3D277, d_type=3DDT_UNKNOWN, d_recle=
n=3D48, d_name=3D".dvb_ringbuffer.o.cmd"} {d_ino=3D15737857, d_off=3D284,=
 d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dvb_math.o.cmd"} {d_ino=3D=
15737858, d_off=3D288, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dvb=
-core.o.cmd"} {d_ino=3D15737860, d_off=3D291, d_type=3DDT_UNKNOWN, d_recl=
en=3D40, d_name=3D"modules.order"} {d_ino=3D15740158, d_off=3D307, d_type=
=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dvb-core.mod.c"} {d_ino=3D1573788=
0, d_off=3D314, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dvb-core.m=
od.o.cmd"} {d_ino=3D15740167, d_off=3D358, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D".dvb-core.ko.cmd"} {d_ino=3D15737843, d_off=3D361, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"dvbdev.o"} {d_ino=3D15737840, d_off=3D=
364, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dmxdev.o"} {d_ino=3D15=
737841, d_off=3D367, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dvb_de=
mux.o"} {d_ino=3D15737842, d_off=3D370, d_type=3DDT_UNKNOWN, d_reclen=3D3=
2, d_name=3D"dvb_filter.o"} {d_ino=3D15737844, d_off=3D374, d_type=3DDT_U=
NKNOWN, d_reclen=3D40, d_name=3D"dvb_ca_en50221.o"} {d_ino=3D15737845, d_=
off=3D378, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dvb_frontend.o"}=
 {d_ino=3D15737846, d_off=3D381, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_na=
me=3D"dvb_net.o"} {d_ino=3D15737847, d_off=3D385, d_type=3DDT_UNKNOWN, d_=
reclen=3D40, d_name=3D"dvb_ringbuffer.o"} {d_ino=3D15737848, d_off=3D388,=
 d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dvb_math.o"} {d_ino=3D1573=
7850, d_off=3D391, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dvb-core=
=2Eo"} {d_ino=3D15737875, d_off=3D395, d_type=3DDT_UNKNOWN, d_reclen=3D40=
, d_name=3D"dvb-core.mod.o"} {d_ino=3D15737876, d_off=3D512, d_type=3DDT_=
UNKNOWN, d_reclen=3D32, d_name=3D"dvb-core.ko"}}, 4096) =3D 1800
getdents64(4, {}, 4096)                 =3D 0
close(4)                                =3D 0
chdir("dvb-core")                       =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D15629739, st_mode=3DS_IFDI=
R|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01=
/12-20:03:29, st_ctime=3D2009/01/12-20:03:29}) =3D 0
lstat64("demux.h", {st_dev=3Dmakedev(3, 1), st_ino=3D15629741, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D24, st_size=3D8791, st_atime=3D2009/01/08-18:34:03, st_mtime=3D=
2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dmxdev.c", {st_dev=3Dmakedev(3, 1), st_ino=3D15629742, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D56, st_size=3D28645, st_atime=3D2009/01/08-18:34:03, st_mtime=3D=
2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dmxdev.h", {st_dev=3Dmakedev(3, 1), st_ino=3D15629743, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D8, st_size=3D2409, st_atime=3D2009/01/08-18:34:03, st_mtime=3D2=
008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dvb_ca_en50221.c", {st_dev=3Dmakedev(3, 1), st_ino=3D15629744, s=
t_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D96, st_size=3D45096, st_atime=3D2009/01/08-18:34:03, st=
_mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dvb_ca_en50221.h", {st_dev=3Dmakedev(3, 1), st_ino=3D15629745, s=
t_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D8, st_size=3D3998, st_atime=3D2009/01/08-18:34:03, st_m=
time=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dvb_demux.c", {st_dev=3Dmakedev(3, 1), st_ino=3D15629746, st_mod=
e=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096=
, st_blocks=3D64, st_size=3D29517, st_atime=3D2009/01/08-18:34:03, st_mti=
me=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dvb_demux.h", {st_dev=3Dmakedev(3, 1), st_ino=3D15629747, st_mod=
e=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096=
, st_blocks=3D8, st_size=3D3501, st_atime=3D2009/01/08-18:34:03, st_mtime=
=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dvb_filter.c", {st_dev=3Dmakedev(3, 1), st_ino=3D15629748, st_mo=
de=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D409=
6, st_blocks=3D32, st_size=3D12922, st_atime=3D2009/01/08-18:34:03, st_mt=
ime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
write(1, "/media/dvb/bt8xx/bt878.c\0../linu"..., 1024) =3D 1024
lstat64("dvb_filter.h", {st_dev=3Dmakedev(3, 1), st_ino=3D15629749, st_mo=
de=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D409=
6, st_blocks=3D16, st_size=3D6064, st_atime=3D2009/01/08-18:34:03, st_mti=
me=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dvb_frontend.c", {st_dev=3Dmakedev(3, 1), st_ino=3D15629750, st_=
mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4=
096, st_blocks=3D104, st_size=3D52402, st_atime=3D2009/01/08-18:34:03, st=
_mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dvb_frontend.h", {st_dev=3Dmakedev(3, 1), st_ino=3D15629751, st_=
mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4=
096, st_blocks=3D16, st_size=3D7486, st_atime=3D2009/01/08-18:34:03, st_m=
time=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dvb_math.c", {st_dev=3Dmakedev(3, 1), st_ino=3D15629752, st_mode=
=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096,=
 st_blocks=3D16, st_size=3D5423, st_atime=3D2009/01/08-18:34:03, st_mtime=
=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dvb_math.h", {st_dev=3Dmakedev(3, 1), st_ino=3D15629753, st_mode=
=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096,=
 st_blocks=3D8, st_size=3D1974, st_atime=3D2009/01/08-18:34:03, st_mtime=3D=
2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dvb_net.c", {st_dev=3Dmakedev(3, 1), st_ino=3D15629754, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D88, st_size=3D42969, st_atime=3D2009/01/08-18:34:03, st_mtime=3D=
2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dvb_net.h", {st_dev=3Dmakedev(3, 1), st_ino=3D15629755, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D8, st_size=3D1379, st_atime=3D2009/01/08-18:34:03, st_mtime=3D2=
008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dvb_ringbuffer.c", {st_dev=3Dmakedev(3, 1), st_ino=3D15629756, s=
t_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D16, st_size=3D7188, st_atime=3D2009/01/08-18:34:03, st_=
mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dvb_ringbuffer.h", {st_dev=3Dmakedev(3, 1), st_ino=3D15629757, s=
t_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D16, st_size=3D6340, st_atime=3D2009/01/08-18:34:03, st_=
mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dvbdev.c", {st_dev=3Dmakedev(3, 1), st_ino=3D15629758, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D24, st_size=3D10746, st_atime=3D2009/01/08-18:34:03, st_mtime=3D=
2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dvbdev.h", {st_dev=3Dmakedev(3, 1), st_ino=3D15629759, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D8, st_size=3D4047, st_atime=3D2009/01/08-18:34:03, st_mtime=3D2=
008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:06}) =3D 0
lstat64("dvb-core.mod.c", {st_dev=3Dmakedev(3, 1), st_ino=3D15740158, st_=
mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4=
096, st_blocks=3D8, st_size=3D444, st_atime=3D2009/01/12-19:08:54, st_mti=
me=3D2009/01/12-19:08:46, st_ctime=3D2009/01/12-19:08:46}) =3D 0
chdir("..")                             =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D3158162, st_mode=3DS_IFDIR=
|0755, st_nlink=3D13, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01=
/08-19:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
lstat64("dvb-usb", {st_dev=3Dmakedev(3, 1), st_ino=3D19537968, st_mode=3D=
S_IFDIR|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D16, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D=
2009/01/09-18:14:49, st_ctime=3D2009/01/09-18:14:49}) =3D 0
open("dvb-usb", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D19537968, st_mode=3DS_IFDIR|=
0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
16, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2009/01/09=
-18:14:49, st_ctime=3D2009/01/09-18:14:49}) =3D 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         =3D 0
getdents64(4, {{d_ino=3D19537968, d_off=3D4, d_type=3DDT_UNKNOWN, d_recle=
n=3D24, d_name=3D"."} {d_ino=3D3158162, d_off=3D6, d_type=3DDT_UNKNOWN, d=
_reclen=3D24, d_name=3D".."} {d_ino=3D19537969, d_off=3D9, d_type=3DDT_UN=
KNOWN, d_reclen=3D32, d_name=3D"Kconfig"} {d_ino=3D19537970, d_off=3D12, =
d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"Makefile"} {d_ino=3D1953797=
1, d_off=3D15, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"a800.c"} {d_=
ino=3D19537972, d_off=3D18, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"af9005-fe.c"} {d_ino=3D19537973, d_off=3D22, d_type=3DDT_UNKNOWN, d_recl=
en=3D40, d_name=3D"af9005-remote.c"} {d_ino=3D19537974, d_off=3D26, d_typ=
e=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"af9005-script.h"} {d_ino=3D19537=
975, d_off=3D29, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"af9005.c"}=
 {d_ino=3D19537976, d_off=3D32, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_nam=
e=3D"af9005.h"} {d_ino=3D19537977, d_off=3D35, d_type=3DDT_UNKNOWN, d_rec=
len=3D32, d_name=3D"af9015.c"} {d_ino=3D19537978, d_off=3D38, d_type=3DDT=
_UNKNOWN, d_reclen=3D32, d_name=3D"af9015.h"} {d_ino=3D19537979, d_off=3D=
41, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"anysee.c"} {d_ino=3D195=
37980, d_off=3D44, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"anysee.h=
"} {d_ino=3D19537981, d_off=3D47, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_n=
ame=3D"au6610.c"} {d_ino=3D19537982, d_off=3D50, d_type=3DDT_UNKNOWN, d_r=
eclen=3D32, d_name=3D"au6610.h"} {d_ino=3D19537983, d_off=3D54, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D"cinergyT2-core.c"} {d_ino=3D19537984=
, d_off=3D58, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"cinergyT2-fe.=
c"} {d_ino=3D19537985, d_off=3D61, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_=
name=3D"cinergyT2.h"} {d_ino=3D19537986, d_off=3D64, d_type=3DDT_UNKNOWN,=
 d_reclen=3D32, d_name=3D"cxusb.c"} {d_ino=3D19537987, d_off=3D67, d_type=
=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"cxusb.h"} {d_ino=3D19537988, d_of=
f=3D70, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dib0700.h"} {d_ino=3D=
19537989, d_off=3D74, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dib07=
00_core.c"} {d_ino=3D19537990, d_off=3D78, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D"dib0700_devices.c"} {d_ino=3D19537991, d_off=3D81, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"dib07x0.h"} {d_ino=3D19537992, d_off=
=3D85, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dibusb-common.c"} {d=
_ino=3D19537993, d_off=3D88, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"dibusb-mb.c"} {d_ino=3D19537994, d_off=3D91, d_type=3DDT_UNKNOWN, d_recl=
en=3D32, d_name=3D"dibusb-mc.c"} {d_ino=3D19537995, d_off=3D94, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"dibusb.h"} {d_ino=3D19537996, d_off=3D=
97, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"digitv.c"} {d_ino=3D195=
37997, d_off=3D100, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"digitv.=
h"} {d_ino=3D19537998, d_off=3D103, d_type=3DDT_UNKNOWN, d_reclen=3D32, d=
_name=3D"dtt200u-fe.c"} {d_ino=3D19537999, d_off=3D106, d_type=3DDT_UNKNO=
WN, d_reclen=3D32, d_name=3D"dtt200u.c"} {d_ino=3D19538000, d_off=3D109, =
d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dtt200u.h"} {d_ino=3D195380=
01, d_off=3D112, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dtv5100.c"=
} {d_ino=3D19538002, d_off=3D115, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_n=
ame=3D"dtv5100.h"} {d_ino=3D19538003, d_off=3D119, d_type=3DDT_UNKNOWN, d=
_reclen=3D40, d_name=3D"dvb-usb-common.h"} {d_ino=3D19538004, d_off=3D122=
, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dvb-usb-dvb.c"} {d_ino=3D=
19538005, d_off=3D126, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dvb-=
usb-firmware.c"} {d_ino=3D19538006, d_off=3D129, d_type=3DDT_UNKNOWN, d_r=
eclen=3D40, d_name=3D"dvb-usb-i2c.c"} {d_ino=3D19538007, d_off=3D132, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dvb-usb-ids.h"} {d_ino=3D19538=
008, d_off=3D136, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dvb-usb-i=
nit.c"} {d_ino=3D19538009, d_off=3D140, d_type=3DDT_UNKNOWN, d_reclen=3D4=
0, d_name=3D"dvb-usb-remote.c"} {d_ino=3D19538010, d_off=3D143, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D"dvb-usb-urb.c"} {d_ino=3D19538011, d=
_off=3D146, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dvb-usb.h"} {d_=
ino=3D19538012, d_off=3D149, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"dw2102.c"} {d_ino=3D19538013, d_off=3D152, d_type=3DDT_UNKNOWN, d_reclen=
=3D32, d_name=3D"dw2102.h"} {d_ino=3D19538014, d_off=3D155, d_type=3DDT_U=
NKNOWN, d_reclen=3D32, d_name=3D"gl861.c"} {d_ino=3D19538015, d_off=3D158=
, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"gl861.h"} {d_ino=3D195486=
72, d_off=3D161, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"gp8psk-fe.=
c"} {d_ino=3D19548673, d_off=3D164, d_type=3DDT_UNKNOWN, d_reclen=3D32, d=
_name=3D"gp8psk.c"} {d_ino=3D19548674, d_off=3D167, d_type=3DDT_UNKNOWN, =
d_reclen=3D32, d_name=3D"gp8psk.h"} {d_ino=3D19548675, d_off=3D170, d_typ=
e=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"m920x.c"} {d_ino=3D19548676, d_o=
ff=3D173, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"m920x.h"} {d_ino=3D=
19548677, d_off=3D176, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"nova=
-t-usb2.c"} {d_ino=3D19548678, d_off=3D179, d_type=3DDT_UNKNOWN, d_reclen=
=3D32, d_name=3D"opera1.c"} {d_ino=3D19548679, d_off=3D182, d_type=3DDT_U=
NKNOWN, d_reclen=3D32, d_name=3D"ttusb2.c"} {d_ino=3D19548680, d_off=3D18=
5, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"ttusb2.h"} {d_ino=3D1954=
8681, d_off=3D188, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"umt-010.=
c"} {d_ino=3D19548682, d_off=3D191, d_type=3DDT_UNKNOWN, d_reclen=3D32, d=
_name=3D"usb-urb.c"} {d_ino=3D19548683, d_off=3D194, d_type=3DDT_UNKNOWN,=
 d_reclen=3D32, d_name=3D"vp702x-fe.c"} {d_ino=3D19548684, d_off=3D197, d=
_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"vp702x.c"} {d_ino=3D19548685=
, d_off=3D200, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"vp702x.h"} {=
d_ino=3D19548686, d_off=3D203, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=
=3D"vp7045-fe.c"} {d_ino=3D19548687, d_off=3D206, d_type=3DDT_UNKNOWN, d_=
reclen=3D32, d_name=3D"vp7045.c"} {d_ino=3D19548688, d_off=3D209, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"vp7045.h"} {d_ino=3D19896429, d_off=3D=
212, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"built-in.o"} {d_ino=3D=
19896430, d_off=3D220, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".bui=
lt-in.o.cmd"} {d_ino=3D19919111, d_off=3D230, d_type=3DDT_UNKNOWN, d_recl=
en=3D40, d_name=3D"cinergyT2-fe.o"} {d_ino=3D19912166, d_off=3D239, d_typ=
e=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dvb-usb-firmware.o"} {d_ino=3D19=
912163, d_off=3D244, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D".dvb-u=
sb-firmware.o.cmd"} {d_ino=3D19919110, d_off=3D248, d_type=3DDT_UNKNOWN, =
d_reclen=3D40, d_name=3D"cinergyT2-core.o"} {d_ino=3D19919115, d_off=3D25=
6, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D".dvb-usb-cinergyT2.o.cmd=
"} {d_ino=3D19912168, d_off=3D264, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_=
name=3D"dvb-usb-init.o"} {d_ino=3D19912164, d_off=3D268, d_type=3DDT_UNKN=
OWN, d_reclen=3D40, d_name=3D".dvb-usb-init.o.cmd"} {d_ino=3D19919114, d_=
off=3D272, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".cinergyT2-fe.o.=
cmd"} {d_ino=3D19919116, d_off=3D280, d_type=3DDT_UNKNOWN, d_reclen=3D48,=
 d_name=3D"dvb-usb-cinergyT2.mod.c"} {d_ino=3D19912170, d_off=3D287, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dvb-usb-urb.o"} {d_ino=3D199121=
65, d_off=3D291, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dvb-usb-u=
rb.o.cmd"} {d_ino=3D19919117, d_off=3D299, d_type=3DDT_UNKNOWN, d_reclen=3D=
48, d_name=3D"dvb-usb-cinergyT2.mod.o"} {d_ino=3D19912167, d_off=3D306, d=
_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dvb-usb-i2c.o"} {d_ino=3D199=
12171, d_off=3D310, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dvb-us=
b-i2c.o.cmd"} {d_ino=3D19919119, d_off=3D318, d_type=3DDT_UNKNOWN, d_recl=
en=3D48, d_name=3D".dvb-usb-cinergyT2.mod.o.cmd"} {d_ino=3D19912169, d_of=
f=3D325, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dvb-usb-dvb.o"} {d=
_ino=3D19912173, d_off=3D329, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
".dvb-usb-dvb.o.cmd"} {d_ino=3D19919112, d_off=3D333, d_type=3DDT_UNKNOWN=
, d_reclen=3D48, d_name=3D".cinergyT2-core.o.cmd"} {d_ino=3D19912175, d_o=
ff=3D342, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dvb-usb.o"} {d_in=
o=3D19912176, d_off=3D350, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"=
dvb-usb-remote.o"} {d_ino=3D19912172, d_off=3D361, d_type=3DDT_UNKNOWN, d=
_reclen=3D48, d_name=3D".dvb-usb-remote.o.cmd"} {d_ino=3D19912174, d_off=3D=
368, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"usb-urb.o"} {d_ino=3D1=
9912177, d_off=3D375, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".usb-=
urb.o.cmd"} {d_ino=3D19912178, d_off=3D379, d_type=3DDT_UNKNOWN, d_reclen=
=3D40, d_name=3D".dvb-usb.o.cmd"} {d_ino=3D19912179, d_off=3D382, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D"modules.order"} {d_ino=3D19915211, d=
_off=3D385, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dvb-usb.mod.c"}=
 {d_ino=3D19915217, d_off=3D388, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_na=
me=3D"dvb-usb.mod.o"} {d_ino=3D19919118, d_off=3D396, d_type=3DDT_UNKNOWN=
, d_reclen=3D40, d_name=3D"dvb-usb-cinergyT2.ko"} {d_ino=3D19915219, d_of=
f=3D403, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dvb-usb.mod.o.cmd=
"} {d_ino=3D19915220, d_off=3D407, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_=
name=3D".dvb-usb.ko.cmd"} {d_ino=3D19919113, d_off=3D411, d_type=3DDT_UNK=
NOWN, d_reclen=3D40, d_name=3D"dvb-usb-cinergyT2.o"} {d_ino=3D19919120, d=
_off=3D416, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D".dvb-usb-cinerg=
yT2.ko.cmd"} {d_ino=3D19915218, d_off=3D4294967295, d_type=3DDT_UNKNOWN, =
d_reclen=3D32, d_name=3D"dvb-usb.ko"}}, 4096) =3D 3656
_llseek(4, 416, [416], SEEK_SET)        =3D 0
getdents64(4, {{d_ino=3D19915218, d_off=3D4294967295, d_type=3DDT_UNKNOWN=
, d_reclen=3D32, d_name=3D"dvb-usb.ko"}}, 4096) =3D 32
close(4)                                =3D 0
write(1, ".c\0../linux/drivers/media/dvb/dv"..., 587) =3D 587
write(2, "/usr/src/findutils-4.1.20/find/f"..., 37) =3D 37
write(2, "../linux/drivers/media/dvb/dvb-u"..., 34) =3D 34
write(2, ": Der Wert ist zu gro\337 f\374r den d"..., 51) =3D 51
write(2, "\n", 1)                       =3D 1
lstat64("frontends", {st_dev=3Dmakedev(3, 1), st_ino=3D22601094, st_mode=3D=
S_IFDIR|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D32, st_size=3D12288, st_atime=3D2009/01/14-21:15:56, st_mtime=3D=
2009/01/09-18:14:50, st_ctime=3D2009/01/09-18:14:50}) =3D 0
open("frontends", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D22601094, st_mode=3DS_IFDIR|=
0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
32, st_size=3D12288, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2009/01/0=
9-18:14:50, st_ctime=3D2009/01/09-18:14:50}) =3D 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         =3D 0
getdents64(4, {{d_ino=3D22601094, d_off=3D4, d_type=3DDT_UNKNOWN, d_recle=
n=3D24, d_name=3D"."} {d_ino=3D3158162, d_off=3D6, d_type=3DDT_UNKNOWN, d=
_reclen=3D24, d_name=3D".."} {d_ino=3D22601095, d_off=3D9, d_type=3DDT_UN=
KNOWN, d_reclen=3D32, d_name=3D"Kconfig"} {d_ino=3D22601096, d_off=3D12, =
d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"Makefile"} {d_ino=3D2260109=
7, d_off=3D15, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"af9013.c"} {=
d_ino=3D22601098, d_off=3D18, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"af9013.h"} {d_ino=3D22601099, d_off=3D21, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D"af9013_priv.h"} {d_ino=3D22601100, d_off=3D24, d_type=3DDT_=
UNKNOWN, d_reclen=3D32, d_name=3D"au8522.c"} {d_ino=3D22601101, d_off=3D2=
7, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"au8522.h"} {d_ino=3D2260=
1102, d_off=3D30, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"bcm3510.c=
"} {d_ino=3D22601103, d_off=3D33, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_n=
ame=3D"bcm3510.h"} {d_ino=3D22601104, d_off=3D37, d_type=3DDT_UNKNOWN, d_=
reclen=3D40, d_name=3D"bcm3510_priv.h"} {d_ino=3D22601105, d_off=3D40, d_=
type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"bsbe1.h"} {d_ino=3D22601106, =
d_off=3D43, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"bsru6.h"} {d_in=
o=3D22601107, d_off=3D46, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"c=
x22700.c"} {d_ino=3D22601108, d_off=3D49, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"cx22700.h"} {d_ino=3D22601109, d_off=3D52, d_type=3DDT_UNKN=
OWN, d_reclen=3D32, d_name=3D"cx22702.c"} {d_ino=3D22601110, d_off=3D55, =
d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"cx22702.h"} {d_ino=3D226011=
11, d_off=3D58, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"cx24110.c"}=
 {d_ino=3D22601112, d_off=3D61, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_nam=
e=3D"cx24110.h"} {d_ino=3D22601113, d_off=3D64, d_type=3DDT_UNKNOWN, d_re=
clen=3D32, d_name=3D"cx24113.h"} {d_ino=3D22601114, d_off=3D67, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"cx24116.c"} {d_ino=3D22601115, d_off=
=3D70, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"cx24116.h"} {d_ino=3D=
22601116, d_off=3D73, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"cx241=
23.c"} {d_ino=3D22601117, d_off=3D76, d_type=3DDT_UNKNOWN, d_reclen=3D32,=
 d_name=3D"cx24123.h"} {d_ino=3D22601118, d_off=3D79, d_type=3DDT_UNKNOWN=
, d_reclen=3D32, d_name=3D"dib0070.c"} {d_ino=3D22601119, d_off=3D82, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dib0070.h"} {d_ino=3D22601120,=
 d_off=3D85, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dib3000.h"} {d=
_ino=3D22601121, d_off=3D88, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"dib3000mb.c"} {d_ino=3D22601122, d_off=3D92, d_type=3DDT_UNKNOWN, d_recl=
en=3D40, d_name=3D"dib3000mb_priv.h"} {d_ino=3D22601123, d_off=3D95, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dib3000mc.c"} {d_ino=3D22601124=
, d_off=3D98, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dib3000mc.h"}=
 {d_ino=3D22601125, d_off=3D101, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_na=
me=3D"dib7000m.c"} {d_ino=3D22601126, d_off=3D104, d_type=3DDT_UNKNOWN, d=
_reclen=3D32, d_name=3D"dib7000m.h"} {d_ino=3D22601127, d_off=3D107, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dib7000p.c"} {d_ino=3D22601128,=
 d_off=3D110, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dib7000p.h"} =
{d_ino=3D22601129, d_off=3D114, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_nam=
e=3D"dibx000_common.c"} {d_ino=3D22601130, d_off=3D118, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D"dibx000_common.h"} {d_ino=3D22601131, d_off=3D=
121, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"drx397xD.c"} {d_ino=3D=
22601132, d_off=3D124, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"drx3=
97xD.h"} {d_ino=3D22601133, d_off=3D127, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D"drx397xD_fw.h"} {d_ino=3D22601134, d_off=3D130, d_type=3DDT=
_UNKNOWN, d_reclen=3D32, d_name=3D"dvb-pll.c"} {d_ino=3D22601135, d_off=3D=
133, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dvb-pll.h"} {d_ino=3D2=
2601136, d_off=3D137, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dvb_d=
ummy_fe.c"} {d_ino=3D22601137, d_off=3D141, d_type=3DDT_UNKNOWN, d_reclen=
=3D40, d_name=3D"dvb_dummy_fe.h"} {d_ino=3D22601138, d_off=3D144, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"eds1547.h"} {d_ino=3D22601139, d_off=
=3D147, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"isl6405.c"} {d_ino=3D=
22601140, d_off=3D150, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"isl6=
405.h"} {d_ino=3D22601141, d_off=3D153, d_type=3DDT_UNKNOWN, d_reclen=3D3=
2, d_name=3D"isl6421.c"} {d_ino=3D22601142, d_off=3D156, d_type=3DDT_UNKN=
OWN, d_reclen=3D32, d_name=3D"isl6421.h"} {d_ino=3D22601143, d_off=3D159,=
 d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"itd1000.c"} {d_ino=3D22601=
144, d_off=3D162, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"itd1000.h=
"} {d_ino=3D22601145, d_off=3D166, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_=
name=3D"itd1000_priv.h"} {d_ino=3D22601146, d_off=3D169, d_type=3DDT_UNKN=
OWN, d_reclen=3D32, d_name=3D"l64781.c"} {d_ino=3D22601147, d_off=3D172, =
d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"l64781.h"} {d_ino=3D2260114=
8, d_off=3D175, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"lgdt330x.c"=
} {d_ino=3D22601149, d_off=3D178, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_n=
ame=3D"lgdt330x.h"} {d_ino=3D22601150, d_off=3D182, d_type=3DDT_UNKNOWN, =
d_reclen=3D40, d_name=3D"lgdt330x_priv.h"} {d_ino=3D22601151, d_off=3D185=
, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"lgs8gl5.c"} {d_ino=3D2262=
7648, d_off=3D188, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"lgs8gl5.=
h"} {d_ino=3D22627649, d_off=3D191, d_type=3DDT_UNKNOWN, d_reclen=3D32, d=
_name=3D"lnbp21.c"} {d_ino=3D22627650, d_off=3D194, d_type=3DDT_UNKNOWN, =
d_reclen=3D32, d_name=3D"lnbp21.h"} {d_ino=3D22627651, d_off=3D197, d_typ=
e=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mt312.c"} {d_ino=3D22627652, d_o=
ff=3D200, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mt312.h"} {d_ino=3D=
22627653, d_off=3D203, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mt31=
2_priv.h"} {d_ino=3D22627654, d_off=3D206, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"mt352.c"} {d_ino=3D22627655, d_off=3D209, d_type=3DDT_UNKNO=
WN, d_reclen=3D32, d_name=3D"mt352.h"} {d_ino=3D22627656, d_off=3D212, d_=
type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mt352_priv.h"} {d_ino=3D22627=
657, d_off=3D215, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"nxt200x.c=
"} {d_ino=3D22627658, d_off=3D218, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_=
name=3D"nxt200x.h"} {d_ino=3D22627659, d_off=3D221, d_type=3DDT_UNKNOWN, =
d_reclen=3D32, d_name=3D"nxt6000.c"} {d_ino=3D22627660, d_off=3D224, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"nxt6000.h"} {d_ino=3D22627661, =
d_off=3D228, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"nxt6000_priv.h=
"} {d_ino=3D22627662, d_off=3D231, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_=
name=3D"or51132.c"} {d_ino=3D22627663, d_off=3D234, d_type=3DDT_UNKNOWN, =
d_reclen=3D32, d_name=3D"or51132.h"} {d_ino=3D22627664, d_off=3D237, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"or51211.c"} {d_ino=3D22627665, =
d_off=3D240, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"or51211.h"} {d=
_ino=3D22627666, d_off=3D243, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"s5h1409.c"} {d_ino=3D22627667, d_off=3D246, d_type=3DDT_UNKNOWN, d_recle=
n=3D32, d_name=3D"s5h1409.h"} {d_ino=3D22627668, d_off=3D249, d_type=3DDT=
_UNKNOWN, d_reclen=3D32, d_name=3D"s5h1411.c"} {d_ino=3D22627669, d_off=3D=
252, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"s5h1411.h"} {d_ino=3D2=
2627670, d_off=3D255, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"s5h14=
20.c"} {d_ino=3D22627671, d_off=3D258, d_type=3DDT_UNKNOWN, d_reclen=3D32=
, d_name=3D"s5h1420.h"} {d_ino=3D22627672, d_off=3D262, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D"s5h1420_priv.h"} {d_ino=3D22627673, d_off=3D=
265, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"si21xx.c"} {d_ino=3D22=
627674, d_off=3D268, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"si21xx=
=2Eh"} {d_ino=3D22627675, d_off=3D271, d_type=3DDT_UNKNOWN, d_reclen=3D32=
, d_name=3D"sp8870.c"} {d_ino=3D22627676, d_off=3D274, d_type=3DDT_UNKNOW=
N, d_reclen=3D32, d_name=3D"sp8870.h"} {d_ino=3D22627677, d_off=3D277, d_=
type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"sp887x.c"} {d_ino=3D22627678,=
 d_off=3D280, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"sp887x.h"} {d=
_ino=3D22627679, d_off=3D283, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"stb6000.c"} {d_ino=3D22627680, d_off=3D286, d_type=3DDT_UNKNOWN, d_recle=
n=3D32, d_name=3D"stb6000.h"} {d_ino=3D22627681, d_off=3D289, d_type=3DDT=
_UNKNOWN, d_reclen=3D32, d_name=3D"stv0288.c"} {d_ino=3D22627682, d_off=3D=
292, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"stv0288.h"} {d_ino=3D2=
2627683, d_off=3D295, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"stv02=
97.c"} {d_ino=3D22627684, d_off=3D298, d_type=3DDT_UNKNOWN, d_reclen=3D32=
, d_name=3D"stv0297.h"} {d_ino=3D22627685, d_off=3D301, d_type=3DDT_UNKNO=
WN, d_reclen=3D32, d_name=3D"stv0299.c"} {d_ino=3D22627686, d_off=3D304, =
d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"stv0299.h"} {d_ino=3D226276=
87, d_off=3D307, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda10021.c=
"} {d_ino=3D22627688, d_off=3D310, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_=
name=3D"tda10023.c"} {d_ino=3D22627689, d_off=3D313, d_type=3DDT_UNKNOWN,=
 d_reclen=3D32, d_name=3D"tda1002x.h"} {d_ino=3D22627690, d_off=3D316, d_=
type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda10048.c"} {d_ino=3D2262769=
1, d_off=3D319, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda10048.h"=
} {d_ino=3D22627692, d_off=3D322, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_n=
ame=3D"tda1004x.c"} {d_ino=3D22627693, d_off=3D325, d_type=3DDT_UNKNOWN, =
d_reclen=3D32, d_name=3D"tda1004x.h"} {d_ino=3D22627694, d_off=3D328, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda10086.c"} {d_ino=3D22627695=
, d_off=3D331, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda10086.h"}=
 {d_ino=3D22627696, d_off=3D334, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_na=
me=3D"tda8083.c"} {d_ino=3D22627697, d_off=3D337, d_type=3DDT_UNKNOWN, d_=
reclen=3D32, d_name=3D"tda8083.h"} {d_ino=3D22627698, d_off=3D340, d_type=
=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda826x.c"} {d_ino=3D22627699, d_=
off=3D343, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda826x.h"} {d_i=
no=3D22627700, d_off=3D346, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"tdhd1.h"} {d_ino=3D22627701, d_off=3D349, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"tua6100.c"} {d_ino=3D22627702, d_off=3D352, d_type=3DDT_UNK=
NOWN, d_reclen=3D32, d_name=3D"tua6100.h"} {d_ino=3D22627703, d_off=3D355=
, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"ves1820.c"} {d_ino=3D2262=
7704, d_off=3D358, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"ves1820.=
h"} {d_ino=3D22627705, d_off=3D361, d_type=3DDT_UNKNOWN, d_reclen=3D32, d=
_name=3D"ves1x93.c"} {d_ino=3D22627706, d_off=3D364, d_type=3DDT_UNKNOWN,=
 d_reclen=3D32, d_name=3D"ves1x93.h"} {d_ino=3D22627707, d_off=3D367, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"z0194a.h"} {d_ino=3D22627708, =
d_off=3D370, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"zl10353.c"} {d=
_ino=3D22627709, d_off=3D373, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"zl10353.h"} {d_ino=3D22627710, d_off=3D377, d_type=3DDT_UNKNOWN, d_recle=
n=3D40, d_name=3D"zl10353_priv.h"} {d_ino=3D22718311, d_off=3D380, d_type=
=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"built-in.o"} {d_ino=3D22718312, d=
_off=3D384, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".built-in.o.cmd=
"} {d_ino=3D22729278, d_off=3D387, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_=
name=3D"tda8083.o"}}, 4096) =3D 4096
getdents64(4, {{d_ino=3D22729281, d_off=3D391, d_type=3DDT_UNKNOWN, d_rec=
len=3D48, d_name=3D".dibx000_common.o.cmd"} {d_ino=3D22729290, d_off=3D39=
5, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mt312.o"} {d_ino=3D22729=
268, d_off=3D398, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dvb-pll.o=
"} {d_ino=3D22729289, d_off=3D402, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_=
name=3D".ves1x93.o.cmd"} {d_ino=3D22729265, d_off=3D406, d_type=3DDT_UNKN=
OWN, d_reclen=3D40, d_name=3D".dvb-pll.o.cmd"} {d_ino=3D22729273, d_off=3D=
410, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda8083.o.cmd"} {d_in=
o=3D22729293, d_off=3D414, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"=
=2Esp887x.o.cmd"} {d_ino=3D22729296, d_off=3D417, d_type=3DDT_UNKNOWN, d_=
reclen=3D32, d_name=3D"tda1004x.o"} {d_ino=3D22729270, d_off=3D420, d_typ=
e=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"stv0299.o"} {d_ino=3D22729292, d=
_off=3D424, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"ves1820.o"} {d_=
ino=3D22729266, d_off=3D428, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
".stv0299.o.cmd"} {d_ino=3D22729277, d_off=3D432, d_type=3DDT_UNKNOWN, d_=
reclen=3D40, d_name=3D".dib3000mb.o.cmd"} {d_ino=3D22729283, d_off=3D438,=
 d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dib7000p.o.cmd"} {d_ino=3D=
22729272, d_off=3D441, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"sp88=
70.o"} {d_ino=3D22729298, d_off=3D444, d_type=3DDT_UNKNOWN, d_reclen=3D32=
, d_name=3D"sp887x.o"} {d_ino=3D22729267, d_off=3D447, d_type=3DDT_UNKNOW=
N, d_reclen=3D40, d_name=3D".sp8870.o.cmd"} {d_ino=3D22729280, d_off=3D45=
0, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"l64781.o"} {d_ino=3D2272=
9284, d_off=3D453, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dib3000m=
c.o"} {d_ino=3D22729288, d_off=3D458, d_type=3DDT_UNKNOWN, d_reclen=3D32,=
 d_name=3D"dib7000p.o"} {d_ino=3D22729274, d_off=3D461, d_type=3DDT_UNKNO=
WN, d_reclen=3D32, d_name=3D"cx22700.o"} {d_ino=3D22729291, d_off=3D465, =
d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda1004x.o.cmd"} {d_ino=3D=
22729269, d_off=3D469, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".cx2=
2700.o.cmd"} {d_ino=3D22729294, d_off=3D473, d_type=3DDT_UNKNOWN, d_recle=
n=3D32, d_name=3D"ves1x93.o"} {d_ino=3D22729286, d_off=3D477, d_type=3DDT=
_UNKNOWN, d_reclen=3D40, d_name=3D"dibx000_common.o"} {d_ino=3D22729297, =
d_off=3D480, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D".mt352.o.cmd"}=
 {d_ino=3D22729276, d_off=3D483, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_na=
me=3D"cx24110.o"} {d_ino=3D22731155, d_off=3D487, d_type=3DDT_UNKNOWN, d_=
reclen=3D40, d_name=3D".tda826x.o.cmd"} {d_ino=3D22729271, d_off=3D491, d=
_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".cx24110.o.cmd"} {d_ino=3D22=
729279, d_off=3D495, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dib30=
00mc.o.cmd"} {d_ino=3D22729287, d_off=3D500, d_type=3DDT_UNKNOWN, d_recle=
n=3D40, d_name=3D".ves1820.o.cmd"} {d_ino=3D22729275, d_off=3D503, d_type=
=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".l64781.o.cmd"} {d_ino=3D22729282=
, d_off=3D506, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dib3000mb.o"=
} {d_ino=3D22729285, d_off=3D509, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_n=
ame=3D".mt312.o.cmd"} {d_ino=3D22729300, d_off=3D514, d_type=3DDT_UNKNOWN=
, d_reclen=3D32, d_name=3D"nxt6000.o"} {d_ino=3D22729295, d_off=3D518, d_=
type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".nxt6000.o.cmd"} {d_ino=3D227=
40517, d_off=3D522, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dib3000=
mb.ko"} {d_ino=3D22729302, d_off=3D525, d_type=3DDT_UNKNOWN, d_reclen=3D3=
2, d_name=3D"mt352.o"} {d_ino=3D22740492, d_off=3D528, d_type=3DDT_UNKNOW=
N, d_reclen=3D40, d_name=3D"bcm3510.mod.o"} {d_ino=3D22740519, d_off=3D53=
2, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dib3000mb.ko.cmd"} {d_i=
no=3D22729304, d_off=3D535, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"zl10353.o"} {d_ino=3D22729299, d_off=3D539, d_type=3DDT_UNKNOWN, d_recle=
n=3D40, d_name=3D".zl10353.o.cmd"} {d_ino=3D22740493, d_off=3D542, d_type=
=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"bcm3510.ko"} {d_ino=3D22740518, d=
_off=3D546, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dib3000mb.mod.=
o.cmd"} {d_ino=3D22729306, d_off=3D549, d_type=3DDT_UNKNOWN, d_reclen=3D3=
2, d_name=3D"cx22702.o"} {d_ino=3D22729301, d_off=3D553, d_type=3DDT_UNKN=
OWN, d_reclen=3D40, d_name=3D".cx22702.o.cmd"} {d_ino=3D22740495, d_off=3D=
557, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".bcm3510.ko.cmd"} {d_i=
no=3D22740537, d_off=3D560, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"isl6421.ko"} {d_ino=3D22729308, d_off=3D563, d_type=3DDT_UNKNOWN, d_recl=
en=3D32, d_name=3D"tda10021.o"} {d_ino=3D22729303, d_off=3D567, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D".tda10021.o.cmd"} {d_ino=3D22740494,=
 d_off=3D571, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".bcm3510.mod.=
o.cmd"} {d_ino=3D22740540, d_off=3D574, d_type=3DDT_UNKNOWN, d_reclen=3D4=
0, d_name=3D"itd1000.mod.o"} {d_ino=3D22729310, d_off=3D577, d_type=3DDT_=
UNKNOWN, d_reclen=3D32, d_name=3D"tda10023.o"} {d_ino=3D22729305, d_off=3D=
581, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda10023.o.cmd"} {d_i=
no=3D22740496, d_off=3D584, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
"cx22700.mod.o"} {d_ino=3D22740520, d_off=3D588, d_type=3DDT_UNKNOWN, d_r=
eclen=3D40, d_name=3D"dib3000mc.mod.o"} {d_ino=3D22731136, d_off=3D591, d=
_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"stv0297.o"} {d_ino=3D2272930=
7, d_off=3D595, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".stv0297.o.=
cmd"} {d_ino=3D22740497, d_off=3D598, d_type=3DDT_UNKNOWN, d_reclen=3D32,=
 d_name=3D"cx22700.ko"} {d_ino=3D22740521, d_off=3D602, d_type=3DDT_UNKNO=
WN, d_reclen=3D32, d_name=3D"dib3000mc.ko"} {d_ino=3D22731138, d_off=3D60=
5, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"nxt200x.o"} {d_ino=3D227=
29309, d_off=3D609, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".nxt200=
x.o.cmd"} {d_ino=3D22740499, d_off=3D613, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D".cx22700.ko.cmd"} {d_ino=3D22740541, d_off=3D616, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"itd1000.ko"} {d_ino=3D22731140, d_of=
f=3D619, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"or51211.o"} {d_ino=
=3D22729311, d_off=3D623, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".=
or51211.o.cmd"} {d_ino=3D22740498, d_off=3D627, d_type=3DDT_UNKNOWN, d_re=
clen=3D40, d_name=3D".cx22700.mod.o.cmd"} {d_ino=3D22741824, d_off=3D630,=
 d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"l64781.mod.o"} {d_ino=3D22=
731142, d_off=3D633, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"or5113=
2.o"} {d_ino=3D22731137, d_off=3D637, d_type=3DDT_UNKNOWN, d_reclen=3D40,=
 d_name=3D".or51132.o.cmd"} {d_ino=3D22740500, d_off=3D640, d_type=3DDT_U=
NKNOWN, d_reclen=3D40, d_name=3D"cx22702.mod.o"} {d_ino=3D22740523, d_off=
=3D644, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dib3000mc.ko.cmd"}=
 {d_ino=3D22731144, d_off=3D647, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_na=
me=3D"bcm3510.o"} {d_ino=3D22731139, d_off=3D651, d_type=3DDT_UNKNOWN, d_=
reclen=3D40, d_name=3D".bcm3510.o.cmd"} {d_ino=3D22740501, d_off=3D654, d=
_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"cx22702.ko"} {d_ino=3D227405=
22, d_off=3D658, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dib3000mc=
=2Emod.o.cmd"} {d_ino=3D22731146, d_off=3D661, d_type=3DDT_UNKNOWN, d_rec=
len=3D32, d_name=3D"s5h1420.o"} {d_ino=3D22731141, d_off=3D665, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D".s5h1420.o.cmd"} {d_ino=3D22740503, =
d_off=3D669, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".cx22702.ko.cm=
d"} {d_ino=3D22741825, d_off=3D672, d_type=3DDT_UNKNOWN, d_reclen=3D32, d=
_name=3D"l64781.ko"} {d_ino=3D22731148, d_off=3D675, d_type=3DDT_UNKNOWN,=
 d_reclen=3D32, d_name=3D"lgdt330x.o"} {d_ino=3D22731143, d_off=3D679, d_=
type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".lgdt330x.o.cmd"} {d_ino=3D22=
740502, d_off=3D683, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".cx227=
02.mod.o.cmd"} {d_ino=3D22741829, d_off=3D686, d_type=3DDT_UNKNOWN, d_rec=
len=3D32, d_name=3D"lgdt330x.ko"} {d_ino=3D22731150, d_off=3D689, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"cx24123.o"} {d_ino=3D22731145, d_off=
=3D693, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".cx24123.o.cmd"} {d=
_ino=3D22740504, d_off=3D696, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
"cx24110.mod.o"} {d_ino=3D22740524, d_off=3D700, d_type=3DDT_UNKNOWN, d_r=
eclen=3D40, d_name=3D"dib7000p.mod.o"} {d_ino=3D22731152, d_off=3D703, d_=
type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"lnbp21.o"} {d_ino=3D22731147,=
 d_off=3D706, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".lnbp21.o.cmd=
"} {d_ino=3D22740505, d_off=3D709, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_=
name=3D"cx24110.ko"} {d_ino=3D22740525, d_off=3D713, d_type=3DDT_UNKNOWN,=
 d_reclen=3D32, d_name=3D"dib7000p.ko"} {d_ino=3D22731154, d_off=3D716, d=
_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"isl6421.o"} {d_ino=3D2273114=
9, d_off=3D720, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".isl6421.o.=
cmd"} {d_ino=3D22740507, d_off=3D724, d_type=3DDT_UNKNOWN, d_reclen=3D40,=
 d_name=3D".cx24110.ko.cmd"} {d_ino=3D22741832, d_off=3D727, d_type=3DDT_=
UNKNOWN, d_reclen=3D32, d_name=3D"lnbp21.mod.o"} {d_ino=3D22731156, d_off=
=3D730, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda10086.o"} {d_ino=
=3D22731151, d_off=3D734, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".=
tda10086.o.cmd"} {d_ino=3D22740482, d_off=3D737, d_type=3DDT_UNKNOWN, d_r=
eclen=3D40, d_name=3D"cx24116.mod.c"} {d_ino=3D22740512, d_off=3D742, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"cx24123.mod.o"} {d_ino=3D22731=
158, d_off=3D745, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda826x.o=
"} {d_ino=3D22737049, d_off=3D748, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_=
name=3D"l64781.mod.c"} {d_ino=3D22740483, d_off=3D751, d_type=3DDT_UNKNOW=
N, d_reclen=3D40, d_name=3D"cx24110.mod.c"} {d_ino=3D22740514, d_off=3D75=
6, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".cx24123.mod.o.cmd"} {d_=
ino=3D22731160, d_off=3D759, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"tua6100.o"} {d_ino=3D22740527, d_off=3D763, d_type=3DDT_UNKNOWN, d_recle=
n=3D40, d_name=3D".dib7000p.ko.cmd"} {d_ino=3D22731153, d_off=3D767, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tua6100.o.cmd"} {d_ino=3D22737=
050, d_off=3D770, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"itd1000.m=
od.c"} {d_ino=3D22740484, d_off=3D773, d_type=3DDT_UNKNOWN, d_reclen=3D40=
, d_name=3D"cx22702.mod.c"} {d_ino=3D22740513, d_off=3D778, d_type=3DDT_U=
NKNOWN, d_reclen=3D32, d_name=3D"cx24123.ko"} {d_ino=3D22731162, d_off=3D=
781, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"s5h1409.o"} {d_ino=3D2=
2740526, d_off=3D785, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dib7=
000p.mod.o.cmd"} {d_ino=3D22731157, d_off=3D789, d_type=3DDT_UNKNOWN, d_r=
eclen=3D40, d_name=3D".s5h1409.o.cmd"}}, 4096) =3D 4080
getdents64(4, {{d_ino=3D22737051, d_off=3D792, d_type=3DDT_UNKNOWN, d_rec=
len=3D40, d_name=3D"isl6421.mod.c"} {d_ino=3D22740485, d_off=3D795, d_typ=
e=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"cx22700.mod.c"} {d_ino=3D2274051=
5, d_off=3D800, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".cx24123.ko=
=2Ecmd"} {d_ino=3D22731164, d_off=3D803, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"itd1000.o"} {d_ino=3D22740528, d_off=3D807, d_type=3DDT_UNK=
NOWN, d_reclen=3D40, d_name=3D"dibx000_common.mod.o"} {d_ino=3D22731159, =
d_off=3D811, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".itd1000.o.cmd=
"} {d_ino=3D22737052, d_off=3D814, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_=
name=3D"dvb-pll.mod.c"} {d_ino=3D22740486, d_off=3D817, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D"bcm3510.mod.c"} {d_ino=3D22740516, d_off=3D8=
22, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dib3000mb.mod.o"} {d_in=
o=3D22731166, d_off=3D825, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"=
tda10048.o"} {d_ino=3D22740529, d_off=3D829, d_type=3DDT_UNKNOWN, d_recle=
n=3D40, d_name=3D"dibx000_common.ko"} {d_ino=3D22731161, d_off=3D833, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda10048.o.cmd"} {d_ino=3D227=
37053, d_off=3D837, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dibx000=
_common.mod.c"} {d_ino=3D22740506, d_off=3D841, d_type=3DDT_UNKNOWN, d_re=
clen=3D40, d_name=3D".cx24110.mod.o.cmd"} {d_ino=3D22741833, d_off=3D844,=
 d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"lnbp21.ko"} {d_ino=3D22731=
168, d_off=3D847, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"s5h1411.o=
"} {d_ino=3D22740532, d_off=3D851, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_=
name=3D"dvb-pll.mod.o"} {d_ino=3D22731163, d_off=3D855, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D".s5h1411.o.cmd"} {d_ino=3D22737054, d_off=3D=
859, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dib7000p.mod.c"} {d_in=
o=3D22740508, d_off=3D862, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"=
cx24116.mod.o"} {d_ino=3D22740533, d_off=3D866, d_type=3DDT_UNKNOWN, d_re=
clen=3D32, d_name=3D"dvb-pll.ko"} {d_ino=3D22731170, d_off=3D869, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"cx24116.o"} {d_ino=3D22740535, d_off=
=3D873, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dvb-pll.ko.cmd"} {=
d_ino=3D22731165, d_off=3D877, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=
=3D".cx24116.o.cmd"} {d_ino=3D22737055, d_off=3D881, d_type=3DDT_UNKNOWN,=
 d_reclen=3D40, d_name=3D"dib3000mc.mod.c"} {d_ino=3D22740510, d_off=3D88=
5, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".cx24116.mod.o.cmd"} {d_=
ino=3D22741836, d_off=3D888, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"mt312.mod.o"} {d_ino=3D22731172, d_off=3D891, d_type=3DDT_UNKNOWN, d_rec=
len=3D32, d_name=3D"stv0288.o"} {d_ino=3D22740534, d_off=3D895, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D".dvb-pll.mod.o.cmd"} {d_ino=3D227311=
67, d_off=3D899, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".stv0288.o=
=2Ecmd"} {d_ino=3D22740480, d_off=3D903, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D"dib3000mb.mod.c"} {d_ino=3D22740509, d_off=3D906, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"cx24116.ko"} {d_ino=3D22740536, d_of=
f=3D910, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"isl6421.mod.o"} {d=
_ino=3D22731174, d_off=3D913, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"stb6000.o"} {d_ino=3D22740538, d_off=3D917, d_type=3DDT_UNKNOWN, d_recle=
n=3D40, d_name=3D".isl6421.mod.o.cmd"} {d_ino=3D22731169, d_off=3D921, d_=
type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".stb6000.o.cmd"} {d_ino=3D227=
31171, d_off=3D924, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"modules=
=2Eorder"} {d_ino=3D22737021, d_off=3D927, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D"zl10353.mod.c"} {d_ino=3D22737022, d_off=3D930, d_type=3DDT=
_UNKNOWN, d_reclen=3D40, d_name=3D"ves1x93.mod.c"} {d_ino=3D22737023, d_o=
ff=3D933, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"ves1820.mod.c"} {=
d_ino=3D22737024, d_off=3D936, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=
=3D"tua6100.mod.c"} {d_ino=3D22737025, d_off=3D939, d_type=3DDT_UNKNOWN, =
d_reclen=3D40, d_name=3D"tda826x.mod.c"} {d_ino=3D22737026, d_off=3D942, =
d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tda8083.mod.c"} {d_ino=3D22=
737027, d_off=3D946, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tda100=
86.mod.c"} {d_ino=3D22737028, d_off=3D950, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D"tda1004x.mod.c"} {d_ino=3D22737029, d_off=3D954, d_type=3DD=
T_UNKNOWN, d_reclen=3D40, d_name=3D"tda10048.mod.c"} {d_ino=3D22737030, d=
_off=3D958, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tda10023.mod.c"=
} {d_ino=3D22737031, d_off=3D962, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_n=
ame=3D"tda10021.mod.c"} {d_ino=3D22737032, d_off=3D965, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D"stv0299.mod.c"} {d_ino=3D22737033, d_off=3D9=
68, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"stv0297.mod.c"} {d_ino=3D=
22737034, d_off=3D971, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"stv0=
288.mod.c"} {d_ino=3D22737035, d_off=3D974, d_type=3DDT_UNKNOWN, d_reclen=
=3D40, d_name=3D"stb6000.mod.c"} {d_ino=3D22737036, d_off=3D977, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"sp887x.mod.c"} {d_ino=3D22737037, d_=
off=3D980, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"sp8870.mod.c"} {=
d_ino=3D22737038, d_off=3D983, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=
=3D"s5h1420.mod.c"} {d_ino=3D22737039, d_off=3D986, d_type=3DDT_UNKNOWN, =
d_reclen=3D40, d_name=3D"s5h1411.mod.c"} {d_ino=3D22737040, d_off=3D989, =
d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"s5h1409.mod.c"} {d_ino=3D22=
737041, d_off=3D992, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"or5121=
1.mod.c"} {d_ino=3D22737042, d_off=3D995, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D"or51132.mod.c"} {d_ino=3D22737043, d_off=3D998, d_type=3DDT=
_UNKNOWN, d_reclen=3D40, d_name=3D"nxt6000.mod.c"} {d_ino=3D22737044, d_o=
ff=3D1001, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"nxt200x.mod.c"} =
{d_ino=3D22737045, d_off=3D1004, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_na=
me=3D"mt352.mod.c"} {d_ino=3D22737046, d_off=3D1007, d_type=3DDT_UNKNOWN,=
 d_reclen=3D32, d_name=3D"mt312.mod.c"} {d_ino=3D22737047, d_off=3D1010, =
d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"lnbp21.mod.c"} {d_ino=3D227=
37048, d_off=3D1014, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"lgdt33=
0x.mod.c"} {d_ino=3D22740481, d_off=3D1017, d_type=3DDT_UNKNOWN, d_reclen=
=3D40, d_name=3D"cx24123.mod.c"} {d_ino=3D22740511, d_off=3D1021, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D".cx24116.ko.cmd"} {d_ino=3D22741837,=
 d_off=3D1026, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mt312.ko"} {=
d_ino=3D22741911, d_off=3D1030, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_nam=
e=3D".tda1004x.ko.cmd"} {d_ino=3D22741936, d_off=3D1036, d_type=3DDT_UNKN=
OWN, d_reclen=3D40, d_name=3D"zl10353.mod.o"} {d_ino=3D22740530, d_off=3D=
1041, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D".dibx000_common.mod.o=
=2Ecmd"} {d_ino=3D22740531, d_off=3D1046, d_type=3DDT_UNKNOWN, d_reclen=3D=
48, d_name=3D".dibx000_common.ko.cmd"} {d_ino=3D22740539, d_off=3D1050, d=
_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".isl6421.ko.cmd"} {d_ino=3D2=
2741912, d_off=3D1058, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tda1=
0086.mod.o"} {d_ino=3D22740542, d_off=3D1062, d_type=3DDT_UNKNOWN, d_recl=
en=3D40, d_name=3D".itd1000.mod.o.cmd"} {d_ino=3D22740543, d_off=3D1066, =
d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".itd1000.ko.cmd"} {d_ino=3D=
22741913, d_off=3D1069, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda=
10086.ko"} {d_ino=3D22741937, d_off=3D1074, d_type=3DDT_UNKNOWN, d_reclen=
=3D32, d_name=3D"zl10353.ko"} {d_ino=3D22741826, d_off=3D1078, d_type=3DD=
T_UNKNOWN, d_reclen=3D40, d_name=3D".l64781.mod.o.cmd"} {d_ino=3D22741827=
, d_off=3D1082, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".l64781.ko.=
cmd"} {d_ino=3D22741828, d_off=3D1086, d_type=3DDT_UNKNOWN, d_reclen=3D40=
, d_name=3D"lgdt330x.mod.o"} {d_ino=3D22741915, d_off=3D1094, d_type=3DDT=
_UNKNOWN, d_reclen=3D40, d_name=3D".tda10086.ko.cmd"} {d_ino=3D22741830, =
d_off=3D1098, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".lgdt330x.mod=
=2Eo.cmd"} {d_ino=3D22741831, d_off=3D1102, d_type=3DDT_UNKNOWN, d_reclen=
=3D40, d_name=3D".lgdt330x.ko.cmd"} {d_ino=3D22741914, d_off=3D1110, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda10086.mod.o.cmd"} {d_ino=3D=
22741834, d_off=3D1114, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".ln=
bp21.mod.o.cmd"} {d_ino=3D22741835, d_off=3D1118, d_type=3DDT_UNKNOWN, d_=
reclen=3D40, d_name=3D".lnbp21.ko.cmd"} {d_ino=3D22741916, d_off=3D1121, =
d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tda8083.mod.o"} {d_ino=3D22=
741939, d_off=3D1126, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".zl10=
353.ko.cmd"} {d_ino=3D22741838, d_off=3D1130, d_type=3DDT_UNKNOWN, d_recl=
en=3D40, d_name=3D".mt312.mod.o.cmd"} {d_ino=3D22741839, d_off=3D1133, d_=
type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".mt312.ko.cmd"} {d_ino=3D2274=
1840, d_off=3D1136, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mt352.m=
od.o"} {d_ino=3D22741917, d_off=3D1139, d_type=3DDT_UNKNOWN, d_reclen=3D3=
2, d_name=3D"tda8083.ko"} {d_ino=3D22741938, d_off=3D1144, d_type=3DDT_UN=
KNOWN, d_reclen=3D40, d_name=3D".zl10353.mod.o.cmd"} {d_ino=3D22741842, d=
_off=3D1148, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".mt352.mod.o.c=
md"} {d_ino=3D22741841, d_off=3D1151, d_type=3DDT_UNKNOWN, d_reclen=3D32,=
 d_name=3D"mt352.ko"} {d_ino=3D22741843, d_off=3D1154, d_type=3DDT_UNKNOW=
N, d_reclen=3D40, d_name=3D".mt352.ko.cmd"} {d_ino=3D22741844, d_off=3D11=
57, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"nxt200x.mod.o"} {d_ino=3D=
22741919, d_off=3D1165, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".td=
a8083.ko.cmd"} {d_ino=3D22741846, d_off=3D1169, d_type=3DDT_UNKNOWN, d_re=
clen=3D40, d_name=3D".nxt200x.mod.o.cmd"} {d_ino=3D22741845, d_off=3D1172=
, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"nxt200x.ko"} {d_ino=3D227=
41847, d_off=3D1176, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".nxt20=
0x.ko.cmd"} {d_ino=3D22741848, d_off=3D1179, d_type=3DDT_UNKNOWN, d_recle=
n=3D40, d_name=3D"nxt6000.mod.o"} {d_ino=3D22741918, d_off=3D1187, d_type=
=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda8083.mod.o.cmd"} {d_ino=3D227=
41850, d_off=3D1191, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".nxt60=
00.mod.o.cmd"} {d_ino=3D22741849, d_off=3D1194, d_type=3DDT_UNKNOWN, d_re=
clen=3D32, d_name=3D"nxt6000.ko"}}, 4096) =3D 4072
getdents64(4, {{d_ino=3D22741851, d_off=3D1198, d_type=3DDT_UNKNOWN, d_re=
clen=3D40, d_name=3D".nxt6000.ko.cmd"} {d_ino=3D22741852, d_off=3D1201, d=
_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"or51132.mod.o"} {d_ino=3D227=
41920, d_off=3D1204, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tda826=
x.mod.o"} {d_ino=3D22749297, d_off=3D1209, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D".si21xx.o.cmd"} {d_ino=3D22741854, d_off=3D1213, d_type=3DD=
T_UNKNOWN, d_reclen=3D40, d_name=3D".or51132.mod.o.cmd"} {d_ino=3D2274185=
3, d_off=3D1216, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"or51132.ko=
"} {d_ino=3D22741855, d_off=3D1220, d_type=3DDT_UNKNOWN, d_reclen=3D40, d=
_name=3D".or51132.ko.cmd"} {d_ino=3D22741856, d_off=3D1223, d_type=3DDT_U=
NKNOWN, d_reclen=3D40, d_name=3D"or51211.mod.o"} {d_ino=3D22741921, d_off=
=3D1226, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda826x.ko"} {d_in=
o=3D22749298, d_off=3D1231, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"si21xx.mod.c"} {d_ino=3D22741858, d_off=3D1235, d_type=3DDT_UNKNOWN, d_r=
eclen=3D40, d_name=3D".or51211.mod.o.cmd"} {d_ino=3D22741857, d_off=3D123=
8, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"or51211.ko"} {d_ino=3D22=
741859, d_off=3D1242, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".or51=
211.ko.cmd"} {d_ino=3D22741860, d_off=3D1245, d_type=3DDT_UNKNOWN, d_recl=
en=3D40, d_name=3D"s5h1409.mod.o"} {d_ino=3D22741923, d_off=3D1253, d_typ=
e=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda826x.ko.cmd"} {d_ino=3D22741=
862, d_off=3D1257, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".s5h1409=
=2Emod.o.cmd"} {d_ino=3D22741861, d_off=3D1260, d_type=3DDT_UNKNOWN, d_re=
clen=3D32, d_name=3D"s5h1409.ko"} {d_ino=3D22741863, d_off=3D1264, d_type=
=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".s5h1409.ko.cmd"} {d_ino=3D227418=
64, d_off=3D1267, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"s5h1411.m=
od.o"} {d_ino=3D22741922, d_off=3D1275, d_type=3DDT_UNKNOWN, d_reclen=3D4=
0, d_name=3D".tda826x.mod.o.cmd"} {d_ino=3D22741866, d_off=3D1279, d_type=
=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".s5h1411.mod.o.cmd"} {d_ino=3D227=
41865, d_off=3D1282, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"s5h141=
1.ko"} {d_ino=3D22741867, d_off=3D1286, d_type=3DDT_UNKNOWN, d_reclen=3D4=
0, d_name=3D".s5h1411.ko.cmd"} {d_ino=3D22741868, d_off=3D1289, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D"s5h1420.mod.o"} {d_ino=3D22741924, d=
_off=3D1292, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tua6100.mod.o"=
} {d_ino=3D22749299, d_off=3D1297, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_=
name=3D"si21xx.mod.o"} {d_ino=3D22741870, d_off=3D1301, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D".s5h1420.mod.o.cmd"} {d_ino=3D22741869, d_of=
f=3D1304, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"s5h1420.ko"} {d_i=
no=3D22741871, d_off=3D1308, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
".s5h1420.ko.cmd"} {d_ino=3D22741872, d_off=3D1311, d_type=3DDT_UNKNOWN, =
d_reclen=3D32, d_name=3D"sp8870.mod.o"} {d_ino=3D22741925, d_off=3D1314, =
d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tua6100.ko"} {d_ino=3D22749=
300, d_off=3D1319, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"si21xx.o=
"} {d_ino=3D22741874, d_off=3D1323, d_type=3DDT_UNKNOWN, d_reclen=3D40, d=
_name=3D".sp8870.mod.o.cmd"} {d_ino=3D22741873, d_off=3D1326, d_type=3DDT=
_UNKNOWN, d_reclen=3D32, d_name=3D"sp8870.ko"} {d_ino=3D22741875, d_off=3D=
1330, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".sp8870.ko.cmd"} {d_i=
no=3D22741876, d_off=3D1333, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"sp887x.mod.o"} {d_ino=3D22741927, d_off=3D1341, d_type=3DDT_UNKNOWN, d_r=
eclen=3D40, d_name=3D".tua6100.ko.cmd"} {d_ino=3D22741878, d_off=3D1345, =
d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".sp887x.mod.o.cmd"} {d_ino=3D=
22741877, d_off=3D1348, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"sp8=
87x.ko"} {d_ino=3D22741879, d_off=3D1352, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D".sp887x.ko.cmd"} {d_ino=3D22741880, d_off=3D1355, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D"stb6000.mod.o"} {d_ino=3D22741926, d=
_off=3D1363, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tua6100.mod.o=
=2Ecmd"} {d_ino=3D22741882, d_off=3D1367, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D".stb6000.mod.o.cmd"} {d_ino=3D22741881, d_off=3D1370, d_typ=
e=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"stb6000.ko"} {d_ino=3D22741883, =
d_off=3D1374, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".stb6000.ko.c=
md"} {d_ino=3D22741884, d_off=3D1377, d_type=3DDT_UNKNOWN, d_reclen=3D40,=
 d_name=3D"stv0288.mod.o"} {d_ino=3D22741928, d_off=3D1380, d_type=3DDT_U=
NKNOWN, d_reclen=3D40, d_name=3D"ves1820.mod.o"} {d_ino=3D22749302, d_off=
=3D1385, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".si21xx.mod.o.cmd"=
} {d_ino=3D22741886, d_off=3D1389, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_=
name=3D".stv0288.mod.o.cmd"} {d_ino=3D22741885, d_off=3D1392, d_type=3DDT=
_UNKNOWN, d_reclen=3D32, d_name=3D"stv0288.ko"} {d_ino=3D22741887, d_off=3D=
1396, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".stv0288.ko.cmd"} {d_=
ino=3D22741888, d_off=3D1399, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
"stv0297.mod.o"} {d_ino=3D22741929, d_off=3D1402, d_type=3DDT_UNKNOWN, d_=
reclen=3D32, d_name=3D"ves1820.ko"} {d_ino=3D22749301, d_off=3D1407, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"si21xx.ko"} {d_ino=3D22741890, =
d_off=3D1411, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".stv0297.mod.=
o.cmd"} {d_ino=3D22741889, d_off=3D1414, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"stv0297.ko"} {d_ino=3D22741891, d_off=3D1418, d_type=3DDT_U=
NKNOWN, d_reclen=3D40, d_name=3D".stv0297.ko.cmd"} {d_ino=3D22741892, d_o=
ff=3D1421, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"stv0299.mod.o"} =
{d_ino=3D22741931, d_off=3D1429, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_na=
me=3D".ves1820.ko.cmd"} {d_ino=3D22741894, d_off=3D1433, d_type=3DDT_UNKN=
OWN, d_reclen=3D40, d_name=3D".stv0299.mod.o.cmd"} {d_ino=3D22741893, d_o=
ff=3D1436, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"stv0299.ko"} {d_=
ino=3D22741895, d_off=3D1440, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
".stv0299.ko.cmd"} {d_ino=3D22741896, d_off=3D1444, d_type=3DDT_UNKNOWN, =
d_reclen=3D40, d_name=3D"tda10021.mod.o"} {d_ino=3D22741930, d_off=3D1452=
, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".ves1820.mod.o.cmd"} {d_i=
no=3D22741898, d_off=3D1456, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
".tda10021.mod.o.cmd"} {d_ino=3D22741897, d_off=3D1459, d_type=3DDT_UNKNO=
WN, d_reclen=3D32, d_name=3D"tda10021.ko"} {d_ino=3D22741899, d_off=3D146=
3, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda10021.ko.cmd"} {d_in=
o=3D22741900, d_off=3D1467, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
"tda10023.mod.o"} {d_ino=3D22741932, d_off=3D1470, d_type=3DDT_UNKNOWN, d=
_reclen=3D40, d_name=3D"ves1x93.mod.o"} {d_ino=3D22749303, d_off=3D1475, =
d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".si21xx.ko.cmd"} {d_ino=3D2=
2741902, d_off=3D1479, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda=
10023.mod.o.cmd"} {d_ino=3D22741901, d_off=3D1482, d_type=3DDT_UNKNOWN, d=
_reclen=3D32, d_name=3D"tda10023.ko"} {d_ino=3D22741903, d_off=3D1486, d_=
type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda10023.ko.cmd"} {d_ino=3D2=
2741904, d_off=3D1490, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tda1=
0048.mod.o"} {d_ino=3D22741934, d_off=3D1498, d_type=3DDT_UNKNOWN, d_recl=
en=3D40, d_name=3D".ves1x93.mod.o.cmd"} {d_ino=3D22741906, d_off=3D1502, =
d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda10048.mod.o.cmd"} {d_in=
o=3D22741905, d_off=3D1505, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"tda10048.ko"} {d_ino=3D22741907, d_off=3D1509, d_type=3DDT_UNKNOWN, d_re=
clen=3D40, d_name=3D".tda10048.ko.cmd"} {d_ino=3D22741908, d_off=3D1513, =
d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tda1004x.mod.o"} {d_ino=3D2=
2741933, d_off=3D1521, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"ves1=
x93.ko"} {d_ino=3D22741910, d_off=3D1525, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D".tda1004x.mod.o.cmd"} {d_ino=3D22741909, d_off=3D1528, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda1004x.ko"} {d_ino=3D22741935=
, d_off=3D4294967295, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".ves1=
x93.ko.cmd"}}, 4096) =3D 3120
_llseek(4, 1528, [1528], SEEK_SET)      =3D 0
getdents64(4, {{d_ino=3D22741935, d_off=3D4294967295, d_type=3DDT_UNKNOWN=
, d_reclen=3D40, d_name=3D".ves1x93.ko.cmd"}}, 4096) =3D 40
close(4)                                =3D 0
write(2, "/usr/src/findutils-4.1.20/find/f"..., 37) =3D 37
write(2, "../linux/drivers/media/dvb/front"..., 36) =3D 36
write(2, ": Der Wert ist zu gro\337 f\374r den d"..., 51) =3D 51
write(2, "\n", 1)                       =3D 1
lstat64("pluto2", {st_dev=3Dmakedev(3, 1), st_ino=3D31869976, st_mode=3DS=
_IFDIR|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_=
blocks=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D20=
09/01/09-18:14:50, st_ctime=3D2009/01/09-18:14:50}) =3D 0
open("pluto2", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D31869976, st_mode=3DS_IFDIR|=
0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
8, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2009/01/09-=
18:14:50, st_ctime=3D2009/01/09-18:14:50}) =3D 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         =3D 0
getdents64(4, {{d_ino=3D31869976, d_off=3D4, d_type=3DDT_UNKNOWN, d_recle=
n=3D24, d_name=3D"."} {d_ino=3D3158162, d_off=3D6, d_type=3DDT_UNKNOWN, d=
_reclen=3D24, d_name=3D".."} {d_ino=3D31869977, d_off=3D9, d_type=3DDT_UN=
KNOWN, d_reclen=3D32, d_name=3D"Kconfig"} {d_ino=3D31869978, d_off=3D12, =
d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"Makefile"} {d_ino=3D3186997=
9, d_off=3D15, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"pluto2.c"} {=
d_ino=3D32013736, d_off=3D18, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"built-in.o"} {d_ino=3D32013737, d_off=3D22, d_type=3DDT_UNKNOWN, d_recle=
n=3D40, d_name=3D".built-in.o.cmd"} {d_ino=3D32048442, d_off=3D31, d_type=
=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"modules.order"} {d_ino=3D32062198=
, d_off=3D37, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"pluto2.o"} {d=
_ino=3D32062200, d_off=3D40, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
".pluto2.o.cmd"} {d_ino=3D32062199, d_off=3D43, d_type=3DDT_UNKNOWN, d_re=
clen=3D32, d_name=3D"pluto2.mod.c"} {d_ino=3D32062201, d_off=3D54, d_type=
=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"pluto2.mod.o"} {d_ino=3D32062203,=
 d_off=3D58, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".pluto2.mod.o.=
cmd"} {d_ino=3D32062202, d_off=3D61, d_type=3DDT_UNKNOWN, d_reclen=3D32, =
d_name=3D"pluto2.ko"} {d_ino=3D32062204, d_off=3D512, d_type=3DDT_UNKNOWN=
, d_reclen=3D40, d_name=3D".pluto2.ko.cmd"}}, 4096) =3D 504
getdents64(4, {}, 4096)                 =3D 0
close(4)                                =3D 0
chdir("pluto2")                         =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D31869976, st_mode=3DS_IFDI=
R|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01=
/09-18:14:50, st_ctime=3D2009/01/09-18:14:50}) =3D 0
lstat64("pluto2.c", {st_dev=3Dmakedev(3, 1), st_ino=3D31869979, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D40, st_size=3D20122, st_atime=3D2009/01/08-18:34:03, st_mtime=3D=
2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:08}) =3D 0
lstat64("pluto2.mod.c", {st_dev=3Dmakedev(3, 1), st_ino=3D32062199, st_mo=
de=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D409=
6, st_blocks=3D8, st_size=3D2132, st_atime=3D2009/01/09-18:14:50, st_mtim=
e=3D2009/01/09-18:14:49, st_ctime=3D2009/01/09-18:14:49}) =3D 0
chdir("..")                             =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D3158162, st_mode=3DS_IFDIR=
|0755, st_nlink=3D13, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01=
/08-19:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
lstat64("siano", {st_dev=3Dmakedev(3, 1), st_ino=3D31869980, st_mode=3DS_=
IFDIR|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_b=
locks=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D200=
9/01/08-19:34:24, st_ctime=3D2009/01/08-19:34:24}) =3D 0
open("siano", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D31869980, st_mode=3DS_IFDIR|=
0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
8, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2009/01/08-=
19:34:24, st_ctime=3D2009/01/08-19:34:24}) =3D 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         =3D 0
getdents64(4, {{d_ino=3D31869980, d_off=3D4, d_type=3DDT_UNKNOWN, d_recle=
n=3D24, d_name=3D"."} {d_ino=3D3158162, d_off=3D6, d_type=3DDT_UNKNOWN, d=
_reclen=3D24, d_name=3D".."} {d_ino=3D31869981, d_off=3D9, d_type=3DDT_UN=
KNOWN, d_reclen=3D32, d_name=3D"Kconfig"} {d_ino=3D31869982, d_off=3D12, =
d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"Makefile"} {d_ino=3D3186998=
3, d_off=3D15, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"sms-cards.c"=
} {d_ino=3D31869984, d_off=3D18, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_na=
me=3D"sms-cards.h"} {d_ino=3D31869985, d_off=3D21, d_type=3DDT_UNKNOWN, d=
_reclen=3D32, d_name=3D"smscoreapi.c"} {d_ino=3D31869986, d_off=3D24, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"smscoreapi.h"} {d_ino=3D318699=
87, d_off=3D27, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"smsdvb.c"} =
{d_ino=3D31869988, d_off=3D30, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=
=3D"smsusb.c"} {d_ino=3D32013738, d_off=3D33, d_type=3DDT_UNKNOWN, d_recl=
en=3D32, d_name=3D"built-in.o"} {d_ino=3D32013739, d_off=3D37, d_type=3DD=
T_UNKNOWN, d_reclen=3D40, d_name=3D".built-in.o.cmd"} {d_ino=3D32048443, =
d_off=3D512, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"modules.order"=
}}, 4096) =3D 416
getdents64(4, {}, 4096)                 =3D 0
close(4)                                =3D 0
chdir("siano")                          =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D31869980, st_mode=3DS_IFDI=
R|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01=
/08-19:34:24, st_ctime=3D2009/01/08-19:34:24}) =3D 0
lstat64("sms-cards.c", {st_dev=3Dmakedev(3, 1), st_ino=3D31869983, st_mod=
e=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096=
, st_blocks=3D8, st_size=3D3497, st_atime=3D2009/01/08-18:34:03, st_mtime=
=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:08}) =3D 0
lstat64("sms-cards.h", {st_dev=3Dmakedev(3, 1), st_ino=3D31869984, st_mod=
e=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096=
, st_blocks=3D8, st_size=3D1383, st_atime=3D2009/01/08-18:34:03, st_mtime=
=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:08}) =3D 0
lstat64("smscoreapi.c", {st_dev=3Dmakedev(3, 1), st_ino=3D31869985, st_mo=
de=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D409=
6, st_blocks=3D64, st_size=3D32411, st_atime=3D2009/01/08-18:34:03, st_mt=
ime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("smscoreapi.h", {st_dev=3Dmakedev(3, 1), st_ino=3D31869986, st_mo=
de=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D409=
6, st_blocks=3D32, st_size=3D12932, st_atime=3D2009/01/08-18:34:03, st_mt=
ime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("smsdvb.c", {st_dev=3Dmakedev(3, 1), st_ino=3D31869987, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D24, st_size=3D11165, st_atime=3D2009/01/08-18:34:03, st_mtime=3D=
2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("smsusb.c", {st_dev=3Dmakedev(3, 1), st_ino=3D31869988, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D24, st_size=3D10922, st_atime=3D2009/01/08-18:34:03, st_mtime=3D=
2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
chdir("..")                             =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D3158162, st_mode=3DS_IFDIR=
|0755, st_nlink=3D13, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01=
/08-19:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
lstat64("ttpci", {st_dev=3Dmakedev(3, 1), st_ino=3D35036777, st_mode=3DS_=
IFDIR|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_b=
locks=3D16, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D20=
09/01/08-19:39:00, st_ctime=3D2009/01/08-19:39:00}) =3D 0
open("ttpci", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D35036777, st_mode=3DS_IFDIR|=
0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
16, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2009/01/08=
-19:39:00, st_ctime=3D2009/01/08-19:39:00}) =3D 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         =3D 0
getdents64(4, {{d_ino=3D35036777, d_off=3D4, d_type=3DDT_UNKNOWN, d_recle=
n=3D24, d_name=3D"."} {d_ino=3D3158162, d_off=3D6, d_type=3DDT_UNKNOWN, d=
_reclen=3D24, d_name=3D".."} {d_ino=3D35036778, d_off=3D9, d_type=3DDT_UN=
KNOWN, d_reclen=3D32, d_name=3D"Kconfig"} {d_ino=3D35036779, d_off=3D12, =
d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"Makefile"} {d_ino=3D3503678=
0, d_off=3D15, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"av7110.c"} {=
d_ino=3D35036781, d_off=3D18, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"av7110.h"} {d_ino=3D35036782, d_off=3D21, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"av7110_av.c"} {d_ino=3D35036783, d_off=3D24, d_type=3DDT_UN=
KNOWN, d_reclen=3D32, d_name=3D"av7110_av.h"} {d_ino=3D35036784, d_off=3D=
27, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"av7110_ca.c"} {d_ino=3D=
35036785, d_off=3D30, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"av711=
0_ca.h"} {d_ino=3D35036786, d_off=3D33, d_type=3DDT_UNKNOWN, d_reclen=3D3=
2, d_name=3D"av7110_hw.c"} {d_ino=3D35036787, d_off=3D36, d_type=3DDT_UNK=
NOWN, d_reclen=3D32, d_name=3D"av7110_hw.h"} {d_ino=3D35036788, d_off=3D4=
0, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"av7110_ipack.c"} {d_ino=3D=
35036789, d_off=3D44, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"av711=
0_ipack.h"} {d_ino=3D35036790, d_off=3D47, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"av7110_ir.c"} {d_ino=3D35036791, d_off=3D50, d_type=3DDT_UN=
KNOWN, d_reclen=3D32, d_name=3D"av7110_v4l.c"} {d_ino=3D35036792, d_off=3D=
53, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"budget-av.c"} {d_ino=3D=
35036793, d_off=3D56, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"budge=
t-ci.c"} {d_ino=3D35036794, d_off=3D59, d_type=3DDT_UNKNOWN, d_reclen=3D4=
0, d_name=3D"budget-core.c"} {d_ino=3D35036795, d_off=3D63, d_type=3DDT_U=
NKNOWN, d_reclen=3D40, d_name=3D"budget-patch.c"} {d_ino=3D35036796, d_of=
f=3D66, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"budget.c"} {d_ino=3D=
35036797, d_off=3D69, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"budge=
t.h"} {d_ino=3D35036798, d_off=3D72, d_type=3DDT_UNKNOWN, d_reclen=3D32, =
d_name=3D"fdump.c"} {d_ino=3D35036799, d_off=3D76, d_type=3DDT_UNKNOWN, d=
_reclen=3D40, d_name=3D"ttpci-eeprom.c"} {d_ino=3D36242368, d_off=3D80, d=
_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"ttpci-eeprom.h"} {d_ino=3D34=
980332, d_off=3D83, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"built-i=
n.o"} {d_ino=3D34980333, d_off=3D87, d_type=3DDT_UNKNOWN, d_reclen=3D40, =
d_name=3D".built-in.o.cmd"} {d_ino=3D36324465, d_off=3D90, d_type=3DDT_UN=
KNOWN, d_reclen=3D32, d_name=3D"budget.ko"} {d_ino=3D36324468, d_off=3D99=
, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dvb-ttpci.mod.o"} {d_ino=3D=
34959865, d_off=3D107, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"ttpc=
i-eeprom.o"} {d_ino=3D34959862, d_off=3D111, d_type=3DDT_UNKNOWN, d_recle=
n=3D40, d_name=3D".ttpci-eeprom.o.cmd"} {d_ino=3D36324466, d_off=3D115, d=
_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".budget.mod.o.cmd"} {d_ino=3D=
36324471, d_off=3D123, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dvb=
-ttpci.ko.cmd"} {d_ino=3D34959867, d_off=3D130, d_type=3DDT_UNKNOWN, d_re=
clen=3D40, d_name=3D"budget-core.o"} {d_ino=3D34959863, d_off=3D140, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".budget-core.o.cmd"} {d_ino=3D3=
4959864, d_off=3D146, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"budge=
t.o"} {d_ino=3D34959868, d_off=3D149, d_type=3DDT_UNKNOWN, d_reclen=3D40,=
 d_name=3D".budget.o.cmd"} {d_ino=3D36324469, d_off=3D157, d_type=3DDT_UN=
KNOWN, d_reclen=3D32, d_name=3D"dvb-ttpci.ko"} {d_ino=3D34959866, d_off=3D=
164, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"budget-av.o"} {d_ino=3D=
34959870, d_off=3D168, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".bud=
get-av.o.cmd"} {d_ino=3D36324472, d_off=3D176, d_type=3DDT_UNKNOWN, d_rec=
len=3D40, d_name=3D"ttpci-eeprom.mod.o"} {d_ino=3D34959869, d_off=3D183, =
d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"budget-ci.o"} {d_ino=3D3632=
4416, d_off=3D195, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".budget-=
ci.o.cmd"} {d_ino=3D34959871, d_off=3D202, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"av7110_hw.o"} {d_ino=3D36324418, d_off=3D214, d_type=3DDT_U=
NKNOWN, d_reclen=3D40, d_name=3D".av7110_hw.o.cmd"} {d_ino=3D36324417, d_=
off=3D221, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"av7110_v4l.o"} {=
d_ino=3D36324420, d_off=3D233, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=
=3D".av7110_v4l.o.cmd"} {d_ino=3D36324419, d_off=3D240, d_type=3DDT_UNKNO=
WN, d_reclen=3D32, d_name=3D"av7110_av.o"} {d_ino=3D36324422, d_off=3D252=
, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".av7110_av.o.cmd"} {d_ino=
=3D36324421, d_off=3D259, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"a=
v7110_ca.o"} {d_ino=3D36324424, d_off=3D269, d_type=3DDT_UNKNOWN, d_recle=
n=3D40, d_name=3D".av7110_ca.o.cmd"} {d_ino=3D36324423, d_off=3D275, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"av7110.o"} {d_ino=3D36324426, d=
_off=3D286, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".av7110.o.cmd"}=
 {d_ino=3D36324425, d_off=3D294, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_na=
me=3D"av7110_ipack.o"} {d_ino=3D36324428, d_off=3D306, d_type=3DDT_UNKNOW=
N, d_reclen=3D40, d_name=3D".av7110_ipack.o.cmd"} {d_ino=3D36324427, d_of=
f=3D313, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"av7110_ir.o"} {d_i=
no=3D36324430, d_off=3D317, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
".av7110_ir.o.cmd"} {d_ino=3D36324429, d_off=3D320, d_type=3DDT_UNKNOWN, =
d_reclen=3D32, d_name=3D"dvb-ttpci.o"} {d_ino=3D36324431, d_off=3D324, d_=
type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".dvb-ttpci.o.cmd"} {d_ino=3D3=
6324432, d_off=3D327, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"modul=
es.order"} {d_ino=3D36324441, d_off=3D331, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D"ttpci-eeprom.mod.c"} {d_ino=3D36324442, d_off=3D335, d_type=
=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dvb-ttpci.mod.c"} {d_ino=3D363244=
43, d_off=3D338, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"budget.mod=
=2Ec"} {d_ino=3D36324444, d_off=3D342, d_type=3DDT_UNKNOWN, d_reclen=3D40=
, d_name=3D"budget-core.mod.c"} {d_ino=3D36324445, d_off=3D346, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D"budget-ci.mod.c"} {d_ino=3D36324446,=
 d_off=3D350, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"budget-av.mod=
=2Ec"} {d_ino=3D36324452, d_off=3D362, d_type=3DDT_UNKNOWN, d_reclen=3D40=
, d_name=3D"budget-av.mod.o"} {d_ino=3D36324454, d_off=3D366, d_type=3DDT=
_UNKNOWN, d_reclen=3D40, d_name=3D".budget-av.mod.o.cmd"} {d_ino=3D363244=
53, d_off=3D369, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"budget-av.=
ko"} {d_ino=3D36324455, d_off=3D373, d_type=3DDT_UNKNOWN, d_reclen=3D40, =
d_name=3D".budget-av.ko.cmd"} {d_ino=3D36324456, d_off=3D385, d_type=3DDT=
_UNKNOWN, d_reclen=3D40, d_name=3D"budget-ci.mod.o"} {d_ino=3D36324458, d=
_off=3D389, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".budget-ci.mod.=
o.cmd"} {d_ino=3D36324457, d_off=3D392, d_type=3DDT_UNKNOWN, d_reclen=3D3=
2, d_name=3D"budget-ci.ko"} {d_ino=3D36324459, d_off=3D396, d_type=3DDT_U=
NKNOWN, d_reclen=3D40, d_name=3D".budget-ci.ko.cmd"} {d_ino=3D36324460, d=
_off=3D400, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"budget-core.mod=
=2Eo"} {d_ino=3D36324470, d_off=3D409, d_type=3DDT_UNKNOWN, d_reclen=3D40=
, d_name=3D".dvb-ttpci.mod.o.cmd"} {d_ino=3D36324462, d_off=3D414, d_type=
=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D".budget-core.mod.o.cmd"} {d_ino=3D=
36324461, d_off=3D418, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"budg=
et-core.ko"} {d_ino=3D36324463, d_off=3D422, d_type=3DDT_UNKNOWN, d_recle=
n=3D40, d_name=3D".budget-core.ko.cmd"} {d_ino=3D36324464, d_off=3D425, d=
_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"budget.mod.o"} {d_ino=3D3632=
4467, d_off=3D434, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".budget.=
ko.cmd"} {d_ino=3D36324474, d_off=3D439, d_type=3DDT_UNKNOWN, d_reclen=3D=
48, d_name=3D".ttpci-eeprom.mod.o.cmd"} {d_ino=3D36324473, d_off=3D443, d=
_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"ttpci-eeprom.ko"} {d_ino=3D3=
6324475, d_off=3D4294967295, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
".ttpci-eeprom.ko.cmd"}}, 4096) =3D 3072
_llseek(4, 443, [443], SEEK_SET)        =3D 0
getdents64(4, {{d_ino=3D36324475, d_off=3D4294967295, d_type=3DDT_UNKNOWN=
, d_reclen=3D40, d_name=3D".ttpci-eeprom.ko.cmd"}}, 4096) =3D 40
close(4)                                =3D 0
write(1, "../linux/drivers/media/dvb/pluto"..., 356) =3D 356
write(2, "/usr/src/findutils-4.1.20/find/f"..., 37) =3D 37
write(2, "../linux/drivers/media/dvb/ttpci", 32) =3D 32
write(2, ": Der Wert ist zu gro\337 f\374r den d"..., 51) =3D 51
write(2, "\n", 1)                       =3D 1
lstat64("ttusb-budget", {st_dev=3Dmakedev(3, 1), st_ino=3D41058301, st_mo=
de=3DS_IFDIR|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D409=
6, st_blocks=3D0, st_size=3D119, st_atime=3D2009/01/14-21:15:56, st_mtime=
=3D2009/01/08-19:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
open("ttusb-budget", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D41058301, st_mode=3DS_IFDIR|=
0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
0, st_size=3D119, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2009/01/08-1=
9:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         =3D 0
getdents64(4, {{d_ino=3D41058301, d_off=3D4, d_type=3DDT_DIR, d_reclen=3D=
24, d_name=3D"."} {d_ino=3D3158162, d_off=3D6, d_type=3DDT_DIR, d_reclen=3D=
24, d_name=3D".."} {d_ino=3D41058302, d_off=3D9, d_type=3DDT_UNKNOWN, d_r=
eclen=3D32, d_name=3D"Kconfig"} {d_ino=3D41058303, d_off=3D12, d_type=3DD=
T_UNKNOWN, d_reclen=3D32, d_name=3D"Makefile"} {d_ino=3D41068064, d_off=3D=
16, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"dvb-ttusb-budget.c"} {d=
_ino=3D41094742, d_off=3D19, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"built-in.o"} {d_ino=3D41094743, d_off=3D23, d_type=3DDT_UNKNOWN, d_recle=
n=3D40, d_name=3D".built-in.o.cmd"} {d_ino=3D41097852, d_off=3D512, d_typ=
e=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"modules.order"}}, 4096) =3D 264
getdents64(4, {}, 4096)                 =3D 0
close(4)                                =3D 0
chdir("ttusb-budget")                   =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D41058301, st_mode=3DS_IFDI=
R|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D0, st_size=3D119, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01/=
08-19:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
lstat64("dvb-ttusb-budget.c", {st_dev=3Dmakedev(3, 1), st_ino=3D41068064,=
 st_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=
=3D4096, st_blocks=3D88, st_size=3D44105, st_atime=3D2009/01/08-18:34:03,=
 st_mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
chdir("..")                             =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D3158162, st_mode=3DS_IFDIR=
|0755, st_nlink=3D13, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01=
/08-19:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
lstat64("ttusb-dec", {st_dev=3Dmakedev(3, 1), st_ino=3D43812597, st_mode=3D=
S_IFDIR|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D0, st_size=3D150, st_atime=3D2009/01/14-21:15:56, st_mtime=3D20=
09/01/08-19:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
open("ttusb-dec", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D43812597, st_mode=3DS_IFDIR|=
0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
0, st_size=3D150, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2009/01/08-1=
9:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         =3D 0
getdents64(4, {{d_ino=3D43812597, d_off=3D4, d_type=3DDT_DIR, d_reclen=3D=
24, d_name=3D"."} {d_ino=3D3158162, d_off=3D6, d_type=3DDT_DIR, d_reclen=3D=
24, d_name=3D".."} {d_ino=3D43812598, d_off=3D9, d_type=3DDT_UNKNOWN, d_r=
eclen=3D32, d_name=3D"Kconfig"} {d_ino=3D43812599, d_off=3D12, d_type=3DD=
T_UNKNOWN, d_reclen=3D32, d_name=3D"Makefile"} {d_ino=3D43812600, d_off=3D=
15, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"ttusb_dec.c"} {d_ino=3D=
43812601, d_off=3D18, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"ttusb=
decfe.c"} {d_ino=3D43812602, d_off=3D21, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"ttusbdecfe.h"} {d_ino=3D43839898, d_off=3D24, d_type=3DDT_U=
NKNOWN, d_reclen=3D32, d_name=3D"built-in.o"} {d_ino=3D43839899, d_off=3D=
28, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".built-in.o.cmd"} {d_in=
o=3D43843381, d_off=3D512, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"=
modules.order"}}, 4096) =3D 320
getdents64(4, {}, 4096)                 =3D 0
close(4)                                =3D 0
chdir("ttusb-dec")                      =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D43812597, st_mode=3DS_IFDI=
R|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D0, st_size=3D150, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01/=
08-19:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
lstat64("ttusb_dec.c", {st_dev=3Dmakedev(3, 1), st_ino=3D43812600, st_mod=
e=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096=
, st_blocks=3D88, st_size=3D41068, st_atime=3D2009/01/08-18:34:03, st_mti=
me=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("ttusbdecfe.c", {st_dev=3Dmakedev(3, 1), st_ino=3D43812601, st_mo=
de=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D409=
6, st_blocks=3D16, st_size=3D7875, st_atime=3D2009/01/08-18:34:03, st_mti=
me=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("ttusbdecfe.h", {st_dev=3Dmakedev(3, 1), st_ino=3D43812602, st_mo=
de=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D409=
6, st_blocks=3D8, st_size=3D1265, st_atime=3D2009/01/08-18:34:03, st_mtim=
e=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
chdir("..")                             =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D3158162, st_mode=3DS_IFDIR=
|0755, st_nlink=3D13, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01=
/08-19:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
chdir("..")                             =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D64507419, st_mode=3DS_IFDI=
R|0755, st_nlink=3D6, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D0, st_size=3D141, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01/=
08-19:36:31, st_ctime=3D2009/01/08-19:36:31}) =3D 0
lstat64("radio", {st_dev=3Dmakedev(3, 1), st_ino=3D48977814, st_mode=3DS_=
IFDIR|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_b=
locks=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D200=
9/01/08-19:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
open("radio", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D48977814, st_mode=3DS_IFDIR|=
0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
8, st_size=3D4096, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2009/01/08-=
19:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         =3D 0
getdents64(4, {{d_ino=3D48977814, d_off=3D4, d_type=3DDT_UNKNOWN, d_recle=
n=3D24, d_name=3D"."} {d_ino=3D64507419, d_off=3D6, d_type=3DDT_UNKNOWN, =
d_reclen=3D24, d_name=3D".."} {d_ino=3D48977815, d_off=3D9, d_type=3DDT_U=
NKNOWN, d_reclen=3D32, d_name=3D"Kconfig"} {d_ino=3D48977816, d_off=3D12,=
 d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"Makefile"} {d_ino=3D489778=
17, d_off=3D15, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dsbr100.c"}=
 {d_ino=3D48977818, d_off=3D19, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_nam=
e=3D"radio-aimslab.c"} {d_ino=3D48977819, d_off=3D23, d_type=3DDT_UNKNOWN=
, d_reclen=3D40, d_name=3D"radio-aztech.c"} {d_ino=3D48977820, d_off=3D26=
, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"radio-cadet.c"} {d_ino=3D=
48977821, d_off=3D30, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"radio=
-gemtek-pci.c"} {d_ino=3D48977822, d_off=3D34, d_type=3DDT_UNKNOWN, d_rec=
len=3D40, d_name=3D"radio-gemtek.c"} {d_ino=3D48977823, d_off=3D38, d_typ=
e=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"radio-maestro.c"} {d_ino=3D48977=
824, d_off=3D42, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"radio-maxi=
radio.c"} {d_ino=3D48977825, d_off=3D45, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D"radio-mr800.c"} {d_ino=3D48977826, d_off=3D49, d_type=3DDT_=
UNKNOWN, d_reclen=3D40, d_name=3D"radio-rtrack2.c"} {d_ino=3D48977827, d_=
off=3D53, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"radio-sf16fmi.c"}=
 {d_ino=3D48977828, d_off=3D57, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_nam=
e=3D"radio-sf16fmr2.c"} {d_ino=3D48977829, d_off=3D61, d_type=3DDT_UNKNOW=
N, d_reclen=3D40, d_name=3D"radio-si470x.c"} {d_ino=3D48977830, d_off=3D6=
5, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"radio-terratec.c"} {d_in=
o=3D48977831, d_off=3D68, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"r=
adio-trust.c"} {d_ino=3D48977832, d_off=3D72, d_type=3DDT_UNKNOWN, d_recl=
en=3D40, d_name=3D"radio-typhoon.c"} {d_ino=3D48977833, d_off=3D76, d_typ=
e=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"radio-zoltrix.c"} {d_ino=3D49035=
935, d_off=3D79, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"built-in.o=
"} {d_ino=3D49050400, d_off=3D83, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_n=
ame=3D".built-in.o.cmd"} {d_ino=3D49050433, d_off=3D512, d_type=3DDT_UNKN=
OWN, d_reclen=3D40, d_name=3D"modules.order"}}, 4096) =3D 896
getdents64(4, {}, 4096)                 =3D 0
close(4)                                =3D 0
chdir("radio")                          =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D48977814, st_mode=3DS_IFDI=
R|0755, st_nlink=3D2, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D8, st_size=3D4096, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01=
/08-19:34:37, st_ctime=3D2009/01/08-19:34:37}) =3D 0
lstat64("dsbr100.c", {st_dev=3Dmakedev(3, 1), st_ino=3D48977817, st_mode=3D=
S_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st=
_blocks=3D32, st_size=3D14504, st_atime=3D2009/01/08-18:34:03, st_mtime=3D=
2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("radio-aimslab.c", {st_dev=3Dmakedev(3, 1), st_ino=3D48977818, st=
_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D24, st_size=3D11576, st_atime=3D2009/01/08-18:34:03, st=
_mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("radio-aztech.c", {st_dev=3Dmakedev(3, 1), st_ino=3D48977819, st_=
mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4=
096, st_blocks=3D24, st_size=3D10225, st_atime=3D2009/01/08-18:34:03, st_=
mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("radio-cadet.c", {st_dev=3Dmakedev(3, 1), st_ino=3D48977820, st_m=
ode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D40=
96, st_blocks=3D32, st_size=3D15252, st_atime=3D2009/01/08-18:34:03, st_m=
time=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("radio-gemtek-pci.c", {st_dev=3Dmakedev(3, 1), st_ino=3D48977821,=
 st_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=
=3D4096, st_blocks=3D24, st_size=3D12043, st_atime=3D2009/01/08-18:34:03,=
 st_mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("radio-gemtek.c", {st_dev=3Dmakedev(3, 1), st_ino=3D48977822, st_=
mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4=
096, st_blocks=3D32, st_size=3D16263, st_atime=3D2009/01/08-18:34:03, st_=
mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("radio-maestro.c", {st_dev=3Dmakedev(3, 1), st_ino=3D48977823, st=
_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D24, st_size=3D11550, st_atime=3D2009/01/08-18:34:03, st=
_mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("radio-maxiradio.c", {st_dev=3Dmakedev(3, 1), st_ino=3D48977824, =
st_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D24, st_size=3D11271, st_atime=3D2009/01/08-18:34:03, st=
_mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("radio-mr800.c", {st_dev=3Dmakedev(3, 1), st_ino=3D48977825, st_m=
ode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D40=
96, st_blocks=3D32, st_size=3D16045, st_atime=3D2009/01/08-18:34:03, st_m=
time=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("radio-rtrack2.c", {st_dev=3Dmakedev(3, 1), st_ino=3D48977826, st=
_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D16, st_size=3D8010, st_atime=3D2009/01/08-18:34:03, st_=
mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("radio-sf16fmi.c", {st_dev=3Dmakedev(3, 1), st_ino=3D48977827, st=
_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D24, st_size=3D9712, st_atime=3D2009/01/08-18:34:03, st_=
mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("radio-sf16fmr2.c", {st_dev=3Dmakedev(3, 1), st_ino=3D48977828, s=
t_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D24, st_size=3D11468, st_atime=3D2009/01/08-18:34:03, st=
_mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("radio-si470x.c", {st_dev=3Dmakedev(3, 1), st_ino=3D48977829, st_=
mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4=
096, st_blocks=3D96, st_size=3D48012, st_atime=3D2009/01/08-18:34:03, st_=
mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("radio-terratec.c", {st_dev=3Dmakedev(3, 1), st_ino=3D48977830, s=
t_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D24, st_size=3D10302, st_atime=3D2009/01/08-18:34:03, st=
_mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("radio-trust.c", {st_dev=3Dmakedev(3, 1), st_ino=3D48977831, st_m=
ode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D40=
96, st_blocks=3D24, st_size=3D9816, st_atime=3D2009/01/08-18:34:03, st_mt=
ime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("radio-typhoon.c", {st_dev=3Dmakedev(3, 1), st_ino=3D48977832, st=
_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D32, st_size=3D12949, st_atime=3D2009/01/08-18:34:03, st=
_mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
lstat64("radio-zoltrix.c", {st_dev=3Dmakedev(3, 1), st_ino=3D48977833, st=
_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D=
4096, st_blocks=3D24, st_size=3D11254, st_atime=3D2009/01/08-18:34:03, st=
_mtime=3D2008/12/25-00:26:37, st_ctime=3D2009/01/08-18:35:09}) =3D 0
chdir("..")                             =3D 0
lstat64(".", {st_dev=3Dmakedev(3, 1), st_ino=3D64507419, st_mode=3DS_IFDI=
R|0755, st_nlink=3D6, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_block=
s=3D0, st_size=3D141, st_atime=3D2009/01/14-21:16:03, st_mtime=3D2009/01/=
08-19:36:31, st_ctime=3D2009/01/08-19:36:31}) =3D 0
lstat64("video", {st_dev=3Dmakedev(3, 1), st_ino=3D53193825, st_mode=3DS_=
IFDIR|0755, st_nlink=3D23, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_=
blocks=3D64, st_size=3D16384, st_atime=3D2009/01/14-21:15:56, st_mtime=3D=
2009/01/12-20:03:30, st_ctime=3D2009/01/12-20:03:30}) =3D 0
open("video", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) =3D 4
fstat64(4, {st_dev=3Dmakedev(3, 1), st_ino=3D53193825, st_mode=3DS_IFDIR|=
0755, st_nlink=3D23, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=
=3D64, st_size=3D16384, st_atime=3D2009/01/14-21:15:56, st_mtime=3D2009/0=
1/12-20:03:30, st_ctime=3D2009/01/12-20:03:30}) =3D 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         =3D 0
getdents64(4, {{d_ino=3D53193825, d_off=3D4, d_type=3DDT_UNKNOWN, d_recle=
n=3D24, d_name=3D"."} {d_ino=3D64507419, d_off=3D6, d_type=3DDT_UNKNOWN, =
d_reclen=3D24, d_name=3D".."} {d_ino=3D53193826, d_off=3D9, d_type=3DDT_U=
NKNOWN, d_reclen=3D32, d_name=3D"Kconfig"} {d_ino=3D53193827, d_off=3D12,=
 d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"Makefile"} {d_ino=3D531938=
28, d_off=3D15, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"adv7170.c"}=
 {d_ino=3D53193829, d_off=3D18, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_nam=
e=3D"adv7175.c"} {d_ino=3D53193830, d_off=3D20, d_type=3DDT_UNKNOWN, d_re=
clen=3D32, d_name=3D"arv.c"} {d_ino=3D56082392, d_off=3D23, d_type=3DDT_U=
NKNOWN, d_reclen=3D32, d_name=3D"au0828"} {d_ino=3D53193831, d_off=3D26, =
d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"bt819.c"} {d_ino=3D53193832=
, d_off=3D29, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"bt856.c"} {d_=
ino=3D53193833, d_off=3D32, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"bt866.c"} {d_ino=3D60972636, d_off=3D34, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"bt8xx"} {d_ino=3D53193834, d_off=3D37, d_type=3DDT_UNKNOWN,=
 d_reclen=3D32, d_name=3D"btcx-risc.c"} {d_ino=3D53193835, d_off=3D40, d_=
type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"btcx-risc.h"} {d_ino=3D531938=
36, d_off=3D43, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"bw-qcam.c"}=
 {d_ino=3D53193837, d_off=3D46, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_nam=
e=3D"bw-qcam.h"} {d_ino=3D53193838, d_off=3D49, d_type=3DDT_UNKNOWN, d_re=
clen=3D32, d_name=3D"c-qcam.c"} {d_ino=3D53193839, d_off=3D53, d_type=3DD=
T_UNKNOWN, d_reclen=3D40, d_name=3D"cafe_ccic-regs.h"} {d_ino=3D53193840,=
 d_off=3D56, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"cafe_ccic.c"} =
{d_ino=3D53193841, d_off=3D60, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=
=3D"compat_ioctl32.c"} {d_ino=3D53193842, d_off=3D63, d_type=3DDT_UNKNOWN=
, d_reclen=3D32, d_name=3D"cpia.c"} {d_ino=3D53193843, d_off=3D66, d_type=
=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"cpia.h"} {d_ino=3D64507422, d_off=
=3D68, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"cpia2"} {d_ino=3D531=
93844, d_off=3D71, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"cpia_pp.=
c"} {d_ino=3D53193845, d_off=3D74, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_=
name=3D"cpia_usb.c"} {d_ino=3D53193846, d_off=3D77, d_type=3DDT_UNKNOWN, =
d_reclen=3D32, d_name=3D"cs5345.c"} {d_ino=3D53193847, d_off=3D80, d_type=
=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"cs53l32a.c"} {d_ino=3D53193848, d=
_off=3D83, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"cs8420.h"} {d_in=
o=3D68769546, d_off=3D85, d_type=3DDT_UNKNOWN, d_reclen=3D24, d_name=3D"c=
x18"} {d_ino=3D53193849, d_off=3D88, d_type=3DDT_UNKNOWN, d_reclen=3D32, =
d_name=3D"cx2341x.c"} {d_ino=3D72931445, d_off=3D91, d_type=3DDT_UNKNOWN,=
 d_reclen=3D32, d_name=3D"cx23885"} {d_ino=3D3158216, d_off=3D94, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"cx25840"} {d_ino=3D3158224, d_off=3D=
96, d_type=3DDT_UNKNOWN, d_reclen=3D24, d_name=3D"cx88"} {d_ino=3D5319385=
0, d_off=3D99, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"dabusb.c"} {=
d_ino=3D53193851, d_off=3D102, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=
=3D"dabusb.h"} {d_ino=3D6862939, d_off=3D105, d_type=3DDT_UNKNOWN, d_recl=
en=3D32, d_name=3D"em28xx"} {d_ino=3D9948261, d_off=3D108, d_type=3DDT_UN=
KNOWN, d_reclen=3D32, d_name=3D"et61x251"} {d_ino=3D53193852, d_off=3D111=
, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"font.h"} {d_ino=3D1563488=
0, d_off=3D113, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"gspca"} {d_=
ino=3D53193853, d_off=3D117, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
"hexium_gemini.c"} {d_ino=3D53193854, d_off=3D121, d_type=3DDT_UNKNOWN, d=
_reclen=3D40, d_name=3D"hexium_orion.c"} {d_ino=3D53193855, d_off=3D124, =
d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"ibmmpeg2.h"} {d_ino=3D53193=
856, d_off=3D127, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"indycam.c=
"} {d_ino=3D53193857, d_off=3D130, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_=
name=3D"indycam.h"} {d_ino=3D53193858, d_off=3D133, d_type=3DDT_UNKNOWN, =
d_reclen=3D32, d_name=3D"ir-kbd-i2c.c"} {d_ino=3D22627711, d_off=3D135, d=
_type=3DDT_UNKNOWN, d_reclen=3D24, d_name=3D"ivtv"} {d_ino=3D53193859, d_=
off=3D138, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"ks0127.c"} {d_in=
o=3D53193860, d_off=3D141, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"=
ks0127.h"} {d_ino=3D53193861, d_off=3D144, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"m52790.c"} {d_ino=3D53193862, d_off=3D147, d_type=3DDT_UNKN=
OWN, d_reclen=3D32, d_name=3D"meye.c"} {d_ino=3D53193863, d_off=3D150, d_=
type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"meye.h"} {d_ino=3D53193864, d=
_off=3D154, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"msp3400-driver.=
c"} {d_ino=3D53193865, d_off=3D158, d_type=3DDT_UNKNOWN, d_reclen=3D40, d=
_name=3D"msp3400-driver.h"} {d_ino=3D53193866, d_off=3D162, d_type=3DDT_U=
NKNOWN, d_reclen=3D40, d_name=3D"msp3400-kthreads.c"} {d_ino=3D53193867, =
d_off=3D165, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mt9m001.c"} {d=
_ino=3D53193868, d_off=3D168, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"mt9m111.c"} {d_ino=3D53193869, d_off=3D171, d_type=3DDT_UNKNOWN, d_recle=
n=3D32, d_name=3D"mt9v022.c"} {d_ino=3D53193870, d_off=3D173, d_type=3DDT=
_UNKNOWN, d_reclen=3D32, d_name=3D"mxb.c"} {d_ino=3D53193871, d_off=3D175=
, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mxb.h"} {d_ino=3D53193872=
, d_off=3D178, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"ov511.c"} {d=
_ino=3D53193873, d_off=3D181, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"ov511.h"} {d_ino=3D53193874, d_off=3D184, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"ov7670.c"} {d_ino=3D31869989, d_off=3D187, d_type=3DDT_UNKN=
OWN, d_reclen=3D32, d_name=3D"ovcamchip"} {d_ino=3D53193875, d_off=3D189,=
 d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"pms.c"} {d_ino=3D31869998,=
 d_off=3D192, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"pvrusb2"} {d_=
ino=3D36242369, d_off=3D194, d_type=3DDT_UNKNOWN, d_reclen=3D24, d_name=3D=
"pwc"} {d_ino=3D53193876, d_off=3D197, d_type=3DDT_UNKNOWN, d_reclen=3D32=
, d_name=3D"pxa_camera.c"} {d_ino=3D53193877, d_off=3D200, d_type=3DDT_UN=
KNOWN, d_reclen=3D32, d_name=3D"s2255drv.c"} {d_ino=3D53193878, d_off=3D2=
03, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"saa5246a.c"} {d_ino=3D5=
3193879, d_off=3D206, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"saa52=
49.c"} {d_ino=3D53193880, d_off=3D209, d_type=3DDT_UNKNOWN, d_reclen=3D32=
, d_name=3D"saa6588.c"} {d_ino=3D53193881, d_off=3D212, d_type=3DDT_UNKNO=
WN, d_reclen=3D32, d_name=3D"saa7110.c"} {d_ino=3D53193882, d_off=3D215, =
d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"saa7111.c"} {d_ino=3D531938=
83, d_off=3D218, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"saa7114.c"=
} {d_ino=3D53193884, d_off=3D221, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_n=
ame=3D"saa7115.c"} {d_ino=3D53193885, d_off=3D225, d_type=3DDT_UNKNOWN, d=
_reclen=3D40, d_name=3D"saa711x_regs.h"} {d_ino=3D53193886, d_off=3D228, =
d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"saa7121.h"} {d_ino=3D531938=
87, d_off=3D231, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"saa7127.c"=
} {d_ino=3D41068065, d_off=3D234, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_n=
ame=3D"saa7134"} {d_ino=3D53197344, d_off=3D237, d_type=3DDT_UNKNOWN, d_r=
eclen=3D32, d_name=3D"saa7146.h"} {d_ino=3D53197345, d_off=3D240, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"saa7146reg.h"} {d_ino=3D53197346, d_=
off=3D243, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"saa717x.c"} {d_i=
no=3D53197347, d_off=3D246, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"saa7185.c"} {d_ino=3D53197348, d_off=3D249, d_type=3DDT_UNKNOWN, d_recle=
n=3D32, d_name=3D"saa7191.c"} {d_ino=3D53197349, d_off=3D252, d_type=3DDT=
_UNKNOWN, d_reclen=3D32, d_name=3D"saa7191.h"} {d_ino=3D53197350, d_off=3D=
255, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"se401.c"} {d_ino=3D531=
97351, d_off=3D258, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"se401.h=
"} {d_ino=3D53197352, d_off=3D263, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_=
name=3D"sh_mobile_ceu_camera.c"} {d_ino=3D43812603, d_off=3D266, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"sn9c102"} {d_ino=3D53197353, d_off=3D=
269, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"soc_camera.c"} {d_ino=3D=
53197354, d_off=3D273, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D"soc_=
camera_platform.c"} {d_ino=3D53197355, d_off=3D276, d_type=3DDT_UNKNOWN, =
d_reclen=3D32, d_name=3D"stk-sensor.c"} {d_ino=3D53197356, d_off=3D279, d=
_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"stk-webcam.c"} {d_ino=3D5319=
7357, d_off=3D282, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"stk-webc=
am.h"} {d_ino=3D53197358, d_off=3D285, d_type=3DDT_UNKNOWN, d_reclen=3D32=
, d_name=3D"stradis.c"} {d_ino=3D53197359, d_off=3D288, d_type=3DDT_UNKNO=
WN, d_reclen=3D32, d_name=3D"stv680.c"} {d_ino=3D53197360, d_off=3D291, d=
_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"stv680.h"} {d_ino=3D53197361=
, d_off=3D294, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tcm825x.c"} =
{d_ino=3D53197362, d_off=3D297, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_nam=
e=3D"tcm825x.h"} {d_ino=3D53197363, d_off=3D300, d_type=3DDT_UNKNOWN, d_r=
eclen=3D32, d_name=3D"tda7432.c"} {d_ino=3D53197364, d_off=3D303, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"tda9840.c"} {d_ino=3D53197365, d_off=
=3D306, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda9840.h"} {d_ino=3D=
53197366, d_off=3D309, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda9=
875.c"} {d_ino=3D53197367, d_off=3D312, d_type=3DDT_UNKNOWN, d_reclen=3D3=
2, d_name=3D"tea6415c.c"} {d_ino=3D53197368, d_off=3D315, d_type=3DDT_UNK=
NOWN, d_reclen=3D32, d_name=3D"tea6415c.h"} {d_ino=3D53197369, d_off=3D31=
8, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tea6420.c"} {d_ino=3D531=
97370, d_off=3D321, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tea6420=
=2Eh"} {d_ino=3D53197371, d_off=3D325, d_type=3DDT_UNKNOWN, d_reclen=3D40=
, d_name=3D"tlv320aic23b.c"} {d_ino=3D53197372, d_off=3D328, d_type=3DDT_=
UNKNOWN, d_reclen=3D32, d_name=3D"tuner-core.c"} {d_ino=3D53197373, d_off=
=3D331, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tvaudio.c"} {d_ino=3D=
53197374, d_off=3D334, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tvee=
prom.c"} {d_ino=3D53197375, d_off=3D337, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"tvp5150.c"} {d_ino=3D53197376, d_off=3D340, d_type=3DDT_UNK=
NOWN, d_reclen=3D40, d_name=3D"tvp5150_reg.h"} {d_ino=3D53197377, d_off=3D=
343, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"upd64031a.c"} {d_ino=3D=
53197378, d_off=3D346, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"upd6=
4083.c"} {d_ino=3D48977834, d_off=3D349, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"usbvideo"} {d_ino=3D53197379, d_off=3D352, d_type=3DDT_UNKN=
OWN, d_reclen=3D32, d_name=3D"usbvision"} {d_ino=3D56085730, d_off=3D354,=
 d_type=3DDT_UNKNOWN, d_reclen=3D24, d_name=3D"uvc"} {d_ino=3D53197388, d=
_off=3D357, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"v4l1-compat.c"}=
 {d_ino=3D53197389, d_off=3D360, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_na=
me=3D"v4l2-common.c"} {d_ino=3D53197390, d_off=3D363, d_type=3DDT_UNKNOWN=
, d_reclen=3D32, d_name=3D"v4l2-dev.c"} {d_ino=3D53197391, d_off=3D367, d=
_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"v4l2-int-device.c"} {d_ino=3D=
53197392, d_off=3D370, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"v4l2=
-ioctl.c"} {d_ino=3D53197393, d_off=3D374, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D"videobuf-core.c"}}, 4096) =3D 4056
getdents64(4, {{d_ino=3D53197394, d_off=3D378, d_type=3DDT_UNKNOWN, d_rec=
len=3D48, d_name=3D"videobuf-dma-contig.c"} {d_ino=3D53197395, d_off=3D38=
2, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"videobuf-dma-sg.c"} {d_i=
no=3D53197396, d_off=3D386, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
"videobuf-dvb.c"} {d_ino=3D53197397, d_off=3D390, d_type=3DDT_UNKNOWN, d_=
reclen=3D40, d_name=3D"videobuf-vmalloc.c"} {d_ino=3D53197398, d_off=3D39=
3, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"vino.c"} {d_ino=3D531973=
99, d_off=3D396, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"vino.h"} {=
d_ino=3D53197400, d_off=3D399, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=
=3D"vivi.c"} {d_ino=3D53197401, d_off=3D402, d_type=3DDT_UNKNOWN, d_recle=
n=3D32, d_name=3D"vp27smpx.c"} {d_ino=3D53197402, d_off=3D405, d_type=3DD=
T_UNKNOWN, d_reclen=3D32, d_name=3D"vpx3220.c"} {d_ino=3D53197403, d_off=3D=
408, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"w9966.c"} {d_ino=3D531=
97404, d_off=3D411, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"w9968cf=
=2Ec"} {d_ino=3D53197405, d_off=3D414, d_type=3DDT_UNKNOWN, d_reclen=3D32=
, d_name=3D"w9968cf.h"} {d_ino=3D53197406, d_off=3D418, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D"w9968cf_decoder.h"} {d_ino=3D53197407, d_off=
=3D421, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"w9968cf_vpp.h"} {d_=
ino=3D53197440, d_off=3D424, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"wm8739.c"} {d_ino=3D53197441, d_off=3D427, d_type=3DDT_UNKNOWN, d_reclen=
=3D32, d_name=3D"wm8775.c"} {d_ino=3D60994766, d_off=3D430, d_type=3DDT_U=
NKNOWN, d_reclen=3D32, d_name=3D"zc0301"} {d_ino=3D64507431, d_off=3D432,=
 d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"zoran"} {d_ino=3D53197442,=
 d_off=3D435, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"zr364xx.c"} {=
d_ino=3D53240963, d_off=3D438, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=
=3D"built-in.o"} {d_ino=3D53240964, d_off=3D442, d_type=3DDT_UNKNOWN, d_r=
eclen=3D40, d_name=3D".built-in.o.cmd"} {d_ino=3D53258865, d_off=3D446, d=
_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".v4l2-ioctl.o.cmd"} {d_ino=3D=
53244787, d_off=3D450, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".v4l=
2-common.o.cmd"} {d_ino=3D53244770, d_off=3D454, d_type=3DDT_UNKNOWN, d_r=
eclen=3D40, d_name=3D"msp3400-driver.o"} {d_ino=3D53244778, d_off=3D458, =
d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"compat_ioctl32.o"} {d_ino=3D=
53244772, d_off=3D462, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D".msp=
3400-driver.o.cmd"} {d_ino=3D53244777, d_off=3D465, d_type=3DDT_UNKNOWN, =
d_reclen=3D32, d_name=3D"videodev.o"} {d_ino=3D53244780, d_off=3D469, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".videodev.o.cmd"} {d_ino=3D532=
47513, d_off=3D471, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"mxb.o"}=
 {d_ino=3D53244771, d_off=3D475, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_na=
me=3D"msp3400-kthreads.o"} {d_ino=3D53244775, d_off=3D480, d_type=3DDT_UN=
KNOWN, d_reclen=3D32, d_name=3D"v4l2-ioctl.o"} {d_ino=3D53244774, d_off=3D=
485, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D".msp3400-kthreads.o.cm=
d"} {d_ino=3D53258864, d_off=3D489, d_type=3DDT_UNKNOWN, d_reclen=3D40, d=
_name=3D".v4l2-dev.o.cmd"} {d_ino=3D53385325, d_off=3D493, d_type=3DDT_UN=
KNOWN, d_reclen=3D48, d_name=3D".compat_ioctl32.o.cmd"} {d_ino=3D53244773=
, d_off=3D496, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tuner-core.o=
"} {d_ino=3D53244779, d_off=3D500, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_=
name=3D"v4l2-int-device.o"} {d_ino=3D53244776, d_off=3D504, d_type=3DDT_U=
NKNOWN, d_reclen=3D40, d_name=3D".tuner-core.o.cmd"} {d_ino=3D53240983, d=
_off=3D507, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"v4l2-dev.o"} {d=
_ino=3D53244788, d_off=3D514, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"tuner.o"} {d_ino=3D53244785, d_off=3D519, d_type=3DDT_UNKNOWN, d_reclen=3D=
48, d_name=3D".v4l2-int-device.o.cmd"} {d_ino=3D53247538, d_off=3D522, d_=
type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".ov7670.o.cmd"} {d_ino=3D5324=
4781, d_off=3D526, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"v4l2-com=
mon.o"} {d_ino=3D53247504, d_off=3D530, d_type=3DDT_UNKNOWN, d_reclen=3D4=
0, d_name=3D".cs53l32a.o.cmd"} {d_ino=3D53247533, d_off=3D534, d_type=3DD=
T_UNKNOWN, d_reclen=3D40, d_name=3D".cx2341x.o.cmd"} {d_ino=3D53244782, d=
_off=3D537, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"v4l1-compat.o"}=
 {d_ino=3D53244789, d_off=3D541, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_na=
me=3D".v4l1-compat.o.cmd"} {d_ino=3D53244790, d_off=3D544, d_type=3DDT_UN=
KNOWN, d_reclen=3D32, d_name=3D".tuner.o.cmd"} {d_ino=3D53247506, d_off=3D=
547, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".m52790.o.cmd"} {d_ino=
=3D53247534, d_off=3D552, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".=
upd64083.o.cmd"} {d_ino=3D53244792, d_off=3D555, d_type=3DDT_UNKNOWN, d_r=
eclen=3D32, d_name=3D"ir-kbd-i2c.o"} {d_ino=3D53247540, d_off=3D559, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tcm825x.o.cmd"} {d_ino=3D53244=
794, d_off=3D563, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".ir-kbd-i=
2c.o.cmd"} {d_ino=3D53247503, d_off=3D566, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"m52790.o"} {d_ino=3D53247537, d_off=3D570, d_type=3DDT_UNKN=
OWN, d_reclen=3D32, d_name=3D"cx2341x.o"} {d_ino=3D53244793, d_off=3D573,=
 d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tvaudio.o"} {d_ino=3D53247=
535, d_off=3D577, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"ov7670.o"=
} {d_ino=3D53244796, d_off=3D581, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_n=
ame=3D".tvaudio.o.cmd"} {d_ino=3D53247522, d_off=3D585, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D".videobuf-dvb.o.cmd"} {d_ino=3D53256773, d_o=
ff=3D588, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"saa7191.mod.c"} {=
d_ino=3D53244795, d_off=3D591, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=
=3D"tda7432.o"} {d_ino=3D53247539, d_off=3D595, d_type=3DDT_UNKNOWN, d_re=
clen=3D40, d_name=3D"modules.order"} {d_ino=3D53244798, d_off=3D599, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda7432.o.cmd"} {d_ino=3D53247=
505, d_off=3D603, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tlv320aic=
23b.o"} {d_ino=3D53256774, d_off=3D606, d_type=3DDT_UNKNOWN, d_reclen=3D4=
0, d_name=3D"saa7185.mod.c"} {d_ino=3D53244797, d_off=3D609, d_type=3DDT_=
UNKNOWN, d_reclen=3D32, d_name=3D"tda9875.o"} {d_ino=3D53247536, d_off=3D=
613, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tcm825x.o"} {d_ino=3D5=
3247456, d_off=3D617, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda9=
875.o.cmd"} {d_ino=3D53247508, d_off=3D621, d_type=3DDT_UNKNOWN, d_reclen=
=3D40, d_name=3D".tlv320aic23b.o.cmd"} {d_ino=3D53256775, d_off=3D624, d_=
type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"saa717x.mod.c"} {d_ino=3D5324=
4799, d_off=3D627, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"saa5246a=
=2Eo"} {d_ino=3D53247565, d_off=3D631, d_type=3DDT_UNKNOWN, d_reclen=3D32=
, d_name=3D"wm8775.mod.c"} {d_ino=3D53247458, d_off=3D635, d_type=3DDT_UN=
KNOWN, d_reclen=3D40, d_name=3D".saa5246a.o.cmd"} {d_ino=3D53247507, d_of=
f=3D638, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"wm8775.o"} {d_ino=3D=
53247566, d_off=3D642, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"wm87=
39.mod.c"} {d_ino=3D53247457, d_off=3D645, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"saa5249.o"} {d_ino=3D53247567, d_off=3D649, d_type=3DDT_UNK=
NOWN, d_reclen=3D40, d_name=3D"vpx3220.mod.c"} {d_ino=3D53247460, d_off=3D=
653, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".saa5249.o.cmd"} {d_in=
o=3D53247510, d_off=3D656, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"=
=2Ewm8775.o.cmd"} {d_ino=3D53247568, d_off=3D660, d_type=3DDT_UNKNOWN, d_=
reclen=3D40, d_name=3D"vp27smpx.mod.c"} {d_ino=3D53247459, d_off=3D663, d=
_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda9840.o"} {d_ino=3D5324756=
9, d_off=3D667, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"videodev.mo=
d.c"} {d_ino=3D53247462, d_off=3D671, d_type=3DDT_UNKNOWN, d_reclen=3D40,=
 d_name=3D".tda9840.o.cmd"} {d_ino=3D53247509, d_off=3D674, d_type=3DDT_U=
NKNOWN, d_reclen=3D32, d_name=3D"wm8739.o"} {d_ino=3D53247570, d_off=3D67=
8, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"videobuf-dvb.mod.c"} {d_=
ino=3D53247461, d_off=3D681, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"tea6415c.o"} {d_ino=3D53247571, d_off=3D685, d_type=3DDT_UNKNOWN, d_recl=
en=3D48, d_name=3D"videobuf-dma-sg.mod.c"} {d_ino=3D53247464, d_off=3D689=
, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tea6415c.o.cmd"} {d_ino=3D=
53247512, d_off=3D692, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".wm8=
739.o.cmd"} {d_ino=3D53247572, d_off=3D696, d_type=3DDT_UNKNOWN, d_reclen=
=3D40, d_name=3D"videobuf-core.mod.c"} {d_ino=3D53247463, d_off=3D699, d_=
type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tea6420.o"} {d_ino=3D53247573=
, d_off=3D703, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D"v4l2-int-dev=
ice.mod.c"} {d_ino=3D53247466, d_off=3D707, d_type=3DDT_UNKNOWN, d_reclen=
=3D40, d_name=3D".tea6420.o.cmd"} {d_ino=3D53247511, d_off=3D710, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"vp27smpx.o"} {d_ino=3D53247574, d_of=
f=3D714, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"v4l2-common.mod.c"=
} {d_ino=3D53247465, d_off=3D717, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_n=
ame=3D"saa7110.o"} {d_ino=3D53247575, d_off=3D721, d_type=3DDT_UNKNOWN, d=
_reclen=3D40, d_name=3D"v4l1-compat.mod.c"} {d_ino=3D53247468, d_off=3D72=
5, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".saa7110.o.cmd"} {d_ino=3D=
53247514, d_off=3D729, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".vp2=
7smpx.o.cmd"} {d_ino=3D53256776, d_off=3D732, d_type=3DDT_UNKNOWN, d_recl=
en=3D40, d_name=3D"saa7127.mod.c"} {d_ino=3D53247467, d_off=3D735, d_type=
=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"saa7111.o"} {d_ino=3D53247576, d_=
off=3D739, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"upd64083.mod.c"}=
 {d_ino=3D53247470, d_off=3D743, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_na=
me=3D".saa7111.o.cmd"} {d_ino=3D53247516, d_off=3D746, d_type=3DDT_UNKNOW=
N, d_reclen=3D32, d_name=3D".mxb.o.cmd"} {d_ino=3D53247577, d_off=3D750, =
d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"upd64031a.mod.c"} {d_ino=3D=
53247469, d_off=3D753, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"saa7=
114.o"} {d_ino=3D53247578, d_off=3D757, d_type=3DDT_UNKNOWN, d_reclen=3D4=
0, d_name=3D"tvp5150.mod.c"} {d_ino=3D53247472, d_off=3D761, d_type=3DDT_=
UNKNOWN, d_reclen=3D40, d_name=3D".saa7114.o.cmd"} {d_ino=3D53247515, d_o=
ff=3D765, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"hexium_orion.o"} =
{d_ino=3D53256777, d_off=3D768, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_nam=
e=3D"saa7115.mod.c"}}, 4096) =3D 4072
getdents64(4, {{d_ino=3D53247471, d_off=3D771, d_type=3DDT_UNKNOWN, d_rec=
len=3D32, d_name=3D"saa7115.o"} {d_ino=3D53247579, d_off=3D775, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D"tveeprom.mod.c"} {d_ino=3D53247474, =
d_off=3D779, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".saa7115.o.cmd=
"} {d_ino=3D53247518, d_off=3D783, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_=
name=3D".hexium_orion.o.cmd"} {d_ino=3D53256778, d_off=3D786, d_type=3DDT=
_UNKNOWN, d_reclen=3D40, d_name=3D"saa7114.mod.c"} {d_ino=3D53247473, d_o=
ff=3D789, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"saa717x.o"} {d_in=
o=3D53247580, d_off=3D793, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"=
tvaudio.mod.c"} {d_ino=3D53247476, d_off=3D797, d_type=3DDT_UNKNOWN, d_re=
clen=3D40, d_name=3D".saa717x.o.cmd"} {d_ino=3D53247517, d_off=3D801, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"hexium_gemini.o"} {d_ino=3D532=
56779, d_off=3D804, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"saa7111=
=2Emod.c"} {d_ino=3D53247475, d_off=3D807, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"saa7127.o"} {d_ino=3D53247581, d_off=3D811, d_type=3DDT_UNK=
NOWN, d_reclen=3D32, d_name=3D"tuner.mod.c"} {d_ino=3D53247478, d_off=3D8=
15, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".saa7127.o.cmd"} {d_ino=
=3D53247520, d_off=3D819, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".=
hexium_gemini.o.cmd"} {d_ino=3D53256780, d_off=3D822, d_type=3DDT_UNKNOWN=
, d_reclen=3D40, d_name=3D"saa7110.mod.c"} {d_ino=3D53247477, d_off=3D825=
, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"saa7185.o"} {d_ino=3D5324=
7582, d_off=3D829, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tlv320ai=
c23b.mod.c"} {d_ino=3D53247480, d_off=3D833, d_type=3DDT_UNKNOWN, d_recle=
n=3D40, d_name=3D".saa7185.o.cmd"} {d_ino=3D53247519, d_off=3D837, d_type=
=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".videobuf-core.o.cmd"} {d_ino=3D5=
3256781, d_off=3D840, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"saa52=
49.mod.c"} {d_ino=3D53247479, d_off=3D843, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"saa7191.o"} {d_ino=3D53247583, d_off=3D847, d_type=3DDT_UNK=
NOWN, d_reclen=3D40, d_name=3D"tea6420.mod.c"} {d_ino=3D53247482, d_off=3D=
851, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".saa7191.o.cmd"} {d_in=
o=3D53247523, d_off=3D855, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"=
videobuf-core.o"} {d_ino=3D53256783, d_off=3D858, d_type=3DDT_UNKNOWN, d_=
reclen=3D32, d_name=3D"ov7670.mod.c"} {d_ino=3D53247481, d_off=3D861, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"adv7170.o"} {d_ino=3D53256768,=
 d_off=3D865, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tea6415c.mod.=
c"} {d_ino=3D53247484, d_off=3D869, d_type=3DDT_UNKNOWN, d_reclen=3D40, d=
_name=3D".adv7170.o.cmd"} {d_ino=3D53247521, d_off=3D876, d_type=3DDT_UNK=
NOWN, d_reclen=3D48, d_name=3D".videobuf-dma-sg.o.cmd"} {d_ino=3D53247483=
, d_off=3D879, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"adv7175.o"} =
{d_ino=3D53256769, d_off=3D883, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_nam=
e=3D"tda9875.mod.c"} {d_ino=3D53247486, d_off=3D887, d_type=3DDT_UNKNOWN,=
 d_reclen=3D40, d_name=3D".adv7175.o.cmd"} {d_ino=3D53247525, d_off=3D891=
, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"videobuf-dma-sg.o"} {d_in=
o=3D53256784, d_off=3D894, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"=
mxb.mod.c"} {d_ino=3D53247485, d_off=3D897, d_type=3DDT_UNKNOWN, d_reclen=
=3D32, d_name=3D"vpx3220.o"} {d_ino=3D53256770, d_off=3D901, d_type=3DDT_=
UNKNOWN, d_reclen=3D40, d_name=3D"tda9840.mod.c"} {d_ino=3D53247488, d_of=
f=3D905, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".vpx3220.o.cmd"} {=
d_ino=3D53247526, d_off=3D911, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=
=3D".tveeprom.o.cmd"} {d_ino=3D53247487, d_off=3D914, d_type=3DDT_UNKNOWN=
, d_reclen=3D32, d_name=3D"bt819.o"} {d_ino=3D53256785, d_off=3D917, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"msp3400.mod.c"} {d_ino=3D532474=
90, d_off=3D920, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D".bt819.o.c=
md"} {d_ino=3D53247529, d_off=3D923, d_type=3DDT_UNKNOWN, d_reclen=3D32, =
d_name=3D"btcx-risc.o"} {d_ino=3D53256786, d_off=3D926, d_type=3DDT_UNKNO=
WN, d_reclen=3D32, d_name=3D"m52790.mod.c"} {d_ino=3D53247489, d_off=3D92=
9, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"bt856.o"} {d_ino=3D53256=
787, d_off=3D932, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"ks0127.mo=
d.c"} {d_ino=3D53247492, d_off=3D935, d_type=3DDT_UNKNOWN, d_reclen=3D32,=
 d_name=3D".bt856.o.cmd"} {d_ino=3D53247532, d_off=3D941, d_type=3DDT_UNK=
NOWN, d_reclen=3D40, d_name=3D".upd64031a.o.cmd"} {d_ino=3D53247491, d_of=
f=3D944, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"bt866.o"} {d_ino=3D=
53256791, d_off=3D947, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"cx23=
41x.mod.c"} {d_ino=3D53247494, d_off=3D950, d_type=3DDT_UNKNOWN, d_reclen=
=3D32, d_name=3D".bt866.o.cmd"} {d_ino=3D53247531, d_off=3D953, d_type=3D=
DT_UNKNOWN, d_reclen=3D32, d_name=3D"tveeprom.o"} {d_ino=3D53256793, d_of=
f=3D956, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"cs5345.mod.c"} {d_=
ino=3D53247493, d_off=3D959, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"ks0127.o"} {d_ino=3D53256796, d_off=3D962, d_type=3DDT_UNKNOWN, d_reclen=
=3D32, d_name=3D"bt866.mod.c"} {d_ino=3D53247496, d_off=3D965, d_type=3DD=
T_UNKNOWN, d_reclen=3D40, d_name=3D".ks0127.o.cmd"} {d_ino=3D53247524, d_=
off=3D969, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".btcx-risc.o.cmd=
"} {d_ino=3D53256797, d_off=3D972, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_=
name=3D"bt856.mod.c"} {d_ino=3D53247495, d_off=3D975, d_type=3DDT_UNKNOWN=
, d_reclen=3D32, d_name=3D"tvp5150.o"} {d_ino=3D53256771, d_off=3D979, d_=
type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tda7432.mod.c"} {d_ino=3D5324=
7498, d_off=3D983, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tvp5150=
=2Eo.cmd"} {d_ino=3D53247497, d_off=3D986, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"msp3400.o"} {d_ino=3D53247499, d_off=3D990, d_type=3DDT_UNK=
NOWN, d_reclen=3D40, d_name=3D".msp3400.o.cmd"} {d_ino=3D53247528, d_off=3D=
993, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"upd64031a.o"} {d_ino=3D=
53256798, d_off=3D996, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"bt81=
9.mod.c"} {d_ino=3D53247500, d_off=3D999, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"cs5345.o"} {d_ino=3D53256799, d_off=3D1002, d_type=3DDT_UNK=
NOWN, d_reclen=3D40, d_name=3D"adv7175.mod.c"} {d_ino=3D53247502, d_off=3D=
1005, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".cs5345.o.cmd"} {d_in=
o=3D53247527, d_off=3D1009, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
"videobuf-dvb.o"} {d_ino=3D53256800, d_off=3D1012, d_type=3DDT_UNKNOWN, d=
_reclen=3D40, d_name=3D"adv7170.mod.c"} {d_ino=3D53247501, d_off=3D1015, =
d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"cs53l32a.o"} {d_ino=3D53256=
772, d_off=3D1019, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tcm825x.=
mod.c"} {d_ino=3D53247530, d_off=3D1026, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"upd64083.o"} {d_ino=3D53256782, d_off=3D1030, d_type=3DDT_U=
NKNOWN, d_reclen=3D40, d_name=3D"saa5246a.mod.c"} {d_ino=3D53256788, d_of=
f=3D1034, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"ir-kbd-i2c.mod.c"=
} {d_ino=3D53256789, d_off=3D1038, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_=
name=3D"hexium_orion.mod.c"} {d_ino=3D53256790, d_off=3D1042, d_type=3DDT=
_UNKNOWN, d_reclen=3D40, d_name=3D"hexium_gemini.mod.c"} {d_ino=3D5325679=
2, d_off=3D1046, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"cs53l32a.m=
od.c"} {d_ino=3D53256794, d_off=3D1050, d_type=3DDT_UNKNOWN, d_reclen=3D4=
0, d_name=3D"compat_ioctl32.mod.c"} {d_ino=3D53256795, d_off=3D1054, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"btcx-risc.mod.c"} {d_ino=3D5325=
6811, d_off=3D1057, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"adv7170=
=2Emod.o"} {d_ino=3D53258658, d_off=3D1061, d_type=3DDT_UNKNOWN, d_reclen=
=3D40, d_name=3D".saa7111.ko.cmd"} {d_ino=3D53258688, d_off=3D1065, d_typ=
e=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda7432.ko"} {d_ino=3D53256813, =
d_off=3D1069, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".adv7170.mod.=
o.cmd"} {d_ino=3D53256812, d_off=3D1072, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"adv7170.ko"} {d_ino=3D53256814, d_off=3D1076, d_type=3DDT_U=
NKNOWN, d_reclen=3D40, d_name=3D".adv7170.ko.cmd"} {d_ino=3D53256815, d_o=
ff=3D1079, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"adv7175.mod.o"} =
{d_ino=3D53258659, d_off=3D1082, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_na=
me=3D"saa7114.mod.o"} {d_ino=3D53258680, d_off=3D1087, d_type=3DDT_UNKNOW=
N, d_reclen=3D32, d_name=3D"saa7191.ko"} {d_ino=3D53256817, d_off=3D1091,=
 d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".adv7175.mod.o.cmd"} {d_in=
o=3D53256816, d_off=3D1094, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"adv7175.ko"} {d_ino=3D53256818, d_off=3D1098, d_type=3DDT_UNKNOWN, d_rec=
len=3D40, d_name=3D".adv7175.ko.cmd"} {d_ino=3D53256819, d_off=3D1101, d_=
type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"bt819.mod.o"} {d_ino=3D532586=
60, d_off=3D1104, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"saa7114.k=
o"} {d_ino=3D53258682, d_off=3D1109, d_type=3DDT_UNKNOWN, d_reclen=3D40, =
d_name=3D".saa7191.ko.cmd"} {d_ino=3D53256821, d_off=3D1113, d_type=3DDT_=
UNKNOWN, d_reclen=3D40, d_name=3D".bt819.mod.o.cmd"} {d_ino=3D53256820, d=
_off=3D1116, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"bt819.ko"} {d_=
ino=3D53256822, d_off=3D1119, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
".bt819.ko.cmd"} {d_ino=3D53256823, d_off=3D1122, d_type=3DDT_UNKNOWN, d_=
reclen=3D32, d_name=3D"bt856.mod.o"} {d_ino=3D53258662, d_off=3D1126, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".saa7114.ko.cmd"} {d_ino=3D532=
58690, d_off=3D1130, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda74=
32.ko.cmd"} {d_ino=3D53256825, d_off=3D1134, d_type=3DDT_UNKNOWN, d_recle=
n=3D40, d_name=3D".bt856.mod.o.cmd"} {d_ino=3D53256824, d_off=3D1137, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"bt856.ko"} {d_ino=3D53256826, =
d_off=3D1140, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".bt856.ko.cmd=
"} {d_ino=3D53256827, d_off=3D1143, d_type=3DDT_UNKNOWN, d_reclen=3D32, d=
_name=3D"bt866.mod.o"} {d_ino=3D53258661, d_off=3D1147, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D".saa7114.mod.o.cmd"} {d_ino=3D53258689, d_of=
f=3D1151, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tda7432.mod.o.cm=
d"} {d_ino=3D53256829, d_off=3D1155, d_type=3DDT_UNKNOWN, d_reclen=3D40, =
d_name=3D".bt866.mod.o.cmd"} {d_ino=3D53256828, d_off=3D1158, d_type=3DDT=
_UNKNOWN, d_reclen=3D32, d_name=3D"bt866.ko"} {d_ino=3D53256830, d_off=3D=
1161, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".bt866.ko.cmd"} {d_in=
o=3D53256831, d_off=3D1165, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
"btcx-risc.mod.o"}}, 4096) =3D 4064
getdents64(4, {{d_ino=3D53258663, d_off=3D1168, d_type=3DDT_UNKNOWN, d_re=
clen=3D40, d_name=3D"saa7115.mod.o"} {d_ino=3D53258681, d_off=3D1173, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".saa7191.mod.o.cmd"} {d_ino=3D=
53258593, d_off=3D1177, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".bt=
cx-risc.mod.o.cmd"} {d_ino=3D53258592, d_off=3D1180, d_type=3DDT_UNKNOWN,=
 d_reclen=3D32, d_name=3D"btcx-risc.ko"} {d_ino=3D53258594, d_off=3D1184,=
 d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".btcx-risc.ko.cmd"} {d_ino=
=3D53256809, d_off=3D1188, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"=
compat_ioctl32.mod.o"} {d_ino=3D53258654, d_off=3D1192, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D".saa7110.ko.cmd"} {d_ino=3D53258676, d_off=3D=
1195, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"saa7185.ko"} {d_ino=3D=
53258700, d_off=3D1198, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tea=
6415c.ko"} {d_ino=3D53392039, d_off=3D1203, d_type=3DDT_UNKNOWN, d_reclen=
=3D48, d_name=3D".compat_ioctl32.mod.o.cmd"} {d_ino=3D53258595, d_off=3D1=
207, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"compat_ioctl32.ko"} {d=
_ino=3D53258598, d_off=3D1212, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=
=3D".compat_ioctl32.ko.cmd"} {d_ino=3D53258599, d_off=3D1215, d_type=3DDT=
_UNKNOWN, d_reclen=3D32, d_name=3D"cs5345.mod.o"} {d_ino=3D53258664, d_of=
f=3D1218, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"saa7115.ko"} {d_i=
no=3D53258683, d_off=3D1223, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
"tcm825x.mod.o"} {d_ino=3D53258601, d_off=3D1227, d_type=3DDT_UNKNOWN, d_=
reclen=3D40, d_name=3D".cs5345.mod.o.cmd"} {d_ino=3D53258600, d_off=3D123=
0, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"cs5345.ko"} {d_ino=3D532=
58602, d_off=3D1234, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".cs534=
5.ko.cmd"} {d_ino=3D53258603, d_off=3D1238, d_type=3DDT_UNKNOWN, d_reclen=
=3D40, d_name=3D"cs53l32a.mod.o"} {d_ino=3D53258666, d_off=3D1242, d_type=
=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".saa7115.ko.cmd"} {d_ino=3D532586=
91, d_off=3D1246, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tda9840.m=
od.o"} {d_ino=3D53258605, d_off=3D1250, d_type=3DDT_UNKNOWN, d_reclen=3D4=
0, d_name=3D".cs53l32a.mod.o.cmd"} {d_ino=3D53258604, d_off=3D1253, d_typ=
e=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"cs53l32a.ko"} {d_ino=3D53258606,=
 d_off=3D1257, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".cs53l32a.ko=
=2Ecmd"} {d_ino=3D53258607, d_off=3D1260, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D"cx2341x.mod.o"} {d_ino=3D53258665, d_off=3D1264, d_type=3DD=
T_UNKNOWN, d_reclen=3D40, d_name=3D".saa7115.mod.o.cmd"} {d_ino=3D5325869=
2, d_off=3D1268, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tda9840.ko=
"} {d_ino=3D53258609, d_off=3D1272, d_type=3DDT_UNKNOWN, d_reclen=3D40, d=
_name=3D".cx2341x.mod.o.cmd"} {d_ino=3D53258608, d_off=3D1275, d_type=3DD=
T_UNKNOWN, d_reclen=3D32, d_name=3D"cx2341x.ko"} {d_ino=3D53258610, d_off=
=3D1279, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".cx2341x.ko.cmd"} =
{d_ino=3D53258611, d_off=3D1283, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_na=
me=3D"hexium_gemini.mod.o"} {d_ino=3D53258655, d_off=3D1286, d_type=3DDT_=
UNKNOWN, d_reclen=3D40, d_name=3D"saa7111.mod.o"} {d_ino=3D53258675, d_of=
f=3D1289, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"saa7185.mod.o"} {=
d_ino=3D53258694, d_off=3D1293, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_nam=
e=3D".tda9840.ko.cmd"} {d_ino=3D53258613, d_off=3D1298, d_type=3DDT_UNKNO=
WN, d_reclen=3D48, d_name=3D".hexium_gemini.mod.o.cmd"} {d_ino=3D53258612=
, d_off=3D1302, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"hexium_gemi=
ni.ko"} {d_ino=3D53258614, d_off=3D1306, d_type=3DDT_UNKNOWN, d_reclen=3D=
48, d_name=3D".hexium_gemini.ko.cmd"} {d_ino=3D53258615, d_off=3D1310, d_=
type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"hexium_orion.mod.o"} {d_ino=3D=
53258656, d_off=3D1313, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"saa=
7111.ko"} {d_ino=3D53258678, d_off=3D1319, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D".saa7185.ko.cmd"} {d_ino=3D53258617, d_off=3D1324, d_type=3D=
DT_UNKNOWN, d_reclen=3D48, d_name=3D".hexium_orion.mod.o.cmd"} {d_ino=3D5=
3258616, d_off=3D1328, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"hexi=
um_orion.ko"} {d_ino=3D53258618, d_off=3D1332, d_type=3DDT_UNKNOWN, d_rec=
len=3D40, d_name=3D".hexium_orion.ko.cmd"} {d_ino=3D53258619, d_off=3D133=
6, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"ir-kbd-i2c.mod.o"} {d_in=
o=3D53258667, d_off=3D1339, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
"saa7127.mod.o"} {d_ino=3D53258685, d_off=3D1344, d_type=3DDT_UNKNOWN, d_=
reclen=3D40, d_name=3D".tcm825x.mod.o.cmd"} {d_ino=3D53258621, d_off=3D13=
48, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D".ir-kbd-i2c.mod.o.cmd"}=
 {d_ino=3D53258620, d_off=3D1351, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_n=
ame=3D"ir-kbd-i2c.ko"} {d_ino=3D53258622, d_off=3D1355, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D".ir-kbd-i2c.ko.cmd"} {d_ino=3D53258623, d_of=
f=3D1358, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"ks0127.mod.o"} {d=
_ino=3D53258668, d_off=3D1361, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=
=3D"saa7127.ko"} {d_ino=3D53258684, d_off=3D1366, d_type=3DDT_UNKNOWN, d_=
reclen=3D32, d_name=3D"tcm825x.ko"} {d_ino=3D53258625, d_off=3D1370, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".ks0127.mod.o.cmd"} {d_ino=3D53=
258624, d_off=3D1373, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"ks012=
7.ko"} {d_ino=3D53258626, d_off=3D1377, d_type=3DDT_UNKNOWN, d_reclen=3D4=
0, d_name=3D".ks0127.ko.cmd"} {d_ino=3D53258627, d_off=3D1380, d_type=3DD=
T_UNKNOWN, d_reclen=3D32, d_name=3D"m52790.mod.o"} {d_ino=3D53258670, d_o=
ff=3D1384, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".saa7127.ko.cmd"=
} {d_ino=3D53258693, d_off=3D1388, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_=
name=3D".tda9840.mod.o.cmd"} {d_ino=3D53258629, d_off=3D1392, d_type=3DDT=
_UNKNOWN, d_reclen=3D40, d_name=3D".m52790.mod.o.cmd"} {d_ino=3D53258628,=
 d_off=3D1395, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"m52790.ko"} =
{d_ino=3D53258630, d_off=3D1399, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_na=
me=3D".m52790.ko.cmd"} {d_ino=3D53258631, d_off=3D1402, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D"msp3400.mod.o"} {d_ino=3D53258669, d_off=3D1=
406, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".saa7127.mod.o.cmd"} {=
d_ino=3D53258695, d_off=3D1410, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_nam=
e=3D"tda9875.mod.o"} {d_ino=3D53258633, d_off=3D1414, d_type=3DDT_UNKNOWN=
, d_reclen=3D40, d_name=3D".msp3400.mod.o.cmd"} {d_ino=3D53258632, d_off=3D=
1417, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"msp3400.ko"} {d_ino=3D=
53258634, d_off=3D1421, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".ms=
p3400.ko.cmd"} {d_ino=3D53258635, d_off=3D1424, d_type=3DDT_UNKNOWN, d_re=
clen=3D32, d_name=3D"mxb.mod.o"} {d_ino=3D53258677, d_off=3D1428, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D".saa7185.mod.o.cmd"} {d_ino=3D532587=
03, d_off=3D1431, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tea6420.m=
od.o"} {d_ino=3D53258637, d_off=3D1435, d_type=3DDT_UNKNOWN, d_reclen=3D4=
0, d_name=3D".mxb.mod.o.cmd"} {d_ino=3D53258636, d_off=3D1438, d_type=3DD=
T_UNKNOWN, d_reclen=3D32, d_name=3D"mxb.ko"} {d_ino=3D53258638, d_off=3D1=
441, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D".mxb.ko.cmd"} {d_ino=3D=
53258639, d_off=3D1444, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"ov7=
670.mod.o"} {d_ino=3D53258671, d_off=3D1447, d_type=3DDT_UNKNOWN, d_recle=
n=3D40, d_name=3D"saa717x.mod.o"} {d_ino=3D53258686, d_off=3D1452, d_type=
=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tcm825x.ko.cmd"} {d_ino=3D532586=
41, d_off=3D1456, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".ov7670.m=
od.o.cmd"} {d_ino=3D53258640, d_off=3D1459, d_type=3DDT_UNKNOWN, d_reclen=
=3D32, d_name=3D"ov7670.ko"} {d_ino=3D53258642, d_off=3D1463, d_type=3DDT=
_UNKNOWN, d_reclen=3D40, d_name=3D".ov7670.ko.cmd"} {d_ino=3D53258643, d_=
off=3D1467, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"saa5246a.mod.o"=
} {d_ino=3D53258673, d_off=3D1471, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_=
name=3D".saa717x.mod.o.cmd"} {d_ino=3D53258697, d_off=3D1475, d_type=3DDT=
_UNKNOWN, d_reclen=3D40, d_name=3D".tda9875.mod.o.cmd"} {d_ino=3D53258645=
, d_off=3D1479, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".saa5246a.m=
od.o.cmd"} {d_ino=3D53258644, d_off=3D1482, d_type=3DDT_UNKNOWN, d_reclen=
=3D32, d_name=3D"saa5246a.ko"} {d_ino=3D53258646, d_off=3D1486, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D".saa5246a.ko.cmd"} {d_ino=3D53258647=
, d_off=3D1489, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"saa5249.mod=
=2Eo"} {d_ino=3D53258672, d_off=3D1492, d_type=3DDT_UNKNOWN, d_reclen=3D3=
2, d_name=3D"saa717x.ko"} {d_ino=3D53258687, d_off=3D1497, d_type=3DDT_UN=
KNOWN, d_reclen=3D40, d_name=3D"tda7432.mod.o"} {d_ino=3D53258649, d_off=3D=
1501, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".saa5249.mod.o.cmd"} =
{d_ino=3D53258648, d_off=3D1504, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_na=
me=3D"saa5249.ko"} {d_ino=3D53258650, d_off=3D1508, d_type=3DDT_UNKNOWN, =
d_reclen=3D40, d_name=3D".saa5249.ko.cmd"} {d_ino=3D53258651, d_off=3D151=
1, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"saa7110.mod.o"} {d_ino=3D=
53258674, d_off=3D1515, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".sa=
a717x.ko.cmd"} {d_ino=3D53258696, d_off=3D1519, d_type=3DDT_UNKNOWN, d_re=
clen=3D32, d_name=3D"tda9875.ko"} {d_ino=3D53258653, d_off=3D1523, d_type=
=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".saa7110.mod.o.cmd"} {d_ino=3D532=
58652, d_off=3D1526, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"saa711=
0.ko"} {d_ino=3D53258657, d_off=3D1530, d_type=3DDT_UNKNOWN, d_reclen=3D4=
0, d_name=3D".saa7111.mod.o.cmd"} {d_ino=3D53258679, d_off=3D1533, d_type=
=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"saa7191.mod.o"} {d_ino=3D53258704=
, d_off=3D1538, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tea6420.ko"=
} {d_ino=3D53258698, d_off=3D1542, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_=
name=3D".tda9875.ko.cmd"} {d_ino=3D53258699, d_off=3D1554, d_type=3DDT_UN=
KNOWN, d_reclen=3D40, d_name=3D"tea6415c.mod.o"} {d_ino=3D53258701, d_off=
=3D1558, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tea6415c.mod.o.cm=
d"} {d_ino=3D53258702, d_off=3D1570, d_type=3DDT_UNKNOWN, d_reclen=3D40, =
d_name=3D".tea6415c.ko.cmd"} {d_ino=3D53258705, d_off=3D1574, d_type=3DDT=
_UNKNOWN, d_reclen=3D40, d_name=3D".tea6420.mod.o.cmd"} {d_ino=3D53258706=
, d_off=3D1578, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tea6420.ko=
=2Ecmd"} {d_ino=3D53258707, d_off=3D1591, d_type=3DDT_UNKNOWN, d_reclen=3D=
40, d_name=3D"tlv320aic23b.mod.o"}}, 4096) =3D 4064
getdents64(4, {{d_ino=3D53258709, d_off=3D1596, d_type=3DDT_UNKNOWN, d_re=
clen=3D48, d_name=3D".tlv320aic23b.mod.o.cmd"} {d_ino=3D53258708, d_off=3D=
1600, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tlv320aic23b.ko"} {d_=
ino=3D53258710, d_off=3D1604, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
".tlv320aic23b.ko.cmd"} {d_ino=3D53258711, d_off=3D1615, d_type=3DDT_UNKN=
OWN, d_reclen=3D32, d_name=3D"tuner.mod.o"} {d_ino=3D53258713, d_off=3D16=
19, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tuner.mod.o.cmd"} {d_i=
no=3D53258712, d_off=3D1622, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"tuner.ko"} {d_ino=3D53258714, d_off=3D1625, d_type=3DDT_UNKNOWN, d_recle=
n=3D40, d_name=3D".tuner.ko.cmd"} {d_ino=3D53258715, d_off=3D1636, d_type=
=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tvaudio.mod.o"} {d_ino=3D53258717=
, d_off=3D1640, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tvaudio.mo=
d.o.cmd"} {d_ino=3D53258716, d_off=3D1643, d_type=3DDT_UNKNOWN, d_reclen=3D=
32, d_name=3D"tvaudio.ko"} {d_ino=3D53258718, d_off=3D1647, d_type=3DDT_U=
NKNOWN, d_reclen=3D40, d_name=3D".tvaudio.ko.cmd"} {d_ino=3D53258719, d_o=
ff=3D1659, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"tveeprom.mod.o"}=
 {d_ino=3D53258753, d_off=3D1663, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_n=
ame=3D".tveeprom.mod.o.cmd"} {d_ino=3D53258752, d_off=3D1666, d_type=3DDT=
_UNKNOWN, d_reclen=3D32, d_name=3D"tveeprom.ko"} {d_ino=3D53258754, d_off=
=3D1670, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".tveeprom.ko.cmd"}=
 {d_ino=3D53258755, d_off=3D1681, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_n=
ame=3D"tvp5150.mod.o"} {d_ino=3D53258757, d_off=3D1685, d_type=3DDT_UNKNO=
WN, d_reclen=3D40, d_name=3D".tvp5150.mod.o.cmd"} {d_ino=3D53258756, d_of=
f=3D1688, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"tvp5150.ko"} {d_i=
no=3D53258758, d_off=3D1692, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
".tvp5150.ko.cmd"} {d_ino=3D53258759, d_off=3D1704, d_type=3DDT_UNKNOWN, =
d_reclen=3D40, d_name=3D"upd64031a.mod.o"} {d_ino=3D53258761, d_off=3D170=
8, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".upd64031a.mod.o.cmd"} {=
d_ino=3D53258760, d_off=3D1711, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_nam=
e=3D"upd64031a.ko"} {d_ino=3D53258762, d_off=3D1715, d_type=3DDT_UNKNOWN,=
 d_reclen=3D40, d_name=3D".upd64031a.ko.cmd"} {d_ino=3D53258763, d_off=3D=
1727, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"upd64083.mod.o"} {d_i=
no=3D53258765, d_off=3D1731, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
".upd64083.mod.o.cmd"} {d_ino=3D53258764, d_off=3D1734, d_type=3DDT_UNKNO=
WN, d_reclen=3D32, d_name=3D"upd64083.ko"} {d_ino=3D53258766, d_off=3D173=
8, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".upd64083.ko.cmd"} {d_in=
o=3D53258775, d_off=3D1751, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D=
"videodev.ko"} {d_ino=3D53392040, d_off=3D1760, d_type=3DDT_UNKNOWN, d_re=
clen=3D48, d_name=3D".v4l1-compat.mod.o.cmd"} {d_ino=3D53258770, d_off=3D=
1764, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".v4l1-compat.ko.cmd"}=
 {d_ino=3D53258596, d_off=3D1777, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_n=
ame=3D"v4l1-compat.mod.o"} {d_ino=3D53392037, d_off=3D1786, d_type=3DDT_U=
NKNOWN, d_reclen=3D48, d_name=3D".v4l2-common.mod.o.cmd"} {d_ino=3D532587=
74, d_off=3D1790, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".v4l2-com=
mon.ko.cmd"} {d_ino=3D53258773, d_off=3D1804, d_type=3DDT_UNKNOWN, d_recl=
en=3D40, d_name=3D"videodev.mod.o"} {d_ino=3D53258772, d_off=3D1813, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D".v4l2-int-device.mod.o.cmd"} {d=
_ino=3D53258778, d_off=3D1818, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=
=3D".v4l2-int-device.ko.cmd"} {d_ino=3D53258779, d_off=3D1832, d_type=3DD=
T_UNKNOWN, d_reclen=3D40, d_name=3D"videobuf-core.mod.o"} {d_ino=3D532587=
81, d_off=3D1837, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D".videobuf=
-core.mod.o.cmd"} {d_ino=3D53258780, d_off=3D1841, d_type=3DDT_UNKNOWN, d=
_reclen=3D40, d_name=3D"videobuf-core.ko"} {d_ino=3D53258782, d_off=3D184=
5, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D".videobuf-core.ko.cmd"} =
{d_ino=3D53258783, d_off=3D1859, d_type=3DDT_UNKNOWN, d_reclen=3D48, d_na=
me=3D"videobuf-dma-sg.mod.o"} {d_ino=3D53258785, d_off=3D1864, d_type=3DD=
T_UNKNOWN, d_reclen=3D48, d_name=3D".videobuf-dma-sg.mod.o.cmd"} {d_ino=3D=
53258784, d_off=3D1868, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"vid=
eobuf-dma-sg.ko"} {d_ino=3D53258786, d_off=3D1873, d_type=3DDT_UNKNOWN, d=
_reclen=3D48, d_name=3D".videobuf-dma-sg.ko.cmd"} {d_ino=3D53258787, d_of=
f=3D1886, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"videobuf-dvb.mod.=
o"} {d_ino=3D53258789, d_off=3D1891, d_type=3DDT_UNKNOWN, d_reclen=3D48, =
d_name=3D".videobuf-dvb.mod.o.cmd"} {d_ino=3D53258788, d_off=3D1895, d_ty=
pe=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"videobuf-dvb.ko"} {d_ino=3D5325=
8790, d_off=3D1899, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".videob=
uf-dvb.ko.cmd"} {d_ino=3D53258767, d_off=3D1911, d_type=3DDT_UNKNOWN, d_r=
eclen=3D40, d_name=3D"v4l2-common.mod.o"} {d_ino=3D53258776, d_off=3D1918=
, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".videodev.mod.o.cmd"} {d_=
ino=3D53258794, d_off=3D1922, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
".videodev.ko.cmd"} {d_ino=3D53258795, d_off=3D1934, d_type=3DDT_UNKNOWN,=
 d_reclen=3D40, d_name=3D"vp27smpx.mod.o"} {d_ino=3D53258797, d_off=3D193=
8, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".vp27smpx.mod.o.cmd"} {d=
_ino=3D53258796, d_off=3D1941, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=
=3D"vp27smpx.ko"} {d_ino=3D53258798, d_off=3D1945, d_type=3DDT_UNKNOWN, d=
_reclen=3D40, d_name=3D".vp27smpx.ko.cmd"} {d_ino=3D53258799, d_off=3D195=
6, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D"vpx3220.mod.o"} {d_ino=3D=
53258801, d_off=3D1960, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".vp=
x3220.mod.o.cmd"} {d_ino=3D53258800, d_off=3D1963, d_type=3DDT_UNKNOWN, d=
_reclen=3D32, d_name=3D"vpx3220.ko"} {d_ino=3D53258802, d_off=3D1967, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".vpx3220.ko.cmd"} {d_ino=3D532=
58803, d_off=3D1978, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"wm8739=
=2Emod.o"} {d_ino=3D53258805, d_off=3D1982, d_type=3DDT_UNKNOWN, d_reclen=
=3D40, d_name=3D".wm8739.mod.o.cmd"} {d_ino=3D53258804, d_off=3D1985, d_t=
ype=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"wm8739.ko"} {d_ino=3D53258806,=
 d_off=3D1989, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D".wm8739.ko.c=
md"} {d_ino=3D53258807, d_off=3D2000, d_type=3DDT_UNKNOWN, d_reclen=3D32,=
 d_name=3D"wm8775.mod.o"} {d_ino=3D53258809, d_off=3D2004, d_type=3DDT_UN=
KNOWN, d_reclen=3D40, d_name=3D".wm8775.mod.o.cmd"} {d_ino=3D53258808, d_=
off=3D2007, d_type=3DDT_UNKNOWN, d_reclen=3D32, d_name=3D"wm8775.ko"} {d_=
ino=3D53258810, d_off=3D2011, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=3D=
".wm8775.ko.cmd"} {d_ino=3D53258768, d_off=3D2015, d_type=3DDT_UNKNOWN, d=
_reclen=3D40, d_name=3D"v4l2-common.ko"} {d_ino=3D53258769, d_off=3D2019,=
 d_type=3DDT_UNKNOWN, d_reclen=3D48, d_name=3D"v4l2-int-device.mod.o"} {d=
_ino=3D53258771, d_off=3D2035, d_type=3DDT_UNKNOWN, d_reclen=3D40, d_name=
=3D"v4l2-int-device.ko"} {d_ino=3D53258597, d_off=3D4294967295, d_type=3D=
DT_UNKNOWN, d_reclen=3D40, d_name=3D"v4l1-compat.ko"}}, 4096) =3D 2824
_llseek(4, 2035, [2035], SEEK_SET)      =3D 0
getdents64(4, {{d_ino=3D53258597, d_off=3D4294967295, d_type=3DDT_UNKNOWN=
, d_reclen=3D40, d_name=3D"v4l1-compat.ko"}}, 4096) =3D 40
close(4)                                =3D 0
write(1, "../linux/drivers/media/dvb/ttusb"..., 965) =3D 965
write(2, "/usr/src/findutils-4.1.20/find/f"..., 37) =3D 37
write(2, "../linux/drivers/media/video", 28) =3D 28
write(2, ": Der Wert ist zu gro\337 f\374r den d"..., 51) =3D 51
write(2, "\n", 1)                       =3D 1
fchdir(3)                               =3D 0
munmap(0xb7ca4000, 4096)                =3D 0
exit_group(1)                           =3D ?

--------------020008030406090103030808--
