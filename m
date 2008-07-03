Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbYGCMCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbYGCMCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbYGCMB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:01:29 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44386 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbYGCMB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:01:26 -0400
Date: Thu, 3 Jul 2008 05:34:28 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Dan Williams <dan.j.williams@intel.com>, Martine.Silbermann@hp.com,
       linux-kernel@vger.kernel.org, Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: Multiple MSI
Message-ID: <20080703113427.GD14894@parisc-linux.org>
References: <20080703024445.GA14894@parisc-linux.org> <1215055469.21182.70.camel@pasglop> <20080703035910.GB14894@parisc-linux.org> <1215060119.21182.77.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215060119.21182.77.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 02:41:59PM +1000, Benjamin Herrenschmidt wrote:
> Ok, so I lift my objection there in the sense that allocating a linear
> array of virtual numbers shouldn't be a problem (somebody remind me to
> make NR_IRQS a config option one of these days on ppc, or help with just
> getting rid of irq_desc array alltogether :-)

;-)

> However, do you want to still keep the fact that they are power-of-2
> aligned up to the API or can I just do a linear block allocation for
> virtual number sand require drivers to do the appropriate
> addition/subtraction to get the N'th one ? I will need to allocate
> appropriately aligned HW numbers but that's done via different
> mechanisms (and in some case not even under full linux control, ie,
> hypervisor/firmware does it on pSeries).

Similar situation on x86-64, so I already thought about it ;-)  I think
the IRQ numbers should be contiguous, but not necessarily aligned.
They are, after all, virtual.

> > By the way, would people be interested in changing the MSI-X API to get
> > rid of the msix_entry array?  If allocating consecutive IRQs isn't a
> > problem, then we could switch the MSI-X code to use consecutive IRQs.
> 
> It would make a lot of code simpler...

It certainly would!

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
