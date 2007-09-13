Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbXIMHbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbXIMHbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 03:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbXIMHbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 03:31:43 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34390 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbXIMHbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 03:31:42 -0400
Date: Thu, 13 Sep 2007 01:31:41 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
Message-ID: <20070913073140.GA17367@parisc-linux.org>
References: <1189664467.17835.1.camel@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189664467.17835.1.camel@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 02:21:07PM +0800, Shaohua Li wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=8833
> We write 0xffffffff to BARs to detect BAR size, this will change BAR
> base to 0xfxxxxxx depends on BAR size. In the bug, PCI MCFG base address
> is 0xf4000000. One PCI device (gfx) has a 256M BAR, the detection code
> will temprarily change it to 0xf0000000, so conflict with MCFG decode
> range. Later memory based config space read/write address is decoded by
> both MCH and gfx and cause a hang. This patch disables resource decode
> in BAR size detection to avoid resource conflict. 

You missed the part where we have to avoid doing this for host bridges ...

http://marc.info/?l=linux-kernel&m=118809338631160&w=2

(I believe it's now queued in Greg's tree, and possibly Andrew's tree
too)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
