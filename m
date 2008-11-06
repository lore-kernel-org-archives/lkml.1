Return-Path: <linux-kernel-owner+w=401wt.eu-S1751342AbYKFShh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbYKFShh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 13:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYKFShV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 13:37:21 -0500
Received: from kroah.org ([198.145.64.141]:43598 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751306AbYKFShS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 13:37:18 -0500
Date: Thu, 6 Nov 2008 10:24:43 -0800
From: Greg KH <greg@kroah.com>
To: H L <swdevyid@yahoo.com>
Cc: Yu Zhao <yu.zhao@intel.com>, randy.dunlap@oracle.com,
       grundler@parisc-linux.org, achiang@hp.com, matthew@wil.cx,
       linux-pci@vger.kernel.org, rdreier@cisco.com,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Message-ID: <20081106182443.GB17782@kroah.com>
References: <20081106164919.GA4099@kroah.com> <392264.50990.qm@web45103.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <392264.50990.qm@web45103.mail.sp1.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 10:05:39AM -0800, H L wrote:
> 
> --- On Thu, 11/6/08, Greg KH <greg@kroah.com> wrote:
>  
> > On Thu, Nov 06, 2008 at 08:41:53AM -0800, H L wrote:
> > > I have not modified any existing drivers, but instead
> > I threw together
> > > a bare-bones module enabling me to make a call to
> > pci_iov_register()
> > > and then poke at an SR-IOV adapter's /sys entries
> > for which no driver
> > > was loaded.
> > > 
> > > It appears from my perusal thus far that drivers using
> > these new
> > > SR-IOV patches will require modification; i.e. the
> > driver associated
> > > with the Physical Function (PF) will be required to
> > make the
> > > pci_iov_register() call along with the requisite
> > notify() function.
> > > Essentially this suggests to me a model for the PF
> > driver to perform
> > > any "global actions" or setup on behalf of
> > VFs before enabling them
> > > after which VF drivers could be associated.
> > 
> > Where would the VF drivers have to be associated?  On the
> > "pci_dev"
> > level or on a higher one?
> 
> 
> I have not yet fully grocked Yu Zhao's model to answer this.  That
> said, I would *hope* to find it on the "pci_dev" level.

Me too.

> > Will all drivers that want to bind to a "VF"
> > device need to be
> > rewritten?
> 
> Not necessarily, or perhaps minimally; depends on hardware/firmware
> and actions the driver wants to take.  An example here might assist.
> Let's just say someone has created, oh, I don't know, maybe an SR-IOV
> NIC.  Now, for 'general' I/O operations to pass network traffic back
> and forth there would ideally be no difference in the actions and
> therefore behavior of a PF driver and a VF driver.  But, what do you
> do in the instance a VF wants to change link-speed?  As that physical
> characteristic affects all VFs, how do you handle that?  This is where
> the hardware/firmware implementation part comes to play.  If a VF
> driver performs some actions to initiate the change in link speed, the
> logic in the adapter could be anything like:

<snip>

Yes, I agree that all of this needs to be done, somehow.

It's that "somehow" that I am interested in trying to see how it works
out.

> > 
> > > I have so far only seen Yu Zhao's
> > "7-patch" set.  I've not yet looked
> > > at his subsequently tendered "15-patch" set
> > so I don't know what has
> > > changed.    The hardware/firmware implementation for
> > any given SR-IOV
> > > compatible device, will determine the extent of
> > differences required
> > > between a PF driver and a VF driver.
> > 
> > Yeah, that's what I'm worried/curious about. 
> > Without seeing the code
> > for such a driver, how can we properly evaluate if this
> > infrastructure
> > is the correct one and the proper way to do all of this?
> 
> 
> As the example above demonstrates, that's a tough question to answer.
> Ideally, in my view, there would only be one driver written per SR-IOV
> device and it would contain the logic to "do the right things" based
> on whether its running as a PF or VF with that determination easily
> accomplished by testing the existence of the SR-IOV extended
> capability.    Then, in an effort to minimize (if not eliminate) the
> complexities of driver-to-driver actions for fielding "global events",
> contain as much of the logic as is possible within the adapter.
> Minimizing the efforts required for the device driver writers in my
> opinion paves the way to greater adoption of this technology.

Yes, making things easier is the key here.

Perhaps some of this could be hidden with a new bus type for these kinds
of devices?  Or a "virtual" bus of pci devices that the original SR-IOV
device creates that corrispond to the individual virtual PCI devices?
If that were the case, then it might be a lot easier in the end.

thanks,

greg k-h
