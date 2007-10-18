Return-Path: <linux-kernel-owner+w=401wt.eu-S933950AbXJRXwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933950AbXJRXwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 19:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758560AbXJRXwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 19:52:04 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:55417 "EHLO
	outbound4-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758028AbXJRXwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 19:52:01 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
Date: Thu, 18 Oct 2007 13:36:29 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Andres Salomon" <dilinger@queued.net>
cc: linux-kernel@vger.kernel.org, info-linux@geode.amd.com,
       "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: GEODE: use symbolic constant in cs5536 reboot fixup
Message-ID: <20071018193629.GA25591@cosmic.amd.com>
References: <20071018152651.4d218be9@ephemeral>
MIME-Version: 1.0
In-Reply-To: <20071018152651.4d218be9@ephemeral>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 18 Oct 2007 23:51:24.0981 (UTC)
 FILETIME=[CAEB9650:01C811E1]
X-WSS-ID: 6B092E0A0602334690-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/10/07 15:26 -0400, Andres Salomon wrote:
> Simple cosmetic update for the cs5536 reboot fixup; define the MSR that's used
> for rebooting in geode.h, and use the define.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>

Acked-by: Jordan Crouse <jordan.crouse@amd.com>

> diff --git a/arch/x86/kernel/reboot_fixups_32.c b/arch/x86/kernel/reboot_fixups_32.c
> index 8b30b26..1a07bbe 100644
> --- a/arch/x86/kernel/reboot_fixups_32.c
> +++ b/arch/x86/kernel/reboot_fixups_32.c
> @@ -12,6 +12,7 @@
>  #include <linux/interrupt.h>
>  #include <asm/reboot_fixups.h>
>  #include <asm/msr.h>
> +#include <asm/geode.h>
>  
>  static void cs5530a_warm_reset(struct pci_dev *dev)
>  {
> @@ -24,11 +25,8 @@ static void cs5530a_warm_reset(struct pci_dev *dev)
>  
>  static void cs5536_warm_reset(struct pci_dev *dev)
>  {
> -	/*
> -	 * 6.6.2.12 Soft Reset (DIVIL_SOFT_RESET)
> -	 * writing 1 to the LSB of this MSR causes a hard reset.
> -	 */
> -	wrmsrl(0x51400017, 1ULL);
> +	/* writing 1 to the LSB of this MSR causes a hard reset */
> +	wrmsrl(MSR_DIVIL_SOFT_RESET, 1ULL);
>  	udelay(50); /* shouldn't get here but be safe and spin a while */
>  }
>  
> diff --git a/include/asm-x86/geode.h b/include/asm-x86/geode.h
> index d948988..771af33 100644
> --- a/include/asm-x86/geode.h
> +++ b/include/asm-x86/geode.h
> @@ -38,6 +38,8 @@ extern int geode_get_dev_base(unsigned int dev);
>  #define MSR_LBAR_ACPI		0x5140000E
>  #define MSR_LBAR_PMS		0x5140000F
>  
> +#define MSR_DIVIL_SOFT_RESET	0x51400017
> +
>  #define MSR_PIC_YSEL_LOW	0x51400020
>  #define MSR_PIC_YSEL_HIGH	0x51400021
>  #define MSR_PIC_ZSEL_LOW	0x51400022
> 
> 

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


