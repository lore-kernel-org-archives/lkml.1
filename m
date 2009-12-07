Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbZLGPAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbZLGPAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758207AbZLGPAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:00:48 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:54771 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926AbZLGPAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:00:45 -0500
Date: Tue, 08 Dec 2009 00:00:48 +0900 (JST)
Message-Id: <20091208.000048.123217523.mitake@dcl.info.waseda.ac.jp>
To: xiaoguangrong@cn.fujitsu.com
Cc: mingo@elte.hu, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, paulus@samba.org, tzanussi@gmail.com,
       srostedt@redhat.com, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH 2/2] perf lock: New subcommand "lock" to perf for
 analyzing lock statistics
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <4B1CBEEB.3090800@cn.fujitsu.com>
References: <20091207044125.GB5262@nowhere>
	<20091207072752.GG10868@elte.hu>
	<4B1CBEEB.3090800@cn.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] perf lock: New subcommand "lock" to perf for analyzing lock statistics
Date: Mon, 07 Dec 2009 16:38:03 +0800

Hi Xiao,

> 
> 
> Ingo Molnar wrote:
> 
> > Also, i agree that the performance aspect is probably the most pressing 
> > issue. Note that 'perf bench sched messaging' is very locking intense so 
> > a 10x slowdown is not entirely unexpected - we still ought to optimize 
> > it all some more. 'perf lock' is an excellent testcase for this in any 
> > case.
> > 
> 
> Here are some test results to show the overhead of lockdep trace events:
> 
>                    select    pagefault   mmap    Memory par   Cont_SW
>                    latency    latency   latency   R/W BD      latency
> 
> disable ftrace        0         0         0         0          0
> 
> enable all ftrace  -16.65%    -109.80%   -93.62%   0.14%      -6.94%
> 
> enable all ftrace  -2.67%      1.08%     -3.65%   -0.52%      -0.68%
> except lockdep
> 
> 
> We also found big overhead when using kernbench and fio, but we haven't
> verified whether it's caused by lockdep events.

Thanks for your terrible but important data.
Difference between "enable all ftrace" and "enable all ftrace except lockdep"
is significant... This must be reduced.

Thanks
	Hitoshi
