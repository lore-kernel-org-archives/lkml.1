Return-Path: <linux-kernel-owner+w=401wt.eu-S1161326AbXDKWpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161326AbXDKWpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161323AbXDKWpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:45:09 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51180 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161326AbXDKWpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:45:07 -0400
Subject: Re: [PATCH] markers-linker-generic
From: Jim Keniston <jkenisto@us.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>,
       "Frank Ch. Eigler" <fche@redhat.com>, systemtap@sources.redhat.com
In-Reply-To: <20070411192122.GA4668@Krystal>
References: <20070410223658.GC7092@Krystal>
	 <20070411074414.GC3752@flint.arm.linux.org.uk>
	 <20070411175110.GA30879@Krystal>
	 <20070411110240.537ee25d.akpm@linux-foundation.org>
	 <20070411192122.GA4668@Krystal>
Content-Type: text/plain
Date: Wed, 11 Apr 2007 14:45:00 -0700
Message-Id: <1176327900.3542.22.camel@ibm-ni9dztukfq8.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-11 at 15:21 -0400, Mathieu Desnoyers wrote:
> * Andrew Morton (akpm@linux-foundation.org) wrote:
> > On Wed, 11 Apr 2007 13:51:11 -0400
> > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > > What's this marker stuff about?
> > > > 
> > > 
> > > Hi Russel,
> > > 
> > > Here is an overview :
> > 
> > I am told that the systemtap developers plan to (or are) using this
> > infrastructure.
> > 
> 
> Quoting Frank Ch. Eigler, from the SystemTAP team :
> 
> "The LTTng user-space programs use it today.  Systemtap used to support
> the earlier marker prototype and will be rapidly ported over to this
> new API upon acceptance."
> 
> 
> > If correct: what is their reason for preferring it over kprobes?
> > 
> 
> I will let them answer on this one..
> 

I'll take a shot at this one.

First of all, kprobes remains a vital foundation for SystemTap.  But
markers are attactive as an alternate source of trace/debug info.
Here's why:

1. Markers will live in the kernel and presumably be kept up to date by
the maintainers of the enclosing code.  We have a growing set of tapsets
(probe libraries), each of which "knows" the source code for a certain
area of the kernel.  Whenever the underlying kernel code changes (e.g.,
a function or one of its args disappears or is renamed), there's a
chance that the tapset will become invalid until we bring it back in
sync with the kernel.  As you can imagine, maintaining tapsets separate
from the kernel source is a maintenance headache.  Markers could
mitigate this.

2. Because the kernel code is highly optimized, the kernel's dwarf info
doesn't always accurately reflect which variables have which values on
which lines (sometimes even upon entry to a function).  A marker is a
way to ensure that values of interest are available to SystemTap at
marked points.

3. Sometimes the overhead of a kprobe probepoint is too much (either in
terms of time or locking) for the particular hotspot we want to probe.

Jim

