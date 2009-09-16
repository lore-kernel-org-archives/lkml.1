Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbZIPFXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbZIPFXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 01:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbZIPFXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 01:23:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49243 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbZIPFXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 01:23:08 -0400
Message-ID: <4AB076DE.10604@cn.fujitsu.com>
Date: Wed, 16 Sep 2009 13:25:50 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] ftrace: Add timer-source of walltime for ftrace
References: <alpine.DEB.2.00.0907272218480.30108@gandalf.stny.rr.com> <4A89213C.5090109@cn.fujitsu.com> <20090818215620.A63C.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0908181454090.727@gandalf.stny.rr.com> <4A939CDF.2000407@cn.fujitsu.com>
In-Reply-To: <4A939CDF.2000407@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I rebased patchset of "enable ftrace display walltime".

It can make ftrace display intuitionistic time information to user
with walltime clock.

We can get following output by using it:
 # cd /mnt/debugfs/tracing/
 # cat trace_clock
 [local] global walltime
 # echo sched_switch > current_tracer
 # cat trace
 # tracer: sched_switch
 #
 #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
 #              | |       |          |         |
             bash-3580  [000]  2916.188093:   3580:120:S   + [000]  3580:120:S bash
             bash-3580  [000]  2916.188205:   3580:120:S   + [000]  3580:120:S bash
             bash-3580  [000]  2916.188538:   3580:120:R   + [000]     5:115:S events/0
             bash-3580  [000]  2916.188599:   3580:120:R ==> [000]     5:115:R events/0
         events/0-5     [000]  2916.188669:      5:115:S ==> [000]  3580:120:R bash
 ...
 # echo walltime > trace_clock
 # cat trace
 # tracer: sched_switch
 #
 #           TASK-PID    CPU#           TIMESTAMP  FUNCTION
 #              | |       |                        |         |
             bash-3580  [000] 2009-08-24 18:03:16.500705:   3580:120:S   + [000]  3580:120:S bash
             bash-3580  [000] 2009-08-24 18:03:16.500815:   3580:120:S   + [000]  3580:120:S bash
             bash-3580  [000] 2009-08-24 18:03:16.500815:   3580:120:S   + [000]  3580:120:S bash
             bash-3580  [000] 2009-08-24 18:03:16.500815:   3580:120:S ==> [000]     5:115:R events/0
         events/0-5     [000] 2009-08-24 18:03:16.500815:      5:115:R   + [000]  3578:120:S sshd
 ...

It need to applys on my patch of:
[PATCH v4 1/2] Add function to convert between calendar time and broken-down time for universal use

Hi, Thomas,

To make ftrace's walltime function work, I need to add a tracepoint into xtime's code,
so we can set ftrace's walltime clockbase when time changed.

Could you have a look at this patch, and give me your suggestion?

Changelog:
v1->v2: Rebase to top of tip tree.

Thanks
Zhaolei


