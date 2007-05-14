Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbXENWyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbXENWyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbXENWyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:54:31 -0400
Received: from lixom.net ([66.141.50.11]:39742 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbXENWya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:54:30 -0400
Date: Mon, 14 May 2007 17:57:31 -0500
To: Christoph Hellwig <hch@lst.de>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@brodo.de>
Subject: Re: [PATCH] pcmcia: ppc64 needs 64-bit ioaddr_t
Message-ID: <20070514225731.GA4191@lixom.net>
References: <20070512143105.GA12890@lixom.net> <20070513214608.GA26187@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070513214608.GA26187@lst.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 11:46:08PM +0200, Christoph Hellwig wrote:
> On Sat, May 12, 2007 at 09:31:05AM -0500, Olof Johansson wrote:
> > ppc64 really needs ioaddr_t to be 64-bit, since I/O addresses really
> > are MMIO addresses, and remapped to a high range.
> > 
> > While the type is exported to userspace, there hasn't been any platforms
> > with PCMCIA on 64-bit powerpc until now, so changing it won't regress
> > any existing users.
> 
> In fact the only use of the type should be in the obsolete ioctl-based user
> interface.  So instead of changing the size of the type you should
> 
>  a) make sure you're not using cardmgr
>  b) fix up those places that still use ioaddr_t where they shouldn't
>     and switch the to kio_addr_t (why not just unsigned long like all
>     other busses?) 

I just noticed that feature-removal-schedule.txt says November 2005 for
the removal of the pcmcia ioctl's, but they're still there. I'm missing
the history here, any reason they weren't removed yet?


-Olof
