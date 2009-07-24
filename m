Return-Path: <linux-kernel-owner+w=401wt.eu-S1751633AbZGXEb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbZGXEb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 00:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbZGXEb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 00:31:57 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:39327 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZGXEb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 00:31:57 -0400
Date: Fri, 24 Jul 2009 10:00:01 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Ken Chen <kenchen@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: CFS group scheduler fairness broken starting from 2.6.29-rc1
Message-ID: <20090724043001.GC5304@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090723075735.GA18878@in.ibm.com> <b040c32a0907231517l265a9528w628d48fa3625e261@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b040c32a0907231517l265a9528w628d48fa3625e261@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 03:17:18PM -0700, Ken Chen wrote:
> On Thu, Jul 23, 2009 at 12:57 AM, Bharata B
> Rao<bharata@linux.vnet.ibm.com> wrote:
> > Hi,
> >
> > Group scheduler fainess is broken since 2.6.29-rc1. git bisect led me
> > to this commit:
> >
> > commit ec4e0e2fe018992d980910db901637c814575914
> > Author: Ken Chen <kenchen@google.com>
> > Date:   Tue Nov 18 22:41:57 2008 -0800
> >
> >    sched: fix inconsistency when redistribute per-cpu tg->cfs_rq shares
> >
> >    Impact: make load-balancing more consistent
> > ....
> >
> > ======================================================================
> >                        % CPU time division b/n groups
> > Group           2.6.29-rc1              2.6.29-rc1 w/o the above patch
> > ======================================================================
> > a with 8 tasks  44                      31
> > b with 5 tasks  32                      34
> > c with 3 tasks  22                      34
> > ======================================================================
> > All groups had equal shares.
> 
> What value did you use for each task_group's share?  For very large
> value of tg->shares, it could be that all of the boost went to one CPU
> and subsequently causes load-balancer to shuffle tasks around.  Do you
> see any unexpected task migration?

Used default 1024 for each group.

Without your patch, each of the tasks see around 165 migrations during
a 60s run, but with your patch, they see 125 migrations (as per
se.nr_migrations). I am using a 8CPU machine here.

Regards,
Bharata.
