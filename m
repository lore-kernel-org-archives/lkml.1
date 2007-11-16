Return-Path: <linux-kernel-owner+w=401wt.eu-S1757960AbXKPQ2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbXKPQ2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 11:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbXKPQ2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 11:28:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47306 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbXKPQ2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 11:28:16 -0500
Date: Fri, 16 Nov 2007 17:28:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, Philip Mucci <mucci@cs.utk.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: perfmon2 merge news
Message-ID: <20071116162813.GA29644@one.firstfloor.org>
References: <20071113175545.GD4319@frankl.hpl.hp.com> <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu> <20071113185924.GA22748@suse.de> <20071113120728.4342e7d7.akpm@linux-foundation.org> <20071113203645.GA17145@one.firstfloor.org> <9FF72994-F55A-4B36-9EAA-CB1D2360A6F5@cs.utk.edu> <20071114015210.GA20365@one.firstfloor.org> <A42C2398-2EAB-460C-95C7-686A34A76F82@cs.utk.edu> <p737ikicjbn.fsf@bingen.suse.de> <20071116160056.GF10616@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116160056.GF10616@frankl.hpl.hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 08:00:56AM -0800, Stephane Eranian wrote:
> No, he is talking about something similar to what was in perfctr.
> The kernel emulates 64-bit counters in software and that is you
> get back when you read the counters. If you read via RDPMC, you
> get 40 bits. To reconstruct the full 64-bit value from user land
> you need the upper bits. One approach is for the kernel to allow
> you to remap a page that has the 64-bit (software) counters. With
> that and a bit of mask/shifting you can reconstruct the full value.

You mean the page contains the upper [40;63] bits? 

Sounds reasonable, although I don't remember seeing that when I looked
at the perfmon code last.

> 
> > I'm considering that an essential feature too. I wasn't aware
> > it was dropped.
> > 
> What I dropped is the cr4.pce enabled for self-monitoring sessions.

That sounds bad.

> Perfmon2 allows you to have an in-kernel sampling buffer. The idea is

... you also didn't say *why* that is needed.

Can you give a concrete use case for something that cannot be done
without custom buffer formats? 

> Using this mechanism, for instance, we were able to connect the
> Oprofile kernel code to perfmon2 on Itanium with a 100 lines of
> code. The exact same approach would also work on X86 Oprofile as well.

The existing oprofile code works already fine on x86, no real
need for another one.

> > e.g. PEBS and so on pretty much fix the in memory sample format in hardware,
> > so they only way to get a custom format would be to use a separate buffer.
> > 
> 
> This is also how we support PEBS because, as you said, the format of the
> samples is not under your control. if you want zero-copy PEBS support,
> you have to follow the PEBS format.

Exactly that makes the support for random custom buffers questionable.

e.g. as I can see the main advantage of perfmon over existing setups
is that it support PEBS etc., but with your custom buffer formats which
are by definition incompatible with PEBS you would negate that advantage
again.

Ok IBS will probably need some special handling.

> Yes, you could do that without changing the core implementation of
> perfmon2.

Why this insistence against changing anything?

-Andi
