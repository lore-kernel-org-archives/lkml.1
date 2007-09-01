Return-Path: <linux-kernel-owner+w=401wt.eu-S932850AbXIAWYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbXIAWYH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 18:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757151AbXIAWX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 18:23:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:45806 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756976AbXIAWXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 18:23:55 -0400
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Track accurate idle time with tick_sched.idle_sleeptime
References: <20070827215611.GA30396@linux-os.sc.intel.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Sep 2007 00:23:53 +0200
In-Reply-To: <20070827215611.GA30396@linux-os.sc.intel.com>
Message-ID: <p73bqcmvxc6.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi <venkatesh.pallipadi@intel.com> writes:
>  
> +void tick_nohz_stop_idle(int cpu)
> +{
> +	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
> +
> +	if (ts->idle_active) {
> +		ktime_t now, delta;
> +		now = ktime_get();

That could be PM timer read costing thousands of cycles.

For going into idle it's probably not a real problem, but it could
seriously affect out of idle latencies.

You would really need a cheaper per CPU timer that doesn't
stop in idle (which rules out sched_clock). It's all unfortunately
quite messy.

-Andi
