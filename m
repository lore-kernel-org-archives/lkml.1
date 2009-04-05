Return-Path: <linux-kernel-owner+w=401wt.eu-S1757745AbZDEHD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbZDEHD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 03:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757074AbZDEHDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 03:03:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:62464 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062AbZDEHDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 03:03:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OwYKELpAr9zvM6++asiZnLP3yiwaBdjXU9oA9c93A3wePVak3qVRbGMpWnhPlV5yrI
         +JMtDrEAvpCe9Y2YbwdmpGsCQXCRBjsg8j1j0yIL6zyJW9ThULFl4n3x/myRKnsNdvoX
         Huf1FVD6RYvtCzCw0PEbAfkk5ld6xhJsDKZK8=
MIME-Version: 1.0
In-Reply-To: <9b1675090904011730t38f637b3n55a3a44aeb0b07e@mail.gmail.com>
References: <9b1675090903291904g7eca965eydb1aa3f852a1b91c@mail.gmail.com>
	 <200903301357.17076.alistair@devzero.co.uk>
	 <9b1675090903300826s2ce361e5s1134e13507b0399@mail.gmail.com>
	 <200903301944.30030.alistair@devzero.co.uk>
	 <9b1675090903302211q5703af7fo33f45c93e5db34f0@mail.gmail.com>
	 <9b1675090903312219q5f6df0cbwef86cbdafe035667@mail.gmail.com>
	 <9b1675090904011730t38f637b3n55a3a44aeb0b07e@mail.gmail.com>
Date: Sun, 5 Apr 2009 01:03:47 -0600
Message-ID: <9b1675090904050003v278f8020uc10cc504e4a96aff@mail.gmail.com>
Subject: Re: 2.6.29 on MacBook 2,1 fails to reboot
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: "Morten P.D. Stevens" <mstevens@win-professional.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have more information on this.  I put an strace in the shutdown
script for alsa sound...

strace -T -f -o /root/${1}-strace.txt rmmod --wait "$1"

${1} is the module name...

Oops, I just noticed that it finally quit.  Some of the modules were
unloaded successfully, others, after several minutes, got an error.  I
have the strace for all of them if you want it.  But, here's an
example.  Note the end where it says "resource temporarily
unavailable".  I also give a second strace snippet after this one...

snd_hda_codec-strace.txt
12181 execve("/sbin/rmmod", ["rmmod", "--wait", "snd_hda_codec"], [/*
13 vars */]) = 0 <0.000079>
12181 brk(0)                            = 0x604000 <0.000007>
12181 mmap(NULL, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f224f8c2000 <0.000008>
12181 mmap(NULL, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f224f8c1000 <0.000007>
12181 access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or
directory) <0.000010>
12181 open("/etc/ld.so.cache", O_RDONLY) = 3 <0.000009>
12181 fstat(3, {st_mode=S_IFREG|0644, st_size=214104, ...}) = 0 <0.000007>
12181 mmap(NULL, 214104, PROT_READ, MAP_PRIVATE, 3, 0) =
0x7f224f88c000 <0.000008>
12181 close(3)                          = 0 <0.000007>
12181 open("/lib/libz.so.1", O_RDONLY)  = 3 <0.000011>
12181 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340\37\0\0\0\0\0\0@"...,
832) = 832 <0.000007>
12181 fstat(3, {st_mode=S_IFREG|0755, st_size=84272, ...}) = 0 <0.000006>
12181 mmap(NULL, 2179560, PROT_READ|PROT_EXEC,
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f224f494000 <0.000009>
12181 mprotect(0x7f224f4a8000, 2093056, PROT_NONE) = 0 <0.000009>
12181 mmap(0x7f224f6a7000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x13000) = 0x7f224f6a7000
<0.000010>
12181 close(3)                          = 0 <0.000006>
12181 open("/lib/libc.so.6", O_RDONLY)  = 3 <0.000011>
12181 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\300\345\1\0\0\0\0\0@"...,
832) = 832 <0.000007>
12181 fstat(3, {st_mode=S_IFREG|0755, st_size=1330352, ...}) = 0 <0.000006>
12181 mmap(NULL, 3437208, PROT_READ|PROT_EXEC,
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f224f14c000 <0.000009>
12181 mprotect(0x7f224f28b000, 2093056, PROT_NONE) = 0 <0.000009>
12181 mmap(0x7f224f48a000, 20480, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x13e000) = 0x7f224f48a000
<0.000010>
12181 mmap(0x7f224f48f000, 17048, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f224f48f000
<0.000009>
12181 close(3)                          = 0 <0.000009>
12181 mmap(NULL, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f224f88b000 <0.000008>
12181 mmap(NULL, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f224f88a000 <0.000007>
12181 arch_prctl(ARCH_SET_FS, 0x7f224f88a6f0) = 0 <0.000007>
12181 mprotect(0x7f224f48a000, 16384, PROT_READ) = 0 <0.000009>
12181 mprotect(0x7f224f6a7000, 4096, PROT_READ) = 0 <0.000008>
12181 mprotect(0x602000, 4096, PROT_READ) = 0 <0.000009>
12181 mprotect(0x7f224f8c3000, 4096, PROT_READ) = 0 <0.000008>
12181 munmap(0x7f224f88c000, 214104)    = 0 <0.000012>
12181 create_module(NULL, 0)            = -1 ENOSYS (Function not
implemented) <0.000006>
12181 delete_module("snd_hda_codec", O_RDONLY|O_EXCL) = -1 EAGAIN
(Resource temporarily unavailable) <0.000011>
12181 brk(0)                            = 0x604000 <0.000007>
12181 brk(0x625000)                     = 0x625000 <0.000008>
12181 write(2, "ERROR: Removing 'snd_hda_codec': "..., 66) = 66 <0.000016>
12181 exit_group(1)                     = ?


Note the one below has a different error...
snd_hda_codec_idt-strace.txt
12174 create_module(NULL, 0)            = -1 ENOSYS (Function not
implemented) <0.000006>
12174 delete_module("snd_hda_codec_idt", O_RDONLY|O_EXCL) = -1 EBUSY
(Device or resource busy) <0.000009>
12174 brk(0)                            = 0x604000 <0.000007>
12174 brk(0x625000)                     = 0x625000 <0.000008>
12174 write(2, "ERROR: Removing 'snd_hda_codec_id"..., 61) = 61 <0.000018>
12174 exit_group(1)                     = ?


On Wed, Apr 1, 2009 at 6:30 PM, Trenton D. Adams
<trenton.d.adams@gmail.com> wrote:
> Morton, did you see this one fly by?
>
