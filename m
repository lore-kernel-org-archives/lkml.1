Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbYIXWyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbYIXWyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 18:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYIXWyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 18:54:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:41488 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbYIXWyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:54:36 -0400
Subject: Re: PTE access rules & abstraction
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickins <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Peter Chubb <peterc@gelato.unsw.edu.au>
In-Reply-To: <48DAC285.80507@goop.org>
References: <1221846139.8077.25.camel@pasglop>  <48D739B2.1050202@goop.org>
	 <1222117551.12085.39.camel@pasglop>
	 <Pine.LNX.4.64.0809241919520.575@blonde.site>
	 <1222291248.8277.90.camel@pasglop>  <48DAB7E2.5030009@goop.org>
	 <1222294041.8277.104.camel@pasglop>  <48DAC285.80507@goop.org>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 08:53:04 +1000
Message-Id: <1222296784.8277.126.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Yes, that sounds fine in principle, but the practise gets tricky.  The
> trouble with that kind of interface is that it can be fairly heavyweight
> unless you amortise the cost of the transaction setup/commit with
> multiple operations.

I agree. Anyway, I'm sure if we get everybody around the same table, we
can find something, maybe not that high level, but a better set of
accessors that fits all needs with a more precise semantic. Anyway, I'll
see if I can come up with ideas later that we can discuss.

It's also all inline so it does give us flexibility in having things
compile down to nothing on archs where they aren't needed.

> Are you using the lazy_mmu hooks we put in, or something else?

Yes. We used to do it differently but it was actually racy in a subtle
way, and I switched it to use your lazy_mmu hooks a while ago.

> Likely; it's one of those overused generic words.  The specific meaning
> I'm using is "we can roll a bunch of updates into a single hypercall". 
> Operations which do atomic RMW  or fetch-set are typically not batchable
> because the caller wants the result *now* and can't wait for a deferred
> result.

Right. For us it's mostly about flushing the hash entries, though there
is no fundamental difference I believe here, it's about updating a
cache, whether it's the TLB, our hash table, hypervisor shadows, etc...
and we -should- be able to find a more sensible common ground.

Cheers,
Ben.


