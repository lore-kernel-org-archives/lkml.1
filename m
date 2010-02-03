Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab0BCQVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:21:08 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:53933 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502Ab0BCQVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:21:05 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [BUG] agpgart-amd64 not initialized in 2.6.33-rc5 if iommu=allowed in kernel command line
Date: Wed, 3 Feb 2010 18:18:47 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.33-rc6; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, davej@redhat.com
References: <20100125141006O.fujita.tomonori@lab.ntt.co.jp> <20100202202328O.fujita.tomonori@lab.ntt.co.jp> <20100203004905T.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100203004905T.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002031818.47665.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 February 2010 05:49:20 pm FUJITA Tomonori wrote:

> Duh, sorry, please this instead:

Applies cleanly to 2.6.33-rc6-git3. Works for me.
Details - see my previous post..

Thanks.

Marin Mitov

> 
> diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
> index 34cf04e..fd50ead 100644
> --- a/drivers/char/agp/amd64-agp.c
> +++ b/drivers/char/agp/amd64-agp.c
> @@ -767,16 +767,19 @@ int __init agp_amd64_init(void)
>  
>  static int __init agp_amd64_mod_init(void)
>  {
> +#ifndef MODULE
>  	if (gart_iommu_aperture)
>  		return agp_bridges_found ? 0 : -ENODEV;
> -
> +#endif
>  	return agp_amd64_init();
>  }
>  
>  static void __exit agp_amd64_cleanup(void)
>  {
> +#ifndef MODULE
>  	if (gart_iommu_aperture)
>  		return;
> +#endif
>  	if (aperture_resource)
>  		release_resource(aperture_resource);
>  	pci_unregister_driver(&agp_amd64_pci_driver);
> 
