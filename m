Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbZLCOEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbZLCOEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 09:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbZLCOEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 09:04:36 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33298 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170AbZLCOEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 09:04:32 -0500
Subject: [ANNOUNCE] The Linux Test Project has been Released for NOVEMBER
	2009
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sf.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Garrett Cooper <yanegomi@gmail.com>, Mike Frysinger <vapier@gentoo.org>,
       Jiri Palecek <jpalecek@web.de>, Randy Dunlap <rdunlap@xenotime.net>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Cyril Hrubis <chrubis@suse.cz>,
       Shi Weihua <shiwh@cn.fujitsu.com>, Wei Yongjun <yjwei@cn.fujitsu.com>,
       Henry Yei <hyei@mvista.com>, Liu Bo <liubo2009@cn.fujitsu.com>,
       Giuseppe Cavallaro <peppe.cavallaro@st.com>,
       Tomonori Mitani <mitani@ryobi.co.jp>, Andrew Vagin <avagin@gmail.com>
Content-Type: multipart/mixed; boundary="=-ZiuJlfagBgEFheJgnlpU"
Organization: IBM
Date: Thu, 03 Dec 2009 19:34:19 +0530
Message-Id: <1259849059.5085.17.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZiuJlfagBgEFheJgnlpU
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi,

The Linux Test Project test suite has been released for the month of
NOVEMBER 2009. Please see ltp/INSTALL file carefully, as, there has
been multiple changes for building/installing the test suite after the
recent changes in Makefile infrastructure.

The latest version of the test-suite contains 3000+ tests for the Linux
OS and can be found at:
http://ltp.sourceforge.net/,
Latest happenings in LTP can also be found at:
http://ltp.sourceforge.net/wiki/,
http://ltp.sourceforge.net/wikiArchives.php, and,
IRC: irc.freenode.org #ltp.

========================
NOVEMBER 2009 Highlights:
======================== 
     1. Cleanup and stabilization of new build system for distros with
        older kernels, 
     2. Addition of EXECLTP - A Python script that is more user
        friendly,
------------------------------

==============================
NOVEMBER 2009 LTP Contributors:
============================== 
     1. Garrett Cooper, 
     2. Mike Frysinger, 
     3. Jiri Palecek, 
     4. Randy Dunlap, 
     5. Serge E. Hallyn, 
     6. Cyril Hrubis, 
     7. Shi Weihua, 
     8. Wei Yongjun, 
     9. Henry Yei, 
    10. Liu Bo, 
    11. Giuseppe Cavallaro, 
    12. Tomonori Mitani, 
    13. Andrew Vagin,
------------------------------

==============================
Note(s) from the Maintainer:
==============================
Garrett continued with his effort to stabilize the new build system and tried to accommodate everybody´s problems. More than 80% of the changes this month are due to fixes by Garret. Thanks for such huge effort. Recently, hovering over some statistics i found that around 30 institutions contribute to LTP. This is a great news for us to cheer. We would hope that this count will keep increasing in future.

Our web site also contains other information such as:
- A Linux test tools matrix
- Technical papers
- How To's on Linux testing
- Code coverage analysis tool.

