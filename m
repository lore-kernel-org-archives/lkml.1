Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYICMWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYICMWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 08:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYICMWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 08:22:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:38976 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbYICMWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 08:22:15 -0400
Subject: Re: Blacklist DMAR on Intel G31/G33 chipsets
From: David Woodhouse <dwmw2@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org,
       "Sankaran, Rajesh" <rajesh.sankaran@intel.com>,
       "Bork, Jon" <jon.bork@intel.com>
In-Reply-To: <20080903120926.GR18288@one.firstfloor.org>
References: <20080902061920.GK18288@one.firstfloor.org>
	 <1220439231.2985.103.camel@pmac.infradead.org>
	 <20080903120926.GR18288@one.firstfloor.org>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 13:22:11 +0100
Message-Id: <1220444531.2985.124.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-03 at 14:09 +0200, Andi Kleen wrote:
> > @@ -114,6 +128,10 @@ static struct chipset early_qrk[] __initdata = {
> >  	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, via_bugs },
> >  	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB,
> >  	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, fix_hypertransport_config },
> > +#ifdef CONFIG_DMAR
> > +	{ PCI_VENDOR_ID_INTEL, 0x29c0,
> > +	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, intel_g33_dmar },
> > +#endif
> 
> Are you sure 0x29c0 is only used on the G31/G33?

And P35 and P31, but nothing with an IOMMU, I believe. The G35 is
8086:2980.

But still I'd be slightly happier using a DMI match on the only
_motherboard_ we've seen so far with this BIOS bug. We can easily add
new motherboards if it does show up elsewhere.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



