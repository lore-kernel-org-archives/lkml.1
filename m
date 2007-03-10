Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbXCJD1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbXCJD1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 22:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbXCJD1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 22:27:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:55310 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbXCJD1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 22:27:41 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH][RFC] Make entire ACPI submenu dependent on PM.
Date: Fri, 9 Mar 2007 22:26:14 -0500
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
References: <Pine.LNX.4.64.0703041312490.5332@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0703041312490.5332@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703092226.14552.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is right, and I applied it.

On i386, it did what it should -- made the menus look better.

Testing x86_64 exposed a latent bug, however.
Since CONFIG_X86_64_ACPI_NUMA=y does a select on ACPI,
it is possible to config a kernel with PM=n
and ACPI=y, which violates ACPI's dependency on PM.

Basically, select of something that has dependencies doesn't
enforce those dependencies.

When will somebody re-write Kconfig into something that
humans can use?

-Len

On Sunday 04 March 2007 13:17, Robert P. J. Day wrote:
> 
>   Make the visibility of the entire ACPI submenu dependent on PM.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
>   given that de-selecting Power Management (PM) de-activates the
> entire contents of the ACPI submenu, it seems pointless to leave the
> top-level menu entry visible.  but this is just a hack and i'll leave
> it to the official maintainers to do it properly. :-)
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 7c49e10..3208ce0 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -7,6 +7,7 @@ menu "ACPI (Advanced Configuration and Power Interface) Support"
>  	depends on !X86_VISWS
>  	depends on !IA64_HP_SIM
>  	depends on IA64 || X86
> +	depends on PM
> 
>  config ACPI
>  	bool "ACPI Support"
> 
