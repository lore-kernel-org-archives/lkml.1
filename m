Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbYCDJuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbYCDJuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 04:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYCDJuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 04:50:03 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:55985 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbYCDJuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:50:01 -0500
Date: Tue, 4 Mar 2008 15:19:44 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
       serue@us.ibm.com, menage@google.com
Subject: Re: [RFC, PATCH 1/2] sched: change the fairness model of the CFS
	group scheduler
Message-ID: <20080304094944.GB3730@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080225141504.GA27746@linux.vnet.ibm.com> <20080225141604.GA29213@linux.vnet.ibm.com> <1204227768.6243.42.camel@lappy> <20080229090400.GD15328@linux.vnet.ibm.com> <1204281475.6243.73.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204281475.6243.73.camel@lappy>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 11:37:55AM +0100, Peter Zijlstra wrote:
> 
> On Fri, 2008-02-29 at 14:34 +0530, Dhaval Giani wrote:
> 
> > > > +#elif defined CONFIG_USER_SCHED
> > > > +		/*
> > > > +		 * In case of task-groups formed thr' the user id of tasks,
> > > > +		 * init_task_group represents tasks belonging to root user.
> > > > +		 * Hence it forms a sibling of all subsequent groups formed.
> > > > +		 * In this case, init_task_group gets only a fraction of overall
> > > > +		 * system cpu resource, based on the weight assigned to root
> > > > +		 * user's cpu share (INIT_TASK_GROUP_LOAD). This is accomplished
> > > > +		 * by letting tasks of init_task_group sit in a separate cfs_rq
> > > > +		 * (init_cfs_rq) and having one entity represent this group of
> > > > +		 * tasks in rq->cfs (i.e init_task_group->se[] != NULL).
> > > > +		 */
> > > >  		init_tg_cfs_entry(rq, &init_task_group,
> > > >  				&per_cpu(init_cfs_rq, i),
> > > >  				&per_cpu(init_sched_entity, i), i, 1);
> > > 
> > > But I fail to parse this lengthy comment. What does it do:
> > > 
> > >     init_group
> > >    /     |    \
> > > uid-0 uid-1000 uid-n
> > > 
> > > or does it blend uid-0 into the init_group?
> > > 
> > 
> > It blends uid-0 (root) into init_group.
> 
> Any particular reason why? It seems to me uid-0 should be treated like
> any other uid.
> 

Ah, I misunderstood your question. We have not changed anything for UID
scheduling as no task can (should) exist at the root level (init_group).
Your initial figure is right, sorry for the confusion.

Thanks,
-- 
regards,
Dhaval
