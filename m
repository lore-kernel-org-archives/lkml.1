Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbZHFKSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbZHFKSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 06:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbZHFKSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 06:18:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60830 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbZHFKSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 06:18:22 -0400
Date: Thu, 6 Aug 2009 13:17:02 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-kernel@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/7] AlacrityVM guest drivers Reply-To:
Message-ID: <20090806101702.GA10605@redhat.com>
References: <20090803171030.17268.26962.stgit@dev.haskins.net> <20090806081955.GA9752@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806081955.GA9752@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 11:19:56AM +0300, Michael S. Tsirkin wrote:
> On Mon, Aug 03, 2009 at 01:17:30PM -0400, Gregory Haskins wrote:
> > (Applies to v2.6.31-rc5, proposed for linux-next after review is complete)
> 
> These are guest drivers, right? Merging the guest first means relying on
> kernel interface from an out of tree driver, which well might change
> before it goes in.  Would it make more sense to start merging with the
> host side of the project?
> 
> > This series implements the guest-side drivers for accelerated IO
> > when running on top of the AlacrityVM hypervisor, the details of
> > which you can find here:
> > 
> > http://developer.novell.com/wiki/index.php/AlacrityVM
> 
> Since AlacrityVM is kvm based, Cc kvm@vger.kernel.org.
> 
> > This series includes the basic plumbing, as well as the driver for
> > accelerated 802.x (ethernet) networking.
> 
> The graphs comparing virtio with vbus look interesting.
> However, they do not compare apples to apples, do they?
> These compare userspace virtio with kernel vbus, where for
> apples to apples comparison one would need to compare
> kernel virtio with kernel vbus. Right?

Or userspace virtio with userspace vbus.

> > Regards,
> > -Greg
> > 
> > ---
> > 
> > Gregory Haskins (7):
> >       venet: add scatter-gather/GSO support
> >       net: Add vbus_enet driver
> >       ioq: add driver-side vbus helpers
> >       vbus-proxy: add a pci-to-vbus bridge
> >       vbus: add a "vbus-proxy" bus model for vbus_driver objects
> >       ioq: Add basic definitions for a shared-memory, lockless queue
> >       shm-signal: shared-memory signals
> > 
> > 
> >  arch/x86/Kconfig            |    2 
> >  drivers/Makefile            |    1 
> >  drivers/net/Kconfig         |   14 +
> >  drivers/net/Makefile        |    1 
> >  drivers/net/vbus-enet.c     |  899 +++++++++++++++++++++++++++++++++++++++++++
> >  drivers/vbus/Kconfig        |   24 +
> >  drivers/vbus/Makefile       |    6 
> >  drivers/vbus/bus-proxy.c    |  216 ++++++++++
> >  drivers/vbus/pci-bridge.c   |  824 +++++++++++++++++++++++++++++++++++++++
> >  include/linux/Kbuild        |    4 
> >  include/linux/ioq.h         |  415 ++++++++++++++++++++
> >  include/linux/shm_signal.h  |  189 +++++++++
> >  include/linux/vbus_driver.h |   80 ++++
> >  include/linux/vbus_pci.h    |  127 ++++++
> >  include/linux/venet.h       |   84 ++++
> >  lib/Kconfig                 |   21 +
> >  lib/Makefile                |    2 
> >  lib/ioq.c                   |  294 ++++++++++++++
> >  lib/shm_signal.c            |  192 +++++++++
> >  19 files changed, 3395 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/net/vbus-enet.c
> >  create mode 100644 drivers/vbus/Kconfig
> >  create mode 100644 drivers/vbus/Makefile
> >  create mode 100644 drivers/vbus/bus-proxy.c
> >  create mode 100644 drivers/vbus/pci-bridge.c
> >  create mode 100644 include/linux/ioq.h
> >  create mode 100644 include/linux/shm_signal.h
> >  create mode 100644 include/linux/vbus_driver.h
> >  create mode 100644 include/linux/vbus_pci.h
> >  create mode 100644 include/linux/venet.h
> >  create mode 100644 lib/ioq.c
> >  create mode 100644 lib/shm_signal.c
> > 
> > -- 
> > Signature
> > --
> > To unsubscribe from this list: send the line "unsubscribe netdev" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