We would encourage the community to post results to
ltp-results@lists.sf.net,
patches, new tests, bugs or comments/questions to ltp-list@lists.sf.net,
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=103382 (for
New Bug(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=303382 (for
New Patch(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=353382 (for
New Feature Request(s))

Happy testing, 
Regards-- 
Subrata,


--=-ZiuJlfagBgEFheJgnlpU
Content-Disposition: attachment; filename=Nov-2009_Changelog.txt
Content-Type: text/plain; name=Nov-2009_Changelog.txt; charset=utf-8
Content-Transfer-Encoding: 8bit

1) Log Message:
Fix expected output in ar01 testcase: According to POSIX, the verbose output of "ar -tv" should not contain the leading zero in day-of-month (its format should be equivalent to %e specifier of date) [source: man(1posix)]. Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/commands/ade/ar/ar01

2) Log Message:
Use a saner variant for computing the number of groups in cpuctl tests: this patch changes the calculation of numer of groups in cpuctl test. The new code doesn't need bc, and is more comprehensible IMHO. Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/controllers/cpuctl/parameters.sh

3) Log Message:
Other compiler warning fixes: this is another chunk of compiler warning fixes in LTP tests, related to printf format strings. They have multiple causes:
- most of them are caused by %d used for the TEST_RETURN variable (as in a previous patch),
- off_t are cast to (int64_t) and PRId64 output specifier is used for them,
- other types are cast to (intmax_t) or (uintmax_t) and use the %jd or %ju (C99) output specifier. I've used this solution because it's generally correct, easy to use solution that is portable and (IMHO) more readable than using PRId64/PRIu64 and a cast (which you generally can't avoid). This way, there's only a cast,
- in ioperm test, address should be declared as unsigned long (according to ioperm(2)),
- other little fixes (foo vs. *foo, %S vs. %s, %0 vs. %o). 
Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/mem/hugetlb/hugeshmctl/hugeshmctl01.c
ltp/testcases/kernel/syscalls/fcntl/fcntl02.c
ltp/testcases/kernel/syscalls/fcntl/fcntl03.c
ltp/testcases/kernel/syscalls/fcntl/fcntl04.c
ltp/testcases/kernel/syscalls/fcntl/fcntl05.c
ltp/testcases/kernel/syscalls/fcntl/fcntl11.c
ltp/testcases/kernel/syscalls/fcntl/fcntl14.c
ltp/testcases/kernel/syscalls/fcntl/fcntl17.c
ltp/testcases/kernel/syscalls/fcntl/fcntl19.c
ltp/testcases/kernel/syscalls/fcntl/fcntl20.c
ltp/testcases/kernel/syscalls/fcntl/fcntl21.c
ltp/testcases/kernel/syscalls/fcntl/fcntl22.c
ltp/testcases/kernel/syscalls/fork/fork09.c
ltp/testcases/kernel/syscalls/ftruncate/ftruncate01.c
ltp/testcases/kernel/syscalls/ftruncate/ftruncate04.c
ltp/testcases/kernel/syscalls/gettimeofday/gettimeofday02.c
ltp/testcases/kernel/syscalls/inotify/inotify02.c
ltp/testcases/kernel/syscalls/ioperm/ioperm01.c
ltp/testcases/kernel/syscalls/ipc/semctl/semctl07.c
ltp/testcases/kernel/syscalls/keyctl/keyctl01.c
ltp/testcases/kernel/syscalls/llseek/llseek01.c
ltp/testcases/kernel/syscalls/lseek/lseek01.c
ltp/testcases/kernel/syscalls/lseek/lseek07.c
ltp/testcases/kernel/syscalls/mkdir/mkdir08.c
ltp/testcases/kernel/syscalls/mknod/mknod01.c
ltp/testcases/kernel/syscalls/mknod/mknod06.c
ltp/testcases/kernel/syscalls/mknod/mknod07.c
ltp/testcases/kernel/syscalls/mknod/mknod09.c
ltp/testcases/kernel/syscalls/mlockall/mlockall01.c
ltp/testcases/kernel/syscalls/mlockall/mlockall02.c
ltp/testcases/kernel/syscalls/mlockall/mlockall03.c
ltp/testcases/kernel/syscalls/move_pages/move_pages_support.c
ltp/testcases/kernel/syscalls/msync/msync03.c
ltp/testcases/kernel/syscalls/msync/msync04.c
ltp/testcases/kernel/syscalls/msync/msync05.c
ltp/testcases/kernel/syscalls/munlock/munlock01.c
ltp/testcases/kernel/syscalls/munlock/munlock02.c
ltp/testcases/kernel/syscalls/munlockall/munlockall01.c
ltp/testcases/kernel/syscalls/munmap/munmap03.c
ltp/testcases/kernel/syscalls/nanosleep/nanosleep01.c
ltp/testcases/kernel/syscalls/nanosleep/nanosleep02.c
ltp/testcases/kernel/syscalls/nanosleep/nanosleep03.c
ltp/testcases/kernel/syscalls/nanosleep/nanosleep04.c
ltp/testcases/kernel/syscalls/newuname/newuname01.c
ltp/testcases/kernel/syscalls/nice/nice04.c
ltp/testcases/kernel/syscalls/nice/nice05.c
ltp/testcases/kernel/syscalls/pathconf/pathconf01.c
ltp/testcases/kernel/syscalls/pipe/pipe03.c
ltp/testcases/kernel/syscalls/prctl/prctl01.c
ltp/testcases/kernel/syscalls/prctl/prctl02.c
ltp/testcases/kernel/syscalls/pread/pread01.c
ltp/testcases/kernel/syscalls/pread/pread02.c
ltp/testcases/kernel/syscalls/pread/pread03.c
ltp/testcases/kernel/syscalls/pselect/pselect01.c
ltp/testcases/kernel/syscalls/ptrace/ptrace03.c
ltp/testcases/kernel/syscalls/pwrite/pwrite01.c
ltp/testcases/kernel/syscalls/pwrite/pwrite02.c
ltp/testcases/kernel/syscalls/pwrite/pwrite03.c
ltp/testcases/kernel/syscalls/read/read01.c
ltp/testcases/kernel/syscalls/read/read04.c
ltp/testcases/kernel/syscalls/readlink/readlink01.c
ltp/testcases/kernel/syscalls/readlink/readlink02.c
ltp/testcases/kernel/syscalls/readlink/readlink03.c
ltp/testcases/kernel/syscalls/readlink/readlink04.c
ltp/testcases/kernel/syscalls/remap_file_pages/remap_file_pages01.c
ltp/testcases/kernel/syscalls/rename/rename02.c
ltp/testcases/kernel/syscalls/rmdir/rmdir04.c
ltp/testcases/kernel/syscalls/rt_sigaction/rt_sigaction01.c
ltp/testcases/kernel/syscalls/rt_sigaction/rt_sigaction02.c
ltp/testcases/kernel/syscalls/rt_sigaction/rt_sigaction03.c
ltp/testcases/kernel/syscalls/sched_get_priority_max/sched_get_priority_max01.c
ltp/testcases/kernel/syscalls/sched_get_priority_max/sched_get_priority_max02.c
ltp/testcases/kernel/syscalls/sched_get_priority_min/sched_get_priority_min01.c
ltp/testcases/kernel/syscalls/sched_get_priority_min/sched_get_priority_min02.c
ltp/testcases/kernel/syscalls/sched_getparam/sched_getparam01.c
ltp/testcases/kernel/syscalls/sched_getparam/sched_getparam02.c
ltp/testcases/kernel/syscalls/sched_rr_get_interval/sched_rr_get_interval01.c
ltp/testcases/kernel/syscalls/sched_rr_get_interval/sched_rr_get_interval02.c
ltp/testcases/kernel/syscalls/sched_rr_get_interval/sched_rr_get_interval03.c
ltp/testcases/kernel/syscalls/sched_setparam/sched_setparam01.c
ltp/testcases/kernel/syscalls/sched_setparam/sched_setparam02.c
ltp/testcases/kernel/syscalls/sched_setparam/sched_setparam03.c
ltp/testcases/kernel/syscalls/sched_setparam/sched_setparam05.c
ltp/testcases/kernel/syscalls/sendfile/sendfile02.c
ltp/testcases/kernel/syscalls/sendfile/sendfile06.c
ltp/testcases/kernel/syscalls/sendmsg/sendmsg01.c
ltp/testcases/kernel/syscalls/set_robust_list/set_robust_list01.c
ltp/testcases/kernel/syscalls/set_tid_address/set_tid_address01.c
ltp/testcases/kernel/syscalls/setdomainname/setdomainname01.c
ltp/testcases/kernel/syscalls/setfsgid/setfsgid01.c
ltp/testcases/kernel/syscalls/setfsgid/setfsgid02.c
ltp/testcases/kernel/syscalls/setfsgid/setfsgid03.c
ltp/testcases/kernel/syscalls/setfsuid/setfsuid01.c
ltp/testcases/kernel/syscalls/setfsuid/setfsuid02.c
ltp/testcases/kernel/syscalls/setfsuid/setfsuid03.c
ltp/testcases/kernel/syscalls/setgid/setgid01.c
ltp/testcases/kernel/syscalls/setgroups/setgroups01.c
ltp/testcases/kernel/syscalls/setgroups/setgroups03.c
ltp/testcases/kernel/syscalls/setgroups/setgroups04.c
ltp/testcases/kernel/syscalls/sethostname/sethostname01.c
ltp/testcases/kernel/syscalls/setpgid/setpgid01.c
ltp/testcases/kernel/syscalls/setpgrp/setpgrp01.c
ltp/testcases/kernel/syscalls/setregid/setregid01.c
ltp/testcases/kernel/syscalls/setregid/setregid02.c
ltp/testcases/kernel/syscalls/setregid/setregid04.c
ltp/testcases/kernel/syscalls/setreuid/setreuid01.c
ltp/testcases/kernel/syscalls/setreuid/setreuid02.c
ltp/testcases/kernel/syscalls/setsockopt/setsockopt01.c
ltp/testcases/kernel/syscalls/setuid/setuid01.c
ltp/testcases/kernel/syscalls/setuid/setuid02.c
ltp/testcases/kernel/syscalls/sgetmask/sgetmask01.c
ltp/testcases/kernel/syscalls/sigaltstack/sigaltstack02.c
ltp/testcases/kernel/syscalls/signal/signal04.c
ltp/testcases/kernel/syscalls/sigpending/sigpending02.c
ltp/testcases/kernel/syscalls/sigsuspend/sigsuspend01.c
ltp/testcases/kernel/syscalls/socketcall/socketcall01.c
ltp/testcases/kernel/syscalls/socketcall/socketcall03.c
ltp/testcases/kernel/syscalls/socketcall/socketcall04.c
ltp/testcases/kernel/syscalls/sockioctl/sockioctl01.c
ltp/testcases/kernel/syscalls/splice/splice01.c
ltp/testcases/kernel/syscalls/stat/stat03.c
ltp/testcases/kernel/syscalls/stat/stat05.c
ltp/testcases/kernel/syscalls/stat/stat06.c
ltp/testcases/kernel/syscalls/statfs/statfs01.c
ltp/testcases/kernel/syscalls/statfs/statfs03.c
ltp/testcases/kernel/syscalls/statvfs/statvfs01.c
ltp/testcases/kernel/syscalls/stime/stime02.c
ltp/testcases/kernel/syscalls/symlink/symlink01.c
ltp/testcases/kernel/syscalls/sync/sync01.c
ltp/testcases/kernel/syscalls/tee/tee01.c
ltp/testcases/kernel/syscalls/time/time01.c
ltp/testcases/kernel/syscalls/time/time02.c
ltp/testcases/kernel/syscalls/times/times03.c
ltp/testcases/kernel/syscalls/truncate/truncate01.c
ltp/testcases/kernel/syscalls/truncate/truncate03.c
ltp/testcases/kernel/syscalls/truncate/truncate04.c
ltp/testcases/kernel/syscalls/ulimit/ulimit01.c
ltp/testcases/kernel/syscalls/umask/umask01.c
ltp/testcases/kernel/syscalls/umask/umask03.c
ltp/testcases/kernel/syscalls/uname/uname01.c
ltp/testcases/kernel/syscalls/unlink/unlink05.c
ltp/testcases/kernel/syscalls/unlink/unlink06.c
ltp/testcases/kernel/syscalls/unlink/unlink07.c
ltp/testcases/kernel/syscalls/unlink/unlink08.c
ltp/testcases/kernel/syscalls/utime/utime06.c
ltp/testcases/kernel/syscalls/vmsplice/vmsplice01.c
ltp/testcases/kernel/syscalls/wait4/wait401.c
ltp/testcases/kernel/syscalls/write/write01.c
ltp/testcases/kernel/syscalls/writev/writev06.c
ltp/testcases/kernel/timers/clock_settime/clock_settime03.c
ltp/testcases/network/lib6/asapi_04.c
ltp/testcases/network/lib6/asapi_05.c
ltp/testcases/network/lib6/getaddrinfo_01.c
ltp/testcases/network/lib6/in6_02.c

4) Log Message:
Add an explicit requirement in the documentation stating that people need to have Gnu make 3.81, because many of the constructs in the new Makefile infrastructure will not work with prior versions of Gnu Make or other versions of Make. Garrett Cooper <yaberauneya@users.sourceforge.net>.

Modified Files:
ltp/INSTALL

5) Log Message:
extend autoconf ptrace tests. Mike Frysinger <vapier@users.sourceforge.net>.

Modified Files:
ltp/m4/ltp-ptrace.m4
ltp/testcases/kernel/controllers/freezer/vfork.c
ltp/testcases/kernel/syscalls/ptrace/ptrace01.c
ltp/testcases/kernel/syscalls/ptrace/ptrace02.c
ltp/testcases/kernel/syscalls/ptrace/ptrace03.c
ltp/testcases/kernel/syscalls/ptrace/ptrace04.c
ltp/testcases/kernel/syscalls/ptrace/ptrace05.c
ltp/testcases/kernel/syscalls/ptrace/ptrace06.c

6) Log Message:
define and use common clone helpers. From: Serge E. Hallyn <serue@us.ibm.com>. Define ltp_clone() and related helpers in libltp, and convert all existing clone usages to them. This way we no longer have arch-specific cruft cluttering up random source files all over the place.

