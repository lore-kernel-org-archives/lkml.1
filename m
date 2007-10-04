Return-Path: <linux-kernel-owner+w=401wt.eu-S1758897AbXJDMI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbXJDMI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 08:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbXJDMIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 08:08:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47629 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbXJDMIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 08:08:18 -0400
Subject: Re: [13/18] x86_64: Allow fallback for the stack
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, travis@sgi.com
In-Reply-To: <200710041356.51750.ak@suse.de>
References: <20071004035935.042951211@sgi.com>
	 <20071004040004.708466159@sgi.com>  <200710041356.51750.ak@suse.de>
Content-Type: text/plain
Date: Thu, 04 Oct 2007 14:08:12 +0200
Message-Id: <1191499692.22357.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-04 at 13:56 +0200, Andi Kleen wrote:
> On Thursday 04 October 2007 05:59:48 Christoph Lameter wrote:
> > Peter Zijlstra has recently demonstrated that we can have order 1 allocation
> > failures under memory pressure with small memory configurations. The
> > x86_64 stack has a size of 8k and thus requires a order 1 allocation.
> 
> We've known for ages that it is possible. But it has been always so rare
> that it was ignored.
> 
> Is there any evidence this is more common now than it used to be?

The order-1 allocation failures where GFP_ATOMIC, because SLUB uses !0
order for everything. Kernel stack allocation is GFP_KERNEL I presume.
Also, I use 4k stacks on all my machines.

Maybe the cpumask thing needs an extended api, one that falls back to
kmalloc if NR_CPUS >> sane.

That way that cannot be an argument to inflate stacks.

