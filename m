Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbYJOQ5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbYJOQ5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 12:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYJOQ5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 12:57:36 -0400
Received: from waste.org ([66.93.16.53]:48899 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbYJOQ5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 12:57:35 -0400
Subject: Re: [rfc] SLOB memory ordering issue
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: torvalds@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <200810160334.13082.nickpiggin@yahoo.com.au>
References: <200810160334.13082.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 11:54:18 -0500
Message-Id: <1224089658.3316.218.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-16 at 03:34 +1100, Nick Piggin wrote:
> I think I see a possible memory ordering problem with SLOB:
> In slab caches with constructors, the constructor is run
> before returning the object to caller, with no memory barrier
> afterwards.
> 
> Now there is nothing that indicates the _exact_ behaviour
> required here. Is it at all reasonable to expect ->ctor() to
> be visible to all CPUs and not just the allocating CPU?

Do you have a failure scenario in mind?

First, it's a categorical mistake for another CPU to be looking at the
contents of an object unless it knows that it's in an allocated state.

For another CPU to receive that knowledge (by reading a causally-valid
pointer to it in memory), a memory barrier has to occur, no?

-- 
Mathematics is the supreme nostalgia of our time.

