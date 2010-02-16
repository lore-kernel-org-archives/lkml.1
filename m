Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab0BPGP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 01:15:58 -0500
Received: from cantor.suse.de ([195.135.220.2]:60189 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab0BPGP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 01:15:56 -0500
Date: Tue, 16 Feb 2010 17:15:53 +1100
From: Nick Piggin <npiggin@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 2/9 v2] oom: sacrifice child with highest badness
 score for parent
Message-ID: <20100216061553.GZ5723@laptop>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1002151417480.26927@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002151417480.26927@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 02:20:03PM -0800, David Rientjes wrote:
> When a task is chosen for oom kill, the oom killer first attempts to
> sacrifice a child not sharing its parent's memory instead.
> Unfortunately, this often kills in a seemingly random fashion based on
> the ordering of the selected task's child list.  Additionally, it is not
> guaranteed at all to free a large amount of memory that we need to
> prevent additional oom killing in the very near future.
> 
> Instead, we now only attempt to sacrifice the worst child not sharing its
> parent's memory, if one exists.  The worst child is indicated with the
> highest badness() score.  This serves two advantages: we kill a
> memory-hogging task more often, and we allow the configurable
> /proc/pid/oom_adj value to be considered as a factor in which child to
> kill.
> 
> Reviewers may observe that the previous implementation would iterate
> through the children and attempt to kill each until one was successful
> and then the parent if none were found while the new code simply kills
> the most memory-hogging task or the parent.  Note that the only time
> oom_kill_task() fails, however, is when a child does not have an mm or
> has a /proc/pid/oom_adj of OOM_DISABLE.  badness() returns 0 for both
> cases, so the final oom_kill_task() will always succeed.
> 
> Acked-by: Rik van Riel <riel@redhat.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Nick Piggin <npiggin@suse.de>