Modified Files:
ltp/testcases/kernel/containers/utsname/Makefile
ltp/testcases/kernel/containers/utsname/check_utsns_enabled.c
ltp/testcases/kernel/containers/pidns/Makefile
ltp/testcases/kernel/containers/pidns/pidns12.c
ltp/testcases/kernel/containers/pidns/pidns13.c
ltp/testcases/kernel/containers/pidns/pidns16.c
ltp/testcases/kernel/containers/pidns/pidns20.c
ltp/testcases/kernel/containers/pidns/pidns21.c
ltp/testcases/kernel/containers/pidns/pidns30.c
ltp/testcases/kernel/containers/pidns/pidns31.c
ltp/testcases/kernel/fs/fs_bind/bin/Makefile
ltp/testcases/kernel/fs/fs_bind/bin/nsclone.c
ltp/testcases/kernel/controllers/cgroup/test_6_2.c
ltp/testcases/kernel/security/selinux-testsuite/tests/execshare/selinux_execshare_parent.c
ltp/include/mk/config.mk.default
ltp/include/mk/config.mk.in
ltp/testcases/kernel/security/tomoyo/Makefile
ltp/testcases/kernel/security/tomoyo/newns.c
ltp/testcases/kernel/syscalls/clone/clone01.c
ltp/testcases/kernel/syscalls/clone/clone02.c
ltp/testcases/kernel/syscalls/clone/clone03.c
ltp/testcases/kernel/syscalls/clone/clone04.c
ltp/testcases/kernel/syscalls/clone/clone05.c
ltp/testcases/kernel/syscalls/clone/clone06.c
ltp/testcases/kernel/syscalls/clone/clone07.c
ltp/testcases/kernel/containers/sysvipc/Makefile
ltp/testcases/kernel/containers/sysvipc/check_ipcns_enabled.c
ltp/testcases/kernel/containers/libclone/libclone.c
ltp/testcases/kernel/containers/libclone/libclone.h
ltp/testcases/kernel/containers/netns/common.c
ltp/include/test.h
Removed Files:
ltp/testcases/kernel/controllers/cgroup/clone_platform.h
Added File(s):
ltp/lib/cloner.c

7) Log Message:
The patch does the following:

1. Simplifies the code in get_mempolicy01,
2. Fixes indentation (some of the output in the diff looks wrong, but it's correct in the real testcase file),
3. Uses TERRNO for getting the error per testcase call properly, instead of getting the last errno value,
4. Uses basename(3) instead of hacking with strchr(3),
5. Disables the test for s390x (as __NR_get_mempolicy, __NR_mbind, and __NR_set_mempolicy aren't defined), as described in `Build Fails on some archs' thread,
Enabled:
get_mempolicy01    0  TINFO  :  (case00) START
EXPECT: return value(ret)=0 errno=0 (Success)
RESULT: return value(ret)=0 errno=0 (Success)
get_mempolicy01    1  TPASS  :  (case00) END
get_mempolicy01    0  TINFO  :  (case01) START
EXPECT: return value(ret)=0 errno=0 (Success)
RESULT: return value(ret)=0 errno=0 (Success)
get_mempolicy01    2  TPASS  :  (case01) END
get_mempolicy01    0  TINFO  :  (case02) START
EXPECT: return value(ret)=0 errno=0 (Success)
RESULT: return value(ret)=0 errno=0 (Success)
get_mempolicy01    3  TPASS  :  (case02) END
get_mempolicy01    0  TINFO  :  (case03) START
EXPECT: return value(ret)=0 errno=0 (Success)
RESULT: return value(ret)=0 errno=0 (Success)
get_mempolicy01    4  TPASS  :  (case03) END
get_mempolicy01    0  TINFO  :  (case04) START
EXPECT: return value(ret)=0 errno=0 (Success)
RESULT: return value(ret)=0 errno=0 (Success)
get_mempolicy01    5  TPASS  :  (case04) END
get_mempolicy01    0  TINFO  :  (case05) START
EXPECT: return value(ret)=0 errno=0 (Success)
RESULT: return value(ret)=0 errno=0 (Success)
get_mempolicy01    6  TPASS  :  (case05) END
get_mempolicy01    0  TINFO  :  (case06) START
EXPECT: return value(ret)=0 errno=0 (Success)
RESULT: return value(ret)=0 errno=0 (Success)
get_mempolicy01    7  TPASS  :  (case06) END
get_mempolicy01    0  TINFO  :  (case07) START
EXPECT: return value(ret)=0 errno=0 (Success)
RESULT: return value(ret)=0 errno=0 (Success)
get_mempolicy01    8  TPASS  :  (case07) END
get_mempolicy01    0  TINFO  :  (case08) START
EXPECT: return value(ret)=0 errno=0 (Success)
RESULT: return value(ret)=0 errno=0 (Success)
get_mempolicy01    9  TPASS  :  (case08) END
get_mempolicy01    0  TINFO  :  (case09) START
EXPECT: return value(ret)=0 errno=0 (Success)
RESULT: return value(ret)=0 errno=0 (Success)
get_mempolicy01   10  TPASS  :  (case09) END
get_mempolicy01    0  TINFO  :  (case10) START
EXPECT: return value(ret)=-1 errno=14 (Bad address)
RESULT: return value(ret)=-1 errno=14 (Bad address)
get_mempolicy01   11  TPASS  :  (case10) END
get_mempolicy01    0  TINFO  :  (case11) START
EXPECT: return value(ret)=-1 errno=22 (Invalid argument)
RESULT: return value(ret)=-1 errno=22 (Invalid argument)
get_mempolicy01   12  TPASS  :  (case11) END
Forced disable (#undef'ed __NR_get_mempolicy):
$ ./get_mempolicy01
get_mempolicy01    1  TCONF  :  Your system doesn't properly support:
get_mempolicy
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/get_mempolicy/get_mempolicy01.c

8) Log Message:
1. Disable the test whenever the appropriate headers and syscalls don't exist so this will compile on systems without numa and without.
2. Fix the indentation.
3. Use TFAIL | TERRNO instead of all of the ad-hoc (TFAIL ... TERRNO, strerror(TERRNO)) logic.
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/mbind/mbind01.c

9) Log Message:
1. Use linux_syscall_numbers.h.
2. Fix a format string (use inttypes.h).
3. Remove an unused var.
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/controllers/cpuset/cpuset_syscall_test/cpuset_syscall_test.c

10) Log Message:
I was confused, and numaif.h is in fact a header under testcases/kernel/syscalls/utils. As such:

1. The autoconf test for the header is removed.
2. An appropriate inclusion is added for numa.h in numaif.h
3. Remove overengineered code in get_mempolicy01.c because linux_syscall_numbers.h handles the unhandled numa syscall numbers.
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/get_mempolicy/et_mempolicy01.c
ltp/testcases/kernel/syscalls/mbind/mbind01.c
ltp/testcases/kernel/syscalls/move_pages/move_pages_support.h
ltp/testcases/kernel/syscalls/move_pages/move_pages_support.c
ltp/testcases/kernel/syscalls/move_pages/Makefile
ltp/m4/ltp-numa.m4

11) Log Message:
Fix bad SQA:
1. main was missing an int return code.
2. #include <stdio.h> was missing for the printf.

Modified Files:
ltp/testcases/commands/ade/ar/file1.c
ltp/testcases/commands/ade/ar/file2.c
ltp/testcases/commands/ade/ar/file3.c

12) Log Message:
Report errors appropriate to whether or not the read / write operations with the pipe succeeded. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/containers/libclone/libclone.c

13) Log Message:
drop compile-time checks for the syscall and rely completely on runtime --people missing __NR_fallocate should update include/linux_syscall_numbers.h. Mike Frysinger <vapier@users.sourceforge.net>.

Modified Files:
ltp/testcases/kernel/syscalls/fallocate/fallocate01.c
ltp/testcases/kernel/syscalls/fallocate/fallocate02.c
ltp/testcases/kernel/syscalls/fallocate/fallocate03.c

14) Log Message:
fallocate02: add a default case to avoid gcc uninitialized warning. Mike Frysinger <vapier@users.sourceforge.net>.

Modified Files:
ltp/testcases/kernel/syscalls/fallocate/fallocate02.c

15) Log Message:
Add a Common Issues section to address common roadblocks encountered with the build.  Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/INSTALL

16) Log Message:
Fix the Makefile comment title. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/syscalls/Makefile

17) Log Message:
Fix an unitialized variable and usage corner case where if argc > 1, it would always accept the arguments as-is. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/controllers/cpuset/cpuset_memory_pressure_test/cpuset_memory_pressure.c

18) Log Message:
main was lacking a return code. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/commands/ade/ar/file1.c

19) Log Message:
Fix the issue filed as https://sourceforge.net/tracker/?func=detail&aid=2892491&group_id=202378&atid=981342. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/utils/benchmark/ebizzy-0.3/ebizzy.c

20) Log Message:
main is missing a return code. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/commands/ade/ar/file3.c

21) Log Message:
Wow, ok -- copy-paste R'US. Missing return code in main, yet again. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/commands/ade/ar/file2.c

22) Log Message:
1. Fix 2 format strings, so that the underlying scripts actually are called properly.
2. Use appropriate precision so that 64-bit archs don't whine about printing out pid_t format strings.
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/containers/netns/common.c

23) Log Message:
forgot to add ptrace.h as Garrett pointed out. Mike Frysinger <vapier@users.sourceforge.net>.

Added Files:
ltp/testcases/kernel/syscalls/ptrace/ptrace.h

24) Log Message:
The wording for the requirements was ambiguous and confusing. Make things explicit that you need make 3.81 to compile LTP. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/INSTALL

25) Log Message:
Drop the caps.

Modified Files:
ltp/INSTALL

