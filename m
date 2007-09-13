Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbXIMHjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbXIMHjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 03:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbXIMHjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 03:39:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:59321 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbXIMHjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 03:39:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,248,1186383600"; 
   d="scan'208";a="304727492"
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
From: Shaohua Li <shaohua.li@intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
In-Reply-To: <20070913073140.GA17367@parisc-linux.org>
References: <1189664467.17835.1.camel@sli10-conroe.sh.intel.com>
	 <20070913073140.GA17367@parisc-linux.org>
Content-Type: text/plain
Date: Thu, 13 Sep 2007 15:24:46 +0800
Message-Id: <1189668286.18361.3.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-13 at 01:31 -0600, Matthew Wilcox wrote:
> On Thu, Sep 13, 2007 at 02:21:07PM +0800, Shaohua Li wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=8833
> > We write 0xffffffff to BARs to detect BAR size, this will change BAR
> > base to 0xfxxxxxx depends on BAR size. In the bug, PCI MCFG base address
> > is 0xf4000000. One PCI device (gfx) has a 256M BAR, the detection code
> > will temprarily change it to 0xf0000000, so conflict with MCFG decode
> > range. Later memory based config space read/write address is decoded by
> > both MCH and gfx and cause a hang. This patch disables resource decode
> > in BAR size detection to avoid resource conflict. 
> 
> You missed the part where we have to avoid doing this for host bridges ...
> 
> http://marc.info/?l=linux-kernel&m=118809338631160&w=2
> 
> (I believe it's now queued in Greg's tree, and possibly Andrew's tree
> too)
Hmm, I don't know there is already a fix for this, so waste a whole
morning :(. yes, your patch looks better.

Thanks,
Shaohua
