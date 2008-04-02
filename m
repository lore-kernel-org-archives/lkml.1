Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbYDBKzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbYDBKzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 06:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbYDBKzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 06:55:42 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41950 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbYDBKzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 06:55:42 -0400
Date: Wed, 2 Apr 2008 03:55:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Message-ID: <20080402105539.GA5610@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com> <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk> <Pine.LNX.4.64.0804021020280.25738@sbz-30.cs.Helsinki.FI> <20080402072456.GI12774@kernel.dk> <20080402072846.GA16454@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402072846.GA16454@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 09:28:46AM +0200, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Apr 02 2008, Pekka J Enberg wrote:
> > > On Wed, 2 Apr 2008, Jens Axboe wrote:
> > > > Good catch, I wonder why it didn't complain in my testing. I've added a
> > > > patch to fix that, please see it here:
> > > 
> > > You probably don't have kmemcheck in your kernel ;-)
> > 
> > Ehm no, you are right :)
> 
> ... and you can get kmemcheck by testing on x86.git/latest:
> 
>   http://people.redhat.com/mingo/x86.git/README
> 
> ;-)

I will check this when I get back to some bandwidth -- but in the meantime,
does kmemcheck special-case SLAB_DESTROY_BY_RCU?  It is legal to access
newly-freed items in that case, as long as you did rcu_read_lock()
before gaining a reference to them and don't hold the reference past
the matching rcu_read_unlock().

							Thanx, Paul
