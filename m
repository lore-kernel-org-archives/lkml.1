Return-Path: <linux-kernel-owner+w=401wt.eu-S1761942AbYEARHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761942AbYEARHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759197AbYEARHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:07:23 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53399 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757307AbYEARHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:07:21 -0400
Subject: [LTP] [ANNOUNCE] The Linux Test Project has been Released for
	APRIL 2008
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sourceforge.net>,
       ltp-announce <ltp-announce@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: multipart/mixed; boundary="=-AIs8vQRr8VUSZTxtrBaT"
Organization: IBM
Date: Thu, 01 May 2008 22:36:57 +0530
Message-Id: <1209661618.4798.34.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AIs8vQRr8VUSZTxtrBaT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Dear All,

The Linux Test Project test suite has been released for the month of
APRIL 2008. The latest version of the test-suite contains 3000+ tests
for the Linux OS and can be found at
http://ltp.sourceforge.net/.
Latest happenings in LTP can also be found at:
http://ltp.sourceforge.net/wiki/,
http://ltp.sourceforge.net/wikiArchives.php, and,
IRC: irc.freenode.org #ltp.


APRIL 2008 Highlights:

* Release of LTP Development RPMs enabling Kernel developers to create
standalone LTP unit test case(s),
* Addition of Initial set of MEMORY CONTROLLER test cases,
* Cleanups for existing CPU CONTROLLER test cases,
* Continuing work for Concurrency fixes,
* Cleanup/Updates to LTP Real Time test cases,
* Cleanup/Updates to LTP SELinux test cases,
* SGI Common Criteria CAPP/LSPP EAL4+ certification test suite Release,
* Release of gcov-kernel patches for Linux 2.6.25,
* A Paper on LTP´s progress has been submitted to OLS 2008 committee.



Note(s) from the Maintainer:

Kerlabs kept the wheel rolling for fixing the concurrency issues. RT
tree cleanup and updates has become very common. Hope this brings good
news to the RT Linux community and users. The SELinux community has kept
their LTP test cases up-to-date. SGI has chosen LTP to release their
common criteria certification testsuite. And as promised earlier, we
brought in the initial set of MEMORY controller tests to LTP with
cleanups for the existing CPU controller test cases. But equally
disappointing to see that new test cases from others in the community
are not flowing into LTP. The maintainer has worked to put forward a
Paper on LTP´s progress in OLS 2008. Hope this will generate enthusiasm
among other members of the community.

I would reiterate my request to engineers across Linux Distros to kindly
consider integrating the enhancements/fixes they might have done to
their local LTP suit to the Global LTP Project.


Our web site also contains other information such as:
- A Linux test tools matrix
- Technical papers
- How To's on Linux testing
- Code coverage analysis tool.


