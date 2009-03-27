Return-Path: <linux-kernel-owner+w=401wt.eu-S933210AbZC0Dae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210AbZC0Dae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 23:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbZC0Da0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 23:30:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61804 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754564AbZC0DaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 23:30:25 -0400
Message-ID: <49CC4866.5050604@cn.fujitsu.com>
Date: Fri, 27 Mar 2009 11:30:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] blktrace: make classic output more classic
References: <49CC37AA.3060908@cn.fujitsu.com> <49CC37C2.7050307@cn.fujitsu.com>
In-Reply-To: <49CC37C2.7050307@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -995,7 +995,7 @@ static int blk_log_action_iter(struct trace_iterator *iter, const char *act)
>  {
>  	char rwbs[6];
>  	unsigned long long ts  = ns2usecs(iter->ts);

This should be changed to "ts = iter->ts".

I'll fix it and resend the patchset, since this affects a later patch.

> -	unsigned long usec_rem = do_div(ts, USEC_PER_SEC);
> +	unsigned long nsec_rem = do_div(ts, NSEC_PER_SEC);
>  	unsigned secs	       = (unsigned long)ts;
>  	const struct trace_entry *ent = iter->ent;
>  	const struct blk_io_trace *t = (const struct blk_io_trace *)ent;
> @@ -1003,9 +1003,9 @@ static int blk_log_action_iter(struct trace_iterator *iter, const char *act)
>  	fill_rwbs(rwbs, t);
