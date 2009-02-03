Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbZBCAQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbZBCAQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbZBCAQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:16:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067AbZBCAQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:16:03 -0500
Date: Mon, 2 Feb 2009 16:15:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: PCI PM: Restore standard config registers of all devices early
In-Reply-To: <alpine.LFD.2.00.0902021551050.3247@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0902021611210.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902022331.49131.rjw@sisk.pl> <alpine.LFD.2.00.0902021508340.3247@localhost.localdomain> <200902030045.19416.rjw@sisk.pl> <alpine.LFD.2.00.0902021551050.3247@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Feb 2009, Linus Torvalds wrote:
> 
>      IOW, we can easily add a magic flag for registering a timer 
>      interrupt (in fact, I guess we already have IRQF_TIMER)

Side note: we may have IRQF_TIMER (and some timers even set it), but since 
it's not actually _used_ for anything it should come as no surprise that 
it's not set by the x86 code, for example (nor by a lot of other 
architectures).

But we can already notice system interrupts automatically by them being 
registered by "setup_irq()" instead of "request_irq()". And on x86, many 
of the really core interrupts aren't actually seen as device interrupts at 
all, but are directly taken by the kernel through local apic stuff. So 
they wouldn't get disabled anyway (example: local APIC timer interrupts 
and the inter-processor IPI).

So it should be pretty easy to do a reasonable job with the information 
that we already have available.

			Linus
