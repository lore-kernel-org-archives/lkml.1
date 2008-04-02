Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbYDBLOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbYDBLOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 07:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbYDBLOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 07:14:24 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:13479 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753471AbYDBLOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:14:23 -0400
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Jens Axboe <jens.axboe@oracle.com>, paulmck@linux.vnet.ibm.com,
       Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <84144f020804020411m7c6b0f27w16e8c6500867f3c1@mail.gmail.com>
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com>
	 <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk>
	 <Pine.LNX.4.64.0804021020280.25738@sbz-30.cs.Helsinki.FI>
	 <20080402072456.GI12774@kernel.dk> <20080402072846.GA16454@elte.hu>
	 <20080402105539.GA5610@linux.vnet.ibm.com>
	 <84144f020804020401j4e5863dcofd16662baa54574@mail.gmail.com>
	 <20080402110718.GU12774@kernel.dk> <1207134536.8514.773.camel@twins>
	 <84144f020804020411m7c6b0f27w16e8c6500867f3c1@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 13:14:09 +0200
Message-Id: <1207134849.8514.775.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 14:11 +0300, Pekka Enberg wrote:
> On Wed, 2008-04-02 at 13:07 +0200, Jens Axboe wrote:
> > > Makes sense, and to me Pauls analysis of the code looks totally correct
> > > - there's no bug there, at least related to hlist traversal and
> > > kmem_cache_free(), since we are under rcu_read_lock() and thus hold off
> > > the grace for freeing.
> 
> On Wed, Apr 2, 2008 at 2:08 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >  but what holds off the slab allocator re-issueing that same object and
> >  someone else writing other stuff into it?
> 
> Nothing. So you cannot access the object at all after you've called
> kmem_cache_free(). SLAB_RCU or no SLAB_RCU.

Well, you can, but you have to validate you get the object you were
looking for.

