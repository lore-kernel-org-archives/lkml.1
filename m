Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbYAVQsC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbYAVQsC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 11:48:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYAVQrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 11:47:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41553 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYAVQru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 11:47:50 -0500
Subject: Re: [PATCH] sched: don't take a mutex from interrupt context
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: vatsa@linux.vnet.ibm.com
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
In-Reply-To: <20080122165121.GE31049@linux.vnet.ibm.com>
References: <20080122023626.GA12213@darkstar.te-china.tietoenator.com>
	 <1201019138.6341.24.camel@lappy>
	 <20080122165121.GE31049@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 17:47:34 +0100
Message-Id: <1201020454.6341.29.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-22 at 22:21 +0530, Srivatsa Vaddagiri wrote:
> On Tue, Jan 22, 2008 at 05:25:38PM +0100, Peter Zijlstra wrote:
> > @@ -1428,9 +1428,9 @@ static void print_cfs_stats(struct seq_f
> >  #ifdef CONFIG_FAIR_GROUP_SCHED
> >  	print_cfs_rq(m, cpu, &cpu_rq(cpu)->cfs);
> >  #endif
> > -	lock_task_group_list();
> > +	rcu_read_lock();
> >  	for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
> >  		print_cfs_rq(m, cpu, cfs_rq);
> 
> Isn't there a possibility that print_cfs_rq() can block?

It should not, that would be another bug, but from a quick glance at the
code it doesn't do that.

> 
> > -	unlock_task_group_list();
> > +	rcu_read_unlock();
> >  }
> >  #endif
> > 
> 

