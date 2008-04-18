Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbYDRQk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbYDRQk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 12:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbYDRQkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 12:40:15 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:49028 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbYDRQkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 12:40:14 -0400
Date: Fri, 18 Apr 2008 12:39:48 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Recompiling 2.6.25 fails several ways.
To: linux-kernel@vger.kernel.org
Message-id: <200804181239.48277.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;  New thread.

First, my makeit script bails out at the make clean stage:

xargs: xargs.c:445: main: Assertion `bc_ctl.arg_max <= (131072-2048)' failed.
/bin/sh: line 4:  2161 Broken pipe             find . \( -name SCCS -o -name BitKeeper -o -name .svn -o -name 
CVS -o -name .pc -o -name .hg -o -name .git \) -prune -o \( -name '*.
[oas]' -o -name '*.ko' -o -name '.*.cmd' -o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' -o -name '*.symtypes' -o -name 'modules.order' 
\) -type f -print
      2162 Aborted                 | xargs rm -f
make: *** [clean] Error 134

So, I comment that, and get this:
  DEPMOD  2.6.25
now making a new initrd.2.6.25.img
nash received SIGSEGV!  Backtrace (11):
/sbin/nash[0x805314a]
[0xffffe40c]
/lib/libglib-2.0.so.0[0x455efba1]
/usr/lib/libbdevid.so.6.0.19(bdevid_module_unload_all+0x31)[0x451e4e37]
/usr/lib/libbdevid.so.6.0.19(bdevid_destroy+0x2d)[0x451e457c]
/usr/lib/libnash.so.6.0.19[0x452a2174]
/usr/lib/libnash.so.6.0.19(nash_vitals_destroy_probes+0x3f)[0x452a27ec]
/usr/lib/libnash.so.6.0.19(_nashFreeContext+0x1c)[0x45292fc6]
/sbin/nash[0x80536e4]
/lib/libc.so.6(__libc_start_main+0xe6)[0x450505d6]
/sbin/nash[0x804ae61]

I can suggest only one thing, that the rawhide glib is not usable
on an otherwise up to date F8 system.

I had installed the yum and yumex from rawhide because it has a 're-install' 
option now, and I need that to fully recover from a disk failure.

That pulled in the rawhide stuff, from logwatch:
Packages Installed:
    pygpgme.i386 0.1-8.fc9
 
 Packages Updated:
    yum-updatesd.noarch 1:0.9-1.fc9
    yumex.noarch 2.0.4-1.fc9
    glib2.i386 2.16.3-3.fc9
    yum.noarch 3.2.14-10.fc9
    glib2-devel.i386 2.16.3-3.fc9
    yum-metadata-parser.i386 1.1.2-8.fc9
    glibc.i686 2.8-1
    glibc-headers.i386 2.8-1
    glibc-devel.i386 2.8-1
    yum-utils.noarch 1.1.13-2.fc9
    glibc-common.i386 2.8-1

Have I hosed the build system here?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Punishment becomes ineffective after a certain point.  Men become insensitive.
		-- Eneg, "Patterns of Force", stardate 2534.7
