Return-Path: <linux-kernel-owner+w=401wt.eu-S1760657AbXGNRMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbXGNRMp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 13:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbXGNRMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 13:12:39 -0400
Received: from mail.screens.ru ([213.234.233.54]:46538 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757012AbXGNRMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 13:12:38 -0400
Date: Sat, 14 Jul 2007 21:14:06 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH -rt 1/5] workqueue: queue_work_cpu
Message-ID: <20070714171406.GA746@tv-sign.ru>
References: <20070714175733.194012000@chello.nl> <20070714175839.377905000@chello.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714175839.377905000@chello.nl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14, Peter Zijlstra wrote:
>
> +int fastcall queue_work_cpu(struct workqueue_struct *wq, struct work_struct *work, int cpu)
> +{
> +	int ret = 0;
> +
> +	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
> +		BUG_ON(!list_empty(&work->entry));
> +		__queue_work(wq_per_cpu(wq, cpu), work);
> +		ret = 1;
> +	}
> +	return ret;
> +}

Minor nit, we already have queue_delayed_work_on(), perhaps it should be named
queue_work_on().

Oleg.

