Return-Path: <linux-kernel-owner+w=401wt.eu-S933840AbYD1MwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840AbYD1MwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 08:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763309AbYD1Mvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 08:51:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53755 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbYD1Mvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 08:51:54 -0400
Date: Mon, 28 Apr 2008 14:51:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fair-group: fix a Div0 error of the fair group
	scheduler
Message-ID: <20080428125141.GF27997@elte.hu>
References: <481558A0.9020803@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481558A0.9020803@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Miao Xie <miaox@cn.fujitsu.com> wrote:

> When I echoed 0 into the "cpu.shares" file, a Div0 error occured.
>
> We found it is caused by the following calling.
>
>   sched_group_set_shares(tg, shares)
>       set_se_shares(tg->se[i], shares/nr_cpu_ids)
>           __set_se_shares(se, shares)
>               div64_64((1ULL<<32), shares)
>
> When the echoed value was less than the number of processores, the 
> result of the sentence "shares/nr_cpu_ids" was 0, and then the system 
> called div64() to divide the result, the Div0 error occured.
>
> It is unnecessary that the shares value is divided by nr_cpu_ids, I 
> think. Because in the function __update_group_shares_cpu() and 
> init_tg_cfs_entry(), the shares value isn't divided by nr_cpu_ids when 
> setting shares of the sched entity.
>
> This patch fixes this bug. And echoing ULONG_MAX value into cpu.shares 
> also causes Div0 error, so we set a macro MAX_SHARES to limit the max 
> value of shares.

thanks, applied.

	Ingo