We would encourage the community to post results to
ltp-results@lists.sf.net,
patches, new tests, bugs or comments/questions to ltp-list@lists.sf.net,
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=103382
(for New Bug(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=303382
(for New Patch(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=353382
(for New Feature Request(s))

Please also see the Change Log Attached (APRIL 2008):

Happy testing, 
Regards-- 
Subrata,

--=-AIs8vQRr8VUSZTxtrBaT
Content-Disposition: attachment; filename=April-2008_Changelog.txt
Content-Type: text/plain; name=April-2008_Changelog.txt; charset=UTF-8
Content-Transfer-Encoding: 8bit

1) Log Message:
Addition of SPEC File for creation of LTP-DEVEL RPMs on various Architectures for Standalone development of LTP Unit Testcase. Contributed by George Kraft <gk4@us.ibm.com>

Modified File(s):
ltp/Makefile
ltp/lib/Makefile
ltp/pan/Makefile

Added File(s):
ltp/README.ltp-devel
ltp/ltp-devel.spec
ltp/doc/man1/Makefile
ltp/doc/man3/Makefile
ltp/include/Makefile
ltp/lib/ltp.pc

2) Log Message:
This patch should solve the problem of RT Linux Compilation Failure on various Architectures. It just avoids the compilation of realtime tests on a non (x86,ppc) arch. Assumption: uname -m doesn't contain 86/ppc on any arch except the x86 and ppc. Signed-Off-By: Chirag <chirag@linux.vnet.ibm.com>

Modified File(s):
ltp/testcases/Makefile

3) Log Message:
Previously I was under the impression that selinux test was not cleaning up properly. I don't believe that to be the case. I must have been mistaken. Here is a patch for the allow_domain_fd_use boolean issue in 5.2, by, Jeff Burke <jburke@redhat.com>

Modified File(s):
ltp/testscripts/test_selinux.sh

4) Log Message:
This patch, which is independent of Jeff's patch, updates the selinux testsuite to run under Fedora 9, and does no harm on Fedora 8. While creating this, I noticed two other things that ultimately need fixing: 
1) The sbin_deprecated.patch adds domain_dyntrans_type() to all the test domains.  If that was truly desired, we should just put it into unconfined_runs_test().  But it shouldn't be necessary - only the test_dyntrans.te and test_dyntrace.te domains should require permissions for dynamic transitions.  I'll let Serge confirm that. 
2) The test scripts are presently relabeling /tmp to test_file_t for the duration of the test.  That's insane - it could break any other running process that tries to access /tmp during the test.  That was not part of our original selinux testsuite and seems to have been introduced when IBM ported it to LTP.  If you are worried about lacking search permission to /tmp in the test domains, then create your own private /test directory or something.  Or just give all test domains permission to search tmp either via unconfined_runs_test() or in test_global.te using the testdomain attribute. Those don't need to be fixed though for this patch to be merged. Also, I noticed some new failures in the tests due to latest Fedora policies giving all domains search permission to all directories.  Not sure if that was intentional - sent a separate note to Dan about that.

Modified File(s):
ltp/testcases/kernel/security/selinux-testsuite/misc/sbin_deprecated.patch
ltp/testcases/kernel/security/selinux-testsuite/tests/runtest.sh
ltp/testscripts/test_selinux.sh

5) Log Message:
Ok here is a first small patch to stop relabeling /tmp as Stephen suggested. It should be no more complicated to get rid of the unneeded dyntrans_types, but I messed up somewhere generating the patch and subsequent test bombed.  So I'll just do that next week or whenever this patch hits cvs (for simplicity). Subject: selinux testsuite: don't relabel /tmp. There's no need for the selinux testsuite to relabel /tmp for the duration of the test.  It uses /tmp/selinux anyway.  Just need to be sure to have search perms to tmp_t. Signed-off-by: Serge Hallyn <serue@us.ibm.com>

Modified File(s):
ltp/testcases/kernel/security/selinux-testsuite/policy/test_global.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_global.te
ltp/testscripts/test_selinux.sh

6) Log Message:
dont build things statically, by, Mike Frysinger <vapier@users.sourceforge.net>

Modified File(s):
ltp/testcases/kernel/syscalls/inotify/Makefile

7) Log Message:
anal fix: add whitespace between arguments, by, Mike Frysinger <vapier@users.sourceforge.net>

Modified File(s):
ltp/testcases/kernel/syscalls/fcntl/fcntl23.c
ltp/testcases/kernel/syscalls/fcntl/fcntl24.c
ltp/testcases/kernel/syscalls/fcntl/fcntl25.c
ltp/testcases/kernel/syscalls/fcntl/fcntl26.c
ltp/testcases/kernel/syscalls/fcntl/fcntl27.c
ltp/testcases/kernel/syscalls/fcntl/fcntl28.c

8) Log Message:
This patch remove the useless random function used in getipckey. This random value has been replaced by a static int incremented at each call. This allow to remove the ugly whiles around the getipckey calls when we need several keys, by, Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>

