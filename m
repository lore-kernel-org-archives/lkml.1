Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbZIIXoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbZIIXoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbZIIXoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:44:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:6771 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbZIIXon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:44:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,360,1249282800"; 
   d="scan'208";a="492051664"
From: "Song, Youquan" <youquan.song@intel.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>
Date: Thu, 10 Sep 2009 07:44:41 +0800
Subject: RE: [PATCH] interrupt remapping: Disallow interrupt remapping if
 not all ioapic under interrupt remapping
Thread-Topic: [PATCH] interrupt remapping: Disallow interrupt remapping if
 not all ioapic under interrupt remapping
Thread-Index: Acoxlpmit6ZfdjkaQwWQoGp9pteb+QAENCCw
Message-ID: <0A882F4D99BBF6449D58E61AAFD7EDD6323CC996@pdsmsx502.ccr.corp.intel.com>
In-Reply-To: <1252532575.2767.32.camel@sbs-t61.sc.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n89Nix16005646


This patch also is promising to go to 2.6.32.

Thanks & Regards, 
Song Youquan 
Intel SSG/SSD/OTC 
MOB: 13681289076 
TEL: 010-82171326 
INET: 8-758-1326 
LOC: Raycom 5W027


 

> -----Original Message-----
> From: Siddha, Suresh B 
> Sent: 2009Äê9ÔÂ10ÈÕ 5:43
> To: Song, Youquan
> Cc: mingo@elte.hu; hpa@zytor.com; tglx@linutronix.de; 
> linux-kernel@vger.kernel.org; dwmw2@infradead.org
> Subject: Re: [PATCH] interrupt remapping: Disallow interrupt 
> remapping if not all ioapic under interrupt remapping
> 
> On Mon, 2009-09-07 at 07:58 -0700, Song, Youquan wrote:
> > Current kernel enable interrupt remapping only when all the 
> vt-d unit support
> > interrupt remapping. So it is reasonable we should also 
> disallow enabling
> > intr-remapping if there any io-apics that are not listed 
> under vt-d units. 
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
> > diff --git a/drivers/pci/intr_remapping.c 
> b/drivers/pci/intr_remapping.c
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
> 
> ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
