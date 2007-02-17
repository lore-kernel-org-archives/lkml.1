Return-Path: <linux-kernel-owner+w=401wt.eu-S1946380AbXBQDGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946380AbXBQDGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 22:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964882AbXBQDGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 22:06:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:36765 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964874AbXBQDF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 22:05:58 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: John Keller <jpk@sgi.com>
Subject: Re: [PATCH 1/1] -  acpi_boot_init() making bad check on return code
Date: Fri, 16 Feb 2007 22:04:38 -0500
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org, ayoung@sgi.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20070216210727.7407.93052.sendpatchset@attica.americas.sgi.com>
In-Reply-To: <20070216210727.7407.93052.sendpatchset@attica.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702162204.38607.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

thanks,
-Len
On Friday 16 February 2007 16:07, John Keller wrote:
> acpi_boot_init() is making a bad check on the return
> status from acpi_table_parse(). acpi_table_parse() now
> returns zero on success, one on failure.
> 
> Signed-off-by: Aaron Young <ayoung@sgi.com>
> ---
> 
> Index: release/arch/ia64/kernel/acpi.c
> ===================================================================
> --- release.orig/arch/ia64/kernel/acpi.c	2007-02-16 08:58:10.000000000 -0600
> +++ release/arch/ia64/kernel/acpi.c	2007-02-16 09:03:16.893360100 -0600
> @@ -651,7 +651,7 @@ int __init acpi_boot_init(void)
>  	 * information -- the successor to MPS tables.
>  	 */
>  
> -	if (acpi_table_parse(ACPI_SIG_MADT, acpi_parse_madt) < 1) {
> +	if (acpi_table_parse(ACPI_SIG_MADT, acpi_parse_madt)) {
>  		printk(KERN_ERR PREFIX "Can't find MADT\n");
>  		goto skip_madt;
>  	}
> @@ -702,7 +702,7 @@ int __init acpi_boot_init(void)
>  	 * gets interrupts such as power and sleep buttons.  If it's not
>  	 * on a Legacy interrupt, it needs to be setup.
>  	 */
> -	if (acpi_table_parse(ACPI_SIG_FADT, acpi_parse_fadt) < 1)
> +	if (acpi_table_parse(ACPI_SIG_FADT, acpi_parse_fadt))
>  		printk(KERN_ERR PREFIX "Can't find FADT\n");
>  
>  #ifdef CONFIG_SMP
> -
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
