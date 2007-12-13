Return-Path: <linux-kernel-owner+w=401wt.eu-S932989AbXLMVMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989AbXLMVMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbXLMVMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:12:30 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:48939 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbXLMVM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:12:29 -0500
Date: Fri, 14 Dec 2007 00:12:39 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jesse Barnes <jesse.barnes@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Robert Hancock <hancockr@shaw.ca>, linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Possible issue with dangling PCI BARs
Message-ID: <20071214001239.B21652@jurassic.park.msu.ru>
References: <fa.YfTvVN5C3e6zwXPW5biWgeZ9XXc@ifi.uio.no> <1197544621.15741.132.camel@pasglop> <1197544820.15741.137.camel@pasglop> <200712131204.18227.jesse.barnes@intel.com> <1197579066.15741.167.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <1197579066.15741.167.camel@pasglop>; from benh@kernel.crashing.org on Fri, Dec 14, 2007 at 07:51:06AM +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 07:51:06AM +1100, Benjamin Herrenschmidt wrote:
> If the device is behind a P2P bridge and the BIOS has set the windows of
> that bridge so tightly that there is no room to allocate the MMIO BAR,
> then a full disable/full enable would fail on a device that would
> otherwise work using only PIO.

It won't be a problem with separate io/mmio enable.

> However, I'd be curious to see that happening in practice :-)
> 
> But I think it's fair enough to do an IO only / MEM only approach. I've
> seen cases where IO is just not useable because of other constraints and
> so I expect the MEM-only case to be more common, especially on non-x86.

Everybody wants MEM if it's available - it's just faster :-)
So I guess a common case will be

	if (pci_enable_device_mmio(dev)) {
		/* failed, fallback to IO */
		if (pci_enable_device_io(dev))
			return -ENODEV;
		...
	}

Ivan.