File(s) Updated:
ltp/testcases/kernel/syscalls/ipc/lib/libipc.c
ltp/testcases/kernel/syscalls/ipc/semop/semop02.c
ltp/testcases/kernel/syscalls/ipc/shmat/shmat02.c
ltp/testcases/kernel/syscalls/ipc/shmctl/shmctl02.c
ltp/testcases/kernel/syscalls/ipc/shmget/shmget02.c

9) Log Message:
This patch fixes a concurrency issue in msgget02. The second key used for this test was sometime conflicting with the key from another task due to a bad way of creating keys. This patch generate a valid second key through getipckey to avoid conflicts. Signed-off-by: Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>

Modified File(s):
ltp/testcases/kernel/syscalls/ipc/msgget/msgget02.c

10) Log Message:
These patch removes a IPC leak in case of test failure. When the msgget function succeed instead of returning  ENOSPC, the returned IPC was not released, by, Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>

Modified File(s):
ltp/testcases/kernel/syscalls/ipc/msgget/msgget03.c

11) Log Message:
This patch fixes a concurrency issue un shmctl01. Synchronization between processes was done using sleeps, which is not enough when multiple instances of the test are running or when we are running on loaded CPUs, by, Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>

Modified File(s):
ltp/testcases/kernel/syscalls/ipc/shmctl/Makefile
ltp/testcases/kernel/syscalls/ipc/shmctl/shmctl01.

12) Log Message:
Fix concurrency issue in msgctl04. The second key used for this test could conflict with the key from another task. Signed-off-by: Matthieu Fertré <mfertre@irisa.fr>

Modified Files:
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl04.c

13 Log Message:
Fix concurrency issue in msgctl06. Signed-off-by: Matthieu Fertré <mfertre@irisa.fr>

Modified Files:
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl06.c

14) Log Message:
This patch fix a concurrency issue in msgctl07, by, Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>

Modified Files:
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl07.c

15) Log Message:
Fix concurrency issue. The second key used for this test could conflict with the key from another task. Signed-off-by: Matthieu Fertré <mfertre@irisa.fr> 

Modified Files:
ltp/testcases/kernel/syscalls/ipc/msgrcv/msgrcv02.c

16) Log Message:
Fix concurrency issue in msgrcv05. Due to the use of usleep function to synchronize processes, synchronization issues can occur on a loaded system. Fix this by using pipes to synchronize processes. Signed-off-by: Matthieu Fertré <mfertre@irisa.fr>

Modified Files:
ltp/testcases/kernel/syscalls/ipc/msgrcv/msgrcv05.c

17) Log Message:
Fix concurrency issue in msgrcv06. Due to the use of usleep function to synchronize processes, synchronization issues can occur on a loaded system. Fix this by using pipes to synchronize processes. Signed-off-by: Matthieu Fertré <mfertre@irisa.fr>

Modified Files:
ltp/testcases/kernel/syscalls/ipc/msgrcv/Makefile
ltp/testcases/kernel/syscalls/ipc/msgrcv/msgrcv06.c

18) Log Message:
Fix concurrency issue in msgsnd05. Due to the use of usleep function to synchronize processes, synchronization issues can occur on a loaded system. Fix this by using pipes to synchronize processes. Signed-off-by: Matthieu Fertré <mfertre@irisa.fr>

Modified Files:
ltp/testcases/kernel/syscalls/ipc/msgsnd/Makefile
ltp/testcases/kernel/syscalls/ipc/msgsnd/msgsnd05.c

19) Log Message:
Fix concurrency issue in msgsnd06. Due to the use of usleep function to synchronize processes, synchronization issues can occur on a loaded system. Fix this by using pipes to synchronize processes. Signed-off-by: Matthieu Fertré <mfertre@irisa.fr>

Modified Files:
ltp/testcases/kernel/syscalls/ipc/msgsnd/msgsnd06.c

