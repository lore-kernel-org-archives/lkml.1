Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbXJaTe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbXJaTe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 15:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbXJaTeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 15:34:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521AbXJaTeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 15:34:17 -0400
Date: Wed, 31 Oct 2007 15:29:40 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] Create kinst/ or ki/ directory ?
Message-ID: <20071031192940.GB12334@redhat.com>
References: <4726649A.5020605@garzik.org> <20071029230409.GB16943@Krystal> <472667F3.3000505@garzik.org> <20071030172442.GA4477@Krystal> <alpine.LFD.0.999.0710301044110.30120@woody.linux-foundation.org> <20071030185639.GA9077@Krystal> <alpine.LFD.0.999.0710301214300.30120@woody.linux-foundation.org> <20071030204043.GA13547@Krystal> <y0mk5p3qo8r.fsf@ton.toronto.redhat.com> <20071031163623.GA4766@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031163623.GA4766@Krystal>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Wed, Oct 31, 2007 at 12:36:24PM -0400, Mathieu Desnoyers wrote:

> [...]  That's right, Systemtap uses symbols, thanks for the
> clarification. But my point is still valid: SystemTAP expects
> function names and argument names to stay unchanged, therefore using
> the kernel code itself as an API to userspace tools. [...]

To be precise, this applies *kprobes*-based probes only.  In
acceptance of this fragility, systemtap includes constructs (aliases,
version-dependent conditionals) to make it reasonably easy to adapt to
different kernel versions.

> I think that SystemTAP's [kprobes-based probes'] flexibility is
> great, but leads to fagileness wrt kernel code changes. If the "core
> events" required by SystemTAP (and also by LTTng by the way) could
> be turned into markers, I think it would gain in robustness.

Yes.

> Providing the ability to instrument code locations with breakpoints, in
> addition to this, will help users unsatisfied with the information
> they have, unwilling to recompile their kernel or modules with their
> own markers, ready to accept the two limitations :
> - performance hit of a breakpoint
> - unability to access variables within optimized functions

That latter point has been repeatedly overstated.  Markers provides a
fixed set of values.  kprobes/dwarf provides access to any statements
and any values (including locals) that a compiler did not altogether
elide.  While the latter set is by its nature variable, it will be
much bigger than anything a reasonable set of markers will ever
expose.

> So yes, both approaches seems to be complementary.

Indeed.

> > > About extending on ptrace, I am sorry to say that this solution has
> > > the same downsides as kprobes: it is too slow for high performance
> > > applications, especially if turned on system-wide. [...]
> > 
> > Roland McGrath's ptrace-replacement (utrace) should help with this.
> 
> Yes, I think he did a good job at it. However, it is not a replacement
> for the markers [...]

Right, not as a whole, but it *could* be an alternative way to hook
into system call type events.

> [...]
> So I would say : I'll try to submit a core set of markers patches for
> review on LKML and see what people have to say.

Thank you.  Our team is already in contact to help.

- FChE
