Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYKFWYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYKFWYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYKFWYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:24:12 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:45005 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbYKFWYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:24:10 -0500
Date: Fri, 7 Nov 2008 09:24:08 +1100
From: Simon Horman <horms@verge.net.au>
To: Greg KH <greg@kroah.com>
Cc: Matthew Wilcox <matthew@wil.cx>, H L <swdevyid@yahoo.com>,
       Yu Zhao <yu.zhao@intel.com>, randy.dunlap@oracle.com,
       grundler@parisc-linux.org, achiang@hp.com, linux-pci@vger.kernel.org,
       rdreier@cisco.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, mingo@elte.hu, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Message-ID: <20081106222405.GA9409@verge.net.au>
References: <20081106154351.GA30459@kroah.com> <894107.30288.qm@web45108.mail.sp1.yahoo.com> <20081106164919.GA4099@kroah.com> <20081106174741.GC11773@parisc-linux.org> <20081106175308.GA17027@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106175308.GA17027@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 09:53:08AM -0800, Greg KH wrote:
> On Thu, Nov 06, 2008 at 10:47:41AM -0700, Matthew Wilcox wrote:
> > On Thu, Nov 06, 2008 at 08:49:19AM -0800, Greg KH wrote:
> > > On Thu, Nov 06, 2008 at 08:41:53AM -0800, H L wrote:
> > > > I have not modified any existing drivers, but instead I threw together
> > > > a bare-bones module enabling me to make a call to pci_iov_register()
> > > > and then poke at an SR-IOV adapter's /sys entries for which no driver
> > > > was loaded.
> > > > 
> > > > It appears from my perusal thus far that drivers using these new
> > > > SR-IOV patches will require modification; i.e. the driver associated
> > > > with the Physical Function (PF) will be required to make the
> > > > pci_iov_register() call along with the requisite notify() function.
> > > > Essentially this suggests to me a model for the PF driver to perform
> > > > any "global actions" or setup on behalf of VFs before enabling them
> > > > after which VF drivers could be associated.
> > > 
> > > Where would the VF drivers have to be associated?  On the "pci_dev"
> > > level or on a higher one?
> > > 
> > > Will all drivers that want to bind to a "VF" device need to be
> > > rewritten?
> > 
> > The current model being implemented by my colleagues has separate
> > drivers for the PF (aka native) and VF devices.  I don't personally
> > believe this is the correct path, but I'm reserving judgement until I
> > see some code.
> 
> Hm, I would like to see that code before we can properly evaluate this
> interface.  Especially as they are all tightly tied together.
> 
> > I don't think we really know what the One True Usage model is for VF
> > devices.  Chris Wright has some ideas, I have some ideas and Yu Zhao has
> > some ideas.  I bet there's other people who have other ideas too.
> 
> I'd love to hear those ideas.
> 
> Rumor has it, there is some Xen code floating around to support this
> already, is that true?

Xen patches were posted to xen-devel by Yu Zhao on the 29th of September [1].
Unfortunately the only responses that I can find are a) that the patches
were mangled and b) they seem to include changes (by others) that have
been merged into Linux. I have confirmed that both of these concerns
are valid.

I have not yet examined the difference, if any, in the approach taken by Yu
to SR-IOV in Linux and Xen. Unfortunately comparison is less than trivial
due to the gaping gap in kernel versions between Linux-Xen (2.6.18.8) and
Linux itself.

One approach that I was considering in order to familiarise myself with the
code was to backport the v6 Linux patches (this thread) to Linux-Xen. I made a
start on that, but again due to kernel version differences it is non-trivial.

[1] http://lists.xensource.com/archives/html/xen-devel/2008-09/msg00923.html

-- 
Simon Horman
  VA Linux Systems Japan K.K., Sydney, Australia Satellite Office
  H: www.vergenet.net/~horms/             W: www.valinux.co.jp/en

