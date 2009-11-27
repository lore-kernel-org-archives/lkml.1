Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbZK0Ck5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbZK0Ck5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 21:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbZK0Ck4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 21:40:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:45133 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbZK0Ckz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 21:40:55 -0500
Subject: Re: [PATCH 0/4] powerpc: Fix minor build issues on 2.6.32-rc7
 without CONFIG_XICS set
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091118170510.GA1119@csn.ul.ie>
References: <1258459659-11770-1-git-send-email-mel@csn.ul.ie>
	 <1258524332.2140.663.camel@pasglop>  <20091118170510.GA1119@csn.ul.ie>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Nov 2009 13:40:26 +1100
Message-ID: <1259289626.2076.1.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-18 at 17:05 +0000, Mel Gorman wrote:

> 
> diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
> index 04a8061..a82c470 100644
> --- a/arch/powerpc/platforms/Kconfig
> +++ b/arch/powerpc/platforms/Kconfig
> @@ -52,9 +52,9 @@ config PPC_UDBG_BEAT
>  	default n
>  
>  config XICS
> -	depends on PPC_PSERIES
> +	depends on PCI_MSI
>  	bool
> -	default y
> +	default n

Why the above ? XICS only exist on PSERIES and select bypass depends in
nasty ways anyways.

>  config IPIC
>  	bool
> diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
> index f0e6f28..81c2289 100644
> --- a/arch/powerpc/platforms/pseries/Kconfig
> +++ b/arch/powerpc/platforms/pseries/Kconfig
> @@ -5,6 +5,8 @@ config PPC_PSERIES
>  	select PPC_I8259
>  	select PPC_RTAS
>  	select RTAS_ERROR_LOGGING
> +	select PCI_MSI
> +	select XICS
>  	select PPC_UDBG_16550
>  	select PPC_NATIVE
>  	select PPC_PCI_CHOICE if EMBEDDED

The above bits look plenty enough. Can you also stick it next to the
MPIC one ?

Cheers,
Ben.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