20) Log Message:
Fix concurrency issue in semget05. Create private semaphores to avoid conflict with concurrent processes. Signed-off-by: Matthieu Fertré <mfertre@irisa.fr>

Modified Files:
ltp/testcases/kernel/syscalls/ipc/semget/semget05.c

21) Log Message:
Fix concurrency issue in semop05. Due to the use of usleep function to synchronize processes, synchronization issues can occur on a loaded system. Fix this by using pipes to synchronize processes. Signed-off-by: Matthieu Fertré <mfertre@irisa.fr>

Modified Files:
ltp/testcases/kernel/syscalls/ipc/semop/Makefile
ltp/testcases/kernel/syscalls/ipc/semop/semop05.c

22) Log Message:
This patch reviews the networkstress.sh script and adds a menu to select the network stress tests. Hoping that could be useful, by, Giuseppe Cavallaro <peppe.cavallaro@gmail.com>

Modified File(s):
ltp/testscripts/networkstress.sh

23) Log Message:
Updated the test case as per the man page
***********
RETURN VALUE
       If  name  is  invalid, -1 is returned, and errno is set to EINVAL. Otherwise, the value returned is the value of the system resource and errno is not changed.  In the case of  options, a positive value is  returned  if  a queried option is available, and -1 if it is not.  In the case of limits, -1 means that  there is no definite limit
***********
Return value of sysconf needs to be checked as well and not only depend on errno value. Have made the changes by looking at the code from http://www.comptechdoc.org/os/linux/programming/c/linux_pgcpostest.html. Max Stirling <vicky.irobot@gmail.com>

Modified Files:
ltp/testcases/kernel/syscalls/sysconf/sysconf01.c

24) Log Message:
A patch to include all the headers for the ltp-devel package, by, George Kraft <gk4@austin.ibm.com>

Modified File(s):
ltp/ltp-devel.spec
ltp/include/Makefile

25) Log Message:
Fix from Vivi Li for stack overflows on no-mmu systems: declare large buffers in .bss rather than on the stack

Modified File(s):
ltp/testcases/kernel/syscalls/inotify/inotify01.c
ltp/testcases/kernel/syscalls/inotify/inotify02.c

26) Log Message:
Here is the patch to remove the unneeded dyntrans lines.  Causes no new failures on my f8 test image.
Subject: selinux testsuite: don't give away dyntrans
domain_dyntrans_type() only needs to be used for domains actually needing to do dynamic transitions.  Don't grant it to most domains. Signed-off-by: Serge Hallyn <serue@us.ibm.com>

Modified File(s):
ltp/testcases/kernel/security/selinux-testsuite/misc/sbin_deprecated.patch

27) Log Message:
Making these tests run as default with LTP run, by, Subrata Modak <subrata@linux.vnet.ibm.com>

Modified File(s):
ltp/runtest/fs
ltp/runtest/ipc
ltp/runtest/mm
ltp/runtest/sched

28) Log Message:
split CFLAGS/CPPFLAGS properly and remove inappropriate flags, by, Mike Frysinger <vapier@users.sourceforge.net>

Modified File(s):
ltp/testcases/realtime/config.mk

29) Log Message:
dont stick ar flags into AR, and dont set AR/RANLIB by default, by, Mike Frysinger <vapier@users.sourceforge.net>

Modified File(s):
ltp/testcases/realtime/lib/Makefile

30) Log Message:
setup default RANLIB, by, Mike Frysinger <vapier@users.sourceforge.net>

Modified File(s):
ltp/Makefile

31) Log Message:
checks return values of asprintf calls else gcc-4.3.0 fails like following;
...
libstats.c:308: error: ignoring return value of 'asprintf', declared with attribute warn_unused_result
libstats.c:312: error: ignoring return value of 'asprintf', declared with attribute warn_unused_result
...
Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
Acked-by: Chirag <chirag@linux.vnet.ibm.com>

