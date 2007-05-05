Return-Path: <linux-kernel-owner+w=401wt.eu-S934060AbXEERYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934060AbXEERYV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 13:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934072AbXEERYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 13:24:21 -0400
Received: from ns2.suse.de ([195.135.220.15]:49975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934060AbXEERYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 13:24:20 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: tglx@linutronix.de
Subject: Re: [PATCH] Blacklist Dell Optiplex 320 from using the HPET
Date: Sat, 5 May 2007 19:24:14 +0200
User-Agent: KMail/1.9.6
Cc: john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Guilherme M. Schroeder" <guilherme@centralinf.com.br>,
       lkml <linux-kernel@vger.kernel.org>
References: <1178314144.6094.7.camel@localhost.localdomain> <1178321228.6094.34.camel@localhost.localdomain> <1178375214.31213.13.camel@localhost.localdomain>
In-Reply-To: <1178375214.31213.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705051924.14258.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>  	if (!is_hpet_capable())
> @@ -278,6 +279,14 @@ int __init hpet_enable(void)
>  	/* Start the counter */
>  	hpet_start_counter();
>  
> +	/* Verify whether hpet counter works */
> +	t1 = hpet_read();
> +	udelay(50);

Are you sure udelay is calibrated at this point? I didn't think so.
In fact it needs the external clocks and it's a chicken and egg problem.

It might be safer to use a long loop with io port accesses or similar.

-Andi


> +	if (t1 == hpet_read()) {
> +		printk(KERN_WARNING "HPET counter is defect\n");
> +		goto out_nohpet;
> +	}
> +
>  	/* Initialize and register HPET clocksource
>  	 *
>  	 * hpet period is in femto seconds per cycle
> 
> 
> 


