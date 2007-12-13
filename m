Return-Path: <linux-kernel-owner+w=401wt.eu-S932700AbXLMUwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbXLMUwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932343AbXLMUvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:51:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:44750 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180AbXLMUvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:51:36 -0500
Subject: Re: Possible issue with dangling PCI BARs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Robert Hancock <hancockr@shaw.ca>, linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <200712131204.18227.jesse.barnes@intel.com>
References: <fa.YfTvVN5C3e6zwXPW5biWgeZ9XXc@ifi.uio.no>
	 <1197544621.15741.132.camel@pasglop> <1197544820.15741.137.camel@pasglop>
	 <200712131204.18227.jesse.barnes@intel.com>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 07:51:06 +1100
Message-Id: <1197579066.15741.167.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-13 at 12:04 -0800, Jesse Barnes wrote:
> 
> Yeah, that seems like a reasonable compromise.  Though in practice
> I'd 
> expect the full disable decode approach to work fairly well too.  I 
> mean, if we really end up failing to allocate space for the device
> with 
> the root drive on it, there are probably bigger issues than just 
> failing to get a few bytes of I/O space for it...
> 

The really bad scenario would be something like the Sil680 that Alan
talked about setup by a BIOS that "knows" about the unused BAR when
MMIO_EN is not set.

If the device is behind a P2P bridge and the BIOS has set the windows of
that bridge so tightly that there is no room to allocate the MMIO BAR,
then a full disable/full enable would fail on a device that would
otherwise work using only PIO.

However, I'd be curious to see that happening in practice :-)

But I think it's fair enough to do an IO only / MEM only approach. I've
seen cases where IO is just not useable because of other constraints and
so I expect the MEM-only case to be more common, especially on non-x86.

Ben.


