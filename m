Return-Path: <linux-kernel-owner+w=401wt.eu-S1761347AbXEOFxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761347AbXEOFxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 01:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758196AbXEOFxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 01:53:14 -0400
Received: from verein.lst.de ([213.95.11.210]:50629 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757956AbXEOFxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 01:53:13 -0400
Date: Tue, 15 May 2007 07:52:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: Olof Johansson <olof@lixom.net>
Cc: Christoph Hellwig <hch@lst.de>, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@brodo.de>
Subject: Re: [PATCH] pcmcia: ppc64 needs 64-bit ioaddr_t
Message-ID: <20070515055256.GA18672@lst.de>
References: <20070512143105.GA12890@lixom.net> <20070513214608.GA26187@lst.de> <20070514225731.GA4191@lixom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514225731.GA4191@lixom.net>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 05:57:31PM -0500, Olof Johansson wrote:
> On Sun, May 13, 2007 at 11:46:08PM +0200, Christoph Hellwig wrote:
> > On Sat, May 12, 2007 at 09:31:05AM -0500, Olof Johansson wrote:
> > > ppc64 really needs ioaddr_t to be 64-bit, since I/O addresses really
> > > are MMIO addresses, and remapped to a high range.
> > > 
> > > While the type is exported to userspace, there hasn't been any platforms
> > > with PCMCIA on 64-bit powerpc until now, so changing it won't regress
> > > any existing users.
> > 
> > In fact the only use of the type should be in the obsolete ioctl-based user
> > interface.  So instead of changing the size of the type you should
> > 
> >  a) make sure you're not using cardmgr
> >  b) fix up those places that still use ioaddr_t where they shouldn't
> >     and switch the to kio_addr_t (why not just unsigned long like all
> >     other busses?) 
> 
> I just noticed that feature-removal-schedule.txt says November 2005 for
> the removal of the pcmcia ioctl's, but they're still there. I'm missing
> the history here, any reason they weren't removed yet?

See the discussions on lkml.  It seems like people haven't really
noticed the deprecation messages and are still using it.  Still not
a good reason to use them on a new port (at least new in terms of
pcmcia support)
