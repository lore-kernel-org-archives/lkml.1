Return-Path: <linux-kernel-owner+w=401wt.eu-S1758031AbYGRNDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbYGRNDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 09:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbYGRNCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 09:02:55 -0400
Received: from relay1.sgi.com ([192.48.171.29]:60761 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751465AbYGRNCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 09:02:54 -0400
From: John Keller <jpk@sgi.com>
Message-Id: <200807181302.m6ID2nCX447826@fcbayern.americas.sgi.com>
Subject: Re: [PATCH] x86: Allow MMCONFIG above 4GB on x86_64
To: mingo@elte.hu (Ingo Molnar)
Date: Fri, 18 Jul 2008 08:02:48 -0500 (CDT)
Cc: jpk@sgi.com (John Keller), linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, takayoshi.kochi@gmail.com,
       yhlu.kernel@gmail.com (Yinghai Lu),
       jbarnes@virtuousgeek.org (Jesse Barnes)
In-Reply-To: <20080718123858.GR6875@elte.hu> from "Ingo Molnar" at Jul 18, 2008 02:38:58 PM
X-Mailer: ELM [version 2.5 PL2]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 
> * John Keller <jpk@sgi.com> wrote:
> 
> > SGI UV will have MMCFG base addresses that are greater than 4GB (32 
> > bits).
> 
> > +++ linux-2.6/arch/x86/kernel/acpi/boot.c	2008-07-09 15:25:32.000000000 -0500
> > @@ -200,6 +200,7 @@ int __init acpi_parse_mcfg(struct acpi_t
> >  	}
> >  
> >  	memcpy(pci_mmcfg_config, &mcfg[1], config_size);
> > +#ifndef CONFIG_X86_64
> >  	for (i = 0; i < pci_mmcfg_config_num; ++i) {
> >  		if (pci_mmcfg_config[i].address > 0xFFFFFFFF) {
> >  			printk(KERN_ERR PREFIX
> > @@ -209,6 +210,7 @@ int __init acpi_parse_mcfg(struct acpi_t
> >  			return -ENODEV;
> >  		}
> >  	}
> > +#endif
> 
> hm. If then it should be enabled very carefully and initially probably 
> on a per system (i.e. DMI driven whitelist) basis.
> 
> 	Ingo

I've also posted a revised patch that is platform specific.

http://marc.info/?l=linux-acpi&m=121615159014404&w=2

John
