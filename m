Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbXG1Wi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbXG1Wi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 18:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369AbXG1WiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 18:38:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:53337 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249AbXG1WiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 18:38:19 -0400
Subject: Re: [patch] mm: reduce pagetable-freeing latencies
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0707280627110.26545@blonde.wat.veritas.com>
References: <20070724083855.GA858@elte.hu>
	 <20070724015441.8604d85d.akpm@linux-foundation.org>
	 <1185270045.5439.249.camel@localhost.localdomain>
	 <p73abtmt2y7.fsf@bingen.suse.de>
	 <1185312559.5439.276.camel@localhost.localdomain>
	 <1185345850.8197.64.camel@twins>
	 <1185586601.5495.299.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0707280627110.26545@blonde.wat.veritas.com>
Content-Type: text/plain
Date: Sun, 29 Jul 2007 08:36:20 +1000
Message-Id: <1185662181.5495.325.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The onstack array seems fine to me, even if you do end up deciding on
> an array of one.  Is there any evidence that it's a problem getting a
> page for the freeing (other than in circumstances that are already
> badly slowed down)?  It's obvious that we need a fallback route,
> but optimizing throughput on that route seems premature.

Hrm, no evidence of that so far indeed. I'm worried by the stack usage
of the unmap_mapping_ranges() but appart from that, no.

Appart from that, yeah, I suppose we can have a macro defining how many
on-stack backup we have and adjust it if we see that being a problem.
I'm not fan of dynamic on-stack allocations.

Ben.


