Return-Path: <linux-kernel-owner+w=401wt.eu-S1755692AbZHKXdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbZHKXdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 19:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755678AbZHKXdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 19:33:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755666AbZHKXc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 19:32:59 -0400
Date: Tue, 11 Aug 2009 16:31:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       kosaki.motohiro@jp.fujitsu.com, menage@google.com, prarit@redhat.com,
       andi.kleen@intel.com, xemul@openvz.org, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Help Resource Counters Scale better (v4)
Message-Id: <20090811163159.ddc5f5fd.akpm@linux-foundation.org>
In-Reply-To: <20090811144405.GW7176@balbir.in.ibm.com>
References: <20090811144405.GW7176@balbir.in.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009 20:14:05 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Enhancement: Remove the overhead of root based resource counter accounting
> 
> From: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> This patch reduces the resource counter overhead (mostly spinlock)
> associated with the root cgroup. This is a part of the several
> patches to reduce mem cgroup overhead. I had posted other
> approaches earlier (including using percpu counters). Those
> patches will be a natural addition and will be added iteratively
> on top of these.
> 
> The patch stops resource counter accounting for the root cgroup.
> The data for display is derived from the statisitcs we maintain
> via mem_cgroup_charge_statistics (which is more scalable).
> 
> The tests results I see on a 24 way show that
> 
> 1. The lock contention disappears from /proc/lock_stats
> 2. The results of the test are comparable to running with
>    cgroup_disable=memory.
> 
> Please test/review.

I don't get it.

The patch apepars to skip accounting altogether for the root memcgroup
and then adds some accounting back in for swap.  Or something like
that.  How come?  Do we actually not need the root memcgroup
accounting?

IOW, the changelog sucks ;)

Is this an alternative approach to using percpu_counters, or do we do
both or do we choose one or the other?  res_counter_charge() really is
quite sucky.

The patch didn't have a signoff.

It would be nice to finalise those performance testing results and
include them in the new, improved patch description.

