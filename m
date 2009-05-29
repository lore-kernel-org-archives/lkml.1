Return-Path: <linux-kernel-owner+w=401wt.eu-S1762029AbZE2QGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762029AbZE2QGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 12:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760341AbZE2QFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 12:05:53 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:45524 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760223AbZE2QFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 12:05:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=cwAHubRt9kl0XYQklWSc2PcOujGk/5JuzTqmlvACrgbSS5ECUSmFkPJ0cfah4PpeoG
         za2dTXVMk9dVxgOoDOqP5b7gRCAOtAsV+jwfDsnwABW/a0ujR6KTgqrpApn2gLrFJvpy
         9hj5hb2peZIR1tGHDGxshx1ZNaz/yaKtYPdkQ=
Subject: [RFC V2 PATCH]debugfs:Fix terminology inconsistency of dir name to
	mount debugfs filesystem.
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Steven Rostedt <rostedt@goodmis.org>, Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org,
       balagi@justmail.de, bgamari@gmail.com, Ingo Molnar <mingo@elte.hu>,
       inaky.perez-gonzalez@intel.com
In-Reply-To: <1243315163.14685.17.camel@centos51>
References: <1243315163.14685.17.camel@centos51>
Content-Type: text/plain
Organization: Private
Date: Sat, 30 May 2009 01:05:34 +0900
Message-Id: <1243613134.20635.14.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dear Greg and Steen,

Thanks your advices and opinions about a confusion according to  
too many mount directory names for debugfs. I made rfc v2 patch file again like belows.
Can I hear your advices about below patch contents?.  

* ref: 
http://groups.google.com/group/linux.kernel/browse_thread/thread/c34e386587979340/dc52317f888e78b6?#dc52317f888e78b6


Regards,
GeunSik Lim.

Subject: [PATCH]   Fix terminology inconsistency of dir name to mount debugfs filesystem.

      Many developers use "/debug/" or "/debugfs/ directory name to mount
      debugfs filesystem for ftrace according to
      ./Documentation/tracers/ftrace.txt file.

      And, three directory names(ex:/debug/, /debugfs/, /sys/kernel/debug/) is
      existed in kernel source like ftrace, DRM, Wireless, Network[sky2]files
      to mount debugfs filesystem.

      debugfs means debug filesystem for debugging easy to use by greg kroah
      hartman. "/sys/kernel/debug/" name is suitable as directory name
      of debugfs filesystem.
      -debugfs related reference: http://lwn.net/Articles/115405/

      Fix inconsistency of directory name to mount debugfs filesystem.

         Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
         Acked-By: Inaky Perez-Gonzalez <inaky@linux.intel.com>
         CC: Greg KH <greg@kroah.com>
         CC: Steven Rostedt <rostedt@goodmis.org>
         CC: linux-kernel <linux-kernel@vger.kernel.org>
---
 Documentation/DocBook/debugobjects.tmpl           |    2 +-
 Documentation/cdrom/packet-writing.txt            |    2 +-
 Documentation/fault-injection/fault-injection.txt |   70 +++++-----
 Documentation/kprobes.txt                         |    6 +-
 Documentation/trace/ftrace.txt                    |  166 ++++++++++----------
 Documentation/trace/mmiotrace.txt                 |   26 ++--
 drivers/block/pktcdvd.c                           |    2 +-
 drivers/gpu/drm/drm_debugfs.c                     |   12 +-
 drivers/gpu/drm/drm_drv.c                         |    2 +-
 drivers/gpu/drm/drm_stub.c                        |    2 +-
 drivers/net/Kconfig                               |    4 +-
 drivers/net/wimax/i2400m/i2400m.h                 |    2 +-
 drivers/net/wireless/ath5k/Kconfig                |    6 +-
 drivers/net/wireless/libertas/README              |   12 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                  |    4 +-
 include/linux/kernel.h                            |    2 +-
 include/linux/tracepoint.h                        |    4 +-
 kernel/trace/Kconfig                              |   10 +-
 kernel/trace/trace.c                              |   24 ++--
 scripts/tracing/draw_functrace.py                 |    8 +-
 20 files changed, 183 insertions(+), 183 deletions(-)

diff --git a/Documentation/DocBook/debugobjects.tmpl b/Documentation/DocBook/debugobjects.tmpl
index 7f5f218..08ff908 100644
--- a/Documentation/DocBook/debugobjects.tmpl
+++ b/Documentation/DocBook/debugobjects.tmpl
@@ -106,7 +106,7 @@
       number of errors are printk'ed including a full stack trace.
     </para>
     <para>
-      The statistics are available via debugfs/debug_objects/stats.
+      The statistics are available via /sys/kernel/debug/debug_objects/stats.
       They provide information about the number of warnings and the
       number of successful fixups along with information about the
       usage of the internal tracking objects and the state of the
diff --git a/Documentation/cdrom/packet-writing.txt b/Documentation/cdrom/packet-writing.txt
index cf1f812..1c40777 100644
--- a/Documentation/cdrom/packet-writing.txt
+++ b/Documentation/cdrom/packet-writing.txt
@@ -117,7 +117,7 @@ Using the pktcdvd debugfs interface
 
 To read pktcdvd device infos in human readable form, do:
 
-	# cat /debug/pktcdvd/pktcdvd[0-7]/info
+	# cat /sys/kernel/debug/pktcdvd/pktcdvd[0-7]/info
 
 For a description of the debugfs interface look into the file:
 
diff --git a/Documentation/fault-injection/fault-injection.txt b/Documentation/fault-injection/fault-injection.txt
index 4bc374a..0793056 100644
--- a/Documentation/fault-injection/fault-injection.txt
+++ b/Documentation/fault-injection/fault-injection.txt
@@ -29,16 +29,16 @@ o debugfs entries
 fault-inject-debugfs kernel module provides some debugfs entries for runtime
 configuration of fault-injection capabilities.
 
-- /debug/fail*/probability:
+- /sys/kernel/debug/fail*/probability:
 
 	likelihood of failure injection, in percent.
 	Format: <percent>
 
 	Note that one-failure-per-hundred is a very high error rate
 	for some testcases.  Consider setting probability=100 and configure
-	/debug/fail*/interval for such testcases.
+	/sys/kernel/debug/fail*/interval for such testcases.
 
-- /debug/fail*/interval:
+- /sys/kernel/debug/fail*/interval:
 
 	specifies the interval between failures, for calls to
 	should_fail() that pass all the other tests.
@@ -46,18 +46,18 @@ configuration of fault-injection capabilities.
 	Note that if you enable this, by setting interval>1, you will
 	probably want to set probability=100.
 
