Return-Path: <linux-kernel-owner+w=401wt.eu-S1758293AbZCXJBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbZCXJBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756628AbZCXJBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:01:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53776 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754493AbZCXJBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:01:06 -0400
Message-ID: <49C8A166.8050303@cn.fujitsu.com>
Date: Tue, 24 Mar 2009 17:01:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] blktrace: print human-readable act_mask
References: <49C893FC.9080905@cn.fujitsu.com> <49C89488.4030604@cn.fujitsu.com> <20090324083905.GB13016@elte.hu>
In-Reply-To: <20090324083905.GB13016@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> Print stringified act_mask instead of hex value:
>>  # cat act_mask
>>  read,write,barrier,sync,queue,requeue,issue,complete,fs,pc,ahead,meta,
>>  discard,drv_data
>>  # echo "meta,write" > act_mask
>>  # cat act_mask
>>  write,meta
> 
> Nice!
> 
> It would also be nice to activate trace filters for the blktrace 
> tracepoints - i.e. to convert them to the TRACE_EVENT() enumeration 
> format. Beyond user-space parseable field enumeration and filter, 
> that will also speed up tracing and allows binary record streaming 
> with splice() zero-copy.
> 
> Via that "act_mask" can become a filterable field and you can define 
> expressions to filter. All other fields like sector become in-kernel 
> filterable too.
> 
> See a few examples here:
> 
>  include/trace/irq_event_types.h
>  include/trace/sched_event_types.h
> 
> Note, blktrace tracepoints are certainly more complex than the 
> tracepoints above - you can embedd C statements in TRACE_EVENT()'s 
> TP_fast_assign() bit.
> 
> It was specifically designed to allow the support of blktrace 
> tracepoints, so you can embedd the blk_pc_request() and disk_devt() 
> translation for the block_rq_complete event or 
> block_rq_requeue/issue tracepoints.
> 

I'll look into this when I have time. :)
