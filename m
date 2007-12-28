Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbXL1Fdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbXL1Fdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 00:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbXL1Fd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 00:33:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33934 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750762AbXL1Fd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 00:33:26 -0500
Date: Thu, 27 Dec 2007 21:32:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Daniel Barkalow <barkalow@iabervon.org>
cc: Kai Ruhnau <kai@tragetaschen.dyndns.org>, Loic Prylli <loic@myri.com>,
       Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
In-Reply-To: <alpine.LNX.1.00.0712272204520.13593@iabervon.org>
Message-ID: <alpine.LFD.0.9999.0712272129290.21557@woody.linux-foundation.org>
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no> <fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no> <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no> <4773EBB4.2020805@shaw.ca> <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org> <477414C9.3040906@myri.com>
 <alpine.LFD.0.9999.0712271328010.21557@woody.linux-foundation.org> <alpine.LFD.0.9999.0712271338280.21557@woody.linux-foundation.org> <47742498.1060900@tragetaschen.dyndns.org> <alpine.LNX.1.00.0712272204520.13593@iabervon.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 Dec 2007, Daniel Barkalow wrote:
> 
> I'd actually bet that the hardware bug is actually that any device that 
> gives a CRS response the first time will have its Vendor ID appear as 0001 
> on subsequent mmconfig accesses, which means that it's actually a bus 
> quirk that probably only affects mmconfig access to something in the 
> conf1-visible space. The only per-device aspect would be that it uses CRS 
> (possibly correctly), and that doesn't mean that mmconfig won't be safe in 
> general for the device, or even that it won't be necessary. Actually, we 
> already know that per-driver enabling mmconfig is broken: sky2 is one that 
> wants to opt in but there are also reports of the Vendor ID 0001 bug with 
> it.

Actually, having it be a per-device thing would have fixed this particular 
problem, if only because the device probing would have been done without 
MMCONFIG (thus avoiding the bug), and then after it has been probed, it 
wouldn't have mattered if the driver enabled MMCONFIG for the device, 
since it would now have the right ID in "struct pci_device".

Sure, subsequent "lspci" users would still be confused, but the kernel 
itself would never have noticed anything strange.

Of course, just doing *all* initial probing without MMCONFIG would also 
have fixed it, which is another thing I advocate (regardless of any 
per-device setting).

		Linus
