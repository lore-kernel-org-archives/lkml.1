Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbXDMAiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbXDMAiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 20:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbXDMAiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 20:38:09 -0400
Received: from waste.org ([66.93.16.53]:38115 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948AbXDMAiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 20:38:07 -0400
Date: Thu, 12 Apr 2007 19:25:38 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070413002538.GJ11115@waste.org>
References: <1.486631555@selenic.com> <20070412231050.GN2986@holomorphy.com> <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461ECB9C.8060000@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 10:15:24AM +1000, Nick Piggin wrote:
> Andrew Morton wrote:
> >On Thu, 12 Apr 2007 16:10:50 -0700
> >William Lee Irwin III <wli@holomorphy.com> wrote:
> 
> >>+       while (count > 0) {
> >>+               chunk = min_t(size_t, count, PAGE_SIZE);
> >>+               i = 0;
> >>+
> >>+               if (pfn == -1) {
> >>+                       page[0] = 0;
> >>+                       page[1] = 0;
> >>+                       ((char *)page)[0] = (ntohl(1) != 1);
> >
> >
> >OK.
> >
> >
> >>+                       ((char *)page)[1] = PAGE_SHIFT;
> >
> >
> >OK.
> 
> Shouldn't we just expose page size and endianness by other means? (another 
> file or
> syscall).

If I send you this file dumped from a random machine, you won't know
what to make of it.

I'm planning to write a trivial server to sit on, say, my embedded
target and spew this over the wire to a client. 

> >Not a good idea to expose raw flags in this manner - it changes at the drop
> >of a hat.  We'd need to also expose the kernel's PG_foo-to-bitnumber
> >mapping to make this viable.
> 
> I don't think it is viable because that makes the flags part of the
> userspace ABI. I wonder what they are needed for.

Basically: to show what the hell's going on in the VM.

-- 
Mathematics is the supreme nostalgia of our time.
