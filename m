Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbZCKPez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbZCKPez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbZCKPeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:34:46 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:44144 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbZCKPep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:34:45 -0400
Date: Wed, 11 Mar 2009 21:04:34 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH] cpuacct: per-cgroup utime/stime statistics - v1
Message-ID: <20090311153434.GB16769@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090310124208.GC3902@in.ibm.com> <20090311093812.298a0b21.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090311093812.298a0b21.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-11 09:38:12]:

> On Tue, 10 Mar 2009 18:12:08 +0530
> Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
> 
> > Hi,
> > 
> > Based on the comments received during my last post
> > (http://lkml.org/lkml/2009/2/25/129), here is a fresh attempt
> > to get per-cgroup utime/stime statistics as part of cpuacct controller.
> > 
> > This patch adds a new file cpuacct.stat which displays two stats:
> > utime and stime. I wasn't too sure about the usefulness of providing
> > per-cgroup guest and steal times and hence not including them here.
> > 
> > Note that I am using percpu_counter for collecting these two stats.
> > Since percpu_counter subsystem doesn't protect the readside, readers could
> > theoritically obtain incorrect values for these stats on 32bit systems.
> 
> Using percpu_counter_read() means that .. but is it okay to ignore "batch"
> number ? (see FBC_BATCH)
>

FBC_BATCH? Thats gone..no? We have dynamic batches now, IIRC. Could
you please elaborate on your comment?
 
> 
> > I hope occasional wrong values is not too much of a concern for
> > statistics like this. If it is a problem, we have to either fix
> > percpu_counter or do it all by ourselves as Kamezawa attempted
> > for cpuacct.usage (http://lkml.org/lkml/2009/3/4/14)
> > 
> Hmm, percpu_counter_sum() is bad ?
> 

Yes, but we need to sum somewhere..  user space summing will not be
atomic, we'll get several snapshots of per CPU data and summing it
might not yield the correct answers.

> BTW, I'm not sure but don't we need special handling if
> CONFIG_VIRT_CPU_ACCOUNTING=y ?

Good point. Bharata, with CONFIG_VIRT_CPU_ACCOUNTING, utime and stime
is accounted for within the architecture.

-- 
	Balbir
