Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbZKCRFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbZKCRFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbZKCRFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:05:41 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:56791 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbZKCRFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:05:40 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19LoRub+Q4GiscArAHWCo4B
Date: Tue, 3 Nov 2009 09:05:40 -0800
From: Tony Lindgren <tony@atomide.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAP: Should cs be positive in gpmc_cs_free()?
Message-ID: <20091103170540.GH8981@atomide.com>
References: <4AED8A98.6040205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AED8A98.6040205@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roel Kluin <roel.kluin@gmail.com> [091101 05:07]:
> The index `cs' is signed, test whether it is negative before
> we release gpmc_cs_mem[cs].
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Found by code analysis, is it required?

Looks like a valid check to me.

Acked-by: Tony Lindgren <tony@atomide.com>

> 
> diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
> index 1587682..c892a54 100644
> --- a/arch/arm/mach-omap2/gpmc.c
> +++ b/arch/arm/mach-omap2/gpmc.c
> @@ -378,7 +378,7 @@ EXPORT_SYMBOL(gpmc_cs_request);
>  void gpmc_cs_free(int cs)
>  {
>  	spin_lock(&gpmc_mem_lock);
> -	if (cs >= GPMC_CS_NUM || !gpmc_cs_reserved(cs)) {
> +	if (cs >= GPMC_CS_NUM || cs < 0 || !gpmc_cs_reserved(cs)) {
>  		printk(KERN_ERR "Trying to free non-reserved GPMC CS%d\n", cs);
>  		BUG();
>  		spin_unlock(&gpmc_mem_lock);
