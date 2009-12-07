Return-Path: <linux-kernel-owner+w=401wt.eu-S934723AbZLGIjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934723AbZLGIjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933588AbZLGIjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:39:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53789 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933619AbZLGIjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:39:37 -0500
Message-ID: <4B1CBEEB.3090800@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 16:38:03 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] perf lock: New subcommand "lock" to perf for analyzing
 lock statistics
References: <20091115022135.GA5427@nowhere> <1260156884-8474-2-git-send-email-mitake@dcl.info.waseda.ac.jp> <20091207044125.GB5262@nowhere> <20091207072752.GG10868@elte.hu>
In-Reply-To: <20091207072752.GG10868@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:

> Also, i agree that the performance aspect is probably the most pressing 
> issue. Note that 'perf bench sched messaging' is very locking intense so 
> a 10x slowdown is not entirely unexpected - we still ought to optimize 
> it all some more. 'perf lock' is an excellent testcase for this in any 
> case.
> 

Here are some test results to show the overhead of lockdep trace events:

                   select    pagefault   mmap    Memory par   Cont_SW
                   latency    latency   latency   R/W BD      latency

disable ftrace        0         0         0         0          0

enable all ftrace  -16.65%    -109.80%   -93.62%   0.14%      -6.94%

enable all ftrace  -2.67%      1.08%     -3.65%   -0.52%      -0.68%
except lockdep


We also found big overhead when using kernbench and fio, but we haven't
verified whether it's caused by lockdep events.

Thanks,
Xiao
