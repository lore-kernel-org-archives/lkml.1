Return-Path: <linux-kernel-owner+w=401wt.eu-S1751576AbZISQ7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbZISQ7i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 12:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbZISQ7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 12:59:37 -0400
Received: from mga10.intel.com ([192.55.52.92]:39875 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751455AbZISQ7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 12:59:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,416,1249282800"; 
   d="scan'208";a="495026411"
Date: Sat, 19 Sep 2009 20:37:37 -0400
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: dwmw2@infradead.org, Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Song, Youquan" <youquan.song@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH] IR: Disallow interrupt remapping if not all ioapic under interrupt remapping
Message-ID: <20090920003737.GB21419@youquan-linux.bj.intel.com>
References: <20090907145807.GA30942@youquan-linux.bj.intel.com> <1252532575.2767.32.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252532575.2767.32.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 02:42:55PM -0700, Suresh Siddha wrote:
> On Mon, 2009-09-07 at 07:58 -0700, Song, Youquan wrote:
> > Current kernel enable interrupt remapping only when all the vt-d unit support
> > interrupt remapping. So it is reasonable we should also disallow enabling
> > intr-remapping if there any io-apics that are not listed under vt-d units. 
> > Otherwise we can run into issues.
> > 
> > Acked-by: Suresh Siddha <suresh.b.siddha@intel.com> 
> > Signed-off-by: Youquan Song <youquan.song@intel.com>
> > ---
> > 
> > diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
> > index 7b287cb..a8a4383 100644
> > --- a/drivers/pci/dmar.c
> > +++ b/drivers/pci/dmar.c
> > @@ -570,9 +570,6 @@ int __init dmar_table_init(void)
> >  		printk(KERN_INFO PREFIX "No ATSR found\n");
> >  #endif
> >  
> > -#ifdef CONFIG_INTR_REMAP
> > -	parse_ioapics_under_ir();
> > -#endif
> >  	return 0;
> >  }
> >  
> > diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
> > index 4f5b871..ebfa47b 100644
> > --- a/drivers/pci/intr_remapping.c
> > +++ b/drivers/pci/intr_remapping.c
> > @@ -626,6 +626,11 @@ int __init enable_intr_remapping(int eim)
> >  	struct dmar_drhd_unit *drhd;
> >  	int setup = 0;
> >  
> > +	if (parse_ioapics_under_ir() != 1) {
> > +		printk(KERN_INFO "Not enable interrupt remapping\n");
> > +		return -1;
> > +	}
> > +
> >  	for_each_drhd_unit(drhd) {
> >  		struct intel_iommu *iommu = drhd->iommu;
> >  
> 
> David, Can you also pick this up please?
> 
> thanks,
> suresh

Change the patch title to short one.
David, Couly you please also pick this up? Sorry, if you have done.

Thanks.


> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