26) Log Message:
drop adding of -O/-W type flags that are already handled in common .mk files. for the few makefiles that arent yet converted to the .mk infrastructure: Lately gcc developers introduced -Wextra flag that does the same as -W but is more descriptive. According to this using -W flag should be safe (as gcc is backward compatlible) but using -Wextra is limited to newer gcc releases. Attached patch replaces all -Wextra occurences with -W and thus fixes compliation failures with older gcc (mine was gcc-3.3.3 on sles). Patch by Cyril Hrubis <chrubis@suse.cz>.

Modified Files:
ltp/testcases/kernel/device-drivers/misc_modules/per_cpu_allocator_module/Makefile
ltp/testcases/kernel/device-drivers/acpi/Makefile
ltp/testcases/kernel/controllers/cgroup_fj/Makefile
ltp/testcases/kernel/controllers/cpuacct/Makefile
ltp/testcases/kernel/device-drivers/block/kernel_space/Makefile
ltp/testcases/kernel/controllers/cpuctl_fj/Makefile
ltp/testcases/kernel/device-drivers/v4l/kernel_space/Makefile
ltp/testcases/kernel/io/disktest/Makefile
ltp/testcases/kernel/device-drivers/usb/tusb/Makefile
ltp/testcases/kernel/device-drivers/nls/Makefile
ltp/testcases/kernel/device-drivers/tbio/user_space/Makefile
ltp/testcases/kernel/device-drivers/v4l/user_space/Makefile

27) Log Message:
1. Correct a missing reference in Makefile.
2. Correct some typos and other grammatical issues with README.mk-devel.

Modified Files:
ltp/README.mk-devel
ltp/Makefile

28) Log Message:
Correct another typo and fix the Quick Start directions. Found-by: Randy Dunlap <rdunlap@xenotime.net>, Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/INSTALL

29) Log Message:
numaif.h needs config.h to pick up the HAVE_NUMA_H autoconf set variable in config.h. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/syscalls/utils/numaif.h

30) Log Message:
Get rid of a valid -Wunused warning with the fscanf(3). Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/lib/system_specific_process_info.c

31) Log Message:
Make sure that the chown is successful, and use getegid(2) instead of getgid(2). Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/syscalls/access/access01.c

32) Log Message:
Having config.h.default automatically replace config.h is a nuisance. People should be directed to go read install again, instead of running into some undefined symbols in autoconf-generated territory, especially because config.h.default is a much smaller subset of config.h generated by autoconf/config.h.in. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/include/mk/automake.mk

33) Log Message:
The description for the RHEL 4.8 quotactl check was misleading. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/m4/ltp-quota.m4

34) Log Message:
Update config.h.default to match config.h.in. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/include/config.h.default

35) Log Message:
Return non-void return code when PTRACE junk is missing. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/controllers/freezer/vfork.c

36) Log Message:
Apparently my system has all 3 of the available headers in its default -I search path:
- sys/ptrace.h
- linux/ptrace.h
- asm/ptrace.h
Make these headers mutually exclusive so they don't clash with one another and screw up some of the autoconf'ed decl tests. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/syscalls/ptrace/ptrace.h

37) Log Message:
Be consistent with the braces. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/lib/cmdlib.sh

38) Log Message:
vfork.c:
- Fix autoconf test result name for PTRACE_O_TRACEVFORK*.
vfork_freeze.sh:
- Implement proper TMPDIR logic.
- Remove forced make in place of optional (if needed) make operation.
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/controllers/freezer/vfork.c
ltp/testcases/kernel/controllers/freezer/vfork_freeze.sh

39) Log Message:
Dumb arse typo... Signed-off-by: The idiot that made the last checkin <root@devnull.com>.

Modified Files:
ltp/testcases/kernel/controllers/freezer/vfork.c

40) Log Message:
Just remove the frak'ing \t to be consistent with the old version. Blasted cylons... Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/controllers/freezer/vfork.c

41) Log Message:
vfork.c:
1. Add signal handling code and cleanup code.
2. Protect against ptrace(PTRACE_KILL, -1, ...) *grins*.
3. Add a -f option so one could print out info with tst_res(3) while outputting data to the ptrace logfile.
vfork_freeze.sh:
1. Standardize the log name.
2. Fix a syntax error.

Modified Files:
ltp/testcases/kernel/controllers/freezer/vfork.c
ltp/testcases/kernel/controllers/freezer/vfork_freeze.sh

42) Log Message:
Ok -- APPARENTLY asm/ptrace.h IS required for pt_regs! Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/syscalls/ptrace/ptrace.h

43) Log Message:
Make all of the numa tests consistent and correct. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/syscalls/get_mempolicy/Makefile
ltp/testcases/kernel/syscalls/move_pages/move_pages01.c
ltp/testcases/kernel/syscalls/move_pages/move_pages02.c
ltp/testcases/kernel/syscalls/move_pages/move_pages03.c
ltp/testcases/kernel/syscalls/move_pages/move_pages04.c
ltp/testcases/kernel/syscalls/move_pages/move_pages05.c
ltp/testcases/kernel/syscalls/move_pages/move_pages06.c
ltp/testcases/kernel/syscalls/move_pages/move_pages07.c
ltp/testcases/kernel/syscalls/move_pages/move_pages08.c
ltp/testcases/kernel/syscalls/move_pages/move_pages09.c
ltp/testcases/kernel/syscalls/move_pages/move_pages10.c
ltp/testcases/kernel/syscalls/move_pages/move_pages11.c
ltp/testcases/kernel/syscalls/move_pages/move_pages_support.c

44) Log Message:
need to include -lclone before -lltp. Mike Frysinger <vapier@users.sourceforge.net>.

Modified Files:
ltp/testcases/kernel/containers/mqns/Makefile

45) Log Message:
Fix build failure in cgroup_fj testcase: The following build failure occured on my x86 box. But the case "cgroup_fj" does not need "-lcontrollers" when building. So in my patch, i deleted "-lcontrollers" in testcases/kernel/controllers/Makefile.inc and added it to testcases/kernel/controllers/memctl/Makefile because the case "memctl" need it. All other cases in testcases/kernel/controllers/ build well too when my patch merged. Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>.
 
Modified Files:
ltp/testcases/kernel/controllers/Makefile.inc
ltp/testcases/kernel/controllers/memctl/Makefile

46) Log Message:
Following patch fixes buffer overflow.c. Signed-off-by: Cyril Hrubis <chrubis@suse.cz>.

Modified Files:
ltp/testcases/kernel/fs/doio/growfiles.c

47) Log Message:
Rename coliding names in runtest files: Following patch renumbers testcase names in runtest/ltp-aio-stress.part1 and runtest/ltp-aio-stress.part2 so that their names don't collide. Also renames testcases in runtest/ltp-aiodio.part2 so that they don't collide with ltp-aio-stress ones. Signed-off-by: <chrubis@suse.cz>.

Modified Files:
ltp/runtest/ltp-aio-stress.part1
ltp/runtest/ltp-aio-stress.part2 ltp/runtest/ltp-aiodio.part2

48) Log Message:
1. Don't nuke config.h with clean. ac-clean will do that,
2. config.h can and should be produced either via manual intervention (discouraged) or configure (preferred),
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/include/Makefile

49) Log Message:
Get rid of an unused var. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/mbind/mbind01.c

50) Log Message:
Resolve some clashing symbols for static functions that are in fact defined in numa.h. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/utils/numaif.h

51) Log Message:
The shuffle of headers broke the ia64 workaround. Mike Frysinger <vapier@users.sourceforge.net>,

Modified Files:
ltp/testcases/kernel/syscalls/ptrace/ptrace.h

52) Log Message:
Make a note about the pt_reg changes that Mike implemented, so that another poor sole won't accidentally screw up this header. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/ptrace/ptrace.h

53) Log Message:
ext4: fix script error of ext4_nsec_timestamps_test.sh:
Execute test case of ext4_nsec_timestamps_test.sh had some errors:
./ext4_nsec_timestamps_test.sh: line 183: [0: command not found
./ext4_nsec_timestamps_test.sh: line 189: [0: command not found
This patch fixes them. Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>.

Modified Files:
ltp/testcases/kernel/fs/ext4-new-features/ext4-nsec-timestamps/ext4_nsec_timestamps_test.sh

54) Log Message:
Removal of this testcase and it's reference as per "Serge E. Hallyn" <serue@us.ibm.com> suggestion: The patch in question is upstream, so pidns21.c will always fail and should be removed from ltp. It's worth testing that the container init survives SIGUSR1 from a child, but whether it survives or dies from a parent we don't particularly care.

Modified Files:
ltp/testcases/kernel/containers/pidns/runpidnstest.sh
Removed Files:
ltp/testcases/kernel/containers/pidns/pidns21.c

55) Log Message:
1. The logic check for IDcheck.sh was inverted for finding entries.
2. sys and users were being checked for in /etc/password, not /etc/group.
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/IDcheck.sh

56) Log Message:
Add a note about outdated m4 output seen on RHEL 5.2. Need to add a check for m4 version in configure.ac *sigh*.... Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/INSTALL

