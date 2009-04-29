Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548AbZD2GFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbZD2GFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 02:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbZD2GEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 02:04:48 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:39167 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbZD2GEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 02:04:47 -0400
Date: Wed, 29 Apr 2009 11:34:15 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       seto.hidetoshi@jp.fujitsu.com
Subject: Re: [PATCH] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu
	cputime count
Message-ID: <20090429060415.GB789@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090428153611.EBC6.A69D9226@jp.fujitsu.com> <20090428220854.GC12698@balbir.in.ibm.com> <20090429032146.GA3408@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090429032146.GA3408@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bharata B Rao <bharata@linux.vnet.ibm.com> [2009-04-29 08:51:46]:

> On Wed, Apr 29, 2009 at 03:38:54AM +0530, Balbir Singh wrote:
> > * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-04-28 15:53:32]:
> > > 
> > >  	do {
> > > -		percpu_counter_add(&ca->cpustat[idx], val);
> > > +		__percpu_counter_add(&ca->cpustat[idx], val, cpuacct_batch);
> > 
> > This will make the end result very off the real value due to large
> > batch value per cpu. If we are going to go this route, we should
> > probably consider using __percpu_counter_sum so that the batch value
> > does not show data that is way off.
> 
> But __percpu_counter_sum takes fbc->lock spinlock and that is the cause of
> the problem Kosaki mentions I believe.

But this is on the user space read side (show stats), I thought
Kosaki's problem was with per_cpu_counter_add called from update
stats.

-- 
	Balbir
