Return-Path: <linux-kernel-owner+w=401wt.eu-S1758975AbZEAN4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975AbZEAN4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbZEAN4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:56:42 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:52127 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbZEAN4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:56:41 -0400
Date: Fri, 1 May 2009 14:55:51 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mmotm] memcg: fix mem_cgroup_update_mapped_file_stat oops
In-Reply-To: <20090430090646.a1443096.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0905011447290.26997@blonde.anvils>
References: <Pine.LNX.4.64.0904292209550.30874@blonde.anvils>
 <20090430090646.a1443096.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, KAMEZAWA Hiroyuki wrote:
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

I agree with you, it seems strange for it to come alive only now;
but I've not investigated further, may I leave that to you?

Could it be that all those checks on NULL lookup_page_cgroup()
actually date from before you reworked page cgroup assignment,
and they're now redundant?  If so, you'd do better to remove
all the checks, and Balbir put an explicit check in his code.

Alternatively, could the SPARSEMEM case have been corrupting or
otherwise misbehaving in a hidden way until now?  Seems unlikely.

Hugh
