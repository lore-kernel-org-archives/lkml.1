Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866Ab0AEQFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab0AEQFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:05:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763Ab0AEQFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:05:09 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34077 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648Ab0AEQFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:05:07 -0500
Date: Tue, 5 Jan 2010 08:05:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org, "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 4/8] mm: RCU free vmas
Message-ID: <20100105160502.GA8037@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100104182429.833180340@chello.nl> <20100104182813.479668508@chello.nl> <20100105024336.GQ6748@linux.vnet.ibm.com> <1262680116.2400.19.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262680116.2400.19.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 09:28:36AM +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-04 at 18:43 -0800, Paul E. McKenney wrote:
> > On Mon, Jan 04, 2010 at 07:24:33PM +0100, Peter Zijlstra wrote:
> > > TODO:
> > >  - should be SRCU, lack of call_srcu()
> > > 
> > > In order to allow speculative vma lookups, RCU free the struct
> > > vm_area_struct.
> > > 
> > > We use two means of detecting a vma is still valid:
> > >  - firstly, we set RB_CLEAR_NODE once we remove a vma from the tree.
> > >  - secondly, we check the vma sequence number.
> > > 
> > > These two things combined will guarantee that 1) the vma is still
> > > present and two, it still covers the same range from when we looked it
> > > up.
> > 
> > OK, I think I see what you are up to here.  I could get you a very crude
> > throw-away call_srcu() fairly quickly.  I don't yet have a good estimate
> > of how long it will take me to merge SRCU into the treercu infrastructure,
> > but am getting there.
> > 
> > So, which release are you thinking in terms of?
> 
> I'm not thinking any release yet, its very early and as Linus has
> pointed out, I seem to have forgotten a rather big piece of the
> picture :/
> 
> So I need to try and fix this glaring hole before we can continue.

OK, then I will think in terms of merging SRCU into treercu before
providing any sort of call_srcu().

							Thanx, Paul
