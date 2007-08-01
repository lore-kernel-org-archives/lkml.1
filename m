Return-Path: <linux-kernel-owner+w=401wt.eu-S1764474AbXHAAXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764474AbXHAAXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 20:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbXHAAXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 20:23:17 -0400
Received: from ns.suse.de ([195.135.220.2]:53792 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187AbXHAAXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 20:23:16 -0400
Date: Wed, 1 Aug 2007 02:23:13 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] balance-on-fork NUMA placement
Message-ID: <20070801002313.GC31006@wotan.suse.de>
References: <20070731054142.GB11306@wotan.suse.de> <200707311114.09284.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707311114.09284.ak@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 11:14:08AM +0200, Andi Kleen wrote:
> On Tuesday 31 July 2007 07:41, Nick Piggin wrote:
> 
> > I haven't given this idea testing yet, but I just wanted to get some
> > opinions on it first. NUMA placement still isn't ideal (eg. tasks with
> > a memory policy will not do any placement, and process migrations of
> > course will leave the memory behind...), but it does give a bit more
> > chance for the memory controllers and interconnects to get evenly
> > loaded.
> 
> I didn't think slab honored mempolicies by default? 
> At least you seem to need to set special process flags.
> 
> > NUMA balance-on-fork code is in a good position to allocate all of a new
> > process's memory on a chosen node. However, it really only starts
> > allocating on the correct node after the process starts running.
> >
> > task and thread structures, stack, mm_struct, vmas, page tables etc. are
> > all allocated on the parent's node.
> 
> The page tables should be only allocated when the process runs; except
> for the PGD.

We certainly used to copy all page tables on fork. Not any more, but we
must still copy anonymous page tables.
