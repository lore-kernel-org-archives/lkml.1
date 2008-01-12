Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbYALPL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbYALPL7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 10:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbYALPLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 10:11:52 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:44173 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbYALPLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 10:11:52 -0500
Date: Sat, 12 Jan 2008 18:12:12 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Kumar Gala <galak@kernel.crashing.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: PCI Failed to allocate mem for PCI ROM
Message-ID: <20080112151212.GB19279@jurassic.park.msu.ru>
References: <1B75C5A8-E512-40CB-A6F3-351640701D0D@kernel.crashing.org> <20080111175039.GB7916@kroah.com> <E1025115-6BE2-46B6-8416-A5ADD506E2ED@kernel.crashing.org> <20080112072705.GB7234@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112072705.GB7234@colo.lackof.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 12:27:05AM -0700, Grant Grundler wrote:
> Looking at setup-bus.c:pci_bridge_check_ranges(), I'm concluding that:
> [7] is IO Range.
> [8] is MMIO
> [9] is Prefetchable MMIO
> [10] no clue...maybe used by host PCI bus controllers.

#10 is for cardbus bridges, IIRC.

> 0x100000 is 1MB and would be the minimum MMIO range that can be allocated.
> So that looks right too. Probably need to find out what is allocating
> 0xe0000000 instead.

I believe that the setup-bus code just tried to allocate 1M ROM of some
device using prefetchable window of the bridge 0000:00:00.0. That failed,
probably because there is no MEM space left on the root bus, which is
perfectly OK. Then, the ROM might be successfully allocated in the
non-prefetchable MMIO space.

So, I don't see any problem in this situation. The only thing I could
suggest is to lower the log level in that message from KERN_ERR to
KERN_WARNING...

Ivan.
