Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbYJHTQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbYJHTQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbYJHTQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:16:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:16743 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbYJHTQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:16:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,379,1220252400"; 
   d="scan'208";a="448734370"
Date: Wed, 8 Oct 2008 12:16:09 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: David John <davidjon@xenontk.org>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "clemens@ladisch.de" <clemens@ladisch.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "vojtech@suse.cz" <vojtech@suse.cz>,
       "bob.picco@hp.com" <bob.picco@hp.com>
Subject: Re: [PATCH] HPET: Remove spurious HPET busy warning message.
Message-ID: <20081008191608.GA27806@linux-os.sc.intel.com>
References: <1223283140-8059-1-git-send-email-davidjon@xenontk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223283140-8059-1-git-send-email-davidjon@xenontk.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Yes. This printk is not adding much value and tend to get people confused
making them think that it is some sort of error. It will be good to get rid
of them.

Ingo: Can you pick this patch up into tip?

Thanks,
Venki

Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

On Mon, Oct 06, 2008 at 01:52:20AM -0700, David John wrote:
> On x86 systems with CONFIG_HPET_TIMER enabled
> and the HPET driver (drivers/char/hpet.c) compiled in,
> an incorrect busy message is printed when the driver
> initializes since the HPET has already been allocated
> by the core timer code. Remove the warning message.
> 
> Signed-off-by: David John <davidjon@xenontk.org>
> ---
>  drivers/char/hpet.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
> index b3f5dbc..454c13b 100644
> --- a/drivers/char/hpet.c
> +++ b/drivers/char/hpet.c
> @@ -874,8 +874,6 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
>                 hdp->hd_address = ioremap(addr.minimum, addr.address_length);
> 
>                 if (hpet_is_known(hdp)) {
> -                       printk(KERN_DEBUG "%s: 0x%lx is busy\n",
> -                               __func__, hdp->hd_phys_address);
>                         iounmap(hdp->hd_address);
>                         return AE_ALREADY_EXISTS;
>                 }
> @@ -891,8 +889,6 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
>                                                 HPET_RANGE_SIZE);
> 
>                 if (hpet_is_known(hdp)) {
> -                       printk(KERN_DEBUG "%s: 0x%lx is busy\n",
> -                               __func__, hdp->hd_phys_address);
>                         iounmap(hdp->hd_address);
>                         return AE_ALREADY_EXISTS;
>                 }
