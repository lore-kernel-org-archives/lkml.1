Return-Path: <linux-kernel-owner+w=401wt.eu-S1758550AbXLMJ34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550AbXLMJ34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 04:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXLMJ3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 04:29:47 -0500
Received: from gate.crashing.org ([63.228.1.57]:43519 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbXLMJ3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 04:29:45 -0500
Subject: Re: Possible issue with dangling PCI BARs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20071213121435.C21124@jurassic.park.msu.ru>
References: <fa.YfTvVN5C3e6zwXPW5biWgeZ9XXc@ifi.uio.no>
	 <fa.EhUqlM3V3y3HCcQkLBLSEKTJxBs@ifi.uio.no>
	 <fa.4FjaYKIciOijtgO+0DDrMkrLjv0@ifi.uio.no> <4760B37E.3010002@shaw.ca>
	 <1197523602.15741.114.camel@pasglop>
	 <20071213121435.C21124@jurassic.park.msu.ru>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 20:29:23 +1100
Message-Id: <1197538163.15741.124.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-13 at 12:14 +0300, Ivan Kokshaysky wrote:
> On Thu, Dec 13, 2007 at 04:26:42PM +1100, Benjamin Herrenschmidt wrote:
> > I can try to whip up some code tomorrow I suppose, though I'm always
> > afraid some dodgy x86 setup will blow up...
> 
> That scares me too, but something like pci_dangling_bar(dev, idx) with
> a default (for now) no-op implementation in asm-generic/pci.h should
> be safe...

Well, the code that detects collisions and "unsets" a resource is arch
in the first place, and so is pcibios_enable_device().

So I'm going to do a powerpc implementation & test it a bit with what I
have around, and then do an x86 since with my latest (pending for .25)
patches. powerpc PCI code is -very- similar to x86.

Cheers,
Ben.


