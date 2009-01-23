Return-Path: <linux-kernel-owner+w=401wt.eu-S1760754AbZAWQDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760754AbZAWQDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 11:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756957AbZAWQDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 11:03:31 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49490 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941AbZAWQDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 11:03:31 -0500
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <alpine.DEB.1.10.0901231055520.32253@qirst.com>
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI>
	 <200901240212.58829.nickpiggin@yahoo.com.au>
	 <alpine.DEB.1.10.0901231025320.21692@qirst.com>
	 <200901240237.10522.nickpiggin@yahoo.com.au>
	 <alpine.DEB.1.10.0901231055520.32253@qirst.com>
Date: Fri, 23 Jan 2009 18:03:29 +0200
Message-Id: <1232726609.6094.106.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2009, Nick Piggin wrote:
> > However, I don't know if netperf udp 4K over loopback is totally
> > realistic. Maybe real network drivers have different allocation patterns.
> > If I were you I wouldn't be too hasty to make big changes based on that
> > alone, if it could introduce regression in somewhere more important.

On Fri, 2009-01-23 at 10:57 -0500, Christoph Lameter wrote:
> AFAICT it just wastes memory. My idea of a slab allocator is that it is
> used for small (less than page sized) allocations. The page allocator
> should be able to handle page sized allocations in an effective manner.

FWIW, based on my results, it's actually the big objects that are so
badly fitting which causes much of the wasted memory. So I'd prefer to
get rid of the page allocator completely for kmalloc() and just use a
best fit allocator for everything. Something like my binalloc. ;-)

			Pekka

