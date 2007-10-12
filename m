Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbXJLIWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbXJLIWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 04:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXJLIWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 04:22:43 -0400
Received: from mx10.go2.pl ([193.17.41.74]:53490 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750981AbXJLIWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 04:22:42 -0400
Date: Fri, 12 Oct 2007 10:25:34 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 3/3] x86: optimise barriers
Message-ID: <20071012082534.GB1962@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004052348.GC15131@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04-10-2007 07:23, Nick Piggin wrote:
> According to latest memory ordering specification documents from Intel and
> AMD, both manufacturers are committed to in-order loads from cacheable memory
> for the x86 architecture. Hence, smp_rmb() may be a simple barrier.
...

Great news!

First it looks like a really great thing that it's revealed at last.
But then... there is probably some confusion: did we have to use
ineffective code for so long?

First again, we could try to blame Intel etc. But then, wait a minute:
is it such a mystery knowledge? If this reordering is done there are
some easy rules broken (just like in examples from these manuals). And
if somebody cared to do this for optimization, then this is probably
noticeable optimization, let's say 5 or 10%. Then any test shouldn't
need to take very long to tell the truth in less than 100 loops!

So, maybe linux needs something like this, instead of waiting few
years with each new model for vendors goodwill? IMHO, even for less
popular processors, this could be checked under some debugging option
at the system start (after disabling suspicios barrier for a while
plus some WARN_ONs).

Thanks,
Jarek P.
