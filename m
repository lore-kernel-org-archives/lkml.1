Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbXL1Fif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbXL1Fif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 00:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbXL1Fi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 00:38:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38072 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056AbXL1Fi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 00:38:26 -0500
Date: Thu, 27 Dec 2007 21:37:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Loic Prylli <loic@myri.com>, Robert Hancock <hancockr@shaw.ca>,
       Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>,
       Kai Ruhnau <kai@tragetaschen.dyndns.org>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
In-Reply-To: <1198819790.7209.27.camel@pasglop>
Message-ID: <alpine.LFD.0.9999.0712272135270.21557@woody.linux-foundation.org>
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no>  <fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no>  <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no> <4773EBB4.2020805@shaw.ca>  <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org>  <477414C9.3040906@myri.com>
  <alpine.LFD.0.9999.0712271328010.21557@woody.linux-foundation.org> <1198819790.7209.27.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Dec 2007, Benjamin Herrenschmidt wrote:
> 
> I have embedded boards where proper CRS operations is critical since the
> kernel brings the PCIe link up itself, and thus is likely to hit devices
> still in the middle of CRS.

.. but that's perfectly fine. A PCI-E bridge will certainly retry it in 
hardware (or it isn't a PCI-E bridge!).

The CRS bit in question is purely the *software*visible* bit - ie whether 
the OS gets told about the delay or not. As long as the OS then just 
retries the same device, enabling CRS SV is pointless.

So I'm going to disable that thing. If there is some _other_ PCI-E bridge 
that is simply buggy, and cannot handle the hw retry itself or is just 
otherwise dodgy, we can have a white-list for cases where it really needs 
to be done, but the current code is just bogus.

			Linus
