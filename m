Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbYDBRjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbYDBRjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756055AbYDBRj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:39:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51890 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755298AbYDBRj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:39:27 -0400
Date: Wed, 2 Apr 2008 10:36:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>, paulmck@linux.vnet.ibm.com,
       Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
In-Reply-To: <84144f020804020411m7c6b0f27w16e8c6500867f3c1@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804021036070.26938@schroedinger.engr.sgi.com>
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com> 
 <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk> 
 <Pine.LNX.4.64.0804021020280.25738@sbz-30.cs.Helsinki.FI> 
 <20080402072456.GI12774@kernel.dk> <20080402072846.GA16454@elte.hu> 
 <20080402105539.GA5610@linux.vnet.ibm.com>  <84144f020804020401j4e5863dcofd16662baa54574@mail.gmail.com>
  <20080402110718.GU12774@kernel.dk> <1207134536.8514.773.camel@twins>
 <84144f020804020411m7c6b0f27w16e8c6500867f3c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Pekka Enberg wrote:

> On Wed, Apr 2, 2008 at 2:08 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >  but what holds off the slab allocator re-issueing that same object and
> >  someone else writing other stuff into it?
> 
> Nothing. So you cannot access the object at all after you've called
> kmem_cache_free(). SLAB_RCU or no SLAB_RCU.

You can of course access the object. And if you establish a definite state 
of locks on free (and through a ctor) then its even okay to take locks.
 
