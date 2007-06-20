Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbXFTNqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbXFTNqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 09:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbXFTNql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 09:46:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:40954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbXFTNqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 09:46:40 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 7/12] acpi: fix another compile warning
Date: Wed, 20 Jun 2007 15:46:28 +0200
User-Agent: KMail/1.9.6
Cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Shai Fultheim <shai@scalex86.org>,
       Ravikiran Thirumalai <kiran@scalex86.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <20070619225035.GI5193@alberich.amd.com> <20070620084911.GO5193@alberich.amd.com> <200706200936.31236.lenb@kernel.org>
In-Reply-To: <200706200936.31236.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706201546.28457.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The underlying problem is that Kconfig doesn't support using select
> on targets which themselves have dependencies.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>

The depends on ACPI is fine by me, but I would prefer if the 
ACPI_NUMA dependency worked the other way round (APCI_NUMA default y
and depends on the relevant architecture specific symbols). That would
be more user friendly I think because all the NUMA options would
be in one place.

-Andi

> diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
> index 5ce9443..e9d7767 100644
> --- a/arch/x86_64/Kconfig
> +++ b/arch/x86_64/Kconfig
> @@ -364,9 +364,9 @@ config NODES_SHIFT
>  config X86_64_ACPI_NUMA
>         bool "ACPI NUMA detection"
>         depends on NUMA
> -       select ACPI 
> +       depends on ACPI 
>  	select PCI
> -       select ACPI_NUMA
> +       depends on ACPI_NUMA
>         default y
>         help
>  	 Enable ACPI SRAT based node topology detection.
> 


