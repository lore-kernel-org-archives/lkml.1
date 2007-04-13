Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbXDMRZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbXDMRZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 13:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbXDMRZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 13:25:40 -0400
Received: from waste.org ([66.93.16.53]:34315 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108AbXDMRZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 13:25:39 -0400
Date: Fri, 13 Apr 2007 12:13:08 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070413171308.GP11115@waste.org>
References: <1.486631555@selenic.com> <20070412231050.GN2986@holomorphy.com> <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au> <20070412174201.065068b2.akpm@linux-foundation.org> <461ED96C.5030606@yahoo.com.au> <20070412182213.a18cc4a7.akpm@linux-foundation.org> <461EE005.6070605@yahoo.com.au> <20070412185723.5a5f0443.akpm@linux-foundation.org> <461EE890.2040601@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461EE890.2040601@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 12:18:56PM +1000, Nick Piggin wrote:
> Can't you just traverse arbitrary kernel data structures at a given point
> in time, exactly like the /proc/ call is doing?

Perhaps.

My understanding is that you hook a kprobe to an event. An event is a
particular instruction getting executed. Indeed, you can do whatever
poking around in the kernel you want at that point. And then you can
stuff that data in a buffer that eventually gets to userspace.

This is very different from a read/seek/syscall. Rather than just
asking the kernel for some data, we have to wait for the relevent
events. Now, of course, you can make an ugly hack like hooking
sys_getpid() and basically make your own system call. Hopefully no one
else will call getpid() while you're doing this, etc. Not really how
it's intended to work at all, and probably a bitch to use, but
possible. Then the question becomes: why don't we do this for
everything else in /proc?

And the answer of course is: we put stuff in /proc because it's
generally useful. Extra points if it's actually related to
'proc'esses. Being able to tell what's paged in in a given mapping is
useful. Being able to tell what's shared between two mappings is
useful. Being able to get an accurate, meaningful picture of how your
memory is being used is useful. Heck, I bet some people might find it
useful to be able to see what nodes the pages in their process are on.
All stuff you shouldn't need to be a kernel hacker to answer.

The flags part of /proc/kpagemap exposes some (very interesting!)
implementation details. The rest of it is completely generic to any
system with a VM. It's only deep kernel magic in the sense that it's
not yet exposed.

-- 
Mathematics is the supreme nostalgia of our time.
