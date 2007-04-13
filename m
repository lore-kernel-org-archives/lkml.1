Return-Path: <linux-kernel-owner+w=401wt.eu-S1750909AbXDMRhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750909AbXDMRhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 13:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbXDMRhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 13:37:23 -0400
Received: from waste.org ([66.93.16.53]:33682 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbXDMRhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 13:37:22 -0400
Date: Fri, 13 Apr 2007 12:24:51 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070413172450.GQ11115@waste.org>
References: <1.486631555@selenic.com> <20070412231050.GN2986@holomorphy.com> <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au> <20070412174201.065068b2.akpm@linux-foundation.org> <20070413162436.GO11115@waste.org> <20070413100356.62c6d9c2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413100356.62c6d9c2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 10:03:56AM -0700, Andrew Morton wrote:
> On Fri, 13 Apr 2007 11:24:36 -0500 Matt Mackall <mpm@selenic.com> wrote:
> 
> > > It *will* be viable.  If the application wants to know if a page is dirty,
> > > it looks up "PG_dirty" in /proc/pg_foo-to-bitnumber and uses PG_dirty's
> > > numerical offset when inspecting fields in /proc/kpagemap.  If correctly
> > > designed, such a monitoring application will be able to report upon page
> > > flags which we haven't even thought up yet.
> > 
> > We can probably fit this in the existing (variable-sized) header.
> 
> hm, OK..
> 
> > > > I wonder what they are needed for.
> > > 
> > > Poking deeply into the kernel to provide information about kernel state. 
> > > 
> > > There are real-world needs for this, and the people who develop tools to
> > > process this information will have decent kernel understanding and will
> > > know that the file's contents may alter across kernel versions.  It sure
> > > beats poking around in /dev/kmem.
> > > 
> > > I doubt if there's a sensible way in which we can prettify this interface
> > > without losing information.  But we should aim to make it as robust as
> > > possible agaisnt future kenrel changes, of course.
> > > 
> > > And we should satisfy ourselves that all the required information has been
> > > made available.  The fact that it will satisfy the Oracle requirement is
> > > encouraging.
> > > 
> > > Matt, these changes make the new field in /proc/pid/smaps redundant, don't
> > > they?
> > 
> > Which new field?
> 
> Referenced:
> 
> > From /proc/kpagemap + /proc/*/pagemap, you can
> > basically synthesize any statistic you want, including all the
> > existing ones. For some data, /proc/pid/smaps (or /proc/meminfo) will
> > be considerably more efficient.
> 
> You'd need to poke clear_refs beforehand to make the referenced bits useful.
> 
> Actually, we also need to run around the ptes and collect the pte-referenced
> bits too.  I don't think your code copes with any of that?

No, and it probably should. Perhaps dirty as well, though I've kindof
lost the plot on how that works lately.

> > But in general, most of the statistics in smaps are basically useless
> > for shared mappings, just like RSS. Problem is, we really don't know
> > what statistics we want yet, or even if it can be distilled down to
> > simple numbers anyway.
> 
> yup.  But that's the whole point, really: don't prejudge what info userspace
> is trying to collect.

Right.

-- 
Mathematics is the supreme nostalgia of our time.
