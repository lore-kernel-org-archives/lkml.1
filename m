Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651AbXDMMKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbXDMMKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 08:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbXDMMKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 08:10:17 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58651 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbXDMMKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 08:10:14 -0400
Date: Fri, 13 Apr 2007 17:43:47 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070413121347.GA30280@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au> <20070412174201.065068b2.akpm@linux-foundation.org> <461ED96C.5030606@yahoo.com.au> <20070412182213.a18cc4a7.akpm@linux-foundation.org> <461EE005.6070605@yahoo.com.au> <20070412185723.5a5f0443.akpm@linux-foundation.org> <461EE890.2040601@yahoo.com.au> <20070412193255.62a0b8ed.akpm@linux-foundation.org> <461EEFEC.2010205@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461EEFEC.2010205@yahoo.com.au>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 12:50:20PM +1000, Nick Piggin wrote:
> Andrew Morton wrote:
> >On Fri, 13 Apr 2007 12:18:56 +1000 Nick Piggin <nickpiggin@yahoo.com.au> 
> >wrote:
> >
> >
> >>>I guess one could generate an answer to the static question with 
> >>>systemtap,
> >>>by accumulating running counts across the application lifetime and then
> >>>snapshotting them.  Sounds hard though.
> >>
> >>Can't you just traverse arbitrary kernel data structures at a given point
> >>in time, exactly like the /proc/ call is doing?
> >
> >
> >Do a full pagetable walk, with all the associated locking from within
> >a systemtap script?  I'd be surprised.  Maybe if it's mostly hand-coded
> >in C, perhaps.
> 
> It looks like you can traverse arbitrary data structures, yes.
> 
> It definitely seems like you can use some kernel functions, but the
> ones I saw may just be systemtap facilities. But what is so surprising
> about being able to call a kernel function when running in kernel
> context? Perhaps there is some fundamental limitation of kprobes that
> I don't understand.

The main requirement for kprobes handlers is that they can't sleep. You
could definitely call a kernel function from kprobe handlers as long as
the function doesn't sleep.

Ananth
