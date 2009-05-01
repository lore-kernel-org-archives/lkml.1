Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbZEAQmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbZEAQmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 12:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbZEAQlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 12:41:52 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60287 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbZEAQlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 12:41:51 -0400
Date: Fri, 1 May 2009 21:02:06 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mmotm] memcg: fix mem_cgroup_update_mapped_file_stat
	oops
Message-ID: <20090501153206.GA4686@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <Pine.LNX.4.64.0904292209550.30874@blonde.anvils> <20090430090646.a1443096.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0905011447290.26997@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905011447290.26997@blonde.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hugh Dickins <hugh@veritas.com> [2009-05-01 14:55:51]:

> On Thu, 30 Apr 2009, KAMEZAWA Hiroyuki wrote:
> > On Wed, 29 Apr 2009 22:13:33 +0100 (BST)
> > Hugh Dickins <hugh@veritas.com> wrote:
> > 
> > > CONFIG_SPARSEMEM=y CONFIG_CGROUP_MEM_RES_CTLR=y cgroup_disable=memory
> > > bootup is oopsing in mem_cgroup_update_mapped_file_stat().  !SPARSEMEM
> > > is fine because its lookup_page_cgroup() contains an explicit check for
> > > NULL node_page_cgroup, but the SPARSEMEM version was missing a check for
> > > NULL section->page_cgroup.
> > > 
> > Ouch, it's curious this bug alive now.. thank you.
> > 
> > Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > I think this patch itself is sane but.. Balbir, could you see "caller" ?
> > It seems strange.
> 
> I agree with you, it seems strange for it to come alive only now;
> but I've not investigated further, may I leave that to you?
> 
> Could it be that all those checks on NULL lookup_page_cgroup()
> actually date from before you reworked page cgroup assignment,
> and they're now redundant?  If so, you'd do better to remove
> all the checks, and Balbir put an explicit check in his code.
>

I agree, it needs investigation. I would propose converting them to a
VM_BUG_ON() and then consider removing them, just to catch potential
problems, in case we miss anything.
 
> Alternatively, could the SPARSEMEM case have been corrupting or
> otherwise misbehaving in a hidden way until now?  Seems unlikely.

Agreed.

-- 
	Balbir
