Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbXJXU4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbXJXU4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 16:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbXJXU4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 16:56:24 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:54118
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbXJXU4X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 16:56:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Miguel =?iso-8859-1?q?Bot=F3n?= <mboton.lkml@gmail.com>
Subject: Re: [PATCH 1/2] ssb: Add "ssb_pci_set_power_state" function
Date: Wed, 24 Oct 2007 22:55:39 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       linville@tuxdriver.com
References: <200710242131.21959.mboton.lkml@gmail.com>
In-Reply-To: <200710242131.21959.mboton.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710242255.39772.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2007 21:31:21 Miguel Botón wrote:
> Add "ssb_pci_set_power_state" function. This allows set the power state of a 
> PCI device (for example b44 ethernet device).
> 
> diff -ruN linux-2.6.23/include/linux/ssb/ssb.h 
> linux-2.6.23.orig/include/linux/ssb/ssb.h
> --- linux-2.6.23.orig/include/linux/ssb/ssb.h	2007-10-24 19:02:33.000000000 
> +0200
> +++ linux-2.6.23/include/linux/ssb/ssb.h	2007-10-24 19:49:37.000000000 +0200
> @@ -402,6 +402,14 @@
>  {
>  	pci_unregister_driver(driver);
>  }
> +
> +/* Set PCI device power state */
> +static inline
> +void ssb_pci_set_power_state(struct ssb_device *dev, pci_power_t state)
> +{
> +	if(dev->bus->bustype == SSB_BUSTYPE_PCI)
          ^
Coding style issue.

> +		pci_set_power_state(dev->bus->host_pci, state);
> +}
>  #endif /* CONFIG_SSB_PCIHOST */
>  

The rest is acked.

-- 
Greetings Michael.