57) Log Message:
Correction -- it wasn't just m4. automake was outdated and after it was upgraded to an appropriate version, things just worked like they should. Update the directions again to note that. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/INSTALL

58) Log Message:
Fix the numa-related items for good so that they compile on systems with numa on them. This was compile-tested on Fedora 11 with numactl-devel installed and it passed. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/syscalls/get_mempolicy/Makefile

59) Log Message:
Fix the numa-related items for good so that they compile on systems with numa on them. This was compile-tested on Fedora 11 with numactl-devel installed and it passed. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

ltp/testcases/kernel/syscalls/utils/numaif.h
ltp/testcases/kernel/syscalls/move_pages/Makefile
ltp/testcases/kernel/syscalls/mbind/Makefile

60) Log Message:
Fix a missing brace. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/containers/mqns/mqns_02.c

61) Log Message:
Add runalltests.sh to the install list so it gets installed too. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/Makefile

62) Log Message:
Enhance runalltests.sh so that it can be executed from anywhere. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/runalltests.sh

63) Log Message:
Just need to make sure that we're in LTPROOT before executing anything because unfortunately all of the paths are RELATIVE to LTPROOT XD. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/runalltests.sh

64) Log Message:
1. Remove some stale items that have been resolved or are no longer pertinent.
2. Add a note about libevent being messed up.
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/TODO

65) Log Message:
Fix some unchecked return warnings in mqns_01.c. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/containers/mqns/mqns.h
ltp/testcases/kernel/containers/mqns/mqns_01.c

66) Log Message:
support ptrace on sparc. Mike Frysinger <vapier@users.sourceforge.net>

Modified Files:
ltp/testcases/kernel/syscalls/ptrace/simple_tracer.c
ltp/testcases/kernel/syscalls/ptrace/spawn_ptrace_child.h.

67) Log Message:
Fix __NR_[gs]et_mempolicy syscall numbers and a few other syscall numbers. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/include/arm.in
ltp/testcases/kernel/include/i386.in
ltp/testcases/kernel/include/ia64.in
ltp/testcases/kernel/include/powerpc.in
ltp/testcases/kernel/include/sh.in
ltp/testcases/kernel/include/sparc.in
ltp/testcases/kernel/include/sparc64.in 
ltp/testcases/kernel/include/x86_64.in

68) Log Message:
Forgot to add __NR_add_key to the rest of the .in files. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/include/powerpc.in
ltp/testcases/kernel/include/s390.in
ltp/testcases/kernel/include/sparc.in
ltp/testcases/kernel/include/sparc64.in
ltp/testcases/kernel/include/x86_64.in

69) Log Message:
Fix SIGSEGV if the group entries are missing. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/setregid/setregid04.c

70) Log Message:
Use linux_syscall_numbers's syscall macro instead of syscall(2), so we can test for TCONF'ability of syscall. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/clock_getres/clock_getres01.c

71) Log Message:
Properly granularize errno reporting for sysconf. The manpage only says that EINVAL is supported for return codes. Everything else is free game for error reporting. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/sysconf/sysconf01.c

72) Log Message:
Make the test user lookup error for error bind02 a bit more intuitive. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/bind/bind02.c

73) Log Message:
Consolidate all of the logic in one area and clean it up significantly. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/keyctl/keyctl01.c

74) Log Message:
Add __NR_keyctl. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/include/arm.in
ltp/testcases/kernel/include/i386.in
ltp/testcases/kernel/include/ia64.in
ltp/testcases/kernel/include/powerpc.in
ltp/testcases/kernel/include/s390.in
ltp/testcases/kernel/include/sparc.in
ltp/testcases/kernel/include/sparc64.in 
ltp/testcases/kernel/include/x86_64.in

75) Log Message:
Makefile: No need to compile `create_link_16' ;)... create_link.c: Clean up the logic flow. lchown02.c: The change I made a few months ago, accidentally broke this app, as the process isn't it's CAP_CHOWN'ed, and thus the chown will always fail, by accident. I know I can CAP_CHOWN the proc ess, but prep_create_link: Add script to resolve the chown breakage. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>

Modified Files:
ltp/testcases/kernel/syscalls/lchown/Makefile
ltp/testcases/kernel/syscalls/lchown/create_link.c
ltp/testcases/kernel/syscalls/lchown/lchown02.c

76) Log Message:
Check in runtest changes for lchown02, and libevent (have to fix that still... almost done). Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/runtest/syscalls

77) Log Message:
1. Convert rwtest.sh to rwtest (part 1).
2. Convert lchown02 in ltplite, according to what was also done to syscalls.
3. Convert the aio junk to $TMPDIR (this may or may not require additional work... memory serves me correctly, it does).
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/runtest/ltp-aiodio.part1
ltp/runtest/ltp-aiodio.part3
ltp/runtest/ltp-aiodio.part4
ltp/runtest/ltplite 
ltp/runtest/lvm.part1
ltp/runtest/lvm.part2
ltp/runtest/scsi_debug.part1
ltp/runtest/stress.part1
ltp/runtest/stress.part3

78) Log Message:
Make the switchover from rwtest.sh to rwtest. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/fs/doio/Makefile 
Added Files:
ltp/testcases/kernel/fs/doio/rwtest 
Removed Files:
ltp/testcases/kernel/fs/doio/rwtest.sh

79) Log Message:
Stupid me... I accidentally was mixing pointers with constants >_>... Fix my changes to setregid04, so it doesn't segfault if the groups don't exist, but still remains functional when run. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/setregid/setregid04.c

80) Log Message:
Quell the _GNU_SOURCE already defined noise. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/lib/cloner.c

81) Log Message:
Change += back to := for LDLIBS. I did this for a reason (to make sure that everyone adds the appropriate LDLIBS values after including config.mk // env_pre.mk // testcases.mk). We need to solve the linker issue with libclone, properly, not shove the issue under the rug with things like this. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/include/mk/config.mk.default
ltp/include/mk/config.mk.in

82) Log Message:
Use linux_syscall_numbers.h instead of the syscalls. Need to add the __NR_ defs to the .in files still. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/containers/libclone/libclone.h
ltp/testcases/kernel/containers/pidns/pidns30.c
ltp/testcases/kernel/containers/pidns/pidns31.c
ltp/testcases/kernel/containers/mqns/mqns_01.c
ltp/testcases/kernel/containers/mqns/mqns_02.c
ltp/testcases/kernel/containers/mqns/mqns_03.c
ltp/testcases/kernel/containers/mqns/mqns_04.c

83) Log Message:
Add the mq_* syscalls to the syscall list for each available architecture. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/include/arm.in
ltp/testcases/kernel/include/i386.in
ltp/testcases/kernel/include/ia64.in
ltp/testcases/kernel/include/powerpc.in
ltp/testcases/kernel/include/powerpc64.in
ltp/testcases/kernel/include/s390.in
ltp/testcases/kernel/include/sh.in 
ltp/testcases/kernel/include/sparc.in
ltp/testcases/kernel/include/sparc64.in
ltp/testcases/kernel/include/x86_64.in

84) Log Message:
1. Linker ordering is painful; -lltp must come last for some weird arse reason in order to work with binutils 1.19.51, whereas it needs to precede -lclone on 1.18.. We'll see whether or not it's fubar still in a minute...
2. Not all of the mq_* functions are syscalls; many are in fact libcalls, so we need to use the appropriate function call to stimulate them.
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/containers/sysvipc/Makefile
ltp/testcases/kernel/containers/utsname/Makefile
ltp/testcases/kernel/containers/mqns/Makefile
ltp/testcases/kernel/containers/mqns/mqns.h
ltp/testcases/kernel/containers/mqns/mqns_01.c
ltp/testcases/kernel/containers/mqns/mqns_02.c
ltp/testcases/kernel/containers/mqns/mqns_03.c
ltp/testcases/kernel/containers/mqns/mqns_04.c
ltp/testcases/kernel/containers/pidns/Makefile
ltp/testcases/kernel/containers/pidns/pidns30.c
ltp/testcases/kernel/containers/pidns/pidns31.c

85) Log Message:
I was REALLY stupid when I made clean dependent on ac-distclean. BAD BAD IDEA. Forcing people to have to call configure every time clean is run is STUPID design. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>, 

Modified Files:
ltp/include/Makefile

86) Log Message:
Checking in possible final / intermediate solution to ppoll01 not functioning on mips32. I say intermediate because of the following message: AHA! I figured out why sigset is sized differently on mips32 for you, compared to other architectures. Just like there's a compat_caddr_t datatype (which is explicitly set to char *), there's also a compat_sigset_t as well. Let me see if I can figure out this mystery, but my guess is that you're using n32 based mips, most likely on an Octeon model ;) ;)... which would account for what you're seeing here and possibly account for why the test consistently hangs on our Cavium boards at work (our version of Linux has been hacked so bad though to take shortcuts in the design process instead of following proper design procedure that it makes me cry inside...). The patch attached for ppoll01:
1. Cleans up spacing and code style
2. Removes unneeded/broken debug option parsing if test fails.
3. Prints out the last failed errno, rather than just the last errno(which may have been successful)
4. Passes in correct size of sigset_t for mips.
This patch was tested/passed on x86, mips(little endian), and ppc_82xx. Signed-off-by: Henry Yei <hyei@mvista.com>, Acked-by: Garrett Cooper <yanegomi@gmail.com>

Modified Files:
ltp/testcases/kernel/syscalls/ppoll/ppoll01.c

87) Log Message:
1. Skip over /proc/irq by default to avoid broken hardware / drivers, and thus avoid `hangs'. You can traverse over /proc/irq using -i though.
2. Make the selinux piece a compile-time conditional, to avoid the additional function call.
3. Fix the overflow issue on 64-bit systems by increasing values of total_obj, et all to unsigned long long's.
4. Only call close / closedir if fd is > 0 and dir is not NULL.
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>

