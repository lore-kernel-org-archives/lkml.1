Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbYDBK7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbYDBK7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 06:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbYDBK7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 06:59:35 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:38463 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbYDBK7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 06:59:34 -0400
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20080402105539.GA5610@linux.vnet.ibm.com>
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com>
	 <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk>
	 <Pine.LNX.4.64.0804021020280.25738@sbz-30.cs.Helsinki.FI>
	 <20080402072456.GI12774@kernel.dk> <20080402072846.GA16454@elte.hu>
	 <20080402105539.GA5610@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 12:59:21 +0200
Message-Id: <1207133961.8514.768.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 03:55 -0700, Paul E. McKenney wrote:
> On Wed, Apr 02, 2008 at 09:28:46AM +0200, Ingo Molnar wrote:
> > 
> > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > On Wed, Apr 02 2008, Pekka J Enberg wrote:
> > > > On Wed, 2 Apr 2008, Jens Axboe wrote:
> > > > > Good catch, I wonder why it didn't complain in my testing. I've added a
> > > > > patch to fix that, please see it here:
> > > > 
> > > > You probably don't have kmemcheck in your kernel ;-)
> > > 
> > > Ehm no, you are right :)
> > 
> > ... and you can get kmemcheck by testing on x86.git/latest:
> > 
> >   http://people.redhat.com/mingo/x86.git/README
> > 
> > ;-)
> 
> I will check this when I get back to some bandwidth -- but in the meantime,
> does kmemcheck special-case SLAB_DESTROY_BY_RCU?  It is legal to access
> newly-freed items in that case, as long as you did rcu_read_lock()
> before gaining a reference to them and don't hold the reference past
> the matching rcu_read_unlock().

I don't think it does.

It would have to register an call_rcu callback itself in order to mark
it freed - and handle the race with the object being handed out again.

