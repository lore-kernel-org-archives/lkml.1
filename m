Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbYGGQ4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbYGGQ4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756387AbYGGQvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:51:23 -0400
Received: from colo.lackof.org ([198.49.126.79]:59972 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756366AbYGGQvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:51:21 -0400
Date: Mon, 7 Jul 2008 10:51:07 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-pci@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Dan Williams <dan.j.williams@intel.com>, Martine.Silbermann@hp.com,
       linux-kernel@vger.kernel.org, Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: Multiple MSI
Message-ID: <20080707165107.GG7521@colo.lackof.org>
References: <20080703024445.GA14894@parisc-linux.org> <1215055469.21182.70.camel@pasglop> <20080707161703.GB7521@colo.lackof.org> <20080707163919.GC14894@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080707163919.GC14894@parisc-linux.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 10:39:19AM -0600, Matthew Wilcox wrote:
...
> > If the Local-APICs are able to redirect interrupts, then multiple CPUs
> > can process the interrupts.
> 
> That's not the only way it can work.  If you have an APIC per root bus,
> you can target that with the write.  The APIC could then map the
> interrupt request to the appropriate CPU.  In this scenario, programming
> affinity would be twiddling some bits in the APIC and not need to write
> to the device's MSI register at all.

Ok...but that still means it's got only one target (either one CPU
or a group of CPUs).

> What I've implemented for x86-64 can target any mask of CPUs that are
> in the same interrupt domain.  My machine only has one interrupt domain,
> so I can target the MSI to any subset of the CPUs.  They all move
> together, so you can't target a different subset of CPUs for different
> MSIs on the same device.

*nod* - that's what I meant.

thanks,
grant