Modified Files:
ltp/testcases/kernel/fs/proc/proc01.c

88) Log Message:
Let's not overwrite /bin/cat by accident in open08 if the setguid / setuid fails, mmk? Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/open/open08.c

89) Log Message:
As noticed by Shi Weihua, there was a syntax error in the awk command in get_cpu_usage: 
awk: print $9
awk: ^ syntax error pid 8077 cpu_usage
cpuctl_test_fj    1  TFAIL  :  case19    FAIL awk: print $9
awk: ^ syntax error pid 8104 cpu_usage
cpuctl_test_fj    1  TFAIL  :  case20    FAIL awk: print $9
awk: ^ syntax error
pid 8131 cpu_usage cpuctl_test_fj    1  TFAIL  :  case21    FAIL
awk: print $9 awk: ^ syntax error
pid 8193 cpu_usage cpuctl_test_fj    1  TFAIL  :  case22    FAIL
The checkin corrects the syntax error by implementing the function in a much cleaner manner than the previous implementation, by using just ps | awk instead of top | tail | head | awk | awk. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>. Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>.

90) Log Message:
mem/hugetlb: fix failure of hugemmap04: Testcase hugemmap04 needs at least one hugepage to test, so there needs a judgement of "number of hugepages". This patch fixed the problems. Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>. 

Modified Files:
ltp/testcases/kernel/mem/hugetlb/hugemmap/hugemmap04.c

91) Log Message:
Fix some remaining compile errors that we're checked in earlier... Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/containers/libclone/Makefile
ltp/testcases/kernel/containers/libclone/libclone.h

92) Log Message:
1. Remove the .c files and all calls in runpwtests.sh because we can achieve the same thing through additional shell test logic.
2. Add the apicmds dependency.
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>

Modified Files:
ltp/testcases/kernel/power_management/Makefile
ltp/testcases/kernel/power_management/runpwtests.sh 
Removed Files:
ltp/testcases/kernel/power_management/check_kv_arch.c
ltp/testcases/kernel/power_management/get_sched_values.c

93) Log Message:
mail: fix the bug of mail01: In the testcase "mail01", when mail is send to nosuchuser@domain and mail is send to user@nosuchdomain, mail program may return either "Returnedmail:" or "UndeliveredMailReturned", regardless of the existence of /etc/redhat-release. So, we did a bit of changes to recognize both of returned values. This patch fixes the problem. Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>.

Modified Files:
ltp/testcases/commands/mail/mail_tests.sh

94) Log Message:
[PATCH (1/2)] add atomi_add() define for __sh__. Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>.

Modified Files:
ltp/testcases/realtime/include/librttest.h

95) Log Message:
[PATCH (2/2)] splitting the tsc support. The patch moves the tsc macros form the librttest.h to another header file (named libtsc.h). Without this I got the following error and no tests were built.
 [snip]
 In file included from librttest.c:43:
 ../include/librttest.h:127:2: error: #error
 ../include/librttest.h:169:2: error: #error
 In file included from librttest.c:43:
 ../include/librttest.h: In function ‘atomic_add’:
 [snip]
The tsc macros header is only included in the following tests (thus where necessary):
 o async_handler_tsc.c
 o preempt_timing.c
 o rdtsc-latency.c
Note1: instead of touching the make process the patch allows to build the tests above also for architecture that do not support tsc, yet. These tests will fail at run-time with ENOTSUP. A warning will appear while compiling as well. hmm, I do know if it is the right solution but it's simple and a good starting point for me. Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>.

Modified Files:
ltp/testcases/realtime/func/async_handler/async_handler_tsc.c
ltp/testcases/realtime/func/measurement/preempt_timing.c
ltp/testcases/realtime/func/measurement/rdtsc-latency.c
ltp/testcases/realtime/include/librttest.h
Added Files:
ltp/testcases/realtime/include/libtsc.h

96) Log Message:
mem/hugeshmget: fix failure of hugeshmget01: During hugeshmget01 testcase, we got the following:
hugeshmget01    1  TFAIL  :  seqment size is not correct
hugeshmget01    1  TFAIL  :  hugeshmget01 call failed - errno = 17 :
File exists ......
In shmget call, "buf.shm_segsz" had been set to "huge_pages_shm_to_be_allocated", but the code still used old macro "HUGE_SHM_SIZE", and this leaded to error "seqment size is not correct". So do the following change:
1) s/HUGE_SHM_SIZE/huge_pages_shm_to_be_allocated
2) Delete unused macro "HUGE_SHM_SIZE" defination
This patch fixed the failure. Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>.

Modified Files:
ltp/testcases/kernel/mem/hugetlb/hugeshmget/hugeshmget01.c
ltp/testcases/kernel/mem/hugetlb/lib/ipcshm.h

97) Log Message:
lcov: add CVS revision number to version output

Modified Files:
ltp/utils/analysis/lcov/bin/lcov

98) Log Message:
lcov: add more CVS versioning

Modified Files:
ltp/utils/analysis/lcov/bin/gendesc
ltp/utils/analysis/lcov/bin/genhtml
ltp/utils/analysis/lcov/bin/geninfo
ltp/utils/analysis/lcov/bin/genpng
ltp/utils/analysis/lcov/bin/lcov
ltp/utils/analysis/lcov/bin/updateversion.pl

99) Log Message:
lcov: fix version fixup

Modified Files:
ltp/utils/analysis/lcov/bin/lcov

100) Log Message:
lcov: more version fixup

Modified Files:
ltp/utils/analysis/lcov/bin/gendesc
ltp/utils/analysis/lcov/bin/genhtml
ltp/utils/analysis/lcov/bin/geninfo
ltp/utils/analysis/lcov/bin/genpng

101) Log Message:
Hello guys, I have run into some problems with the network stress tests. I submitted a bug through the sourceforge bug tracker, but after subscribing to the mailing list I can see that it's here where all the action is. If this is not the right place, then please tell me what is the preferred way to submit bug reports and patches. I am using ltp-full-20091031. A lot of the TCP tests involving packet loss fail with this error: ./tcp4-uni-basic01: line 394: netem_param: unbound variable The reason is that strict checking for undefined variables is enabled with "set -u", but the variable netem_param is not always defined before testing its contents. The fix I have applied is to initialize the netem_param variable with an empty string. Also if4-addr-change always fails with this error:  TBROK  :  Failed to set an IPv4 address at the remote host I have found the reason to be a missing semicolon. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/network/stress/tcp/uni-basic/tcp4-uni-basic01
ltp/testcases/network/stress/interface/if4-addr-change

102) Log Message:
1. Merge ftruncate.sh and ftruncate64.sh into one script - ftruncate04.sh - where all you have to do is specify no arguments or 64 to execute ftruncate04 or ftruncate04_64, respectively.
2. Correct tail -1 syntax (-<int> argument types are deprecated with tail(1); Redhat barks whenever it executes it).
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>

Modified Files:
ltp/testcases/kernel/syscalls/ftruncate/Makefile
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/ftruncate/ftruncate04.sh 
Removed Files:
ltp/testcases/kernel/syscalls/ftruncate/ftruncate.sh
ltp/testcases/kernel/syscalls/ftruncate/ftruncate_64.sh

103) Log Message:
Fix more tail -<integer> syntax issues. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testscripts/test_robind.sh
ltp/testcases/pounder21/test_scripts/memtest
ltp/testcases/kernel/fs/quota_remount/quota_remount_test01.sh
ltp/tools/ltp_check
ltp/testcases/kernel/sched/sched_stress/sched_stress.sh
ltp/testcases/kernel/fs/fs-bench/test.sh
ltp/testcases/kernel/fs/fs-bench/test2.sh

104) Log Message:
Include libevent in the proverbial mix. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>

Modified Files:
ltp/testcases/kernel/syscalls/libevent/run_libevent.sh
ltp/runtest/ballista
ltp/runtest/syscalls
ltp/testcases/kernel/syscalls/libevent/test/Makefile.am
ltp/testcases/kernel/syscalls/Makefile
Added Files:
ltp/testcases/kernel/syscalls/libevent/test/test-libevent.sh 
Removed Files:
ltp/testcases/kernel/syscalls/libevent/test/test.sh

105) Log Message:
This wasn't supposed to be checked in yet. Reverting... Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/runtest/ballista

106) Log Message:
Check in remaining syscall number modifications. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/include/arm.in
ltp/testcases/kernel/include/i386.in
ltp/testcases/kernel/include/sh.in

