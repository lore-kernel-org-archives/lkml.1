Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbZCLAPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbZCLAPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 20:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbZCLAPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 20:15:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34994 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbZCLAPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 20:15:33 -0400
Date: Thu, 12 Mar 2009 09:14:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH] cpuacct: per-cgroup utime/stime statistics - v1
Message-Id: <20090312091408.90e602ce.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090311153434.GB16769@balbir.in.ibm.com>
References: <20090310124208.GC3902@in.ibm.com>
	<20090311093812.298a0b21.kamezawa.hiroyu@jp.fujitsu.com>
	<20090311153434.GB16769@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 21:04:34 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > This patch adds a new file cpuacct.stat which displays two stats:
> > > utime and stime. I wasn't too sure about the usefulness of providing
> > > per-cgroup guest and steal times and hence not including them here.
> > > 
> > > Note that I am using percpu_counter for collecting these two stats.
> > > Since percpu_counter subsystem doesn't protect the readside, readers could
> > > theoritically obtain incorrect values for these stats on 32bit systems.
> > 
> > Using percpu_counter_read() means that .. but is it okay to ignore "batch"
> > number ? (see FBC_BATCH)
> >
> 
> FBC_BATCH? Thats gone..no? We have dynamic batches now, IIRC. Could
> you please elaborate on your comment?
>  
Ah, ok. it's now extern int percpu_counter_batch.

-Kame

> > 
> > > I hope occasional wrong values is not too much of a concern for
> > > statistics like this. If it is a problem, we have to either fix
> > > percpu_counter or do it all by ourselves as Kamezawa attempted
> > > for cpuacct.usage (http://lkml.org/lkml/2009/3/4/14)
> > > 
> > Hmm, percpu_counter_sum() is bad ?
> > 
> 
> Yes, but we need to sum somewhere..  user space summing will not be
> atomic, we'll get several snapshots of per CPU data and summing it
> might not yield the correct answers.
> 
> > BTW, I'm not sure but don't we need special handling if
> > CONFIG_VIRT_CPU_ACCOUNTING=y ?
> 
> Good point. Bharata, with CONFIG_VIRT_CPU_ACCOUNTING, utime and stime
> is accounted for within the architecture.
> 
> -- 
> 	Balbir
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

