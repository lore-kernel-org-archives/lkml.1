Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZAWPGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZAWPGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 10:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZAWPGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 10:06:40 -0500
Received: from smtp.ultrahosting.com ([74.213.174.254]:35305 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbZAWPGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 10:06:39 -0500
Date: Fri, 23 Jan 2009 10:03:22 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
In-Reply-To: <200901231952.53961.nickpiggin@yahoo.com.au>
Message-ID: <alpine.DEB.1.10.0901230955470.13690@qirst.com>
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI> <200901231952.53961.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009, Nick Piggin wrote:

> Hmm, it lists quite a number of advantages that I guess are being
> reverted too? What was the test case(s) that prompted this commit
> in the first place? Better ensure it doesn't slow down...

The advantage was mainly memory savings and abilty to redefined kmallocs
to go directly to the page allocator. Totally avoids slab allocator overhead.

I thought higher order allocations were not supposed to be used in
performance critical paths? Didnt you want to do everything with order-0
allocs?

It seems that we currently need the slab allocators to compensate for the
performance problems in the page allocator for these higher order allocs.
I'd rather have the page allocator fixed but things are as they are.



