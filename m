Return-Path: <linux-kernel-owner+w=401wt.eu-S1761535AbXHCBO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761535AbXHCBO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 21:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbXHCBOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 21:14:50 -0400
Received: from ns.suse.de ([195.135.220.2]:36211 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019AbXHCBOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 21:14:49 -0400
Date: Fri, 3 Aug 2007 03:14:48 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] balance-on-fork NUMA placement
Message-ID: <20070803011448.GF14775@wotan.suse.de>
References: <20070731054142.GB11306@wotan.suse.de> <200707311114.09284.ak@suse.de> <Pine.LNX.4.64.0707311639450.31337@schroedinger.engr.sgi.com> <20070802034201.GA32631@wotan.suse.de> <Pine.LNX.4.64.0708021254160.8527@schroedinger.engr.sgi.com> <20070803002639.GC14775@wotan.suse.de> <Pine.LNX.4.64.0708021748110.13312@schroedinger.engr.sgi.com> <20070803005700.GD14775@wotan.suse.de> <Pine.LNX.4.64.0708021801010.13312@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708021801010.13312@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 06:02:56PM -0700, Christoph Lameter wrote:
> On Fri, 3 Aug 2007, Nick Piggin wrote:
> 
> > > Ok. So MPOL_BIND on a single node. We would have to save the current 
> > > memory policy on the stack and then restore it later. Then you would need 
> > > a special call anyways.
> > 
> > Well the memory policy will already be set to MPOL_BIND at this point.
> > The slab allocator I think would just have to honour the node at the
> > object level.
> 
> Who set the policy? The parent process may have its own memory policy. If 
> you set that then the earlier policy is lost.

Yeah it only gets set if the parent is initially using a default policy
at this stage (and then is restored afterwards of course).

