Return-Path: <linux-kernel-owner+w=401wt.eu-S936346AbXHHQ34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936346AbXHHQ34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936494AbXHHQ2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:28:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:12658 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936433AbXHHQ2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:28:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=UW3vSy18mFppdei6ayDN3wfgaaEH346uFh1WsXszsPc9h5uAPr/8RNH/f2T895BuZSN175uU4HsEFXSG1cTOoQ3McdNHcLaicX6Sdpcb5iLvgGTxOUaj3U+6OgUA1gU3Ll23suaKwZXBYAvhM7VsgilmTfkQiFW364MUulp6zuc=
Message-ID: <46B9EF1D.4010907@googlemail.com>
Date: Wed, 08 Aug 2007 18:28:13 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: problems while mounting /boot partition
References: <1186504459.6949.40.camel@pc.ilinx>
In-Reply-To: <1186504459.6949.40.camel@pc.ilinx>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

Brian J. Murrell pisze:
> I am using Ubuntu Gutsy, which is the in-development branch heading for
> their next stable release.

You forgot about message subject, so no one has read this report.

> 
> I have noticed that since some kernel release post-2.6.20 I have been
> unable to mount my /boot partition:
> 
> $ sudo strace -f mount /dev/hda1 /mnt/foo
> execve("/bin/mount", ["mount", "/dev/hda1", "/mnt/foo"], [/* 41 vars*/])= 0
> brk(0)                                  = 0x8062000
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7fbc000
> access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
> open("/etc/ld.so.cache", O_RDONLY)      = 4
> fstat64(4, {st_mode=S_IFREG|0644, st_size=91976, ...}) = 0
> mmap2(NULL, 91976, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7fa5000
> close(4)                                = 0
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> open("/lib/tls/i686/cmov/libc.so.6", O_RDONLY) = 4
> read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\260a\1"..., 512) = 512
> fstat64(4, {st_mode=S_IFREG|0644, st_size=1339816, ...}) = 0
> mmap2(NULL, 1349136, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0xb7e5b000
> mmap2(0xb7f9f000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x143) = 0xb7f9f000
> mmap2(0xb7fa2000, 9744, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7fa2000
> close(4)                                = 0
> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7e5a000
> set_thread_area({entry_number:-1 -> 6, base_addr:0xb7e5a6b0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
> mprotect(0xb7f9f000, 4096, PROT_READ)   = 0
> munmap(0xb7fa5000, 91976)               = 0
> brk(0)                                  = 0x8062000
> brk(0x8083000)                          = 0x8083000
> open("/usr/lib/locale/locale-archive", O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
> open("/usr/share/locale/locale.alias", O_RDONLY) = 4
> fstat64(4, {st_mode=S_IFREG|0644, st_size=2586, ...}) = 0
> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7fbb000
> read(4, "# Locale name alias data base.\n#"..., 1024) = 1024
> read(4, "ies are case independent.\n\n# Not"..., 1024) = 1024
> read(4, ".euc \tko_KR.eucKR\nko_KR\t\tko_KR.e"..., 1024) = 538
> read(4, "", 1024)                       = 0
> close(4)                                = 0
> munmap(0xb7fbb000, 4096)                = 0
> open("/usr/lib/locale/en_CA.UTF-8/LC_IDENTIFICATION", O_RDONLY) = -1 ENOENT (No such file or directory)
> open("/usr/lib/locale/en_CA.utf8/LC_IDENTIFICATION", O_RDONLY) = 4
> fstat64(4, {st_mode=S_IFREG|0644, st_size=363, ...}) = 0
> mmap2(NULL, 363, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7fbb000
> close(4)                                = 0
> open("/usr/lib/gconv/gconv-modules.cache", O_RDONLY) = 4
> fstat64(4, {st_mode=S_IFREG|0644, st_size=25486, ...}) = 0
> mmap2(NULL, 25486, PROT_READ, MAP_SHARED, 4, 0) = 0xb7fb4000
> close(4)                                = 0
> open("/usr/lib/locale/en_CA.UTF-8/LC_MEASUREMENT", O_RDONLY) = -1 ENOENT (No such file or directory)
> open("/usr/lib/locale/en_CA.utf8/LC_MEASUREMENT", O_RDONLY) = 4
> fstat64(4, {st_mode=S_IFREG|0644, st_size=23, ...}) = 0
> mmap2(NULL, 23, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7fb3000
> close(4)                                = 0
> open("/usr/lib/locale/en_CA.UTF-8/LC_TELEPHONE", O_RDONLY) = -1 ENOENT (No such file or directory)
> open("/usr/lib/locale/en_CA.utf8/LC_TELEPHONE", O_RDONLY) = 4
> fstat64(4, {st_mode=S_IFREG|0644, st_size=51, ...}) = 0
> mmap2(NULL, 51, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7fb2000
> close(4)                                = 0
> open("/usr/lib/locale/en_CA.UTF-8/LC_ADDRESS", O_RDONLY) = -1 ENOENT (No such file or directory)
> open("/usr/lib/locale/en_CA.utf8/LC_ADDRESS", O_RDONLY) = 4
> fstat64(4, {st_mode=S_IFREG|0644, st_size=127, ...}) = 0
> mmap2(NULL, 127, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7fb1000
> close(4)                                = 0
> open("/usr/lib/locale/en_CA.UTF-8/LC_NAME", O_RDONLY) = -1 ENOENT (No such file or directory)
> open("/usr/lib/locale/en_CA.utf8/LC_NAME", O_RDONLY) = 4
> fstat64(4, {st_mode=S_IFREG|0644, st_size=62, ...}) = 0
> mmap2(NULL, 62, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7fb0000
> close(4)                                = 0
> open("/usr/lib/locale/en_CA.UTF-8/LC_PAPER", O_RDONLY) = -1 ENOENT (No such file or directory)
> open("/usr/lib/locale/en_CA.utf8/LC_PAPER", O_RDONLY) = 4
> fstat64(4, {st_mode=S_IFREG|0644, st_size=34, ...}) = 0
> mmap2(NULL, 34, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7faf000
> close(4)                                = 0
> open("/usr/lib/locale/en_CA.UTF-8/LC_MESSAGES", O_RDONLY) = -1 ENOENT (No such file or directory)
> open("/usr/lib/locale/en_CA.utf8/LC_MESSAGES", O_RDONLY) = 4
> fstat64(4, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
> close(4)                                = 0
> open("/usr/lib/locale/en_CA.utf8/LC_MESSAGES/SYS_LC_MESSAGES", O_RDONLY) = 4
> fstat64(4, {st_mode=S_IFREG|0644, st_size=54, ...}) = 0
> mmap2(NULL, 54, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7fae000
> close(4)                                = 0
> open("/usr/lib/locale/en_CA.UTF-8/LC_MONETARY", O_RDONLY) = -1 ENOENT (No such file or directory)
> open("/usr/lib/locale/en_CA.utf8/LC_MONETARY", O_RDONLY) = 4
> fstat64(4, {st_mode=S_IFREG|0644, st_size=286, ...}) = 0
> mmap2(NULL, 286, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7fad000
> close(4)                                = 0
> open("/usr/lib/locale/en_CA.UTF-8/LC_COLLATE", O_RDONLY) = -1 ENOENT (No such file or directory)
> open("/usr/lib/locale/en_CA.utf8/LC_COLLATE", O_RDONLY) = 4
> fstat64(4, {st_mode=S_IFREG|0644, st_size=880094, ...}) = 0
> mmap2(NULL, 880094, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7d83000
> close(4)                                = 0
> open("/usr/lib/locale/en_CA.UTF-8/LC_TIME", O_RDONLY) = -1 ENOENT (No such file or directory)
> open("/usr/lib/locale/en_CA.utf8/LC_TIME", O_RDONLY) = 4
> fstat64(4, {st_mode=S_IFREG|0644, st_size=2451, ...}) = 0
> mmap2(NULL, 2451, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7fac000
> close(4)                                = 0
> open("/usr/lib/locale/en_CA.UTF-8/LC_NUMERIC", O_RDONLY) = -1 ENOENT (No such file or directory)
> open("/usr/lib/locale/en_CA.utf8/LC_NUMERIC", O_RDONLY) = 4
> fstat64(4, {st_mode=S_IFREG|0644, st_size=54, ...}) = 0
> mmap2(NULL, 54, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7fab000
> close(4)                                = 0
> open("/usr/lib/locale/en_CA.UTF-8/LC_CTYPE", O_RDONLY) = -1 ENOENT (No such file or directory)
> open("/usr/lib/locale/en_CA.utf8/LC_CTYPE", O_RDONLY) = 4
> fstat64(4, {st_mode=S_IFREG|0644, st_size=238336, ...}) = 0
> mmap2(NULL, 238336, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7d48000
> close(4)                                = 0
> umask(022)                              = 022
> open("/dev/null", O_RDWR|O_LARGEFILE)   = 4
> close(4)                                = 0
> getuid32()                              = 0
> geteuid32()                             = 0
> lstat64("/etc/mtab", {st_mode=S_IFREG|0644, st_size=1136, ...}) = 0
> stat64("/dev/hda1", {st_mode=S_IFBLK|0660, st_rdev=makedev(3, 1), ...}) = 0
> rt_sigprocmask(SIG_BLOCK, ~[TRAP SEGV RTMIN RT_1], NULL, 8) = 0
> open("/dev/hda1", O_RDONLY|O_LARGEFILE) = 4
> ioctl(4, BLKGETSIZE64, 0xbf80f540)      = 0
> _llseek(4, 41025536, [41025536], SEEK_SET) = 0
> read(4, "#=\353\177\374A\305\366d\332&\230\373\222\\\353\3331\r"..., 2048) = 2048
> brk(0x80aa000)                          = 0x80aa000
> _llseek(4, 0, [0], SEEK_SET)            = 0
> read(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 2048) = 2048
> _llseek(4, 0, [0], SEEK_SET)            = 0
> read(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 6144) = 6144
> _llseek(4, 41093632, [41093632], SEEK_SET) = 0
> read(4, "e\262\321\332\273j\242\335\317*\nlb\237T\237\212\236\247"..., 512) = 512
> _llseek(4, 41093120, [41093120], SEEK_SET) = 0
> read(4, ">\270\20XK\177\307\233\334j\315\357ac\235\360\225\276\234"..., 512) = 512
> _llseek(4, 41093632, [41093632], SEEK_SET) = 0
> read(4, "e\262\321\332\273j\242\335\317*\nlb\237T\237\212\236\247"..., 512) = 512
> _llseek(4, 41093120, [41093120], SEEK_SET) = 0
> read(4, ">\270\20XK\177\307\233\334j\315\357ac\235\360\225\276\234"..., 512) = 512
> _llseek(4, 41061888, [41061888], SEEK_SET) = 0
> read(4, "\327\312Z\320s/\201\322\241\274\216\374*\263\1\7\\\220"..., 512) = 512
> _llseek(4, 40963584, [40963584], SEEK_SET) = 0
> read(4, "ODUX\237\253{I\24\216\372\204\213\3525\316\20\341\274\327"..., 512) = 512
> _llseek(4, 40963072, [40963072], SEEK_SET) = 0
> read(4, ":<\217\6\371F\16M\267f\260\265?uH\3656gNJ\v\30\253\350"..., 512) = 512
> _llseek(4, 41085952, [41085952], SEEK_SET) = 0
> read(4, "~\360\373F>\247\346bp\266gA\231\373\24\v0\307\37\222G$"..., 512) = 512
> _llseek(4, 40889856, [40889856], SEEK_SET) = 0
> read(4, "KD\276\330\26\36\266U\373\332\255=\3440\22c\323\276\266"..., 512) = 512
> _llseek(4, 41088512, [41088512], SEEK_SET) = 0
> read(4, "o\331\251yn\365\25669S!} \1\303\334\31\264K\27A)p\341s"..., 512) = 512
> _llseek(4, 41093632, [41093632], SEEK_SET) = 0
> read(4, "e\262\321\332\273j\242\335\317*\nlb\237T\237\212\236\247"..., 512) = 512
> _llseek(4, 0, [0], SEEK_SET)            = 0
> read(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 8192) = 8192
> _llseek(4, 0, [0], SEEK_SET)            = 0
> read(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384) = 16384
> brk(0x8099000)                          = 0x8099000
> brk(0x8089000)                          = 0x8089000
> close(4)                                = 0
> stat64("/sbin/mount.ext3", 0xbf80f484)  = -1 ENOENT (No such file or directory)
> mount("/dev/hda1", "/mnt/foo", "ext3", MS_MGC_VAL, NULL) = -1 EBUSY (Device or resource busy)
> rt_sigprocmask(SIG_UNBLOCK, ~[TRAP SEGV RTMIN RT_1], NULL, 8) = 0
> write(2, "mount: /dev/hda1 already mounted"..., 50mount: /dev/hda1 already mounted or /mnt/foo busy) = 50
> umask(077)                              = 022
> open("/etc/mtab", O_RDONLY|O_LARGEFILE) = 4
> umask(022)                              = 077
> fstat64(4, {st_mode=S_IFREG|0644, st_size=1136, ...}) = 0
> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7d47000
> read(4, "/dev/dm-20 / ext3 rw,errors=remo"..., 1024) = 1024
> read(4, "ib/nfs/rpc_pipefs rpc_pipefs rw "..., 1024) = 112
> read(4, "", 1024)                       = 0
> close(4)                                = 0
> munmap(0xb7d47000, 4096)                = 0
> exit_group(32)                          = ?
> Process 27016 detached
> 
> All other block devices (all LVM LVs) seem to mount with no problems.
> 
> Certainly I leave open the possibility of pilot error (by either me or
> Ubuntu) but I don't know how to even see why/where/what could be going
> wrong.
> 
> /proc/mounts does not show the device mounted:
> 
> $ grep hda /proc/mounts
> $ 
> 
> and fuser and lsof doesn't show anything using the mount point:
> 
> $ fuser /mnt/foo
> $ sudo lsof | grep /mnt/foo
> $ 
> 
> Nor does lsof show /dev/hda (device 3,1) in use:
> 
> $ sudo lsof | grep -e hda -e 3,1
> $ 
> 
> So I'm kind of perplexed as to what to try next in how to debug
> this?
> 
> Any ideas?  Thanx in advance.
> 
> b.
> 

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
