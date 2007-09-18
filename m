Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbXIRKeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbXIRKeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 06:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbXIRKd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 06:33:58 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35728 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099AbXIRKd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 06:33:57 -0400
Date: Tue, 18 Sep 2007 16:14:37 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: containers@lists.osdl.org, Ingo Molnar <mingo@elte.hu>,
       ckrm-tech@lists.sourceforge.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Hookup group-scheduler with task container infrastructure
Message-ID: <20070918104437.GA18221@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070910171049.GA16048@linux.vnet.ibm.com> <20070918171945.d0593a08.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918171945.d0593a08.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 05:19:45PM +0900, KAMEZAWA Hiroyuki wrote:
> Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> > +	tg->cfs_rq = kzalloc(sizeof(cfs_rq) * num_possible_cpus(), GFP_KERNEL);
> > +	if (!tg->cfs_rq)
> > +		goto err;
> > +	tg->se = kzalloc(sizeof(se) * num_possible_cpus(), GFP_KERNEL);
> > +	if (!tg->se)
> > +		goto err;
> Sorry for very lazy responce..
> 
> num_possible_cpus() just returns # of possible cpus. Then it will not return
> Max-cpu-id to be used. I think just use NR_CPUS here is an easy way.

Good catch! Yes, you are right, the pointer array needs to be NR_CPUS
size.

On closer examination, I think I can simply use alloc_percpu() here.
Will send a patch after some testing.

-- 
Regards,
vatsa