Modified File(s):
ltp/testcases/realtime/func/periodic_cpu_load/periodic_cpu_load_single.c
ltp/testcases/realtime/lib/libstats.c

32) Log Message:
faccessat01 and fchmodat01 did not test the AT_FDCWD, following patch makes them test AT_FDCWD and pass. Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

Modified File(s):
ltp/testcases/kernel/syscalls/faccessat/faccessat01.c
ltp/testcases/kernel/syscalls/fchmodat/fchmodat01.c

33) Log Message:
According to Ulrich Drepper, times02 test is bogus (at least for archs which report return value and error in the same value) and times has no reserved error code. So following patch removes times02 from testsuite and moves times03 test to times02. For more information please see
http://sources.redhat.com/ml/libc-alpha/2008-04/msg00054.html and
http://sources.redhat.com/ml/libc-alpha/2008-04/msg00055.html.
Signed-off-by:
S.Çağlar Onur <caglar@pardus.org.tr>

Modified File(s):
ltp/doc/testcases/kernel.txt
ltp/runtest/ltplite
ltp/runtest/stress.part3
ltp/runtest/syscalls
Removed File(s):
ltp/testcases/kernel/syscalls/times/times02.c

34) Log Message:
This turned out to be a test case problem, where it fails to identify the correct backbone network interface to use for the test. But there is an option already provided for the interface to be specified while invoking the test. Here, eth1 is the backbone interface and hence if the test is invoked like 'IFNAME=eth1 ./tcpdump01' it will pass. But it relies on DNS lookup and requires the IP to be configured accordingly. Signed-off-by: Anoop Vijayan
<anoop.vijayan@in.ibm.com>

Modified File(s):
ltp/testcases/network/tcp_cmds/tcpdump/tcpdump01

35) Log Message:
Now that the realtime tests are part of the LTP, there is no need to have any
longer specific compilation directives comments in the source files. And in
most cases they are incorrect. Signed-off-by: Sebastien Dugue
<sebastien.dugue@bull.net>. Cc: Darren Hart <dvhltc@us.ibm.com>

Modified Files:
ltp/testcases/realtime/func/async_handler/async_handler.c
ltp/testcases/realtime/func/async_handler/async_handler_jk.c
ltp/testcases/realtime/func/async_handler/async_handler_tsc.c
ltp/testcases/realtime/func/gtod_latency/gtod_infinite.c
ltp/testcases/realtime/func/gtod_latency/gtod_latency.c
ltp/testcases/realtime/func/hrtimer-prio/hrtimer-prio.c
ltp/testcases/realtime/func/matrix_mult/matrix_mult.c
ltp/testcases/realtime/func/measurement/preempt_timing.c
ltp/testcases/realtime/func/measurement/rdtsc-latency.c
ltp/testcases/realtime/func/periodic_cpu_load/periodic_cpu_load.c
ltp/testcases/realtime/func/periodic_cpu_load/periodic_cpu_load_single.c
ltp/testcases/realtime/func/pi-tests/sbrk_mutex.c
ltp/testcases/realtime/func/pi-tests/test-skeleton.c
ltp/testcases/realtime/func/pi-tests/testpi-0.c
ltp/testcases/realtime/func/pi-tests/testpi-1.c
ltp/testcases/realtime/func/pi-tests/testpi-2.c
ltp/testcases/realtime/func/pi-tests/testpi-4.c
ltp/testcases/realtime/func/pi-tests/testpi-5.c
ltp/testcases/realtime/func/pi-tests/testpi-6.c
ltp/testcases/realtime/func/pi-tests/testpi-7.c
ltp/testcases/realtime/func/pi_perf/pi_perf.c
ltp/testcases/realtime/func/prio-preempt/prio-preempt.c
ltp/testcases/realtime/func/prio-wake/prio-wake.c
ltp/testcases/realtime/func/pthread_kill_latency/pthread_kill_latency.c
ltp/testcases/realtime/func/thread_clock/tc-2.c
ltp/testcases/realtime/include/libjvmsim.h
ltp/testcases/realtime/include/libstats.h
ltp/testcases/realtime/include/list.h
ltp/testcases/realtime/lib/libjvmsim.c
ltp/testcases/realtime/lib/libstats.c
ltp/testcases/realtime/perf/latency/pthread_cond_latency.c
ltp/testcases/realtime/perf/latency/pthread_cond_many.c
ltp/testcases/realtime/stress/pi-tests/lookup_pi_state.c
ltp/testcases/realtime/stress/pi-tests/testpi-3.c

