Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab0APAR1 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 19:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537Ab0APAR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 19:17:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab0APARZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 19:17:25 -0500
Message-ID: <4B51058A.9060000@redhat.com>
Date: Fri, 15 Jan 2010 18:17:14 -0600
From: David Smith <dsmith@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: "systemtap@sourceware.org" <systemtap@sourceware.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LWN <lwn@lwn.net>
Subject: SystemTap release 1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SystemTap team announces release 1.1.

  better support for gcc 4.5 richer DWARF debuginfo, new preprocessor
  conditional for kernel 'CONFIG_*' testing, improved (experimental)
  unprivileged user support, new tapsets, better local-vs-global
  variable warnings, better return codes, bug fixes, and more...

= Where to get it

  http://sourceware.org/systemtap/ - our project page
  http://sourceware.org/systemtap/ftp/releases/systemtap-1.1.tar.gz
  http://koji.fedoraproject.org/koji/packageinfo?packageID=615
  git tag release-1.1 (commit FIXME)

= How to build it

  See the README and NEWS files at
  http://sourceware.org/git/?p=systemtap.git;a=tree
  Further information at http://sourceware.org/systemtap/wiki/

= SystemTap frontend (stap) changes

- Systemtap now warns about global variables being referenced from other
  script files.  This aims to protect against unintended local-vs-global
  namespace collisions such as:

     % cat some_tapset.stp
     probe baz.one = bar { foo = $foo; bar = $bar }
     % cat end_user_script.stp
     global foo # intended to be private variable
     probe timer.s(1) { foo ++ }
     probe baz.* { println(foo, pp()) }
     % stap end_user_script.stp
     WARNING: cross-file global variable reference to foo from
some_tapset.stp

- Better support for richer DWARF debuginfo output from GCC 4.5
  (variable tracking assignments). Kernel modules are now always resolved
  against all their dependencies to find any info referring to missing
  symbols. DW_AT_const_value is now supported when no DW_AT_location
  is available.

- Any diagnostic output line that starts with "ERROR", as in
  error("foo"), will promote a "Pass 5: run failed", and the return
  code is 1.

- The loading of signed modules by staprun is no longer allowed for
  ordinary, unprivileged users.  This means that only root, members of
  the group 'stapdev' and members of the group 'stapusr' can load
  systemtap modules using staprun, stap or stap-client.  The minimum
  privilege required to run arbitrary --unprivileged scripts is now
  'stapusr' membership.

- The stap-server initscript is available. This initscript allows you
  to start systemtap compile servers as a system service and to manage
  these servers as a group or individually. The stap-server initscript
  is installed by the systemtap-server rpm.  The build directory for
  the uprobes module (/usr/share/systemtap/runtime/uprobes) is made
  writable by the 'stap-server' group. All of the files generated when
  building the uprobes module, including the digital signature, are
  also writable by members of stap-server.

  See initscript/README.stap-server for details.

- Some of the of the compile server client, server and certificate
  management tools have been moved from $bindir to
  $libexecdir/systemtap.  You should use the new stap-server script or
  the stap-server initscript for server management where possible. The
  stap-server script provides the same functionality as the
  stap-server initscript except that the servers are run by the
  invoking user by default as opposed to servers started by the
  stap-server initscript which are run by the user stap-server by
  default. See stap-server(8) for more information.

  You may continue to use these tools by adding $libexecdir/systemtap
  to your path. You would need to do this, for example, if you are not
  root, you want to start a compile server and you are not running
  systemtap from a private installation. In this case you still need
  to use stap-start-server.

= SystemTap script language changes

- Preprocessor conditional for kernel configuration testing:
  %( CONFIG_foo == "y" %? ... %)

= SystemTap tapset changes

- New tracepoint based tapset for memory subsystem.
- ftrace(msg:string) tapset function to send strings to the system-wide
  ftrace ring-buffer (if any).
- Additional scsi probepoints
- Additional memory probepoints for kernel allocation and freeing.
- Additional ioblock and ioscheduler probepoints.
- Additional scheduler probepoints
- New IRQ and workqueue probepoints.
- New TTY probepoints.
- New task_time tapset to query time usage.
- New proc_mem tapset to query memory usage.

= New script examples

- interrupt/interrupts-by-dev.stp  Tracks interrupts by device
- io/mbrwatch.stp                  Monitors MBR reads/writes
- memory/vm.tracepoints.stp        Tracks memory slab/slub allocations
- network/tcp_trace.stp            Tcp connection tracing utility
- process/plimit.stp               Prints pid resource limits
- profiling/sched_switch.stp       Display scheduler task switches

= Contributors for this release

  Andre Detsch, Anton Vorontsov, Breno Leitao, Charley Wang, Dave
  Brolley, David J. Wilder, David Smith, Don Domingo, Eugene Teo,
  Eugeniy Meshcheryakov, Frank Ch. Eigler, Josh Stone, Kiran Prakesh,
  Mark Wielaard, Masami Hiramatsu, Prerna Saxena, Przemysław
  Pawełczyk, Rajasekhar Duddu, Robb Romans, Roland Grunberg, Roland
  McGrath, Srikar Dronamraju, Stan Cox, Tim Moore, Wenji Huang,
  William Cohen

= Examples of tested kernel versions

  2.6.9 (el4/i686)
  2.6.18 (el5/ia64/i686/x86_64)
  2.6.30.5 (f11/i686/x86_64)
  2.6.31 (f12/i686/x86_64)
  2.6.32.3 (rawhide/x86_64)

= Known issues with this release

