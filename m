Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbZFBQA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbZFBQA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 12:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbZFBQAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 12:00:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45399 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbZFBQAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 12:00:17 -0400
Date: Tue, 2 Jun 2009 17:55:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       acme@redhat.com, paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       jkacur@redhat.com, efault@gmx.de, ebiederm@xmission.com,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Subject: Re: [tip:perfcounters/core] perf_counter: Use PID namespaces
	properly
Message-ID: <20090602154816.GA15734@redhat.com>
References: <tip-709e50cf870e61745b39552044aa6c7c38e4f9e0@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-709e50cf870e61745b39552044aa6c7c38e4f9e0@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02, tip-bot for Peter Zijlstra wrote:
>
> +static u32 perf_counter_pid(struct perf_counter *counter, struct task_struct *p)
> +{
> +	/*
> +	 * only top level counters have the pid namespace they were created in
> +	 */
> +	if (counter->parent)
> +		counter = counter->parent;
> +
> +	return task_tgid_nr_ns(p, counter->ns);
> +}
> +
> +static u32 perf_counter_tid(struct perf_counter *counter, struct task_struct *p)
> +{
> +	/*
> +	 * only top level counters have the pid namespace they were created in
> +	 */
> +	if (counter->parent)
> +		counter = counter->parent;
> +
> +	return task_pid_nr_ns(p, counter->ns);

Perhaps this should be

	return task_pid_nr_ns(p->group_leader);

?

> +		tid_entry.pid = perf_counter_pid(counter, current);
> +		tid_entry.tid = perf_counter_tid(counter, current);


Otherwise we seem to always report .pid == .tid

Oleg.

