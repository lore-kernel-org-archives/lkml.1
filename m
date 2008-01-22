Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbYAVQiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbYAVQiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 11:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYAVQh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 11:37:58 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60867 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbYAVQh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 11:37:57 -0500
Date: Tue, 22 Jan 2008 22:21:21 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] sched: don't take a mutex from interrupt context
Message-ID: <20080122165121.GE31049@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20080122023626.GA12213@darkstar.te-china.tietoenator.com> <1201019138.6341.24.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201019138.6341.24.camel@lappy>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 05:25:38PM +0100, Peter Zijlstra wrote:
> @@ -1428,9 +1428,9 @@ static void print_cfs_stats(struct seq_f
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  	print_cfs_rq(m, cpu, &cpu_rq(cpu)->cfs);
>  #endif
> -	lock_task_group_list();
> +	rcu_read_lock();
>  	for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
>  		print_cfs_rq(m, cpu, cfs_rq);

Isn't there a possibility that print_cfs_rq() can block?

> -	unlock_task_group_list();
> +	rcu_read_unlock();
>  }
>  #endif
> 

-- 
Regards,
vatsa
