Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbZCWLdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbZCWLdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 07:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbZCWLc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 07:32:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755232AbZCWLcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 07:32:53 -0400
Date: Mon, 23 Mar 2009 04:21:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH -tip] cpuacct: per-cgroup utime/stime statistics - v4
Message-Id: <20090323042123.87a673ac.akpm@linux-foundation.org>
In-Reply-To: <20090323043538.GB3306@in.ibm.com>
References: <20090323043538.GB3306@in.ibm.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Mar 2009 10:05:38 +0530 Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:

> +static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
> +		struct cgroup_map_cb *cb)
> +{
> +	struct cpuacct *ca = cgroup_ca(cgrp);
> +	int i;
> +
> +	for (i = 0; i < CPUACCT_STAT_NSTATS; i++) {
> +		s64 val = percpu_counter_read(&ca->cpustat[i]);
> +		val = cputime_to_clock_t(val);
> +		cb->fill(cb, cpuacct_stat_desc[i], val);
> +	}
> +	return 0;
> +}

I'd have expected `val' to have type clock_t.  But clock_t is 32-bit on
32-bit x86.

Is it correct to pass a 64-bit value to a function which takes a 32-bit
value and to then copy the 32-bit return value into a 64-bit variable?