- When using the systemtap client and server udp port 5353 must be
  open in your firewall in order for the clent to find servers using
  avahi-browse.

- Some kernel crashes continue to be reported when a script probes
  broad kernel function wildcards.

= Bugs fixed for this release

   4037  make staprun 32/64-bit interoperable
   4425  Support for syscall.sigaction is missing on s390x and ppc64
   4472  sytemtap.syscall failures on ppc64.
   4571  NFS tests missing from test suite
   5150  buildok/nfs-all-probes.stp fails
   5434  Error processing (missing) nfsservctl syscall
   5872  Scsi tapset needs updation for 2.6.25-rc* kernels
   5890  sys.stp fails on 2.6.25 x86_64
   5916  Exploit kretprobe entry_handler + data pouch?
   6762  Some syscalls functions just wrappers for other syscalls
   6979  loc2c code generation error
   6991  accept system call missed on 2.6.27
   9973  module signing for unprivileged users
  10010  support $globals in shared libraries
  10013  Support ENABLED sdt probe macro
  10015  Possible uninitialized variable use in sym.c
  10081  improve build-id mismatch message
  10099  extend printf %M to support hexdumping large buffers
  10231  Systemtap variable references fail on custom ppc64 kernels
  10247  stap-server installation: libexecize everything
  10248  fork stap-server man page into stap-client.1 and stap-server.1
  10276  stap-env does not belong to bindir
  10390  option to print into systemwide ftrace buffer
  10466  stap -L misrepresents variables available to multi-probe aliases
  10481  simplify/robustify module checking logic
  10516  on rawhide, getting a warning about bad percpu allocation
  10561  stap-server: take over signing duties, allow arg passing
  10574  Some functions resolve to pc=0x0
  10575  occasional stapio hangs for -c CMD
  10577  lookup_bad_addr must consider the size of the memory access
  10593  Old gcc fails --with-elfutils configure
  10595  uprobe probes causes selinux failures
  10601  user-space deref/registers in loc2c
  10621  init.d script for systemtap-server
  10622  unsuccessful location searches for extern $variables
  10624  client/server testsuite may be run even if configured out
  10632  Random number generator for .stp
  10644  forward-port staplog
  10650  unprivileged embedded-c functions in tapset
  10653  intermittent itrace crashes
  10658  uprobes uproc->rwsem possible recursive locking detected
  10678  vta-gcc: cannot find module nfs debuginfo
  10700  log() doesn't output newline anymore
  10702  preprocessor directive for kernel CONFIG_foo
  10703  compilation error of ext4 tracepoint on 2.6.32
  10706  line buffering needed in staprun?
  10724  stap should not retry if there is a permissions error
  10726  Getting wrong scope for inlined function
  10732  declaration.exp empty-struct always fails
  10746  utrace-less kernels generate funky errors
  10750  translator permits excessively-vararged call into runtime
  10761  pass staprun/stapio verbosity to final staprun -d
  10799  global vs local variable confusion
  10820  stap -L should take variable location list into account
  10822  procfs file created too late
  10839  KRETACTIVE should have a smaller default value
  10849  make MAXSKIPPED overflow trigger an error message
  10854  Race between script startup and abnormal shutdown
  10866  exit with rc != 0 on script ERRORs
  10869  kretprobes waste a lot of memory on kretprobe_instances
  10877  improve probe point error reporting
  10889  stap --unprivileged not documented
  10923  frame_base given by DW_OP_call_frame_cfa in .debug_frame fail
  10927  do-while statement unimplemented, but documented
  10951  Process probes not in language reference manual
  10974  testsuite/buildok/aux_syscalls-embedded.stp failure
  10976  Untrusted uprobes.ko.sig shouldn't be fatal for the privileged
  10981  buildok/netdev.stp failures on rhel5
  10983  Power tracepoints use the wrong header in 2.6.32-rc7
  10984  restrict unprivileged mode operation to "stapusr" or similar
  11015  Support shared library reloading (in different processes)
  11020  SIGUSR2 file switching doesn't work with busy script
  11034  review context struct allocation mechanism
  11038  Trailing semicolon as null-statement confusing
  11034  review context struct allocation mechanism
  11038  Trailing semicolon as null-statement confusing
  11080  error from stack-ppc.c while building ppc module
  11089  process.mark() probes with same name trigger wrongly
  11090  sdt_misc.exp fails with semantic error: No cfa_ops supplied
  11091  vta-test.exp failure loc2c u_const declaration duplication
  11097  debug memory tracker shows memory overwrite in MAXNESTING
  11112  printf memory dump (%m and %M) doesn't check bounds
  11113  utrace changes in 2.6.32 kernel cause compile errors
  11118  CairoWidget.cxx doesn't compile with gcc 4.4.2 on 32bit
  11140  SystemTap userspace marker in shared libraries cause crash
  11147  server.exp testsuite fails to run
  11148  Loading/unloading several scripts concurrently can cause panic
  11151  Leakage of stap_uprobes slots
  11160  syscall.sigaction32 decoding $act argument incorrectly
  11162  on s390x, the 'syscall.pwrite32' tapset alias fails to compile
  11163  on ppc, 'syscall.readv' and 'syscall.writev' aliases broken
  11167  on ppc, the syscall 32-bit signal test fails

= Test results on various systems

- After running "sudo make installcheck" from the test suite, on a
  suitably equipped machine (kernel debugging data and other stuff
  installed), you should see 1000-1100 passes and a small handful of
  failures.

-- 
David Smith
dsmith@redhat.com
Red Hat
http://www.redhat.com
256.217.0141 (direct)
256.837.0057 (fax)