107) Log Message:
Append the PID to linux_syscall_numbers.h to avoid EBUSY / multiple file accesses with corrupt data at once if make(1) isn't doing the right thing and multiple jobs try to modify the header at the same time. This was based on personal experience with binutils and libtool modifying one file multiple times with parallel jobs via libtool. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>

Modified Files:
ltp/testcases/kernel/include/regen.sh

108) Log Message:
Commit execltp - a python script that provides a more user friendly alternative to runltp. The only thing basic that's outstanding from this script that could be improved upon is making the while loop into a python iterator. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/include/mk/automake.mk
ltp/Makefile
ltp/configure.ac 
Added Files:
ltp/execltp.in

109) Log Message:
As Mitani-san noticed the runtest file had two syntax errors -- 
 - "move_pagesXX" files are in "$LTPROOT/testcases/bin" direcotory, not in "$LTPROOT/bin" directory.
 - "chmod" commands don't have target file.
-- which resulted in the following output:
When I ran LTP in RHEL5.4 using ltp-2009-11-19.tar.gz, "move_pages03" and "move_pages11" were failed in each of "syscalls" and "numa" tests like that:
------------
move_pages01    1  TCONF  :  NUMA support not provided
move_pages02    1  TCONF  :  NUMA support not provided
chown: cannot access `move_pages03': No such file or directory
move_pages04    1  TCONF  :  NUMA support not provided
move_pages05    1  TCONF  :  NUMA support not provided
move_pages06    1  TCONF  :  NUMA support not provided
move_pages07    1  TCONF  :  NUMA support not provided
move_pages08    1  TCONF  :  NUMA support not provided
move_pages09    1  TCONF  :  NUMA support not provided
move_pages10    1  TCONF  :  NUMA support not provided
chown: cannot access `move_pages11': No such file or directory
Signed-off-by: Tomonori Mitani <mitani@ryobi.co.jp>,
Acked-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/runtest/numa
ltp/runtest/syscalls

110) Log Message:
Reorder headers because of compile-time definitions. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/syscalls/utils/common_j_h.c

111) Log Message:
Fix a tail -1 syntax item that wasn't fixed this morning. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/pounder21/test_scripts/bonnie++

112) Log Message:
Convert the assert's to more informative tst_resm(3)'s. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/performance_counters/performance_counter01.c

113) Log Message:
According to the manpage for mknod(2): 
       EPERM  mode requested creation of something other than a regular  file,
              FIFO  (named pipe), or Unix domain socket, and the caller is not
              privileged (Linux: does not have the CAP_MKNOD capability); also
              returned if the file system containing pathname does not support
              the type of node requested.
So the default install doesn't fix this mode for mknodat01, and thus the test will always fail the first subtc.
1. Fix the runtest file so that this test passes completely.
2. Fix the ad hoc strerror(errno) calls by replacing them with compatible TTERRNO calls.
gcooper@orangebox ~ $
/scratch/ltp-dev2/ltp/testcases/kernel/syscalls/mknodat/mknodat01 
mknodat01    1  TPASS  :  mknodat() returned the expected errno: TEST_ERRNO=???(0): Success
mknodat01    2  TPASS  :  mknodat() returned the expected errno: TEST_ERRNO=???(0): Success
mknodat01    3  TPASS  :  mknodat() returned the expected errno: TEST_ERRNO=ENOTDIR(20): Not a directory
mknodat01    4  TPASS  :  mknodat() returned the expected errno: TEST_ERRNO=EBADF(9): Bad file descriptor
mknodat01    5  TPASS  :  mknodat() returned the expected errno: TEST_ERRNO=???(0): Success
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>

Modified Files:
ltp/testcases/kernel/syscalls/mknodat/mknodat01.c
ltp/runtest/syscalls

114) Log Message:
Add iterations option in gtod_latency. This patch adds a new option for tuning the number of iterations into the gtod_latency realtime test. Running gtod_latency on a target with limited resources it fails (ENOMEM) as soon as it try to allocate the memory for the two buffers start_data and stop_data. Tested on i386 and sh4 architectures. Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>.

Modified Files:
ltp/testcases/realtime/func/gtod_latency/gtod_latency.c

115) Log Message:
Have to keep in mind that obj is actually the full path, not the basename. Otherwise, the irq filtering is all for naught. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/fs/proc/proc01.c

116) Log Message:
These syscalls can be unimplemented on some archs and kernel versions, so add a check to make sure that they are or aren't as it's valid. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/syscalls/keyctl/keyctl01.c
ltp/testcases/kernel/syscalls/add_key/add_key01.c
ltp/testcases/kernel/syscalls/add_key/add_key02.c 
ltp/testcases/kernel/syscalls/keyctl/keyctl01.c

117) Log Message:
Fix several issues with the Makefiles as noted by Mitani-san and Luibo:
(1) "${LTPROOT}/testcases/kernel/syscalls/libevent/test/Makefile" does not exist. For this measure, this "Makefile" should be made when "${LTPROOT}/configure" executed or this is offered as standard equipment, I think.
(2) "${LTPROOT}/testcases/kernel/syscalls/libevent/libevent.a" does not exist. For this measure, this "libevent.a" may be necessary to be made when "make" executed in "${LTPROOT}" directory.
(3) "${LTPROOT}/testcases/kernel/syscalls/libevent/test/test.sh" does not exist. For this measure, this "test.sh" may be necessary to be offered as standard equipment.
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/libevent/Makefile.am
ltp/testcases/kernel/syscalls/libevent/test/Makefile.in
ltp/testcases/kernel/syscalls/Makefile


118) Log Message:
All syscalls that aren't implemented on target architectures should be properly reported as missing instead of showing up as failures. Noticed by Mitani-san after he encountered several mbind(2) failures on an older kernel (2.6.9), as mbind(2) wasn't implemented until 2.6.17. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/include/regen.sh


119) Log Message:
The ENOSYS problem has been properly resolved in testcases/kernel/includes/regen.sh, so let's remove the ad hoc ENOSYS checks. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/keyctl/keyctl01.c
ltp/testcases/kernel/syscalls/add_key/add_key01.c
ltp/testcases/kernel/syscalls/add_key/add_key02.c

120) Log Message:
This test should be compiled with -lrt -lpthread. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/rt_sigaction/Makefile

121) Log Message:
Check in local copy of configure.ac that had libevent modifications. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/configure.ac

122) Log Message:
A simple header which only contains SIGSETSIZE right now, but will contain more items (potentially) later.

Added Files:
ltp/include/ltp_signal.h

123) Log Message:
Greatly simplify the testcase and use SIGSETSIZE instead of 8 hardcoded everywhere.. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/rt_sigprocmask/rt_sigprocmask02.c

124) Log Message:
1. Use SIGSETSIZE from ltp_signal.h
2. Do NOT use <asm/poll.h>. Use <poll.h> instead:
NAME
       poll, ppoll - wait for some event on a file descriptor
SYNOPSIS
       #include <poll.h>        int poll(struct pollfd *fds, nfds_t nfds, int
timeout);
       #define _GNU_SOURCE
       #include <poll.h>
       int ppoll(struct pollfd *fds, nfds_t nfds,
               const struct timespec *timeout, const sigset_t *sigmask);
3. Remove POLLRDHUP #define because we can get the definition when we add #define _GNU_SOURCE:     POLLRDHUP (since Linux 2.6.17)  Stream socket peer closed connection, or shut down writing half of connection. The _GNU_SOURCE feature test macro must be defined in order to obtain this definition. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/ppoll/ppoll01.c

125) Log Message:
Clean up the test. Dumb thing segfaults on me though... grr... Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/rt_sigsuspend/rt_sigsuspend01.c
ltp/testcases/kernel/syscalls/rt_sigprocmask/rt_sigprocmask01.c

125) Log Message:
1. Conform to ltp_signal.h
2. Fix some format strings with inttypes.h
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/signalfd/signalfd01.c

126) Log Message:

Modified Files:
ltp/testcases/kernel/syscalls/swapon/swapon01.c
ltp/testcases/kernel/syscalls/swapon/swapon02.c
ltp/testcases/kernel/syscalls/swapon/swapon03.c
ltp/configure.ac
ltp/testcases/kernel/include/arm.in
ltp/testcases/kernel/include/i386.in
ltp/testcases/kernel/include/ia64.in
ltp/testcases/kernel/include/powerpc.in
ltp/testcases/kernel/include/s390.in
ltp/testcases/kernel/include/sh.in
ltp/testcases/kernel/include/sparc.in 
ltp/testcases/kernel/include/x86_64.in

Removed Files:
ltp/m4/ltp-swaponoff.m4

Added Files:
ltp/include/swaponoff.h

