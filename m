Return-Path: <linux-kernel-owner+w=401wt.eu-S1751691AbXDKJbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbXDKJbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbXDKJbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:31:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:59839 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbXDKJbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:31:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m0JSSaHULR1zPewdEbY2NZ3ff2GYg6FoCOMryaVrk+xLRJSj3kNXwP87iNas3bKM1oULY/Dlgvcm/D+/byhGZrrpZEhBGopVmdjOsfaBt6R08C0pa0+Yi+qCDodaKNUs4Xv+L26qB2u56xVlK8sCtJgWu3QC9Q38aV5P7Dn63Jg=
Message-ID: <21d7e9970704110231x6d434152n6091f9acf477ffc7@mail.gmail.com>
Date: Wed, 11 Apr 2007 19:31:10 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 3/7] DRM: correct PCI domain setting for ALPHA
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Henderson" <rth@twiddle.net>,
       "Jay Estabrook" <jay.estabrook@hp.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070411122911.D17547@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070411122911.D17547@jurassic.park.msu.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NAK

I already have this queued in the DRM git tree.. Ivan, Jay can you
check an -mm kernel contains it? it'll go in the next merge window..

Dave.

On 4/11/07, Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:
> Files:
>
> drivers/char/drm/drmP.h
>
>         The PCI domain is the hose's index, not the hose's root bus number.
>         Note that this code only applies to ALPHA.
>
>
> Signed-off-by: Jay Estabrook <jay.estabrook@hp.com>
> Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
>
> ---
>
> diff -Naurp a/drivers/char/drm/drmP.h b/drivers/char/drm/drmP.h
> --- a/drivers/char/drm/drmP.h   2007-04-02 13:03:24.000000000 -0400
> +++ b/drivers/char/drm/drmP.h   2007-04-02 13:49:38.000000000 -0400
> @@ -764,7 +764,7 @@ static __inline__ int drm_core_check_fea
>  }
>
>  #ifdef __alpha__
> -#define drm_get_pci_domain(dev) dev->hose->bus->number
> +#define drm_get_pci_domain(dev) dev->hose->index
>  #else
>  #define drm_get_pci_domain(dev) 0
>  #endif
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
