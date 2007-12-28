Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbXL1GIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbXL1GIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 01:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbXL1GIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 01:08:06 -0500
Received: from gate.crashing.org ([63.228.1.57]:56032 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbXL1GIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 01:08:04 -0500
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
	opt-in
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Loic Prylli <loic@myri.com>, Robert Hancock <hancockr@shaw.ca>,
       Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>,
       Kai Ruhnau <kai@tragetaschen.dyndns.org>
In-Reply-To: <alpine.LFD.0.9999.0712272135270.21557@woody.linux-foundation.org>
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no>
	 <fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no>
	 <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no> <4773EBB4.2020805@shaw.ca>
	 <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org>
	 <477414C9.3040906@myri.com>
	 <alpine.LFD.0.9999.0712271328010.21557@woody.linux-foundation.org>
	 <1198819790.7209.27.camel@pasglop>
	 <alpine.LFD.0.9999.0712272135270.21557@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 28 Dec 2007 17:06:50 +1100
Message-Id: <1198822010.7209.32.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-27 at 21:37 -0800, Linus Torvalds wrote:
> 
> On Fri, 28 Dec 2007, Benjamin Herrenschmidt wrote:
> > 
> > I have embedded boards where proper CRS operations is critical since the
> > kernel brings the PCIe link up itself, and thus is likely to hit devices
> > still in the middle of CRS.
> 
> .. but that's perfectly fine. A PCI-E bridge will certainly retry it in 
> hardware (or it isn't a PCI-E bridge!).

Only a handful of times in many bridges I've seen.
 
> So I'm going to disable that thing. If there is some _other_ PCI-E bridge 
> that is simply buggy, and cannot handle the hw retry itself or is just 
> otherwise dodgy, we can have a white-list for cases where it really needs 
> to be done, but the current code is just bogus.

If you disable it, then isn't there also a problem with PCIE->PCI-X
bridge which will stop issuing CRS when they should ? (not sure here, I
may be a bit confused).

Ben.


