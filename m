Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbYFDDH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbYFDDH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 23:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYFDDHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 23:07:13 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34713 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbYFDDHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 23:07:12 -0400
Date: Wed, 04 Jun 2008 12:07:29 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Subject: Re: [PATCH 4/4] per-task-delay-accounting: /proc export for memory reclaim delay
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20080603194608.ed76ecf3.kobayashi.kk@ncos.nec.co.jp>
References: <20080603193825.12dbfff1.kobayashi.kk@ncos.nec.co.jp> <20080603194608.ed76ecf3.kobayashi.kk@ncos.nec.co.jp>
Message-Id: <20080604120235.940B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 9e3b8c3..a3e6e86 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -498,7 +498,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
> 
>  	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
>  %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
> -%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
> +%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %llu %lu %ld\n",
>  		pid_nr_ns(pid, ns),
>  		tcomm,
>  		state,
> @@ -544,6 +544,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
>  		task->rt_priority,
>  		task->policy,
>  		(unsigned long long)delayacct_blkio_ticks(task),
> +		(unsigned long long)delayacct_freepages_ticks(task),
>  		cputime_to_clock_t(gtime),
>  		cputime_to_clock_t(cgtime));

userland program oftern below access.
thus, this patch break userland compatibility.

----------------------------------------
#!/usr/bin/perl

$stat = `cat /proc/$pid/stat`;
split
@stat_list = split(/ / , $stat);
print stat_list[$index];
                 ^
                 |
                 use array index number



