Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbXGXPbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbXGXPbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbXGXPbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:31:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:49607 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbXGXPbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:31:02 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] ACPI: Remove references to ACPI_STATE_S2 from acpi_pm_enter
Date: Tue, 24 Jul 2007 11:30:34 -0400
User-Agent: KMail/1.9.5
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <200707241158.40282.rjw@sisk.pl>
In-Reply-To: <200707241158.40282.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707241130.35323.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2007 05:58, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Remove references to ACPI_STATE_S2, introduced by
> acpi-implement-the-set_target-callback-from-pm_ops.patch, from acpi_pm_enter().
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 

per SubmittingPatches, please try to remember to follow the comments
and preceed the diffstat with a line having just '---'

Applied.
thanks Rafael,
-Len

>  drivers/acpi/sleep/main.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6.23-rc1/drivers/acpi/sleep/main.c
> ===================================================================
> --- linux-2.6.23-rc1.orig/drivers/acpi/sleep/main.c	2007-07-23 22:28:36.000000000 +0200
> +++ linux-2.6.23-rc1/drivers/acpi/sleep/main.c	2007-07-24 11:38:46.000000000 +0200
> @@ -80,8 +80,8 @@ static int acpi_pm_prepare(void)
>   *	acpi_pm_enter - Actually enter a sleep state.
>   *	@pm_state: ignored
>   *
> - *	Flush caches and go to sleep. For STR or S2, we have to call
> - *	arch-specific assembly, which in turn call acpi_enter_sleep_state().
> + *	Flush caches and go to sleep. For STR we have to call arch-specific
> + *	assembly, which in turn call acpi_enter_sleep_state().
>   *	It's unfortunate, but it works. Please fix if you're feeling frisky.
>   */
>  
> @@ -94,7 +94,7 @@ static int acpi_pm_enter(suspend_state_t
>  	ACPI_FLUSH_CPU_CACHE();
>  
>  	/* Do arch specific saving of state. */
> -	if (acpi_state == ACPI_STATE_S2 || acpi_state == ACPI_STATE_S3) {
> +	if (acpi_state == ACPI_STATE_S3) {
>  		int error = acpi_save_state_mem();
>  
>  		if (error) {
> @@ -111,7 +111,6 @@ static int acpi_pm_enter(suspend_state_t
>  		status = acpi_enter_sleep_state(acpi_state);
>  		break;
>  
> -	case ACPI_STATE_S2:
>  	case ACPI_STATE_S3:
>  		do_suspend_lowlevel();
>  		break;
> @@ -135,7 +134,7 @@ static int acpi_pm_enter(suspend_state_t
>  	printk(KERN_DEBUG "Back to C!\n");
>  
>  	/* restore processor state */
> -	if (acpi_state == ACPI_STATE_S2 || acpi_state == ACPI_STATE_S3)
> +	if (acpi_state == ACPI_STATE_S3)
>  		acpi_restore_state_mem();
>  
>  	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
