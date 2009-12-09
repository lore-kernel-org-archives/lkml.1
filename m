Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbZLIJ4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbZLIJ4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbZLIJ4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:56:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52369 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbZLIJ4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:56:19 -0500
Message-ID: <4B1F73E1.6040000@cn.fujitsu.com>
Date: Wed, 09 Dec 2009 17:54:41 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Xiao Guangrong <ericxiao.gr@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, T??r??k Edwin <edwintorok@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] perf/sched: fix for getting task's execution time
References: <4B1B8E0E.3040007@cn.fujitsu.com> <1260097512.7818.341.camel@laptop> <1260097609.7818.349.camel@laptop> <4B1BE588.8020608@gmail.com> <4B1CACC4.3030709@cn.fujitsu.com> <20091207073043.GH10868@elte.hu> <4B1F7322.80103@cn.fujitsu.com>
In-Reply-To: <4B1F7322.80103@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, miss Reported-by, please ignore this mail, i'll resend it

Xiao Guangrong wrote:
> In current code, task's execute time is got by reading
> '/proc/<pid>/sched' file, it's wrong if the task is created
> by pthread_create(), because every thread task has same pid.
> 
> This way also has two demerits:
> 
> 1: 'perf sched replay' can't work if the kernel not compile
>     with 'CONFIG_SCHED_DEBUG' option
> 2: perf tool should depend on proc file system
> 
> So, this patch use PERF_COUNT_SW_TASK_CLOCK to get task's
> execution time instead of reading /proc file
> 
> Changelog v2 -> v3:
> use PERF_COUNT_SW_TASK_CLOCK instead of rusage() as Ingo's suggestion
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
