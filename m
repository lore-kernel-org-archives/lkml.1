Return-Path: <linux-kernel-owner+w=401wt.eu-S1761502AbZD3IXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbZD3IXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760098AbZD3IWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:22:30 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:41207 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZD3IW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:22:26 -0400
Date: Thu, 30 Apr 2009 10:22:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mmotm] memcg: fix mem_cgroup_update_mapped_file_stat
	oops
Message-ID: <20090430045240.GA4430@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <Pine.LNX.4.64.0904292209550.30874@blonde.anvils> <20090430090646.a1443096.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090430090646.a1443096.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-30 09:06:46]:

> On Wed, 29 Apr 2009 22:13:33 +0100 (BST)
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > CONFIG_SPARSEMEM=y CONFIG_CGROUP_MEM_RES_CTLR=y cgroup_disable=memory
> > bootup is oopsing in mem_cgroup_update_mapped_file_stat().  !SPARSEMEM
> > is fine because its lookup_page_cgroup() contains an explicit check for
> > NULL node_page_cgroup, but the SPARSEMEM version was missing a check for
> > NULL section->page_cgroup.
> > 
> Ouch, it's curious this bug alive now.. thank you.
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> I think this patch itself is sane but.. Balbir, could you see "caller" ?
> It seems strange.

Ideally we need to have a disabled check in
mem_cgroup_update_mapped_file_stat(), but it seems as if this fix is
better and fixes a larger scenario and the root cause of
lookup_page_cgroup() OOPSing. It would not hurt to check for
mem_cgroup_disabled() though, but too many checks might spoil the
party for frequent operations.

Kame, do you mean you wanted me to check if I am using
lookup_page_cgroup() correctly?

Hugh, Thank you very much for finding and fixing the problem!
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Balbir
