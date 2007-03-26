Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbXCZIqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbXCZIqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 04:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbXCZIqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 04:46:44 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:52544 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbXCZIqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 04:46:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=Yzhk/t2Q+vvQJPSKPsaEhSMiFJWnDmw7QypfDyWm6KpJ+tPBn1F2MH4wMumd7
	C61byBK1SrY410xHfc75fHRsA==
Date: Mon, 26 Mar 2007 10:46:39 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: I/O memory barriers vs SMP memory barriers
Message-ID: <20070326084639.GA30291@xi.wantstofly.org>
References: <20070323111350.GD3980@xi.wantstofly.org> <e9c3a7c20703021312y5f7aa228i5d1c84a8e9ea5676@mail.gmail.com> <20070303111427.GB16944@xi.wantstofly.org> <20070303113305.GB10515@flint.arm.linux.org.uk> <20070321221134.GA22497@xi.wantstofly.org> <tnxlkhpgslz.fsf@arm.com> <16051.1174657433@redhat.com> <20070325211542.GD3593@linux.vnet.ibm.com> <20070325213843.GE22126@xi.wantstofly.org> <20070326032418.GA14557@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326032418.GA14557@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 08:24:18PM -0700, Paul E. McKenney wrote:

> > > > > [ background: On ARM, SMP synchronisation does need barriers but device
> > > > >   synchronisation does not.  The question is that given this, whether
> > > > >   mb() and friends can be NOPs on ARM or not (i.e. whether mb() is
> > > > >   supposed to sync against other CPUs or not, or whether only smp_mb()
> > > > >   can be used for this.)  ]
> > > > 
> > > > Hmmmm...
> > > > 
> > > > [snip]
> > > 
> > > 3.	Orders memory accesses and device accesses, but not necessarily
> > > 	the union of the two -- mb(), rmb(), wmb().
> > 
> > If mb/rmb/wmb are required to order normal memory accesses, that means
> > that the change made in commit 9623b3732d11b0a18d9af3419f680d27ea24b014
> > to always define mb/rmb/wmb as barrier() on ARM systems was wrong.
> 
> This was on UP ARM systems, right?

No.

If you look at commit 9623b3732d11b0a18d9af3419f680d27ea24b014, you can
see that it defines mb/rmb/wmb as barrier() on both ARM UP and SMP systems.
The UP part is obviously fine, the SMP part is what is under debate here.


> Assuming that ARM CPUs respect the usual CPU-self-consistency
> semantics, and given the background that device accesses are ordered,
> then it might well be OK to have mb/rmb/wmb be barrier() on UP ARM
> systems.
> 
> Most likely not on SMP ARM systems, however.

Given the semantics above, mb/rmb/wmb can obviously be just barrier()s
on ARM UP systems.. I don't think anyone ever disagreed about that.


> > Does everybody agree on these semantics, though?  At least David
> > seems to think that mb/rmb/wmb aren't required to order normal
> > memory accesses against each other..
> 
> Not on UP.  On SMP, ordering is (almost certainly) required.

'almost certainly'?  That sounds like there is a possibility that it
wouldn't have to?  What does this depend on?

At least David and Catalin seem to disagree with the statement
that mb/rmb/wmb should order accesses from different CPUs.  And
memory-barriers.txt is pretty vague about this..
