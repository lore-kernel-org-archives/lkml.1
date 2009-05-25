Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZEYTes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZEYTes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 15:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbZEYTek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 15:34:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46903 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbZEYTek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 15:34:40 -0400
Date: Mon, 25 May 2009 20:34:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jamie Lokier <jamie@shareable.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
Message-ID: <20090525193414.GB3667@n2100.arm.linux.org.uk>
References: <20090422171703.19555.83629.stgit@pc1117.cambridge.arm.com> <20090423141248.22193.10543.stgit@pc1117.cambridge.arm.com> <20090524131636.GB3159@n2100.arm.linux.org.uk> <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal> <20090525161941.GA3667@n2100.arm.linux.org.uk> <20090525172955.GA17665@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525172955.GA17665@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 01:29:55PM -0400, Mathieu Desnoyers wrote:
> Basically, to make sure we don't forget anything, someone should go
> through all the atomic_ops.txt document once more and audit all ARM
> primitives.

That's easy to say - it took me more than half an hour of reading through
atomic_ops.txt to work out what was required for things like cmpxchg,
xchg, etc because it's _very_ waffley and verbose, and directs you to
other parts of the document.

For example, for atomic_cmpxchg it directs you to 'cas' but cas doesn't
really say what the barrier requirements are - reading it leaves me
to expect that provided spinlocks are serializing themselves, it's
fine if 'cas' itself isn't.

Maybe if someone has a few days to translate atomic_ops.txt into a
succinct set of requirements, and get _that_ reviewed, then we could
properly audit this stuff.
