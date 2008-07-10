Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbYGJAzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbYGJAzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 20:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYGJAzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 20:55:24 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:49774 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbYGJAzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 20:55:23 -0400
Subject: Re: Multiple MSI
From: Michael Ellerman <michaele@au1.ibm.com>
Reply-To: michaele@au1.ibm.com
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Dan Williams <dan.j.williams@intel.com>, Martine.Silbermann@hp.com,
       linux-kernel@vger.kernel.org, Michael Ellerman <michaele@au1.ibm.com>
In-Reply-To: <20080707161703.GB7521@colo.lackof.org>
References: <20080703024445.GA14894@parisc-linux.org>
	 <1215055469.21182.70.camel@pasglop> <20080707161703.GB7521@colo.lackof.org>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 10:55:17 +1000
Message-Id: <1215651317.13950.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-07 at 10:17 -0600, Grant Grundler wrote:
> On Thu, Jul 03, 2008 at 01:24:29PM +1000, Benjamin Herrenschmidt wrote:
> ...
> > > Next, MSI requires that you assign a block of interrupts that is a power
> > > of two in size (between 2^0 and 2^5), and aligned to at least that power
> > > of two.
> ...
> > > One thing I do want to be clear in the API is that the driver can ask
> > > for any number of irqs, the pci layer will round up to the next power of
> > > two if necessary.
> > 
> > Well, that's where I'm not happy. The API shouldn't expose the
> > "power-of-two" thing. The numbers shown to drivers aren't in the same
> > space as the source numbers as seen by the HW on many architectures and
> > thus don't need to have the same constraints.
> 
> The drivers have to deal with the limitations of the HW spec.
> In this case it means they have to know they are getting power of 2
> number of interrupts. I think exposing this in the API is a requirement
> and not optional.

I don't think it's quite that strong. If a driver asked for 6 interrupts
the MSI code could setup 8 and have 2 just hooked to nothing. I'm not
sure that's a good idea, but it's possible.

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

