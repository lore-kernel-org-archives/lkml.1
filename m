Return-Path: <linux-kernel-owner+w=401wt.eu-S1751846Ab0ATP46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab0ATP46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322Ab0ATP44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:56:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559Ab0ATP4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:56:55 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Marti Raudsepp <marti@juffo.org>
Subject: Re: [PATCH] powernow-k8: On load failure, remind the user to enable support in BIOS setup
Date: Wed, 20 Jan 2010 16:56:51 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32.1-0.0.14.f17927a-desktop; KDE/4.3.1; x86_64; ; )
Cc: cpufreq@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       linux-kernel@vger.kernel.org
References: <160211accaba09e778c6.1264001606@newn>
In-Reply-To: <160211accaba09e778c6.1264001606@newn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001201656.51376.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 January 2010 16:33:26 Marti Raudsepp wrote:
>  arch/x86/kernel/cpu/cpufreq/powernow-k8.c |  15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> 
> In most cases this is simply user error or bad BIOS defaults, rather
> than a firmware problem.

Not acknowledged.
Bad BIOS defaults is a firmware problem.

But most often this happens if people upgrade their CPU and do not 
update their BIOS.
Or the vendor does not recognise the new CPU even if the BIOS got 
updated.

The itself message might be an enhancment, IMO it's not worth a patch.
But do not revert the FW_BUG part!

People complain to lkml or to the cpufreq list that cpufreq does not 
work. The [Firmware Bug] (FW_BUG) already reminds them to do following 
steps:
  - Read up the BIOS setting description
  - Update the BIOS
  - If it still does not work complain to the vendor

Also this string gets picked up by the linuxfirmwarekit and it could not 
detect anymore that the BIOS does not export cpufreq tables which is 
very often *not* a wrong BIOS default, in which case the message is 
misleading.

   Thomas

> Signed-off-by: Marti Raudsepp <marti@juffo.org>
> 
> diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c 
b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> --- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> +++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> @@ -789,17 +789,20 @@
>  				(struct pst_s *)(psb+1), maxvid);
>  	}
>  	/*
> -	 * If you see this message, complain to BIOS manufacturer. If
> -	 * he tells you "we do not support Linux" or some similar
> -	 * nonsense, remember that Windows 2000 uses the same legacy
> -	 * mechanism that the old Linux PSB driver uses. Tell them it
> -	 * is broken with Windows 2000.
> +	 * If you see this message, check that Cool'N'Quiet is enabled
> +	 * in your BIOS setup. If that fails, complain to your BIOS
> +	 * manufacturer. If he tells you "we do not support Linux" or
> +	 * some similar nonsense, remember that Windows 2000 uses the
> +	 * same legacy mechanism that the old Linux PSB driver uses.
> +	 * Tell them it is broken with Windows 2000.
>  	 *
>  	 * The reference to the AMD documentation is chapter 9 in the
>  	 * BIOS and Kernel Developer's Guide, which is available on
>  	 * www.amd.com
>  	 */
> -	printk(KERN_ERR FW_BUG PFX "No PSB or ACPI _PSS objects\n");
> +	printk(KERN_ERR PFX "No PSB or ACPI _PSS objects\n");
> +	printk(KERN_ERR PFX "Make sure that Cool'N'Quiet support is "
> +		"enabled in your BIOS setup\n");
>  	return -ENODEV;
>  }
>  
> 

