Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZBSSzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZBSSzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZBSSzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:55:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49860 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174AbZBSSzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:55:04 -0500
To: systemtap@sources.redhat.com
cc: linux-kernel@vger.kernel.org
Subject: systemtap release 0.9
From: fche@redhat.com (Frank Ch. Eigler)
References: <1233759677.2243.111.camel@fedora.wildebeest.org>
Date: Thu, 19 Feb 2009 13:55:01 -0500
In-Reply-To: <1233759677.2243.111.camel@fedora.wildebeest.org> (Mark Wielaard's message of "Wed, 04 Feb 2009 16:01:17 +0100")
Message-ID: <y0my6w2qmt6.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The systemtap team announces release 0.9.

 = Where to get it

   http://sourceware.org/systemtap/ - our project page   
   http://sourceware.org/systemtap/ftp/releases/systemtap-0.9.tar.gz
   git commit 49e34da0
   http://koji.fedoraproject.org/koji/packageinfo?packageID=615

 = How to build it

   See the README and NEWS files at 
   http://sourceware.org/git/?p=systemtap.git;a=tree;hb=49e34da0
   Further information at http://sourceware.org/systemtap/wiki/

 = Systemtap frontend (stap) changes

   The stap "-r /DIR" option may be used to identify a hand-made kernel
   build directory.  The tool determines the appropriate release string
   automatically from the directory.

   For scripts that sometimes terminate with excessive "skipped" probes,
   rerunning the script with "-t" (timing) will print more details about
   the skippage reasons.

   Per-pass verbosity control is available with the new "--vp {N}+"
   option.  "stap --vp 040" adds 4 units of -v verbosity only to pass
   2.  This is useful for diagnosing errors from one pass without
   excessive verbosity from others.

   For those that really want to run stap from the build tree there is
   now the 'run-stap' script in the top-level build directory that sets
   up the SYSTEMTAP_TAPSET, SYSTEMTAP_RUNTIME, SYSTEMTAP_STAPRUN, and
   SYSTEMTAP_STAPIO environment variables (installing systemtap, in a
   local prefix, is still recommended for common use).

   For a full overview of the stap frontend see man stap(1).

 = Systemtap script language changes

   Typecasting is now supported using the @cast operator.  A script can
   define a pointer type for a "long" value, and then access type members
   using the same syntax as with $target variables.  For example, this will
   retrieve the parent pid from a kernel task_struct:
     @cast(pointer, "task_struct", "kernel")->parent->pid

   function("func").label("label") probes are now supported to direct
   a probe at a label (such as the typical "out" goto-exit points)
   within a function.

   Serious problems associated with user-space probing in shared
   libraries were corrected, making it now possible to experiment
   with probe shared libraries.  Assuming dwarf debugging information
   is installed, use this twist on the normal syntax:

     probe process("/lib64/libc-2.8.so").function("....") { ... }

   This would probe all threads that call into that library.  Running
   "stap -c CMD" or "stap -x PID" naturally restricts this to the target
   command+descendants only.  $$vars etc. may be used.

   process().mark() probes are now possible to trace static user space
   markers put in programs with the STAP_PROBE macro using the new
   sys/sdt.h include file. This also provides dtrace compatible markers
   through DTRACE_PROBE and an associated python 'dtrace' script that
   can be used in builds based on dtrace that need dtrace -h or -G
   functionality.

   For a full overview of all probes see man stapprobes(5).

 = Systemtap client and compile server

   The systemtap client and compile server are now available.
   These allow you to compile a systemtap module on a host other than
   the one which it will be run, providing the client and server
   are compatible. Other than using a server for passes 1 through
   4, the client behaves like the 'stap' front end itself. This
   means, among other things, that the client will automatically
   load the resulting module on the local host unless -p[1234]
   was specified.  See stap-server(8) for more details.
   The client/server now use SSL for network connection security and
   for signing.

   The systemtap client and server are prototypes only. Interfaces,
   options and usage may change at any time.

 = Documentation

   SystemTap Tapset Reference Manual

   Standard tapsets included with Systemtap were modified to include
   extractable documentation information based on the kernel-doc
   infrastructure. When configured --enable-docs a HTML and PDF
   version of the Tapset Reference Manual is produced explaining probes
   defined in each tapset.

   SystemTap Beginners Guide

   Systemtap now comes with a new Beginners Guide that walks the user
   through their first steps setting up stap, understanding how it all
   works, introduces some useful scripts and describes some common
   pitfalls.  It isn't created by default since it needs a Publican
   setup, but full build instructions can be found in the wiki:
   http://sourceware.org/systemtap/wiki/PublicanQuikHowto
   An online version can be found at:
   http://sourceware.org/systemtap/SystemTap_Beginners_Guide.pdf

 = Miscellaneous changes

   Systemtap initscript is available. This initscript allows you to run
   systemtap scripts as system services (in flight recorder mode) and
   control those scripts individually.
   See README.initscript for details.

   Symbol tables and unwind (backtracing) data support were formerly
   compiled in for all probed modules as identified by the script
   (kernel; module("name"); process("file")) plus those listed by the
   stap "-d BINARY" option.  Now, this data is included only if the
   systemtap script uses tapset functions like probefunc() or
   backtrace() that require such information.  This shrinks the probe
   modules considerably for the rest.

   Most probe handlers now run with interrupts enabled, for improved
   system responsiveness and less probing overhead.  This may result in
   more skipped probes, for example if a reentrant probe handler is
   attempted from within an interrupt handler.  It may also make the
   systemtap overload detection facility more likely to be triggered,
   as interrupt handlers' run time would be included in the
   self-assessed overhead of running probe handlers.

 = Code contributors for this release

   Ananth N Mavinakayanahalli, Dave Brolley, David Smith, Don Domingo,
   Elliott Baron, Eugeniy Meshcheryakov, Frank Ch. Eigler, Jim
   Keniston, Josh Stone, Kent Sebastian, K Prasad, Mark Wielaard,
   Masami Hiramatsu, Rajan Arora, Roland McGrath, Srikar Dronamraju,
   Stan Cox, Tim Moore, Wenji Huang, William Cohen

   Thanks to Mark Wielaard for assembling these notes.

 = Examples of tested kernel versions

   2.6.9-70 (el4/i386)
   2.6.18-128 (el5/xen/i386/x86_64)
   2.6.27.12 (f10/i386/x86_64)
   2.6.29-rc5 (x86_64)
   2.6.29-rc5-next (x86_64)
   
 = Know issues with this release

   Some kernel crashes continue to be reported when a script probes
   broad kernel function wildcards.

   Some 2.6.28- and 2.6.29-era kernels contain bugs that can more
   easily trigger crashes upon systemtap scripts.  Upgrade to the
   latest -stable or -rc if possible.

 = Problems resolved for this release

   1166    implement .label("foo")
   1918    investigate user-level static instrumentation
   3668    Add hex dump function for arbitrary buffers
   4783    staprun should not self-renice
   4930    Add "examples" tests to test suite
   5376    Stap does not check incorrect probe point syntax
   5689    extend stap -t mode to track causes of skipped probes
   5892    support stap against plain KERNEL-BUILD-TREE
   5947    make systemtap 0.6.2/0.131 work on F8 2.6.21.7-2.fc8xen
   6477    without debuginfo, compiling a process probe script fails...
   6829    uprobe on cloney shell hangs
   6879    does not currently support probing instruction first byte...
   6881    problems with stap-server.8 manpage
   6925    make roland happy
   6936    Systemtap as a Service (/etc/init.d/systemtap) support
   6965    compile symbol-table in conditionally
   7000    printf %n specifier causes segfault
   7016    Systemtap will causes OOM when specifying large relay buf...
   7033    Optimize locking reginon of global variables
   7035    -L mode should not suppress all errors
   7039    syscall tapset cannot differentiate between fork and clon...
   7046    deadlock on shared library uprobes
   7051    remove broken printf %n directive support
   7062    uprobes loading does not respect SYSTEMTAP_RUNTIME enviro...
   7063    do not hard-wire locations of staprun, stapio
   7086    stap-start-server fails if nc is not available.
   7087    stap-start-server fails if nc utility is not available
   7090    support hand-built kernels built with O=<dir> option
   7096    Probe definitions over kernel markers isn't recognised
   9673    uprobes: use fewer task-finders
   9693    missing shebangs in example scripts
   9702    stap-gen-server-cert doesn't work on Debian
   9709    xmlto doesn't work on all distributions
   9716    latest systemtap ./configure build fails with pkgconfig-0.21
   9740    syscall.* probe causes kernel panic(double fault) on rawh...
   9756    incorrect footer in tapset reference manpages
   9757    compile server fails to start first time if client is not...
   9767    static probes only work with -c executable (and no argume...
   9768    cannot read userspace shared library vars
   9787    permissions error in staprun
   9792    probefunc() returns absolute address instead of the funct...
   9801    ftrace ring-buffer backend for runtime
   9810    ia64 REG_IP() cannot be used as a lvalue
   9816    functioncallcount.stp causes system crash
   9849    dtrace: Unsafe temporary file handling
   9850    dtrace: Incorrect shell execution
   9851    dtrace: Incorrect file extension replacement
   9716    latest systemtap ./configure build fails with pkgconfig-0...
   9860    _stp_stack_print_fallback prototype/function declaration ...

 = Test results on various systems

   After running "sudo make installcheck" from the test suite, on a
   suitably equipped machine (kernel debugging data and other stuff
   installed), you should see 500-600 passes and a small handful of
   failures.
