Return-Path: <linux-kernel-owner+w=401wt.eu-S1765162AbXJZU5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765162AbXJZU5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbXJZU5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:57:42 -0400
Received: from waste.org ([66.93.16.53]:59691 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbXJZU5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:57:41 -0400
Date: Fri, 26 Oct 2007 15:57:14 -0500
From: Matt Mackall <mpm@selenic.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Message-ID: <20071026205714.GQ17536@waste.org>
References: <20071024195847.GE27248@parisc-linux.org> <1193255992-14385-1-git-send-email-matthew@wil.cx> <200710261211.01423.rusty@rustcorp.com.au> <20071026115727.GR27248@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026115727.GR27248@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 05:57:27AM -0600, Matthew Wilcox wrote:
> On Fri, Oct 26, 2007 at 12:11:01PM +1000, Rusty Russell wrote:
> > 	This just seems like more optimization and complexity that we need.  Interfaces
> > using vsnprintf don't seem like good candidates for optimization.
> 
> That's a fair point, but I'm optimising for fewer trips into the
> slab(/slub/slob) allocator, and thus having less of an impact on the
> rest of the system.  Given that 'an alloc on every call' was one of the
> complaints Matt had about my v1 stringbuf patch, I can't imagine he'll
> be happy about this one either.

Well I expect once you start letting people easily build strings by
concatenation, you'll very shortly afterwards have people using them
in loops. And having hidden O(n^2) behavior in there is a little sad,
even though n will tend to be small and well-bounded. If we can do
something simple to avoid it, we should.

-- 
Mathematics is the supreme nostalgia of our time.
