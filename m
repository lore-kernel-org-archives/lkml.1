Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbYDBQPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbYDBQPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbYDBQPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:15:22 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46901 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbYDBQPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:15:21 -0400
Date: Wed, 2 Apr 2008 09:15:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Message-ID: <20080402161519.GC9333@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk> <Pine.LNX.4.64.0804021020280.25738@sbz-30.cs.Helsinki.FI> <20080402072456.GI12774@kernel.dk> <20080402072846.GA16454@elte.hu> <20080402105539.GA5610@linux.vnet.ibm.com> <1207133961.8514.768.camel@twins> <20080402113327.GC41073@gandalf.sssup.it> <20080402133232.GE2813@linux.vnet.ibm.com> <20080402134046.GZ12774@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402134046.GZ12774@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 03:40:46PM +0200, Jens Axboe wrote:
> On Wed, Apr 02 2008, Paul E. McKenney wrote:
> > On Wed, Apr 02, 2008 at 01:33:27PM +0200, Fabio Checconi wrote:
> > > > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > Date: Wed, Apr 02, 2008 12:59:21PM +0200
> > > >
> > > > On Wed, 2008-04-02 at 03:55 -0700, Paul E. McKenney wrote:
> > > > > On Wed, Apr 02, 2008 at 09:28:46AM +0200, Ingo Molnar wrote:
> > > > > > 
> > > > > > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > > > 
> > > > > > > On Wed, Apr 02 2008, Pekka J Enberg wrote:
> > > > > > > > On Wed, 2 Apr 2008, Jens Axboe wrote:
> > > > > > > > > Good catch, I wonder why it didn't complain in my testing. I've added a
> > > > > > > > > patch to fix that, please see it here:
> > > > > > > > 
> > > > > > > > You probably don't have kmemcheck in your kernel ;-)
> > > > > > > 
> > > > > > > Ehm no, you are right :)
> > > > > > 
> > > > > > ... and you can get kmemcheck by testing on x86.git/latest:
> > > > > > 
> > > > > >   http://people.redhat.com/mingo/x86.git/README
> > > > > > 
> > > > > > ;-)
> > > > > 
> > > > > I will check this when I get back to some bandwidth -- but in the meantime,
> > > > > does kmemcheck special-case SLAB_DESTROY_BY_RCU?  It is legal to access
> > > > > newly-freed items in that case, as long as you did rcu_read_lock()
> > > > > before gaining a reference to them and don't hold the reference past
> > > > > the matching rcu_read_unlock().
> > > > 
> > > > I don't think it does.
> > > > 
> > > > It would have to register an call_rcu callback itself in order to mark
> > > > it freed - and handle the race with the object being handed out again.
> > > 
> > > I had the same problem while debugging a cfq-derived i/o scheduler,
> > > and I found nothing preventing the reuse of the freed memory.
> > > The patch below seemed to fix the logic.
> > 
> > Looks good to me from a strictly RCU viewpoint -- I must confess great
> > ignorance of the CFQ code.  :-/
> 
> That can always be rectified, given enough spare time :-)

Hey, I am not complaining about 2007 being gone already, because I am
still wondering what the heck happened to 2005 and 2006!!!  ;-)

							Thanx, Paul

> > Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Thanks, added.
> 
> -- 
> Jens Axboe
> 
