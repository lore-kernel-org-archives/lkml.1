Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbZABIHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbZABIHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 03:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbZABIHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 03:07:46 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:48679
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZABIHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 03:07:45 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Embedded Linux mailing list <linux-embedded@vger.kernel.org>
Subject: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Fri, 2 Jan 2009 02:07:28 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901020207.30359.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before 2.6.25 (specifically git bdc807871d58285737d50dc6163d0feb72cb0dc2 ) 
building a Linux kernel never required perl to be installed on the build 
system.  (Various development and debugging scripts were written in perl and 
python and such, but they weren't involved in actually building a kernel.)  
Building a kernel before 2.6.25 could be done with a minimal system built from 
gcc, binutils, bash, make, busybox, uClibc, and the Linux kernel, and nothing 
else.  (Embedded developers creating clean cross compile environments that 
won't leak bits of the host system into the target, or bootstrapping native 
development environments to run on target hardware or under emulators, tend to 
care about this sort of thing.)

The perl checkin for 2.6.25 was the camel's nose under the tent flap, and 
since then two more instances of perl have shown up in the core kernel build.  
This patch series removes the three required to build a basic kernel for qemu 
for the targets I've tested (arm, mips, powerpc, sparc, m68k, sh4, and of 
course x86 and x86-64), replacing them with shell scripts.

Historically the kernel has gone out of its way to minimize environmental 
dependencies for the build.  For example, the plethora of *_shipped files mean 
we don't need lex and yacc to build the kernel.  The kconfig infrastructure 
once required curses to run "make oldconfig", but that requirement was 
restricted to just menuconfig so the kernel could build on systems without 
ncurses.

That was a very nice policy.  Kernel development already requires an in-depth 
knowledge of C, make, and shell, plus things like the kconfig language.  A 
similarly in-depth knowledge of perl is bigger than all that combined (even 
Larry Wall probably doesn't know all of Perl anymore), and then what's the 
excuse _not_ to add Python to the core build?  And after that why not java, or 
lua?  Where does it end?  What's the criteria to say "no" here?

This patch series saves time and says no now.
