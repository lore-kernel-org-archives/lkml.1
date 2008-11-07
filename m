Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbYKGHor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbYKGHor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 02:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYKGHog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 02:44:36 -0500
Received: from mx.neterion.com ([72.1.205.142]:44038 "EHLO owa.neterion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbYKGHoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 02:44:34 -0500
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Nov 2008 02:44:34 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Date: Fri, 7 Nov 2008 02:29:21 -0500
Message-ID: <78C9135A3D2ECE4B8162EBDCE82CAD77048C226F@nekter>
In-Reply-To: <4913E8E8.5040103@intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Thread-Index: AclAqBoCrIDafodsQAehVfAKL00fiwAAR6+g
References: <20081106154351.GA30459@kroah.com><894107.30288.qm@web45108.mail.sp1.yahoo.com><20081106164919.GA4099@kroah.com><20081106174741.GC11773@parisc-linux.org><20081106175308.GA17027@kroah.com><20081106235406.GB30790@sequoia.sous-sol.org> <4913E8E8.5040103@intel.com>
From: "Leonid Grossman" <Leonid.Grossman@neterion.com>
To: "Zhao, Yu" <yu.zhao@intel.com>, "Chris Wright" <chrisw@sous-sol.org>
Cc: <randy.dunlap@oracle.com>, <grundler@parisc-linux.org>, <achiang@hp.com>,
       "Matthew Wilcox" <matthew@wil.cx>, "Greg KH" <greg@kroah.com>,
       <rdreier@cisco.com>, <linux-kernel@vger.kernel.org>,
       <jbarnes@virtuousgeek.org>, <virtualization@lists.linux-foundation.org>,
       <kvm@vger.kernel.org>, <linux-pci@vger.kernel.org>, <mingo@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: virtualization-bounces@lists.linux-foundation.org
> [mailto:virtualization-bounces@lists.linux-foundation.org] On Behalf
Of
> Zhao, Yu
> Sent: Thursday, November 06, 2008 11:06 PM
> To: Chris Wright
> Cc: randy.dunlap@oracle.com; grundler@parisc-linux.org;
achiang@hp.com;
> Matthew Wilcox; Greg KH; rdreier@cisco.com;
linux-kernel@vger.kernel.org;
> jbarnes@virtuousgeek.org; virtualization@lists.linux-foundation.org;
> kvm@vger.kernel.org; linux-pci@vger.kernel.org; mingo@elte.hu
> Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
> 
> Chris Wright wrote:
> > * Greg KH (greg@kroah.com) wrote:
> >> On Thu, Nov 06, 2008 at 10:47:41AM -0700, Matthew Wilcox wrote:
> >>> On Thu, Nov 06, 2008 at 08:49:19AM -0800, Greg KH wrote:
> >>>> On Thu, Nov 06, 2008 at 08:41:53AM -0800, H L wrote:
> >>>>> I have not modified any existing drivers, but instead I threw
> together
> >>>>> a bare-bones module enabling me to make a call to
pci_iov_register()
> >>>>> and then poke at an SR-IOV adapter's /sys entries for which no
> driver
> >>>>> was loaded.
> >>>>>
> >>>>> It appears from my perusal thus far that drivers using these new
> >>>>> SR-IOV patches will require modification; i.e. the driver
associated
> >>>>> with the Physical Function (PF) will be required to make the
> >>>>> pci_iov_register() call along with the requisite notify()
function.
> >>>>> Essentially this suggests to me a model for the PF driver to
perform
> >>>>> any "global actions" or setup on behalf of VFs before enabling
them
> >>>>> after which VF drivers could be associated.
> >>>> Where would the VF drivers have to be associated?  On the
"pci_dev"
> >>>> level or on a higher one?
> >>>>
> >>>> Will all drivers that want to bind to a "VF" device need to be
> >>>> rewritten?
> >>> The current model being implemented by my colleagues has separate
> >>> drivers for the PF (aka native) and VF devices.  I don't
personally
> >>> believe this is the correct path, but I'm reserving judgement
until I
> >>> see some code.
> >> Hm, I would like to see that code before we can properly evaluate
this
> >> interface.  Especially as they are all tightly tied together.
> >>
> >>> I don't think we really know what the One True Usage model is for
VF
> >>> devices.  Chris Wright has some ideas, I have some ideas and Yu
Zhao
> has
> >>> some ideas.  I bet there's other people who have other ideas too.
> >> I'd love to hear those ideas.
> >
> > First there's the question of how to represent the VF on the host.
> > Ideally (IMO) this would show up as a normal interface so that
normal
> tools
> > can configure the interface.  This is not exactly how the first
round of
> > patches were designed.
> 
> Whether the VF can show up as a normal interface is decided by VF
> driver. VF is represented by 'pci_dev' at PCI level, so VF driver can
be
> loaded as normal PCI device driver.
> 
> What the software representation (eth, framebuffer, etc.) created by
VF
> driver is not controlled by SR-IOV framework.
> 
> So you definitely can use normal tool to configure the VF if its
driver
> supports that :-)
> 
> >
> > Second there's the question of reserving the BDF on the host such
that
> > we don't have two drivers (one in the host and one in a guest)
trying to
> > drive the same device (an issue that shows up for device assignment
as
> > well as VF assignment).
> 
> If we don't reserve BDF for the device, they can't work neither in the
> host nor the guest.
> 
> Without BDF, we can't access the config space of the device, the
device
> also can't do DMA.
> 
> Did I miss your point?
> 
> >
> > Third there's the question of whether the VF can be used in the host
at
> > all.
> 
> Why can't? My VFs work well in the host as normal PCI devices :-)
> 
> >
> > Fourth there's the question of whether the VF and PF drivers are the
> > same or separate.
> 
> As I mentioned in another email of this thread. We can't predict how
> hardware vendor creates their SR-IOV device. PCI SIG doesn't define
> device specific logics.
> 
> So I think the answer of this question is up to the device driver
> developers. If PF and VF in a SR-IOV device have similar logics, then
> they can combine the driver. Otherwise, e.g., if PF doesn't have real
> functionality at all -- it only has registers to control internal
> resource allocation for VFs, then the drivers should be separate,
right?


Right, this really depends upon the functionality behind a VF. If VF is
done as a subset of netdev interface (for example, a queue pair), then a
split VF/PF driver model and a proprietary communication channel is in
order. 

If each VF is done as a complete netdev interface (like in our 10GbE IOV
controllers), then PF and VF drivers could be the same. Each VF can be
independently driven by such "native" netdev driver; this includes the
ability to run a native driver in a guest in passthru mode. 
A PF driver in a privileged domain doesn't even have to be present.

> 
> >
> > The typical usecase is assigning the VF to the guest directly, so
> > there's only enough functionality in the host side to allocate a VF,
> > configure it, and assign it (and propagate AER).  This is with
separate
> > PF and VF driver.
> >
> > As Anthony mentioned, we are interested in allowing the host to use
the
> > VF.  This could be useful for containers as well as dedicating a VF
(a
> > set of device resources) to a guest w/out passing it through.
> 
> I've considered the container cases, we don't have problem with
running
> VF driver in the host.
> 
> Thanks,
> Yu
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/virtualization
