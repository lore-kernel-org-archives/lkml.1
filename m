Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYDBLHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYDBLHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 07:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYDBLHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 07:07:23 -0400
Received: from brick.kernel.dk ([87.55.233.238]:19520 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbYDBLHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:07:23 -0400
Date: Wed, 2 Apr 2008 13:07:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Message-ID: <20080402110718.GU12774@kernel.dk>
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com> <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk> <Pine.LNX.4.64.0804021020280.25738@sbz-30.cs.Helsinki.FI> <20080402072456.GI12774@kernel.dk> <20080402072846.GA16454@elte.hu> <20080402105539.GA5610@linux.vnet.ibm.com> <84144f020804020401j4e5863dcofd16662baa54574@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020804020401j4e5863dcofd16662baa54574@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02 2008, Pekka Enberg wrote:
> Hi Paul,
> 
> On Wed, Apr 2, 2008 at 1:55 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >  I will check this when I get back to some bandwidth -- but in the meantime,
> >  does kmemcheck special-case SLAB_DESTROY_BY_RCU?  It is legal to access
> >  newly-freed items in that case, as long as you did rcu_read_lock()
> >  before gaining a reference to them and don't hold the reference past
> >  the matching rcu_read_unlock().
> 
> No, kmemcheck is work in progress and does not know about
> SLAB_DESTROY_BY_RCU yet. The reason I asked Vegard to post the warning
> was because Peter, Vegard, and myself identified this particular
> warning as a real problem. But yeah, kmemcheck can cause false
> positives for RCU for now.

Makes sense, and to me Pauls analysis of the code looks totally correct
- there's no bug there, at least related to hlist traversal and
kmem_cache_free(), since we are under rcu_read_lock() and thus hold off
the grace for freeing.

-- 
Jens Axboe

