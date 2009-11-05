Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbZKEDgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbZKEDgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 22:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbZKEDgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 22:36:47 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:37365 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbZKEDgq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 22:36:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WSQbgkPcqms9nTas8a4pFaeXJuggcq4rHL5Fv9PZBtKxFYWkb3Pt3wHdaXYLmxXG1D
         4t5AndFYJugnjOr4jqQUfAUEpnhz54LY7/mLwSdQro6aVrjXMdNd9zLV/YeQqBg+NGKg
         Zfe2D5lhfKDjipddatYJ8lzKkNuwz6TddjnYk=
MIME-Version: 1.0
In-Reply-To: <4AF21E0C.90506@gmail.com>
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com>
	 <20091103222432.4a94bd8f.akpm@linux-foundation.org>
	 <4AF17DED.7080808@gmail.com> <4AF198E1.9010303@gmail.com>
	 <4AF1A198.1090709@gmail.com>
	 <dd18b0c30911040839ice58f81v7c8aa10e79f5d1b8@mail.gmail.com>
	 <4AF1DA8D.9070009@gmail.com> <4AF1E66D.6060705@gmail.com>
	 <dd18b0c30911041322y2cfd58f8m168550bbe3e8234b@mail.gmail.com>
	 <4AF21E0C.90506@gmail.com>
Date: Wed, 4 Nov 2009 19:36:51 -0800
Message-ID: <dd18b0c30911041936i7876f2d1o7e31059cc44c644f@mail.gmail.com>
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
From: Justin Mattock <justinmattock@gmail.com>
To: Dave Korn <dave.korn.cygwin@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gcc@gcc.gnu.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@cs.washington.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 4:36 PM, Dave Korn
<dave.korn.cygwin@googlemail.com> wrote:
> Justin Mattock wrote:
>> here's what I did:
>>  valgrind --tool=memcheck --leak-check=full -v make -f client.mk build
>
>> ==4072== LEAK SUMMARY:
>
>> I'll try out gdb, and more of valgrind.
>
>  Yep, that doesn't tell us a lot in its default modes.  I'm not a valgrind
> expert but it looks from the docs like you want to try the Massif tool: it
> looks really thorough.
>
> http://valgrind.org/docs/manual/ms-manual.html
>
>    cheers,
>      DaveK
>
>
>

o.k. round2 I can try gdb(now that I have somewhat of an idea of
how to use one of these tools).

in the meanwhile hopefully this is useful(if not just clip, and I'll try
to gather something useful)


using this for valgrind and the command(below in log)
valgrind -v --tool=memcheck --leak-check=yes --num-callers=10
--leak-check=full --show-reachable=yes --gen-suppressions=yes
(log of valgrind is a bit long, so here's just a few of what
suppresions printed out:)

