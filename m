Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbYKFUFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbYKFUFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYKFUFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:05:06 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:31493 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYKFUFD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:05:03 -0500
From: "Fischer, Anna" <anna.fischer@hp.com>
To: Greg KH <greg@kroah.com>
CC: H L <swdevyid@yahoo.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "Chiang, Alexander" <achiang@hp.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Date: Thu, 6 Nov 2008 20:04:27 +0000
Subject: RE: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Thread-Topic: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Thread-Index: AclAOg3aHEuPiiZpS2ioNtDnCQLO/AADTW5A
Message-ID: <0199E0D51A61344794750DC57738F58E5E26F99702@GVW1118EXC.americas.hpqcorp.net>
References: <20081106154351.GA30459@kroah.com>
 <894107.30288.qm@web45108.mail.sp1.yahoo.com>
 <20081106164919.GA4099@kroah.com>
 <0199E0D51A61344794750DC57738F58E5E26F996C4@GVW1118EXC.americas.hpqcorp.net>
 <20081106180354.GA17429@kroah.com>
In-Reply-To: <20081106180354.GA17429@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
>
> On Thu, Nov 06, 2008 at 05:38:16PM +0000, Fischer, Anna wrote:
> > > On Thu, Nov 06, 2008 at 08:41:53AM -0800, H L wrote:
> > > > I have not modified any existing drivers, but instead I threw
> > > together
> > > > a bare-bones module enabling me to make a call to
> pci_iov_register()
> > > > and then poke at an SR-IOV adapter's /sys entries for which no
> driver
> > > > was loaded.
> > > >
> > > > It appears from my perusal thus far that drivers using these new
> > > > SR-IOV patches will require modification; i.e. the driver
> associated
> > > > with the Physical Function (PF) will be required to make the
> > > > pci_iov_register() call along with the requisite notify()
> function.
> > > > Essentially this suggests to me a model for the PF driver to
> perform
> > > > any "global actions" or setup on behalf of VFs before enabling
> them
> > > > after which VF drivers could be associated.
> > >
> > > Where would the VF drivers have to be associated?  On the "pci_dev"
> > > level or on a higher one?
> >
> > A VF appears to the Linux OS as a standard (full, additional) PCI
> > device. The driver is associated in the same way as for a normal PCI
> > device. Ideally, you would use SR-IOV devices on a virtualized
> system,
> > for example, using Xen. A VF can then be assigned to a guest domain
> as
> > a full PCI device.
>
> It's that "second" part that I'm worried about.  How is that going to
> happen?  Do you have any patches that show this kind of "assignment"?

That depends on your setup. Using Xen, you could assign the VF to a guest domain like any other PCI device, e.g. using PCI pass-through. For VMware, KVM, there are standard ways to do that, too. I currently don't see why SR-IOV devices would need any specific, non-standard mechanism for device assignment.


> > > Will all drivers that want to bind to a "VF" device need to be
> > > rewritten?
> >
> > Currently, any vendor providing a SR-IOV device needs to provide a PF
> > driver and a VF driver that runs on their hardware.
>
> Are there any such drivers available yet?

I don't know.


> > A VF driver does not necessarily need to know much about SR-IOV but
> > just run on the presented PCI device. You might want to have a
> > communication channel between PF and VF driver though, for various
> > reasons, if such a channel is not provided in hardware.
>
> Agreed, but what does that channel look like in Linux?
>
> I have some ideas of what I think it should look like, but if people
> already have code, I'd love to see that as well.

At this point I would guess that this code is vendor specific, as are the drivers. The issue I see is that most likely drivers will run in different environments, for example, in Xen the PF driver runs in a driver domain while a VF driver runs in a guest VM. So a communication channel would need to be either Xen specific, or vendor specific. Also, a guest using the VF might run Windows while the PF might be controlled under Linux.

Anna
