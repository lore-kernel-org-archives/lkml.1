Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbZBSDji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbZBSDji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 22:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZBSDj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 22:39:26 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:16808 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbZBSDjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 22:39:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=Npmp1M9fofCNDW1dj7GGD1IEez4tTecSitW7FqBr0lCStU/fe5GGopU4oMwa+FXDfY
         XAPoWrTAypqQLtMVlQ0Z66pDF4+uu3pz5/nB1SQuR4dx5JWZiiaLxV37/VIGLKvL7GsZ
         uxtLvq0cHwAulbWhGnH4v3/thC4vSXWzGkxcA=
Message-ID: <499CD466.1060900@gmail.com>
Date: Wed, 18 Feb 2009 21:39:18 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.pci,gmane.linux.kernel,gmane.linux.scsi
To: Yinghai Lu <yinghai@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       Matthew Wilcox <matthew@wil.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: enable MSI on 8132
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>  <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>  <20090217230050.GG16841@parisc-linux.org>  <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm> <86802c440902171511s1abcc0eao560df4b8fcea0e7c@mail.gmail.com> <alpine.DEB.1.10.0902171514120.26625@asgard.lang.hm> <499B46B2.5040601@kernel.org> <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm> <499B6BF7.9090300@kernel.org> <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm> <499B724A.2040408@kernel.org> <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm> <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm> <499B774C.5010705@kernel.org> <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm> <499B9129.50104@kernel.org>
In-Reply-To: <499B9129.50104@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Impact: workaround BIOS that doesn't enable that bit
> 
> David reported that LSI sas doesn't work with MSI.
> it turns out that BIOS doesn't enable HT MSI
> 8132 does support HT MSI.
> add quirk to enable it
> 
> Reported-by: David Lang <david@lang.hm>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/quirks.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/pci/quirks.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/quirks.c
> +++ linux-2.6/drivers/pci/quirks.c
> @@ -1981,7 +1981,6 @@ static void __devinit quirk_msi_ht_cap(s
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT2000_PCIE,
>  			quirk_msi_ht_cap);
>  
> -
>  /* The nVidia CK804 chipset may have 2 HT MSI mappings.
>   * MSI are supported if the MSI capability set in any of these mappings.
>   */
> @@ -2032,6 +2031,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_S
>  			 PCI_DEVICE_ID_SERVERWORKS_HT1000_PXB,
>  			 ht_enable_msi_mapping);
>  
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8132_BRIDGE,
> +			 ht_enable_msi_mapping);
> +

Is there a reason why we can't just enable the HT MSI mapping for any 
bridge device that has that PCI capability and is underneath an HT 
bridge? Essentially the code for nv_msi_ht_cap_quirk could potentially 
be applied to all bridges as it is currently for NVIDIA and ALi bridges..
