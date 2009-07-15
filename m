Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZGORbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZGORbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 13:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbZGORbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 13:31:11 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:30979 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbZGORbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 13:31:10 -0400
Subject: Re: [BUG] set_mempolicy(MPOL_INTERLEAV) cause kernel panic
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Rientjes <rientjes@google.com>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090715182320.39B5.A69D9226@jp.fujitsu.com>
References: <20090715182320.39B5.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/LKTT
Date: Wed, 15 Jul 2009 13:31:04 -0400
Message-Id: <1247679064.4089.26.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 18:48 +0900, KOSAKI Motohiro wrote:
> Hi
> 
> On 2.6.31-rc3, following test makes kernel panic immediately.
> 
>   numactl --interleave=all echo
> 
> Panic message is below. I don't think commit 58568d2a8 is correct patch.
> 
> old behavior:
>   do_set_mempolicy
>     mpol_new
>       cpuset_update_task_memory_state
>         guarantee_online_mems
>           nodes_and(cs->mems_allowed, node_states[N_HIGH_MEMORY]);
> 
> but new code doesn't consider N_HIGH_MEMORY. Then, the userland program
> passing non-online node bit makes crash, I guess.
> 
> Miao, What do you think?

This looks similar to the problem I tried to fix in:

	http://marc.info/?l=linux-mm&m=124140637722309&w=4

Miao pointed out that the patch needs more work to track hot plug of
nodes.  I've not had time to get back to this.

Interestingly, on ia64, the top cpuset mems_allowed gets set to all
possible nodes, while on x86_64, it gets set to on-line nodes [or nodes
with memory].  Maybe this is a to support hot-plug?

Lee

<snip>

