Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbZCAION@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbZCAION (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 03:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbZCAIOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 03:14:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:59087 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbZCAIN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 03:13:59 -0500
Message-ID: <49AA4389.8010605@kernel.org>
Date: Sun, 01 Mar 2009 00:12:57 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Prakash Punnoor <prakash@punnoor.de>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       Matthew Wilcox <matthew@wil.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: don't enable too many HT MSI mapping
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <86802c440902281443g4638dbcby463864df911a50ba@mail.gmail.com> <200903010850.53031.prakash@punnoor.de> <200903010858.05758.prakash@punnoor.de>
In-Reply-To: <200903010858.05758.prakash@punnoor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prakash Punnoor wrote:
> [PATCH] Enable HT MSI mapping on all known needed NVidia host bridges
> 
> v3 of Yinghai Lu's work only enables HT MSI mapping for one specific host bridge.
> Do this also for all known needed ones as specified by NVidia's original patch.
> 
> Signed-off-by: Prakash Punnoor <prakash@punnoor.de>
> 
> --- drivers/pci/quirks.c.current	2009-03-01 08:42:31.321660493 +0100
> +++ drivers/pci/quirks.c	2009-03-01 08:47:47.267657376 +0100
> @@ -2189,8 +2189,20 @@
>  	return __nv_msi_ht_cap_quirk(dev, 0);
>  }
>  
> -/* werid?, c51/mcp51 need c51 ht msi to be enable to make mcp51 ht msi working */
> +/* Enable HT MSI mapping on following host brigdes */
> +/* C51 host bridges */
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x02f0, nv_msi_ht_cap_quirk_all);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x02f1, nv_msi_ht_cap_quirk_all);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x02f2, nv_msi_ht_cap_quirk_all);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x02f3, nv_msi_ht_cap_quirk_all);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x02f4, nv_msi_ht_cap_quirk_all);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x02f5, nv_msi_ht_cap_quirk_all);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x02f6, nv_msi_ht_cap_quirk_all);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x02f7, nv_msi_ht_cap_quirk_all);
> +/* MCP55 host bridge */
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x0369, nv_msi_ht_cap_quirk_all);
we may not need this one.
mcp55 is some kind of mcp51 equivent, so we dont't HT MSI for 0x0369

YH

> +
> +/* Enable MSI mapping on all regular devices */
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, nv_msi_ht_cap_quirk_leaf);
>  
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, PCI_ANY_ID, nv_msi_ht_cap_quirk_all);

