Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbXIQJU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbXIQJU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbXIQJUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 05:20:07 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:54759 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbXIQJUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 05:20:04 -0400
Date: Mon, 17 Sep 2007 13:20:05 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Greg KH <gregkh@suse.de>, Matthew Wilcox <matthew@wil.cx>,
       Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
Message-ID: <20070917132005.A21399@jurassic.park.msu.ru>
References: <fa.13eJumylqINOxOaoEj9cthw0d0M@ifi.uio.no> <fa.tAIuIM02CoL+ixB11n9Fmcqyz9M@ifi.uio.no> <fa.pxFYhTaUz2NVN7Vux7b5xVRrKTw@ifi.uio.no> <46EA00DA.6010704@shaw.ca> <20070914151401.A5586@jurassic.park.msu.ru> <46EA9B23.7030709@shaw.ca> <20070914192913.A6668@jurassic.park.msu.ru> <46EB1F16.8060209@shaw.ca> <20070916151355.A18508@jurassic.park.msu.ru> <46ED692B.3010004@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <46ED692B.3010004@shaw.ca>; from hancockr@shaw.ca on Sun, Sep 16, 2007 at 11:34:35AM -0600
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2007 at 11:34:35AM -0600, Robert Hancock wrote:
> > The most interesting fact there is that windows *does not* clear
> > PCI_COMMAND_MEMORY bits during PCI bus enumeration, so BIOS writers
> > have to rely on that. Yet another reason why your patch is unsafe.
> 
> Windows 98 doesn't, it says. That doesn't say anything about what newer 
> versions of Windows are doing (like Vista, which is the first to 
> actually use MMCONFIG).

But we're not going to drop support for hardware "designed for Windows 98",
aren't we?

> Check the code. We have a quirk to handle this, in 
> drivers/usb/host/pci-quirks.c

It doesn't help. It's a "final" fixup, so it runs much later than BAR sizing.

Ivan.
