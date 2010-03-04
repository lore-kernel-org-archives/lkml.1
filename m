Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0CDKSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 05:18:52 -0500
Received: from smtp.citrix.com ([66.165.176.89]:44001 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab0CDKSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 05:18:49 -0500
X-IronPort-AV: E=Sophos;i="4.49,580,1262581200"; 
   d="scan'208";a="7438093"
Subject: Re: [Xen-devel] [PATCH 3/7] xen/hvm: Xen PV extension of  HVM
 initialization
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Sheng Yang <sheng@linux.intel.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1003031741080.4648@kaball-desktop>
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com>
	 <1267436315-24486-4-git-send-email-sheng@linux.intel.com>
	 <4B8C63B0.2090507@goop.org>  <201003020938.53630.sheng@linux.intel.com>
	 <1267521735.11737.23107.camel@zakaz.uk.xensource.com>
	 <4B8D7248.5070807@goop.org>
	 <alpine.DEB.2.00.1003031132550.4648@kaball-desktop>
	 <4B8E9DD7.6020408@goop.org>
	 <alpine.DEB.2.00.1003031741080.4648@kaball-desktop>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 4 Mar 2010 10:18:45 +0000
Message-ID: <1267697925.11737.32107.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 17:41 +0000, Stefano Stabellini wrote:
> On Wed, 3 Mar 2010, Jeremy Fitzhardinge wrote:
> > On 03/03/2010 03:35 AM, Stefano Stabellini wrote:
> > > Give a look at the fourth patch of the series I just posted: it
> > > introduces a simple driver for the Xen PCI platform device to initialize
> > > xenbus and gran table later on when running in a HVM domain, at the same
> > > time leaving the PV case as it is.
> > >    
> > 
> > Yes, I noticed that.  Do the PV drivers cope with having the PCI 
> > probe/xenbus setup after their init functions have been called, or do 
> > you make sure the PCI probe happens early?
> > 
> 
> Nope, they seem to cope fine so far.

xenbus_frontend_register is basically just driver_register so it should
be safe to call even before the register_bus(xenbusfoo) call. Things
shouldn't kick off until xen_probe() is called which either happens
explicitly in xenbus_probe_init() or via probe_work which contains a
xenstored_ready check.

Ian.

