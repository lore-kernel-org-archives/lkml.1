Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbZFOGrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbZFOGrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 02:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbZFOGq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 02:46:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:52496 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbZFOGq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 02:46:56 -0400
Date: Mon, 15 Jun 2009 08:46:53 +0200
From: Nick Piggin <npiggin@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
Message-ID: <20090615064653.GB18390@wotan.suse.de>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI> <alpine.DEB.1.10.0906121317140.23840@gentwo.org> <1244843163.23936.2.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244843163.23936.2.camel@pasglop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 07:46:03AM +1000, Benjamin Herrenschmidt wrote:
> 
> > Adds code to hot code path.
> 
> A single mask which should be mostly in the noise...

Cacheline load. Yes it will be in the noise. Like all other slowdowns
that get merged ;)


> > The allocators mask flags passed to the page allocator through
> > GFP_RECLAIM_MASK|GFP_CONSTRAINT_MASK. This is done outside of the critical
> > code paths.
> > 
> > The might_sleep issues may be fixed by adding another check to
> > __might_sleep().
> 
> That is not enough because slab and slub explicitely re-enable
> interrupts when __GFP_WAIT is set, which is the problem we need to solve
> in the first place, so we need to do the masking there.
> 
> Cheers,
> Ben.
> 
