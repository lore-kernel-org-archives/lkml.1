Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbZDRJQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbZDRJQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 05:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbZDRJQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 05:16:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35895 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbZDRJQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 05:16:38 -0400
Date: Sat, 18 Apr 2009 11:16:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] pci: don't printout if the bus res size is 0
Message-ID: <20090418091633.GN7678@elte.hu>
References: <49E992C2.4010707@kernel.org> <49E99355.6090609@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E99355.6090609@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> 
> also print out if it is prefetechable mmio
> 
> [Impact: cleanup]
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/setup-bus.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -558,11 +558,13 @@ static void pci_bus_dump_res(struct pci_
>  
>          for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
>                  struct resource *res = bus->resource[i];
> -                if (!res)
> +                if (!res || !res->end)
>                          continue;
>  
>  		dev_printk(KERN_DEBUG, &bus->dev, "resource %d %s %pR\n", i,
> -			   (res->flags & IORESOURCE_IO) ? "io: " : "mem:", res);
> +			   (res->flags & IORESOURCE_IO) ? "io: " :
> +			    ((res->flags & IORESOURCE_PREFETCH)? "pref mem":"mem:"),
> +			   res);

'pref mem' is easily mistaken for 'preferential memory' or something 
similar. Would printing "prefetchable-mem" still be OK?

	Ingo
