Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039AbZEZL34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbZEZL34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 07:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbZEZL3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 07:29:49 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:45839 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802AbZEZL3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 07:29:48 -0400
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jamie Lokier <jamie@shareable.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20090525193414.GB3667@n2100.arm.linux.org.uk>
References: <20090422171703.19555.83629.stgit@pc1117.cambridge.arm.com>
	 <20090423141248.22193.10543.stgit@pc1117.cambridge.arm.com>
	 <20090524131636.GB3159@n2100.arm.linux.org.uk>
	 <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org>
	 <20090525151724.GA14321@Krystal>
	 <20090525161941.GA3667@n2100.arm.linux.org.uk>
	 <20090525172955.GA17665@Krystal>
	 <20090525193414.GB3667@n2100.arm.linux.org.uk>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 26 May 2009 12:29:12 +0100
Message-Id: <1243337352.21735.12.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2009 11:29:13.0649 (UTC) FILETIME=[323F1210:01C9DDF5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-25 at 20:34 +0100, Russell King - ARM Linux wrote:
> On Mon, May 25, 2009 at 01:29:55PM -0400, Mathieu Desnoyers wrote:
> > Basically, to make sure we don't forget anything, someone should go
> > through all the atomic_ops.txt document once more and audit all ARM
> > primitives.
> 
> That's easy to say - it took me more than half an hour of reading through
> atomic_ops.txt to work out what was required for things like cmpxchg,
> xchg, etc because it's _very_ waffley and verbose, and directs you to
> other parts of the document.
> 
> For example, for atomic_cmpxchg it directs you to 'cas' but cas doesn't
> really say what the barrier requirements are - reading it leaves me
> to expect that provided spinlocks are serializing themselves, it's
> fine if 'cas' itself isn't.
> 
> Maybe if someone has a few days to translate atomic_ops.txt into a
> succinct set of requirements, and get _that_ reviewed, then we could
> properly audit this stuff.

Documentation/memory-barriers.txt has a section on atomic operations and
it states that barriers should be placed on each side of the cmpxchg and
xchg operations.

-- 
Catalin

