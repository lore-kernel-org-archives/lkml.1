Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbZHLD4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbZHLD4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 23:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbZHLD4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 23:56:14 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:52653 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZHLD4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 23:56:13 -0400
Date: Wed, 12 Aug 2009 09:26:05 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       kosaki.motohiro@jp.fujitsu.com, menage@google.com, prarit@redhat.com,
       andi.kleen@intel.com, xemul@openvz.org, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Help Resource Counters Scale better (v4)
Message-ID: <20090812035605.GF7176@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090811144405.GW7176@balbir.in.ibm.com> <20090811163159.ddc5f5fd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090811163159.ddc5f5fd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2009-08-11 16:31:59]:

> On Tue, 11 Aug 2009 20:14:05 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > Enhancement: Remove the overhead of root based resource counter accounting
> > 
> > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > 
> > This patch reduces the resource counter overhead (mostly spinlock)
> > associated with the root cgroup. This is a part of the several
> > patches to reduce mem cgroup overhead. I had posted other
> > approaches earlier (including using percpu counters). Those
> > patches will be a natural addition and will be added iteratively
> > on top of these.
> > 
> > The patch stops resource counter accounting for the root cgroup.
> > The data for display is derived from the statisitcs we maintain
> > via mem_cgroup_charge_statistics (which is more scalable).
> > 
> > The tests results I see on a 24 way show that
> > 
> > 1. The lock contention disappears from /proc/lock_stats
> > 2. The results of the test are comparable to running with
> >    cgroup_disable=memory.
> > 
> > Please test/review.
> 
> I don't get it.
> 
> The patch apepars to skip accounting altogether for the root memcgroup
> and then adds some accounting back in for swap.  Or something like
> that.  How come?  Do we actually not need the root memcgroup
> accounting?
>

The changelog mentions that the statistics are derived. For memsw as
Daisuke-San mentioned, the SWAP accounting is for memsw. We can derive
memory.usage_in_bytes from RSS+Cache fields in the memory.stat
accounting. For memsw, we needed SWAP accounting.

 
> IOW, the changelog sucks ;)
> 
> Is this an alternative approach to using percpu_counters, or do we do
> both or do we choose one or the other?  res_counter_charge() really is
> quite sucky.
> 
> The patch didn't have a signoff.
> 
> It would be nice to finalise those performance testing results and
> include them in the new, improved patch description.
> 

I'll submit a new patch with better changelog, checkpatch.pl fixes and
test results.


-- 
	Balbir