36) Log Message:
pi_perf is not built by default, so add it to SUBDIRS in
testcases/realtime/Makefile. Signed-off-by: Sebastien Dugue
<sebastien.dugue@bull.net>. Acked-by: Chirag <chirag@linux.vnet.ibm.com>

Modified Files:
ltp/testcases/realtime/func/Makefile

37) Log Message:
The rttest, stats and jvmsim library archives used by the realtime tests only
contain a single object file each. Therefore we can skip the "ar" and "ranlib"
steps and directly link with the objects. Signed-off-by: Sebastien Dugue
<sebastien.dugue@bull.net>. Acked-by: Chirag <chirag@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/realtime/config.mk
ltp/testcases/realtime/lib/Makefile

38) Log Message:
periodic_cpu_load has a '-i iterations' command line argument without it being
listed in the help. Add its description to the usage() function.
Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>. Acked-by: Chirag
<chirag@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/realtime/func/periodic_cpu_load/periodic_cpu_load.c

39) Log Message:
Some tests have a configurable number of iterations. However those same tests
which do calculate quantiles need a number of iterations higher than 100.
Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>. Acked-by: Chirag
<chirag@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/realtime/func/periodic_cpu_load/periodic_cpu_load.c
ltp/testcases/realtime/func/periodic_cpu_load/periodic_cpu_load_single.c
ltp/testcases/realtime/func/pi_perf/pi_perf.c

40) Log Message:
Remove the last 2 files missed in the migration, namely:
testcases/realtime/stress/pi-tests/GNUmakefile.am
testcases/realtime/stress/pi-tests/GNUmakefile.in
Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>

Removed Files:
ltp/testcases/realtime/stress/pi-tests/GNUmakefile.am
ltp/testcases/realtime/stress/pi-tests/GNUmakefile.in

41) Log Message:
In the expected scenario, it attempts to execve(2) a file which is being opened by another process for writing fails with ETXTBS. On a loaded system, however, the child which does execve might get access to the file before the other child which opens it and result in a unexpected opening fail. By Roy Lee <roylee17@gmail.com>

Modified Files:
ltp/testcases/kernel/syscalls/execve/Makefile
ltp/testcases/kernel/syscalls/execve/execve05.c

42) Log Message:
I think there is a problem with the previous patch. Since you call the wait_son_startup() function after the fork() and before the test on the PID variable, the father AND the son will wait on the pipe, leading to a dead-lock. I suggest to move the wait_son_startup() calls after the pid test. Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>. Cha
nges by Roy Lee <roylee17@gmail.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/execve/execve05.c

43) Log Message:
This patch fix a concurrency issue in execve02. In case of concurrent executions, all tasks was using the same file, changing its mode and leading to invalid mode for some of them. This patch creates a private tmp directory for each task, copies the test file in it and performs all the tests using this private file. Regards Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>

Modified File(s):
ltp/testcases/kernel/syscalls/execve/execve02.c

44) Log Message:
This patch fixes a concurrency issue in ftruncate04. In the expected scenario, child should hold the lock of the file before parent access it. On a loaded system, however, the parent might access the file before the child, hence resulting in a unexpected 'open fail'. By, Roy Lee <roylee17@gmail.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/ftruncate/Makefile
ltp/testcases/kernel/syscalls/ftruncate/ftruncate04.c

