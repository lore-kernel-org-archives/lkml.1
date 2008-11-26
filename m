Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbYKZFI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbYKZFI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 00:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbYKZFIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 00:08:04 -0500
Received: from sous-sol.org ([216.99.217.87]:60327 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752644AbYKZFIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 00:08:01 -0500
Date: Tue, 25 Nov 2008 21:07:58 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Greg KH <greg@kroah.com>
Cc: Chris Wright <chrisw@sous-sol.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, allen.m.kay@intel.com, jun.nakajima@intel.com
Subject: Re: [PATCH 2/2] PCI: pci-stub module to reserve pci device
Message-ID: <20081126050758.GA22700@sequoia.sous-sol.org>
References: <20081126033610.GB19881@sequoia.sous-sol.org> <20081126033839.GC19881@sequoia.sous-sol.org> <20081126041946.GA18816@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126041946.GA18816@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (greg@kroah.com) wrote:
> On Tue, Nov 25, 2008 at 07:38:39PM -0800, Chris Wright wrote:
> > When doing device assignment with KVM there's currently nothing to
> > protect the device from having a driver in the host as well as the guest.
> > This trivial module just binds the pci device on the host to a stub
> > driver so that a real host driver can't bind to the device.  It has no
> > pci id table, it supports only dynamic ids.
> > 
> >  # echo "8086 10f5" > /sys/bus/pci/drivers/pci-stub/new_id
> >  # echo -n 0000:00:19.0 > /sys/bus/pci/drivers/e1000e/unbind
> >  # echo -n 0000:00:19.0 > /sys/bus/pci/drivers/pci-stub/bind
> >  # ls -l /sys/bus/pci/devices/0000:00:19.0/driver
> >  lrwxrwxrwx 1 root root 0 2008-11-25 19:10 /sys/bus/pci/devices/0000:00:19.0/driver -> ../../../bus/pci/drivers/pci-stub
> 
> You might want to put this somewhere in the .c or documentation files
> somewhere as well.

OK, I'll add this to the .c file for now.

> > Cc: "Kay, Allen M" <allen.m.kay@intel.com>
> > Cc: "Nakajima, Jun" <jun.nakajima@intel.com>
> > Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> > ---
> >  drivers/pci/Kconfig    |    9 +++++++++
> >  drivers/pci/Makefile   |    2 ++
> >  drivers/pci/pci-stub.c |   38 ++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 49 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/pci/pci-stub.c
> > 
> > diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> > index e1ca425..f6183df 100644
> > --- a/drivers/pci/Kconfig
> > +++ b/drivers/pci/Kconfig
> > @@ -42,6 +42,15 @@ config PCI_DEBUG
> >  
> >  	  When in doubt, say N.
> >  
> > +config PCI_STUB
> > +	tristate "PCI Stub driver"
> > +	depends on PCI
> > +	help
> > +	  Say Y or M here if you want be able to reserve a PCI device
> > +	  when it is going to be assigned to a guest.
> 
> "guest operating system"?  Otherwise, just "guest" doesn't mean much
> here in this context.

fixed

> Other than that minor thing, looks great.
> 
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,
-chris
