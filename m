Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbYGKAAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbYGKAAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 20:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbYGKAAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:00:18 -0400
Received: from mga10.intel.com ([192.55.52.92]:51392 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755517AbYGKAAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:00:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,341,1212390000"; 
   d="scan'208";a="589716598"
Date: Thu, 10 Jul 2008 19:53:26 -0400
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yong Wang <yong.y.wang@linux.intel.com>, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com
Subject: Re: [PATCH] Intel IOMMU: RMRRs do not necessarily have to be
	present on all VT-d capable platforms
Message-ID: <20080710235326.GA21208@ywang-dev>
References: <20080701091354.GA12969@ywang-dev> <20080710010149.a73d779c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710010149.a73d779c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 01:01:49AM -0700, Andrew Morton wrote:
> On Tue, 1 Jul 2008 05:13:54 -0400 Yong Wang <yong.y.wang@linux.intel.com> wrote:
> 
> > RMRRs do not necessarily have to be present on all VT-d capable platforms.
> > The printk is just informational and does not need to be followed by an
> > error return.
> > 
> > Signed-off-by: Yong Y Wang <yong.y.wang@intel.com>
> > ---
> >  dmar.c |    4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
> > index f941f60..8bf86ae 100644
> > --- a/drivers/pci/dmar.c
> > +++ b/drivers/pci/dmar.c
> > @@ -317,10 +317,8 @@ int __init dmar_table_init(void)
> >  		return -ENODEV;
> >  	}
> >  
> > -	if (list_empty(&dmar_rmrr_units)) {
> > +	if (list_empty(&dmar_rmrr_units))
> >  		printk(KERN_INFO PREFIX "No RMRR found\n");
> > -		return -ENODEV;
> > -	}
> >  
> >  	return 0;
> >  }
> 
> >From your description I am unable to work out how important this fix is.
> 
> Is it needed in 2.6.25.x?  In 2.6.26?  In 2.6.27?  There's no way for me to
> know :(

Actually this is the same as Suresh' x2apic patch 05/26. The absence of RMRRs
will prevent kernel from parsing IOxAPICs without this patch and thus leaves
IOxAPICs in an uninitialized state.
