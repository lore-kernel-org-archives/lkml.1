Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbZLGHcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbZLGHcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758576AbZLGHcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:32:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60387 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757980AbZLGHcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:32:07 -0500
Date: Mon, 7 Dec 2009 08:30:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Xiao Guangrong <ericxiao.gr@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, T??r??k Edwin <edwintorok@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] perf/sched: fix for getting task's execution time
Message-ID: <20091207073043.GH10868@elte.hu>
References: <4B1B8E0E.3040007@cn.fujitsu.com>
 <1260097512.7818.341.camel@laptop>
 <1260097609.7818.349.camel@laptop>
 <4B1BE588.8020608@gmail.com>
 <4B1CACC4.3030709@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1CACC4.3030709@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> In current code, task's execute time is got by reading
> '/proc/<pid>/sched' file, it's wrong if the task is created
> by pthread_create(), because every thread task has same pid.
> 
> This way also has two demerits:
> 
> 1: 'perf sched replay' can't work if the kernel not compile with
>    'CONFIG_SCHED_DEBUG' option
> 2: perf tool should depend on proc file system
> 
> So, this patch call getrusage() to get task's execution time instead
> of reading /proc file

ok, that's better than /proc, but how about using 
PERF_COUNT_SW_TASK_CLOCK instead of rusage, to recover the CPU time 
used? It would be more precise, and it would use the perf API. (Some 
helper functions in tools/perf/lib/ would be nice to make it as easy to 
use as rusage (or even easier if possible).)

	Ingo
