Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab0CBOFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 09:05:38 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:20703 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab0CBOFh (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 2 Mar 2010 09:05:37 -0500
Date: Tue, 2 Mar 2010 08:41:27 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sheng Yang <sheng@linux.intel.com>
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>, linux-kernel@vger.kernel.org
Subject: Re: [LKML] [PATCH 7/7] xen: Enable grant table and xenbus for PV
	extension of HVM
Message-ID: <20100302134127.GA25893@phenom.dumpdata.com>
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com> <1267436315-24486-8-git-send-email-sheng@linux.intel.com> <20100301173858.GJ7881@phenom.dumpdata.com> <201003020921.43398.sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003020921.43398.sheng@linux.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B8D1B28.0194:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 09:21:43AM +0800, Sheng Yang wrote:
> On Tuesday 02 March 2010 01:38:58 Konrad Rzeszutek Wilk wrote:
> > > +/* The region reserved by QEmu for Xen platform device */
> > > +#define GNTTAB_START	    0xf2000000ul
> > > +#define GNTTAB_SIZE	    0x20000ul
> > 
> > I thought that in the earlier review you said:
> > 
> > "> > +#define GNTTAB_START           0xfbfe0000ul
> > 
> > > > +#define GNTTAB_SIZE            0x20000ul
> > >
> > > Is it possible that there would be a PCI device that would be
> > > passed in the guest that would conflict with the above mentioned
> > > E820 region?
> > 
> > I would change them to a dedicated PCI MMIO address in the next version.
> > Thanks.
> > 
> > "
> > ?
> 
> And yes, this is the dedicated PCI MMIO address I mentioned.. I would update 
> the comments to get it more clear.
> 
> I don't think it's very clear solution, because the real good way to do this 
> is probe pci device and find out with one is the platform pci device then use 
> it. But the grant table initialization is quite earlier compared to the 
> possible probing now... I hardcode the position now, and hunting for a better 

Would it be possible to move the grant table initialization to later
phase? Past the PCI loading/initialization?

> idea.
> 
> Comments?
> 
> -- 
> regards
> Yang, Sheng
>  
