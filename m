Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbZEABRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbZEABRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 21:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZEABRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 21:17:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908AbZEABRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 21:17:33 -0400
Date: Thu, 30 Apr 2009 18:10:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, bharata@linux.vnet.ibm.com,
       balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl,
       balbir@linux.vnet.ibm.com, mingo@elte.hu, schwidefsky@de.ibm.com,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH v2] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu
 cputime count
Message-Id: <20090430181045.516cc106.akpm@linux-foundation.org>
In-Reply-To: <20090430151008.D21C.A69D9226@jp.fujitsu.com>
References: <20090430151008.D21C.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 15:11:15 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 
> Changelog:
>   since v1
>   - use percpu_counter_sum() instead percpu_counter_read()
> 
> 
> -------------------------------------
> Subject: [PATCH v2] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu cputime count
> 
> cpuacct_update_stats() is called at every tick updating. and it use percpu_counter
> for avoiding performance degression.
> 
> For archs which define VIRT_CPU_ACCOUNTING, every tick would result
> in >1000 units of cputime updates and since this is much much greater
> than percpu_batch_counter, we end up taking spinlock on every tick.
> 
> This patch change batch rule. now, any cpu can store "percpu_counter_bach * jiffies"
> cputime in per-cpu cache.
> it mean this patch don't have behavior change if VIRT_CPU_ACCOUNTING=n.

Does this actually matter?

If we're calling cpuacct_update_stats() with large values of `cputime'
then presumably we're also calling cpuacct_update_stats() at a low
frequency, so the common lock-taking won't cause performance problems?

