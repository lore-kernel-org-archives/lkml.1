Return-Path: <linux-kernel-owner+w=401wt.eu-S932672AbZKDVWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbZKDVWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:22:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932632AbZKDVWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:22:08 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:53518 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758175AbZKDVWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:22:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rDi9lNqLT/heUDGI4AWam3KV7G0TLvGyrESFkTdmfRffeWOK3Ti6xW1bSH3XK+fic8
         O+y7XMqdhzFme8VLBG18CSPkyFFnFRmnvPdk2b6XX18R+71R4eLYmRu+qcDeJCa0aCB1
         g4hSmqgBqNe5f0SNaec98SbTNw7EjD1Lfq/Ek=
MIME-Version: 1.0
In-Reply-To: <4AF1E66D.6060705@gmail.com>
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com>
	 <20091103222432.4a94bd8f.akpm@linux-foundation.org>
	 <4AF17DED.7080808@gmail.com> <4AF198E1.9010303@gmail.com>
	 <4AF1A198.1090709@gmail.com>
	 <dd18b0c30911040839ice58f81v7c8aa10e79f5d1b8@mail.gmail.com>
	 <4AF1DA8D.9070009@gmail.com> <4AF1E66D.6060705@gmail.com>
Date: Wed, 4 Nov 2009 13:22:11 -0800
Message-ID: <dd18b0c30911041322y2cfd58f8m168550bbe3e8234b@mail.gmail.com>
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
From: Justin Mattock <justinmattock@gmail.com>
To: Dave Korn <dave.korn.cygwin@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gcc@gcc.gnu.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@cs.washington.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

here's what I did:
 valgrind --tool=memcheck --leak-check=full -v make -f client.mk build


e2 -march=core2 -O2 -pipe -fomit-frame-pointer   -DMOZILLA_CLIENT
-include ./js-confdefs.h -Wp,-MD,.deps/jsxml.pp
/home/justin/LFS/firefox/mozilla-1.9.2/js/src/jsxml.cpp
{standard input}: Assembler messages:
{standard input}:271839: Warning: end of file not at end of a line;
newline inserted
{standard input}:271896: Error: suffix or operands invalid for `movq'
{standard input}:271896: Error: open CFI at the end of file; missing
.cfi_endproc directive
c++: Internal error: Killed (program cc1plus)
Please submit a full bug report.
See <http://gcc.gnu.org/bugs.html> for instructions.
make[4]: *** [jsxml.o] Error 1
make[4]: Leaving directory
`/home/name/LFS/firefox/mozilla-1.9.2/obj-x86_64-unknown-linux-gnu/js/src'
make[3]: *** [libs_tier_js] Error 2
make[3]: Leaving directory
`/home/name/LFS/firefox/mozilla-1.9.2/obj-x86_64-unknown-linux-gnu'
make[2]: *** [tier_js] Error 2
make[2]: Leaving directory
`/home/name/LFS/firefox/mozilla-1.9.2/obj-x86_64-unknown-linux-gnu'
make[1]: *** [default] Error 2
make[1]: Leaving directory
`/home/name/LFS/firefox/mozilla-1.9.2/obj-x86_64-unknown-linux-gnu'
make: *** [build] Error 2
==4072==
==4072== HEAP SUMMARY:
==4072==     in use at exit: 201,183 bytes in 4,237 blocks
==4072==   total heap usage: 28,879 allocs, 24,642 frees, 2,947,434
bytes allocated
==4072==
==4072== Searching for pointers to 4,237 not-freed blocks
==4072== Checked 268,808 bytes
==4072==
==4072== 6 bytes in 1 blocks are possibly lost in loss record 41 of 295
==4072==    at 0x4C2488A: malloc (vg_replace_malloc.c:195)
==4072==    by 0x50ABEE1: strdup (in /lib/libc-2.10.90.so)
==4072==    by 0x4118D8: xstrdup (in /usr/bin/make)
==4072==    by 0x41BAA4: define_variable_in_set (in /usr/bin/make)
==4072==    by 0x4160B4: eval (in /usr/bin/make)
==4072==    by 0x416766: eval_makefile (in /usr/bin/make)
==4072==    by 0x416A3F: read_all_makefiles (in /usr/bin/make)
==4072==    by 0x410853: main (in /usr/bin/make)
==4072==
==4072== 14 bytes in 1 blocks are possibly lost in loss record 69 of 295
==4072==    at 0x4C2488A: malloc (vg_replace_malloc.c:195)
==4072==    by 0x411977: xmalloc (in /usr/bin/make)
==4072==    by 0x411AA8: savestring (in /usr/bin/make)
==4072==    by 0x41BB7A: define_variable_in_set (in /usr/bin/make)
==4072==    by 0x410832: main (in /usr/bin/make)
==4072==
==4072== LEAK SUMMARY:
==4072==    definitely lost: 0 bytes in 0 blocks
==4072==    indirectly lost: 0 bytes in 0 blocks
==4072==      possibly lost: 20 bytes in 2 blocks
==4072==    still reachable: 201,163 bytes in 4,235 blocks
==4072==         suppressed: 0 bytes in 0 blocks
==4072== Reachable blocks (those to which a pointer was found) are not shown.
==4072== To see them, rerun with: --leak-check=full --show-reachable=yes
==4072==
==4072== ERROR SUMMARY: 2 errors from 2 contexts (suppressed: 5 from 5)
--4072--
--4072-- used_suppression:      2 dl-hack3-cond-1
--4072-- used_suppression:      3 glibc-2.5.x-on-SUSE-10.2-(PPC)-2a
==4072==
==4072== ERROR SUMMARY: 2 errors from 2 contexts (suppressed: 5 from 5)

I'll try out gdb, and more of valgrind.

-- 
Justin P. Mattock
