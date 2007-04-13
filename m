Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbXDMPpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbXDMPpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 11:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbXDMPpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 11:45:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:45324 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbXDMPpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 11:45:42 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Badari Pulavarty <pbadari@gmail.com>
Subject: Re: [PATCH] cache_k8_northbridges() overflows beyond allocation (Was: 2.6.21-rc5-mm4 (SLUB))
Date: Fri, 13 Apr 2007 17:45:37 +0200
User-Agent: KMail/1.9.6
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
References: <20070402224745.71a25af7.akpm@linux-foundation.org> <Pine.LNX.4.64.0704041103060.26866@schroedinger.engr.sgi.com> <1176477222.8559.4.camel@dyn9047017100.beaverton.ibm.com>
In-Reply-To: <1176477222.8559.4.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704131745.37795.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> cache_k8_northbridges() is storing config values to incorrect locations
> (in flush_words) and also its overflowing beyond the allocation, causing
> slab verification failures.

Oops. Thanks for tracking that down, Badari.

Andrew, clear .21 candidate.

-ANdi

> 
> Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
> ---
>  arch/x86_64/kernel/k8.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.21-rc6/arch/x86_64/kernel/k8.c
> ===================================================================
> --- linux-2.6.21-rc6.orig/arch/x86_64/kernel/k8.c	2007-04-05 19:36:56.000000000 -0700
> +++ linux-2.6.21-rc6/arch/x86_64/kernel/k8.c	2007-04-13 07:51:57.000000000 -0700
> @@ -61,8 +61,8 @@ int cache_k8_northbridges(void)
>  	dev = NULL;
>  	i = 0;
>  	while ((dev = next_k8_northbridge(dev)) != NULL) {
> -		k8_northbridges[i++] = dev;
> -		pci_read_config_dword(dev, 0x9c, &flush_words[i]);
> +		k8_northbridges[i] = dev;
> +		pci_read_config_dword(dev, 0x9c, &flush_words[i++]);
>  	}
>  	k8_northbridges[i] = NULL;
>  	return 0;
> 
> 
> 


