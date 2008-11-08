Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbYKHLLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbYKHLLJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 06:11:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbYKHLKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 06:10:54 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:31677 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbYKHLKv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 06:10:51 -0500
From: "Fischer, Anna" <anna.fischer@hp.com>
To: Greg KH <greg@kroah.com>, Yu Zhao <yu.zhao@uniscape.net>
CC: Matthew Wilcox <matthew@wil.cx>, Anthony Liguori <anthony@codemonkey.ws>,
       H L <swdevyid@yahoo.com>,
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
       "mingo@elte.hu" <mingo@elte.hu>,
       "keir.fraser@eu.citrix.com" <keir.fraser@eu.citrix.com>,
       "Leonid.Grossman@neterion.com" <Leonid.Grossman@neterion.com>,
       "eddie.dong@intel.com" <eddie.dong@intel.com>,
       "jun.nakajima@intel.com" <jun.nakajima@intel.com>,
       "avi@redhat.com" <avi@redhat.com>
Date: Sat, 8 Nov 2008 11:09:38 +0000
Subject: RE: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Thread-Topic: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Thread-Index: AclBFTb7qUtEL2p/QLi7p8D7C8ssfAAei3yw
Message-ID: <0199E0D51A61344794750DC57738F58E5E26FF3237@GVW1118EXC.americas.hpqcorp.net>
References: <20081106154351.GA30459@kroah.com>
 <894107.30288.qm@web45108.mail.sp1.yahoo.com>
 <20081106164919.GA4099@kroah.com>
 <0199E0D51A61344794750DC57738F58E5E26F996C4@GVW1118EXC.americas.hpqcorp.net>
 <20081106183630.GD11773@parisc-linux.org> <491371F0.7020805@codemonkey.ws>
 <20081106225854.GA15439@parisc-linux.org> <20081107061952.GF3860@kroah.com>
 <49145C14.1050409@uniscape.net> <20081107184825.GB2320@kroah.com>
In-Reply-To: <20081107184825.GB2320@kroah.com>
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
> Importance: High
>
> On Fri, Nov 07, 2008 at 11:17:40PM +0800, Yu Zhao wrote:
> > While we are arguing what the software model the SR-IOV should be,
> let me
> > ask two simple questions first:
> >
> > 1, What does the SR-IOV looks like?
> > 2, Why do we need to support it?
>
> I don't think we need to worry about those questions, as we can see
> what
> the SR-IOV interface looks like by looking at the PCI spec, and we know
> Linux needs to support it, as Linux needs to support everything :)
>
> (note, community members that can not see the PCI specs at this point
> in
> time, please know that we are working on resolving these issues,
> hopefully we will have some good news within a month or so.)
>
> > As you know the Linux kernel is the base of various virtual machine
> > monitors such as KVM, Xen, OpenVZ and VServer. We need SR-IOV support
> in
> > the kernel because mostly it helps high-end users (IT departments,
> HPC,
> > etc.) to share limited hardware resources among hundreds or even
> thousands
> > virtual machines and hence reduce the cost. How can we make these
> virtual
> > machine monitors utilize the advantage of SR-IOV without spending too
> much
> > effort meanwhile remaining architectural correctness? I believe
> making VF
> > represent as much closer as a normal PCI device (struct pci_dev) is
> the
> > best way in current situation, because this is not only what the
> hardware
> > designers expect us to do but also the usage model that KVM, Xen and
> other
> > VMMs have already supported.
>
> But would such an api really take advantage of the new IOV interfaces
> that are exposed by the new device type?

I agree with what Yu says. The idea is to have hardware capabilities to
virtualize a PCI device in a way that those virtual devices can represent
full PCI devices. The advantage of that is that those virtual device can
then be used like any other standard PCI device, meaning we can use existing
OS tools, configuration mechanism etc. to start working with them. Also, when
using a virtualization-based system, e.g. Xen or KVM, we do not need
to introduce new mechanisms to make use of SR-IOV, because we can handle
VFs as full PCI devices.

A virtual PCI device in hardware (a VF) can be as powerful or complex as
you like, or it can be very simple. But the big advantage of SR-IOV is
that hardware presents a complete PCI device to the OS - as opposed to
some resources, or queues, that need specific new configuration and
assignment mechanisms in order to use them with a guest OS (like, for
example, VMDq or similar technologies).

Anna
