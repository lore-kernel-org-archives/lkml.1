Return-Path: <linux-kernel-owner+w=401wt.eu-S1760456AbYFDRrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760456AbYFDRrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbYFDRr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:47:29 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:30188 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbYFDRr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:47:28 -0400
Message-ID: <4846D52E.8060101@ct.jp.nec.com>
Date: Wed, 04 Jun 2008 10:47:26 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 4/4] per-task-delay-accounting: /proc export for memory
 reclaim delay
References: <20080603193825.12dbfff1.kobayashi.kk@ncos.nec.co.jp> <20080603194608.ed76ecf3.kobayashi.kk@ncos.nec.co.jp> <20080604120235.940B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080604120235.940B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi
> 
>> diff --git a/fs/proc/array.c b/fs/proc/array.c
>> index 9e3b8c3..a3e6e86 100644
>> --- a/fs/proc/array.c
>> +++ b/fs/proc/array.c
>> @@ -498,7 +498,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
>>
>>  	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
>>  %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
>> -%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
>> +%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %llu %lu %ld\n",
>>  		pid_nr_ns(pid, ns),
>>  		tcomm,
>>  		state,
>> @@ -544,6 +544,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
>>  		task->rt_priority,
>>  		task->policy,
>>  		(unsigned long long)delayacct_blkio_ticks(task),
>> +		(unsigned long long)delayacct_freepages_ticks(task),
>>  		cputime_to_clock_t(gtime),
>>  		cputime_to_clock_t(cgtime));
> 
> userland program oftern below access.
> thus, this patch break userland compatibility.

It's my fault. I suggested him to group delayacct ticks.
I know this breakage, but was not sure what it affects.
I thought that if it'll be a problem we get a claim such you did.

Thanks,
Hiroshi Shimamoto
