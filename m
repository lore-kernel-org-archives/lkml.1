Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbZKKChF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbZKKChF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 21:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758724AbZKKChE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 21:37:04 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51713 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758686AbZKKChD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 21:37:03 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with nodemask v3
Cc: kosaki.motohiro@jp.fujitsu.com,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       cl@linux-foundation.org, rientjes@google.com
In-Reply-To: <20091111112404.0026e601.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091110171704.3800f081.kamezawa.hiroyu@jp.fujitsu.com> <20091111112404.0026e601.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20091111113559.FD4D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 11 Nov 2009 11:36:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KAMEZAWA Hiroyuki <kamezawa.hioryu@jp.fujitsu.com>
> 
> Fixing node-oriented allocation handling in oom-kill.c
> I myself think this as bugfix not as ehnancement.
> 
> In these days, things are changed as
>   - alloc_pages() eats nodemask as its arguments, __alloc_pages_nodemask().
>   - mempolicy don't maintain its own private zonelists.
>   (And cpuset doesn't use nodemask for __alloc_pages_nodemask())
> 
> But, current oom-killer's doesn't handle nodemask and it's wrong.
> 
> This patch does
>   - check nodemask, if nodemask && nodemask doesn't cover all
>     node_states[N_HIGH_MEMORY], this is CONSTRAINT_MEMORY_POLICY.
>   - Scan all zonelist under nodemask, if it hits cpuset's wall
>     this faiulre is from cpuset.
> And
>   - modifies the caller of out_of_memory not to call oom if __GFP_THISNODE.
>     This doesn't change "current" behavior.
>     If callers use __GFP_THISNODE, it should handle "page allocation failure"
>     by itself.
> 
> Changelog: 2009/11/11
>  - fixed nodes_equal() calculation.
>  - return CONSTRAINT_MEMPOLICY always if given nodemask is not enough big.
> 
> Changelog: 2009/11/06
>  - fixed lack of oom.h
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hioryu@jp.fujitsu.com>
> ---
>  drivers/char/sysrq.c |    2 +-
>  include/linux/oom.h  |    4 +++-
>  mm/oom_kill.c        |   44 ++++++++++++++++++++++++++++++++------------
>  mm/page_alloc.c      |   10 ++++++++--
>  4 files changed, 44 insertions(+), 16 deletions(-)
> 

Looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



