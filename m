Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514AbZBDA2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbZBDA2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZBDA1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:27:55 -0500
Received: from gate.crashing.org ([63.228.1.57]:36853 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775AbZBDA1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:27:54 -0500
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
 standard config registers of all devices early)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jesse Barnes <jesse.barnes@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0902031514510.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <200902032253.42709.rjw@sisk.pl> <1233700390.16867.97.camel@pasglop>
	 <200902032344.22348.rjw@sisk.pl> <1233702327.16867.109.camel@pasglop>
	 <alpine.LFD.2.00.0902031514510.3247@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 11:27:19 +1100
Message-Id: <1233707239.16867.113.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 15:18 -0800, Linus Torvalds wrote:

> With ACPI, there is no such thing as a "big issue". There are only tons of 
> small horrid details that. And the "big issue" is that all the small 
> details are insane.

Allright, fair enough :-) Here's my grand plan defeated by the uglyness
of ACPI ... argh ! :-)

In any case, both approach will solve the problem at hand and I'll be
able to move some of that pmac uglyness into the platform hooks.

BTW. Do we want one or two system states ? IE. regarding silently
"upgrading" GFP_KERNEL, I believe it needs to be done in two different
phases. The main suspend loop (after all the prepare() calls complete)
should be done with GFP_KERNEL -> GFP_NOIO, and the last phase with IRQs
really disabled (local_irq_save, aka. sysdev's) could use being done
with GFP_KERNEL -> GFP_ATOMIC.

The later will not be used much, but with the PCI layer now doing
kmalloc GFP_KERNEL all over the place in trivial things like pci_get_*,
I think it's worth it as sysdev's like cpufreq, or other low level arch
bits like memory controller tweaking does involve mucking around with
PCI devices.

Cheers,
Ben.


