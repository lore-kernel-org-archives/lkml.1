Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab0CCLcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 06:32:10 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:8979 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab0CCLcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 06:32:07 -0500
X-IronPort-AV: E=Sophos;i="4.49,573,1262563200"; 
   d="scan'208";a="9757854"
Date: Wed, 3 Mar 2010 11:35:52 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/7] xen/hvm: Xen PV extension of  HVM
 initialization
In-Reply-To: <4B8D7248.5070807@goop.org>
Message-ID: <alpine.DEB.2.00.1003031132550.4648@kaball-desktop>
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com>  <1267436315-24486-4-git-send-email-sheng@linux.intel.com>  <4B8C63B0.2090507@goop.org>  <201003020938.53630.sheng@linux.intel.com> <1267521735.11737.23107.camel@zakaz.uk.xensource.com>
 <4B8D7248.5070807@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Mar 2010, Jeremy Fitzhardinge wrote:
> On 03/02/2010 01:22 AM, Ian Campbell wrote:
> > On Tue, 2010-03-02 at 01:38 +0000, Sheng Yang wrote:
> >    
> >> A annoy thing in pv drivers is that it would test if the domain type
> >> is _NOT_ XEN_NATIVE. So set the domain to XEN_HVM_DOMAIN would result
> >> in PV driver initialization then probably panic.
> >>      
> > What _actually_ panics?
> >
> > Registration of the frontend devices should be completely harmless
> > (apart from a little wasted RAM) unless a xenbus driver manages to come
> > up and enumerate the xen bus and cause the ->probe function run.
> >
> > You should be gating the xenbus startup on the availability of PV
> > functionality not the individual driver registrations. This keeps the
> > test in a single easy to maintain place.
> >
> > Compare with pci_register_driver and all of the callers of that function
> > -- not a single one of them has an "is_pci_available" test anywhere.
> >    
> 
> The problem is that it currently assumes xenbus is initialized by the 
> time the PV drivers init, because in a PV boot xenbus gets initted very 
> early.  We need to change it so that it can cope with drivers being 
> initialized and registering with xenbus before it has been initialized.
> 
> We have the same problem with plain PV-on-HVM drivers as xenbus only 
> comes up as a result of probing the Xen PCI platform device, which may 
> be after the PV drivers' init functions have been called.

Give a look at the fourth patch of the series I just posted: it
introduces a simple driver for the Xen PCI platform device to initialize
xenbus and gran table later on when running in a HVM domain, at the same
time leaving the PV case as it is.


