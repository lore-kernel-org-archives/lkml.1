Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYKGG3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYKGG3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 01:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbYKGG2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 01:28:39 -0500
Received: from kroah.org ([198.145.64.141]:48935 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755566AbYKGG2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 01:28:36 -0500
Date: Thu, 6 Nov 2008 22:10:07 -0800
From: Greg KH <greg@kroah.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Matthew Wilcox <matthew@wil.cx>, H L <swdevyid@yahoo.com>,
       Yu Zhao <yu.zhao@intel.com>, randy.dunlap@oracle.com,
       grundler@parisc-linux.org, achiang@hp.com, linux-pci@vger.kernel.org,
       rdreier@cisco.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Message-ID: <20081107061007.GB3860@kroah.com>
References: <20081106154351.GA30459@kroah.com> <894107.30288.qm@web45108.mail.sp1.yahoo.com> <20081106164919.GA4099@kroah.com> <20081106174741.GC11773@parisc-linux.org> <20081106175308.GA17027@kroah.com> <20081106235406.GB30790@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106235406.GB30790@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 03:54:06PM -0800, Chris Wright wrote:
> * Greg KH (greg@kroah.com) wrote:
> > On Thu, Nov 06, 2008 at 10:47:41AM -0700, Matthew Wilcox wrote:
> > > On Thu, Nov 06, 2008 at 08:49:19AM -0800, Greg KH wrote:
> > > > On Thu, Nov 06, 2008 at 08:41:53AM -0800, H L wrote:
> > > > > I have not modified any existing drivers, but instead I threw together
> > > > > a bare-bones module enabling me to make a call to pci_iov_register()
> > > > > and then poke at an SR-IOV adapter's /sys entries for which no driver
> > > > > was loaded.
> > > > > 
> > > > > It appears from my perusal thus far that drivers using these new
> > > > > SR-IOV patches will require modification; i.e. the driver associated
> > > > > with the Physical Function (PF) will be required to make the
> > > > > pci_iov_register() call along with the requisite notify() function.
> > > > > Essentially this suggests to me a model for the PF driver to perform
> > > > > any "global actions" or setup on behalf of VFs before enabling them
> > > > > after which VF drivers could be associated.
> > > > 
> > > > Where would the VF drivers have to be associated?  On the "pci_dev"
> > > > level or on a higher one?
> > > > 
> > > > Will all drivers that want to bind to a "VF" device need to be
> > > > rewritten?
> > > 
> > > The current model being implemented by my colleagues has separate
> > > drivers for the PF (aka native) and VF devices.  I don't personally
> > > believe this is the correct path, but I'm reserving judgement until I
> > > see some code.
> > 
> > Hm, I would like to see that code before we can properly evaluate this
> > interface.  Especially as they are all tightly tied together.
> > 
> > > I don't think we really know what the One True Usage model is for VF
> > > devices.  Chris Wright has some ideas, I have some ideas and Yu Zhao has
> > > some ideas.  I bet there's other people who have other ideas too.
> > 
> > I'd love to hear those ideas.
> 
> First there's the question of how to represent the VF on the host.
> Ideally (IMO) this would show up as a normal interface so that normal tools
> can configure the interface.  This is not exactly how the first round of
> patches were designed.
> 
> Second there's the question of reserving the BDF on the host such that
> we don't have two drivers (one in the host and one in a guest) trying to
> drive the same device (an issue that shows up for device assignment as
> well as VF assignment).
> 
> Third there's the question of whether the VF can be used in the host at
> all.
> 
> Fourth there's the question of whether the VF and PF drivers are the
> same or separate.
> 
> The typical usecase is assigning the VF to the guest directly, so
> there's only enough functionality in the host side to allocate a VF,
> configure it, and assign it (and propagate AER).  This is with separate
> PF and VF driver.
> 
> As Anthony mentioned, we are interested in allowing the host to use the
> VF.  This could be useful for containers as well as dedicating a VF (a
> set of device resources) to a guest w/out passing it through.

All of this looks great.  So, with all of these questions, how does the
current code pertain to these issues?  It seems like we have a long way
to go...

thanks,

greg k-h
