Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbXHBDmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbXHBDmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 23:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbXHBDmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 23:42:05 -0400
Received: from mail.suse.de ([195.135.220.2]:50024 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbXHBDmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 23:42:02 -0400
Date: Thu, 2 Aug 2007 05:42:01 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] balance-on-fork NUMA placement
Message-ID: <20070802034201.GA32631@wotan.suse.de>
References: <20070731054142.GB11306@wotan.suse.de> <200707311114.09284.ak@suse.de> <Pine.LNX.4.64.0707311639450.31337@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707311639450.31337@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 04:40:18PM -0700, Christoph Lameter wrote:
> On Tue, 31 Jul 2007, Andi Kleen wrote:
> 
> > On Tuesday 31 July 2007 07:41, Nick Piggin wrote:
> > 
> > > I haven't given this idea testing yet, but I just wanted to get some
> > > opinions on it first. NUMA placement still isn't ideal (eg. tasks with
> > > a memory policy will not do any placement, and process migrations of
> > > course will leave the memory behind...), but it does give a bit more
> > > chance for the memory controllers and interconnects to get evenly
> > > loaded.
> > 
> > I didn't think slab honored mempolicies by default? 
> > At least you seem to need to set special process flags.
> 
> It does in the sense that slabs are allocated following policies. If you 
> want to place individual objects then you need to use kmalloc_node().

Is there no way to place objects via policy? At least kernel stack and page
tables on x86-64 should be covered by page allocator policy, so the patch
will still be useful.

