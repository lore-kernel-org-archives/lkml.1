Return-Path: <linux-kernel-owner+w=401wt.eu-S936876AbYGCHPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936876AbYGCHPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbYGCG7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:59:04 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:33252 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbYGCGot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 02:44:49 -0400
Subject: Re: Multiple MSI
From: Michael Ellerman <michaele@au1.ibm.com>
Reply-To: michaele@au1.ibm.com
To: benh@kernel.crashing.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Dan Williams <dan.j.williams@intel.com>, Martine.Silbermann@hp.com,
       linux-kernel@vger.kernel.org, Michael Ellerman <michaele@au1.ibm.com>
In-Reply-To: <1215060119.21182.77.camel@pasglop>
References: <20080703024445.GA14894@parisc-linux.org>
	 <1215055469.21182.70.camel@pasglop>
	 <20080703035910.GB14894@parisc-linux.org>
	 <1215060119.21182.77.camel@pasglop>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 16:44:44 +1000
Message-Id: <1215067484.17950.35.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 14:41 +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2008-07-02 at 21:59 -0600, Matthew Wilcox wrote:
> > 
> > 
> > This is true and worth considering carefully.  Are IRQ numbers a scarce
> > resource on PowerPC?  They are considerably less scarce than interrupt
> > vectors are on x86-64.  How hard is it to make IRQ numbers an abundent
> > resource?  Is it simply a question of increasing NR_IRQS?
> 
> Yes, indeed, they aren't really scarce... actually less than the
> underlying HW vectors in most cases, so it isn't a big issue to add some
> kind of constraint to the allocator.

Not scarce, but increasing NR_IRQS makes some static arrays bigger,
which is not so nice.

> > By the way, would people be interested in changing the MSI-X API to get
> > rid of the msix_entry array?  If allocating consecutive IRQs isn't a
> > problem, then we could switch the MSI-X code to use consecutive IRQs.
> 
> It would make a lot of code simpler...

It's not a pretty API to be sure. I thought drivers needed the
flexibility of being able to specify non-contiguous ranges. In practice
it looks like only s2io is doing anything different.

cheers

-- 
Michael Ellerman
OzLabs, IBM Australia Development Lab

email: michaele@au.ibm.com
stime: ellerman@au1.ibm.com
notes: Michael Ellerman/Australia/IBM
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