45) Log Message:
The following patch and all others that were submitted in Feb, 2008 pertaining to "__NR_fadvise64" seem to break ARM builds of ltp as the arm does not have __NR_fadvise64 defined.  I suspect there should be
#ifndef __NR_fadvise64
#define __NR_fadvise64 0
in each of the files that the patches were added. By, Shane Volpe <shanevolpe@gmail.com>

Modified File(s):
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise01.c
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise02.c
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise03.c
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise04.c

46) Log Message:
The Linux port I run on LTP has a minimal set of system calls. It currently does not implement the sysfs system call so I'd like to disable the tests for this system call - at the moment they will fail to compile because __NR_sysfs is undefined. Is there an idiomatic way of doing this? I can either prevent the test compiling completely somehow in the Makefile (e.g. as modify_ldt does) or make the test compile but return BROK perhaps. Attached is a patch to implement a strategy like this one. By Will Newton <will.newton@gmail.com>

Modified File(s):
ltp/testcases/kernel/syscalls/sysfs/sysfs01.c
ltp/testcases/kernel/syscalls/sysfs/sysfs02.c
ltp/testcases/kernel/syscalls/sysfs/sysfs03.c
ltp/testcases/kernel/syscalls/sysfs/sysfs04.c
ltp/testcases/kernel/syscalls/sysfs/sysfs05.c
ltp/testcases/kernel/syscalls/sysfs/sysfs06.c

47) Log Message:
Executing f00f testcase in x86 Xeon machines, it failed returning SIGSEGV:
# ./f00f
f00f        0  INFO  :  Testing for proper f00f instruction handling.
Segmentation fault

Searching for this issue, I found an old thread in ltp-list discussing broken test-cases (http://sourceforge.net/mailarchive/message.php?msg_id=46E5998B.9070903%40redhat.com), where Jeff Burke raise this problem with f00f failing on systems that have the NX bit. But, according to the flags reported in /proc/cpuinfo, the machines where i'm running this testcase seems not to have this NX bit enabled. On /proc/cpuinfo, we also have this line "f00f_bug: no". Would it be useful to select if this testcase should be executed or not? These machines are running a kernel compiled with processor family "Pentium-Pro" (CONFIG_M686=y), which, in according to the kernel config help, "disables the init-time guard against the f00f bug found in earlier Pentiums". Here i have created a patch that seems to fix the testcase using an inline assembly. By, Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/misc/f00f/f00f.c

48) Log Message:
nptl01 looks to have an operator precedence bug in it that prevents the output being done at appropriate times. With this patch you should get 10 lines of output, one every 10000 loops, rather than 10 lines of output, one for each of the first 10 loops. By, Will Newton <will.newton@gmail.com>.

Modified File(s):
ltp/testcases/kernel/sched/nptl/nptl01.c

49) Log Message:
I believe we had written this test to debug the other test with a lower overhead clocksource.  Unfortunately, the tsc is x86 specific, isn't consistent across CPUs on certain systems, and can have it's frequency changed depending on by power states. For all those reasons this test can simply be removed from the LTP. Raied by Daniel Gollub <dgollub@suse.de>, endorsed by Sebastien Dugue <sebastien.dugue@bull.net>, seconded by Darren Hart <dvhltc@us.ibm.com>.

Removed File(s):
ltp/testcases/realtime/func/async_handler/run_auto.sh

50) Log Message:
This patch removes the dependency of existing tty* devices for this test to pass, and also ups the invalid file descriptor value from 400 to 1025 which is used to confirm the EBADF errno. By, Henry Yei <hyei@mvista.com>

Modified File(s):
ltp/testcases/kernel/syscalls/sockioctl/sockioctl01.c

