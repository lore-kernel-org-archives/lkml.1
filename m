Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab0CBBUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 20:20:46 -0500
Received: from mga05.intel.com ([192.55.52.89]:45216 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751412Ab0CBBUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 20:20:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,563,1262592000"; 
   d="scan'208";a="777063716"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [LKML] [PATCH 7/7] xen: Enable grant table and xenbus for PV extension of HVM
Date: Tue, 2 Mar 2010 09:21:43 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       "xen-devel" <xen-devel@lists.xensource.com>,
       linux-kernel@vger.kernel.org
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com> <1267436315-24486-8-git-send-email-sheng@linux.intel.com> <20100301173858.GJ7881@phenom.dumpdata.com>
In-Reply-To: <20100301173858.GJ7881@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003020921.43398.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 March 2010 01:38:58 Konrad Rzeszutek Wilk wrote:
> > +/* The region reserved by QEmu for Xen platform device */
> > +#define GNTTAB_START	    0xf2000000ul
> > +#define GNTTAB_SIZE	    0x20000ul
> 
> I thought that in the earlier review you said:
> 
> "> > +#define GNTTAB_START           0xfbfe0000ul
> 
> > > +#define GNTTAB_SIZE            0x20000ul
> >
> > Is it possible that there would be a PCI device that would be
> > passed in the guest that would conflict with the above mentioned
> > E820 region?
> 
> I would change them to a dedicated PCI MMIO address in the next version.
> Thanks.
> 
> "
> ?

And yes, this is the dedicated PCI MMIO address I mentioned.. I would update 
the comments to get it more clear.

I don't think it's very clear solution, because the real good way to do this 
is probe pci device and find out with one is the platform pci device then use 
it. But the grant table initialization is quite earlier compared to the 
possible probing now... I hardcode the position now, and hunting for a better 
idea.

Comments?

-- 
regards
Yang, Sheng
 
