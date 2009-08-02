Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbZHBQ1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbZHBQ1r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 12:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZHBQ1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 12:27:46 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:48740 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZHBQ1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 12:27:46 -0400
Date: Sun, 2 Aug 2009 21:57:32 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: memory-controller patch fails to boot in qemu [mmotm]
Message-ID: <20090802162732.GE8514@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4A744C2A.6040009@gmail.com>
 <20090801200200.GB8514@balbir.in.ibm.com>
 <Pine.LNX.4.64.0908012305260.4581@sister.anvils>
 <20090801222602.GC8514@balbir.in.ibm.com>
 <Pine.LNX.4.64.0908021704300.3945@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908021704300.3945@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hugh Dickins <hugh.dickins@tiscali.co.uk> [2009-08-02 17:12:53]:

> On Sun, 2 Aug 2009, Balbir Singh wrote:
> > * Hugh Dickins <hugh.dickins@tiscali.co.uk> [2009-08-01 23:09:09]:
> > > 
> > > Hmm, this a weird function, passed an argument just to tell it to do
> > > nothing.  Perhaps a placeholder for something more sensible to come?
> > 
> > The argument is passed a result of a function, It no-ops quite
> > frequently for the root cgroup.
> 
> The more often it no-ops, the sillier it is to be called in
> the first place: here's an updated patch which fixes that too.
> 
> 
> [PATCH mmotm] memory controller: soft limit organize cgroups v9 fix
> 
> CONFIG_CGROUP_MEM_RES_CTLR=y CONFIG_PREEMPT=y mmotm fails to boot:
> Kernel panic - not syncing: No init found; after lots of scheduling
> while atomics, starting from when async_thread does sd_probe_async.
> 
> mem_cgroup_soft_limit_check() was doing an unbalanced get_cpu():
> don't get_cpu if we won't need it, and put_cpu if we did get_cpu.
> 
> And fix the silliness of passing it an "over_soft_limit" argument
> that just tells it to return false when false.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Fair enough (I guess my intention of keeping if blocks outside for
each call site, does not pay sufficiently enough), Thanks for the cleanup


Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Balbir
