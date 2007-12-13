Return-Path: <linux-kernel-owner+w=401wt.eu-S934324AbXLMXKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934324AbXLMXKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 18:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764163AbXLMXKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:10:07 -0500
Received: from gate.crashing.org ([63.228.1.57]:33041 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762708AbXLMXKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:10:05 -0500
Subject: Re: Possible issue with dangling PCI BARs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jesse Barnes <jesse.barnes@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Robert Hancock <hancockr@shaw.ca>, linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20071214001239.B21652@jurassic.park.msu.ru>
References: <fa.YfTvVN5C3e6zwXPW5biWgeZ9XXc@ifi.uio.no>
	 <1197544621.15741.132.camel@pasglop> <1197544820.15741.137.camel@pasglop>
	 <200712131204.18227.jesse.barnes@intel.com>
	 <1197579066.15741.167.camel@pasglop>
	 <20071214001239.B21652@jurassic.park.msu.ru>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 10:09:28 +1100
Message-Id: <1197587368.15741.187.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-14 at 00:12 +0300, Ivan Kokshaysky wrote:
> On Fri, Dec 14, 2007 at 07:51:06AM +1100, Benjamin Herrenschmidt wrote:
> > If the device is behind a P2P bridge and the BIOS has set the windows of
> > that bridge so tightly that there is no room to allocate the MMIO BAR,
> > then a full disable/full enable would fail on a device that would
> > otherwise work using only PIO.
> 
> It won't be a problem with separate io/mmio enable.
> 
> > However, I'd be curious to see that happening in practice :-)
> > 
> > But I think it's fair enough to do an IO only / MEM only approach. I've
> > seen cases where IO is just not useable because of other constraints and
> > so I expect the MEM-only case to be more common, especially on non-x86.
> 
> Everybody wants MEM if it's available - it's just faster :-)
> So I guess a common case will be

 .../...

Right, I'm going to cook up some patch as time permit, maybe not before
next week tho.

Cheers,
Ben.


