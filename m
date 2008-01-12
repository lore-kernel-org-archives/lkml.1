Return-Path: <linux-kernel-owner+w=401wt.eu-S1763313AbYALAmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763313AbYALAmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 19:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762569AbYALAmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 19:42:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:30162 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758743AbYALAmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 19:42:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,274,1196668800"; 
   d="scan'208";a="364642014"
From: Jesse Barnes <jesse.barnes@intel.com>
To: linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver opt-in
Date: Fri, 11 Jan 2008 16:17:53 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>
References: <20080111194524.GA17170@suse.de> <20080111213803.GS18741@parisc-linux.org> <20080111235856.GA16079@jurassic.park.msu.ru>
In-Reply-To: <20080111235856.GA16079@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801111617.55623.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 11, 2008 3:58 Ivan Kokshaysky wrote:
> On Fri, Jan 11, 2008 at 02:38:03PM -0700, Matthew Wilcox wrote:
> > On Fri, Jan 11, 2008 at 01:28:30PM -0800, Linus Torvalds wrote:
> > > Hmm. Were all those reports root-caused to just that BAR probing?
> > > If so, we may be in better shape than I worried.
> >
> > I believe so.
>
> Ditto.
>
> One typical problem is that on "Intel(r) 3 Series Experss Chipset
> Family" MMCONFIG probing of the BAR #2 (frame buffer address) of
> integrated graphics device locks up the machine (depending on BIOS
> settings, of course). This happens because the frame buffer of IGD
> has higher decode priority than MMCONFIG range, as stated in Intel
> docs...

Yeah, I'm only aware of 3:
  - the BAR overlapping w/MMCONFIG problem described above
  - ATI chipset config space retry bug
  - VIA (?) chipset host bridges don't respond well to having decode
    disabled (they stop decoding RAM addresses as well)

That's it afaik, so I've never really known where Linus' paranoia comes 
from.  OTOH I haven't been too keen to challenge it either; MMCONFIG 
space is only just beginning to be tested widely with the deployment of 
Vista, so we'll doubtless see more problems on older chipsets if we 
enable it by default.

Jesse
