Return-Path: <linux-kernel-owner+w=401wt.eu-S1752380AbYKFShA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbYKFShA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 13:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYKFSgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 13:36:48 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:49367 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYKFSgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 13:36:47 -0500
Date: Thu, 6 Nov 2008 11:36:30 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: "Fischer, Anna" <anna.fischer@hp.com>
Cc: Greg KH <greg@kroah.com>, H L <swdevyid@yahoo.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "Chiang, Alexander" <achiang@hp.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Message-ID: <20081106183630.GD11773@parisc-linux.org>
References: <20081106154351.GA30459@kroah.com> <894107.30288.qm@web45108.mail.sp1.yahoo.com> <20081106164919.GA4099@kroah.com> <0199E0D51A61344794750DC57738F58E5E26F996C4@GVW1118EXC.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0199E0D51A61344794750DC57738F58E5E26F996C4@GVW1118EXC.americas.hpqcorp.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Anna, can you fix your word-wrapping please?  Your lines appear to be
infinitely long which is most unpleasant to reply to]

On Thu, Nov 06, 2008 at 05:38:16PM +0000, Fischer, Anna wrote:
> > Where would the VF drivers have to be associated?  On the "pci_dev"
> > level or on a higher one?
> 
> A VF appears to the Linux OS as a standard (full, additional) PCI
> device. The driver is associated in the same way as for a normal PCI
> device. Ideally, you would use SR-IOV devices on a virtualized system,
> for example, using Xen. A VF can then be assigned to a guest domain as
> a full PCI device.

It's not clear thats the right solution.  If the VF devices are _only_
going to be used by the guest, then arguably, we don't want to create
pci_devs for them in the host.  (I think it _is_ the right answer, but I
want to make it clear there's multiple opinions on this).

> > Will all drivers that want to bind to a "VF" device need to be
> > rewritten?
> 
> Currently, any vendor providing a SR-IOV device needs to provide a PF
> driver and a VF driver that runs on their hardware. A VF driver does not
> necessarily need to know much about SR-IOV but just run on the presented
> PCI device. You might want to have a communication channel between PF
> and VF driver though, for various reasons, if such a channel is not
> provided in hardware.

That is one model.  Another model is to provide one driver that can
handle both PF and VF devices.  A third model is to provide, say, a
Windows VF driver and a Xen PF driver and only support Windows-on-Xen.
(This last would probably be an exercise in foot-shooting, but
nevertheless, I've heard it mooted).

> > Yeah, that's what I'm worried/curious about.  Without seeing the code
> > for such a driver, how can we properly evaluate if this infrastructure
> > is the correct one and the proper way to do all of this?
> 
> Yu's API allows a PF driver to register with the Linux PCI code and use
> it to activate VFs and allocate their resources. The PF driver needs to
> be modified to work with that API. While you can argue about how that API
> is supposed to look like, it is clear that such an API is required in some
> form. The PF driver needs to know when VFs are active as it might want to
> allocate further (device-specific) resources to VFs or initiate further
> (device-specific) configurations. While probably a lot of SR-IOV specific
> code has to be in the PF driver, there is also support required from
> the Linux PCI subsystem, which is to some extend provided by Yu's patches.

Everyone agrees that some support is necessary.  The question is exactly
what it looks like.  I must confess to not having reviewed this latest
patch series yet -- I'm a little burned out on patch review.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
