Return-Path: <linux-kernel-owner+w=401wt.eu-S1761073AbZFLBDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761073AbZFLBDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 21:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbZFLBDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 21:03:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42481 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbZFLBDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 21:03:10 -0400
Message-ID: <4A31A945.7010705@redhat.com>
Date: Thu, 11 Jun 2009 18:03:01 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b5pre) Gecko/20090513 Fedora/3.0-2.4.b3pre.hg.6a6386c16e98.fc11 Lightning/1.0pre Thunderbird/3.0b3pre
MIME-Version: 1.0
To: SystemTap <systemtap@sourceware.org>
CC: LKML <linux-kernel@vger.kernel.org>, LWN <lwn@lwn.net>
Subject: SystemTap release 0.9.8
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SystemTap team proudly announces release 0.9.8.

  Module signing, debuginfo package suggestions, system call dwarfless
  probing, new tapset functions, support for 2.6.30 kernels, and many
  bug fixes and miscellaneous speed improvements.

= Where to get it

  http://sourceware.org/systemtap/ - our project page
  http://sourceware.org/systemtap/ftp/releases/systemtap-0.9.8.tar.gz
  http://koji.fedoraproject.org/koji/packageinfo?packageID=615
  git tag release-0.9.8 (commit e1774a7f)

= How to build it

  See the README and NEWS files at
  http://sourceware.org/git/?p=systemtap.git;a=tree
  Further information at http://sourceware.org/systemtap/wiki/

= SystemTap frontend (stap) changes

- Module signing: If the appropriate nss libraries are available on your
  system, stap will sign each compiled module using a self-generated
  certificate.  This is the first step toward extending authority to
  load certain modules to unprivileged users. For now, if the system
  administrator adds a certificate to a database of trusted signers
  (stap-authorize-signing-cert), modules signed using that certificate
  will be verified by staprun against tampering.  Otherwise, you should
  notice no difference in the operation of stap or staprun.

- Debuginfo suggestions: If a script fails in some way due to missing
  debugging information, stap will try to query rpm for which package
  supplied that binary and suggest the matching debuginfo packages to
  install.

= SystemTap script language changes

- Using %M in print formats for hex dumps can now print entire buffers,
  instead of just small numbers.

= SystemTap tapset changes

- Dwarfless syscalls: The nd_syscalls tapset is now available to probe
  system calls without requiring kernel debugging information.  All of
  the same probepoints in the normal syscalls tapset are available with
  an "nd_" prefix, e.g. syscall.open becomes nd_syscall.open.  Most
  syscall arguments are also available by name in nd_syscalls.

- Miscellaneous new functions:
  - sid() returns the session ID of the current process
  - stringat() indexes a single character from a string.

= New script examples

- io/ttyspy.stp           Monitor tty typing
- process/schedtimes.stp  Track time processes spend in various states

= Code contributors for this release

  Ananth N Mavinakayanahalli, Dave Brolley, David Smith, Don Domingo,
  Elliott Baron, Eugeniy Meshcheryakov, Frank Ch. Eigler, Jim Keniston,
  JoeLynn Keniston, Josh Stone, Kai Meyer, Keiichi KII, Kent Sebastian,
  Malte Nuhn, Mark Wielaard, Masami Hiramatsu, Petr Muller, Przemyslaw
  Pawelczyk, Stan Cox, Sunzen Wang, Wenji Huang, William Cohen

= Examples of tested kernel versions

  2.6.9 (el4/i386)
  2.6.18 (el5/ia64/i686/x86_64-xen)
  2.6.27.21 (f10/i686/x86_64)
  2.6.29.4 (f11/i586/x86_64)
  2.6.30 (i686/x86_64)

= Known issues with this release

  Some kernel crashes continue to be reported when a script probes broad
  kernel function wildcards.

= Bugs fixed for this release

   3347 undesirable embedded-C functions at top level
   5630 support for single-stepping in user-space
   5635 unwind-data-based backtracing for userspace
   6930 Flight Recorder on file
   6933 Individual kprobes enable/disable support
   9997 provide run-time advice on how to install needed debuginfo
  10007 Some SystemTap tests need updates to handle SYSCALL_WRAPPERS
  10082 add environment variable to pass -r RELEASE/PATH option
  10091 Backward compatibility for insn probe point (itrace) on o...
  10102 optional probe points should silently accept "probe point...
  10117 on ppc64, tapset/context.stp is broken on older kernels
  10130 Argument to mktemp should have at least 6 X's
  10139 .probes section disappears into debuginfo
  10172 sdt.h on powerpc Error: junk at end of line: `0'
  10177 _stp_kill_time on RT-kernel hits BUG
  10182 systemtap.spec should clean up old leftover runtime/uprobes/
  10185 stap uprobe script on rawhide causes system crash
  10190 Suppress registration warnings for optional probes
  10206 symname() resolves incorrect symbols on ppc
  10209 extend configury for --disable-translator
  10232 backtrace through kretprobes via fallback unwinder
  10260 Crash due to stale timer callbacks

= Test results on various systems

  After running "sudo make installcheck" from the test suite, on a
  suitably equipped machine (kernel debugging data and other stuff
  installed), you should see 800-850 passes and a small handful of
  failures.
