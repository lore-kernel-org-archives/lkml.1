Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbYKMXOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbYKMXOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYKMXOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:14:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50278
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752768AbYKMXOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:14:37 -0500
Date: Thu, 13 Nov 2008 15:14:35 -0800 (PST)
Message-Id: <20081113.151435.146617325.davem@davemloft.net>
To: travis@sgi.com
Cc: paulus@samba.org, akpm@linux-foundation.org, yinghai@kernel.org,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
From: David Miller <davem@davemloft.net>
In-Reply-To: <491CB421.2020701@sgi.com>
References: <18716.42977.127816.205211@cargo.ozlabs.ibm.com>
	<20081113.142343.225648934.davem@davemloft.net>
	<491CB421.2020701@sgi.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Travis <travis@sgi.com>
Date: Thu, 13 Nov 2008 15:11:29 -0800

> David Miller wrote:
> > From: Paul Mackerras <paulus@samba.org>
> > Date: Fri, 14 Nov 2008 09:19:13 +1100
> > 
> >> Andrew Morton writes:
> >>
> >>> Other architectures want (or have) sparse interrupts.  Are those guys
> >>> paying attention here?
> >> On powerpc we have a mapping from virtual irq numbers (in the range 0
> >> to NR_IRQS-1) to physical irq numbers (which can be anything) and back
> >> again.  I think our approach is simpler than what's being proposed
> >> here, though we don't try to keep the irqdescs node-local as this
> >> patch seems to (fortunately our big systems aren't so NUMA-ish as to
> >> make that necessary).
> > 
> > This is exactly what sparc64 does as well, same as powerpc, and
> > as Paul said it's so much incredibly simpler than the dyn_irq stuff.
> 
> One problem is that pre-defining a static NR_IRQ count is almost always
> wrong when the NR_CPUS count is large, and should be adjusted as resources
> require.

We use a value of 256 and I've been booting linux on 128 cpu sparc64
systems with lots of PCI-E host controllers (and others have booted it
on even larger ones).  All of which have several NUMA domains.

It's not an issue.

> Large UV systems will take a performance hit from off-node accesses
> when the CPU count (or more likely the NODE count) reaches some
> threshold.  So keeping as much interrupt context close to the
> interrupting source is a good thing.

Just because the same piece of information is repeated over and
over again doesn't mean it really matters.
