Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab0BPQBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 11:01:40 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:53143 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab0BPQBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 11:01:38 -0500
Date: Tue, 16 Feb 2010 21:31:31 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [tip:sched/urgent] sched: Fix sched_mv_power_savings for !SMT
Message-ID: <20100216160131.GD8777@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20100208100555.GD2931@dirshya.in.ibm.com>
 <tip-28f5318167adf23b16c844b9c2253f355cb21796@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <tip-28f5318167adf23b16c844b9c2253f355cb21796@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* tip-bot for Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2010-02-16 14:15:43]:

> Commit-ID:  28f5318167adf23b16c844b9c2253f355cb21796
> Gitweb:     http://git.kernel.org/tip/28f5318167adf23b16c844b9c2253f355cb21796
> Author:     Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> AuthorDate: Mon, 8 Feb 2010 15:35:55 +0530
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Tue, 16 Feb 2010 15:13:59 +0100
> 
> sched: Fix sched_mv_power_savings for !SMT
                ^^^^^ _mc_

Minor typo, the summary should be 
"sched: Fix sched_mc_power_savings for !SMT cases"

Thanks,
Vaidy

> Fix for sched_mc_powersavigs for pre-Nehalem platforms.
> Child sched domain should clear SD_PREFER_SIBLING if parent will have
> SD_POWERSAVINGS_BALANCE because they are contradicting.
> 
> Sets the flags correctly based on sched_mc_power_savings.
> 
> Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <20100208100555.GD2931@dirshya.in.ibm.com>
> Cc: stable@kernel.org [2.6.32.x]
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/sched.h |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 78efe7c..1f5fa53 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -878,7 +878,10 @@ static inline int sd_balance_for_mc_power(void)
>  	if (sched_smt_power_savings)
>  		return SD_POWERSAVINGS_BALANCE;
> 
> -	return SD_PREFER_SIBLING;
> +	if (!sched_mc_power_savings)
> +		return SD_PREFER_SIBLING;
> +
> +	return 0;
>  }
> 
>  static inline int sd_balance_for_package_power(void)