-- /debug/fail*/times:
+- /sys/kernel/debug/fail*/times:
 
 	specifies how many times failures may happen at most.
 	A value of -1 means "no limit".
 
-- /debug/fail*/space:
+- /sys/kernel/debug/fail*/space:
 
 	specifies an initial resource "budget", decremented by "size"
 	on each call to should_fail(,size).  Failure injection is
 	suppressed until "space" reaches zero.
 
-- /debug/fail*/verbose
+- /sys/kernel/debug/fail*/verbose
 
 	Format: { 0 | 1 | 2 }
 	specifies the verbosity of the messages when failure is
@@ -65,17 +65,17 @@ configuration of fault-injection capabilities.
 	log line per failure; '2' will print a call trace too -- useful
 	to debug the problems revealed by fault injection.
 
-- /debug/fail*/task-filter:
+- /sys/kernel/debug/fail*/task-filter:
 
 	Format: { 'Y' | 'N' }
 	A value of 'N' disables filtering by process (default).
 	Any positive value limits failures to only processes indicated by
 	/proc/<pid>/make-it-fail==1.
 
-- /debug/fail*/require-start:
-- /debug/fail*/require-end:
-- /debug/fail*/reject-start:
-- /debug/fail*/reject-end:
+- /sys/kernel/debug/fail*/require-start:
+- /sys/kernel/debug/fail*/require-end:
+- /sys/kernel/debug/fail*/reject-start:
+- /sys/kernel/debug/fail*/reject-end:
 
 	specifies the range of virtual addresses tested during
 	stacktrace walking.  Failure is injected only if some caller
@@ -84,26 +84,26 @@ configuration of fault-injection capabilities.
 	Default required range is [0,ULONG_MAX) (whole of virtual address space).
 	Default rejected range is [0,0).
 
-- /debug/fail*/stacktrace-depth:
+- /sys/kernel/debug/fail*/stacktrace-depth:
 
 	specifies the maximum stacktrace depth walked during search
 	for a caller within [require-start,require-end) OR
 	[reject-start,reject-end).
 
-- /debug/fail_page_alloc/ignore-gfp-highmem:
+- /sys/kernel/debug/fail_page_alloc/ignore-gfp-highmem:
 
 	Format: { 'Y' | 'N' }
 	default is 'N', setting it to 'Y' won't inject failures into
 	highmem/user allocations.
 
-- /debug/failslab/ignore-gfp-wait:
-- /debug/fail_page_alloc/ignore-gfp-wait:
+- /sys/kernel/debug/failslab/ignore-gfp-wait:
+- /sys/kernel/debug/fail_page_alloc/ignore-gfp-wait:
 
 	Format: { 'Y' | 'N' }
 	default is 'N', setting it to 'Y' will inject failures
 	only into non-sleep allocations (GFP_ATOMIC allocations).
 
-- /debug/fail_page_alloc/min-order:
+- /sys/kernel/debug/fail_page_alloc/min-order:
 
 	specifies the minimum page allocation order to be injected
 	failures.
@@ -166,13 +166,13 @@ o Inject slab allocation failures into module init/exit code
 #!/bin/bash
 
 FAILTYPE=failslab
