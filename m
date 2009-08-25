Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZHYIJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZHYIJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZHYIJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:09:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52527 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753989AbZHYIJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:09:14 -0400
Message-ID: <4A939CDF.2000407@cn.fujitsu.com>
Date: Tue, 25 Aug 2009 16:12:15 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] ftrace: Add timer-source of walltime for ftrace
References: <alpine.DEB.2.00.0907272218480.30108@gandalf.stny.rr.com> <4A89213C.5090109@cn.fujitsu.com> <20090818215620.A63C.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0908181454090.727@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0908181454090.727@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I finished this patchset to enable ftrace display walltime.

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

This patchset merged suggestion of Steven, Frederic and Kosaki-san on last RFC.

Thanks
Zhaolei

