Return-Path: <linux-kernel-owner+w=401wt.eu-S1030783AbXAZGSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030783AbXAZGSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 01:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030784AbXAZGSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 01:18:37 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47763 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030783AbXAZGSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 01:18:36 -0500
Date: Thu, 25 Jan 2007 22:18:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Alan <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
 controllers
In-Reply-To: <Pine.LNX.4.64.0701252125280.25027@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0701252208050.25027@woody.linux-foundation.org>
References: <20070125150905.652f9ce2@localhost.localdomain> 
 <1169741658.3593.98.camel@shinybook.infradead.org> 
 <20070125172739.0c990a9a@localhost.localdomain> 
 <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org> 
 <1169770985.3593.146.camel@shinybook.infradead.org> 
 <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org> 
 <1169778239.3593.195.camel@shinybook.infradead.org> 
 <Pine.LNX.4.64.0701251832040.25027@woody.linux-foundation.org> 
 <1169782107.3593.219.camel@shinybook.infradead.org> 
 <Pine.LNX.4.64.0701251932250.25027@woody.linux-foundation.org> 
 <1169785150.3593.231.camel@shinybook.infradead.org> 
 <Pine.LNX.4.64.0701252029570.25027@woody.linux-foundation.org>
 <1169788181.3593.250.camel@shinybook.infradead.org>
 <Pine.LNX.4.64.0701252125280.25027@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Jan 2007, Linus Torvalds wrote:
> 
> Have you noticed that the resource-allocation code _already_ never returns 
> zero on sparc64?

Btw, that was a rhetorical question, and I'm not actually sure what the 
heck sparc64 will _really_ do ;)

I picked sparc64 as an example, because I _think_ that sparc64 actually is 
an example of an architecture that sets up a separate root resource for 
each PCI domain, and they are actually set up so that the ioport regions 
are literally offset to match the hardware bases (and there are several 
different kinds of PCI domain controllers that sparc supports, so those 
bases will depend on that too).

So on sparc64, "ioport_resource" really is just a container for the actual 
per-domain resource buckets that the hardware (within that domain) will 
then do the resource allocation from. Afaik.

But you should actaully verify that with somebody like Davem if you 
_really_ care.  I cc'd him in case he wants to pipe up and perhaps prove 
me wrong.


			Linus
