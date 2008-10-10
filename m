Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbYJJH1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbYJJH1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 03:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYJJH06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 03:26:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38874 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbYJJH05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 03:26:57 -0400
Date: Fri, 10 Oct 2008 09:26:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David John <davidjon@xenontk.org>
Cc: clemens@ladisch.de, venkatesh.pallipadi@intel.com, vojtech@suse.cz,
       bob.picco@hp.com, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] HPET: Remove spurious HPET busy warning message.
Message-ID: <20081010072640.GA16016@elte.hu>
References: <48EEF194.5010008@xenontk.org> <1223619164-16874-1-git-send-email-davidjon@xenontk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223619164-16874-1-git-send-email-davidjon@xenontk.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David John <davidjon@xenontk.org> wrote:

> On x86 systems with CONFIG_HPET_TIMER enabled, when
> the HPET driver (drivers/char/hpet.c) is loaded,
> an incorrect busy message is printed when the driver
> initializes since the HPET has already been allocated
> by the core timer code. Remove the warning message.
> 
> Signed-off-by: David John <davidjon@xenontk.org>
> Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> ---
>  drivers/char/hpet.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
> index b3f5dbc..454c13b 100644
> --- a/drivers/char/hpet.c
> +++ b/drivers/char/hpet.c
> @@ -874,8 +874,6 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
>  		hdp->hd_address = ioremap(addr.minimum, addr.address_length);
>  
>  		if (hpet_is_known(hdp)) {
> -			printk(KERN_DEBUG "%s: 0x%lx is busy\n",
> -				__func__, hdp->hd_phys_address);
>  			iounmap(hdp->hd_address);
>  			return AE_ALREADY_EXISTS;
>  		}
> @@ -891,8 +889,6 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
>  						HPET_RANGE_SIZE);
>  
>  		if (hpet_is_known(hdp)) {
> -			printk(KERN_DEBUG "%s: 0x%lx is busy\n",
> -				__func__, hdp->hd_phys_address);
>  			iounmap(hdp->hd_address);
>  			return AE_ALREADY_EXISTS;
>  		}

applied to tip/timers/hpet, thanks John!

	Ingo
