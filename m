Return-Path: <linux-kernel-owner+w=401wt.eu-S1761592AbXHXMUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761592AbXHXMUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757186AbXHXMUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:20:41 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2694 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760532AbXHXMUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:20:41 -0400
Date: Fri, 24 Aug 2007 12:20:25 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Zachary Amsden <zach@vmware.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
Message-ID: <20070824122025.GA3886@ucw.cz>
References: <46CBC842.4070100@vmware.com> <46CBD0F5.2080709@zytor.com> <46CBD1A5.8070702@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CBD1A5.8070702@vmware.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>In general, I/O in a virtual guest is subject to 
> >>performance problems. The I/O can not be completed 
> >>physically, but must be virtualized.  This
> >>means trapping and decoding port I/O instructions from 
> >>the guest OS. Not only is the trap for a #GP 
> >>heavyweight, both in the processor and
> >>the hypervisor (which usually has a complex #GP path), 
> >>but this forces
> >>the hypervisor to decode the individual instruction 
> >>which has faulted. Worse, even with hardware assist 
> >>such as VT, the exit reason alone is
> >>not sufficient to determine the true nature of the 
> >>faulting instruction,
> >>requiring a complex and costly instruction decode and 
> >>simulation.
> >>
> >>This patch provides hypercalls for the i386 port I/O 
> >>instructions, which
> >>vastly helps guests which use native-style drivers.  
> >>For certain VMI
> >>workloads, this provides a performance boost of up to 
> >>30%.  We expect
> >>KVM and lguest to be able to achieve similar gains on 
> >>I/O intensive
> >>workloads.
> >>
> >>    
> >
> >What about cost on hardware?
> >  
> 
> On modern hardware, port I/O is about the most expensive 
> thing you can do.  The extra function call cost is 
> totally masked by the stall.  We have measured with port 
> I/O converted like this on real hardware, and have seen 
> zero measurable impact on macro-benchmarks.  
> Micro-benchmarks that generate massively repeated port 
> I/O might show some effect on ancient hardware, but I 
> can't even imagine a workload which does such a thing, 
> other than a polling port I/O loop perhaps - which would 
> not be performance critical in any case I can reasonably 
> imagine.

SCSI controller in ISA slot? IDE without DMA enabled?

Yes, those are performance-critical. The second case seems common with
compactflash cards.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