-echo Y > /debug/$FAILTYPE/task-filter
-echo 10 > /debug/$FAILTYPE/probability
-echo 100 > /debug/$FAILTYPE/interval
-echo -1 > /debug/$FAILTYPE/times
-echo 0 > /debug/$FAILTYPE/space
-echo 2 > /debug/$FAILTYPE/verbose
-echo 1 > /debug/$FAILTYPE/ignore-gfp-wait
+echo Y > /sys/kernel/debug/$FAILTYPE/task-filter
+echo 10 > /sys/kernel/debug/$FAILTYPE/probability
+echo 100 > /sys/kernel/debug/$FAILTYPE/interval
+echo -1 > /sys/kernel/debug/$FAILTYPE/times
+echo 0 > /sys/kernel/debug/$FAILTYPE/space
+echo 2 > /sys/kernel/debug/$FAILTYPE/verbose
+echo 1 > /sys/kernel/debug/$FAILTYPE/ignore-gfp-wait
 
 faulty_system()
 {
@@ -217,20 +217,20 @@ then
 	exit 1
 fi
 
-cat /sys/module/$module/sections/.text > /debug/$FAILTYPE/require-start
-cat /sys/module/$module/sections/.data > /debug/$FAILTYPE/require-end
+cat /sys/module/$module/sections/.text > /sys/kernel/debug/$FAILTYPE/require-start
+cat /sys/module/$module/sections/.data > /sys/kernel/debug/$FAILTYPE/require-end
 
-echo N > /debug/$FAILTYPE/task-filter
-echo 10 > /debug/$FAILTYPE/probability
-echo 100 > /debug/$FAILTYPE/interval
-echo -1 > /debug/$FAILTYPE/times
-echo 0 > /debug/$FAILTYPE/space
-echo 2 > /debug/$FAILTYPE/verbose
-echo 1 > /debug/$FAILTYPE/ignore-gfp-wait
-echo 1 > /debug/$FAILTYPE/ignore-gfp-highmem
-echo 10 > /debug/$FAILTYPE/stacktrace-depth
+echo N > /sys/kernel/debug/$FAILTYPE/task-filter
+echo 10 > /sys/kernel/debug/$FAILTYPE/probability
+echo 100 > /sys/kernel/debug/$FAILTYPE/interval
+echo -1 > /sys/kernel/debug/$FAILTYPE/times
+echo 0 > /sys/kernel/debug/$FAILTYPE/space
+echo 2 > /sys/kernel/debug/$FAILTYPE/verbose
+echo 1 > /sys/kernel/debug/$FAILTYPE/ignore-gfp-wait
+echo 1 > /sys/kernel/debug/$FAILTYPE/ignore-gfp-highmem
+echo 10 > /sys/kernel/debug/$FAILTYPE/stacktrace-depth
 
-trap "echo 0 > /debug/$FAILTYPE/probability" SIGINT SIGTERM EXIT
+trap "echo 0 > /sys/kernel/debug/$FAILTYPE/probability" SIGINT SIGTERM EXIT
 
 echo "Injecting errors into the module $module... (interrupt to stop)"
 sleep 1000000
diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 1e7a769..053037a 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -507,9 +507,9 @@ http://www.linuxsymposium.org/2006/linuxsymposium_procv2.pdf (pages 101-115)
 Appendix A: The kprobes debugfs interface
 
 With recent kernels (> 2.6.20) the list of registered kprobes is visible
-under the /debug/kprobes/ directory (assuming debugfs is mounted at /debug).
+under the /sys/kernel/debug/kprobes/ directory (assuming debugfs is mounted at //sys/kernel/debug).
 
-/debug/kprobes/list: Lists all registered probes on the system
+/sys/kernel/debug/kprobes/list: Lists all registered probes on the system
 
 c015d71a  k  vfs_read+0x0
 c011a316  j  do_fork+0x0
@@ -525,7 +525,7 @@ virtual addresses that correspond to modules that've been unloaded),
 such probes are marked with [GONE]. If the probe is temporarily disabled,
 such probes are marked with [DISABLED].
 
-/debug/kprobes/enabled: Turn kprobes ON/OFF forcibly.
+/sys/kernel/debug/kprobes/enabled: Turn kprobes ON/OFF forcibly.
 
 Provides a knob to globally and forcibly turn registered kprobes ON or OFF.
 By default, all kprobes are enabled. By echoing "0" to this file, all
diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index fd9a3e6..cbc6cca 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -35,11 +35,11 @@ well as the files to display output.
 
 To mount the debugfs system:
 
-  # mkdir /debug
-  # mount -t debugfs nodev /debug
+  # mkdir /sys/kernel/debug
+  # mount -t debugfs nodev /sys/kernel/debug
 
 ( Note: it is more common to mount at /sys/kernel/debug, but for
-  simplicity this document will use /debug)
+  simplicity this document will use /sys/kernel/debug)
 
 That's it! (assuming that you have ftrace configured into your kernel)
 
@@ -389,18 +389,18 @@ trace_options
 The trace_options file is used to control what gets printed in
 the trace output. To see what is available, simply cat the file:
 
-  cat /debug/tracing/trace_options
+  cat /sys/kernel/debug/tracing/trace_options
   print-parent nosym-offset nosym-addr noverbose noraw nohex nobin \
   noblock nostacktrace nosched-tree nouserstacktrace nosym-userobj
 
 To disable one of the options, echo in the option prepended with
 "no".
 
-  echo noprint-parent > /debug/tracing/trace_options
+  echo noprint-parent > /sys/kernel/debug/tracing/trace_options
 
 To enable an option, leave off the "no".
 
-  echo sym-offset > /debug/tracing/trace_options
+  echo sym-offset > /sys/kernel/debug/tracing/trace_options
 
 Here are the available options:
 
@@ -476,11 +476,11 @@ sched_switch
 This tracer simply records schedule switches. Here is an example
 of how to use it.
 
- # echo sched_switch > /debug/tracing/current_tracer
- # echo 1 > /debug/tracing/tracing_enabled
+ # echo sched_switch > /sys/kernel/debug/tracing/current_tracer
+ # echo 1 > /sys/kernel/debug/tracing/tracing_enabled
  # sleep 1
- # echo 0 > /debug/tracing/tracing_enabled
- # cat /debug/tracing/trace
+ # echo 0 > /sys/kernel/debug/tracing/tracing_enabled
+ # cat /sys/kernel/debug/tracing/trace
 
 # tracer: sched_switch
 #
@@ -574,13 +574,13 @@ new trace is saved.
 To reset the maximum, echo 0 into tracing_max_latency. Here is
 an example:
 
- # echo irqsoff > /debug/tracing/current_tracer
- # echo 0 > /debug/tracing/tracing_max_latency
- # echo 1 > /debug/tracing/tracing_enabled
+ # echo irqsoff > /sys/kernel/debug/tracing/current_tracer
+ # echo 0 > /sys/kernel/debug/tracing/tracing_max_latency
+ # echo 1 > /sys/kernel/debug/tracing/tracing_enabled
  # ls -ltr
  [...]
- # echo 0 > /debug/tracing/tracing_enabled
- # cat /debug/tracing/latency_trace
+ # echo 0 > /sys/kernel/debug/tracing/tracing_enabled
+ # cat /sys/kernel/debug/tracing/latency_trace
 # tracer: irqsoff
 #
 irqsoff latency trace v1.1.5 on 2.6.26
@@ -681,13 +681,13 @@ Like the irqsoff tracer, it records the maximum latency for
 which preemption was disabled. The control of preemptoff tracer
 is much like the irqsoff tracer.
 
- # echo preemptoff > /debug/tracing/current_tracer
- # echo 0 > /debug/tracing/tracing_max_latency
- # echo 1 > /debug/tracing/tracing_enabled
+ # echo preemptoff > /sys/kernel/debug/tracing/current_tracer
+ # echo 0 > /sys/kernel/debug/tracing/tracing_max_latency
+ # echo 1 > /sys/kernel/debug/tracing/tracing_enabled
  # ls -ltr
  [...]
- # echo 0 > /debug/tracing/tracing_enabled
- # cat /debug/tracing/latency_trace
+ # echo 0 > /sys/kernel/debug/tracing/tracing_enabled
+ # cat /sys/kernel/debug/tracing/latency_trace
 # tracer: preemptoff
 #
 preemptoff latency trace v1.1.5 on 2.6.26-rc8
@@ -828,13 +828,13 @@ tracer.
 Again, using this trace is much like the irqsoff and preemptoff
 tracers.
 
- # echo preemptirqsoff > /debug/tracing/current_tracer
- # echo 0 > /debug/tracing/tracing_max_latency
- # echo 1 > /debug/tracing/tracing_enabled
+ # echo preemptirqsoff > /sys/kernel/debug/tracing/current_tracer
+ # echo 0 > /sys/kernel/debug/tracing/tracing_max_latency
+ # echo 1 > /sys/kernel/debug/tracing/tracing_enabled
  # ls -ltr
  [...]
- # echo 0 > /debug/tracing/tracing_enabled
- # cat /debug/tracing/latency_trace
+ # echo 0 > /sys/kernel/debug/tracing/tracing_enabled
+ # cat /sys/kernel/debug/tracing/latency_trace
 # tracer: preemptirqsoff
 #
 preemptirqsoff latency trace v1.1.5 on 2.6.26-rc8
@@ -990,12 +990,12 @@ slightly differently than we did with the previous tracers.
 Instead of performing an 'ls', we will run 'sleep 1' under
 'chrt' which changes the priority of the task.
 
- # echo wakeup > /debug/tracing/current_tracer
- # echo 0 > /debug/tracing/tracing_max_latency
- # echo 1 > /debug/tracing/tracing_enabled
+ # echo wakeup > /sys/kernel/debug/tracing/current_tracer
+ # echo 0 > /sys/kernel/debug/tracing/tracing_max_latency
+ # echo 1 > /sys/kernel/debug/tracing/tracing_enabled
  # chrt -f 5 sleep 1
- # echo 0 > /debug/tracing/tracing_enabled
- # cat /debug/tracing/latency_trace
+ # echo 0 > /sys/kernel/debug/tracing/tracing_enabled
+ # cat /sys/kernel/debug/tracing/latency_trace
 # tracer: wakeup
 #
 wakeup latency trace v1.1.5 on 2.6.26-rc8
@@ -1105,11 +1105,11 @@ can be done from the debug file system. Make sure the
 ftrace_enabled is set; otherwise this tracer is a nop.
 
  # sysctl kernel.ftrace_enabled=1
- # echo function > /debug/tracing/current_tracer
- # echo 1 > /debug/tracing/tracing_enabled
+ # echo function > /sys/kernel/debug/tracing/current_tracer
+ # echo 1 > /sys/kernel/debug/tracing/tracing_enabled
  # usleep 1
- # echo 0 > /debug/tracing/tracing_enabled
- # cat /debug/tracing/trace
+ # echo 0 > /sys/kernel/debug/tracing/tracing_enabled
+ # cat /sys/kernel/debug/tracing/trace
 # tracer: function
 #
 #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
@@ -1146,7 +1146,7 @@ int trace_fd;
 [...]
 int main(int argc, char *argv[]) {
 	[...]
-	trace_fd = open("/debug/tracing/tracing_enabled", O_WRONLY);
+	trace_fd = open("/sys/kernel/debug/tracing/tracing_enabled", O_WRONLY);
 	[...]
 	if (condition_hit()) {
 		write(trace_fd, "0", 1);
@@ -1155,7 +1155,7 @@ int main(int argc, char *argv[]) {
 }
 
 Note: Here we hard coded the path name. The debugfs mount is not
-guaranteed to be at /debug (and is more commonly at
+guaranteed to be at /sys/kernel/debug (and is more commonly at
 /sys/kernel/debug). For simple one time traces, the above is
 sufficent. For anything else, a search through /proc/mounts may
 be needed to find where the debugfs file-system is mounted.
@@ -1164,16 +1164,16 @@ be needed to find where the debugfs file-system is mounted.
 Single thread tracing
 ---------------------
 
-By writing into /debug/tracing/set_ftrace_pid you can trace a
+By writing into /sys/kernel/debug/tracing/set_ftrace_pid you can trace a
 single thread. For example:
 
-# cat /debug/tracing/set_ftrace_pid
+# cat /sys/kernel/debug/tracing/set_ftrace_pid
 no pid
-# echo 3111 > /debug/tracing/set_ftrace_pid
-# cat /debug/tracing/set_ftrace_pid
+# echo 3111 > /sys/kernel/debug/tracing/set_ftrace_pid
+# cat /sys/kernel/debug/tracing/set_ftrace_pid
 3111
-# echo function > /debug/tracing/current_tracer
-# cat /debug/tracing/trace | head
+# echo function > /sys/kernel/debug/tracing/current_tracer
+# cat /sys/kernel/debug/tracing/trace | head
  # tracer: function
  #
  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
@@ -1184,8 +1184,8 @@ no pid
      yum-updatesd-3111  [003]  1637.254683: lock_hrtimer_base <-hrtimer_try_to_cancel
      yum-updatesd-3111  [003]  1637.254685: fget_light <-do_sys_poll
      yum-updatesd-3111  [003]  1637.254686: pipe_poll <-do_sys_poll
-# echo -1 > /debug/tracing/set_ftrace_pid
-# cat /debug/tracing/trace |head
+# echo -1 > /sys/kernel/debug/tracing/set_ftrace_pid
+# cat /sys/kernel/debug/tracing/trace |head
  # tracer: function
  #
  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
@@ -1217,12 +1217,12 @@ int main (int argc, char **argv)
                 char line[64];
                 int s;
 
-                ffd = open("/debug/tracing/current_tracer", O_WRONLY);
+                ffd = open("/sys/kernel/debug/tracing/current_tracer", O_WRONLY);
                 if (ffd < 0)
                         exit(-1);
                 write(ffd, "nop", 3);
 
-                fd = open("/debug/tracing/set_ftrace_pid", O_WRONLY);
+                fd = open("/sys/kernel/debug/tracing/set_ftrace_pid", O_WRONLY);
                 s = sprintf(line, "%d\n", getpid());
                 write(fd, line, s);
 
@@ -1374,22 +1374,22 @@ want, depending on your needs.
   tracing_cpu_mask file) or you might sometimes see unordered
   function calls while cpu tracing switch.
 
-	hide: echo nofuncgraph-cpu > /debug/tracing/trace_options
-	show: echo funcgraph-cpu > /debug/tracing/trace_options
+	hide: echo nofuncgraph-cpu > /sys/kernel/debug/tracing/trace_options
+	show: echo funcgraph-cpu > /sys/kernel/debug/tracing/trace_options
 
 - The duration (function's time of execution) is displayed on
   the closing bracket line of a function or on the same line
   than the current function in case of a leaf one. It is default
   enabled.
 
-	hide: echo nofuncgraph-duration > /debug/tracing/trace_options
-	show: echo funcgraph-duration > /debug/tracing/trace_options
+	hide: echo nofuncgraph-duration > /sys/kernel/debug/tracing/trace_options
+	show: echo funcgraph-duration > /sys/kernel/debug/tracing/trace_options
 
 - The overhead field precedes the duration field in case of
   reached duration thresholds.
 
-	hide: echo nofuncgraph-overhead > /debug/tracing/trace_options
-	show: echo funcgraph-overhead > /debug/tracing/trace_options
+	hide: echo nofuncgraph-overhead > /sys/kernel/debug/tracing/trace_options
+	show: echo funcgraph-overhead > /sys/kernel/debug/tracing/trace_options
 	depends on: funcgraph-duration
 
   ie:
@@ -1418,8 +1418,8 @@ want, depending on your needs.
 - The task/pid field displays the thread cmdline and pid which
   executed the function. It is default disabled.
 
-	hide: echo nofuncgraph-proc > /debug/tracing/trace_options
-	show: echo funcgraph-proc > /debug/tracing/trace_options
+	hide: echo nofuncgraph-proc > /sys/kernel/debug/tracing/trace_options
+	show: echo funcgraph-proc > /sys/kernel/debug/tracing/trace_options
 
   ie:
 
@@ -1442,8 +1442,8 @@ want, depending on your needs.
   system clock since it started. A snapshot of this time is
   given on each entry/exit of functions
 
-	hide: echo nofuncgraph-abstime > /debug/tracing/trace_options
-	show: echo funcgraph-abstime > /debug/tracing/trace_options
+	hide: echo nofuncgraph-abstime > /sys/kernel/debug/tracing/trace_options
+	show: echo funcgraph-abstime > /sys/kernel/debug/tracing/trace_options
 
   ie:
 
@@ -1540,7 +1540,7 @@ listed in:
 
    available_filter_functions
 
- # cat /debug/tracing/available_filter_functions
+ # cat /sys/kernel/debug/tracing/available_filter_functions
 put_prev_task_idle
 kmem_cache_create
 pick_next_task_rt
@@ -1552,12 +1552,12 @@ mutex_lock
 If I am only interested in sys_nanosleep and hrtimer_interrupt:
 
  # echo sys_nanosleep hrtimer_interrupt \
-		> /debug/tracing/set_ftrace_filter
- # echo ftrace > /debug/tracing/current_tracer
- # echo 1 > /debug/tracing/tracing_enabled
+		> /sys/kernel/debug/tracing/set_ftrace_filter
+ # echo ftrace > /sys/kernel/debug/tracing/current_tracer
+ # echo 1 > /sys/kernel/debug/tracing/tracing_enabled
  # usleep 1
- # echo 0 > /debug/tracing/tracing_enabled
- # cat /debug/tracing/trace
+ # echo 0 > /sys/kernel/debug/tracing/tracing_enabled
+ # cat /sys/kernel/debug/tracing/trace
 # tracer: ftrace
 #
 #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
@@ -1568,7 +1568,7 @@ If I am only interested in sys_nanosleep and hrtimer_interrupt:
 
 To see which functions are being traced, you can cat the file:
 
- # cat /debug/tracing/set_ftrace_filter
+ # cat /sys/kernel/debug/tracing/set_ftrace_filter
 hrtimer_interrupt
 sys_nanosleep
 
@@ -1588,7 +1588,7 @@ Note: It is better to use quotes to enclose the wild cards,
       otherwise the shell may expand the parameters into names
       of files in the local directory.
 
- # echo 'hrtimer_*' > /debug/tracing/set_ftrace_filter
+ # echo 'hrtimer_*' > /sys/kernel/debug/tracing/set_ftrace_filter
 
 Produces:
 
@@ -1609,7 +1609,7 @@ Produces:
 
 Notice that we lost the sys_nanosleep.
 
- # cat /debug/tracing/set_ftrace_filter
+ # cat /sys/kernel/debug/tracing/set_ftrace_filter
 hrtimer_run_queues
 hrtimer_run_pending
 hrtimer_init
@@ -1635,17 +1635,17 @@ To append to the filters, use '>>'
 To clear out a filter so that all functions will be recorded
 again:
 
- # echo > /debug/tracing/set_ftrace_filter
- # cat /debug/tracing/set_ftrace_filter
+ # echo > /sys/kernel/debug/tracing/set_ftrace_filter
+ # cat /sys/kernel/debug/tracing/set_ftrace_filter
  #
 
 Again, now we want to append.
 
- # echo sys_nanosleep > /debug/tracing/set_ftrace_filter
- # cat /debug/tracing/set_ftrace_filter
+ # echo sys_nanosleep > /sys/kernel/debug/tracing/set_ftrace_filter
+ # cat /sys/kernel/debug/tracing/set_ftrace_filter
 sys_nanosleep
- # echo 'hrtimer_*' >> /debug/tracing/set_ftrace_filter
- # cat /debug/tracing/set_ftrace_filter
+ # echo 'hrtimer_*' >> /sys/kernel/debug/tracing/set_ftrace_filter
+ # cat /sys/kernel/debug/tracing/set_ftrace_filter
 hrtimer_run_queues
 hrtimer_run_pending
 hrtimer_init
@@ -1668,7 +1668,7 @@ hrtimer_init_sleeper
 The set_ftrace_notrace prevents those functions from being
 traced.
 
- # echo '*preempt*' '*lock*' > /debug/tracing/set_ftrace_notrace
+ # echo '*preempt*' '*lock*' > /sys/kernel/debug/tracing/set_ftrace_notrace
 
 Produces:
 
@@ -1758,13 +1758,13 @@ the effect on the tracing is different. Every read from
 trace_pipe is consumed. This means that subsequent reads will be
 different. The trace is live.
 
- # echo function > /debug/tracing/current_tracer
- # cat /debug/tracing/trace_pipe > /tmp/trace.out &
+ # echo function > /sys/kernel/debug/tracing/current_tracer
+ # cat /sys/kernel/debug/tracing/trace_pipe > /tmp/trace.out &
 [1] 4153
- # echo 1 > /debug/tracing/tracing_enabled
+ # echo 1 > /sys/kernel/debug/tracing/tracing_enabled
  # usleep 1
- # echo 0 > /debug/tracing/tracing_enabled
- # cat /debug/tracing/trace
+ # echo 0 > /sys/kernel/debug/tracing/tracing_enabled
+ # cat /sys/kernel/debug/tracing/trace
 # tracer: function
 #
 #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
@@ -1800,7 +1800,7 @@ number listed is the number of entries that can be recorded per
 CPU. To know the full size, multiply the number of possible CPUS
 with the number of entries.
 
- # cat /debug/tracing/buffer_size_kb
+ # cat /sys/kernel/debug/tracing/buffer_size_kb
 1408 (units kilobytes)
 
 Note, to modify this, you must have tracing completely disabled.
@@ -1808,18 +1808,18 @@ To do that, echo "nop" into the current_tracer. If the
 current_tracer is not set to "nop", an EINVAL error will be
 returned.
 
- # echo nop > /debug/tracing/current_tracer
- # echo 10000 > /debug/tracing/buffer_size_kb
- # cat /debug/tracing/buffer_size_kb
+ # echo nop > /sys/kernel/debug/tracing/current_tracer
+ # echo 10000 > /sys/kernel/debug/tracing/buffer_size_kb
+ # cat /sys/kernel/debug/tracing/buffer_size_kb
 10000 (units kilobytes)
 
 The number of pages which will be allocated is limited to a
 percentage of available memory. Allocating too much will produce
 an error.
 
- # echo 1000000000000 > /debug/tracing/buffer_size_kb
+ # echo 1000000000000 > /sys/kernel/debug/tracing/buffer_size_kb
 -bash: echo: write error: Cannot allocate memory
- # cat /debug/tracing/buffer_size_kb
+ # cat /sys/kernel/debug/tracing/buffer_size_kb
 85
 
 -----------
diff --git a/Documentation/trace/mmiotrace.txt b/Documentation/trace/mmiotrace.txt
index 5731c67..162effb 100644
--- a/Documentation/trace/mmiotrace.txt
+++ b/Documentation/trace/mmiotrace.txt
@@ -32,41 +32,41 @@ is no way to automatically detect if you are losing events due to CPUs racing.
 Usage Quick Reference
 ---------------------
 
-$ mount -t debugfs debugfs /debug
-$ echo mmiotrace > /debug/tracing/current_tracer
-$ cat /debug/tracing/trace_pipe > mydump.txt &
+$ mount -t debugfs debugfs /sys/kernel/debug
+$ echo mmiotrace > /sys/kernel/debug/tracing/current_tracer
+$ cat /sys/kernel/debug/tracing/trace_pipe > mydump.txt &
 Start X or whatever.
-$ echo "X is up" > /debug/tracing/trace_marker
-$ echo nop > /debug/tracing/current_tracer
+$ echo "X is up" > /sys/kernel/debug/tracing/trace_marker
+$ echo nop > /sys/kernel/debug/tracing/current_tracer
 Check for lost events.
 
 
 Usage
 -----
 
-Make sure debugfs is mounted to /debug. If not, (requires root privileges)
-$ mount -t debugfs debugfs /debug
+Make sure debugfs is mounted to /sys/kernel/debug. If not, (requires root privileges)
+$ mount -t debugfs debugfs /sys/kernel/debug
 
 Check that the driver you are about to trace is not loaded.
 
 Activate mmiotrace (requires root privileges):
-$ echo mmiotrace > /debug/tracing/current_tracer
+$ echo mmiotrace > /sys/kernel/debug/tracing/current_tracer
 
 Start storing the trace:
-$ cat /debug/tracing/trace_pipe > mydump.txt &
+$ cat /sys/kernel/debug/tracing/trace_pipe > mydump.txt &
 The 'cat' process should stay running (sleeping) in the background.
 
 Load the driver you want to trace and use it. Mmiotrace will only catch MMIO
 accesses to areas that are ioremapped while mmiotrace is active.
 
 During tracing you can place comments (markers) into the trace by
-$ echo "X is up" > /debug/tracing/trace_marker
+$ echo "X is up" > /sys/kernel/debug/tracing/trace_marker
 This makes it easier to see which part of the (huge) trace corresponds to
 which action. It is recommended to place descriptive markers about what you
 do.
 
 Shut down mmiotrace (requires root privileges):
-$ echo nop > /debug/tracing/current_tracer
+$ echo nop > /sys/kernel/debug/tracing/current_tracer
 The 'cat' process exits. If it does not, kill it by issuing 'fg' command and
 pressing ctrl+c.
 
@@ -78,10 +78,10 @@ to view your kernel log and look for "mmiotrace has lost events" warning. If
 events were lost, the trace is incomplete. You should enlarge the buffers and
 try again. Buffers are enlarged by first seeing how large the current buffers
 are:
-$ cat /debug/tracing/buffer_size_kb
+$ cat /sys/kernel/debug/tracing/buffer_size_kb
 gives you a number. Approximately double this number and write it back, for
 instance:
-$ echo 128000 > /debug/tracing/buffer_size_kb
+$ echo 128000 > /sys/kernel/debug/tracing/buffer_size_kb
 Then start again from the top.
 
 If you are doing a trace for a driver project, e.g. Nouveau, you should also
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index dc7a8c3..9aa8932 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -430,7 +430,7 @@ static void pkt_sysfs_cleanup(void)
 /********************************************************************
   entries in debugfs
 
-  /debugfs/pktcdvd[0-7]/
+  /sys/kernel/debug/pktcdvd[0-7]/
 			info
 
  *******************************************************************/
diff --git a/drivers/gpu/drm/drm_debugfs.c b/drivers/gpu/drm/drm_debugfs.c
index c77c6c6..6ce0e26 100644
--- a/drivers/gpu/drm/drm_debugfs.c
+++ b/drivers/gpu/drm/drm_debugfs.c
@@ -105,7 +105,7 @@ int drm_debugfs_create_files(struct drm_info_list *files, int count,
 		ent = debugfs_create_file(files[i].name, S_IFREG | S_IRUGO,
 					  root, tmp, &drm_debugfs_fops);
 		if (!ent) {
-			DRM_ERROR("Cannot create /debugfs/dri/%s/%s\n",
+			DRM_ERROR("Cannot create /sys/kernel/debug/dri/%s/%s\n",
 				  name, files[i].name);
 			drm_free(tmp, sizeof(struct drm_info_node),
 				 _DRM_DRIVER);
@@ -133,9 +133,9 @@ EXPORT_SYMBOL(drm_debugfs_create_files);
  * \param minor device minor number
  * \param root DRI debugfs dir entry.
  *
- * Create the DRI debugfs root entry "/debugfs/dri", the device debugfs root entry
- * "/debugfs/dri/%minor%/", and each entry in debugfs_list as
- * "/debugfs/dri/%minor%/%name%".
+ * Create the DRI debugfs root entry "/sys/kernel/debug/dri", the device debugfs root entry
+ * "/sys/kernel/debug/dri/%minor%/", and each entry in debugfs_list as
+ * "/sys/kernel/debug/dri/%minor%/%name%".
  */
 int drm_debugfs_init(struct drm_minor *minor, int minor_id,
 		     struct dentry *root)
@@ -148,7 +148,7 @@ int drm_debugfs_init(struct drm_minor *minor, int minor_id,
 	sprintf(name, "%d", minor_id);
 	minor->debugfs_root = debugfs_create_dir(name, root);
 	if (!minor->debugfs_root) {
-		DRM_ERROR("Cannot create /debugfs/dri/%s\n", name);
+		DRM_ERROR("Cannot create /sys/kernel/debug/dri/%s\n", name);
 		return -1;
 	}
 
@@ -165,7 +165,7 @@ int drm_debugfs_init(struct drm_minor *minor, int minor_id,
 		ret = dev->driver->debugfs_init(minor);
 		if (ret) {
 			DRM_ERROR("DRM: Driver failed to initialize "
-				  "/debugfs/dri.\n");
+				  "/sys/kernel/debug/dri.\n");
 			return ret;
 		}
 	}
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 019b7c5..1bf7efd 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -339,7 +339,7 @@ static int __init drm_core_init(void)
 
 	drm_debugfs_root = debugfs_create_dir("dri", NULL);
 	if (!drm_debugfs_root) {
-		DRM_ERROR("Cannot create /debugfs/dri\n");
+		DRM_ERROR("Cannot create /sys/kernel/debug/dri\n");
 		ret = -1;
 		goto err_p3;
 	}
diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index b9631e3..b2a93c4 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -328,7 +328,7 @@ static int drm_get_minor(struct drm_device *dev, struct drm_minor **minor, int t
 #if defined(CONFIG_DEBUG_FS)
 	ret = drm_debugfs_init(new_minor, minor_id, drm_debugfs_root);
 	if (ret) {
-		DRM_ERROR("DRM: Failed to initialize /debugfs/dri.\n");
+		DRM_ERROR("DRM: Failed to initialize /sys/kernel/debug/dri.\n");
 		goto err_g2;
 	}
 #endif
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 214a92d..a170cea 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2200,7 +2200,7 @@ config SKGE_DEBUG
        depends on SKGE && DEBUG_FS
        help
 	 This option adds the ability to dump driver state for debugging.
-	 The file debugfs/skge/ethX displays the state of the internal
+	 The file /sys/kernel/debug/skge/ethX displays the state of the internal
 	 transmit and receive rings.
 
 	 If unsure, say N.
@@ -2226,7 +2226,7 @@ config SKY2_DEBUG
        depends on SKY2 && DEBUG_FS
        help
 	 This option adds the ability to dump driver state for debugging.
-	 The file debugfs/sky2/ethX displays the state of the internal
+	 The file /sys/kernel/debug/sky2/ethX displays the state of the internal
 	 transmit and receive rings.
 
 	 If unsure, say N.
diff --git a/drivers/net/wimax/i2400m/i2400m.h b/drivers/net/wimax/i2400m/i2400m.h
index 3ae2df3..da2e8f2 100644
--- a/drivers/net/wimax/i2400m/i2400m.h
+++ b/drivers/net/wimax/i2400m/i2400m.h
@@ -389,7 +389,7 @@ struct i2400m {
 	unsigned ready:1;		/* all probing steps done */
 	unsigned rx_reorder:1;		/* RX reorder is enabled */
 	u8 trace_msg_from_user;		/* echo rx msgs to 'trace' pipe */
-					/* typed u8 so debugfs/u8 can tweak */
+					/* typed u8 so /sys/kernel/debug/u8 can tweak */
 	enum i2400m_system_state state;
 	wait_queue_head_t state_wq;	/* Woken up when on state updates */
 
diff --git a/drivers/net/wireless/ath5k/Kconfig b/drivers/net/wireless/ath5k/Kconfig
index 75383a5..fdfa708 100644
--- a/drivers/net/wireless/ath5k/Kconfig
+++ b/drivers/net/wireless/ath5k/Kconfig
@@ -27,11 +27,11 @@ config ATH5K_DEBUG
 	  Say Y, if and you will get debug options for ath5k.
 	  To use this, you need to mount debugfs:
 
-	  mkdir /debug/
-	  mount -t debugfs debug /debug/
+	  mkdir /sys/kernel/debug/
+	  mount -t debugfs debug /sys/kernel/debug/
 
 	  You will get access to files under:
-	  /debug/ath5k/phy0/
+	  /sys/kernel/debug/ath5k/phy0/
 
 	  To enable debug, pass the debug level to the debug module
 	  parameter. For example:
diff --git a/drivers/net/wireless/libertas/README b/drivers/net/wireless/libertas/README
index d860fc3..ab6a2d5 100644
--- a/drivers/net/wireless/libertas/README
+++ b/drivers/net/wireless/libertas/README
@@ -72,7 +72,7 @@ rdrf
 	location that is to be read.  This parameter must be specified in
 	hexadecimal (its possible to preceed preceding the number with a "0x").
 
-	Path: /debugfs/libertas_wireless/ethX/registers/
+	Path: /sys/kernel/debug/libertas_wireless/ethX/registers/
 
 	Usage:
 		echo "0xa123" > rdmac ; cat rdmac
@@ -95,7 +95,7 @@ wrrf
 sleepparams
 	This command is used to set the sleepclock configurations
 
-	Path: /debugfs/libertas_wireless/ethX/
+	Path: /sys/kernel/debug/libertas_wireless/ethX/
 
 	Usage:
 		cat sleepparams: reads the current sleepclock configuration
@@ -115,7 +115,7 @@ subscribed_events
 	The subscribed_events directory contains the interface for the
 	subscribed events API.
 
-	Path: /debugfs/libertas_wireless/ethX/subscribed_events/
+	Path: /sys/kernel/debug/libertas_wireless/ethX/subscribed_events/
 
 	Each event is represented by a filename. Each filename consists of the
 	following three fields:
@@ -165,7 +165,7 @@ subscribed_events
 extscan
 	This command is used to do a specific scan.
 
-	Path: /debugfs/libertas_wireless/ethX/
+	Path: /sys/kernel/debug/libertas_wireless/ethX/
 
 	Usage: echo "SSID" > extscan
 
@@ -179,7 +179,7 @@ getscantable
 	Display the current contents of the driver scan table (ie. get the
 	scan results).
 
-	Path: /debugfs/libertas_wireless/ethX/
+	Path: /sys/kernel/debug/libertas_wireless/ethX/
 
 	Usage:
 		cat getscantable
@@ -188,7 +188,7 @@ setuserscan
 	Initiate a customized scan and retrieve the results
 
 
-	Path: /debugfs/libertas_wireless/ethX/
+	Path: /sys/kernel/debug/libertas_wireless/ethX/
 
     Usage:
        echo "[ARGS]" > setuserscan
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 52be564..9112380 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -51,8 +51,8 @@
  * debugfs interface
  *
  * To access this interface the user should:
- * # mkdir /debug
- * # mount -t debugfs none /debug
+ * # mkdir /sys/kernel/debug
+ * # mount -t debugfs none /sys/kernel/debug
  *
  * The lpfc debugfs directory hierarchy is:
  * lpfc/lpfcX/vportY
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 883cd44..99b7aad 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -406,7 +406,7 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
  *
  * Use tracing_on/tracing_off when you want to quickly turn on or off
  * tracing. It simply enables or disables the recording of the trace events.
- * This also corresponds to the user space debugfs/tracing/tracing_on
+ * This also corresponds to the user space /sys/kernel/debug/tracing/tracing_on
  * file, which gives a means for the kernel and userspace to interact.
  * Place a tracing_off() in the kernel where you want tracing to end.
  * From user space, examine the trace, and then echo 1 > tracing_on
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index d35a7ee..9c9ac7d 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -197,7 +197,7 @@ static inline void tracepoint_synchronize_unregister(void)
  *	* This is how the trace record is structured and will
  *	* be saved into the ring buffer. These are the fields
  *	* that will be exposed to user-space in
- *	* /debug/tracing/events/<*>/format.
+ *	* /sys/kernel/debug/tracing/events/<*>/format.
  *	*
  *	* The declared 'local variable' is called '__entry'
  *	*
@@ -257,7 +257,7 @@ static inline void tracepoint_synchronize_unregister(void)
  * tracepoint callback (this is used by programmatic plugins and
  * can also by used by generic instrumentation like SystemTap), and
  * it is also used to expose a structured trace record in
- * /debug/tracing/events/.
+ * /sys/kernel/debug/tracing/events/.
  */
 
 #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 417d198..e5ce28f 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -120,7 +120,7 @@ config IRQSOFF_TRACER
 	  disabled by default and can be runtime (re-)started
 	  via:
 
-	      echo 0 > /debugfs/tracing/tracing_max_latency
+	      echo 0 > /sys/kernel/debug/tracing/tracing_max_latency
 
 	  (Note that kernel size and overhead increases with this option
 	  enabled. This option and the preempt-off timing option can be
@@ -141,7 +141,7 @@ config PREEMPT_TRACER
 	  disabled by default and can be runtime (re-)started
 	  via:
 
-	      echo 0 > /debugfs/tracing/tracing_max_latency
+	      echo 0 > /sys/kernel/debug/tracing/tracing_max_latency
 
 	  (Note that kernel size and overhead increases with this option
 	  enabled. This option and the irqs-off timing option can be
@@ -213,7 +213,7 @@ config TRACE_BRANCH_PROFILING
 	  This tracer profiles all the the likely and unlikely macros
 	  in the kernel. It will display the results in:
 
-	  /debugfs/tracing/profile_annotated_branch
+	  /sys/kernel/debug/tracing/profile_annotated_branch
 
 	  Note: this will add a significant overhead, only turn this
 	  on if you need to profile the system's use of these macros.
@@ -228,7 +228,7 @@ config PROFILE_ALL_BRANCHES
 	  taken in the kernel is recorded whether it hit or miss.
 	  The results will be displayed in:
 
-	  /debugfs/tracing/profile_branch
+	  /sys/kernel/debug/tracing/profile_branch
 
 	  This configuration, when enabled, will impose a great overhead
 	  on the system. This should only be enabled when the system
@@ -276,7 +276,7 @@ config STACK_TRACER
 	select KALLSYMS
 	help
 	  This special tracer records the maximum stack footprint of the
-	  kernel and displays it in debugfs/tracing/stack_trace.
+	  kernel and displays it in /sys/kernel/debug/tracing/stack_trace.
 
 	  This tracer works by hooking into every function call that the
 	  kernel executes, and keeping a maximum stack depth value and
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index cda81ec..9b94d57 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -335,7 +335,7 @@ static raw_spinlock_t ftrace_max_lock =
 /*
  * Copy the new maximum trace into the separate maximum-trace
  * structure. (this way the maximum trace is permanently saved,
- * for later retrieval via /debugfs/tracing/latency_trace)
+ * for later retrieval via /sys/kernel/debug/tracing/latency_trace)
  */
 static void
 __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
@@ -2366,21 +2366,21 @@ static const struct file_operations tracing_iter_fops = {
 
 static const char readme_msg[] =
 	"tracing mini-HOWTO:\n\n"
-	"# mkdir /debug\n"
-	"# mount -t debugfs nodev /debug\n\n"
-	"# cat /debug/tracing/available_tracers\n"
+	"# mkdir /sys/kernel/debug\n"
+	"# mount -t debugfs nodev /sys/kernel/debug\n\n"
+	"# cat /sys/kernel/debug/tracing/available_tracers\n"
 	"wakeup preemptirqsoff preemptoff irqsoff function sched_switch nop\n\n"
-	"# cat /debug/tracing/current_tracer\n"
+	"# cat /sys/kernel/debug/tracing/current_tracer\n"
 	"nop\n"
-	"# echo sched_switch > /debug/tracing/current_tracer\n"
-	"# cat /debug/tracing/current_tracer\n"
+	"# echo sched_switch > /sys/kernel/debug/tracing/current_tracer\n"
+	"# cat /sys/kernel/debug/tracing/current_tracer\n"
 	"sched_switch\n"
-	"# cat /debug/tracing/trace_options\n"
+	"# cat /sys/kernel/debug/tracing/trace_options\n"
 	"noprint-parent nosym-offset nosym-addr noverbose\n"
-	"# echo print-parent > /debug/tracing/trace_options\n"
-	"# echo 1 > /debug/tracing/tracing_enabled\n"
-	"# cat /debug/tracing/trace > /tmp/trace.txt\n"
-	"# echo 0 > /debug/tracing/tracing_enabled\n"
+	"# echo print-parent > /sys/kernel/debug/tracing/trace_options\n"
+	"# echo 1 > /sys/kernel/debug/tracing/tracing_enabled\n"
+	"# cat /sys/kernel/debug/tracing/trace > /tmp/trace.txt\n"
+	"# echo 0 > /sys/kernel/debug/tracing/tracing_enabled\n"
 ;
 
 static ssize_t
diff --git a/scripts/tracing/draw_functrace.py b/scripts/tracing/draw_functrace.py
index 902f9a9..66f4d1b 100644
--- a/scripts/tracing/draw_functrace.py
+++ b/scripts/tracing/draw_functrace.py
@@ -12,10 +12,10 @@ calls. Only the functions's names and the the call time are provided.
 
 Usage:
 	Be sure that you have CONFIG_FUNCTION_TRACER
-	# mkdir /debugfs
-	# mount -t debug debug /debug
-	# echo function > /debug/tracing/current_tracer
-	$ cat /debug/tracing/trace_pipe > ~/raw_trace_func
+	# mkdir /sys/kernel/debug
+	# mount -t debug debug /sys/kernel/debug
+	# echo function > /sys/kernel/debug/tracing/current_tracer
+	$ cat /sys/kernel/debug/tracing/trace_pipe > ~/raw_trace_func
 	Wait some times but not too much, the script is a bit slow.
 	Break the pipe (Ctrl + Z)
 	$ scripts/draw_functrace.py < raw_trace_func > draw_functrace
-- 
1.6.3.1

 
-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim (  S A M S U N G     E L E C T R O N I C S  )
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://blog.naver.com/invain/
-----------------------------------------------

