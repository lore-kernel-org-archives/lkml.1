Return-Path: <linux-kernel-owner+w=401wt.eu-S933108AbXA2DOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108AbXA2DOb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 22:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933109AbXA2DOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 22:14:30 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:59642 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933108AbXA2DOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 22:14:30 -0500
Date: Sun, 28 Jan 2007 19:10:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: 2.6.20-rc6-mm1 posixtest failures
Message-Id: <20070128191042.e64b84e3.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 2.6.20-rc6 (run #1097), the openposixtest[1] suite results were:

build errors: 13 files, 31 lines
PASS:         1687
FAILED:       68
UNTESTED:     95
UNRESOLVED:   9
UNSUPPORTED:  22
INTERRUPTED:  7
SCORE:        89

[1] http://posixtest.sourceforge.net/  (using v1.5.2)

On 2.6.20-rc6-mm1 (run #1104), the results were:

build errors: 13 files, 31 lines
PASS:         1662		// 25 fewer tests PASS
FAILED:       84
UNTESTED:     95
UNRESOLVED:   18
UNSUPPORTED:  22
INTERRUPTED:  7
SCORE:        88

Many of the new FAILED tests are in scheduler and mlock test cases.

Here is a diff of the test output files:

3993c3993
< /bin/sh: line 1: 27934 Segmentation fault      ./t0 240 conformance/interfaces/pthread_key_create/speculative/5-1.test >$COMPLOG 2>&1
---
> /bin/sh: line 1: 27891 Segmentation fault      ./t0 240 conformance/interfaces/pthread_key_create/speculative/5-1.test >$COMPLOG 2>&1
4219c4219
< conformance/interfaces/sched_setscheduler/1-1: execution: PASS
---
> conformance/interfaces/sched_setscheduler/1-1: execution: UNRESOLVED 
4227c4227
< conformance/interfaces/sched_setscheduler/17-5: execution: UNRESOLVED 
---
> conformance/interfaces/sched_setscheduler/17-5: execution: FAILED 
4266c4266
< conformance/interfaces/sched_getparam/1-1: execution: PASS
---
> conformance/interfaces/sched_getparam/1-1: execution: FAILED 
4269,4270c4269,4270
< conformance/interfaces/sched_getparam/2-1: execution: PASS
< conformance/interfaces/sched_getparam/3-1: execution: PASS
---
> conformance/interfaces/sched_getparam/2-1: execution: FAILED 
> conformance/interfaces/sched_getparam/3-1: execution: FAILED 
4406c4406
< /bin/sh: line 1: 32176 Segmentation fault      ./t0 240 conformance/interfaces/timer_getoverrun/speculative/6-1.test >$COMPLOG 2>&1
---
> /bin/sh: line 1: 32168 Segmentation fault      ./t0 240 conformance/interfaces/timer_getoverrun/speculative/6-1.test >$COMPLOG 2>&1
4429c4429
< conformance/interfaces/mlockall/3-6: execution: PASS
---
> conformance/interfaces/mlockall/3-6: execution: UNRESOLVED 
4432,4433c4432,4433
< conformance/interfaces/mlockall/8-1: execution: PASS
< conformance/interfaces/mlockall/3-7: execution: PASS
---
> conformance/interfaces/mlockall/8-1: execution: UNRESOLVED 
> conformance/interfaces/mlockall/3-7: execution: UNRESOLVED 
4545,4546c4545,4546
< conformance/interfaces/sched_get_priority_min/1-1: execution: PASS
< conformance/interfaces/sched_get_priority_min/1-2: execution: PASS
---
> conformance/interfaces/sched_get_priority_min/1-1: execution: FAILED 
> conformance/interfaces/sched_get_priority_min/1-2: execution: FAILED 
4548c4548
< conformance/interfaces/sched_get_priority_min/1-4: execution: PASS
---
> conformance/interfaces/sched_get_priority_min/1-4: execution: FAILED 
4585,4587c4585,4587
< conformance/interfaces/munlock/11-1: execution: PASS
< conformance/interfaces/munlock/10-1: execution: PASS
< conformance/interfaces/munlock/7-1: execution: PASS
---
> conformance/interfaces/munlock/11-1: execution: UNRESOLVED 
> conformance/interfaces/munlock/10-1: execution: UNRESOLVED 
> conformance/interfaces/munlock/7-1: execution: UNRESOLVED 
4590c4590
< /bin/sh: line 1:  1234 Segmentation fault      ./t0 240 conformance/interfaces/pthread_cond_timedwait/2-2.test >$COMPLOG 2>&1
---
> /bin/sh: line 1:  1226 Segmentation fault      ./t0 240 conformance/interfaces/pthread_cond_timedwait/2-2.test >$COMPLOG 2>&1
4598c4598
< /bin/sh: line 1:  3593 Segmentation fault      ./t0 240 conformance/interfaces/pthread_cond_timedwait/2-3.test >$COMPLOG 2>&1
---
> /bin/sh: line 1:  3588 Segmentation fault      ./t0 240 conformance/interfaces/pthread_cond_timedwait/2-3.test >$COMPLOG 2>&1
4648,4649c4648,4649
< conformance/interfaces/sched_getscheduler/4-1: execution: PASS
< conformance/interfaces/sched_getscheduler/1-1: execution: PASS
---
> conformance/interfaces/sched_getscheduler/4-1: execution: FAILED 
> conformance/interfaces/sched_getscheduler/1-1: execution: FAILED 
4653c4653
< conformance/interfaces/sched_getscheduler/3-1: execution: PASS
---
> conformance/interfaces/sched_getscheduler/3-1: execution: FAILED 
4692c4692
< /bin/sh: line 1:  4293 Segmentation fault      ./t0 240 conformance/interfaces/timer_delete/speculative/5-1.test >$COMPLOG 2>&1
---
> /bin/sh: line 1:  4288 Segmentation fault      ./t0 240 conformance/interfaces/timer_delete/speculative/5-1.test >$COMPLOG 2>&1
4876c4876
< conformance/interfaces/mlock/5-1: execution: PASS
---
> conformance/interfaces/mlock/5-1: execution: UNRESOLVED 
4879,4880c4879,4880
< conformance/interfaces/mlock/10-1: execution: PASS
< conformance/interfaces/mlock/8-1: execution: PASS
---
> conformance/interfaces/mlock/10-1: execution: UNRESOLVED 
> conformance/interfaces/mlock/8-1: execution: UNRESOLVED 
4922,4923c4922,4923
< conformance/interfaces/sched_get_priority_max/1-1: execution: PASS
< conformance/interfaces/sched_get_priority_max/1-2: execution: PASS
---
> conformance/interfaces/sched_get_priority_max/1-1: execution: FAILED 
> conformance/interfaces/sched_get_priority_max/1-2: execution: FAILED 
4925c4925
< conformance/interfaces/sched_get_priority_max/1-4: execution: PASS
---
> conformance/interfaces/sched_get_priority_max/1-4: execution: FAILED 
5456c5456
< /bin/sh: line 1: 12915 Segmentation fault      ./t0 240 conformance/interfaces/timer_settime/speculative/12-1.test >$COMPLOG 2>&1
---
> /bin/sh: line 1: 11871 Segmentation fault      ./t0 240 conformance/interfaces/timer_settime/speculative/12-1.test >$COMPLOG 2>&1
5722c5722
< /bin/sh: line 1: 15525 Segmentation fault      ./t0 240 conformance/interfaces/timer_gettime/speculative/6-1.test >$COMPLOG 2>&1
---
> /bin/sh: line 1: 14462 Segmentation fault      ./t0 240 conformance/interfaces/timer_gettime/speculative/6-1.test >$COMPLOG 2>&1
5784c5784
< conformance/interfaces/aio_cancel/3-1: execution: PASS
---
> conformance/interfaces/aio_cancel/3-1: execution: FAILED 
5788,5789c5788,5789
< conformance/interfaces/sched_rr_get_interval/1-1: execution: PASS
< conformance/interfaces/sched_rr_get_interval/2-1: execution: PASS
---
> conformance/interfaces/sched_rr_get_interval/1-1: execution: FAILED 
> conformance/interfaces/sched_rr_get_interval/2-1: execution: FAILED 
5847,5848c5847,5848
< 317.15user 224.14system 31:57.09elapsed 28%CPU (0avgtext+0avgdata 0maxresident)k
< 0inputs+0outputs (8major+36135568minor)pagefaults 0swaps
---
> 326.55user 224.21system 28:30.06elapsed 32%CPU (0avgtext+0avgdata 0maxresident)k
> 0inputs+0outputs (5major+36135269minor)pagefaults 0swaps


---
~Randy
