Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759076AbYLQLox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbYLQLox (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 06:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYLQLom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 06:44:42 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:30193 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbYLQLok convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 06:44:40 -0500
From: "Fischer, Anna" <anna.fischer@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Yu Zhao <yu.zhao@intel.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Chiang, Alexander" <achiang@hp.com>,
        "Helgaas, Bjorn" <bjorn.helgaas@hp.com>,
        "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
        "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "matthew@wil.cx" <matthew@wil.cx>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "rdreier@cisco.com" <rdreier@cisco.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Wed, 17 Dec 2008 11:42:54 +0000
Subject: RE: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Thread-Topic: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Thread-Index: Aclf1ad786RxgFQaSkW4dYZWKK0VaQAPNhgA
Message-ID: <0199E0D51A61344794750DC57738F58E5E29B33E3C@GVW1118EXC.americas.hpqcorp.net>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
 <200812161523.55238.jbarnes@virtuousgeek.org>
In-Reply-To: <200812161523.55238.jbarnes@virtuousgeek.org>
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

> From: linux-pci-owner@vger.kernel.org [mailto:linux-pci-
> owner@vger.kernel.org] On Behalf Of Jesse Barnes
> Sent: 16 December 2008 23:24
> To: Yu Zhao
> Cc: linux-pci@vger.kernel.org; Chiang, Alexander; Helgaas, Bjorn;
> grundler@parisc-linux.org; greg@kroah.com; mingo@elte.hu;
> matthew@wil.cx; randy.dunlap@oracle.com; rdreier@cisco.com;
> horms@verge.net.au; yinghai@kernel.org; linux-kernel@vger.kernel.org;
> kvm@vger.kernel.org; virtualization@lists.linux-foundation.org
> Subject: Re: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
>
> On Friday, November 21, 2008 10:36 am Yu Zhao wrote:
> > Greetings,
> >
> > Following patches are intended to support SR-IOV capability in the
> > Linux kernel. With these patches, people can turn a PCI device with
> > the capability into multiple ones from software perspective, which
> > will benefit KVM and achieve other purposes such as QoS, security,
> > and etc.
> >
> > The Physical Function and Virtual Function drivers using the SR-IOV
> > APIs will come soon!
> >
> > Major changes from v6 to v7:
> > 1, remove boot-time resource rebalancing support. (Greg KH)
> > 2, emit uevent upon the PF driver is loaded. (Greg KH)
> > 3, put SR-IOV callback function into the 'pci_driver'. (Matthew
> Wilcox)
> > 4, register SR-IOV service at the PF loading stage.
> > 5, remove unnecessary APIs (pci_iov_enable/disable).
>
> Thanks for your patience with this, Yu, I know it's been a long haul.
> :)
>
> I applied 1-9 to my linux-next branch; and at least patch #10 needs a
> respin,
> so can you re-do 10-13 as a new patch set?
>
> On re-reading the last thread, there was a lot of smoke, but very
> little fire
> afaict.  The main questions I saw were:
>
>   1) do we need SR-IOV at all?  why not just make each subsystem export
>      devices to guests?
>     This is a bit of a red herring.  Nothing about SR-IOV prevents us
> from
>     making subsystems more v12n friendly.  And since SR-IOV is a
> hardware
>     feature supported by devices these days, we should make Linux
> support it.
>
>   2) should the PF/VF drivers be the same or not?
>     Again, the SR-IOV patchset and PCI spec don't dictate this.  We're
> free to
>     do what we want here.
>
>   3) should VF devices be represented by pci_dev structs?
>     Yes.  (This is an easy one :)
>
>   4) can VF devices be used on the host?
>     Yet again, SR-IOV doesn't dictate this.  Developers can make PF/VF
> combo
>     drivers or split them, and export the resulting devices however
> they want.
>     Some subsystem work may be needed to make this efficient, but SR-
> IOV
>     itself is agnostic about it.
>
> So overall I didn't see many objections to the actual code in the last
> post,
> and the issues above certainly don't merit a NAK IMO...

I have two minor comments on this topic.

1) Currently the PF driver is called before the kernel initializes VFs and
their resources, and the current API does not allow the PF driver to
detect that easily if the allocation of the VFs and their resources
has succeeded or not. It would be quite useful if the PF driver gets
notified when the VFs have been created successfully as it might have
to do further device-specific work *after* IOV has been enabled.

2) Configuration of SR-IOV: the current API allows to enable/disable
VFs from userspace via SYSFS. At the moment I am not quite clear what
exactly is supposed to control these capabilities. This could be
Linux tools or, on a virtualized system, hypervisor control tools.
One thing I am missing though is an in-kernel API for this which I
think might be useful. After all the PF driver controls the device,
and, for example, when a device error occurs (e.g. a hardware failure
which only the PF driver will be able to detect, not Linux), then the
PF driver might have to de-allocate all resources, shut down VFs and
reset the device, or something like that. In that case the PF driver
needs to have a way to notify the Linux SR-IOV code about this and
initiate cleaning up of VFs and their resources. At the moment, this
would have to go through userspace, I believe, and I think that is not
an optimal solution. Yu, do you have an opinion on how this would be
realized?

Anna
