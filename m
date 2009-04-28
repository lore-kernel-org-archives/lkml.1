Return-Path: <linux-kernel-owner+w=401wt.eu-S1761337AbZD1OXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761337AbZD1OXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 10:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757574AbZD1OXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 10:23:09 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41491 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757911AbZD1OXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 10:23:08 -0400
Date: Tue, 28 Apr 2009 07:22:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Evgeniy Polyakov <zbr@ioremap.net>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       Jarek Poplawski <jarkao2@gmail.com>, Paul Mackerras <paulus@samba.org>,
       kaber@trash.net, jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-CPU r**ursive lock {XV}
Message-ID: <20090428142258.GA6730@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090427185423.GC23862@elte.hu> <20090427120658.35a858bb@nehalam> <alpine.LFD.2.00.0904271219570.22156@localhost.localdomain> <20090427203616.GB3836@ioremap.net> <alpine.LFD.2.00.0904271340400.22156@localhost.localdomain> <20090427144054.1fb9b7a6@nehalam> <alpine.LFD.2.00.0904271506530.22156@localhost.localdomain> <alpine.LFD.2.00.0904271525120.22156@localhost.localdomain> <alpine.LFD.2.00.0904271619240.22156@localhost.localdomain> <1240904468.7620.70.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240904468.7620.70.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 09:41:08AM +0200, Peter Zijlstra wrote:
> On Mon, 2009-04-27 at 16:32 -0700, Linus Torvalds wrote:
> > 
> > On Mon, 27 Apr 2009, Linus Torvalds wrote:
> > > 
> > > I left the commentary about "readers" and "writers", because in many
> > > ways it's correct, and what the code actually does is very much to
> > > emulate a reader-writer lock.  I put quotes around the uses in the
> > > comments to high-light that it largely _acts_ as a reader-writer lock. 
> > 
> > Btw, I think it was Paul who pointed out that technically it's probably 
> > better to call them "local" and "global" lockers instead of "readers" and 
> > "writers".
> 
> exclusive vs non-exclusive is what the literature would call them in
> most cases I think.

I would argue that the non-exclusive category includes both reader-writer
locking and local-global locking.  That said, we have an unusual variant
of local-global in this case, as the global processing acquires only one
of the locks at a time.

							Thanx, Paul