51) Log Message:
Attached is a patch to ltp/lib/Makefile that fixes Solaris cross-building. For some reason the variable CC was overridden with gcc -Wall which caused it to use the system compiler. By Henry Yei <hyei@mvista.com>

Modified File(s):
ltp/lib/Makefile

52) Log Message:
overhaul script to make things much easier to manage by Garrett Cooper <yanegomi@gmail.com>

Modified File(s):
ltp/IDcheck.sh

53) Log Message:
simplify targets, by, Mike Frysinger <vapier@users.sourceforge.net>

Modified File(s):
ltp/testcases/kernel/fs/fs_perms/Makefile

54) Log Message:
cleanup code and add error checking, by, Mike Frysinger <vapier@users.sourceforge.net>

Modified File(s):
ltp/testcases/kernel/fs/fs_perms/Makefile
ltp/testcases/kernel/fs/fs_perms/fs_perms.c

55) Log Message:
Attached is a patch to ltp/lib/Makefile that fixes Solaris cross-building. For some reason the variable CC was overridden with gcc -Wall which caused it to use the system compiler. Also fixes cross-building for the filecaps tests. By, Henry Yei <hyei@mvista.com>.

Modified File(s):
ltp/testcases/kernel/security/filecaps/Makefile
ltp/testcases/kernel/security/filecaps/checkforlibcap.sh

56) Log Message:
The float_bessel testcases, as a matter of fact, all float_* testcases seem to fail when multiple instances are run concurrently. The failures occur because file sizes don't match or because the number of bytes read don't match the file size. This can be attributed to the parallel instance reading a file before the write to it (by another instance) has completed. In such situations, either the file size has not been updated in the inode header or the file size has been updated but the file's write operation has not been updated completely. To fix this concurrency problem, my suggestion is to check for an existing instance and wait for it to finish before beginning the current instance. Any other concurrency resolution technique may complicate matters. A message to the console indicating such a decision might be added. By Sridhar Vinay <vinaysridhar@in.ibm.com> & Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>.

Modified File(s):
ltp/testcases/misc/math/float/main.c
ltp/testcases/misc/math/float/bessel/genbessel.c
ltp/testcases/misc/math/float/exp_log/genexp_log.c
ltp/testcases/misc/math/float/iperb/geniperb.c
ltp/testcases/misc/math/float/power/genpower.c
ltp/testcases/misc/math/float/trigo/gentrigo.c

57) Log Message:
Some Cleanups for CPU Controller Test Cases by Sudhir Kumar. Signed-off-by: Sudhir Kumar <skumar@linux.vnet.ibm.com>, Acked-by: Dhaval Giani
<dhaval@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/kernel/controllers/test_controllers.sh
ltp/testcases/kernel/controllers/testplan.txt
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test01.c
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test02.c
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test03.c
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test04.c
ltp/testcases/kernel/controllers/cpuctl/cpuctl_testplan.txt
ltp/testcases/kernel/controllers/cpuctl/parameters.sh
ltp/testcases/kernel/controllers/cpuctl/run_cpuctl_stress_test.sh
ltp/testcases/kernel/controllers/cpuctl/run_cpuctl_test.sh
ltp/testcases/kernel/controllers/libcontrollers/libcontrollers.c
ltp/testcases/kernel/controllers/libcontrollers/libcontrollers.h

58) Log Message:
Initial Set of MEMORY CONTROLLER Test Cases Added to LTP by Sudhir Kumar. Signed-off-by: Sudhir Kumar <skumar@linux.vnet.ibm.com>, Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/controllers/Makefile
ltp/testcases/kernel/controllers/test_controllers.sh
Added Files:
ltp/testcases/kernel/controllers/memctl/Makefile
ltp/testcases/kernel/controllers/memctl/memctl_test01.c
ltp/testcases/kernel/controllers/memctl/myfunctions.sh
ltp/testcases/kernel/controllers/memctl/run_memctl_test.sh

--=-AIs8vQRr8VUSZTxtrBaT--

