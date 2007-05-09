Return-Path: <linux-kernel-owner+w=401wt.eu-S1759803AbXEIXjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803AbXEIXjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756894AbXEIXjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:39:09 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473AbXEIXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:39:06 -0400
Date: Wed, 9 May 2007 16:36:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Call percpu smp cacheline algin interface
Message-Id: <20070509163616.e8a36a4c.akpm@linux-foundation.org>
In-Reply-To: <A29F7A5700A7EA4380E08C1F68C3B6D802B5F7CA@scsmsx411.amr.corp.intel.com>
References: <Pine.LNX.4.64.0705091556260.1221@schroedinger.engr.sgi.com>
	<A29F7A5700A7EA4380E08C1F68C3B6D802B5F7CA@scsmsx411.amr.corp.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007 16:10:05 -0700
"Yu, Fenghua" <fenghua.yu@intel.com> wrote:

> 
> 
> On Wed, 9 May 2007, Andrew Morton wrote:
> 
> >> erm, it's not obviosu from all this that the patches are worth
> proceeding
> >> with, are they?
> 
> >What was it? 0.5% performance improvement on a synthetic benchmark? 
> >Process wakeup I believe?
> 
> The initial patch and discussion is from:
> http://www.uwsg.iu.edu/hypermail/linux/kernel/0704.1/0340.html
> 
> Yes, the runqueue patch has a 0.5% perf improvement on database
> workload(which is a good improvement for this workload).
> 
> The theory behind the patches is:
> 
> 1. Minimize number of cache lines that are touched during a remote
> access. On Numa system, remote access is more expensive than local.
> 2. Do not share cache line between remote accessed data and local
> accessed data. Local data update may cause remote access cache miss and
> wait for longer time.
> 
> Although the patches themselves don't save or waste per_cpu size, the
> above two reasons are good to have them in.
> 

Guys, this is all a lesson in the value of changelogs, and in how not to
write them.

Can you please prepare a new changelog for these patches?  Something which
encapsulates all the above in as brief a form as possible and which
includes some numbers describing the space and/or speed improvements?

Thanks.
