Return-Path: <linux-kernel-owner+w=401wt.eu-S1030420AbXDMVRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030420AbXDMVRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030455AbXDMVRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:17:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030420AbXDMVRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:17:34 -0400
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
References: <20070412182213.a18cc4a7.akpm@linux-foundation.org>
	<461EE005.6070605@yahoo.com.au>
	<20070412185723.5a5f0443.akpm@linux-foundation.org>
	<461EE890.2040601@yahoo.com.au>
	<20070412193255.62a0b8ed.akpm@linux-foundation.org>
	<461EEFEC.2010205@yahoo.com.au> <20070413065357.GP2986@holomorphy.com>
	<461F2BCB.2020200@yahoo.com.au> <20070413075142.GA23822@infradead.org>
	<461F3961.6030300@yahoo.com.au> <20070413081338.GA27675@infradead.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: 13 Apr 2007 17:17:00 -0400
In-Reply-To: <20070413081338.GA27675@infradead.org>
Message-ID: <y0m6480x9df.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.0808 (Gnus v5.8.8) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Christoph Hellwig <hch@infradead.org> writes:

> [...]
> > merge it in the first place?
> 
> It's very nice to poke deep into the kernel for development purposes.
> For example for the spu scheduler work I'm doing currently I have
> a module using kprobes (note the systemtap crap because it's big, bloated,
> in and odd language, and does a lot of really wrong things in its runtime).

It may be worthwhile to remind people that it is easy to use systemtap
only to the extent of automating the placement of kprobes: just to
perform the function-name/source-file/line-number triplet to PC
mapping.  They can use embedded-C code to do all the same stuff they'd
do with kprobes.  They are not obligated to write any odd script code
for probing logic, nor indeed use any of this really wrong runtime.

> This module allows me to put probes into various places in the scheduler
> and writes them into a ringbuffer with timestampts allowing me to
> trace what's going on there.  This is really neat.  [...]

Indeed, and we too try to make this simple & fast: a couple of lines.

> [...] To summarize, I really love kprobes to ease my debugging work,
> but using it for any kind of production code is a total nightmare.

But at some point, some interface needs to be fixed for a final
user-space tool.  Whether that interface fixing is performed by kernel
developers being more reluctant to rewrite basic things, or by
providing a proc interface, or maintaining a kprobes module does not
matter.  Someone will feel constrained, and someone will be liberated.

One neat thing about our systemtap tool is that, no matter what layer
such interfaces become fixed within, it can probably interface to
them.  If there is no fixed interface, it can go down to debugging
info.  If there are tracing hooks present, it can attach.  It can make
appear as unified the disparate standardization policies of different
subsystems.


> > We could distribute some systemtap scripts, and even distribute some
> > basic useful ones like this sort of page info in the kernel source
> > tree.
>
> We could not really distribute systemtap scripts with the kernel.
> systemtap is a bloody complicated piece of [software] 

I don't know if that should be treated a compliment to our team, for
being able to work quickly on something that a full-grown kernel
developer finds bloody complicated.  Perhaps your information is
simply outdated.  Big & bloated?  We have several times asked for
specifics rather than smears - what about it?

> outside the kernel tree that breaks all the time we change kernel
> internals. [...]

That's begging the question.  If kernel folks are willing to maintain
some included systemtap-related code, then by definition it would not
break all the time.


- FChE
