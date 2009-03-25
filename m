Return-Path: <linux-kernel-owner+w=401wt.eu-S1760646AbZCYQEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646AbZCYQEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759305AbZCYQEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:04:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:21464 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760855AbZCYQEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:04:22 -0400
MIME-Version: 1.0
In-Reply-To: <tip-b7bb4c9bb01941fe8feb653f3410e7ed0c9bb786@git.kernel.org>
References: <20090325091427.13992.18933.stgit@sofia.in.ibm.com> 
	<tip-b7bb4c9bb01941fe8feb653f3410e7ed0c9bb786@git.kernel.org>
Date: Wed, 25 Mar 2009 09:04:05 -0700
Message-ID: <2c0942db0903250904x799271b5s78a1007d0fdbbb77@mail.gmail.com>
Subject: Re: [tip:sched/balancing] sched: Add comments to find_busiest_group() 
	function
From: Ray Lee <ray-lk@madrabbit.org>
To: mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, balbir@in.ibm.com,
       bharata@linux.vnet.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, nickpiggin@yahoo.com.au, svaidy@linux.vnet.ibm.com,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit says it's just adding comments, but...

On Wed, Mar 25, 2009 at 5:30 AM, Gautham R Shenoy <ego@in.ibm.com> wrote:
> Commit-ID:  b7bb4c9bb01941fe8feb653f3410e7ed0c9bb786
> Gitweb:     http://git.kernel.org/tip/b7bb4c9bb01941fe8feb653f3410e7ed0c9bb786
> Author:     Gautham R Shenoy <ego@in.ibm.com>
> AuthorDate: Wed, 25 Mar 2009 14:44:27 +0530
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 25 Mar 2009 13:28:30 +0100
>
> sched: Add comments to find_busiest_group() function
>
> Impact: cleanup
>
> Add /** style comments around find_busiest_group(). Also add a few
> explanatory comments.

...but there are actual code changes. Hard to know if you intended to
do that and forgot to changelog it, or if it's an unexpected hunk that
accidentally got included:

>        if (balance && !(*balance))
>                goto ret;
>
> -       if (!sds.busiest || sds.this_load >= sds.max_load
> -               || sds.busiest_nr_running == 0)
> +       if (!sds.busiest || sds.busiest_nr_running == 0)
> +               goto out_balanced;
> +
> +       if (sds.this_load >= sds.max_load)
>                goto out_balanced;
>
>        sds.avg_load = (SCHED_LOAD_SCALE * sds.total_load) / sds.total_pwr;
>
> -       if (sds.this_load >= sds.avg_load ||
> -                       100*sds.max_load <= sd->imbalance_pct * sds.this_load)
> +       if (sds.this_load >= sds.avg_load)
> +               goto out_balanced;
> +
> +       if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
>                goto out_balanced;
>
>        sds.busiest_load_per_task /= sds.busiest_nr_running;
