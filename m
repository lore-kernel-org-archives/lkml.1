Return-Path: <linux-kernel-owner+w=401wt.eu-S1760446AbZAWQCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446AbZAWQCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 11:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbZAWQCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 11:02:43 -0500
Received: from smtp.ultrahosting.com ([74.213.174.254]:37418 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702AbZAWQCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 11:02:42 -0500
Date: Fri, 23 Jan 2009 10:59:17 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
In-Reply-To: <200901240241.06670.nickpiggin@yahoo.com.au>
Message-ID: <alpine.DEB.1.10.0901231057280.32253@qirst.com>
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI> <84144f020901230716n3f106034x8a10463b411c9a9b@mail.gmail.com> <alpine.DEB.1.10.0901231022490.21692@qirst.com> <200901240241.06670.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2009, Nick Piggin wrote:

> Page allocator is never going to be as fast as slab allocator, for
> issues I explained a long time ago. Not to say it can't be improved,
> just stating facts.

Why not? Remember the discussion we had a while ago. You can bring the
pages into a state where minimal manipulations are required for alloc free
and avoid all the checks in the hot paths. The SLUB method could be used
taking a big contiguous chunk and then issueing page size portions of it.
That could be quite fast.

Or if you prefer order-0. Do a single linked list like SLQB does.


