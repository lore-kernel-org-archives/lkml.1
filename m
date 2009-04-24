Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbZDXBpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbZDXBpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 21:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZDXBpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 21:45:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54066 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbZDXBpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 21:45:05 -0400
Message-ID: <49F11994.2050403@redhat.com>
Date: Thu, 23 Apr 2009 18:44:52 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: systemtap <systemtap@sourceware.org>
CC: LKML <linux-kernel@vger.kernel.org>, LWN <lwn@lwn.net>
Subject: systemtap release 0.9.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SystemTap team announces release 0.9.7.

  Better uprobes shared library support, kprobes dwarfless probing,
  experimental user space unwinding, better static user space .mark and
  .label -l listings, improved signal handling (to use stap in scripts),
  tcp packet receive tracing, typecasting from headers w/o debuginfo,
  updates for latest kernel

= Where to get it

  http://sourceware.org/systemtap/ - our project page
  http://sourceware.org/systemtap/ftp/releases/systemtap-0.9.7.tar.gz
  http://koji.fedoraproject.org/koji/packageinfo?packageID=615
  git tag release-0.9.7 (commit 9b055ab2)

= How to build it

  See the README and NEWS files at
  http://sourceware.org/git/?p=systemtap.git;a=tree
  Further information at http://sourceware.org/systemtap/wiki/

= SystemTap frontend (stap) changes

- The --skip-badvars option now also suppresses run-time error messages
  that would otherwise result from erroneous memory accesses.  Such
  accesses can originate from $context expressions fueled by erroneous
  debug data, or by kernel_{long,string,...}() tapset calls.

  For a full overview of the stap frontend see man stap(1).

= SystemTap script language changes

- Arrays now support up to 9 index dimensions (up from 5)

- @cast can now determine its type information using an explicit header
  specification.  For example:
    @cast(tv, "timeval", "<sys/time.h>")->tv_sec
    @cast(task, "task_struct", "kernel<linux/sched.h>")->tgid

- New probe primitives 'kprobe.function(FUNCTION)' and
  'kprobe.function(FUNCTION).return' for dwarfless probing. These
  postpone function address resolution to run-time and use the kprobe
  symbol-resolution mechanism. Probing of absolute statements can be
  done using the kprobe.statement(ADDRESS).absolute construct.

= SystemTap tapset changes

- The overlapping process.* tapsets are now separated.  Those probe
  points documented in stapprobes(3stap) remain the same.  Those that
  were formerly in stapprobes.process(3stap) have been renamed to
  kprocess, to reflect their kernel perspective on processes.

- EXPERIMENTAL support for user process unwinding. A new collection of
  tapset functions have been added to handle user space backtraces from
  probe points that support them (currently process and timer probes -
  for timer probes test whether or not in user space first with the
  already existing user_mode() function). The new tapset functions are:
    uaddr - User space address of current running task.
    usymname - Return the symbol of an address in the current task.
    usymdata - Return the symbol and module offset of an address.
    print_ustack - Print out stack for the current task from string.
    print_ubacktrace - Print stack back trace for current task.
    ubacktrace - Hex backtrace of current task stack.
  Please read http://sourceware.org/ml/systemtap/2009-q2/msg00364.html
  on the current restrictions and possible changes in the future and
  give feedback if you want to influence future developments.

- Miscellaneous other tapset changes:
  - ANSI escape sequences tapset.
  - symname, symdata and modname kernel context functions.
  - errno_p() function that will return an absolute errno if valid.
  - New TCP and IP functions, and probe tcp.receive to trace packets.

= New script examples

- network/dropwatch.stp    watch where kernel socket buffers are freed
- network/tcp.stp          a simple tcp tapset example
- network/tcpdumplike.stp  dump of received tcp packets
- process/errsnoop.stp     tabulate system call errors

= Miscellaneous changes

- The source tree now includes a lightweight graphing tool that
  visualizes script data in real time.

= Code contributors for this release

  Ananth N Mavinakayanahalli, Andre Detsch, David Smith, Eugene Teo,
  Eugeniy Meshcheryakov, Frank Ch. Eigler, Jim Keniston, Josh Stone,
  Kent Sebastian, Mark Wielaard, Masami Hiramatsu, Maynard Johnson,
  Prerna Saxena, Rajan Arora, Roland McGrath, Stan Cox, Sunzen Wang,
  Tim Moore, Wenji Huang, William Cohen

  Thanks to David Smith and Mark Wielaard for assembling these notes.

= Examples of tested kernel versions

  2.6.9-70 (el4/i386)
  2.6.18 (el5/ia64/i686/x86_64-xen)
  2.6.27.21 (f10/i686/x86_64)
  2.6.29 (i586/x86_64)
  2.6.30-rc3 (x86)

= Know issues with this release

  Some kernel crashes continue to be reported when a script probes broad
  kernel function wildcards.

  Some 2.6.28- and 2.6.29-era kernels contain bugs that can more easily
  trigger crashes upon systemtap scripts.  Upgrade to the latest -stable
  or -rc if possible.

= Problems resolved for this release

   4105  support up to 9 (up from 5) array index dimensions
   5163  assign need_uprobes during pass-2
   6580  implement symname, symdata and modname context functions
   7072  use _stp_reserve_bytes for printf buffer
   9940  avoid double calling of uprobes in shared libraries
   9953  split up the two process.* tapsets
   9995  test for [installtest_p] && [utrace_p].
   9998  adapt tapset/i686/registers.stp to latest kernel
  10016  purge stap of all pgrp and system() usage
  10019  add --skip-badvars to suppress run-time memory errors too
  10020  sys_sigaltstack param change
  10026  read marker/tracepoint args directly
  10032  trigger cleanup after relay thread errors
  10037  add target_symbol token to $context error messages
  10049  restore better errors for $return
  10055  generate dummy modules w/types for @cast
  10067  fix bitfield access when used with @cast
  10070  don't warn about side-effect-free probes in -t (timing) mode
  10078  uretprobes on functions returning structs/unions

= Test results on various systems

  After running "sudo make installcheck" from the test suite, on a
  suitably equipped machine (kernel debugging data and other stuff
  installed), you should see 800-850 passes and a small handful of
  failures.
