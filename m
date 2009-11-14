Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632AbZKNAPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbZKNAPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757560AbZKNAPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:15:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49006 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757420AbZKNAPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:15:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/5] x86, sleep: always save the value of EFER
Date: Sat, 14 Nov 2009 01:16:21 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc7-rjw; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       x86@kernel.org, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@tuxonice.net>
References: <1258154897-6770-1-git-send-email-hpa@zytor.com> <1258154897-6770-3-git-send-email-hpa@zytor.com>
In-Reply-To: <1258154897-6770-3-git-send-email-hpa@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200911140116.21627.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 November 2009, H. Peter Anvin wrote:
> Always save the value of EFER, regardless of the state of NX.  Since
> EFER may not actually exist, use rdmsr_safe() to do so.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> Cc: Nigel Cunningham <nigel@tuxonice.net>
> ---
>  arch/x86/kernel/acpi/sleep.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
> index ca93638..c2e4455 100644
> --- a/arch/x86/kernel/acpi/sleep.c
> +++ b/arch/x86/kernel/acpi/sleep.c
> @@ -78,12 +78,9 @@ int acpi_save_state_mem(void)
>  #ifndef CONFIG_64BIT
>  	store_gdt((struct desc_ptr *)&header->pmode_gdt);
>  
> -	header->pmode_efer_low = nx_enabled;
> -	if (header->pmode_efer_low & 1) {
> -		/* This is strange, why not save efer, always? */
> -		rdmsr(MSR_EFER, header->pmode_efer_low,
> -			header->pmode_efer_high);
> -	}
> +	header->pmode_efer_low = header->pmode_efer_high = 0;
> +	rdmsr_safe(MSR_EFER,
> +		   &header->pmode_efer_low, &header->pmode_efer_high);
>  #endif /* !CONFIG_64BIT */
>  
>  	header->pmode_cr0 = read_cr0();
> 

