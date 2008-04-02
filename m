Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYDBKtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYDBKtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 06:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYDBKtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 06:49:20 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:53056 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752093AbYDBKtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 06:49:17 -0400
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: paulmck@linux.vnet.ibm.com, Jens Axboe <jens.axboe@oracle.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <84144f020804020346v6c6de91fr795dec55e0543105@mail.gmail.com>
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com>
	 <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk>
	 <20080402104025.GC2813@linux.vnet.ibm.com>
	 <84144f020804020346v6c6de91fr795dec55e0543105@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 12:49:04 +0200
Message-Id: <1207133344.8514.759.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 13:46 +0300, Pekka Enberg wrote:
> Hi Paul,
> 
> On Wed, Apr 2, 2008 at 1:40 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >  I am still confused.
> >
> >  o       The kmem_cache has SLAB_DESTROY_BY_RCU.
> >
> >  o       This means that a given slab should not be returned to the
> >         system until a grace period elapses.
> 
> Yeah, that's what I thought too, that this is a SLUB bug but Peter
> convinced me otherwise. SLUB keeps the _page_ around so the pointer
> will be _valid_, although it might not be _your_ pointer so the caller
> needs to do some validation step. Or at least that's how I understood
> what Peter was saying.

Correct, that is always how i understood SLAB_DESTROY_BY_RCU to work.

Does SLAB (as opposed to SLUB) do it differently?

