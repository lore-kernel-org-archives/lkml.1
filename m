Return-Path: <linux-kernel-owner+w=401wt.eu-S1760564AbXFAB0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564AbXFAB0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758734AbXFAB0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:26:25 -0400
Received: from mylar.outflux.net ([69.93.193.226]:60273 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757569AbXFAB0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:26:24 -0400
Date: Thu, 31 May 2007 17:47:29 -0700
From: Kees Cook <kees@outflux.net>
To: linux-kernel@vger.kernel.org
Subject: Documentation: /proc/$pid/stat files
Message-ID: <20070601004729.GR14736@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Outflux
X-HELO: gorgon.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to see the "stat" file documented (I always have to go looking
for it).  Thanks to Bharadwaj Yadavalli[1] and fs/proc/array.c, I've got
most of it, but I'm not an expert in this area.  :)  I've included my
"pending" patch below for reference.

Can someone give me a short description of the following fields?

  wchan
  exit_signal
  policy
  blkio_ticks

Thanks,

-Kees

[1] http://www.red-hat.com/archives/axp-list/2001-January/msg00355.html

---
--- linux-2.6.22-rc3-git4/Documentation/filesystems/proc.txt.pre	2007-05-31 17:17:20.000000000 -0700
+++ linux-2.6.22-rc3-git4/Documentation/filesystems/proc.txt	2007-05-31 17:40:06.000000000 -0700
@@ -171,7 +171,9 @@ read the file /proc/PID/status:
 This shows you nearly the same information you would get if you viewed it with
 the ps  command.  In  fact,  ps  uses  the  proc  file  system  to  obtain its
 information. The  statm  file  contains  more  detailed  information about the
-process memory usage. Its seven fields are explained in Table 1-2.
+process memory usage. Its seven fields are explained in Table 1-2.  The stat
+file contains details information about the process itself.  Its fields are
+explained in Table 1-3.
 
 
 Table 1-2: Contents of the statm files (as of 2.6.8-rc3)
@@ -188,16 +190,64 @@ Table 1-2: Contents of the statm files (
  dt       number of dirty pages			(always 0 on 2.6)
 ..............................................................................
 
+
+Table 1-3: Contents of the stat files (as of 2.6.22-rc3)
+..............................................................................
+ Field          Content
+  pid           process id
+  tcomm         filename of the executable
+  state         state (R is running, S is sleeping, D is sleeping in an
+                uninterruptible wait, Z is zombie, T is traced or stopped)
+  ppid          process id of the parent process
+  pgrp          pgrp of the process
+  sid           session id
+  tty_nr        tty the process uses
+  tty_pgrp      pgrp of the tty
+  flags         task flags
+  min_flt       number of minor faults
+  cmin_flt      number of minor faults with child's
+  maj_flt       number of major faults
+  cmaj_flt      number of major faults with child's
+  utime         user mode jiffies
+  stime         kernel mode jiffies
+  cutime        user mode jiffies with child's
+  cstime        kernel mode jiffies with child's
+  priority      priority level
+  nice          nice level
+  num_threads   number of threads
+  start_time    time the process started after system boot
+  vsize         virtual memory size
+  rss           resident set memory size
+  rsslim        current limit in bytes on the rss
+  start_code    address above which program text can run
+  end_code      address below which program text can run 
+  start_stack   address of the start of the stack 
+  esp           current value of ESP
+  eip           current value of EIP
+  pending       bitmap of pending signals (obsolete)
+  blocked       bitmap of blocked signals (obsolete)
+  sigign        bitmap of ignored signals (obsolete)
+  sigcatch      bitmap of catched signals (obsolete)
+  wchan         ?
+  0             (place holder)
+  0             (place holder)
+  exit_signal   ?
+  task_cpu      which CPU the task is scheduled on
+  rt_priority   realtime priority
+  policy        ?
+  blkio_ticks   ?
+..............................................................................
+
 1.2 Kernel data
 ---------------
 
 Similar to  the  process entries, the kernel data files give information about
 the running kernel. The files used to obtain this information are contained in
-/proc and  are  listed  in Table 1-3. Not all of these will be present in your
+/proc and  are  listed  in Table 1-4. Not all of these will be present in your
 system. It  depends  on the kernel configuration and the loaded modules, which
 files are there, and which are missing.
 
-Table 1-3: Kernel info in /proc 
+Table 1-4: Kernel info in /proc 
 ..............................................................................
  File        Content                                           
  apm         Advanced power management info                    
@@ -473,10 +523,10 @@ IDE devices:
 
 More detailed  information  can  be  found  in  the  controller  specific
 subdirectories. These  are  named  ide0,  ide1  and  so  on.  Each  of  these
-directories contains the files shown in table 1-4.
+directories contains the files shown in table 1-5.
 
 
-Table 1-4: IDE controller info in  /proc/ide/ide? 
+Table 1-5: IDE controller info in  /proc/ide/ide? 
 ..............................................................................
  File    Content                                 
  channel IDE channel (0 or 1)                    
@@ -486,11 +536,11 @@ Table 1-4: IDE controller info in  /proc
 ..............................................................................
 
 Each device  connected  to  a  controller  has  a separate subdirectory in the
-controllers directory.  The  files  listed in table 1-5 are contained in these
+controllers directory.  The  files  listed in table 1-6 are contained in these
 directories.
 
 
-Table 1-5: IDE device information 
+Table 1-6: IDE device information 
 ..............................................................................
  File             Content                                    
  cache            The cache                                  
---

-- 
Kees Cook                                            @outflux.net
