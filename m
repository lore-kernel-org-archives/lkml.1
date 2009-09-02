Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbZIBGQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbZIBGQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 02:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbZIBGQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 02:16:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40375 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbZIBGQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 02:16:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 2 Sep 2009 15:15:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [mmotm][PATCH] coalescing uncharge
Message-Id: <20090902151500.532ffc2f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090902134114.b6f1a04d.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090902093438.eed47a57.kamezawa.hiroyu@jp.fujitsu.com>
	<20090902134114.b6f1a04d.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Sep 2009 13:41:14 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

>  #ifdef CONFIG_SWAP
>  /*
>   * called after __delete_from_swap_cache() and drop "page" account.
> Index: mmotm-2.6.31-Aug27/include/linux/sched.h
> ===================================================================
> --- mmotm-2.6.31-Aug27.orig/include/linux/sched.h
> +++ mmotm-2.6.31-Aug27/include/linux/sched.h
> @@ -1540,6 +1540,13 @@ struct task_struct {
>  	unsigned long trace_recursion;
>  #endif /* CONFIG_TRACING */
>  	unsigned long stack_start;
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR /* memcg uses this to do batch job */
> +	struct memcg_batch_info {
> +		bool do_batch;
> +		struct mem_cgroup *memcg;
> +		long pages, memsw;
> +	} memcg_batch;
> +#endif
I wonder I should make this as a pointer
	struct memcg_batch_info *

and allocate this dynamically at attach. Hmm. maybe useful for other purpose
to track per-task memcg behavior.

Regards,
-Kmae

