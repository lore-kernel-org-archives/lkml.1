Return-Path: <linux-kernel-owner+w=401wt.eu-S1759137AbXEMGof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbXEMGof (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 02:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758186AbXEMGo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 02:44:26 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757122AbXEMGoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 02:44:25 -0400
Date: Sat, 12 May 2007 23:44:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Reboot PATCH (ACPI related)
Message-Id: <20070512234413.54fc6afa.akpm@linux-foundation.org>
In-Reply-To: <20070512201006.GA3569@ics.muni.cz>
References: <20070512201006.GA3569@ics.muni.cz>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 May 2007 22:10:07 +0200 Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:

> why the attached patch is still not included in mainline kernel? It fixes boot
> problems after suspend to RAM.
> 
> -- 
> Lukáš Hejtmánek
> 
> 
> [reboot.patch  text/x-diff (564B)]
> --- arch/i386/kernel/reboot.c.old	2006-06-18 03:49:35.000000000 +0200
> +++ arch/i386/kernel/reboot.c	2006-07-01 17:29:23.000000000 +0200
> @@ -31,6 +31,12 @@
>  #ifdef CONFIG_SMP
>  static int reboot_cpu = -1;
>  #endif
> +#ifdef CONFIG_ACPI
> +extern u32 acpi_disable(void);
> +#else
> +static u32 acpi_disable(void){};
> +#endif
> +
>  static int __init reboot_setup(char *str)
>  {
>  	while(1) {
> @@ -322,6 +328,7 @@
>  
>  void machine_emergency_restart(void)
>  {
> +	acpi_disable();
>  	if (!reboot_thru_bios) {
>  		if (efi_enabled) {
>  			efi.reset_system(EFI_RESET_COLD, EFI_SUCCESS, 0, NULL);

We'd prefer to fix the problem, whatever it is, rather than just turning
APCI off.

Please ensure that a full bug report has been entered at bugzilla.kernel.org,
thanks.
