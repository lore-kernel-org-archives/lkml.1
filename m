Return-Path: <linux-kernel-owner+w=401wt.eu-S1751216AbZEUFeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbZEUFeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 01:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbZEUFd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 01:33:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49430 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbZEUFd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 01:33:56 -0400
Message-ID: <4A14E805.9040103@cn.fujitsu.com>
Date: Thu, 21 May 2009 13:35:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 5/5] tracing: convert irq events to use __print_symbolic
References: <20090521031711.494593605@goodmis.org> <20090521031749.639465433@goodmis.org>
In-Reply-To: <20090521031749.639465433@goodmis.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define softirq_name(sirq) { sirq, #sirq }
> +#define show_softirq_name(val)						\
> +	__print_symbolic(val,						\
> +			 softirq_name(HI_SOFTIRQ),			\
> +			 softirq_name(TIMER_SOFTIRQ),			\
> +			 softirq_name(NET_TX_SOFTIRQ),			\
> +			 softirq_name(NET_RX_SOFTIRQ),			\
> +			 softirq_name(BLOCK_SOFTIRQ),			\
> +			 softirq_name(TASKLET_SOFTIRQ),			\
> +			 softirq_name(SCHED_SOFTIRQ),			\
> +			 softirq_name(HRTIMER_SOFTIRQ),			\
> +			 softirq_name(RCU_SOFTIRQ))
> +

The ending "_SOFTIRQ" is just redundant.

And it's you that removed "_SOFTIRQ" in the output of irq
trace events. ;)

==========
commit 899039e8746bb9a09b6487ddb8ab2275ce9d0256
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Mar 13 00:43:33 2009 -0400

    softirq: no need to have SOFTIRQ in softirq name

    Impact: clean up

    It is redundant to have 'SOFTIRQ' in the softirq names.
==========

How about:

#define softirq_name(sirq) { sirq ## _SOFTIRQ, #sirq }
#define show_softirq_name(val)						\
	__print_symbolic(val,						\
			 softirq_name(HI),				\

or:

#define softirq_name(sirq) { sirq, softirq_to_name[sirq] }

