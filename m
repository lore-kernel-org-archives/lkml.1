Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbXL0VMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbXL0VMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 16:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbXL0VMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 16:12:21 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:2000 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752032AbXL0VMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 16:12:20 -0500
Message-ID: <477414C9.3040906@myri.com>
Date: Thu, 27 Dec 2007 16:10:33 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no> <fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no> <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no> <4773EBB4.2020805@shaw.ca> <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2007 1:58 PM, Linus Torvalds wrote:
>
> There was a thread called "PCI vendor id == 1 regression?" (Kai Ruhnau was 
> the main reporter for that one). But looking back, it seems that one 
> didn't hit the kernel mailing list, so I guess google cannot pick it up. I 
> can forward all the emails if you want, but quite frankly, you don't 
> really want to. It boils down to:
>
> Stephen Hemminger:
>   "There have been two reports with different hardware of the PCI vendor
>    id of 0001 showing up. I got a report on sky2, and Francois saw similar
>    problem on r8169.
>    In one case, it happened only with 2.6.23 kernel, the correct id was
>    returned by older kernels.
>
>    This is a heads up, there may be a PCI problem. Or just
>    some users smoking strange fall leaves."
>
> And then one of the reporters:
>
>   "Good kernel:
>
>    02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E Gigabit Ethernet Controller (rev 12)
> 	00: ab 11 64 43 07 00 10 00 12 00 00 02 01 00 00 00
>
>    Bad kernel:
>
>    02:00.0 Ethernet controller: Unknown device 0001:4364 (rev 12)
> 	00: 01 00 64 43 07 00 10 00 12 00 00 02 01 00 00 00"
>   





The root pcie port implementation is obviously buggy. But did we confirm
whether that hardware bug might be partly related to
"configuration-retry-status" pcie-root handling as introduced/described in:



http://marc.info/?l=linux-kernel&m=110541914926842&w=2


Does the 0001 vendor-id still shows up if pci_enable_crs() has never
been called?


Does anybody knows what was the original rational to call
pci_enable_crs() by default?


Loic

