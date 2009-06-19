Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbZFSXut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbZFSXut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 19:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZFSXul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 19:50:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:38802 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbZFSXul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 19:50:41 -0400
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or
 suspending
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, npiggin@suse.de,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <20090619232336.GA2442@elf.ucw.cz>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
	 <20090619145913.GA1389@ucw.cz> <1245450449.16880.10.camel@pasglop>
	 <20090619232336.GA2442@elf.ucw.cz>
Content-Type: text/plain
Date: Sat, 20 Jun 2009 09:50:09 +1000
Message-Id: <1245455409.16880.15.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-20 at 01:23 +0200, Pavel Machek wrote:
> > No. First, code that assumes GFP_KERNEL don't fail is stupid. Any
> > allocation should always be assumed to potentially fail.
> 
> Stupid, yes. Uncommon? Not sure.

A lot less than it used to be, we've been fixing those by the truckload
over the past few years. But again, if allocations start failing that
early at boot, you are likely to be doomed anyway. Still, better to do
proper error handling, and I think we -mostly- do (ok, not -always-).

> > Then, if you start failing allocations at boot time, then you aren't
> > going anywhere are you ?
> 
> Exactly. So boot code should have access to all the memory, right?
> Setting some aside for GFP_ATOMIC does not make sense in that context.

I'm not certain what you mean here. If you're going to hit the atomic
reserve that early, you aren't going anywhere neither :-)

Is there any real problem you are trying to solve here or is it all
just academic ?

Cheers,
Ben.


