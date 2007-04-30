Return-Path: <linux-kernel-owner+w=401wt.eu-S1946721AbXD3TZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946721AbXD3TZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946719AbXD3TZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:25:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:3021 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946717AbXD3TZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:25:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,471,1170662400"; 
   d="scan'208";a="236674416"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] support PCI MCFG space on Intel i915 bridges
Date: Mon, 30 Apr 2007 12:25:21 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <fa.aWIs6SNmpl2IhGAAoSWJu6oKjPo@ifi.uio.no> <46355007.5030807@shaw.ca>
In-Reply-To: <46355007.5030807@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704301225.22016.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 29, 2007 7:10 pm Robert Hancock wrote:
> Jesse Barnes wrote:
> > Add support for Intel 915 bridge chips to the new PCI MMConfig
> > detection code.  Tested and works on my sole 915 based platform (a
> > Toshiba laptop).  I added register masking per Oliver's suggestion,
> > and moved the __init qualifier to after the 'static const char' to
> > match Ogawa-san's recent cleanup patches.
> >
> > Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>
> >
> > diff --git a/arch/i386/pci/mmconfig-shared.c
> > b/arch/i386/pci/mmconfig-shared.c index 747d8c6..1339d31 100644
> > --- a/arch/i386/pci/mmconfig-shared.c
> > +++ b/arch/i386/pci/mmconfig-shared.c
> > @@ -72,6 +72,26 @@ static const char __init *pci_mmcfg_e7520(void)
> >  	return "Intel Corporation E7520 Memory Controller Hub";
> >  }
> >
> > +static const char __init *pci_mmcfg_intel_915(void)
> > +{
> > +       u32 pciexbar, len = 0;
> > +
> > +       pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0x48, 4, &pciexbar);
> > +
> > +       /* No enable bit or size field, so assume 256M range is
> > enabled. */ +       len = 0x10000000U;
>
> Check the 915 spec more carefully, there is an enable bit, it's in
> the DEVEN register offset 54h, the bit is called PCIEXBAREN (bit 31).
> If that is not set you should be setting pci_mmcfg_config_num to 0
> and bailing out.

Right, but you patch should obsolete this stuff anyway.  I'll test it 
out in the next few days.

Jesse