127) Log Message:
What I meant to say in my last commit email was...
1. Replace swapon / swapoff calls with syscall wrapper calls to avoid having to deal with ugly header checks in autoconf land.
2. autoconf checks were wrong, as the MAX_SWAPFILES amount is actually predetermined based on the kernel version, not on the headers necessarily as Redhat LOVES being non-standard. This can't be tst_kvercmp, as tst_kvercmp is runtime based and MAX_SWAPFILES must be set at compile-time. And what I mean to say now is: I'm a dork -- I inverted the logic signs by accident (`<' -> `>'). Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/swapon/swapon02.c
ltp/testcases/kernel/syscalls/swapoff/swapoff01.c
ltp/testcases/kernel/syscalls/swapoff/swapoff02.c
ltp/include/swaponoff.h

128) Log Message:
You go in too ;)... Cleaned up this testcase as well, but this also segfaults on my system (before and after). Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/rt_sigaction/rt_sigaction01.c

129) Log Message:
Enable ebizzy and kernbench properly so that they get installed in the correct spots. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/utils/benchmark/kernbench-0.42/Makefile
ltp/utils/benchmark/ebizzy-0.3/Makefile
ltp/utils/benchmark/Makefile

130) Log Message:
configure target shouldn't be executed by any sane human being. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/utils/Makefile

131) Log Message:
Implement a weak handler so that libraries (like libcontrollers) can override cleanup in the respective user code, as it's required to get past compile-time issues with pidns, et all. This only marks the beginning of our long journey of cleaning up the cleanup defined but not used warnings... Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/include/regen.sh

132) Log Message:
Clean up testcase and have it conform to a more LTP-like standard. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/controllers/cpuset/cpuset_load_balance_test/cpuset_sched_domains_check.c

133) Log Message:
Need to change this script to scrape stdout. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/controllers/cpuset/cpuset_load_balance_test/cpuset_sched_domains_test.sh

134) Log Message:
Check in cleaned up versions of these tests. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/cacheflush/cacheflush01.c
ltp/testcases/kernel/syscalls/eventfd/eventfd01.c

135) Log Message:
Remove a blank line. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/signalfd/Makefile

136) Log Message:
Clean up this testcase a lot by fixing indentation, spacing, fixing a few memory leaks, and the cleanup prototype. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/linkat/Makefile
ltp/testcases/kernel/syscalls/linkat/linkat01.c

137) Log Message:
Clean up the testcases a bit and make the tests follow more of a LTP-like reporting method. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/performance_counters/performance_counter01.c
ltp/testcases/kernel/performance_counters/performance_counter02.c

138) Log Message:
ptrace04.c: Avoid compile errors on some archs if the appropriate headers are missing and thus the structure is undefined by wrapping with preprocessor define: HAVE_STRUCT_PTRACE_REGS. ptrace.h: Shift around ptrace.h again, so preprocessor defines for datatypes are only done if necessary. We'll see if this fixes Mitani san's issue on ia64... Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/ptrace/ptrace.h
ltp/testcases/kernel/syscalls/ptrace/ptrace04.c

139) Log Message:
No reason to do the #if !defined's anymore, because we're undefining the symbols before we #define them again XD. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/ptrace/ptrace.h

140) Log Message:
ptrace.h: Nevermind. The last commit was bogus -- we do need those #if !defined's.. ptrace04.c: WTF. Who in their bloody right mind would name a field and a data type with the same damn name?!?!?! The original test writer needs to be slapped. Not sure why in the heck the last compile didn't catch this glaring issue. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/syscalls/ptrace/ptrace.h
ltp/testcases/kernel/syscalls/ptrace/ptrace04.c

141) Log Message:
env_pre.mk: Check in, at bare minimum, the needed pieces to point people in the right direction as far as the make 3.81 requirement is concerned. functions.mk: Add some make 3.80 compatibility functions. Makefile: Remove make 3.81-ism's. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/include/mk/env_pre.mk
ltp/include/mk/functions.mk

142) Log Message:
env_pre.mk: Check in, at bare minimum, the needed pieces to point people in the right direction as far as the make 3.81 requirement is concerned. functions.mk: Add some make 3.80 compatibility functions. Makefile: Remove make 3.81-ism's. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/Makefile

143) Log Message:
Checkin all local changes for testcases/kernel/controllers to avoid compile-time warnings and errors, so that I can move forward with the weak handlers change. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/controllers/cpuset/cpuset_memory_test/cpuset_memory_test.c
ltp/testcases/kernel/controllers/cpuset/cpuset_load_balance_test/cpuset_cpu_hog.c
ltp/testcases/kernel/controllers/cgroup/cgroup_regression_test.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_lib/Makefile
ltp/testcases/kernel/containers/pidns/pidns17.c
ltp/testcases/kernel/containers/pidns/pidns10.c
ltp/testcases/kernel/containers/pidns/pidns04.c
ltp/testcases/kernel/controllers/cpuset/Makefile.inc
ltp/testcases/kernel/controllers/cpuset/cpuset_syscall_test/cpuset_syscall_test.c

144) Log Message:
Checkin the weak handlers change, so that compiles won't error out and test writers can define cleanup at the library level or the sourcefile(s) level, such that the sourcefile level version will overwrite the library level one. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/include/regen.sh

145) Log Message:
Add a check for (struct sigaction).sa_sigaction as it's not present on all architectures. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Added Files:
ltp/m4/ltp-signal.m4

Modified Files:
ltp/configure.ac

146) Log Message:
Some local changes bringing back CLEAN_DEPS and also making sure that FILTER_MAKE_TARGETS works even when MAKE_TARGETS is already defined. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/include/mk/generic_leaf_target.inc
ltp/include/mk/env_post.mk

147) Log Message:
Commit changes which provide a functional fix for the rt_sigaction(2) tests on x86_64, apart from SIGRTMIN (still crashes, but it keeps on going..). The test is now disabled on platforms where sa_handler isn't present in struct sigaction, which includes ia64, mips, and powerpc. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/include/ltp_signal.h
ltp/testcases/kernel/syscalls/rt_sigaction/rt_sigaction01.c


148) Log Message:
testcases/kernel/include/...: Add clock_gettime and clock_settime syscalls to all missing architecture .in files. testcases/kernel/timers/...:
1. Improve upon reporting, as noted by Andrew Vagin.
2. Clean up the test because there was a lot of ad hoc reporting / stale data that already gets punted back by | TERRNO and syscall, as implemented by linux_syscall_numbers.h, effectively simplifying the test(s) a LOT. 
3. Shift -D_GNU_SOURCE from CFLAGS to CPPFLAGS.
4. Make sure we link against -lrt, like the manpage says:
SYNOPSIS
       #include <time.h>
       int clock_getres(clockid_t clk_id, struct timespec *res);
       int clock_gettime(clockid_t clk_id, struct timespec *tp);
       int clock_settime(clockid_t clk_id, const struct timespec *tp);
       Link with -lrt.
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/timers/clock_settime/Makefile
ltp/testcases/kernel/timers/clock_settime/clock_settime02.c
ltp/testcases/kernel/timers/clock_settime/clock_settime03.c
ltp/testcases/kernel/include/arm.in
ltp/testcases/kernel/include/s390.in
ltp/testcases/kernel/include/sparc.in
ltp/testcases/kernel/include/arm.in

149) Log Message:
Avoid unintended side-effects with errno being overwritten by accident with fprintf call early on in the tst_print function.
Signed-off-by: Andrew Vagin <avagin@gmail.com>,
Acked-by: Mike Frysinger <vapier@gentoo.org>,
Acked-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/lib/tst_res.c

150) Log Message:
Remove useless comment. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/include/mk/testcases.mk

151) Log Message:
testcases/kernel/include/...:
        .../Makefile: Remove unneeded set -e.
        .../regen.sh: Quote variables.
        .../strip_syscall.awk: Add an awk script to strip syscalls from the unistd.h headers.
testcases/kernel/syscalls/Makefile: yank libevent because something's missing from the distribution and it's not compiling after running ac-clean // ac-distclean // ac-maintainer-clean. BAH. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/include/regen.sh
ltp/testcases/kernel/include/Makefile 
ltp/include/mk/generic_leaf_target.inc
ltp/include/mk/generic_trunk_target.inc
ltp/testcases/kernel/syscalls/Makefile

Added Files:
ltp/testcases/kernel/include/strip_syscall.awk

152) Log Message:
*.in: Checkin updated and complete syscalls as per kernel version 2.6.32-r8. linux_syscall_numbers.h: Avoid race conditions by reviving file, esp because it takes ~3 seconds to generate on my machine, which means that it will take eons on slower machines... Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/include/arm.in
ltp/testcases/kernel/include/i386.in
ltp/testcases/kernel/include/ia64.in
ltp/testcases/kernel/include/powerpc.in
ltp/testcases/kernel/include/s390.in
ltp/testcases/kernel/include/sh.in
ltp/testcases/kernel/include/sparc.in 
ltp/testcases/kernel/include/x86_64.in 

Added Files:
ltp/testcases/kernel/include/linux_syscall_numbers.h

153) Log Message:
Fix the performance counter testcases because __NR_perf_count_open is finally defined to the right value. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/performance_counters/performance_counter01.c
ltp/testcases/kernel/performance_counters/performance_counter02.c

154) Log Message:
Remove more unneeded comments. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>,

Modified Files:
ltp/testcases/kernel/performance_counters/performance_counter01.c
ltp/testcases/kernel/performance_counters/performance_counter02.c


--=-ZiuJlfagBgEFheJgnlpU--

