Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbXDMIPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbXDMIPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 04:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXDMIPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 04:15:42 -0400
Received: from holomorphy.com ([66.93.40.71]:41108 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbXDMIPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 04:15:40 -0400
Date: Fri, 13 Apr 2007 01:15:44 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070413081544.GS2986@holomorphy.com>
References: <461ED96C.5030606@yahoo.com.au> <20070412182213.a18cc4a7.akpm@linux-foundation.org> <461EE005.6070605@yahoo.com.au> <20070412185723.5a5f0443.akpm@linux-foundation.org> <461EE890.2040601@yahoo.com.au> <20070412193255.62a0b8ed.akpm@linux-foundation.org> <461EEFEC.2010205@yahoo.com.au> <20070413065357.GP2986@holomorphy.com> <461F2BCB.2020200@yahoo.com.au> <20070413075142.GA23822@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413075142.GA23822@infradead.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 08:51:42AM +0100, Christoph Hellwig wrote:
> Umm, folks.  systemtap basically means people compile kernel modules
> from an odd scripting language with embedded C snipplets into kernel
> modules.  The kernel modules don't use normal exported APIs but use
> kallsysms and dwarf info to poke into every possible private bit.
> Saying you don't care the slightest whether oracle will load huge
> amounts of code into the kernel that depends on intimate implementation
> details, and that you don't even have source to to debug it is not what
> I'd call "none of us need to care in the slightest", at least for those
> of you working for distributions that may actually have to debug this
> shit in the end.
> While we're at it, what happened to the idea of tainting the kernel
> as soon as krpobes are placed in the kernel to at least make people
> aware of it?

This is for a system monitoring app outside the database proper that
just happens to be done by the same .com as makes the database. It's
got little to do with the database itself apart from knowing how to
tell the database to e.g. let fewer clients in. The part that deals
with this is sort of like a custom procps that does things rather
specifically how they need them, including being portable to other
OS's IIRC, though the scope of the app is much larger than that.

They're actually quite concerned about issues of this sort since they
want to run all the time in the background in order to respond to
system conditions, though probably not necessarily rapid-fire sorts of
responses to second-by-second changes in conditions.

Basically, they're not a debugging affair, and they need to be able to
run in supported conditions. They're rather disinterested in things
that would, say, taint the kernel or take customers out of supported
configurations. They'll fall back to the known-grossly-inaccurate
RSS-based estimates they're using now in preference to such.

They don't want omnibus back doors into the kernel and I honestly
expect them to NAK the systemtap solution. They really want the
"uniquely attributable RSS" or "proportional RSS" reported directly,
and it takes some doing to convince them that this can't be done
directly for various reasons, e.g. floating point in the kernel won't
fly. They can program sufficiently well to maintain a database of pfn's,
pid's of processes mapping them, and user virtual addresses they're
mapped at (easy enough to kick off a database instance for it if they
don't feel comfortable just hashing the triples) and do the tabulation
from there, though they're not happy having to do so much of the
calculation themselves. Actually, I promised them reporting of mapcount
which would make per-process UARSS/PRSS calculation able to be done on
a process-by-process basis, though I can probably convince them to do
whole-system pfn-by-pfn tabulation if such is lacking.


-- wli
