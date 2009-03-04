Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbZCDLpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbZCDLpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbZCDLp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:45:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53551 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938AbZCDLp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:45:26 -0500
Date: Wed, 4 Mar 2009 12:45:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/6] rcu: introduce kfree_rcu V2
Message-ID: <20090304114504.GB4916@elte.hu>
References: <49AD342D.6030609@cn.fujitsu.com> <20090303140955.GD23822@elte.hu> <49AE484C.8020801@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AE484C.8020801@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Ingo Molnar wrote:
> > 
> > Nice idea. The patches dont actually remove the RCU helpers 
> > anywhere. Might be useful to include a few example conversions 
> > of this facility as well, so that the total impact can be seen.
> > 
> > 
> 
> This is one of patches I test kfree_rcu().
> And it could be an example conversions of this facility.
> 
> ---
>  arch/ia64/sn/kernel/irq.c           |   14 +-----------
>  block/genhd.c                       |   10 --------
>  ipc/sem.c                           |   10 +-------
>  kernel/audit_tree.c                 |    8 ------
>  kernel/cgroup.c                     |    9 -------
>  kernel/smp.c                        |   11 ---------
>  mm/vmalloc.c                        |   18 +--------------
>  net/can/af_can.c                    |   14 +-----------
>  net/core/gen_estimator.c            |    9 -------
>  net/core/net_namespace.c            |   10 --------
>  net/ipv4/fib_trie.c                 |    7 ------
>  net/ipv6/addrconf.c                 |   10 --------
>  net/netfilter/nf_conntrack_extend.c |    8 ------
>  net/netlabel/netlabel_unlabeled.c   |   42 +-----------------------------------
>  security/device_cgroup.c            |   10 --------
>  security/keys/keyring.c             |   15 ------------
>  security/keys/user_defined.c        |   18 +--------------
>  security/selinux/netif.c            |   18 ---------------
>  security/selinux/netnode.c          |   20 +----------------
>  security/selinux/netport.c          |   20 +----------------
>  20 files changed, 28 insertions(+), 253 deletions(-)

Looks convincing to me but Nick does not like the extra SLAB 
field it uses :-/

	Ingo
