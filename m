Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab0CBOKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 09:10:00 -0500
Received: from smtp.citrix.com ([66.165.176.89]:19599 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab0CBOJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 09:09:59 -0500
X-IronPort-AV: E=Sophos;i="4.49,567,1262581200"; 
   d="scan'208";a="7407373"
Subject: Re: [LKML] [PATCH 7/7] xen: Enable grant table and xenbus for PV
 extension of HVM
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Sheng Yang <sheng@linux.intel.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100302134127.GA25893@phenom.dumpdata.com>
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com>
	 <1267436315-24486-8-git-send-email-sheng@linux.intel.com>
	 <20100301173858.GJ7881@phenom.dumpdata.com>
	 <201003020921.43398.sheng@linux.intel.com>
	 <20100302134127.GA25893@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 2 Mar 2010 14:09:55 +0000
Message-ID: <1267538995.11737.24042.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 13:41 +0000, Konrad Rzeszutek Wilk wrote:
> On Tue, Mar 02, 2010 at 09:21:43AM +0800, Sheng Yang wrote:
> > On Tuesday 02 March 2010 01:38:58 Konrad Rzeszutek Wilk wrote:
> > > > +/* The region reserved by QEmu for Xen platform device */
> > > > +#define GNTTAB_START	    0xf2000000ul
> > > > +#define GNTTAB_SIZE	    0x20000ul
> > > 
> > > I thought that in the earlier review you said:
> > > 
> > > "> > +#define GNTTAB_START           0xfbfe0000ul
> > > 
> > > > > +#define GNTTAB_SIZE            0x20000ul
> > > >
> > > > Is it possible that there would be a PCI device that would be
> > > > passed in the guest that would conflict with the above mentioned
> > > > E820 region?
> > > 
> > > I would change them to a dedicated PCI MMIO address in the next version.
> > > Thanks.
> > > 
> > > "
> > > ?
> > 
> > And yes, this is the dedicated PCI MMIO address I mentioned.. I would update 
> > the comments to get it more clear.
> > 
> > I don't think it's very clear solution, because the real good way to do this 
> > is probe pci device and find out with one is the platform pci device then use 
> > it. But the grant table initialization is quite earlier compared to the 
> > possible probing now... I hardcode the position now, and hunting for a better 
> 
> Would it be possible to move the grant table initialization to later
> phase? Past the PCI loading/initialization?

Or provide the address via an MSR, hypervisor specific CPUID leaf or IO
port or by using the early_pci infrastructure in the kernel. I don't
think we are short of options ;-)

Ian.

> 
> > idea.
> > 
> > Comments?
> > 
> > -- 
> > regards
> > Yang, Sheng
> >  


