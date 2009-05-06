Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbZEFUUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbZEFUUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756336AbZEFUUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:20:36 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44852 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756092AbZEFUUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:20:35 -0400
Date: Wed, 6 May 2009 13:20:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, dhowells@redhat.com, linux-kernel@vger.kernel.org,
       niv@us.ibm.com, dvhltc@us.ibm.com, lethal@linux-sh.org,
       kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v4 RCU: the bloatwatch edition
Message-ID: <20090506202030.GI6771@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090502163423.GA1633@linux.vnet.ibm.com> <20090506112459.5edd0902.akpm@linux-foundation.org> <20090506190216.GE6771@linux.vnet.ibm.com> <20090506121908.1fcd3afc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506121908.1fcd3afc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 12:19:08PM -0700, Andrew Morton wrote:
> On Wed, 6 May 2009 12:02:16 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > > > i'm wondering what Andrew thinks - he had objections, right?
> > > > 
> > > 
> > > More like "concerns".  It's unobvious to me that the modest .text
> > > savings justify the costs of an additional RCU implementation.  Where
> > > those costs include
> > > 
> > > - additional maintenance work and
> > > 
> > > - the reduced code reliability which comes from fragmenting the
> > >   tester base.  This will mostly affect users of the less popular RCU
> > >   implementations.
> > > 
> > > But hey, maybe I'm wrong.  And maybe I'm right, but we'll merge it anyway ;)
> > 
> > ;-)
> > 
> > How about if acceptance of Tiny RCU happens at the same time as Classic
> > RCU is dropped?  That would be a large net decrease in code size and
> > complexity.
> 
> It's a bit artificial to link the two actions.  Removing something:
> good.  Adding something: bad.  good+bad == less good ;)

Ah, but from a memory-footprint perspective, removing Classic RCU is
about 1.5K bad, given the larger memory footprint of Hierarchical RCU.
So, in this case, removing Classic RCU: good complexity, bad memory
footprint.  Adding Tiny RCU: slightly bad complexity, good memory
footprint.

So, replacing Classic RCU with Tiny RCU improves (reduces) both the
complexity and the memory footprint.

							Thanx, Paul
