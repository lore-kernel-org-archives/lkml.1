Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbXL1F26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbXL1F26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 00:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbXL1F2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 00:28:48 -0500
Received: from gate.crashing.org ([63.228.1.57]:55078 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbXL1F2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 00:28:48 -0500
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
In-Reply-To: <alpine.LFD.0.9999.0712271328010.21557@woody.linux-foundation.org>
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no>
	 <fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no>
	 <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no> <4773EBB4.2020805@shaw.ca>
	 <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org>
	 <477414C9.3040906@myri.com>
	 <alpine.LFD.0.9999.0712271328010.21557@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 28 Dec 2007 16:27:26 +1100
Message-Id: <1198819646.7209.23.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-27 at 13:37 -0800, Linus Torvalds wrote:
> 
> > Does anybody knows what was the original rational to call
> > pci_enable_crs() by default?
> 
> .. another good question. I don't think anybody expected it to be
> broken, 
> but if this turns out to be the thing that triggers it, I think we
> should 
> disable CRS by default.

Some sane archs need CRS and do a lot of HW.. However, just testing for
vendor ID being 0x0001 instead of testing all bits might be a useable
workaround.

> The code doesn't actually do what CRS is supposed to help with (ie go
> on 
> to probe another device and then come back to the slow one later), so 
> right now it's pretty much useless *anyway*. 

