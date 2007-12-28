Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbXL1FcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbXL1FcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 00:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbXL1FcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 00:32:08 -0500
Received: from gate.crashing.org ([63.228.1.57]:55125 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbXL1FcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 00:32:05 -0500
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
	opt-in
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Kai Ruhnau <kai@tragetaschen.dyndns.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Loic Prylli <loic@myri.com>, Robert Hancock <hancockr@shaw.ca>,
       Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
In-Reply-To: <47742498.1060900@tragetaschen.dyndns.org>
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no>
	 <fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no>
	 <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no> <4773EBB4.2020805@shaw.ca>
	 <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org>
	 <477414C9.3040906@myri.com>
	 <alpine.LFD.0.9999.0712271328010.21557@woody.linux-foundation.org>
	 <alpine.LFD.0.9999.0712271338280.21557@woody.linux-foundation.org>
	 <47742498.1060900@tragetaschen.dyndns.org>
Content-Type: text/plain
Date: Fri, 28 Dec 2007 16:31:22 +1100
Message-Id: <1198819882.7209.29.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-27 at 23:18 +0100, Kai Ruhnau wrote:

> That one did not work out so well.
> I reenabled the call to pci_enable_crs() and changed the line as above.
> That resulted in two timeouts (from dmesg):
> 
> [....]
> ACPI: Interpreter enabled
> ACPI: (supports S0 S3 S4 S5)
> ACPI: Using IOACPI for interrupt routing
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> Device 0000:01:00.0 not responding
> Device 0000:02:00.0 not responding
> [....]
> 
> Then, the kernel boots up normally except of graphics and network card
> not showing up at all in lspci.

Could be that DRS is totally broken on those bridges. Might need some
per bridge quirks to disable CRS. But don't do that by default please,
other people need it.

Cheers,
Ben.


