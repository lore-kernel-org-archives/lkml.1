Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbYKJJ3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbYKJJ3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbYKJJ33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:29:29 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:32622 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbYKJJ33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:29:29 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] sched: Include group statistics in /proc/sched_debug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>
In-Reply-To: <20081110092350.GA3679@in.ibm.com>
References: <20081110092350.GA3679@in.ibm.com>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 10:30:07 +0100
Message-Id: <1226309407.2697.4034.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-10 at 14:53 +0530, Bharata B Rao wrote:
> Include group statistics in /proc/sched_debug.
> 
> Since the statistics of a group entity isn't exported directly from the
> kernel, it becomes difficult to obtain some of the group statistics.
> For example, the current method to obtain exec time of a group entity
> is not always accurate. One has to read the exec times of all
> the tasks(/proc/<pid>/sched) in the group and add them. This method
> fails (or becomes difficult) if we want to collect stats of a group over
> a duration where tasks get created and terminated.
> 
> This patch makes it easier to obtain group stats by directly including
> them in /proc/sched_debug. Stats like group exec time would help user
> programs (like LTP) to accurately measure the group fairness.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> ---

<snip patch>

> An extract of /proc/sched_debug showing group stats obtained from
> this patch:
> 
> group[1]:/3/a/1
>   .se->exec_start                : 256484.781577
>   .se->vruntime                  : 12868.176994
>   .se->sum_exec_runtime          : 3243.669709
>   .se->wait_start                : 0.000000
>   .se->sleep_start               : 0.000000
>   .se->block_start               : 0.000000
>   .se->sleep_max                 : 0.000000
>   .se->block_max                 : 0.000000
>   .se->exec_max                  : 1.002095
>   .se->slice_max                 : 13.997073
>   .se->wait_max                  : 67.978322
>   .se->wait_sum                  : 7141.676906
>   .se->wait_count                : 203
>   .se->load.weight               : 255

Why not simply add them to the cfs_rq[n]:/path sections we already have?

