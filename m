Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbZJ0AnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbZJ0AnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbZJ0AnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:43:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:13601 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444AbZJ0AnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 20:43:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,628,1249282800"; 
   d="scan'208";a="740779851"
Subject: Re: [PATCH 5/5] PCI: fix memory leak in aer_inject
From: Huang Ying <ying.huang@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andrew Patterson <andrew.patterson@hp.com>,
       "prarit@redhat.com" <prarit@redhat.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "pci-linux@vger.kernel.org" <pci-linux@vger.kernel.org>
In-Reply-To: <20091026142150.37711e0d@jbarnes-g45>
References: <20091012070248.27029.78378.stgit@bob.kio>
	 <20091012070314.27029.35077.stgit@bob.kio>
	 <1255333470.6047.141.camel@yhuang-dev.sh.intel.com>
	 <20091026142150.37711e0d@jbarnes-g45>
Content-Type: text/plain
Date: Tue, 27 Oct 2009 08:43:21 +0800
Message-Id: <1256604201.30470.969.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jesse,

On Tue, 2009-10-27 at 05:21 +0800, Jesse Barnes wrote: 
> On Mon, 12 Oct 2009 15:44:30 +0800
> Huang Ying <ying.huang@intel.com> wrote:
> 
> > On Mon, 2009-10-12 at 15:03 +0800, Andrew Patterson wrote: 
> > > PCI: fix memory leak in aer_inject
> > > 
> > > Fixed probable typo in aer_inject cleanup code resulting in a memory
> > > leak.
> > > 
> > > Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
> > > ---
> > > 
> > > diff --git a/drivers/pci/pcie/aer/aer_inject.c
> > > b/drivers/pci/pcie/aer/aer_inject.c index da2ad6e..2246bf7 100644
> > > --- a/drivers/pci/pcie/aer/aer_inject.c
> > > +++ b/drivers/pci/pcie/aer/aer_inject.c
> > > @@ -474,7 +474,7 @@ static void __exit aer_inject_exit(void)
> > >  	}
> > >  
> > >  	spin_lock_irqsave(&inject_lock, flags);
> > > -	list_for_each_entry_safe(err, err_next, &pci_bus_ops_list,
> > > list) {
> > > +	list_for_each_entry_safe(err, err_next, &einjected, list) {
> > >  		list_del(&err->list);
> > >  		kfree(err);
> > >  	}
> > 
> > Thanks for the patch.
> > 
> > Acked-by: Huang Ying <ying.huang@intel.com>
> > 
> 
> How do the rest of the patches look, Ying?  Should I add your acked-by
> on Andrew's latest set?

The whole latest patchset looks good to me.

Acked-by: Huang Ying <ying.huang@intel.com>

Best Regards,
Huang Ying


