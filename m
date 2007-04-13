Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbXDMREI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbXDMREI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 13:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbXDMREI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 13:04:08 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42584 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbXDMREF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 13:04:05 -0400
Date: Fri, 13 Apr 2007 10:03:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-Id: <20070413100356.62c6d9c2.akpm@linux-foundation.org>
In-Reply-To: <20070413162436.GO11115@waste.org>
References: <1.486631555@selenic.com>
	<20070412231050.GN2986@holomorphy.com>
	<20070412163235.dd030637.akpm@linux-foundation.org>
	<461ECB9C.8060000@yahoo.com.au>
	<20070412174201.065068b2.akpm@linux-foundation.org>
	<20070413162436.GO11115@waste.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 11:24:36 -0500 Matt Mackall <mpm@selenic.com> wrote:

> > It *will* be viable.  If the application wants to know if a page is dirty,
> > it looks up "PG_dirty" in /proc/pg_foo-to-bitnumber and uses PG_dirty's
> > numerical offset when inspecting fields in /proc/kpagemap.  If correctly
> > designed, such a monitoring application will be able to report upon page
> > flags which we haven't even thought up yet.
> 
> We can probably fit this in the existing (variable-sized) header.

hm, OK..

> > > I wonder what they are needed for.
> > 
> > Poking deeply into the kernel to provide information about kernel state. 
> > 
> > There are real-world needs for this, and the people who develop tools to
> > process this information will have decent kernel understanding and will
> > know that the file's contents may alter across kernel versions.  It sure
> > beats poking around in /dev/kmem.
> > 
> > I doubt if there's a sensible way in which we can prettify this interface
> > without losing information.  But we should aim to make it as robust as
> > possible agaisnt future kenrel changes, of course.
> > 
> > And we should satisfy ourselves that all the required information has been
> > made available.  The fact that it will satisfy the Oracle requirement is
> > encouraging.
> > 
> > Matt, these changes make the new field in /proc/pid/smaps redundant, don't
> > they?
> 
> Which new field?

Referenced:

> From /proc/kpagemap + /proc/*/pagemap, you can
> basically synthesize any statistic you want, including all the
> existing ones. For some data, /proc/pid/smaps (or /proc/meminfo) will
> be considerably more efficient.

You'd need to poke clear_refs beforehand to make the referenced bits useful.

Actually, we also need to run around the ptes and collect the pte-referenced
bits too.  I don't think your code copes with any of that?
 
> But in general, most of the statistics in smaps are basically useless
> for shared mappings, just like RSS. Problem is, we really don't know
> what statistics we want yet, or even if it can be distilled down to
> simple numbers anyway.

yup.  But that's the whole point, really: don't prejudge what info userspace
is trying to collect.
