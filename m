Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbZC0UQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbZC0UQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757739AbZC0UPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:15:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46979 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200AbZC0UPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:15:47 -0400
Message-ID: <49CD33E8.6060307@redhat.com>
Date: Fri, 27 Mar 2009 13:15:36 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: systemtap <systemtap@sourceware.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: systemtap release 0.9.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SystemTap team proudly announces release 0.9.5.

 Kernel tracepoint support, standard tapset functions and probe now have
 manual pages, typecasting supports module search paths, on-file flight
 recorder support, probe each instruction (block) step of a process,
 syscall wrappers support, security fixes, tested against released
 2.6.29 kernels.

 = Where to get it

   http://sourceware.org/systemtap/ - our project page
   http://sourceware.org/systemtap/ftp/releases/systemtap-0.9.5.tar.gz
   http://koji.fedoraproject.org/koji/packageinfo?packageID=615
   git commit 756c9462

 = How to build it

   See the README and NEWS files at
   http://sourceware.org/git/?p=systemtap.git;a=tree;hb=756c9462
   Further information at http://sourceware.org/systemtap/wiki/

 = Systemtap frontend (stap) changes

 - On-file flight recorder is supported. It allows stap to record huge
   trace log on the disk and to run in background.  Passing -F option
   with -o option runs stap in background mode. In this mode, staprun is
   detached from console, and stap itself shows staprun's pid and exits.
   Specifying the max size and the max number of log files are also
   available by passing -S option. This option has one or two arguments
   seperated by a comma. The first argument is the max size of a log
   file in MB. If the size of a log file exceeds it, stap switches to
   the next log file automatically. The second is how many files are
   kept on the disk. If the number of log files exceeds it, the oldest
   log file is removed automatically. The second argument can be
   omitted.

   For example, this will record output on log files each of them is
   smaller than 1024MB and keep last 3 logs, in background.
     % stap -F -o /tmp/staplog -S 1024,3 script.stp

 - In guru mode (-g), the kernel probing blacklist is disabled, leaving
   only a subset - the kernel's own internal kprobe blacklist - to
   attempt to filter out areas unsafe to probe.  The differences may be
   enough to probe more interrupt handlers.

 - Variables unavailable in current context may be skipped by setting a
   session level flag with command line option --skip-badvars now
   available. This replaces any dwarf $variable expressions that could
   not be resolved with literal numeric zeros, along with a warning
   message.

 - Both kernel markers and kernel tracepoint support argument listing
   through stap -L 'kernel.mark("*")' or stap -L 'kernel.trace("*")'

 - Users can use -DINTERRUPTIBLE=0 to prevent interrupt reentrancy in
   their script, at the cost of a bit more overhead to toggle the
   interrupt mask.

 - Added reentrancy debugging. If stap is run with the arguments
   "-t -DDEBUG_REENTRANCY", additional warnings will be printed for
   every reentrancy event, including the probe points of the resident
   and interloper probes.

   For an overview of the stap frontend see man stap(1).

 = Systemtap script language changes

 - Kernel tracepoints are now supported for probing predefined kernel
   events without any debuginfo.  Tracepoints incur less overhead than
   kprobes, and context parameters are available with full type
   information.  Any kernel 2.6.28 and later should have defined
   tracepoints.  Try the following to see what's available:
    $ stap -L 'kernel.trace("*")'

 - New probes process().insn and process().insn.block that allows
   inspection of the process after each instruction or block of
   instructions executed. So to count the total number of instructions
   a process executes during a run do something like:
    $ stap -e 'global steps; probe process("/bin/ls").insn {steps++}
               probe end {printf("Total instructions: %d\n", steps);}' \
           -c /bin/ls
   This feature can slow down execution of a process somewhat.

 - Typecasting with @cast now supports modules search paths, which is
   useful in case there are multiple places where the type definition
   may be found.  For example:
     @cast(sdev, "scsi_device", "kernel:scsi_mod")->sdev_state

   For an overview of available probes, functions and variables see
   man stapprobes(3stap), man stapfuncs(3stap), man stapvars(3stap)

 = Documentation

 - Systemtap probes and function man pages extracted from the tapsets
   are now available under 3stap. To show the page for the probe
   vm.pagefault or the stap function pexecname do:
     $ man [3stap] vm.pagefault
     $ man [3stap] pexecname

 = Miscellaneous changes

 - Default to --disable-pie for configure. Use --enable-pie to turn it
   back on.

 - Improved sdt.h compatibility and test suite for static dtrace
   compatible user space markers.

 - Some architectures now use syscall wrappers (HAVE_SYSCALL_WRAPPERS).
   The syscall tapset has been enhanced to take care of the syscall
   wrappers in this release.

 - Security fix for CVE-2009-0784: stapusr module-path checking race.

 = Code contributors for this release

   Ananth N Mavinakayanahalli, Breno Leitao, Dan Horak, Dave Brolley,
   David Smith, Don Domingo, Eugeniy Meshcheryakov, Frank Ch. Eigler,
   Josh Stone, Lubomir Rintel, Mahesh J Salgaonkar, Mark Wielaard,
   Masami Hiramatsu, Maynard Johnson, Rajan Arora, Roland McGrath,
   Stan Cox, Tim Moore, Wenji Huang and William Cohen

   Thanks to Mark Wielaard for assembling these notes.

 = Examples of tested kernel versions

   2.6.9-70 (el4/i386)
   2.6.18 (el5/ia64/i686/x86_64-xen)
   2.6.27.19 (f10/i686/x86_64)
   2.6.29 (i586/x86_64)

 = Know issues with this release

   Some kernel crashes continue to be reported when a script probes
   broad kernel function wildcards.

   Some 2.6.28- and 2.6.29-era kernels contain bugs that can more
   easily trigger crashes upon systemtap scripts.  Upgrade to the
   latest -stable or -rc if possible.

 = Problems resolved for this release

    4311 support probing without debuginfo via symbol tables
    4862 -rt kernel compatibility for locks
    4901 tcp_sendmsg arguments changed in 2.6.23-rc2
    5634 support pointer type punning
    5951 process lifetime/memorymap monitor
    6899 offer option to avoid disabling interrupts during more probe...
    6921 tracepoint support
    6930 Flight Recorder on file
    6950 buildok/twentyfive.stp fails with elfutils 0.137
    7045 user-space probe x86 on x86-64 host
    7053 automatic global printing of statistic needs to check @count>0
    7071 optional $context variables
    7092 uprobes probes causing OOM
    9692 stap-{client,server}-connect fail to build on Debian
    9718 utrace - ftrace demo consumer
    9719 improve type mismatch messages
    9770 stap -l 'process("bla").mark("*")' should print marker names
    9788 permissions error in staprun
    9821 Support strftime like format for output file
    9866 save_stack_trace code in runtime stack* needs more than CONF...
    9870 man pages from tapset should not go under /usr/share/man/man5
    9875 building rpm fails in checking for unpackaged file
    9876 Syscall tapset broken on architectures that use SYSCALL_WRAP...
    9882 drop Core from Fedora name
    9883 static markers in userspace libraries segfaults
    9896 Systemtap source compilation failure on latest Ubuntu
    9919 array overflow error points to wrong statement
    9922 need to configure with --disable-pie on ubuntu
    9927 2.6.29-rc7 - kernel crash with sharedbuf.exp stap test script
    9930 produce more information about probe reentrancy
    9932 @cast module search path
    9935 New sdt.exp test fails for mark probes with more than 4 argu...
    9936 server.exp  hangs
    9947 lockdep triggered on rawhide with tracepoints
    9951 runtime error: error: '_v' may be used uninitialized in this...
    9956 sdt.exp doesn't run against gcc 4.1.2 with -O2
    9959 tracepoints should gloss over unrecognized parameter types
    9960 tracepoints should support complex parameters by-value
    9964 Can't find seperate debuginfo file  for user space probing
    9967 raise MAXSKIPPED for -DINTERRUPTIBLE!=0 case
    9974 adapt to utrace renaming of utrace_attached_engine -> utrace...
    9980 sdt.h doesn't compile against gcc 4.3.2 on i386
    9989 utrace or task-finder crash in upstream utrace git tree
    9993 2.6.29-rc8-next-20090323 tracepoint build-breaking changes
   10000 buildok/seventeen.stp fails "integer constant is too large"
   10001 32-bit map error "array subscript is above array bounds"
   10006 CVE-2009-0784: staprun race condition, privilege escalation

 = Test results on various systems

   After running "sudo make installcheck" from the test suite, on a
   suitably equipped machine (kernel debugging data and other stuff
   installed), you should see 500-600 passes and a small handful of
   failures.