==1830== Memcheck, a memory error detector
==1830== Copyright (C) 2002-2009, and GNU GPL'd, by Julian Seward et al.
==1830== Using Valgrind-3.5.0 and LibVEX; rerun with -h for copyright info
==1830== Command: c++ -o jsxml.o -c -DOSTYPE="Linux2.6" -DOSARCH=Linux
-DEXPORT_JS_API -DJS_USE_SAFE_ARENA
-I/home/justin/LFS/firefox/mozilla-1.9.2/js/src -I.
-I./../../dist/include -I./../../dist/include/nsprpub
-I/usr/include/nspr -I/home/justin/LFS/firefox/mozilla-1.9.2/js/src
-fPIC -fno-rtti -fno-exceptions -Wall -Wpointer-arith
-Woverloaded-virtual -Wsynth -Wno-ctor-dtor-privacy
-Wno-non-virtual-dtor -Wcast-align -Wno-invalid-offsetof
-Wno-variadic-macros -Wno-long-long -pedantic -fno-strict-aliasing
-pthread -pipe -DNDEBUG -DTRIMMED -m64 -mtune=core2 -march=core2 -O2
-pipe -fomit-frame-pointer -DMOZILLA_CLIENT -include ./js-confdefs.h
-Wp,-MD,.deps/jsxml.pp
/home/justin/LFS/firefox/mozilla-1.9.2/js/src/jsxml.cpp
==1830==
--1830-- Valgrind options:
--1830--    -v
--1830--    --tool=memcheck
--1830--    --leak-check=yes
--1830--    --num-callers=10
--1830--    --leak-check=full
--1830--    --show-reachable=yes
--1830--    --gen-suppressions=yes
--1830-- Contents of /proc/version:
--1830--   Linux version 2.6.32-rc5-00083-g04ea458 (justin@Linux-0)
(gcc version 4.4.1 (GCC for Cross-LFS 4.4.1.20090722) ) #2 SMP Sat Oct
24 21:38:54 PDT 2009
--1830-- Arch and hwcaps: AMD64, amd64-sse3-cx16
--1830-- Page sizes: currently 4096, max supported 4096
--1830-- Valgrind library directory: /usr/lib/valgrind
--1830-- Reading syms from /usr/bin/c++ (0x400000)
--1830-- Reading syms from /lib/ld-2.10.90.so (0x4000000)
--1830-- Reading syms from /usr/lib/valgrind/memcheck-amd64-linux (0x38000000)
--1830--    object doesn't have a dynamic symbol table
--1830-- Reading suppressions file: /usr/lib/valgrind/default.supp
--1830-- REDIR: 0x4016110 (strlen) redirected to 0x38040607
(vgPlain_amd64_linux_REDIR_FOR_strlen)
--1830-- Reading syms from
/usr/lib/valgrind/vgpreload_core-amd64-linux.so (0x4a20000)
--1830-- Reading syms from
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so (0x4c21000)
==1830== WARNING: new redirection conflicts with existing -- ignoring it
--1830--     new: 0x04016110 (strlen              ) R-> 0x04c24fd0 strlen
--1830-- REDIR: 0x4015f30 (index) redirected to 0x4c24d50 (index)
--1830-- REDIR: 0x40160e0 (strcmp) redirected to 0x4c252e0 (strcmp)
--1830-- Reading syms from /lib/libc-2.10.90.so (0x4e28000)
--1830-- REDIR: 0x4ea4c40 (rindex) redirected to 0x4c24bb0 (rindex)
--1830-- REDIR: 0x4e9e010 (malloc) redirected to 0x4c24808 (malloc)
--1830-- REDIR: 0x4ea3330 (strncmp) redirected to 0x4c25210 (strncmp)
--1830-- REDIR: 0x4ea7670 (memcpy) redirected to 0x4c253e0 (memcpy)
--1830-- REDIR: 0x4e9df30 (free) redirected to 0x4c23b44 (free)
--1830-- REDIR: 0x4ea17d0 (strcmp) redirected to 0x4c25280 (strcmp)
--1830-- REDIR: 0x4ea3170 (strlen) redirected to 0x4c24f90 (strlen)
--1830-- REDIR: 0x4ea1750 (index) redirected to 0x4c24c50 (index)
--1830-- REDIR: 0x4ea9da0 (strchrnul) redirected to 0x4c25ff0 (strchrnul)
--1830-- REDIR: 0x4ea6d30 (mempcpy) redirected to 0x4c260e0 (mempcpy)
--1830-- REDIR: 0x4ea5bc0 (memchr) redirected to 0x4c253a0 (memchr)
--1830-- REDIR: 0x4e9f060 (realloc) redirected to 0x4c248b9 (realloc)
--1830-- REDIR: 0x4ea31c0 (strnlen) redirected to 0x4c24f60 (strnlen)
--1830-- REDIR: 0x4ea7360 (stpcpy) redirected to 0x4c25c10 (stpcpy)
--1830-- REDIR: 0x4ea2c20 (strcpy) redirected to 0x4c24ff0 (strcpy)
--1830-- REDIR: 0x4ea9d50 (rawmemchr) redirected to 0x4c26020 (rawmemchr)
--1830-- REDIR: 0x4e9d5d0 (calloc) redirected to 0x4c2322c (calloc)
--1830-- REDIR: 0x4ea4b80 (strncpy) redirected to 0x4c250c0 (strncpy)
--1830-- REDIR: 0x4ea1590 (strcat) redirected to 0x4c24d90 (strcat)
--1830-- REDIR: 0x4e5bf40 (putenv) redirected to 0x4c263d0 (putenv)
{standard input}: Assembler messages:
{standard input}:271839: Warning: end of file not at end of a line;
newline inserted
{standard input}:271896: Error: suffix or operands invalid for `movq'
{standard input}:271896: Error: open CFI at the end of file; missing
.cfi_endproc directive
c++: Internal error: Killed (program cc1plus)
Please submit a full bug report.
See <http://gcc.gnu.org/bugs.html> for instructions.
==1830==
==1830== HEAP SUMMARY:
==1830==     in use at exit: 25,444 bytes in 75 blocks
==1830==   total heap usage: 212 allocs, 137 frees, 36,791 bytes allocated
==1830==
==1830== Searching for pointers to 75 not-freed blocks
==1830== Checked 74,760 bytes
==1830==
==1830== 1 bytes in 1 blocks are still reachable in loss record 1 of 59
==1830==    at 0x4C232DA: calloc (vg_replace_malloc.c:418)
==1830==    by 0x41BE49: xcalloc (xmalloc.c:162)
==1830==    by 0x40F5D6: main (gcc.c:7270)
==1830==
==1830==
==1830== ---- Print suppression ? --- [Return/N/n/Y/y/C/c] ---- y
{
   <insert_a_suppression_name_here>
   Memcheck:Leak
   fun:calloc
   fun:xcalloc
   fun:main
}
==1830== 4 bytes in 1 blocks are still reachable in loss record 2 of 59
==1830==    at 0x4C2488A: malloc (vg_replace_malloc.c:195)
==1830==    by 0x41BDF7: xmalloc (xmalloc.c:147)
==1830==    by 0x402255: save_string (gcc.c:7660)
==1830==    by 0x4034ED: add_preprocessor_option (gcc.c:3447)
==1830==    by 0x408A06: process_command (gcc.c:3943)
==1830==    by 0x40DE6F: main (gcc.c:6871)
==1830==
==1830==
==1830== ---- Print suppression ? --- [Return/N/n/Y/y/C/c] ---- y
{
   <insert_a_suppression_name_here>
   Memcheck:Leak
   fun:malloc
   fun:xmalloc
   fun:save_string
   fun:add_preprocessor_option
   fun:process_command
   fun:main
}
==1830== 6 bytes in 1 blocks are still reachable in loss record 3 of 59
==1830==    at 0x4C2488A: malloc (vg_replace_malloc.c:195)
==1830==    by 0x41BDF7: xmalloc (xmalloc.c:147)
==1830==    by 0x41BF11: xstrdup (xstrdup.c:34)
==1830==    by 0x411F75: update_path (prefix.c:273)
==1830==    by 0x403631: add_prefix (gcc.c:2871)
==1830==    by 0x40E1CF: main (gcc.c:7043)
==1830==
==1830==
==1830== ---- Print suppression ? --- [Return/N/n/Y/y/C/c] ---- y
{
   <insert_a_suppression_name_here>
   Memcheck:Leak
   fun:malloc
   fun:xmalloc
   fun:xstrdup
   fun:update_path
   fun:add_prefix
   fun:main
}
==1830== 7 bytes in 1 blocks are still reachable in loss record 4 of 59
==1830==    at 0x4C2488A: malloc (vg_replace_malloc.c:195)
==1830==    by 0x41BDF7: xmalloc (xmalloc.c:147)
==1830==    by 0x40E64E: main (gcc.c:8236)
==1830==
==1830==
==1830== ---- Print suppression ? --- [Return/N/n/Y/y/C/c] ---- y
{
   <insert_a_suppression_name_here>
   Memcheck:Leak
   fun:malloc
   fun:xmalloc
   fun:main
}


all I have to do is go into the directory
obj-x86_64-unknown-linux-gnu/js/src/
of mozillas source tree and use valgrind c++ ***
(I'll see what gdb does)

-- 
Justin P. Mattock
